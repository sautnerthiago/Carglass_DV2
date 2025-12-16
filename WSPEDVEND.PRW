//Bibliotecas
#Include "Totvs.ch"
#Include "RESTFul.ch"
#Include "TopConn.ch"
#Include 'Protheus.ch'
#INCLUDE 'APWEBSRV.CH'
#INCLUDE "TBICONN.CH"


/*/{Protheus.doc} WSRESTFUL WSPEDVEND
MONTAGEM PEDIDO DE VENDAS
@author JOSE EDILSON DE LIMA PINTO
@since 19/05/2025
@version 1.0
@type wsrestful
/*/

WSSTRUCT ITEMPV

	WSDATA nitem as INTEGER
	WSDATA cCodProd as String
	WSDATA cDescProd as String
	WSDATA nQuant as Float

ENDWSSTRUCT

WSRESTFUL WSPEDVEND DESCRIPTION 'PEDIDO DE VENDAS'
    //Atributos
    WSDATA NUMPV       AS STRING
    WSDATA solicitante AS STRING
    WSDATA emissao     AS STRING
    WSDATA item        AS ITEMPV

	WSDATA page AS INTEGER OPTIONAL
	WSDATA pageSize AS INTEGER OPTIONAL
	WSDATA searchKey AS STRING OPTIONAL

	//Métodos
	WSMETHOD GET PDV DESCRIPTION "Retorna lista de Pedidos de Vendas" WSSYNTAX "/WSPEDVEND/pdvs " PATH '/WSPEDVEND/pdvs' PRODUCES APPLICATION_JSON
 
    //Métodos
    WSMETHOD GET ID      DESCRIPTION 'Retorna o registro pesquisado'                WSSYNTAX '/WSPEDVEND/{NUMPV}'          PATH '{NUMPV}'       PRODUCES APPLICATION_JSON
	WSMETHOD GET INTEGRA DESCRIPTION 'Retorna o registro pesquisado - INTEGRADO'   	WSSYNTAX '/WSPEDVEND/integrado' 	   PATH '/integrado'  	PRODUCES APPLICATION_JSON

    WSMETHOD POST   NEW    DESCRIPTION 'Inclusão de registro'          WSSYNTAX '/WSPEDVEND/new'                      PATH 'new'           PRODUCES APPLICATION_JSON
    WSMETHOD PUT    UPDATE DESCRIPTION 'Atualização de registro'       WSSYNTAX '/WSPEDVEND/update'                   PATH 'update'        PRODUCES APPLICATION_JSON
    WSMETHOD PUT    ERASE  DESCRIPTION 'Blaqueio de registro'          WSSYNTAX '/WSPEDVEND/delete'                   PATH 'delete'        PRODUCES APPLICATION_JSON
END WSRESTFUL

/*/{Protheus.doc} WSMETHOD GET ID
Busca registro via ID
@author JOSE EDILSON DE LIMA PINTO
@since 19/05/2025
/*/

WSMETHOD GET ID WSRECEIVE NUMPV WSSERVICE WSPEDVEND
    Local lRet       := .T.
    Local jResponse  := JsonObject():New()
    Local cAliasWS   := 'SC5'
    Local NUMPV		 := self:aUrlParms[1]

    Local cAlSC5     := GetNextAlias()

	oWS    := LIBGLASS():new()

    //Se o id estiver vazio
    If Empty(NUMPV)
        //SetRestFault(500, 'Falha ao consultar o registro') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
        Self:setStatus(500) 
        jResponse['errorId']  := 'ID001'
        jResponse['error']    := 'ID vazio'
        jResponse['solution'] := 'Informe o ID'
    Else
        DbSelectArea(cAliasWS)
        (cAliasWS)->(DbSetOrder(1))

        //Se não encontrar o registro
        If !(cAliasWS)->(MsSeek(FWxFilial(cAliasWS) + NUMPV))
            //SetRestFault(500, 'Falha ao consultar ID') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
            Self:setStatus(500) 
            jResponse['errorId']  := 'ID002'
            jResponse['error']    := 'PD ('+NUMPV+') não encontrado'
            jResponse['solution'] := 'Código PD não encontrado na tabela ' + cAliasWS
        Else

            cQuery := " SELECT * "
            cQuery += " FROM "+RetSQLName("SC5") + " AS SC5 WITH (NOLOCK) "
            cQuery += " WHERE C5_FILIAL = '" + FWxFilial(cAliasWS) + "' AND SC5.C5_NUM = '"+NUMPV+"' "
            cQuery += " AND SC5.D_E_L_E_T_ = '' "
            //cAlSC5:= CriaTrab(Nil,.F.)
            DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSC5, .F., .T.)    
                   
            DO WHILE !((cAlSC5)->(EOF())) .AND. (cAlSC5)->C5_NUM == NUMPV
                    jResponse['NUMPV']          := (cAlSC5)->C5_NUM
                    jResponse['EMISSAO']        := StoD((cAlSC5)->C5_EMISSAO)
                    jResponse['CLIENTE']        := (cAlSC5)->C5_CLIENTE
                    jResponse['LOJA']           := (cAlSC5)->C5_LOJACLI
                    jResponse['LOJAENTREGA']    := (cAlSC5)->C5_LOJAENT
                    jResponse['COND']           := (cAlSC5)->C5_CONDPAG
                    jResponse['INTEGRADO']	    := (cAlSC5)->C5_ZINTEGR
                    jResponse['NATUREZA']  	    := Rtrim((cAlSC5)->C5_NATUREZ)
                    jResponse['NOTA']  	        := Rtrim((cAlSC5)->C5_NOTA)
                    jResponse['SERIE'] 	        := Rtrim((cAlSC5)->C5_SERIE)
                    jResponse['ITENS']          := oWS:ITENSPV((cAlSC5)->C5_FILIAL, (cAlSC5)->C5_NUM, (cAlSC5)->C5_CLIENTE, (cAlSC5)->C5_LOJACLI )
                    (cAlSC5)->(DBSKIP())
                    LOOP
            ENDDO
            (cAlSC5)->(DBCLOSEAREA())
        EndIf
    EndIf

    //Define o retorno
    Self:SetContentType('application/json')
    Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
Return lRet

WSMETHOD GET INTEGRA WSRECEIVE WSSERVICE WSPEDVEND
	Local lRet       := .T.
	Local jResponse  := JsonObject():New()

	oWS    := LIBGLASS():new()
	cJsonNfs:= FwJsonSerialize( oWS:Integrado( "SC5", "" )  )			

    If Empty(cJsonNfs) 
		Self:setStatus(500)
		jResponse['errorId']  := 'Tipo016'
		jResponse['error']    := 'Não ha dados a serem integrados'
		jResponse['solution'] := 'Não ha dados a Integrar'

		cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
		oWS:GRAVALOGMURO(cResponc, cJason, "WSPEDVEND", "NAO HA DADOS A SEREM INTEGRADOS")
	Else
    	//Define o retorno
		Self:SetContentType('application/json')
		Self:SetResponse(cJsonNfs)
	ENDIF	

Return lRet

WSMETHOD POST NEW WSRECEIVE NUMPV WSSERVICE WSPEDVEND
    Local lRet              := .T.
    Local jJson             := Nil
    Local cJson             := Self:GetContent()
    Local cError            := ''
    Local nLinha            := 0
    Local cDirLog           := '\x_logs\'
    Local cArqLog           := ''
    Local cErrorLog         := ''
    Local aLogAuto          := {}
    Local jResponse         := JsonObject():New()

	Local cJason			:= ""
	Local cResponc          := ""
    Local nX
    Local aItens            := {}
    Local aCab              := {}
    
    Local _cCusto           := ""
    //Local aClient           := {}

    Local nTotal            := 0
    Local cSinistr          := ""

    Local cIdUiv            := ""

    Local nCount            
    Local cCCont            := "" //23/10/2025 - inclusãodacontacontábil

    Local cLogErro          := ""
    
    Private lMsErroAuto     := .F.
    Private lMsHelpAuto     := .T.
    Private lAutoErrNoFile  := .T.

	oWS    := LIBGLASS():new()
    
    //Se não existir a pasta de logs, cria
    IF ! ExistDir(cDirLog)
        MakeDir(cDirLog)
    EndIF    

    //Definindo o conteúdo como JSON, e pegando o content e dando um parse para ver se a estrutura está ok
    Self:SetContentType('application/json')
    jJson  := JsonObject():New()
    cError := jJson:FromJson(cJson)
	cJason := cJson
    lTemPr := .T.

    cEmpAt1 := cEmpAnt
    cFilAt1 := cFilAnt

    cEmpAt   := Iif(EMPTY(jJson:GetJsonObject("GRUPO") ), "01", jJson:GetJsonObject("GRUPO" ))
    cFilAt   := Iif(EMPTY(jJson:GetJsonObject("FILIAL")), "01", jJson:GetJsonObject("FILIAL"))

    Do While .T.
        rpcClearEnv()
        if RPCSetEnv(cEmpAt, cFilAt) //RPCSetEnv('02','01')       
            EXIT            
        ENDIF
    EndDo

    if !(empty(cError)) 
		Self:setStatus(500)
		jResponse['errorId']  := 'NEW0000'
		jResponse['error']    := 'ERRO NO JSON'
        jResponse['errorLog'] := cError
		jResponse['solution'] := 'ANALISE A INFORMACAO DE ENVIO'
        
        Self:SetContentType('application/json')
        Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
        Return 
    ENDIF

    FOR NX := 1 TO LEN(jJson:GetJsonObject("ITENS"))
	    _cod   := jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("PRODUTO")
        lTemPr := oWS:temProd(FWxFilial("SB1"), _cod) 
    Next
 
    _Cli    := jJson:GetJsonObject("CLIENTE")
    _lojCli := if (Empty(jJson:GetJsonObject("LOJA")),"01", jJson:GetJsonObject("LOJA"))
    _TpCli  := ows:PGtIPcLI(_Cli, _lojCli) 

    lTemCLi := ows:temCliCod(FWxFilial("SA1"), _Cli, _lojCli)

    cIdUiv  := jJson:GetJsonObject("IDPEDCOMPREXT") + jJson:GetJsonObject("EXTERNID")  //14/10/2025 - inclusão depois de reunião com MP, George e Rodrigo - composição o Externi mais o Enum
    aDadPDV := oWs:PGExtPDV( cIdUiv ) //jJson:GetJsonObject("NUMPV") 

    //26/09/2025 - incluido para identificar o eero 500
    If len(aDadPDV) > 0
		Self:setStatus(506)
		jResponse['errorId']  := 'NEW0016'
		jResponse['error']    := 'EXTERNOID'
        jResponse['errorLog'] := "PEDIDO JA ENVIADO ANTERIORMENTE"
		jResponse['solution'] := 'MANDE UM PEDIDO NOVO'

		cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
		oWS:GRAVALOGMURO(cResponc, cJason, "WSPEDVEND", "INCLUSAO DE PEDIDO DE VENDAS - EXTERNAID")
        
        Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
        Return .F.
    Endif

    IF !Empty(oWs:PGExtrtV( cIdUiv )) //jJson:GetJsonObject("EXTERNID") ))
		Self:setStatus(506)
		jResponse['errorId']  := 'NEW0016'
		jResponse['error']    := 'EXTERNOID'
        jResponse['errorLog'] := "PEDIDO JA ENVIADO ANTERIORMENTE"
		jResponse['solution'] := 'MANDE UM PEDIDO NOVO'

		cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
		oWS:GRAVALOGMURO(cResponc, cJason, "WSPEDVEND", "INCLUSAO DE PEDIDO DE VENDAS - EXTERNAID")
        
        Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
        Return .F.

    Endif

	IF !lTemPr 
		Self:setStatus(500)
		jResponse['errorId']  := 'NEW0006'
		jResponse['error']    := 'PRODUTO NÃO EXISTE'
        jResponse['errorLog'] := cErrorLog
		jResponse['solution'] := 'CADASTRE UM PRODUTO QUE DESEJA PEDIR'

		cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
		oWS:GRAVALOGMURO(cResponc, cJason, "WSPEDVEND", "INCLUSAO DE PEDIDO DE VENDAS")

        Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
        Return .F.
        
	EndIF
    
    //VALIDAÇÃO DO CLIENTE PELO cnpj
        //aClient := oWS:pgClient(jJson:GetJsonObject("CNPJ"))  //16/07/2025 - inclusão do CNPJ
        //if len(aClient) > 0
        //    _Cli    := aClient[1,1] //jJson:GetJsonObject("CLIENTE")
        //    _lojCli := aClient[1,2] //jJson:GetJsonObject("LOJA")

        //    lTemCLi := ows:temCliCod(FWxFilial("SA1"), _Cli, _lojCli)
        //else
        //    lTemCLi := .F.
        //endif
    //VALIDAÇÃO DO CLIENTE PELO cnpj

	IF !lTemCLi 
		Self:setStatus(500)
		jResponse['errorId']  := 'NEW0044'
		jResponse['error']    := 'CLIENTE NÃO EXISTE'
        jResponse['errorLog'] := cErrorLog
		jResponse['solution'] := 'CADASTRE UM CLIENTE QUE DESEJA VENDER'

		cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
		oWS:GRAVALOGMURO(cResponc, cJason, "WSPEDVEND", "INCLUSAO DE PEDIDO DE VENDAS")

        Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
        Return .F.
        
	EndIF
 
    //Se tiver algum erro no Parse, encerra a execução
    IF !Empty(cError)
        Self:setStatus(500) 
        jResponse['errorId']  := 'NEW004'
        jResponse['error']    := 'Parse do JSON'
        jResponse['errorLog'] := cErrorLog
        jResponse['solution'] := 'Erro ao fazer o Parse do JSON'

		cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
		oWS:GRAVALOGMURO(cResponc, cJason, "WSPEDVEND", "INCLUSÃO DE PEDIDO DE VENDAS")

        Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
        Return .F.

    Else		
      
        if EMPTY( jJson:GetJsonObject("IDPEDCOMPREXT") ) .OR. EMPTY(jJson:GetJsonObject("EXTERNID"))
            Self:setStatus(513) 
            jResponse['errorId']  := 'NEW009'
            jResponse['error']    := 'Parse do JSON'
            jResponse['errorLog'] := "IDPEDCOMPREXT ou EXTERNID, estão vazios"
            jResponse['solution'] := 'Preencha os campos - IDPEDCOMPREXT ou EXTERNID'

            cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
            oWS:GRAVALOGMURO(cResponc, cJason, "WSPEDVEND", "INCLUSÃO DE PEDIDO DE VENDAS")

            Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
            Return .F.

        Endif

		//Adiciona os dados do ExecAuto
        _cNumPed := oWs:GrPedVd(cFilAt) //GetSXENum("SC5","C5_NUM") //jJson:GetJsonObject("NUMPV") 
        //cNatur   := "02.01.01"
        //cNatur   := iif( Empty(jJson:GetJsonObject("NATUREZA")), "02.01.01", jJson:GetJsonObject("NATUREZA") )
        if (ValType(jJson:GetJsonObject("SINISTR  ")) == "U" )
            cSinistr := ""
        ELSE
            cSinistr := jJson:GetJsonObject("SINISTR  ")
        Endif

        cIdUiv := jJson:GetJsonObject("IDPEDCOMPREXT") + jJson:GetJsonObject("EXTERNID")  //14/10/2025 - inclusão depois de reunião com MP, George e Rodrigo - composição o Externi mais o Enum

        aadd(aCab, {"C5_NUM"       , _cNumPed   ,Nil})
        aadd(aCab, {"C5_EMISSAO"   , ddatabase  ,Nil})
        aadd(aCab, {"C5_CLIENTE"   , _Cli       , nIL})    //jJson:GetJsonObject("CLIENTE"), Nil})
        aadd(aCab, {"C5_LOJACLI"   , _lojCli    , nIL})    //jJson:GetJsonObject("LOJA"), Nil})
        aadd(aCab, {"C5_LOJAENT"   , jJson:GetJsonObject("LOJAENTREGA") , Nil})
        aadd(aCab, {"C5_CONDPAG"   , jJson:GetJsonObject("COND")        , Nil})
        aadd(aCab, {"C5_ZINTEGR"   , jJson:GetJsonObject("INTEGRADO")   , Nil})
        aadd(aCab, {"C5_ZEXTID"    , jJson:GetJsonObject("EXTERNID")    , Nil})
        aadd(aCab, {"C5_SINISTR"   , cSinistr   , Nil})                           //24/09/2025 - 
        aadd(aCab, {"C5_PLACA"     , jJson:GetJsonObject("PLACA")       , Nil})   //24/09/2025 - 
        aadd(aCab, {"C5_INDPRES"   , "1"        , Nil})   //10/10/25 -  SOLICITAÇÃO GEORGE - VIA ZAP
        aadd(aCab, {"C5_TIPOCLI"   , _TpCli     , Nil})   //15/10/25 -  SOLICITAÇÃO VICTOR RAMON - EM MEETING
        aadd(aCab, {"C5_TPFRETE"   , "S"        , Nil})   //20/10/25 -  SOLICITAÇÃO GEORGE - VIA ZAP - PEDIDO PARA "XUMBAR"
        
        aadd(aCab, {"C5_ZGRPNUM"   , jJson:GetJsonObject("IDPEDCOMPREXT")    , Nil})
        aadd(aCab, {"C5_ZIDPDVI"   , cIdUiv   , Nil})                           //14/10/2025 - inclusão depois de reunião com MP, George e Rodrigo - composição o Externi mais o Enum

        //aadd(aCab, {"C5_ZNUMCTR"   , jJson:GetJsonObject("NUMCONTRATO") , Nil}) //DESCONTINUADO DEPOIS DE REUNIÃO COM GEORGE RODRIGO E VICTOR - 19/09/2025//ID146 - J.EDILSON - 16/09/2025
        //aadd(aCab, {"C5_DESC1"     , jJson:GetJsonObject("DESC"), NIL})         //DESCONTINUADO DEPOIS DE REUNIÃO COM GEORGE RODRIGO E VICTOR - 19/09/2025//ID146 - J.EDILSON - 16/09/2025  

        cExtId  := jJson:GetJsonObject("EXTERNID")

        FOR Nx := 1 to len(jJson:GetJsonObject("ITENS"))

            //23/10/2025 - reabilitado - RODRIGO / GEORGE
            If ValType(jJson:GetJsonObject("CENTROCUSTOS")) == "U"
               _cCusto := ""
            else
               _cCusto := jJson:GetJsonObject("CENTROCUSTOS") //jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("CENTROCUSTOS")
            EndIf

            cCCont   := jJson:GetJsonObject("CONTACONTABIL") //jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("CONTACONTABIL")

            aLinhaC1 := {}

            cProdut := jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("PRODUTO")
            cOperac := jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("OPERACAO")
            cNatur  := oWS:pgNat(cProdut)

            if nX == 1
                _cProdu := Posicione("SB1",1, XFILIAL("SB1") + jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("PRODUTO"), "B1_DESC") 
                _Tipo   := Posicione("SB1",1, XFILIAL("SB1") + jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("PRODUTO"), "B1_TIPO") 

                IF _Tipo == 'SV' 
                    cObsMem := cExtId + " - " + _cProdu
                    aadd(aCab, {"C5_XMEMO"     , cObsMem     , NIL}) // J.EDILSON - 10/10/2025 - EM REUNIÃO COM GEORGE E EQUIPE DO FINANCEIR / ONTABILIDADE - DFINIDO QUE NÃO SERÁ USADO 
                ENDIF                
                aadd(aCab, {"C5_NATUREZ"   , cNatur     , NIL}) // J.EDILSON - 10/10/2025 - EM REUNIÃO COM GEORGE E EQUIPE DO FINANCEIR / ONTABILIDADE - DFINIDO QUE NÃO SERÁ USADO 
                nTotal := (jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("QUANT") * jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("PRECO"))
            Endif
            
            aadd(aLinhaC1, {"C6_ITEM"     , Strzero(Nx,2)                                               , nil})
            aadd(aLinhaC1, {"C6_PRODUTO"  , jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("PRODUTO")   , NIL})
            aadd(aLinhaC1, {"C6_QTDVEN"   , jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("QUANT")     , NIL})
            aadd(aLinhaC1, {"C6_QTDLIB"   , jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("QUANT")     , NIL})
            aadd(aLinhaC1, {"C6_PRCVEN"   , jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("PRECO")     , NIL})
            aadd(aLinhaC1, {"C6_VALDESC"  , jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("DESC")      , NIL})
            aadd(aLinhaC1, {"C6_VALOR"    , nTotal, Nil }) 
            aadd(aLinhaC1, {"C6_OPER"     , jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("OPERACAO"), NIL})
            aadd(aLinhaC1, {"C6_DESCRI"   , oWS:PGDSCPRD(cProdut), NIL}) //30/09/2025 - incluido para descrição            
            aadd(aLinhaC1, {"C6_CCUSTO"   , _cCusto , NIL})            //23/10/2025 - REINCLUIDO GEORGE / RODRIGO - //26/09/2025 - solicitada a retirada pelo GEORGE - //22/09/2025 - SOLICITADO POR GEORGE    
            aadd(aLinhaC1, {"C6_CONTA"    , cCCont  , NIL})            //23/10/2025 - INCLUIDO GEORGE / RODRIGO            
            aadd(aItens,aLinhaC1)
        Next

        // cEmpAnt  := cEmpAt
        // cFilAnt  := cFilAt
        
        //RPCSetEnv(cEmpAt, cFilAt)

        //Time(MSExecAuto({|X,Y,Z| MATA410(X,Y,Z)}, aCab, aItens, 3), 5)  //Sugestão do Rafael - testar
        MSExecAuto({|X,Y,Z| MATA410(X,Y,Z)}, aCab, aItens, 3)
        
        If !lMsErroAuto
            Self:setStatus(200) 
            ConOut("Incluido com sucesso! " + _cNumPed)
            jResponse['note']     := 'Registro incluido com sucesso - ' + _cNumPed
            
            Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
            rpcClearEnv()
            cEmpAnt  := cEmpAt1
            cFilAnt  := cFilAt1

            Return 
        Else
            ConOut("Erro na inclusao! -Pedido de Vendas")
            aErroAuto  := GetAutoGRLog()
            For nCount := 1 To Len(aErroAuto)
                if nCount > 1
                    cLogErro += StrTran(StrTran(aErroAuto[nCount], "<", ""), "-", "") + " "
                    ConOut(cLogErro)
                endif
            Next nCount
            cArqLog := 'WSPEDVEND_New_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
			MemoWrite(cDirLog + cArqLog, cErrorLog)

			//Define o retorno para o WebService
			//SetRestFault(500, cErrorLog) //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
            Self:setStatus(510) 
			jResponse['errorId']  := 'NEW005'
			jResponse['error']    := 'Erro na inclusão do registro'
			jResponse['errorLog'] := cErrorLog
			jResponse['solution'] := 'Nao foi possivel incluir o registro, foi gerado um arquivo de log em ' + cDirLog + cArqLog + ' '
			lRet := .F.
			cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']            
            SetRestFault(510, cResponc )

            rpcClearEnv()
            cEmpAnt  := cEmpAt1
            cFilAnt  := cFilAt1

            Return 
        EndIf

        /*
            aRetGrv := oWS:pedVendas(aCab, aItens, 3, _cNumPed) //pedCompra(aCab, aItens, 3) 

            If !aRetGrv[1,2] //lMsErroAuto
                //Monta o texto do Error Log que será salvo
                cErrorLog   := ''
                aLogAuto    := aRetGrv // GetAutoGrLog()
                For nLinha := 1 To Len(aLogAuto)
                    cErrorLog += aLogAuto[nLinha,1] + CRLF
                Next nLinha

                //Grava o arquivo de log
                cArqLog := 'WSPEDVEND_New_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
                MemoWrite(cDirLog + cArqLog, cErrorLog)

                //Define o retorno para o WebService
                //SetRestFault(500, cErrorLog) //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
            Self:setStatus(500) 
                jResponse['errorId']  := 'NEW005'
                jResponse['error']    := 'Erro na inclusão do registro'
                jResponse['errorLog'] := cErrorLog
                jResponse['solution'] := 'Nao foi possivel incluir o registro, foi gerado um arquivo de log em ' + cDirLog + cArqLog + ' '
                lRet := .F.

                cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
                oWS:GRAVALOGMURO(cResponc, cJason, "WSPEDVEND", "INCLUSAO DE PEDIDO DE VENDAS")

            //Senão, define o retorno
            Else
                //aNf := oWS:GerarNota(_cNumPed, FwXFilial("SC5") ) //ROTINA DE GERAÇÃO DE NOTA - 14/07/2025 - retirado por solicitação do Sr. George
                jResponse['note']     := 'Registro incluido com sucesso - ' + _cNumPed
                //oWS:PGTIPPRD(jJson:GetJsonObject("EXTERNID"), cEmpAnt, _cNumPed ) // 10/10/2025
            EndIf
        */  

    EndIf
    RESET ENVIRONMENT

    rpcClearEnv()
    cEmpAnt  := cEmpAt1
    cFilAnt  := cFilAt1
    
    ConOut("O sistema boooooommmmmm " + _cNumPed)
    ConOut("RESPONSE - " + jResponse:toJSON())
       
    //Define o retorno
    //-Self:SetContentType('application/json')
    //-Self:SetResponse(EncodeUTF8(jResponse:toJSON()))

Return 

WSMETHOD PUT UPDATE WSRECEIVE NUMPV WSSERVICE WSPEDVEND
    Local lRet              := .T.
    Local jJson             := Nil
    Local cJson             := Self:GetContent()
    Local cError            := ''
    Local nLinha            := 0
    Local cDirLog           := '\x_logs\'
    Local cArqLog           := ''
    Local cErrorLog         := ''
    Local aLogAuto          := {}
    //Local nCampo            := 0
    Local jResponse         := JsonObject():New()

	Local cJason			:= ""
	Local cResponc          := ""
    Local nX
    Local aItens            := {}
    Local aCab              := {}
    
    Local cIdUiv            := ""  //14/10/2025 - inclusão depois de reunião com MP, George e Rodrigo - composição o Externi mais o Enum

    Private lMsErroAuto     := .F.
    Private lMsHelpAuto     := .T.
    Private lAutoErrNoFile  := .T.

	oWS    := LIBGLASS():new()
 
    //Se não existir a pasta de logs, cria
    IF ! ExistDir(cDirLog)
        MakeDir(cDirLog)
    EndIF    

    //Definindo o conteúdo como JSON, e pegando o content e dando um parse para ver se a estrutura está ok
    Self:SetContentType('application/json')
    jJson  := JsonObject():New()
    cError := jJson:FromJson(cJson)
	cJason := cJson
    lTemPr := .T.
    FOR NX := 1 TO LEN(jJson:GetJsonObject("ITENS"))
	    _cod   := jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("PRODUTO")
        lTemPr := oWS:temProd(FWxFilial("SB1"), _cod)//temFornec(, ::cnpj)
    Next

    //VALIDAÇÃO DO CLIENTE PELO cnpj
    //aClient := oWS:pgClient(jJson:GetJsonObject("CNPJ"))  //16/07/2025 - inclusão do CNPJ
    //_Cli    := aClient[1,1] //jJson:GetJsonObject("CLIENTE")
    //_lojCli := aClient[1,2] //jJson:GetJsonObject("LOJA")
    //VALIDAÇÃO DO CLIENTE PELO cnpj

    _Cli    := jJson:GetJsonObject("CLIENTE")
    _lojCli := if (Empty(jJson:GetJsonObject("LOJA")),"01", jJson:GetJsonObject("LOJA"))

    lTemCLi := ows:temCliCod(FWxFilial("SA1"), _Cli, _lojCli)

    cEmpAt1 := cEmpAnt
    cFilAt1 := cFilAnt

    cEmpAt   := Iif(EMPTY(jJson:GetJsonObject("GRUPO") ), "01", jJson:GetJsonObject("GRUPO" ))
    cFilAt   := Iif(EMPTY(jJson:GetJsonObject("FILIAL")), "01", jJson:GetJsonObject("FILIAL"))

    cEmpAnt  := cEmpAt
    cFilAnt  := cFilAt
    rpcSetEnv(cEmpAt, cFilAt)

	IF !lTemPr //oWS:temProd(FWxFilial("SB1"), _cod)//temFornec(, ::cnpj)
		//SetRestFault(500, 'Falha ao obter JSON') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
		Self:setStatus(500)
		jResponse['errorId']  := 'UPD010'
		jResponse['error']    := 'PRODUTO NÃO EXISTE'
        jResponse['errorLog'] := cErrorLog
		jResponse['solution'] := 'CADASTRE UM PRODUTO QUE DESEJA SOLICITAR'

		cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
		oWS:GRAVALOGMURO(cResponc, cJason, "WSPEDVEND", "ALTERAÇÃO DE PEDIDO DE VENDAS")
        
        Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
        Return .F.
	EndIF
 
    //Se tiver algum erro no Parse, encerra a execução
    IF !Empty(cError)
        //SetRestFault(500, 'Falha ao obter JSON') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
        Self:setStatus(500) 
        jResponse['errorId']  := 'UPD008'
        jResponse['error']    := 'Parse do JSON'
        jResponse['errorLog'] := cErrorLog
        jResponse['solution'] := 'Erro ao fazer o Parse do JSON'

		cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
		oWS:GRAVALOGMURO(cResponc, cJason, "WSPEDVEND", "ALTERAÇÃO DE PEDIDO DE VENDAS")
    Else

		//Adiciona os dados do ExecAuto
        
        cIdUiv   := jJson:GetJsonObject("IDPEDCOMPREXT") + jJson:GetJsonObject("EXTERNID")  //14/10/2025 - inclusão depois de reunião com MP, George e Rodrigo - composição o Externi mais o Enum
        _cNumPed := oWs:PGExtrtV( cIdUiv ) //14/10/2025 - inclusão depois de reunião com MP, George e Rodrigo - composição o Externi mais o Enum

        aadd(aCab, {"C5_NUM"       , _cNumPed   ,Nil})
        aadd(aCab, {"C5_EMISSAO"   , ddatabase  ,Nil})
        aadd(aCab, {"C5_CLIENTE"   , _Cli       , nIL})    //jJson:GetJsonObject("CLIENTE"), Nil})
        aadd(aCab, {"C5_LOJACLI"   , _lojCli    , nIL})    //jJson:GetJsonObject("LOJA"), Nil})
        aadd(aCab, {"C5_LOJAENT"   , jJson:GetJsonObject("LOJAENTREGA"), Nil})
        aadd(aCab, {"C5_CONDPAG"   , jJson:GetJsonObject("COND"), Nil})
        aadd(aCab, {"C5_ZINTEGR"   , jJson:GetJsonObject("INTEGRADO"), Nil})
        aadd(aCab, {"C5_ZEXTID"    , jJson:GetJsonObject("EXTERNID"), Nil})
        //aadd(aCab, {"C5_NATUREZ"   , jJson:GetJsonObject("NATUREZA"), Nil})
        //aadd(aCab, {"C5_INDPRES"   , jJson:GetJsonObject("INDICAPRES"), Nil})
        //aadd(aCab, {"C5_DESC1"     , jJson:GetJsonObject("DESC"), NIL})

        FOR Nx := 1 to len(jJson:GetJsonObject("ITENS"))
            aLinhaC1 := {}
            //cTes     := oWS:TesPDV(cProdut, _Cli, _lojCli, cOperac) //MaTesInt(2, cOperac, _Cli, _lojCli,"C",cProdut,"C6_TES")

            if (jJson:GetJsonObject("DESCONTO") > 0) .AND. nX == 1
                nTotal := (jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("QUANT") * jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("PRECO")) - jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("DESC")
            else
                nTotal := (jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("QUANT") * jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("PRECO"))
            Endif

            aadd(aLinhaC1, {"C6_ITEM"     , Strzero(Nx,4)               ,nil})
            aadd(aLinhaC1, {"C6_PRODUTO"  , jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("PRODUTO"), NIL})
            aadd(aLinhaC1, {"C6_QTDVEN"   , jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("QUANT"), NIL})
            aadd(aLinhaC1, {"C6_PRCVEN"   , jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("PRECO"), NIL})
            aadd(aLinhaC1, {"C6_VALDESC"  , jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("DESC"), NIL})
            aadd(aLinhaC1, {"C6_VALOR"    , nTotal, Nil }) //jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("TOTAL"), NIL})
            aadd(aLinhaC1, {"C6_OPER"     , jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("OPERACAO"), NIL})
            //aadd(aLinhaC1, {"C6_TES"      , jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("TES"), NIL})
            //aadd(aLinhaC1, {"C6_VALOR"    , jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("TOTAL"), NIL})
            aadd(aItens,aLinhaC1)
        Next
        aRetGrv := oWS:pedVendas(aCab, aItens, 4, _cNumPed) //pedCompra(aCab, aItens, 3) 

		If !aRetGrv[1,2] //lMsErroAuto
			//Monta o texto do Error Log que será salvo
			cErrorLog   := ''
			aLogAuto    := aRetGrv // GetAutoGrLog()
			For nLinha := 1 To Len(aLogAuto)
				cErrorLog += aLogAuto[nLinha,1] + CRLF
			Next nLinha

			//Grava o arquivo de log
			cArqLog := 'WSPEDVEND_New_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
			MemoWrite(cDirLog + cArqLog, cErrorLog)

			//Define o retorno para o WebService
			//SetRestFault(500, cErrorLog) //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
           Self:setStatus(500) 
			jResponse['errorId']  := 'UPD009'
			jResponse['error']    := 'Erro na alteração do registro'
			jResponse['errorLog'] := cErrorLog
			jResponse['solution'] := 'Nao foi possivel incluir o registro, foi gerado um arquivo de log em ' + cDirLog + cArqLog + ' '
			lRet := .F.

			cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
			oWS:GRAVALOGMURO(cResponc, cJason, "WSPEDVEND", "ALTERACAO DE PEDIDO DE VENDAS")

		//Senão, define o retorno
		Else
			jResponse['note']     := 'Registro alterado com sucesso - ' + _cNumPed
		EndIf

    EndIf
    rpcClearEnv()

    //Define o retorno
    Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
Return lRet

WSMETHOD PUT ERASE WSRECEIVE NUMPV WSSERVICE WSPEDVEND
    Local lRet              := .T.
    Local jJson             := Nil
    Local cJson             := Self:GetContent()
    Local cError            := ''
    Local nLinha            := 0
    Local cDirLog           := '\x_logs\'
    Local cArqLog           := ''
    Local cErrorLog         := ''
    Local aLogAuto          := {}
    Local jResponse         := JsonObject():New()

	Local cJason			:= ""
	Local cResponc          := ""
    Local nX
    Local aItens            := {}
    Local aCab              := {}
    Local aDadPDV           := {}
    Local _cNumPed          := ""

    Local cIdUiv            := ""  //14/10/2025 - inclusão depois de reunião com MP, George e Rodrigo - composição o Externi mais o Enum

    Private lMsErroAuto     := .F.
    Private lMsHelpAuto     := .T.
    Private lAutoErrNoFile  := .T.

	oWS    := LIBGLASS():new()
 
    //Se não existir a pasta de logs, cria
    IF ! ExistDir(cDirLog)
        MakeDir(cDirLog)
    EndIF    

    //Definindo o conteúdo como JSON, e pegando o content e dando um parse para ver se a estrutura está ok
    Self:SetContentType('application/json')
    jJson  := JsonObject():New()
    cError := jJson:FromJson(cJson)
	cJason := cJson
    lTemPr := .T.

    /* // 05/09/2025
        FOR NX := 1 TO LEN(jJson:GetJsonObject("ITENS"))
            _cod   := jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("PRODUTO")
            lTemPr := oWS:temProd(FWxFilial("SB1"), _cod)//temFornec(, ::cnpj)
        Next

        //VALIDAÇÃO DO CLIENTE PELO cnpj
        _Cli    := jJson:GetJsonObject("CLIENTE")
        _lojCli := if (Empty(jJson:GetJsonObject("LOJA")),"01", jJson:GetJsonObject("LOJA"))

        lTemCLi := ows:temCliCod(FWxFilial("SA1"), _Cli, _lojCli)
    */ // 05/09/2025

    cEmpAt1 := cEmpAnt
    cFilAt1 := cFilAnt

    cEmpAt   := Iif(EMPTY(jJson:GetJsonObject("GRUPO") ), "01", jJson:GetJsonObject("GRUPO" ))
    cFilAt   := Iif(EMPTY(jJson:GetJsonObject("FILIAL")), "01", jJson:GetJsonObject("FILIAL"))

    cEmpAnt  := cEmpAt
    cFilAnt  := cFilAt
    rpcSetEnv(cEmpAt, cFilAt)

    /*  // 05/09/2025
        IF !lTemPr //oWS:temProd(FWxFilial("SB1"), _cod)//temFornec(, ::cnpj)
            //SetRestFault(500, 'Falha ao obter JSON') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
            Self:setStatus(500)
            jResponse['errorId']  := 'DEL014'
            jResponse['error']    := 'PRODUTO NÃO EXISTE'
            jResponse['errorLog'] := cErrorLog
            jResponse['solution'] := 'CADASTRE UM PRODUTO QUE DESEJA SOLICITAR'

            cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
            oWS:GRAVALOGMURO(cResponc, cJason, "WSPEDVEND", "EXCLUSÃO DE PEDIDO DE VENDAS")
            
            Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
            Return .F.
        EndIF
    */  // 05/09/2025

    //Se tiver algum erro no Parse, encerra a execução
    IF !Empty(cError)
        //SetRestFault(500, 'Falha ao obter JSON') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
        Self:setStatus(500) 
        jResponse['errorId']  := 'DEL012'
        jResponse['error']    := 'Parse do JSON'
        jResponse['errorLog'] := cErrorLog
        jResponse['solution'] := 'Erro ao fazer o Parse do JSON'

		cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
		oWS:GRAVALOGMURO(cResponc, cJason, "WSPEDVEND", "EXCLUSÃO DE PEDIDO DE VENDAS")
    Else

		//Adiciona os dados do ExecAuto
        cIdUiv  := jJson:GetJsonObject("IDPEDCOMPREXT") + jJson:GetJsonObject("EXTERNID")  //14/10/2025 - inclusão depois de reunião com MP, George e Rodrigo - composição o Externi mais o Enum
        aDadPDV := oWs:PGExtPDV( cIdUiv ) //jJson:GetJsonObject("NUMPV") 

        //26/09/2025 - incluido para identificar o eero 500
        If len(aDadPDV) == 0
            ConOut("Exclusão pedido de Vendas - pedido não encontrado " + jJson:GetJsonObject("EXTERNID") )
            Self:setStatus(200) 
            lRet := .F.
            Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
            Return lRet
        Endif
        //26/09/2025 - incluido para identificar o eero 500


        FOR Nx := 1 to len(aDadPDV)
            aLinhaC1 := {}
            IF (Nx == 1)
                _cNumPed := aDadPDV[Nx,1]
                aadd(aCab, {"C5_NUM"       , aDadPDV[Nx,1]  , Nil})
                aadd(aCab, {"C5_EMISSAO"   , ddatabase      , Nil})
                aadd(aCab, {"C5_CLIENTE"   , aDadPDV[Nx,3]  , nIL})    //jJson:GetJsonObject("CLIENTE"), Nil})
                aadd(aCab, {"C5_LOJACLI"   , aDadPDV[Nx,4]  , nIL})    //jJson:GetJsonObject("LOJA"), Nil})
                aadd(aCab, {"C5_LOJAENT"   , aDadPDV[Nx,5]  , Nil})
                aadd(aCab, {"C5_LIBEROK"   , " "            , Nil})
                aadd(aCab, {"C5_CONDPAG"   , aDadPDV[Nx,6]  , Nil})
            Endif
            aadd(aLinhaC1, {"C6_ITEM"     , aDadPDV[Nx,7]   , nil})
            aadd(aLinhaC1, {"C6_PRODUTO"  , aDadPDV[Nx,8]   , NIL})
            aadd(aLinhaC1, {"C6_QTDVEN"   , aDadPDV[Nx,9]   , NIL})
            aadd(aLinhaC1, {"C6_QTDLIB"   , 0               , NIL})
            aadd(aLinhaC1, {"C6_QTDEMP"   , 0               , NIL})
            aadd(aLinhaC1, {"C6_PRCVEN"   , aDadPDV[Nx,10]  , NIL})
            aadd(aLinhaC1, {"C6_VALDESC"  , aDadPDV[Nx,11]  , NIL})
            aadd(aLinhaC1, {"C6_VALOR"    , aDadPDV[Nx,12]  , Nil}) 
            aadd(aLinhaC1, {"C6_OPER"     , aDadPDV[Nx,13]  , NIL})
            aadd(aItens,aLinhaC1)
        Next

        //aRetGrv := oWS:pedVendas(aCab, aItens, 4, _cNumPed) //pedCompra(aCab, aItens, 3) 
        ConOut("Incluido Exclusão pedido de Vendas " )
        aRetGrv := oWS:pedVendas(aCab, aItens, 5, _cNumPed) //pedCompra(aCab, aItens, 3) 

		If !aRetGrv[1,2] //lMsErroAuto
            ConOut("Erro na Exclusão pedido de Vendas " )
			//Monta o texto do Error Log que será salvo
			cErrorLog   := ''
			aLogAuto    := aRetGrv // GetAutoGrLog()
			For nLinha := 1 To Len(aLogAuto)
				cErrorLog += aLogAuto[nLinha,1] + CRLF
			Next nLinha

			//Grava o arquivo de log
			cArqLog := 'WSPEDVEND_New_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
			MemoWrite(cDirLog + cArqLog, cErrorLog)

			//Define o retorno para o WebService
			//SetRestFault(500, cErrorLog) //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
            Self:setStatus(500) 
			jResponse['errorId']  := 'DEL013'
			jResponse['error']    := 'Erro na exclusao do registro'
			jResponse['errorLog'] := cErrorLog
			jResponse['solution'] := 'Nao foi possivel excluir o registro, foi gerado um arquivo de log em ' + cDirLog + cArqLog + ' '
			lRet := .F.

			cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
			oWS:GRAVALOGMURO(cResponc, cJason, "WSPEDVEND", "EXCLUSAO DE PEDIDO DE VENDAS")

		//Senão, define o retorno
		Else
			jResponse['note']     := 'Registro excluido com sucesso'
		EndIf

    EndIf
    rpcClearEnv()
    
    //Define o retorno
    Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
Return lRet

WSMETHOD GET PDV WSRECEIVE searchKey, page, pageSize WSREST WSPEDVEND

	Local aList := {}

	Local cAlias := GetNextAlias()
	Local cJsonPdv := ''
	Local cWhere := "AND SC5.C5_FILIAL = '"+xFilial('SC5')+"'"

	Local lRet := .T.

	Local nCount := 0
	Local nStart := 1
	Local nReg := 0
	Local nAux := 0

	Local oJsonPdv := JsonObject():New()

	Default self:searchKey := ''
	Default self:page := 1
	Default self:pageSize := 10
    
    cWhere += " AND SC5.C5_ZINTEGR <> 'S' "

	cWhere := '%'+cWhere+'%'

	//-------------------------------------------------------------------
	// Query para selecionar clientes
	//-------------------------------------------------------------------
	BEGINSQL Alias cAlias
 
	SELECT SC5.C5_NUM, SC5.C5_EMISSAO, SC5.C5_CLIENTE, SC5.C5_LOJACLI,;
        SC5.C5_LOJAENT, SC5.C5_CONDPAG,SC5.C5_ZINTEGR, SC5.C5_NATUREZ;
	FROM %table:SC5% SC5
	WHERE SC5.%NotDel%
	%exp:cWhere%
	
	ENDSQL

	If ( cAlias )->( ! Eof() )

		//-------------------------------------------------------------------
		// Identifica a quantidade de registro no alias temporário
		//-------------------------------------------------------------------
		COUNT TO nRecord

		//-------------------------------------------------------------------
		// nStart -> primeiro registro da pagina
		// nReg -> numero de registros do inicio da pagina ao fim do arquivo
		//-------------------------------------------------------------------
		If self:page > 1
			nStart := ( ( self:page - 1 ) * self:pageSize ) + 1
			nReg := nRecord - nStart + 1
		Else
			nReg := nRecord
		EndIf

		//-------------------------------------------------------------------
		// Posiciona no primeiro registro.
		//-------------------------------------------------------------------
		( cAlias )->( DBGoTop() )

		//-------------------------------------------------------------------
		// Valida a exitencia de mais paginas
		//-------------------------------------------------------------------
		If nReg > self:pageSize
			oJsonPdv['hasNext'] := .T.
		Else
			oJsonPdv['hasNext'] := .F.
		EndIf
	Else
		//-------------------------------------------------------------------
		// Nao encontrou registros
		//-------------------------------------------------------------------
		oJsonPdv['hasNext'] := .F.
	EndIf

	//-------------------------------------------------------------------
	// Alimenta array de clientes
	//-------------------------------------------------------------------
	While ( cAlias )->( ! Eof() )

		nCount++

		If nCount >= nStart
			nAux++
			aAdd( aList , JsonObject():New() )
            aList[nAux]['NUMPV']          := (cAlias)->C5_NUM
            aList[nAux]['EMISSAO']        := StoD((cAlias)->C5_EMISSAO)
            aList[nAux]['CLIENTE']        := (cAlias)->C5_CLIENTE
            aList[nAux]['LOJA']           := (cAlias)->C5_LOJACLI
            aList[nAux]['LOJAENTREGA']    := (cAlias)->C5_LOJAENT
            aList[nAux]['COND']           := (cAlias)->C5_CONDPAG
            aList[nAux]['INTEGRADO']	  := (cAlias)->C5_ZINTEGR
            aList[nAux]['NATUREZA']  	  := Rtrim((cAlias)->C5_NATUREZ)
			If Len(aList) >= self:pageSize
				Exit
			EndIf

		EndIf

		( cAlias )->( DBSkip() )

	End

	( cAlias )->( DBCloseArea() )

	oJsonPdv['PDVS'] := aList

	//-------------------------------------------------------------------
	// Serializa objeto Json
	//-------------------------------------------------------------------
	cJsonPdv:= FwJsonSerialize( oJsonPdv )

	//-------------------------------------------------------------------
	// Elimina objeto da memoria
	//-------------------------------------------------------------------
	FreeObj(oJsonPdv)

	Self:SetResponse( cJsonPdv ) //-- Seta resposta

Return( lRet )
