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
 
    //Métodos
    WSMETHOD GET    ID     DESCRIPTION 'Retorna o registro pesquisado' WSSYNTAX '/WSPEDVEND/{NUMPV}'                  PATH '{NUMPV}'       PRODUCES APPLICATION_JSON
    WSMETHOD POST   NEW    DESCRIPTION 'Inclusão de registro'          WSSYNTAX '/WSPEDVEND/new'                      PATH 'new'           PRODUCES APPLICATION_JSON
    WSMETHOD PUT    UPDATE DESCRIPTION 'Atualização de registro'       WSSYNTAX '/WSPEDVEND/update'                   PATH 'update'        PRODUCES APPLICATION_JSON
    WSMETHOD PUT    ERASE  DESCRIPTION 'Blaqueio de registro'          WSSYNTAX '/WSPEDVEND/bloqu'                    PATH 'bloqu'         PRODUCES APPLICATION_JSON
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
            cQuery += " WHERE C5_FILENT = '" + FWxFilial(cAliasWS) + "' AND SC5.C5_NUM = '"+NUMPV+"' "
            cQuery += " AND SC5.D_E_L_E_T_ = '' "
            cAlSC5:= CriaTrab(Nil,.F.)
            DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSC5, .F., .T.)                
                   
            DO WHILE !((cAlSC5)->(EOF())) .AND. (cAlSC5)->C5_NUM == NUMPV
                    jResponse['NUMPV']          := (cAlSC5)->C5_NUM
                    jResponse['EMISSAO']        := StoD((cAlSC5)->C5_EMISSAO)
                    jResponse['FORNECE']        := (cAlSC5)->C5_CLIENTE
                    jResponse['LOJA']           := (cAlSC5)->C5_LOJACLI
                    jResponse['LOJAENTREGA']    := (cAlSC5)->C5_LOJAENT
                    jResponse['COND']           := (cAlSC5)->C5_CONDPAG
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
    FOR NX := 1 TO LEN(jJson:GetJsonObject("PEDIDO"):GetJsonObject("ITENS"))
	    _cod   := jJson:GetJsonObject("PEDIDO"):GetJsonObject("ITENS")[nX]:GetJsonObject("PRODUTO")
        lTemPr := oWS:temProd(FWxFilial("SB1"), _cod) 
    Next

	IF !lTemPr 
		Self:setStatus(500)
		jResponse['errorId']  := 'NEW0041'
		jResponse['error']    := 'PRODUTO NÃO EXISTE'
		jResponse['solution'] := 'CADASTRE UM PRODUTO QUE DESEJA PEDIR'

		cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
		oWS:GRAVALOGMURO(cResponc, cJason, "WSPEDVEND", "INCLUSAO DE PEDIDO DE VENDAS")
        
        Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
        Return .F.
	EndIF
    _Cli    := jJson:GetJsonObject("PEDIDO"):GetJsonObject("CLIENTE")
    _lojCli := jJson:GetJsonObject("PEDIDO"):GetJsonObject("LOJA")

    lTemCLi := ows:temCliCod(FWxFilial("SA1"), _Cli, _lojCli)
	IF !lTemCLi 
		Self:setStatus(500)
		jResponse['errorId']  := 'NEW0044'
		jResponse['error']    := 'CLIENTE NÃO EXISTE'
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
        jResponse['solution'] := 'Erro ao fazer o Parse do JSON'

		cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
		oWS:GRAVALOGMURO(cResponc, cJason, "WSPEDVEND", "INCLUSÃO DE PEDIDO DE VENDAS")
    Else		
      
		//Adiciona os dados do ExecAuto
        _cNumPed := jJson:GetJsonObject("PEDIDO"):GetJsonObject("NUMPV") 

        aadd(aCab, {"C5_NUM"       , _cNumPed   ,Nil})
        aadd(aCab, {"C5_EMISSAO"   , ddatabase  ,Nil})
        aadd(aCab, {"C5_CLIENTE"   , jJson:GetJsonObject("PEDIDO"):GetJsonObject("CLIENTE"), Nil})
        aadd(aCab, {"C5_LOJACLI"   , jJson:GetJsonObject("PEDIDO"):GetJsonObject("LOJA"), Nil})
        aadd(aCab, {"C5_LOJAENT"   , jJson:GetJsonObject("PEDIDO"):GetJsonObject("LOJAENTREGA"), Nil})
        aadd(aCab, {"C5_CONDPAG"   , jJson:GetJsonObject("PEDIDO"):GetJsonObject("COND"), Nil})
        aadd(aCab, {"C5_NATUREZ"   , jJson:GetJsonObject("PEDIDO"):GetJsonObject("NATUREZA"), Nil})

        FOR Nx := 1 to len(jJson:GetJsonObject("PEDIDO"):GetJsonObject("ITENS"))
            aLinhaC1 := {}
            aadd(aLinhaC1, {"C6_ITEM"     ,Strzero(Nx,4)               ,nil})
            aadd(aLinhaC1, {"C6_PRODUTO"  , jJson:GetJsonObject("PEDIDO"):GetJsonObject("ITENS")[nX]:GetJsonObject("PRODUTO"), NIL})
            aadd(aLinhaC1, {"C6_QTDVEN"   , jJson:GetJsonObject("PEDIDO"):GetJsonObject("ITENS")[nX]:GetJsonObject("QUANT"), NIL})
            aadd(aLinhaC1, {"C6_PRCVEN"   , jJson:GetJsonObject("PEDIDO"):GetJsonObject("ITENS")[nX]:GetJsonObject("PRECO"), NIL})
            aadd(aLinhaC1, {"C6_VALOR"    , jJson:GetJsonObject("PEDIDO"):GetJsonObject("ITENS")[nX]:GetJsonObject("TOTAL"), NIL})
            aadd(aLinhaC1, {"C6_TES"      , jJson:GetJsonObject("PEDIDO"):GetJsonObject("ITENS")[nX]:GetJsonObject("TES"), NIL})
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
			jResponse['solution'] := 'Nao foi possivel incluir o registro, foi gerado um arquivo de log em ' + cDirLog + cArqLog + ' '
			lRet := .F.

			cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
			oWS:GRAVALOGMURO(cResponc, cJason, "WSPEDVEND", "INCLUSAO DE PEDIDO DE VENDAS")

		//Senão, define o retorno
		Else
			jResponse['note']     := 'Registro incluido com sucesso'
		EndIf

    EndIf

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
    FOR NX := 1 TO LEN(jJson:GetJsonObject("PEDIDO"):GetJsonObject("ITENS"))
	    _cod   := jJson:GetJsonObject("PEDIDO"):GetJsonObject("ITENS")[nX]:GetJsonObject("PRODUTO")
        lTemPr := oWS:temProd(FWxFilial("SB1"), _cod)//temFornec(, ::cnpj)
    Next

	IF !lTemPr //oWS:temProd(FWxFilial("SB1"), _cod)//temFornec(, ::cnpj)
		//SetRestFault(500, 'Falha ao obter JSON') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
		Self:setStatus(500)
		jResponse['errorId']  := 'NEW0041'
		jResponse['error']    := 'PRODUTO NÃO EXISTE'
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
        jResponse['errorId']  := 'NEW004'
        jResponse['error']    := 'Parse do JSON'
        jResponse['solution'] := 'Erro ao fazer o Parse do JSON'

		cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
		oWS:GRAVALOGMURO(cResponc, cJason, "WSPEDVEND", "ALTERAÇÃO DE PEDIDO DE VENDAS")
    Else

		//Adiciona os dados do ExecAuto
        _cNumPed := jJson:GetJsonObject("PEDIDO"):GetJsonObject("NUMPV") //GetSx8Num("SC7","C7_NUM")

        aadd(aCab, {"C7_NUM"       , _cNumPed   ,Nil})
        aadd(aCab, {"C7_EMISSAO"   , ddatabase  ,Nil})
        aadd(aCab, {"C7_MOEDA"     , 1			,Nil})
        aadd(aCab, {"C7_TXMOEDA"   , 1			,Nil})
        aadd(aCab, {"C7_FORNECE"   , jJson:GetJsonObject("PEDIDO"):GetJsonObject("FORNECE"), Nil})
        aadd(aCab, {"C7_LOJA"      , jJson:GetJsonObject("PEDIDO"):GetJsonObject("LOJA"), Nil})
        aadd(aCab, {"C7_COND"      , jJson:GetJsonObject("PEDIDO"):GetJsonObject("COND"), Nil})
        aadd(aCab, {"C7_CONTATO"   , jJson:GetJsonObject("PEDIDO"):GetJsonObject("CONTATO"), Nil})
        aadd(aCab, {"C7_FILENT"    , jJson:GetJsonObject("PEDIDO"):GetJsonObject("FILENT"), Nil})

        FOR Nx := 1 to len(jJson:GetJsonObject("PEDIDO"):GetJsonObject("ITENS"))
            aLinhaC1 := {}
            aadd(aLinhaC1, {"C7_PRODUTO" , jJson:GetJsonObject("PEDIDO"):GetJsonObject("ITENS")[nX]:GetJsonObject("PRODUTO"), NIL})
            aadd(aLinhaC1, {"C7_QUANT"   , jJson:GetJsonObject("PEDIDO"):GetJsonObject("ITENS")[nX]:GetJsonObject("QUANT"), NIL})
            aadd(aLinhaC1, {"C7_PRECO"   , jJson:GetJsonObject("PEDIDO"):GetJsonObject("ITENS")[nX]:GetJsonObject("PRECO"), NIL})
            aadd(aLinhaC1, {"C7_TOTAL"   , jJson:GetJsonObject("PEDIDO"):GetJsonObject("ITENS")[nX]:GetJsonObject("TOTAL"), NIL})

            cUM    := POSICIONE("SB1",1,xFilial("SB1")+jJson:GetJsonObject("PEDIDO"):GetJsonObject("ITENS")[nX]:GetJsonObject("PRODUTO"),"B1_UM")
            cDesc  := POSICIONE("SB1",1,xFilial("SB1")+jJson:GetJsonObject("PEDIDO"):GetJsonObject("ITENS")[nX]:GetJsonObject("PRODUTO"),"B1_DESC")

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
			//Monta o texto do Error Log que será salvo
			cErrorLog   := ''
			aLogAuto    := aRetGrv // GetAutoGrLog()
			For nLinha := 1 To Len(aLogAuto)
				cErrorLog += aLogAuto[nLinha] + CRLF
			Next nLinha

			//Grava o arquivo de log
			cArqLog := 'WSPEDVEND_upd_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
			MemoWrite(cDirLog + cArqLog, cErrorLog)

			//Define o retorno para o WebService
			//SetRestFault(500, cErrorLog) //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
           Self:setStatus(500) 
			jResponse['errorId']  := 'NEW005'
			jResponse['error']    := 'Erro na inclusão do registro'
			jResponse['solution'] := 'Nao foi possivel alterar o registro, foi gerado um arquivo de log em ' + cDirLog + cArqLog + ' '
			lRet := .F.

			cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
			oWS:GRAVALOGMURO(cResponc, cJason, "WSPEDVEND", "ALTERAÇÃO DE PEDIDO DE VENDAS")

		//Senão, define o retorno
		Else
			jResponse['note']     := 'Registro alterado com sucesso'
		EndIf

    EndIf

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
    FOR NX := 1 TO LEN(jJson:GetJsonObject("PEDIDO"):GetJsonObject("ITENS"))
	    _cod   := jJson:GetJsonObject("PEDIDO"):GetJsonObject("ITENS")[nX]:GetJsonObject("PRODUTO")
        lTemPr := oWS:temProd(FWxFilial("SB1"), _cod)//temFornec(, ::cnpj)
    Next

	IF !lTemPr //oWS:temProd(FWxFilial("SB1"), _cod)//temFornec(, ::cnpj)
		//SetRestFault(500, 'Falha ao obter JSON') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
		Self:setStatus(500)
		jResponse['errorId']  := 'NEW0041'
		jResponse['error']    := 'PRODUTO NÃO EXISTE'
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
        jResponse['errorId']  := 'NEW004'
        jResponse['error']    := 'Parse do JSON'
        jResponse['solution'] := 'Erro ao fazer o Parse do JSON'

		cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
		oWS:GRAVALOGMURO(cResponc, cJason, "WSPEDVEND", "EXCLUSÃO DE PEDIDO DE VENDAS")
    Else
		
		//Adiciona os dados do ExecAuto
        _cNumPed := jJson:GetJsonObject("PEDIDO"):GetJsonObject("NUMPV") //GetSx8Num("SC7","C7_NUM")

        aadd(aCab, {"C7_NUM"       , _cNumPed   ,Nil})
        aadd(aCab, {"C7_EMISSAO"   , ddatabase  ,Nil})
        aadd(aCab, {"C7_MOEDA"     , 1			,Nil})
        aadd(aCab, {"C7_TXMOEDA"   , 1			,Nil})
        aadd(aCab, {"C7_FORNECE"   , jJson:GetJsonObject("PEDIDO"):GetJsonObject("FORNECE"), Nil})
        aadd(aCab, {"C7_LOJA"      , jJson:GetJsonObject("PEDIDO"):GetJsonObject("LOJA"), Nil})
        aadd(aCab, {"C7_COND"      , jJson:GetJsonObject("PEDIDO"):GetJsonObject("COND"), Nil})
        aadd(aCab, {"C7_CONTATO"   , jJson:GetJsonObject("PEDIDO"):GetJsonObject("CONTATO"), Nil})
        aadd(aCab, {"C7_FILENT"    , jJson:GetJsonObject("PEDIDO"):GetJsonObject("FILENT"), Nil})

        FOR Nx := 1 to len(jJson:GetJsonObject("PEDIDO"):GetJsonObject("ITENS"))
            aLinhaC1 := {}
            aadd(aLinhaC1, {"C7_PRODUTO" , jJson:GetJsonObject("PEDIDO"):GetJsonObject("ITENS")[nX]:GetJsonObject("PRODUTO"), NIL})
            aadd(aLinhaC1, {"C7_QUANT"   , jJson:GetJsonObject("PEDIDO"):GetJsonObject("ITENS")[nX]:GetJsonObject("QUANT"), NIL})
            aadd(aLinhaC1, {"C7_PRECO"   , jJson:GetJsonObject("PEDIDO"):GetJsonObject("ITENS")[nX]:GetJsonObject("PRECO"), NIL})
            aadd(aLinhaC1, {"C7_TOTAL"   , jJson:GetJsonObject("PEDIDO"):GetJsonObject("ITENS")[nX]:GetJsonObject("TOTAL"), NIL})

            cUM    := POSICIONE("SB1",1,xFilial("SB1")+jJson:GetJsonObject("PEDIDO"):GetJsonObject("ITENS")[nX]:GetJsonObject("PRODUTO"),"B1_UM")
            cDesc  := POSICIONE("SB1",1,xFilial("SB1")+jJson:GetJsonObject("PEDIDO"):GetJsonObject("ITENS")[nX]:GetJsonObject("PRODUTO"),"B1_DESC")

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
			//Monta o texto do Error Log que será salvo
			cErrorLog   := ''
			aLogAuto    := aRetGrv // GetAutoGrLog()
			For nLinha := 1 To Len(aLogAuto)
				cErrorLog += aLogAuto[nLinha] + CRLF
			Next nLinha

			//Grava o arquivo de log
			cArqLog := 'WSPEDVEND_New_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
			MemoWrite(cDirLog + cArqLog, cErrorLog)

			//Define o retorno para o WebService
			//SetRestFault(500, cErrorLog) //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
           Self:setStatus(500) 
			jResponse['errorId']  := 'NEW005'
			jResponse['error']    := 'Erro na inclusão do registro'
			jResponse['solution'] := 'Nao foi possivel excluir o registro, foi gerado um arquivo de log em ' + cDirLog + cArqLog + ' '
			lRet := .F.

			cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
			oWS:GRAVALOGMURO(cResponc, cJason, "WSPEDVEND", "EXCLUSÃO DE PEDIDO DE VENDAS")

		//Senão, define o retorno
		Else
			jResponse['note']     := 'Registro excluido com sucesso'
		EndIf

    EndIf

    //Define o retorno
    Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
Return lRet
