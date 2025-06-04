//Bibliotecas
#Include "Totvs.ch"
#Include "RESTFul.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} WSRESTFUL WSPEDVEND
CADASTRO DE FORNECEDOR
@author JOSE EDILSON DE LIMA PINTO
@since 31/05/2025
@version 1.0
@type wsrestful
/*/

WSRESTFUL WSPEDVEND DESCRIPTION 'PEDIDO DE VENDAS'
    //Métodos
    WSMETHOD GET    NUM    DESCRIPTION 'Retorna o registro pesquisado' WSSYNTAX '/WSPEDVEND/{num}'     PATH 'num'        PRODUCES APPLICATION_JSON
    WSMETHOD POST   NEW    DESCRIPTION 'Inclusão de registro'          WSSYNTAX '/WSPEDVEND/new'       PATH 'new'        PRODUCES APPLICATION_JSON
    WSMETHOD PUT    UPDATE DESCRIPTION 'Atualização de registro'       WSSYNTAX '/WSPEDVEND/update'    PATH 'update'     PRODUCES APPLICATION_JSON
    WSMETHOD PUT    ERASE  DESCRIPTION 'Blaoquei de registro'          WSSYNTAX '/WSPEDVEND/bloqu'     PATH 'bloqu'      PRODUCES APPLICATION_JSON
END WSRESTFUL

WSMETHOD GET NUM WSRECEIVE num WSSERVICE WSPEDVEND
    Local lRet       := .T.
    Local jResponse  := JsonObject():New()

	Local cJason			:= ""
	Local cResponc          := ""
	Local lExtFor           := .F.

	oWS    := LIBGLASS():new()

    //Se o id estiver vazio
    If Empty(::NUM)
        Self:setStatus(500) 
        jResponse['errorId']  := 'ID001'
        jResponse['error']    := 'NUM vazio'
        jResponse['solution'] := 'Informe o Pedido'

		cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
		oWS:GRAVALOGMURO(cResponc, cJason, "WSPEDVEND", "NÃO FOI SOLICITADO NUMERO DE PEDIDO DE VENDAS")
		lExtFor := .T.

        Self:SetContentType('application/json')
        Self:SetResponse(EncodeUTF8(jResponse:toJSON()))

    Else    
        cQuery := "SELECT * FROM " +  RetSQLName("SC6")  
        cQuery += "WHERE C6_NUM = '"+NUM+"'  "
        cQuery += "D_E_L_E_T_ = '' "
        TCQUERY cQuery NEW ALIAS "CBC6"

        _cJson  += ' pedido: {
        WHILE !CBC6->(EOF())
            cNomCli := Posicione("SA1", 1, xFilial("SA1")+CBC6->C5_CLIENTE+CBC6->C5_LOJA,"A1_NOME")
            cNomPRD := Posicione("SB1", 1, xFilial("SB1")+CBC6->C6_PRODUTO,"B1_DESC")

            _cJson  += ' "num": "'+Alltrim(CBC6->C6_NUM)+'",'
            _cJson  += ' "codigo": "'+Alltrim(CBC6->C6_CLIENTE)+'",'
            _cJson  += ' "nome": "'+cNomCli+'",'
            _cJson  += ' "loja": "'+CBC6->C6_LOJA+'",  '
            _cJson  += ' "codProduto": "'+CBC6->C6_PRODUTO+'",  '
            _cJson  += ' "descProduto": "'+cNomPRD+'",  '
            _cJson  += ' "qtd": "'+CBC6->C6_QTDVEN+'",  '
            _cJson  += ' "vlrUnit": "'+CBC6->C6_PRCVEN+'",  '
            _cJson  += ' "vlrTotal": "'+CBC6->C6_VALOR+'" } '
            
            CBC6->(DBSKIP())
            
            if !CBC6->(EOF())
                _cJson  += ', {'
            else
                _cJson  += ''
            endif
            LOOP
        ENDDO
        CBC6->(DBCLOSEAREA())

        Self:SetContentType('application/json')
        ::setResponse( _cJson ) //Se tudo ocorreu bem, retorna os dados via Json

    EndIf
Return lRet

WSMETHOD POST NEW WSRECEIVE WSSERVICE WSPEDVEND
    Local lRet              := .T.
    Local aDados            := {}
    Local jJson             := Nil
    Local cJson             := Self:GetContent()
    Local cError            := ''
    Local nLinha            := 0
    Local cDirLog           := '\x_logs\'
    Local cArqLog           := ''
    Local cErrorLog         := ''
    Local aLogAuto          := {}
    Local nCampo            := 0
    Local jResponse         := JsonObject():New()
    Local cAliasWS          := 'SA2'

	Local cJason			:= ""
	Local cResponc          := ""
	Local lExtFor           := .F.

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
	::NUM := jJson:GetJsonObject('NUM')

	IF oWS:temFornec(FWxFilial(cAliasWS), ::NUM)
		//SetRestFault(500, 'Falha ao obter JSON') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
		Self:setStatus(500)
		jResponse['errorId']  := 'NEW0041'
		jResponse['error']    := 'FORNECEDOR JA EXISTE'
		jResponse['solution'] := 'CADASTRE UM FORNECEDOR CUJO NUM NÃO SEJA O MESMO'

		cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
		oWS:GRAVALOGMURO(cResponc, cJason, "WSFORNC", "INCLUSÃO DE FORNECEDOR")
		lExtFor := .T.
	EndIF
 
    //Se tiver algum erro no Parse, encerra a execução
    IF ! Empty(cError)
        //SetRestFault(500, 'Falha ao obter JSON') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
        Self:setStatus(500) 
        jResponse['errorId']  := 'NEW004'
        jResponse['error']    := 'Parse do JSON'
        jResponse['solution'] := 'Erro ao fazer o Parse do JSON'

		cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
		oWS:GRAVALOGMURO(cResponc, cJason, "WSFORNC", "INCLUSÃO DE FORNECEDOR")
    Else
		DbSelectArea(cAliasWS)
       
		//Adiciona os dados do ExecAuto
		aAdd(aDados, {'A2_FILIAL' , FWCodFil()                      , Nil} )
		aAdd(aDados, {'A2_COD'    , jJson:GetJsonObject('CODIGO')   , Nil} )
		aAdd(aDados, {'A2_LOJA'   , jJson:GetJsonObject('LOJA')     , Nil} )
		aAdd(aDados, {'A2_NOME'   , jJson:GetJsonObject('NOME')     , Nil} )
		aAdd(aDados, {'A2_NREDUZ ', jJson:GetJsonObject('NREDUZ')   , Nil} )
        aAdd(aDados, {'A2_BAIRRO ', jJson:GetJsonObject('BAIRRO')   , Nil} )
        aAdd(aDados, {'A2_EMAIL  ', jJson:GetJsonObject('EMAIL')    , Nil} )
        aAdd(aDados, {'A2_CEP    ', jJson:GetJsonObject('CEP')      , Nil} )
        aAdd(aDados, {'A2_CGC    ', jJson:GetJsonObject('NUM')     , Nil} )
        aAdd(aDados, {'A2_EST    ', jJson:GetJsonObject('ESTADO')   , Nil} )
        aAdd(aDados, {'A2_COD_MUN', jJson:GetJsonObject('COD_MUN')  , Nil} )
        aAdd(aDados, {'A2_COND   ', jJson:GetJsonObject('COND')     , Nil} )
        aAdd(aDados, {'A2_DDD    ', jJson:GetJsonObject('DDD')      , Nil} )
        aAdd(aDados, {'A2_EMAIL  ', jJson:GetJsonObject('EMAIL')    , Nil} )
        aAdd(aDados, {'A2_END    ', jJson:GetJsonObject('END')      , Nil} )
        aAdd(aDados, {'A2_INSCR  ', jJson:GetJsonObject('INSCR')    , Nil} )
        aAdd(aDados, {'A2_MUN    ', jJson:GetJsonObject('MUNICIPIO'), Nil} )
        aAdd(aDados, {'A2_NATUREZ', jJson:GetJsonObject('NATUREZ')  , Nil} )
        aAdd(aDados, {'A2_TIPO   ', jJson:GetJsonObject('TIPO')     , Nil} )
        aAdd(aDados, {'A2_TEL    ', jJson:GetJsonObject('FONE')     , Nil} )
        aAdd(aDados, {'A2_TRANSP ', jJson:GetJsonObject('TRANSP')   , Nil} )
        aAdd(aDados, {'A2_PAIS   ', '105'  							, Nil} )

		//Percorre os dados do execauto
		For nCampo := 1 To Len(aDados)
			//Se o campo for data, retira os hifens e faz a conversão
			If GetSX3Cache(aDados[nCampo][1], 'X3_TIPO') == 'D'
				aDados[nCampo][2] := StrTran(aDados[nCampo][2], '-', '')
				aDados[nCampo][2] := sToD(aDados[nCampo][2])
			EndIf
		Next

		if !lExtFor
			//Chama a inclusão automática
			conout("antes do execaut")
			MsExecAuto({|x, y| MATA020(x, y)}, aDados, 3)
		Endif
		//Se houve erro, gera um arquivo de log dentro do diretório da protheus data
		If lMsErroAuto
			//Monta o texto do Error Log que será salvo
			cErrorLog   := ''
			aLogAuto    := GetAutoGrLog()
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
			jResponse['solution'] := 'Nao foi possivel incluir o registro, foi gerado um arquivo de log em ' + cDirLog + cArqLog + ' '
			lRet := .F.

			cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
			oWS:GRAVALOGMURO(cResponc, cJason, "WSFORNC", "INCLUSÃO DE FORNECEDOR")

		//Senão, define o retorno
		Else
			jResponse['note']     := 'Registro incluido com sucesso'
		EndIf

    EndIf

    //Define o retorno
    Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
Return lRet

WSMETHOD PUT UPDATE WSRECEIVE NUM WSSERVICE WSPEDVEND
    Local lRet              := .T.
    Local aDados            := {}
    Local jJson             := Nil
    Local cJson             := Self:GetContent()
    Local cError            := ''
    Local nLinha            := 0
    Local cDirLog           := '\x_logs\'
    Local cArqLog           := ''
    Local cErrorLog         := ''
    Local aLogAuto          := {}
    Local jResponse         := JsonObject():New()
    Local cAliasWS          := 'SA2'
	
	Local cJason			:= ""
	Local cResponc          := ""

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
	cNUM  := jJson:GetJsonObject('NUM')
	cCodi  := jJson:GetJsonObject('CODIGO')
	cLoja  := jJson:GetJsonObject('LOJA')
	::NUM := jJson:GetJsonObject('NUM')

    //Se o id estiver vazio
    If Empty(::NUM)
        //SetRestFault(500, 'Falha ao consultar o registro') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
        Self:setStatus(500) 
        jResponse['errorId']  := 'UPD006'
        jResponse['error']    := 'ID vazio'
        jResponse['solution'] := 'Informe o ID'

		cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
		oWS:GRAVALOGMURO(cResponc, cJason, "WSFORNC", "ATUALIZAÇÃO DE FORNECEDOR")
    Else
        DbSelectArea(cAliasWS)
        (cAliasWS)->(DbSetOrder(1))

        //Se não encontrar o registro
        If !oWS:temFornec(FWxFilial(cAliasWS), ::NUM) //(cAliasWS)->(MsSeek(FWxFilial(cAliasWS) + ::NUM))
            //SetRestFault(500, 'Falha ao consultar ID') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
            Self:setStatus(500) 
            jResponse['errorId']  := 'UPD007'
            jResponse['error']    := 'ID não encontrado'
            jResponse['solution'] := 'Código ID não encontrado na tabela ' + cAliasWS

			cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
			oWS:GRAVALOGMURO(cResponc, cJason, "WSFORNC", "ATUALIZAÇÃO DE FORNECEDOR")
        Else
 
            //Se tiver algum erro no Parse, encerra a execução
            If ! Empty(cError)
                //SetRestFault(500, 'Falha ao obter JSON') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
                Self:setStatus(500) 
                jResponse['errorId']  := 'UPD008'
                jResponse['error']    := 'Parse do JSON'
                jResponse['solution'] := 'Erro ao fazer o Parse do JSON'

				cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
				oWS:GRAVALOGMURO(cResponc, cJason, "WSFORNC", "ATUALIZAÇÃO DE FORNECEDOR")
            Else
		         DbSelectArea(cAliasWS)
                
		         //Adiciona os dados do ExecAuto
				aAdd(aDados, {'A2_NOME'   , jJson:GetJsonObject('NOME')     , Nil} )
				aAdd(aDados, {'A2_NREDUZ ', jJson:GetJsonObject('NREDUZ')   , Nil} )
				aAdd(aDados, {'A2_BAIRRO ', jJson:GetJsonObject('BAIRRO')   , Nil} )
				aAdd(aDados, {'A2_EMAIL  ', jJson:GetJsonObject('EMAIL')    , Nil} )
				aAdd(aDados, {'A2_CEP    ', jJson:GetJsonObject('CEP')      , Nil} )
				aAdd(aDados, {'A2_EST    ', jJson:GetJsonObject('ESTADO')   , Nil} )
				aAdd(aDados, {'A2_DDD    ', jJson:GetJsonObject('DDD')      , Nil} )
				aAdd(aDados, {'A2_END    ', jJson:GetJsonObject('END')      , Nil} )
				aAdd(aDados, {'A2_INSCR  ', jJson:GetJsonObject('INSCR')    , Nil} )
				aAdd(aDados, {'A2_MUN    ', jJson:GetJsonObject('MUNICIPIO'), Nil} )
				aAdd(aDados, {'A2_NATUREZ', jJson:GetJsonObject('NATUREZ')  , Nil} )
		         
				 SA2->(DbGoTop())
				 SA2->(DbSetOrder(3)) 
				 if (SA2->( DbSeek( xFilial("SA2") + cNUM ) ) )
			 		lMsErroAuto :=  oWS:ATUSA2(aDados, xFilial("SA2"),  cNUM)
					//MsExecAuto({|x, y| MATA020(x, y)}, aDados, 4)
				 Endif
		         //Se houve erro, gera um arquivo de log dentro do diretório da protheus data
		         If lMsErroAuto
		         	//Monta o texto do Error Log que será salvo
		         	cErrorLog   := ''
		         	aLogAuto    := GetAutoGrLog()
		         	For nLinha := 1 To Len(aLogAuto)
		         		cErrorLog += aLogAuto[nLinha] + CRLF
		         	Next nLinha

		            //Grava o arquivo de log
		            cArqLog := 'WSPEDVEND_New_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
		            MemoWrite(cDirLog + cArqLog, cErrorLog)

		            //Define o retorno para o WebService
		            //SetRestFault(500, cErrorLog) //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
		            Self:setStatus(500) 
		            jResponse['errorId']  := 'UPD009'
		            jResponse['error']    := 'Erro na atualização do registro'
		            jResponse['solution'] := 'Nao foi possivel incluir o registro, foi gerado um arquivo de log em ' + cDirLog + cArqLog + ' '
		            lRet := .F.

					cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
					oWS:GRAVALOGMURO(cResponc, cJason, "WSFORNC", "ATUALIZAÇÃO DE FORNECEDOR")

		         Else
		         	jResponse['note']     := 'Registro Atualizado com sucesso'
		         EndIf

		     EndIf
		 EndIf
    EndIf

    //Define o retorno
    Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
Return lRet

WSMETHOD PUT ERASE WSRECEIVE id WSSERVICE WSPEDVEND
    Local lRet              := .T.
    Local aDados            := {}
    Local jJson             := Nil
    Local cJson             := Self:GetContent()
    Local cError            := ''
    Local nLinha            := 0
    Local cDirLog           := '\x_logs\'
    Local cArqLog           := ''
    Local cErrorLog         := ''
    Local aLogAuto          := {}
   
    Local jResponse         := JsonObject():New()
    Local cAliasWS          := 'SA2'

	Local cJason			:= ""
	Local cResponc          := ""

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
	cNUM  := jJson:GetJsonObject('NUM')
	cCodi  := jJson:GetJsonObject('CODIGO')
	cLoja  := jJson:GetJsonObject('LOJA')
	::NUM := jJson:GetJsonObject('NUM')

    //Se o id estiver vazio
    If Empty(::NUM)
        //SetRestFault(500, 'Falha ao consultar o registro') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
        Self:setStatus(500) 
        jResponse['errorId']  := 'DEL010'
        jResponse['error']    := 'ID vazio'
        jResponse['solution'] := 'Informe o ID'

		cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
		oWS:GRAVALOGMURO(cResponc, cJason, "WSFORNC", "BLOQUEIO DE FORNECEDOR")

    Else
        If !oWS:temFornec(FWxFilial(cAliasWS), ::NUM) //(cAliasWS)->(MsSeek(FWxFilial(cAliasWS) + ::NUM))
            //SetRestFault(500, 'Falha ao consultar ID') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
            Self:setStatus(500) 
            jResponse['errorId']  := 'DEL011'
            jResponse['error']    := 'ID não encontrado'
            jResponse['solution'] := 'Código ID não encontrado na tabela ' + cAliasWS
	
			cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
			oWS:GRAVALOGMURO(cResponc, cJason, "WSFORNC", "BLOQUEIO DE FORNECEDOR")
        Else
 
            //Se tiver algum erro no Parse, encerra a execução
            If ! Empty(cError)
                //SetRestFault(500, 'Falha ao obter JSON') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
                Self:setStatus(500) 
                jResponse['errorId']  := 'DEL012'
                jResponse['error']    := 'Parse do JSON'
                jResponse['solution'] := 'Erro ao fazer o Parse do JSON'

				cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
				oWS:GRAVALOGMURO(cResponc, cJason, "WSFORNC", "BLOQUEIO DE FORNECEDOR")
            Else
		         //Adiciona os dados do ExecAuto
				 aAdd(aDados, {'A2_MSBLQL', '1',   Nil})

				 SA2->(DbGoTop())
				 SA2->(DbSetOrder(3)) 
				 if (SA2->( DbSeek( xFilial("SA2") + cNUM ) ) )
			 		lMsErroAuto :=  oWS:ATUSA2(aDados, xFilial("SA2"),  cNUM)
			        //MsExecAuto({|x, y| MATA020(x, y)}, aDados, 5)
				 Endif


		         //Se houve erro, gera um arquivo de log dentro do diretório da protheus data
		         If lMsErroAuto
		         	//Monta o texto do Error Log que será salvo
		         	cErrorLog   := ''
		         	aLogAuto    := GetAutoGrLog()
		         	For nLinha := 1 To Len(aLogAuto)
		         		cErrorLog += aLogAuto[nLinha] + CRLF
		         	Next nLinha

		            //Grava o arquivo de log
		            cArqLog := 'WSPEDVEND_New_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
		            MemoWrite(cDirLog + cArqLog, cErrorLog)

		            //Define o retorno para o WebService
		            //SetRestFault(500, cErrorLog) //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
		            Self:setStatus(500) 
		            jResponse['errorId']  := 'DEL013'
		            jResponse['error']    := 'Erro na exclusão do registro'
		            jResponse['solution'] := 'Nao foi possivel incluir o registro, foi gerado um arquivo de log em ' + cDirLog + cArqLog + ' '
		            lRet := .F.
					cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
					oWS:GRAVALOGMURO(cResponc, cJason, "WSFORNC", "BLOQUEIO DE FORNECEDOR")
		         Else
		         	jResponse['note']     := 'Registro Bloqueado com sucesso'
		         EndIf

		     EndIf
		 EndIf
    EndIf

    //Define o retorno
    Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
Return lRet
