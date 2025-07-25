//Bibliotecas
#Include "Totvs.ch"
#Include "RESTFul.ch"
#Include "TopConn.ch"
#Include 'Protheus.ch'
#INCLUDE 'APWEBSRV.CH'

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

	//M�todos
	WSMETHOD GET PDC DESCRIPTION "Retorna lista de Pedidos de Compras" WSSYNTAX "/WSPEDCOM/pdcs " PATH '/WSPEDCOM/pdcs' PRODUCES APPLICATION_JSON
  
    //M�todos
    WSMETHOD GET ID      DESCRIPTION 'Retorna o registro pesquisado'                WSSYNTAX '/WSPEDCOM/{NUMPC}'        PATH '{NUMPC}'      PRODUCES APPLICATION_JSON
	WSMETHOD GET INTEGRA DESCRIPTION 'Retorna o registro pesquisado - INTEGRADO'   	WSSYNTAX '/WSPEDCOM/integrado' 		PATH '/integrado'  	PRODUCES APPLICATION_JSON

    WSMETHOD POST   NEW    DESCRIPTION 'Inclus�o de registro'          WSSYNTAX '/WSPEDCOM/new'                      PATH 'new'           PRODUCES APPLICATION_JSON
    WSMETHOD PUT    UPDATE DESCRIPTION 'Atualiza��o de registro'       WSSYNTAX '/WSPEDCOM/update'                   PATH 'update'        PRODUCES APPLICATION_JSON
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
    Local NUMPC			 := self:aUrlParms[1]
	oWS    := LIBGLASS():new()

    //Se o id estiver vazio
    If Empty(NUMPC)
        //SetRestFault(500, 'Falha ao consultar o registro') //caso queira usar esse comando, voc� n�o poder� usar outros retornos, como os abaixo
        Self:setStatus(500) 
        jResponse['errorId']  := 'ID001'
        jResponse['error']    := 'ID vazio'
        jResponse['solution'] := 'Informe o ID'
    Else
        DbSelectArea(cAliasWS)
        (cAliasWS)->(DbSetOrder(1))

        //Se n�o encontrar o registro
        If !(cAliasWS)->(MsSeek(FWxFilial(cAliasWS) + NUMPC))
            //SetRestFault(500, 'Falha ao consultar ID') //caso queira usar esse comando, voc� n�o poder� usar outros retornos, como os abaixo
            Self:setStatus(500) 
            jResponse['errorId']  := 'ID002'
            jResponse['error']    := 'PD ('+NUMPC+') n�o encontrado'
            jResponse['solution'] := 'C�digo PD n�o encontrado na tabela ' + cAliasWS
        Else

            cQuery := " SELECT * "
            cQuery += " FROM "+RetSQLName("SC7") + " AS SC7 WITH (NOLOCK) "
            cQuery += " WHERE C7_FILENT = '" + FWxFilial(cAliasWS) + "' AND SC7.C7_NUM = '"+NUMPC+"' "
            cQuery += " AND SC7.D_E_L_E_T_ = '' "
            cAlSC7:= CriaTrab(Nil,.F.)
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
		jResponse['error']    := 'N�o ha dados a serem integrados'
		jResponse['solution'] := 'N�o ha dados a Integrar'

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

    Private lMsErroAuto     := .F.
    Private lMsHelpAuto     := .T.
    Private lAutoErrNoFile  := .T.

	oWS    := LIBGLASS():new()
 
    //Se n�o existir a pasta de logs, cria
    IF ! ExistDir(cDirLog)
        MakeDir(cDirLog)
    EndIF    

    //Definindo o conte�do como JSON, e pegando o content e dando um parse para ver se a estrutura est� ok
    Self:SetContentType('application/json')
    jJson  := JsonObject():New()
    cError := jJson:FromJson(cJson)
	cJason := cJson
    lTemPr := .T.
    FOR NX := 1 TO LEN(jJson:GetJsonObject("ITENS"))
	    _cod   := jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("PRODUTO")
        lTemPr := oWS:temProd(FWxFilial("SB1"), _cod)//temFornec(, ::cnpj)
    Next

	IF !lTemPr //oWS:temProd(FWxFilial("SB1"), _cod)//temFornec(, ::cnpj)
		//SetRestFault(500, 'Falha ao obter JSON') //caso queira usar esse comando, voc� n�o poder� usar outros retornos, como os abaixo
		Self:setStatus(500)
		jResponse['errorId']  := 'NEW0041'
		jResponse['error']    := 'PRODUTO N�O EXISTE'
        jResponse['errorLog'] := cErrorLog
		jResponse['solution'] := 'CADASTRE UM PRODUTO QUE DESEJA PEDIR'

		cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
		oWS:GRAVALOGMURO(cResponc, cJason, "WSPEDCOM", "INCLUS�O DE PEDIDO DE COMPRAS")
        
        Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
        Return .F.
	EndIF
 
    //Se tiver algum erro no Parse, encerra a execu��o
    IF !Empty(cError)
        //SetRestFault(500, 'Falha ao obter JSON') //caso queira usar esse comando, voc� n�o poder� usar outros retornos, como os abaixo
        Self:setStatus(500) 
        jResponse['errorId']  := 'NEW004'
        jResponse['error']    := 'Parse do JSON'
        jResponse['errorLog'] := cErrorLog
        jResponse['solution'] := 'Erro ao fazer o Parse do JSON'

		cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
		oWS:GRAVALOGMURO(cResponc, cJason, "WSPEDCOM", "INCLUS�O DE PEDIDO DE COMPRAS")
    Else		
      
		//Adiciona os dados do ExecAuto
        _cNumPed := jJson:GetJsonObject("NUMPC") //GetSx8Num("SC7","C7_NUM")
        cTes     := jJson:GetJsonObject("TES")

        aadd(aCab, {"C7_NUM"       , _cNumPed   ,Nil})
        aadd(aCab, {"C7_EMISSAO"   , ddatabase  ,Nil})
        aadd(aCab, {"C7_MOEDA"     , 1			,Nil})
        aadd(aCab, {"C7_TXMOEDA"   , 1			,Nil})
        aadd(aCab, {"C7_FORNECE"   , jJson:GetJsonObject("FORNECE"), Nil})
        aadd(aCab, {"C7_LOJA"      , jJson:GetJsonObject("LOJA"), Nil})
        aadd(aCab, {"C7_COND"      , jJson:GetJsonObject("COND"), Nil})
        aadd(aCab, {"C7_CONTATO"   , jJson:GetJsonObject("CONTATO"), Nil})
        aadd(aCab, {"C7_FILENT"    , jJson:GetJsonObject("FILENT"), Nil})
        aadd(aCab, {"C7_ZINTEGR"   , jJson:GetJsonObject("INTEGRADO"), Nil})
        IF !Empty(cTes)
            aadd(aCab, {"C7_TES"       , jJson:GetJsonObject("TES"), Nil})
        EndIF
                            
        FOR Nx := 1 to len(jJson:GetJsonObject("ITENS"))
            aLinhaC1 := {}
            aadd(aLinhaC1, {"C7_PRODUTO" , jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("PRODUTO"), NIL})
            aadd(aLinhaC1, {"C7_QUANT"   , jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("QUANT"), NIL})
            aadd(aLinhaC1, {"C7_PRECO"   , jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("PRECO"), NIL})
            aadd(aLinhaC1, {"C7_TOTAL"   , jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("TOTAL"), NIL})

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
            aadd(aItens,aLinhaC1)
        Next
        aRetGrv := oWS:pedCompra(aCab, aItens, 3) 

		If !aRetGrv[1,2] //lMsErroAuto
			//Monta o texto do Error Log que ser� salvo
			cErrorLog   := ''
			aLogAuto    := aRetGrv // GetAutoGrLog()
			For nLinha := 1 To Len(aLogAuto)
				cErrorLog += aLogAuto[nLinha] + CRLF
			Next nLinha

			//Grava o arquivo de log
			cArqLog := 'WSPEDCOM_New_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
			MemoWrite(cDirLog + cArqLog, cErrorLog)

			//Define o retorno para o WebService
			//SetRestFault(500, cErrorLog) //caso queira usar esse comando, voc� n�o poder� usar outros retornos, como os abaixo
           Self:setStatus(500) 
			jResponse['errorId']  := 'NEW005'
			jResponse['error']    := 'Erro na inclus�o do registro'
			jResponse['errorLog'] := cErrorLog
			jResponse['solution'] := 'Nao foi possivel incluir o registro, foi gerado um arquivo de log em ' + cDirLog + cArqLog + ' '
			lRet := .F.

			cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
			oWS:GRAVALOGMURO(cResponc, cJason, "WSPEDCOM", "INCLUS�O DE PEDIDO DE COMPRAS")

		//Sen�o, define o retorno
		Else
			jResponse['note']     := 'Registro incluido com sucesso'
		EndIf

    EndIf

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
 
    //Se n�o existir a pasta de logs, cria
    IF ! ExistDir(cDirLog)
        MakeDir(cDirLog)
    EndIF    

    //Definindo o conte�do como JSON, e pegando o content e dando um parse para ver se a estrutura est� ok
    Self:SetContentType('application/json')
    jJson  := JsonObject():New()
    cError := jJson:FromJson(cJson)
	cJason := cJson
    lTemPr := .T.
    FOR NX := 1 TO LEN(jJson:GetJsonObject("ITENS"))
	    _cod   := jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("PRODUTO")
        lTemPr := oWS:temProd(FWxFilial("SB1"), _cod)//temFornec(, ::cnpj)
    Next

	IF !lTemPr //oWS:temProd(FWxFilial("SB1"), _cod)//temFornec(, ::cnpj)
		//SetRestFault(500, 'Falha ao obter JSON') //caso queira usar esse comando, voc� n�o poder� usar outros retornos, como os abaixo
		Self:setStatus(500)
		jResponse['errorId']  := 'UPD010'
		jResponse['error']    := 'PRODUTO N�O EXISTE'
        jResponse['errorLog'] := cErrorLog
		jResponse['solution'] := 'CADASTRE UM PRODUTO QUE DESEJA SOLICITAR'

		cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
		oWS:GRAVALOGMURO(cResponc, cJason, "WSPEDCOM", "ALTERA��O DE PEDIDO DE COMPRAS")
        
        Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
        Return .F.
	EndIF
 
    //Se tiver algum erro no Parse, encerra a execu��o
    IF !Empty(cError)
        //SetRestFault(500, 'Falha ao obter JSON') //caso queira usar esse comando, voc� n�o poder� usar outros retornos, como os abaixo
        Self:setStatus(500) 
        jResponse['errorId']  := 'UPD008'
        jResponse['error']    := 'Parse do JSON'
        jResponse['errorLog'] := cErrorLog
        jResponse['solution'] := 'Erro ao fazer o Parse do JSON'

		cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
		oWS:GRAVALOGMURO(cResponc, cJason, "WSPEDCOM", "ALTERA��O DE PEDIDO DE COMPRAS")
    Else

		//Adiciona os dados do ExecAuto
        _cNumPed := jJson:GetJsonObject("NUMPC") //GetSx8Num("SC7","C7_NUM")

        aadd(aCab, {"C7_NUM"       , _cNumPed   ,Nil})
        aadd(aCab, {"C7_EMISSAO"   , ddatabase  ,Nil})
        aadd(aCab, {"C7_MOEDA"     , 1			,Nil})
        aadd(aCab, {"C7_TXMOEDA"   , 1			,Nil})
        aadd(aCab, {"C7_FORNECE"   , jJson:GetJsonObject("FORNECE"), Nil})
        aadd(aCab, {"C7_LOJA"      , jJson:GetJsonObject("LOJA"), Nil})
        aadd(aCab, {"C7_COND"      , jJson:GetJsonObject("COND"), Nil})
        aadd(aCab, {"C7_CONTATO"   , jJson:GetJsonObject("CONTATO"), Nil})
        aadd(aCab, {"C7_FILENT"    , jJson:GetJsonObject("FILENT"), Nil})
        aadd(aCab, {"C7_ZINTEGR"   , jJson:GetJsonObject("INTEGRADO"), Nil})

        FOR Nx := 1 to len(jJson:GetJsonObject("ITENS"))
            aLinhaC1 := {}
            aadd(aLinhaC1, {"C7_PRODUTO" , jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("PRODUTO"), NIL})
            aadd(aLinhaC1, {"C7_QUANT"   , jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("QUANT"), NIL})
            aadd(aLinhaC1, {"C7_PRECO"   , jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("PRECO"), NIL})
            aadd(aLinhaC1, {"C7_TOTAL"   , jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("TOTAL"), NIL})

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
            aadd(aItens,aLinhaC1)
        Next
        aRetGrv := oWS:pedCompra(aCab, aItens, 4) 

		If !aRetGrv[1,2] //lMsErroAuto
			//Monta o texto do Error Log que ser� salvo
			cErrorLog   := ''
			aLogAuto    := aRetGrv // GetAutoGrLog()
			For nLinha := 1 To Len(aLogAuto)
				cErrorLog += aLogAuto[nLinha,1] + CRLF
			Next nLinha

			//Grava o arquivo de log
			cArqLog := 'WSPEDCOM_upd_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
			MemoWrite(cDirLog + cArqLog, cErrorLog)

			//Define o retorno para o WebService
			//SetRestFault(500, cErrorLog) //caso queira usar esse comando, voc� n�o poder� usar outros retornos, como os abaixo
           Self:setStatus(500) 
			jResponse['errorId']  := 'UPD009'
			jResponse['error']    := 'Erro na Alteracao do registro'
			jResponse['errorLog'] := cErrorLog
			jResponse['solution'] := 'Nao foi possivel alterar o registro, foi gerado um arquivo de log em ' + cDirLog + cArqLog + ' '
			lRet := .F.

			cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
			oWS:GRAVALOGMURO(cResponc, cJason, "WSPEDCOM", "ALTERA��O DE PEDIDO DE COMPRAS")

		//Sen�o, define o retorno
		Else
			jResponse['note']     := 'Registro alterado com sucesso'
		EndIf

    EndIf

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

    Private lMsErroAuto     := .F.
    Private lMsHelpAuto     := .T.
    Private lAutoErrNoFile  := .T.

	oWS    := LIBGLASS():new()
 
    //Se n�o existir a pasta de logs, cria
    IF ! ExistDir(cDirLog)
        MakeDir(cDirLog)
    EndIF    

    //Definindo o conte�do como JSON, e pegando o content e dando um parse para ver se a estrutura est� ok
    Self:SetContentType('application/json')
    jJson  := JsonObject():New()
    cError := jJson:FromJson(cJson)
	cJason := cJson
    lTemPr := .T.
    FOR NX := 1 TO LEN(jJson:GetJsonObject("ITENS"))
	    _cod   := jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("PRODUTO")
        lTemPr := oWS:temProd(FWxFilial("SB1"), _cod)//temFornec(, ::cnpj)
    Next

	IF !lTemPr //oWS:temProd(FWxFilial("SB1"), _cod)//temFornec(, ::cnpj)
		//SetRestFault(500, 'Falha ao obter JSON') //caso queira usar esse comando, voc� n�o poder� usar outros retornos, como os abaixo
		Self:setStatus(500)
		jResponse['errorId']  := 'DEL014'
		jResponse['error']    := 'PRODUTO N�O EXISTE'
        jResponse['errorLog'] := cErrorLog
		jResponse['solution'] := 'CADASTRE UM PRODUTO QUE DESEJA SOLICITAR'

		cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
		oWS:GRAVALOGMURO(cResponc, cJason, "WSPEDCOM", "EXCLUS�O DE PEDIDO DE COMPRAS")
        
        Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
        Return .F.
	EndIF
 
    //Se tiver algum erro no Parse, encerra a execu��o
    IF !Empty(cError)
        //SetRestFault(500, 'Falha ao obter JSON') //caso queira usar esse comando, voc� n�o poder� usar outros retornos, como os abaixo
        Self:setStatus(500) 
        jResponse['errorId']  := 'DEL012'
        jResponse['error']    := 'Parse do JSON'
        jResponse['errorLog'] := cErrorLog
        jResponse['solution'] := 'Erro ao fazer o Parse do JSON'

		cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
		oWS:GRAVALOGMURO(cResponc, cJason, "WSPEDCOM", "EXCLUS�O DE PEDIDO DE COMPRAS")
    Else
		
		//Adiciona os dados do ExecAuto
        _cNumPed := jJson:GetJsonObject("NUMPC") //GetSx8Num("SC7","C7_NUM")

        aadd(aCab, {"C7_NUM"       , _cNumPed   ,Nil})
        aadd(aCab, {"C7_EMISSAO"   , ddatabase  ,Nil})
        aadd(aCab, {"C7_MOEDA"     , 1			,Nil})
        aadd(aCab, {"C7_TXMOEDA"   , 1			,Nil})
        aadd(aCab, {"C7_FORNECE"   , jJson:GetJsonObject("FORNECE"), Nil})
        aadd(aCab, {"C7_LOJA"      , jJson:GetJsonObject("LOJA"), Nil})
        aadd(aCab, {"C7_COND"      , jJson:GetJsonObject("COND"), Nil})
        aadd(aCab, {"C7_CONTATO"   , jJson:GetJsonObject("CONTATO"), Nil})
        aadd(aCab, {"C7_FILENT"    , jJson:GetJsonObject("FILENT"), Nil})
        aadd(aCab, {"C7_ZINTEGR"   , jJson:GetJsonObject("INTEGRADO"), Nil})

        FOR Nx := 1 to len(jJson:GetJsonObject("ITENS"))
            aLinhaC1 := {}
            aadd(aLinhaC1, {"C7_PRODUTO" , jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("PRODUTO"), NIL})
            aadd(aLinhaC1, {"C7_QUANT"   , jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("QUANT"), NIL})
            aadd(aLinhaC1, {"C7_PRECO"   , jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("PRECO"), NIL})
            aadd(aLinhaC1, {"C7_TOTAL"   , jJson:GetJsonObject("ITENS")[nX]:GetJsonObject("TOTAL"), NIL})

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
            aadd(aItens,aLinhaC1)
        Next
        aRetGrv := oWS:pedCompra(aCab, aItens, 5) 

		If !aRetGrv[1,2] //lMsErroAuto
			//Monta o texto do Error Log que ser� salvo
			cErrorLog   := ''
			aLogAuto    := aRetGrv // GetAutoGrLog()
			For nLinha := 1 To Len(aLogAuto)
				cErrorLog += aLogAuto[nLinha] + CRLF
			Next nLinha

			//Grava o arquivo de log
			cArqLog := 'WSPEDCOM_New_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
			MemoWrite(cDirLog + cArqLog, cErrorLog)

			//Define o retorno para o WebService
			//SetRestFault(500, cErrorLog) //caso queira usar esse comando, voc� n�o poder� usar outros retornos, como os abaixo
           Self:setStatus(500) 
			jResponse['errorId']  := 'DEL013'
			jResponse['error']    := 'Erro na exclusao do registro'
			jResponse['errorLog'] := cErrorLog
			jResponse['solution'] := 'Nao foi possivel excluir o registro, foi gerado um arquivo de log em ' + cDirLog + cArqLog + ' '
			lRet := .F.

			cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
			oWS:GRAVALOGMURO(cResponc, cJason, "WSPEDCOM", "EXCLUS�O DE PEDIDO DE COMPRAS")

		//Sen�o, define o retorno
		Else
			jResponse['note']     := 'Registro excluido com sucesso'
		EndIf

    EndIf

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
		// Identifica a quantidade de registro no alias tempor�rio
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
