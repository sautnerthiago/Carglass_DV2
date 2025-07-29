//Bibliotecas
#Include "Totvs.ch"
#Include "RESTFul.ch"
#Include "TopConn.ch"
#Include 'Protheus.ch'
#INCLUDE 'APWEBSRV.CH'

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
    Local NUMPV			 := self:aUrlParms[1]
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
            cAlSC5:= CriaTrab(Nil,.F.)
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
    Local aClient           := {}

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
        lTemPr := oWS:temProd(FWxFilial("SB1"), _cod) 
    Next
 
    cEmpAt := Iif(EMPTY(jJson:GetJsonObject("GRUPO") ), "01", jJson:GetJsonObject("GRUPO" ))
    cFilAt := Iif(EMPTY(jJson:GetJsonObject("FILIAL")), "01", jJson:GetJsonObject("FILIAL"))
    rpcSetEnv(cEmpAt, cFilAt)

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
    aClient := oWS:pgClient(jJson:GetJsonObject("CNPJ"))  //16/07/2025 - inclusão do CNPJ
    if len(aClient) > 0
        _Cli    := aClient[1,1] //jJson:GetJsonObject("CLIENTE")
        _lojCli := aClient[1,2] //jJson:GetJsonObject("LOJA")

        lTemCLi := ows:temCliCod(FWxFilial("SA1"), _Cli, _lojCli)
    else
        lTemCLi := .F.
    endif
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
    Else		
      
		//Adiciona os dados do ExecAuto
        _cNumPed := GetSXENum("SC5","C5_NUM") //jJson:GetJsonObject("NUMPV") 

        aadd(aCab, {"C5_NUM"       , _cNumPed   ,Nil})
        aadd(aCab, {"C5_EMISSAO"   , ddatabase  ,Nil})
        aadd(aCab, {"C5_CLIENTE"   , _Cli       , nIL})    //jJson:GetJsonObject("CLIENTE"), Nil})
        aadd(aCab, {"C5_LOJACLI"   , _lojCli    , nIL})    //jJson:GetJsonObject("LOJA"), Nil})
        aadd(aCab, {"C5_LOJAENT"   , jJson:GetJsonObject("LOJAENTREGA"), Nil})
        aadd(aCab, {"C5_CONDPAG"   , jJson:GetJsonObject("COND"), Nil})
        aadd(aCab, {"C5_NATUREZ"   , jJson:GetJsonObject("NATUREZA"), Nil})
        aadd(aCab, {"C5_ZINTEGR"   , jJson:GetJsonObject("INTEGRADO"), Nil})
        aadd(aCab, {"C5_INDPRES"   , jJson:GetJsonObject("INDICAPRES"), Nil})
        aadd(aCab, {"C5_TPFRETE"   , jJson:GetJsonObject("TIPOFRETE"), Nil})
        aadd(aCab, {"C5_MENNOTA"   , jJson:GetJsonObject("MENSAGENOTA"), Nil})
        aadd(aCab, {"C5_DESC01"    , jJson:GetJsonObject("DESCONTO"), NIL})
        aadd(aCab, {"C5_ZEXTID"    , jJson:GetJsonObject("EXTERNID"), Nil})

        FOR Nx := 1 to len(jJson:GetJsonObject("ITENS"))
            aLinhaC1 := {}
            if (jJson:GetJsonObject("DESCONTO") > 0) .AND. nX == 1
                nTotal := (jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("QUANT") * jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("PRECO")) - jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("DESCONTO")
            else
                nTotal := (jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("QUANT") * jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("PRECO"))
            Endif

            cProdut := jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("PRODUTO")
            cOperac := jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("OPERACAO")
            cTes    := oWS:TesPDV(cProdut, _Cli, _lojCli, cOperac) //MaTesInt(2, cOperac, _Cli, _lojCli,"C",cProdut,"C6_TES")
            
            aadd(aLinhaC1, {"C6_ITEM"     , Strzero(Nx,4)               ,nil})
            aadd(aLinhaC1, {"C6_PRODUTO"  , jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("PRODUTO"), NIL})
            aadd(aLinhaC1, {"C6_QTDVEN"   , jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("QUANT"), NIL})
            aadd(aLinhaC1, {"C6_QTDLIB"   , jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("QUANT"), NIL})
            aadd(aLinhaC1, {"C6_PRCVEN"   , jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("PRECO"), NIL})
            aadd(aLinhaC1, {"C6_VALOR"    , nTotal, Nil }) //jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("TOTAL"), NIL})
            aadd(aLinhaC1, {"C6_OPER"     , jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("OPERACAO"), NIL})
            aadd(aLinhaC1, {"C6_TES"      , cTes , NIL})
            //aadd(aLinhaC1, {"C6_TES"      , jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("TES"), NIL})
            aadd(aItens,aLinhaC1)
        Next
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
		EndIf

    EndIf
    rpcClearEnv()
    //Define o retorno
    Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
Return lRet

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
    aClient := oWS:pgClient(jJson:GetJsonObject("CNPJ"))  //16/07/2025 - inclusão do CNPJ
    _Cli    := aClient[1,1] //jJson:GetJsonObject("CLIENTE")
    _lojCli := aClient[1,2] //jJson:GetJsonObject("LOJA")
    //VALIDAÇÃO DO CLIENTE PELO cnpj

    cEmpAt := Iif(EMPTY(jJson:GetJsonObject("GRUPO") ), "01", jJson:GetJsonObject("GRUPO" ))
    cFilAt := Iif(EMPTY(jJson:GetJsonObject("FILIAL")), "01", jJson:GetJsonObject("FILIAL"))
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
        _cNumPed := jJson:GetJsonObject("NUMPV") 

        aadd(aCab, {"C5_NUM"       , _cNumPed   ,Nil})
        aadd(aCab, {"C5_EMISSAO"   , ddatabase  ,Nil})
        aadd(aCab, {"C5_CLIENTE"   , _Cli       , nIL})    //jJson:GetJsonObject("CLIENTE"), Nil})
        aadd(aCab, {"C5_LOJACLI"   , _lojCli    , nIL})    //jJson:GetJsonObject("LOJA"), Nil})
        aadd(aCab, {"C5_LOJAENT"   , jJson:GetJsonObject("LOJAENTREGA"), Nil})
        aadd(aCab, {"C5_CONDPAG"   , jJson:GetJsonObject("COND"), Nil})
        aadd(aCab, {"C5_NATUREZ"   , jJson:GetJsonObject("NATUREZA"), Nil})
        aadd(aCab, {"C5_ZINTEGR"   , jJson:GetJsonObject("INTEGRADO"), Nil})
        aadd(aCab, {"C5_INDPRES"   , jJson:GetJsonObject("INDICAPRES"), Nil})
        aadd(aCab, {"C5_TPFRETE"   , jJson:GetJsonObject("TIPOFRETE"), Nil})
        aadd(aCab, {"C5_MENNOTA"   , jJson:GetJsonObject("MENSAGENOTA"), Nil})
        aadd(aCab, {"C5_DESC01"    , jJson:GetJsonObject("DESCONTO"), NIL})
        aadd(aCab, {"C5_ZEXTID"    , jJson:GetJsonObject("EXTERNID"), Nil})

        FOR Nx := 1 to len(jJson:GetJsonObject("ITENS"))
            aLinhaC1 := {}

            if (jJson:GetJsonObject("DESCONTO") > 0) .AND. nX == 1
                nTotal := (jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("QUANT") * jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("PRECO")) - jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("DESCONTO")
            else
                nTotal := (jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("QUANT") * jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("PRECO"))
            Endif

            aadd(aLinhaC1, {"C6_ITEM"     ,Strzero(Nx,4)               ,nil})
            aadd(aLinhaC1, {"C6_PRODUTO"  , jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("PRODUTO"), NIL})
            aadd(aLinhaC1, {"C6_QTDVEN"   , jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("QUANT"), NIL})
            aadd(aLinhaC1, {"C6_PRCVEN"   , jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("PRECO"), NIL})
            //aadd(aLinhaC1, {"C6_VALOR"    , jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("TOTAL"), NIL})
            aadd(aLinhaC1, {"C6_VALOR"    , nTotal, Nil }) //jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("TOTAL"), NIL})
            aadd(aLinhaC1, {"C6_TES"      , jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("TES"), NIL})
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

    //VALIDAÇÃO DO CLIENTE PELO cnpj
    aClient := oWS:pgClient(jJson:GetJsonObject("CNPJ"))  //16/07/2025 - inclusão do CNPJ
    _Cli    := aClient[1,1] //jJson:GetJsonObject("CLIENTE")
    _lojCli := aClient[1,2] //jJson:GetJsonObject("LOJA")
    //VALIDAÇÃO DO CLIENTE PELO cnpj

    cEmpAt := Iif(EMPTY(jJson:GetJsonObject("GRUPO") ), "01", jJson:GetJsonObject("GRUPO" ))
    cFilAt := Iif(EMPTY(jJson:GetJsonObject("FILIAL")), "01", jJson:GetJsonObject("FILIAL"))
    rpcSetEnv(cEmpAt, cFilAt)

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
        _cNumPed := jJson:GetJsonObject("NUMPV") 
		
        aadd(aCab, {"C5_NUM"       , _cNumPed   ,Nil})
        aadd(aCab, {"C5_EMISSAO"   , ddatabase  ,Nil})
        aadd(aCab, {"C5_CLIENTE"   , _Cli       , nIL})    //jJson:GetJsonObject("CLIENTE"), Nil})
        aadd(aCab, {"C5_LOJACLI"   , _lojCli    , nIL})    //jJson:GetJsonObject("LOJA"), Nil})
        aadd(aCab, {"C5_LOJAENT"   , jJson:GetJsonObject("LOJAENTREGA"), Nil})
        aadd(aCab, {"C5_CONDPAG"   , jJson:GetJsonObject("COND"), Nil})
        aadd(aCab, {"C5_NATUREZ"   , jJson:GetJsonObject("NATUREZA"), Nil})
        aadd(aCab, {"C5_ZINTEGR"   , jJson:GetJsonObject("INTEGRADO"), Nil})
        aadd(aCab, {"C5_INDPRES"   , jJson:GetJsonObject("INDICAPRES"), Nil})
        aadd(aCab, {"C5_TPFRETE"   , jJson:GetJsonObject("TIPOFRETE"), Nil})
        aadd(aCab, {"C5_MENNOTA"   , jJson:GetJsonObject("MENSAGENOTA"), Nil})
        aadd(aCab, {"C5_DESC01"    , jJson:GetJsonObject("DESCONTO"), NIL})

        FOR Nx := 1 to len(jJson:GetJsonObject("ITENS"))
            aLinhaC1 := {}

            if (jJson:GetJsonObject("DESCONTO") > 0) .AND. nX == 1
                nTotal := (jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("QUANT") * jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("PRECO")) - jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("DESCONTO")
            else
                nTotal := (jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("QUANT") * jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("PRECO"))
            Endif

            aadd(aLinhaC1, {"C6_ITEM"     ,Strzero(Nx,4)               ,nil})
            aadd(aLinhaC1, {"C6_PRODUTO"  , jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("PRODUTO"), NIL})
            aadd(aLinhaC1, {"C6_QTDVEN"   , jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("QUANT"), NIL})
            aadd(aLinhaC1, {"C6_PRCVEN"   , jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("PRECO"), NIL})
            //aadd(aLinhaC1, {"C6_VALOR"    , jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("TOTAL"), NIL})
            aadd(aLinhaC1, {"C6_VALOR"    , nTotal, Nil }) //jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("TOTAL"), NIL})
            aadd(aLinhaC1, {"C6_TES"      , jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("TES"), NIL})
            aadd(aItens,aLinhaC1)
        Next
        aRetGrv := oWS:pedVendas(aCab, aItens, 5, _cNumPed) //pedCompra(aCab, aItens, 3) 

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
