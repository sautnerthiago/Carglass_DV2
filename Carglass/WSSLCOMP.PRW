//Bibliotecas
#Include "Totvs.ch"
#Include "RESTFul.ch"
#Include "TopConn.ch"
#Include 'Protheus.ch'
#INCLUDE 'APWEBSRV.CH'

/*/{Protheus.doc} WSRESTFUL WSSLCOMP
CADASTRO DE FORNECEDOR
@author JOSE EDILSON DE LIMA PINTO
@since 19/05/2025
@version 1.0
@type wsrestful
/*/

WSSTRUCT ITEMSC

	WSDATA nitem as INTEGER
	WSDATA cCodProd as String
	WSDATA cDescProd as String
	WSDATA nQuant as Float

ENDWSSTRUCT

WSRESTFUL WSSLCOMP DESCRIPTION 'SOLICITAÇÃO DE COMPRAS AUTOMATIZADA'
    //Atributos
    WSDATA numSC       AS STRING
    WSDATA solicitante AS STRING
    WSDATA emissao     AS STRING
    WSDATA item        AS ITEMSC
 
    //Métodos
    WSMETHOD GET    ID     DESCRIPTION 'Retorna o registro pesquisado' WSSYNTAX '/WSSLCOMP/{numSC}'                  PATH '{numSC}'        PRODUCES APPLICATION_JSON
    WSMETHOD POST   NEW    DESCRIPTION 'Inclusão de registro'          WSSYNTAX '/WSSLCOMP/new'                      PATH 'new'           PRODUCES APPLICATION_JSON
    WSMETHOD PUT    UPDATE DESCRIPTION 'Atualização de registro'       WSSYNTAX '/WSSLCOMP/update'                   PATH 'update'        PRODUCES APPLICATION_JSON
    WSMETHOD PUT    ERASE  DESCRIPTION 'Blaqueio de registro'          WSSYNTAX '/WSSLCOMP/bloqu'                    PATH 'bloqu'         PRODUCES APPLICATION_JSON
END WSRESTFUL

/*/{Protheus.doc} WSMETHOD GET ID
Busca registro via ID
@author JOSE EDILSON DE LIMA PINTO
@since 19/05/2025
/*/

WSMETHOD GET ID WSRECEIVE numSC WSSERVICE WSSLCOMP
    Local lRet       := .T.
    Local jResponse  := JsonObject():New()
    Local cAliasWS   := 'SC1'
    Local numSC			 := self:aUrlParms[1]
	oWS    := LIBGLASS():new()

    //Se o id estiver vazio
    If Empty(numSC)
        //SetRestFault(500, 'Falha ao consultar o registro') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
        Self:setStatus(500) 
        jResponse['errorId']  := 'ID001'
        jResponse['error']    := 'ID vazio'
        jResponse['solution'] := 'Informe o ID'
    Else
        DbSelectArea(cAliasWS)
        (cAliasWS)->(DbSetOrder(1))

        //Se não encontrar o registro
        If ! (cAliasWS)->(MsSeek(FWxFilial(cAliasWS) + numSC))
            //SetRestFault(500, 'Falha ao consultar ID') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
            Self:setStatus(500) 
            jResponse['errorId']  := 'ID002'
            jResponse['error']    := 'SC ('+numSC+') não encontrado'
            jResponse['solution'] := 'Código SC não encontrado na tabela ' + cAliasWS
        Else
            //Define o retorno
            jResponse['filial'] 	    := (cAliasWS)->C1_FILIAL 
            jResponse['numSC'] 	    	:= (cAliasWS)->C1_NUM 
            jResponse['solicitante'] 	:= (cAliasWS)->C1_SOLICIT 
            jResponse['emissao'] 		:= DtoC((cAliasWS)->C1_EMISSAO)
            jResponse['integrado']  	:= (cAliasWS)->C1_ZINTEGR
        EndIf
    EndIf

    //Define o retorno
    Self:SetContentType('application/json')
    Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
Return lRet

WSMETHOD POST NEW WSRECEIVE numSC WSSERVICE WSSLCOMP
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
    FOR NX := 1 TO LEN(jJson:GetJsonObject("solicitacao"):GetJsonObject("itens"))
	    _cod   := jJson:GetJsonObject("solicitacao"):GetJsonObject("itens")[nX]:GetJsonObject("codigo")
        lTemPr := oWS:temProd(FWxFilial("SB1"), _cod)//temFornec(, ::cnpj)
    Next

	IF !lTemPr //oWS:temProd(FWxFilial("SB1"), _cod)//temFornec(, ::cnpj)
		//SetRestFault(500, 'Falha ao obter JSON') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
		Self:setStatus(500)
		jResponse['errorId']  := 'NEW0041'
		jResponse['error']    := 'PRODUTO NÃO EXISTE'
		jResponse['solution'] := 'CADASTRE UM PRODUTO QUE DESEJA SOLICITAR'

		cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
		oWS:GRAVALOGMURO(cResponc, cJason, "WSSLCOMP", "INCLUSÃO DE SOLICITAÇÃO DE COMPRAS")
        
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
		oWS:GRAVALOGMURO(cResponc, cJason, "WSSLCOMP", "INCLUSÃO DE SOLICITAÇÃO DE COMPRAS")
    Else
		
      
		//Adiciona os dados do ExecAuto
        aadd(aCab,{"C1_NUM"       , jJson:GetJsonObject("solicitacao"):GetJsonObject("numSC")})
        aadd(aCab,{"C1_SOLICIT"   , jJson:GetJsonObject("solicitacao"):GetJsonObject("solicitante")})
        aadd(aCab,{"C1_EMISSAO"   , Stod(jJson:GetJsonObject("solicitacao"):GetJsonObject("emissao"))})
        aadd(aCab,{"C1_ZINTEGR"   , jJson:GetJsonObject("solicitacao"):GetJsonObject("integrado")})

        FOR Nx := 1 to len(jJson:GetJsonObject("solicitacao"):GetJsonObject("itens"))
            aLinhaC1 := {}
			aadd(aLinhaC1,{"C1_ITEM"   , jJson:GetJsonObject("solicitacao"):GetJsonObject("itens")[nX]:GetJsonObject("item")       ,Nil})
            aadd(aLinhaC1,{"C1_PRODUTO", jJson:GetJsonObject("solicitacao"):GetJsonObject("itens")[nX]:GetJsonObject("codigo")     ,Nil})
            aadd(aLinhaC1,{"C1_QUANT"  , jJson:GetJsonObject("solicitacao"):GetJsonObject("itens")[nX]:GetJsonObject("quantidade") ,Nil})
            aadd(aItens,aLinhaC1)
        Next
        aRetGrv := oWS:SCCompras("", aCab, aItens, 3, "")

		If !aRetGrv[1,2] //lMsErroAuto
			//Monta o texto do Error Log que será salvo
			cErrorLog   := ''
			aLogAuto    := aRetGrv // GetAutoGrLog()
			For nLinha := 1 To Len(aLogAuto)
				cErrorLog += aLogAuto[nLinha] + CRLF
			Next nLinha

			//Grava o arquivo de log
			cArqLog := 'WSSLCOMP_New_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
			MemoWrite(cDirLog + cArqLog, cErrorLog)

			//Define o retorno para o WebService
			//SetRestFault(500, cErrorLog) //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
           Self:setStatus(500) 
			jResponse['errorId']  := 'NEW005'
			jResponse['error']    := 'Erro na inclusão do registro'
			jResponse['solution'] := 'Nao foi possivel incluir o registro, foi gerado um arquivo de log em ' + cDirLog + cArqLog + ' '
			lRet := .F.

			cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
			oWS:GRAVALOGMURO(cResponc, cJason, "WSSLCOMP", "INCLUSÃO DE SOLICITAÇÃO DE COMPRAS")

		//Senão, define o retorno
		Else
			jResponse['note']     := 'Registro incluido com sucesso'
		EndIf

    EndIf

    //Define o retorno
    Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
Return lRet

WSMETHOD PUT UPDATE WSRECEIVE numSC WSSERVICE WSSLCOMP
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
    FOR NX := 1 TO LEN(jJson:GetJsonObject("solicitacao"):GetJsonObject("itens"))
	    _cod   := jJson:GetJsonObject("solicitacao"):GetJsonObject("itens")[nX]:GetJsonObject("codigo")
        lTemPr := oWS:temProd(FWxFilial("SB1"), _cod)//temFornec(, ::cnpj)
    Next

	IF !lTemPr //oWS:temProd(FWxFilial("SB1"), _cod)//temFornec(, ::cnpj)
		//SetRestFault(500, 'Falha ao obter JSON') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
		Self:setStatus(500)
		jResponse['errorId']  := 'NEW0041'
		jResponse['error']    := 'PRODUTO NÃO EXISTE'
		jResponse['solution'] := 'CADASTRE UM PRODUTO QUE DESEJA SOLICITAR'

		cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
		oWS:GRAVALOGMURO(cResponc, cJason, "WSSLCOMP", "ALTERAÇÃO DE SOLICITAÇÃO DE COMPRAS")
        
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
		oWS:GRAVALOGMURO(cResponc, cJason, "WSSLCOMP", "ALTERAÇÃO DE SOLICITAÇÃO DE COMPRAS")
    Else
		
      
		//Adiciona os dados do ExecAuto
        aadd(aCab,{"C1_NUM"       , jJson:GetJsonObject("solicitacao"):GetJsonObject("numSC")})
        aadd(aCab,{"C1_SOLICIT"   , jJson:GetJsonObject("solicitacao"):GetJsonObject("solicitante")})
        aadd(aCab,{"C1_EMISSAO"   , Stod(jJson:GetJsonObject("solicitacao"):GetJsonObject("emissao"))})
        aadd(aCab,{"C1_ZINTEGR"   , jJson:GetJsonObject("solicitacao"):GetJsonObject("integrado")})

        FOR Nx := 1 to len(jJson:GetJsonObject("solicitacao"):GetJsonObject("itens"))
            aLinhaC1 := {}
			aadd(aLinhaC1,{"C1_ITEM"   , jJson:GetJsonObject("solicitacao"):GetJsonObject("itens")[nX]:GetJsonObject("item")       ,Nil})
            aadd(aLinhaC1,{"C1_PRODUTO", jJson:GetJsonObject("solicitacao"):GetJsonObject("itens")[nX]:GetJsonObject("codigo")     ,Nil})
            aadd(aLinhaC1,{"C1_QUANT"  , jJson:GetJsonObject("solicitacao"):GetJsonObject("itens")[nX]:GetJsonObject("quantidade") ,Nil})
            aadd(aItens,aLinhaC1)
        Next
        aRetGrv := oWS:SCCompras("", aCab, aItens, 4, "")

		If !aRetGrv[1,2] //lMsErroAuto
			//Monta o texto do Error Log que será salvo
			cErrorLog   := ''
			aLogAuto    := aRetGrv // GetAutoGrLog()
			For nLinha := 1 To Len(aLogAuto)
				cErrorLog += aLogAuto[nLinha] + CRLF
			Next nLinha

			//Grava o arquivo de log
			cArqLog := 'WSSLCOMP_upd_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
			MemoWrite(cDirLog + cArqLog, cErrorLog)

			//Define o retorno para o WebService
			//SetRestFault(500, cErrorLog) //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
           Self:setStatus(500) 
			jResponse['errorId']  := 'NEW005'
			jResponse['error']    := 'Erro na inclusão do registro'
			jResponse['solution'] := 'Nao foi possivel alterar o registro, foi gerado um arquivo de log em ' + cDirLog + cArqLog + ' '
			lRet := .F.

			cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
			oWS:GRAVALOGMURO(cResponc, cJason, "WSSLCOMP", "ALTERAÇÃO DE SOLICITAÇÃO DE COMPRAS")

		//Senão, define o retorno
		Else
			jResponse['note']     := 'Registro alterado com sucesso'
		EndIf

    EndIf

    //Define o retorno
    Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
Return lRet

WSMETHOD PUT ERASE WSRECEIVE numSC WSSERVICE WSSLCOMP
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
    FOR NX := 1 TO LEN(jJson:GetJsonObject("solicitacao"):GetJsonObject("itens"))
	    _cod   := jJson:GetJsonObject("solicitacao"):GetJsonObject("itens")[nX]:GetJsonObject("codigo")
        lTemPr := oWS:temProd(FWxFilial("SB1"), _cod)//temFornec(, ::cnpj)
    Next

	IF !lTemPr //oWS:temProd(FWxFilial("SB1"), _cod)//temFornec(, ::cnpj)
		//SetRestFault(500, 'Falha ao obter JSON') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
		Self:setStatus(500)
		jResponse['errorId']  := 'NEW0041'
		jResponse['error']    := 'PRODUTO NÃO EXISTE'
		jResponse['solution'] := 'CADASTRE UM PRODUTO QUE DESEJA SOLICITAR'

		cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
		oWS:GRAVALOGMURO(cResponc, cJason, "WSSLCOMP", "EXCLUSÃO DE SOLICITAÇÃO DE COMPRAS")
        
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
		oWS:GRAVALOGMURO(cResponc, cJason, "WSSLCOMP", "EXCLUSÃO DE SOLICITAÇÃO DE COMPRAS")
    Else
		
      
		//Adiciona os dados do ExecAuto
        aadd(aCab,{"C1_NUM"       , jJson:GetJsonObject("solicitacao"):GetJsonObject("numSC")})
        aadd(aCab,{"C1_SOLICIT"   , jJson:GetJsonObject("solicitacao"):GetJsonObject("solicitante")})
        aadd(aCab,{"C1_EMISSAO"   , Stod(jJson:GetJsonObject("solicitacao"):GetJsonObject("emissao"))})
        aadd(aCab,{"C1_ZINTEGR"   , jJson:GetJsonObject("solicitacao"):GetJsonObject("integrado")})

        FOR Nx := 1 to len(jJson:GetJsonObject("solicitacao"):GetJsonObject("itens"))
            aLinhaC1 := {}
			aadd(aLinhaC1,{"C1_ITEM"   , jJson:GetJsonObject("solicitacao"):GetJsonObject("itens")[nX]:GetJsonObject("item")       ,Nil})
            aadd(aLinhaC1,{"C1_PRODUTO", jJson:GetJsonObject("solicitacao"):GetJsonObject("itens")[nX]:GetJsonObject("codigo")     ,Nil})
            aadd(aLinhaC1,{"C1_QUANT"  , jJson:GetJsonObject("solicitacao"):GetJsonObject("itens")[nX]:GetJsonObject("quantidade") ,Nil})
            aadd(aItens,aLinhaC1)
        Next
        aRetGrv := oWS:SCCompras("", aCab, aItens, 5, "")

		If !aRetGrv[1,2] //lMsErroAuto
			//Monta o texto do Error Log que será salvo
			cErrorLog   := ''
			aLogAuto    := aRetGrv // GetAutoGrLog()
			For nLinha := 1 To Len(aLogAuto)
				cErrorLog += aLogAuto[nLinha] + CRLF
			Next nLinha

			//Grava o arquivo de log
			cArqLog := 'WSSLCOMP_New_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
			MemoWrite(cDirLog + cArqLog, cErrorLog)

			//Define o retorno para o WebService
			//SetRestFault(500, cErrorLog) //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
           Self:setStatus(500) 
			jResponse['errorId']  := 'NEW005'
			jResponse['error']    := 'Erro na inclusão do registro'
			jResponse['solution'] := 'Nao foi possivel excluir o registro, foi gerado um arquivo de log em ' + cDirLog + cArqLog + ' '
			lRet := .F.

			cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
			oWS:GRAVALOGMURO(cResponc, cJason, "WSSLCOMP", "EXCLUSÃO DE SOLICITAÇÃO DE COMPRAS")

		//Senão, define o retorno
		Else
			jResponse['note']     := 'Registro excluido com sucesso'
		EndIf

    EndIf

    //Define o retorno
    Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
Return lRet
