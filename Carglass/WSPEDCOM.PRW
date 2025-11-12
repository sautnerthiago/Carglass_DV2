//Bibliotecas
#Include "Totvs.ch"
#Include "RESTFul.ch"
#Include "TopConn.ch"
#Include 'Protheus.ch'
#INCLUDE 'APWEBSRV.CH'
#Include "tbiconn.ch"
/*/{Protheus.doc} WSRESTFUL WSPEDCOM
CADASTRO DE FORNECEDOR
@author JOSE EDILSON DE LIMA PINTO
@since 19/05/2025
@version 1.0
@type wsrestful
/*/

WSSTRUCT ITEMPD

	WSDATA nitem as INTEGER
	WSDATA cCodProd as String
	WSDATA cDescProd as String
	WSDATA nQuant as Float

ENDWSSTRUCT

WSRESTFUL WSPEDCOM DESCRIPTION 'PEDIDO DE COMPRAS'
    //Atributos
    WSDATA NUMPC       AS STRING
    WSDATA solicitante AS STRING
    WSDATA emissao     AS STRING
    WSDATA item        AS ITEMPD
    
    WSDATA page AS INTEGER OPTIONAL
	WSDATA pageSize AS INTEGER OPTIONAL
	WSDATA searchKey AS STRING OPTIONAL

	//Métodos
	WSMETHOD GET PDC DESCRIPTION "Retorna lista de Pedidos de Compras" WSSYNTAX "/WSPEDCOM/pdcs " PATH '/WSPEDCOM/pdcs' PRODUCES APPLICATION_JSON
  
    //Métodos
    WSMETHOD GET ID      DESCRIPTION 'Retorna o registro pesquisado'                WSSYNTAX '/WSPEDCOM/{NUMPC}'        PATH '{NUMPC}'      PRODUCES APPLICATION_JSON
	WSMETHOD GET INTEGRA DESCRIPTION 'Retorna o registro pesquisado - INTEGRADO'   	WSSYNTAX '/WSPEDCOM/integrado' 		PATH '/integrado'  	PRODUCES APPLICATION_JSON

    WSMETHOD POST   NEW    DESCRIPTION 'Inclusão de registro'          WSSYNTAX '/WSPEDCOM/new'                      PATH 'new'           PRODUCES APPLICATION_JSON
    WSMETHOD PUT    UPDATE DESCRIPTION 'Atualização de registro'       WSSYNTAX '/WSPEDCOM/update'                   PATH 'update'        PRODUCES APPLICATION_JSON
    WSMETHOD PUT    ERASE  DESCRIPTION 'Blaqueio de registro'          WSSYNTAX '/WSPEDCOM/delete'                   PATH 'delete'        PRODUCES APPLICATION_JSON
END WSRESTFUL

/*/{Protheus.doc} WSMETHOD GET ID
Busca registro via ID
@author JOSE EDILSON DE LIMA PINTO
@since 19/05/2025
/*/

WSMETHOD GET ID WSRECEIVE NUMPC WSSERVICE WSPEDCOM
    Local lRet       := .T.
    Local jResponse  := JsonObject():New()
    Local cAliasWS   := 'SC7'
    Local NUMPC		 := self:aUrlParms[1]

    Local cAlSC7     := GetNextAlias()


	oWS    := LIBGLASS():new()

    //Se o id estiver vazio
    If Empty(NUMPC)
        //SetRestFault(500, 'Falha ao consultar o registro') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
        Self:setStatus(500) 
        jResponse['errorId']  := 'ID001'
        jResponse['error']    := 'ID vazio'
        jResponse['solution'] := 'Informe o ID'
    Else
        DbSelectArea(cAliasWS)
        (cAliasWS)->(DbSetOrder(1))

        //Se não encontrar o registro
        If !(cAliasWS)->(MsSeek(FWxFilial(cAliasWS) + NUMPC))
            //SetRestFault(500, 'Falha ao consultar ID') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
            Self:setStatus(500) 
            jResponse['errorId']  := 'ID002'
            jResponse['error']    := 'PD ('+NUMPC+') não encontrado'
            jResponse['solution'] := 'Código PD não encontrado na tabela ' + cAliasWS
        Else

            cQuery := " SELECT * "
            cQuery += " FROM "+RetSQLName("SC7") + " AS SC7 WITH (NOLOCK) "
            cQuery += " WHERE C7_FILENT = '" + FWxFilial(cAliasWS) + "' AND SC7.C7_NUM = '"+NUMPC+"' "
            cQuery += " AND SC7.D_E_L_E_T_ = '' "
            //cAlSC7:= CriaTrab(Nil,.F.)
            DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSC7, .F., .T.)                
                   
            DO WHILE !((cAlSC7)->(EOF())) .AND. (cAlSC7)->C7_NUM == NUMPC
                    jResponse['NUMPC']     := (cAlSC7)->C7_NUM
                    jResponse['EMISSAO']   := StoD((cAlSC7)->C7_EMISSAO)
                    jResponse['FORNECE']   := (cAlSC7)->C7_FORNECE
                    jResponse['LOJA']      := (cAlSC7)->C7_LOJA
                    jResponse['COND']      := (cAlSC7)->C7_COND
                    jResponse['CONTATO']   := (cAlSC7)->C7_CONTATO
                    jResponse['FILENT']    := (cAlSC7)->C7_FILENT
                    jResponse['INTEGRADO'] := (cAlSC7)->C7_ZINTEGR
                    jResponse['ITENS']     := oWS:ITENSPC((cAlSC7)->C7_FILIAL, (cAlSC7)->C7_NUM, (cAlSC7)->C7_FORNECE, (cAlSC7)->C7_LOJA )
                    (cAlSC7)->(DBSKIP())
                    LOOP
            ENDDO
            (cAlSC7)->(DBCLOSEAREA())

        EndIf
    EndIf

    //Define o retorno
    Self:SetContentType('application/json')
    Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
Return lRet

WSMETHOD GET INTEGRA WSRECEIVE WSSERVICE WSPEDCOM
	Local lRet       := .T.
	Local jResponse  := JsonObject():New()

	oWS    := LIBGLASS():new()
	cJsonNfs:= FwJsonSerialize( oWS:Integrado( "SC7", "" )  )			

    If Empty(cJsonNfs) 
		Self:setStatus(500)
		jResponse['errorId']  := 'Tipo016'
		jResponse['error']    := 'Não ha dados a serem integrados'
		jResponse['solution'] := 'Não ha dados a Integrar'

		cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
		oWS:GRAVALOGMURO(cResponc, cJason, "WSPEDCOM", "NAO HA DADOS A SEREM INTEGRADOS")
	Else
    	//Define o retorno
		Self:SetContentType('application/json')
		Self:SetResponse(cJsonNfs)
	ENDIF	

Return lRet

WSMETHOD POST NEW WSRECEIVE NUMPC WSSERVICE WSPEDCOM
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
    Local _cCusto           := ""
    Local cCCont            := ""   //23/10/2025 - INCLUSÃO - GEORGE / RODRIGO
    Local cIdUiv            := ""   //14/10/2025 - id unico do pedido de compras
    Local aRet              := {}
    //Local aFornec           := {}

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
    
    ConOut("iniciando pedido de compras")
    
    cError := jJson:FromJson(cJson)

    if !(empty(cError)) 
		Self:setStatus(500)
		jResponse['errorId']  := 'NEW0000'
		jResponse['error']    := 'ERRO NO JSON'
        jResponse['errorLog'] := cError
		jResponse['solution'] := 'ANALISE A INFORMACAO DE ENVIO'
        
        ConOut("erro 001")

        Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
        Return .F.
    ENDIF

	cJason := cJson 
    lTemPr := .F.
    FOR NX := 1 TO LEN(jJson:GetJsonObject("ITENS"))
	    _cod   := jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("PRODUTO")
        lTemPr := oWS:temProd(FWxFilial("SB1"), _cod)//temFornec(, ::cnpj)
    Next

    //VALIDAÇÃO DO FORNECEDOR PELO cnpj
    //aFornec := oWS:pgFornec(jJson:GetJsonObject("CNPJ"))  //16/07/2025 - inclusão do CNPJ
    //if len(aFornec) > 0
    cTamSp := jJson:GetJsonObject("FORNECE")

    _For    := cTamSp + Space(10-len(cTamSp))
    _lojFor := "01"//jJson:GetJsonObject("LOJA")
    lTemFor := ows:temForCod(FWxFilial("SA2"), _For, _lojFor)
    //else
    //    lTemFor := .F.
    //endif
    //VALIDAÇÃO DO FORNECEDOR PELO cnpj

    cEmpAt1 := cEmpAnt
    cFilAt1 := cFilAnt

    cEmpAt   := Iif(EMPTY(jJson:GetJsonObject("GRUPO") ), "01", jJson:GetJsonObject("GRUPO" ))
    cFilAt   := Iif(EMPTY(jJson:GetJsonObject("FILIAL")), "01", jJson:GetJsonObject("FILIAL"))

    cEmpAnt  := cEmpAt
    cFilAnt  := cFilAt
    
    //RPCSetEnv(cEmpAt, cFilAt)
    Do While .T.
        rpcClearEnv()
        if RPCSetEnv(cEmpAt, cFilAt) //RPCSetEnv('02','01')       
            EXIT            
        ENDIF
    EndDo

    IF !lTemFor
		//SetRestFault(500, 'Falha ao obter JSON') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
		Self:setStatus(500)
		jResponse['errorId']  := 'NEW0041'
		jResponse['error']    := 'FORNECEDOR NAO EXISTE'
        jResponse['errorLog'] := cErrorLog
		jResponse['solution'] := 'CADASTRE UM FORNECEDOR'

		cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
		oWS:GRAVALOGMURO(cResponc, cJason, "WSPEDCOM", "INCLUSÃO DE PEDIDO DE COMPRAS")

        ConOut("erro 002")

        Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
        Return .F.
	EndIF

	IF !lTemPr //oWS:temProd(FWxFilial("SB1"), _cod)//temFornec(, ::cnpj)
		//SetRestFault(500, 'Falha ao obter JSON') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
		Self:setStatus(500)
		jResponse['errorId']  := 'NEW0041'
		jResponse['error']    := 'PRODUTO NÃO EXISTE'
        jResponse['errorLog'] := cErrorLog
		jResponse['solution'] := 'CADASTRE UM PRODUTO QUE DESEJA PEDIR'

		cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
		oWS:GRAVALOGMURO(cResponc, cJason, "WSPEDCOM", "INCLUSÃO DE PEDIDO DE COMPRAS")

        ConOut("erro 003 - Pedido de Compras")
        
        Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
        Return .F.
	EndIF
 
    //Se tiver algum erro no Parse, encerra a execução
    IF !Empty(cError)
        //SetRestFault(500, 'Falha ao obter JSON') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
        Self:setStatus(500) 
        jResponse['errorId']  := 'NEW004'
        jResponse['error']    := 'Parse do JSON'
        jResponse['errorLog'] := cErrorLog
        jResponse['solution'] := 'Erro ao fazer o Parse do JSON'

        ConOut("erro 004")
        
		cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
		oWS:GRAVALOGMURO(cResponc, cJason, "WSPEDCOM", "INCLUSÃO DE PEDIDO DE COMPRAS")
    Else		

		//Adiciona os dados do ExecAuto
        _cNumPed := oWs:GrPedCom(cFilAt) //GetSXENum("SC7","C7_NUM") //jJson:GetJsonObject("NUMPC")
        cTes     := jJson:GetJsonObject("TES")

        If ValType(jJson:GetJsonObject("CENTROCUSTOS")) == "U"
            _cCusto := ""
        else
            _cCusto := jJson:GetJsonObject("CENTROCUSTOS")
        EndIf

        IF !(oWs:temCC( _cCusto ))
            Self:setStatus(502)
            jResponse['errorId']  := 'NEW0019'
            jResponse['error']    := 'CENTRO DE CUSTOS'
            jResponse['errorLog'] := cErrorLog
            jResponse['solution'] := 'CENTRO DE CUSTOS, NÃO EXISTE OU VAZIO'

            cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
            oWS:GRAVALOGMURO(cResponc, cJason, "WSPEDCOM", "INCLUSÃO DE PEDIDO DE COMPRAS - EXTERNID")
            
            Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
            Return .F.
        Endif

        aadd(aCab, {"C7_FILIAL"    , cFilAt     ,Nil})
        aadd(aCab, {"C7_NUM"       , _cNumPed   ,Nil})
        aadd(aCab, {"C7_EMISSAO"   , ddatabase  ,Nil})
        aadd(aCab, {"C7_MOEDA"     , 1			,Nil})
        aadd(aCab, {"C7_TXMOEDA"   , 1			,Nil})
        aadd(aCab, {"C7_FORNECE"   , _For       , Nil})
        aadd(aCab, {"C7_LOJA"      , _lojFor    , Nil})
        aadd(aCab, {"C7_COND"      , jJson:GetJsonObject("COND"), Nil})
        aadd(aCab, {"C7_CONTATO"   , jJson:GetJsonObject("CONTATO"), Nil})
        aadd(aCab, {"C7_FILENT"    , jJson:GetJsonObject("FILENT"), Nil})
        aadd(aCab, {"C7_ZINTEGR"   , jJson:GetJsonObject("INTEGRADO"), Nil})

        _ZEXTID := jJson:GetJsonObject("EXTERNID")
        _Enum   := jJson:GetJsonObject("IDPEDCOMPREXT")
        aRet    := oWs:PGExtDad( _Enum + _ZEXTID )
        IF len(aRet) > 0
            Self:setStatus(500)
            jResponse['errorId']  := 'NEW0016'
            jResponse['error']    := 'EXTERNOID'
            jResponse['errorLog'] := cErrorLog
            jResponse['solution'] := 'EXTERNOID - JA CADASTRADO ANTERIORMENTE'

            cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
            oWS:GRAVALOGMURO(cResponc, cJason, "WSPEDCOM", "INCLUSÃO DE PEDIDO DE COMPRAS - EXTERNID")
            
            Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
            Return .F.
        Endif

                            
        FOR Nx := 1 to len(jJson:GetJsonObject("ITENS"))
            aLinhaC1 := {}

            nTotal := (jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("QUANT") * jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("PRECO")) //- jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("DESC")
            
            _cAprov := jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("GRPAPROV")

            aadd(aLinhaC1, {"C7_PRODUTO" , jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("PRODUTO"), NIL})
            aadd(aLinhaC1, {"C7_QUANT"   , jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("QUANT"), NIL})
            aadd(aLinhaC1, {"C7_PRECO"   , jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("PRECO"), NIL})
            aadd(aLinhaC1, {"C7_DESC1"   , jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("DESC"), NIL})
            aadd(aLinhaC1, {"C7_VLDESC"  , jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("DESC"), NIL})
            aadd(aLinhaC1, {"C7_TOTAL"   , nTotal, NIL})
            aadd(aLinhaC1, {"C7_OPER"    , jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("OPERACAO"), NIL})   //05/08/2025 - INCLUIDO
            //aadd(aLinhaC1, {"C7_APROV"   , _cAprov, NIL})  // 14/10/2025 - DESCONTINUADO //09/10/2025 - INCLUIDO - EM VALIDAÇÃO GRUPO DE APROVAÇÃO

            cUM     := POSICIONE("SB1",1,xFilial("SB1")+jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("PRODUTO"),"B1_UM")
            cDesc   := POSICIONE("SB1",1,xFilial("SB1")+jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("PRODUTO"),"B1_DESC")

            //23/10/2025 - reabilitado - RODRIGO / GEORGE
            If ValType(jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("CENTROCUSTOS")) == "U"
               _cCusto := ""
            else
               _cCusto := jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("CENTROCUSTOS")
            EndIf
            cCCont   := jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("CONTACONTABIL")

            cIdUiv   := jJson:GetJsonObject("IDPEDCOMPREXT") + _ZEXTID  //14/10/2025 - inclusão depois de reunião com MP, George e Rodrigo - composição o Externi mais o Enum

            aadd(aLinhaC1,{"C7_ITEM"    ,Strzero(Nx,4)               ,nil})
            aadd(aLinhaC1,{"C7_UM"      ,cUM                         ,nil})
            aadd(aLinhaC1,{"C7_DESCRI"  ,cDesc                       ,nil})
            aadd(aLinhaC1,{"C7_LOCAL"   ,"01"                        ,Nil})   
            aadd(aLinhaC1,{"C7_CC"      ,_cCusto                     ,Nil}) //23/10/2025 - REINCERIDO- RODRIGO / GEORGE - //26/09/2025 - solicitada a retirada pelo GEORGE - //22/09/2025 - SOLICITADO POR GEORGE                    
            aadd(aLinhaC1,{"C7_OBS"     ,""                          ,Nil})
            aadd(aLinhaC1,{"C7_CONTATO" ,""                          ,Nil})
            aadd(aLinhaC1,{"C7_DATPRF"  ,dDataBase                   ,NIL})
            aadd(aLinhaC1,{"C7_EMISSAO" ,dDataBase                   ,NIL})
            aadd(aLinhaC1,{"C7_SEGURO"  ,0.00                        ,NIL})
            aadd(aLinhaC1,{"C7_DESPESA" ,0.00                        ,NIL})  
            aadd(aLinhaC1,{"C7_VALFRE"  ,0.00                        ,NIL})         
            // aadd(aLinhaC1,{"C7_IPI"     ,0.00                        ,Nil})  
            // aadd(aLinhaC1,{"C7_PICM"    ,0.00                        ,NIL})              
            // aadd(aLinhaC1,{"C7_TXMOEDA" ,0.00                        ,NIL})              
            // aadd(aLinhaC1,{"C7_BASESOL" ,0.00                        ,NIL})
            aadd(aLinhaC1,{"C7_ZEXTID"  ,_ZEXTID                     ,Nil})            
            aadd(aLinhaC1,{"C7_ZGRPNUM" , jJson:GetJsonObject("IDPEDCOMPREXT"), Nil})  //14/10/2025 - inclusão depois de reunião com MP, George e Rodrigo
            aadd(aLinhaC1,{"C7_ZIDPDCI" , cIdUiv     , Nil})
            aadd(aLinhaC1,{"C7_CONTA"   , cCCont     , Nil})            //23/10/2025 - INCLUIDO GEORGE / RODRIGO            

            //aadd(aLinhaC1,{"C7_APROV"   ,"000001"                    ,NIL}) //INCLUIDO E NÃO COMPILADO AINDA- 01/09/2025 - aguardando confiração para compilação
            aadd(aItens,aLinhaC1)
        Next
        aRetGrv := oWS:pedCompra(aCab, aItens, 3) 

		If !aRetGrv[1,2] //lMsErroAuto
			//Monta o texto do Error Log que será salvo
			cErrorLog   := ''
			aLogAuto    := aRetGrv // GetAutoGrLog()
			For nLinha := 1 To Len(aLogAuto)
				cErrorLog += aLogAuto[nLinha,1] + CRLF
			Next nLinha

			//Grava o arquivo de log
			cArqLog := 'WSPEDCOM_New_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
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
			oWS:GRAVALOGMURO(cResponc, cJason, "WSPEDCOM", "INCLUSÃO DE PEDIDO DE COMPRAS")

            ConOut("erro 005")
        
		    //Senão, define o retorno
		Else
			jResponse['note']     := 'Registro incluido com sucesso - ' + _cNumPed 
            //oWS:atuPEdC(_cNumPed, _cAprov, _ZEXTID )
		EndIf

    EndIf
    rpcClearEnv()
    cEmpAnt  := cEmpAt1
    cFilAnt  := cFilAt1
    
    ConOut("ô sistema boooooommmmmm " + _cNumPed)
        
    //Define o retorno
    Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
Return lRet

WSMETHOD PUT UPDATE WSRECEIVE NUMPC WSSERVICE WSPEDCOM
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

    _For    := jJson:GetJsonObject("FORNECE")
    _lojFor := "01"//jJson:GetJsonObject("LOJA")
    lTemFor := ows:temForCod(FWxFilial("SA2"), _For, _lojFor)

    cEmpAt1 := cEmpAnt
    cFilAt1 := cFilAnt

    cEmpAt   := Iif(EMPTY(jJson:GetJsonObject("GRUPO") ), "01", jJson:GetJsonObject("GRUPO" ))
    cFilAt   := Iif(EMPTY(jJson:GetJsonObject("FILIAL")), "01", jJson:GetJsonObject("FILIAL"))

    cEmpAnt  := cEmpAt
    cFilAnt  := cFilAt
    
    RPCSetEnv(cEmpAt, cFilAt)

	IF !lTemPr //oWS:temProd(FWxFilial("SB1"), _cod)//temFornec(, ::cnpj)
		//SetRestFault(500, 'Falha ao obter JSON') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
		Self:setStatus(500)
		jResponse['errorId']  := 'UPD010'
		jResponse['error']    := 'PRODUTO NÃO EXISTE'
        jResponse['errorLog'] := cErrorLog
		jResponse['solution'] := 'CADASTRE UM PRODUTO QUE DESEJA SOLICITAR'

		cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
		oWS:GRAVALOGMURO(cResponc, cJason, "WSPEDCOM", "ALTERAÇÃO DE PEDIDO DE COMPRAS")
        
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
		oWS:GRAVALOGMURO(cResponc, cJason, "WSPEDCOM", "ALTERAÇÃO DE PEDIDO DE COMPRAS")
    Else

		//Adiciona os dados do ExecAuto
        _ZEXTID  := jJson:GetJsonObject("EXTERNID")
        cIdUiv   := jJson:GetJsonObject("IDPEDCOMPREXT") + _ZEXTID  //14/10/2025 - inclusão depois de reunião com MP, George e Rodrigo

        _cNumPed := oWs:PGExtrt( cIdUiv ) 

        aadd(aCab, {"C7_NUM"       , _cNumPed   ,Nil})
        aadd(aCab, {"C7_EMISSAO"   , ddatabase  ,Nil})
        aadd(aCab, {"C7_MOEDA"     , 1			,Nil})
        aadd(aCab, {"C7_TXMOEDA"   , 1			,Nil})
        aadd(aCab, {"C7_FORNECE"   , _For       ,Nil})
        aadd(aCab, {"C7_LOJA"      , _lojFor    ,Nil})
        aadd(aCab, {"C7_COND"      , jJson:GetJsonObject("COND"), Nil})
        aadd(aCab, {"C7_CONTATO"   , jJson:GetJsonObject("CONTATO"), Nil})
        aadd(aCab, {"C7_FILENT"    , jJson:GetJsonObject("FILENT"), Nil})
        aadd(aCab, {"C7_ZINTEGR"   , jJson:GetJsonObject("INTEGRADO"), Nil})

        FOR Nx := 1 to len(jJson:GetJsonObject("ITENS"))
            aLinhaC1 := {}
            nTotal   := (jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("QUANT") * jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("PRECO")) //- jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("DESC")
            
            aadd(aLinhaC1, {"C7_PRODUTO" , jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("PRODUTO"), NIL})
            aadd(aLinhaC1, {"C7_QUANT"   , jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("QUANT"), NIL})
            aadd(aLinhaC1, {"C7_PRECO"   , jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("PRECO"), NIL})
            aadd(aLinhaC1, {"C7_DESC1"   , jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("DESC"), NIL})
            aadd(aLinhaC1, {"C7_VLDESC"  , jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("DESC"), NIL})
            aadd(aLinhaC1, {"C7_TOTAL"   , nTotal, NIL})

            cUM    := POSICIONE("SB1",1,xFilial("SB1")+jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("PRODUTO"),"B1_UM")
            cDesc  := POSICIONE("SB1",1,xFilial("SB1")+jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("PRODUTO"),"B1_DESC")

            aadd(aLinhaC1,{"C7_ITEM"    ,Strzero(Nx,4)               ,nil})
            aadd(aLinhaC1,{"C7_UM"      ,cUM                         ,nil})
            aadd(aLinhaC1,{"C7_DESCRI"  ,cDesc                       ,nil})
            aadd(aLinhaC1,{"C7_LOCAL"   ,"01"                        ,Nil})   
            aadd(aLinhaC1,{"C7_IPI"     ,0.00                        ,Nil})  
            aadd(aLinhaC1,{"C7_CC"      ,""                          ,Nil})                 
            aadd(aLinhaC1,{"C7_OBS"     ,""                          ,Nil})
            aadd(aLinhaC1,{"C7_CONTATO" ,""                          ,Nil})
            aadd(aLinhaC1,{"C7_DATPRF"  ,dDataBase                   ,NIL})
            aadd(aLinhaC1,{"C7_EMISSAO" ,dDataBase                   ,NIL})
            aadd(aLinhaC1,{"C7_PICM"    ,0.00                        ,NIL})              
            aadd(aLinhaC1,{"C7_SEGURO"  ,0.00                        ,NIL})
            aadd(aLinhaC1,{"C7_DESPESA" ,0.00                        ,NIL})  
            aadd(aLinhaC1,{"C7_TXMOEDA" ,0.00                        ,NIL})              
            aadd(aLinhaC1,{"C7_VALFRE"  ,0.00                        ,NIL})         
            aadd(aLinhaC1,{"C7_BASESOL" ,0.00                        ,NIL})
            //aadd(aLinhaC1,{"C7_ZEXTID"  ,_ZEXTID                     ,Nil})            
            aadd(aItens,aLinhaC1)
        Next
        aRetGrv := oWS:pedCompra(aCab, aItens, 4) 

		If !aRetGrv[1,2] //lMsErroAuto
			//Monta o texto do Error Log que será salvo
			cErrorLog   := ''
			aLogAuto    := aRetGrv // GetAutoGrLog()
			For nLinha := 1 To Len(aLogAuto)
				cErrorLog += aLogAuto[nLinha,1] + CRLF
			Next nLinha

			//Grava o arquivo de log
			cArqLog := 'WSPEDCOM_upd_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
			MemoWrite(cDirLog + cArqLog, cErrorLog)

			//Define o retorno para o WebService
			//SetRestFault(500, cErrorLog) //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
           Self:setStatus(500) 
			jResponse['errorId']  := 'UPD009'
			jResponse['error']    := 'Erro na Alteracao do registro'
			jResponse['errorLog'] := cErrorLog
			jResponse['solution'] := 'Nao foi possivel alterar o registro, foi gerado um arquivo de log em ' + cDirLog + cArqLog + ' '
			lRet := .F.

			cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
			oWS:GRAVALOGMURO(cResponc, cJason, "WSPEDCOM", "ALTERAÇÃO DE PEDIDO DE COMPRAS")

		//Senão, define o retorno
		Else
			jResponse['note']     := 'Registro alterado com sucesso - ' + _cNumPed 
		EndIf

    EndIf
    rpcClearEnv()

    //Define o retorno
    Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
Return lRet

WSMETHOD PUT ERASE WSRECEIVE NUMPC WSSERVICE WSPEDCOM
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
    Local aDadSC7           := {}

    Local _ZEXTID           := "" 

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

    /* // 04/09/2025
        FOR NX := 1 TO LEN(jJson:GetJsonObject("ITENS"))
            _cod   := jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("PRODUTO")
            lTemPr := oWS:temProd(FWxFilial("SB1"), _cod)//temFornec(, ::cnpj)
        Next

        _For    := jJson:GetJsonObject("FORNECE")
        _lojFor := "01"//jJson:GetJsonObject("LOJA")
        lTemFor := ows:temForCod(FWxFilial("SA2"), _For, _lojFor)
    */// 04/09/2025

    cEmpAt1 := cEmpAnt
    cFilAt1 := cFilAnt

    cEmpAt   := Iif(EMPTY(jJson:GetJsonObject("GRUPO") ), "01", jJson:GetJsonObject("GRUPO" ))
    cFilAt   := Iif(EMPTY(jJson:GetJsonObject("FILIAL")), "01", jJson:GetJsonObject("FILIAL"))

    cEmpAnt  := cEmpAt
    cFilAnt  := cFilAt
    
    RPCSetEnv(cEmpAt, cFilAt)

	/* // 04/09/2025
        IF !lTemPr 
            //SetRestFault(500, 'Falha ao obter JSON') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
            Self:setStatus(500)
            jResponse['errorId']  := 'DEL014'
            jResponse['error']    := 'PRODUTO NÃO EXISTE'
            jResponse['errorLog'] := cErrorLog
            jResponse['solution'] := 'CADASTRE UM PRODUTO QUE DESEJA SOLICITAR'

            cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
            oWS:GRAVALOGMURO(cResponc, cJason, "WSPEDCOM", "EXCLUSÃO DE PEDIDO DE COMPRAS")
            
            Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
            Return .F.
        EndIF
    */ // 04/09/2025
    
    //Se tiver algum erro no Parse, encerra a execução
    IF !Empty(cError)
        //SetRestFault(500, 'Falha ao obter JSON') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
        Self:setStatus(500) 
        jResponse['errorId']  := 'DEL012'
        jResponse['error']    := 'Parse do JSON'
        jResponse['errorLog'] := cErrorLog
        jResponse['solution'] := 'Erro ao fazer o Parse do JSON'

		cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
		oWS:GRAVALOGMURO(cResponc, cJason, "WSPEDCOM", "EXCLUSÃO DE PEDIDO DE COMPRAS")
    Else
		
		//Adiciona os dados do ExecAuto
        //_cNumPed := oWs:PGExtrt(jJson:GetJsonObject("EXTERNID")) //jJson:GetJsonObject("NUMPC") //GetSx8Num("SC7","C7_NUM")

        _ZEXTID  := jJson:GetJsonObject("EXTERNID")                 //14/10/2025 - inclusão depois de reunião com MP, George e Rodrigo
        cIdUiv   := jJson:GetJsonObject("IDPEDCOMPREXT") + _ZEXTID  //14/10/2025 - inclusão depois de reunião com MP, George e Rodrigo
        aDadSC7   := oWs:PGExtDad( cIdUiv )
        
        //26/09/2025 - incluido para identificar o eero 500
        If len(aDadSC7) == 0
            ConOut("Exclusão pedido de Compras - pedido não encontrado " + jJson:GetJsonObject("EXTERNID") )
            Self:setStatus(200) 
            Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
            lRet := .F.
            Return lRet
        Endif
        //26/09/2025 - incluido para identificar o eero 500

        FOR Nx := 1 to Len(aDadSC7) //len(jJson:GetJsonObject("ITENS"))
            if Nx == 1
                aadd(aCab, {"C7_NUM"       , aDadSC7[Nx, 01]     , Nil})
                aadd(aCab, {"C7_EMISSAO"   , ddatabase           , Nil})
                aadd(aCab, {"C7_MOEDA"     , 1			         , Nil})
                aadd(aCab, {"C7_TXMOEDA"   , 1			         , Nil})
                aadd(aCab, {"C7_FORNECE"   , aDadSC7[Nx, 05]     , Nil})
                aadd(aCab, {"C7_LOJA"      , aDadSC7[Nx, 06]     , Nil})
                aadd(aCab, {"C7_COND"      , aDadSC7[Nx, 07]     , Nil})
                aadd(aCab, {"C7_CONTATO"   , aDadSC7[Nx, 08]     , Nil})
                aadd(aCab, {"C7_FILENT"    , aDadSC7[Nx, 09]     , Nil})
                aadd(aCab, {"C7_ZINTEGR"   , aDadSC7[Nx, 10]     , Nil})
            endif

            aLinhaC1 := {}
            
            aadd(aLinhaC1, {"C7_PRODUTO"  , aDadSC7[Nx, 11]     , NIL})
            aadd(aLinhaC1, {"C7_QUANT"    , aDadSC7[Nx, 12]     , NIL})
            aadd(aLinhaC1, {"C7_PRECO"    , aDadSC7[Nx, 13]     , NIL})
            aadd(aLinhaC1, {"C7_DESC1"    , aDadSC7[Nx, 14]     , NIL})
            aadd(aLinhaC1, {"C7_TOTAL"    , aDadSC7[Nx, 15]     , NIL})
            aadd(aLinhaC1, {"C7_ITEM"     , aDadSC7[Nx, 16]     , nil})
            aadd(aLinhaC1, {"C7_UM"       , aDadSC7[Nx, 17]     , nil})
            aadd(aLinhaC1, {"C7_DESCRI"   , aDadSC7[Nx, 18]     , nil})
            aadd(aLinhaC1, {"C7_LOCAL"    , "01"                , Nil})   
            aadd(aLinhaC1, {"C7_IPI"      , 0.00                , Nil})  
            aadd(aLinhaC1, {"C7_CC"       , ""                  , Nil})                 
            aadd(aLinhaC1, {"C7_OBS"      , ""                  , Nil})
            aadd(aLinhaC1, {"C7_CONTATO"  , ""                  , Nil})
            aadd(aLinhaC1, {"C7_DATPRF"   , dDataBase           , NIL})
            aadd(aLinhaC1, {"C7_EMISSAO"  , dDataBase           , NIL})
            aadd(aLinhaC1, {"C7_PICM"     , 0.00                , NIL})              
            aadd(aLinhaC1, {"C7_SEGURO"   , 0.00                , NIL})
            aadd(aLinhaC1, {"C7_DESPESA"  , 0.00                , NIL})  
            aadd(aLinhaC1, {"C7_TXMOEDA"  , 0.00                , NIL})              
            aadd(aLinhaC1, {"C7_VALFRE"   , 0.00                , NIL})         
            aadd(aLinhaC1, {"C7_BASESOL"  , 0.00                , NIL})
            aadd(aItens,aLinhaC1)
        Next
        aRetGrv := oWS:pedCompra(aCab, aItens, 5) 

		If !aRetGrv[1,2] //lMsErroAuto
			//Monta o texto do Error Log que será salvo
			cErrorLog   := ''
			aLogAuto    := aRetGrv // GetAutoGrLog()
			For nLinha := 1 To Len(aLogAuto)
				cErrorLog += aLogAuto[nLinha] + CRLF
			Next nLinha

			//Grava o arquivo de log
			cArqLog := 'WSPEDCOM_New_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
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
			oWS:GRAVALOGMURO(cResponc, cJason, "WSPEDCOM", "EXCLUSÃO DE PEDIDO DE COMPRAS")

		//Senão, define o retorno
		Else
			jResponse['note']     := 'Registro excluido com sucesso'
		EndIf

    EndIf
    rpcClearEnv()
    
    //Define o retorno
    Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
Return lRet

WSMETHOD GET PDC WSRECEIVE searchKey, page, pageSize WSREST WSPEDCOM

	Local aList := {}

	Local cAlias := GetNextAlias()
	Local cJsonPdC := ''
	Local cWhere := "AND SC7.C7_FILIAL = '"+xFilial('SC7')+"'"

	Local lRet := .T.

	Local nCount := 0
	Local nStart := 1
	Local nReg := 0
	Local nAux := 0

	Local oJsonPdC := JsonObject():New()

	Default self:searchKey := ''
	Default self:page := 1
	Default self:pageSize := 10
    
    cWhere += " AND SC7.C7_ZINTEGR <> 'S' "

	cWhere := '%'+cWhere+'%'

	//-------------------------------------------------------------------
	// Query para selecionar clientes
	//-------------------------------------------------------------------
	BEGINSQL Alias cAlias
 
	SELECT SC7.C7_NUM,SC7.C7_EMISSAO,SC7.C7_FORNECE,SC7.C7_LOJA,SC7.C7_COND,SC7.C7_CONTATO,SC7.C7_FILENT,SC7.C7_ZINTEGR FROM %table:SC7% SC7
	WHERE SC7.%NotDel%
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
			oJsonPdC['hasNext'] := .T.
		Else
			oJsonPdC['hasNext'] := .F.
		EndIf
	Else
		//-------------------------------------------------------------------
		// Nao encontrou registros
		//-------------------------------------------------------------------
		oJsonPdC['hasNext'] := .F.
	EndIf

	//-------------------------------------------------------------------
	// Alimenta array de clientes
	//-------------------------------------------------------------------
	While ( cAlias )->( ! Eof() )

		nCount++

		If nCount >= nStart
			nAux++
			aAdd( aList , JsonObject():New() )
            aList[nAux]['NUMPC']     := (cAlias)->C7_NUM
            aList[nAux]['EMISSAO']   := StoD((cAlias)->C7_EMISSAO)
            aList[nAux]['FORNECE']   := (cAlias)->C7_FORNECE
            aList[nAux]['LOJA']      := (cAlias)->C7_LOJA
            aList[nAux]['COND']      := (cAlias)->C7_COND
            aList[nAux]['CONTATO']   := (cAlias)->C7_CONTATO
            aList[nAux]['FILENT']    := (cAlias)->C7_FILENT
            aList[nAux]['INTEGRADO'] := (cAlias)->C7_ZINTEGR
			If Len(aList) >= self:pageSize
				Exit
			EndIf

		EndIf

		( cAlias )->( DBSkip() )

	End

	( cAlias )->( DBCloseArea() )

	oJsonPdC['PDVS'] := aList

	//-------------------------------------------------------------------
	// Serializa objeto Json
	//-------------------------------------------------------------------
	cJsonPdC:= FwJsonSerialize( oJsonPdC )

	//-------------------------------------------------------------------
	// Elimina objeto da memoria
	//-------------------------------------------------------------------
	FreeObj(oJsonPdC)

	Self:SetResponse( cJsonPdC ) //-- Seta resposta

Return( lRet )
