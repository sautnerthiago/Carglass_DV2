//Bibliotecas
#Include "Totvs.ch"
#Include "RESTFul.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} WSRESTFUL wsCliente
Cadastro de Cliente
@author JOSE EDILSON DE LIMA PINTO
@since 13/05/2025
@version 1.0
@type wsrestful
@obs Codigo gerado automaticamente pelo Autumn Code Maker
/*/

WSRESTFUL wsCliente DESCRIPTION 'Cadastro de Cliente'
	//Atributos
	WSDATA cnpj       AS STRING
	WSDATA updated_at AS STRING
	WSDATA limit      AS INTEGER
	WSDATA page       AS INTEGER

	//M�todos
	WSMETHOD GET  ID     DESCRIPTION 'Retorna o registro pesquisado' WSSYNTAX '/wsCliente/{cnpj}'           PATH '{cnpj}'  PRODUCES APPLICATION_JSON
	WSMETHOD POST NEW    DESCRIPTION 'Inclus�o de registro'          WSSYNTAX '/wsCliente/new'              PATH 'new'     PRODUCES APPLICATION_JSON
	WSMETHOD PUT  UPDATE DESCRIPTION 'Atualiza��o de registro'       WSSYNTAX '/wsCliente/update'           PATH 'update'  PRODUCES APPLICATION_JSON
	WSMETHOD PUT  ERASE  DESCRIPTION 'Bloquear Registro'             WSSYNTAX '/wsCliente/bloqu'            PATH 'bloqu'   PRODUCES APPLICATION_JSON
END WSRESTFUL


WSMETHOD GET ID WSRECEIVE cnpj WSSERVICE wsCliente
	Local lRet       := .T.
	Local jResponse  := JsonObject():New()
	Local cAliasWS   := 'SA1'
	::cnpj			 := self:aUrlParms[1]


	oWS    := LIBGLASS():new()

	//Se o id estiver vazio
	If Empty(::cnpj)
		//SetRestFault(500, 'Falha ao consultar o registro') //caso queira usar esse comando, voc� n�o poder� usar outros retornos, como os abaixo
		Self:setStatus(500)
		jResponse['errorId']  := 'ID001'
		jResponse['error']    := 'ID vazio'
		jResponse['solution'] := 'Informe o ID'

		cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
		oWS:GRAVALOGMURO(cResponc, cJason, "WSCLIENTE", "BLOQUEIO DE CLIENTE")
	Else
		DbSelectArea(cAliasWS)
		(cAliasWS)->(DbSetOrder(3))   //PESQUISA CGC/CPF

		//Se n�o encontrar o registro
		If !(cAliasWS)->(MsSeek(FWxFilial(cAliasWS) + ::cnpj))
			//SetRestFault(500, 'Falha ao consultar ID') //caso queira usar esse comando, voc� n�o poder� usar outros retornos, como os abaixo
			Self:setStatus(500)
			jResponse['errorId']  := 'ID002'
			jResponse['error']    := 'CNPJ/CPF ('+::cnpj+') n�o encontrado'
			jResponse['solution'] := 'CNPJ/CPF n�o encontrado na tabela ' + cAliasWS

			cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
			oWS:GRAVALOGMURO(cResponc, cJason, "WSCLIENTE", "BLOQUEIO DE CLIENTE")
		Else
			//Define o retorno
			jResponse['FILIAL'] := (cAliasWS)->A1_FILIAL
			jResponse['COD'] 	:= (cAliasWS)->A1_COD
			jResponse['LOJA'] 	:= (cAliasWS)->A1_LOJA
			jResponse['NOME'] 	:= (cAliasWS)->A1_NOME
			jResponse['NREDUZ '] := (cAliasWs)->A1_NREDUZ 
        	jResponse['BAIRRO '] := (cAliasWs)->A1_BAIRRO 
        	jResponse['EMAIL  '] := (cAliasWs)->A1_EMAIL  
        	jResponse['CEP    '] := (cAliasWs)->A1_CEP    
        	jResponse['CGC    '] := (cAliasWs)->A1_CGC   
        	jResponse['EST    '] := (cAliasWs)->A1_ESTADO 
        	jResponse['COD_MUN'] := (cAliasWs)->A1_COD_MUN
        	jResponse['COND   '] := (cAliasWs)->A1_COND  
        	jResponse['DDD    '] := (cAliasWs)->A1_DDD    
        	jResponse['DTCAD  '] := (cAliasWs)->A1_DTCAD
        	jResponse['EMAIL  '] := (cAliasWs)->A1_EMAIL  
        	jResponse['END    '] := (cAliasWs)->A1_END    
        	jResponse['INSCR  '] := (cAliasWs)->A1_INSCR
        	jResponse['MUN    '] := (cAliasWs)->A1_MUN
        	jResponse['NATUREZ'] := (cAliasWs)->A1_NATUREZ
        	jResponse['PESSOA '] := (cAliasWs)->A1_TPESSOA 
        	jResponse['TIPCLI '] := (cAliasWs)->A1_TIPCLI   
        	jResponse['TEL    '] := (cAliasWs)->A1_TEL
        	jResponse['TRANSP '] := (cAliasWs)->A1_TRANSP
        	jResponse['PAIS   '] := (cAliasWS)->A1_PAIS
		EndIf
	EndIf

	//Define o retorno
	Self:SetContentType('application/json')
	Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
Return lRet

WSMETHOD POST NEW WSRECEIVE WSSERVICE wsCliente
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
	Local cAliasWS          := 'SB1'
	
	Local cJason			:= ""
	Local cResponc          := ""
	Local lExtCli           := .F.
	
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
	::cnpj := jJson:GetJsonObject('CNPJ')

	IF oWS:temClient(FWxFilial(cAliasWS), ::cnpj)
		//SetRestFault(500, 'Falha ao obter JSON') //caso queira usar esse comando, voc� n�o poder� usar outros retornos, como os abaixo
		Self:setStatus(500)
		jResponse['errorId']  := 'NEW0041'
		jResponse['error']    := 'CLIENTE JA EXISTE'
		jResponse['solution'] := 'CADASTRE UM CLIENTE CUJO CNPJ N�O SEJA O MESMO'

		cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
		oWS:GRAVALOGMURO(cResponc, cJason, "WSCLIENTE", "INCLUS�O DE CLIENTE")
		lExtCli := .T.
	EndIF

	//Se tiver algum erro no Parse, encerra a execu��o
	IF ! Empty(cError)
		//SetRestFault(500, 'Falha ao obter JSON') //caso queira usar esse comando, voc� n�o poder� usar outros retornos, como os abaixo
		Self:setStatus(500)
		jResponse['errorId']  := 'NEW004'
		jResponse['error']    := 'Parse do JSON'
		jResponse['solution'] := 'Erro ao fazer o Parse do JSON'

		cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
		oWS:GRAVALOGMURO(cResponc, cJason, "WSCLIENTE", "INCLUS�O DE CLIENTE")
	Else
		DbSelectArea(cAliasWS)
		//Adiciona os dados do ExecAuto
		aAdd(aDados, {'A1_FILIAL' , FWCodFil()                      , Nil} )
		aAdd(aDados, {'A1_COD'    , jJson:GetJsonObject('CODIGO')   , Nil} )
		aAdd(aDados, {'A1_LOJA'   , jJson:GetJsonObject('LOJA')     , Nil} )
		aAdd(aDados, {'A1_NOME'   , jJson:GetJsonObject('NOME')     , Nil} )
		aAdd(aDados, {'A1_NREDUZ ', jJson:GetJsonObject('NREDUZ')   , Nil} )
        aAdd(aDados, {'A1_BAIRRO ', jJson:GetJsonObject('BAIRRO')   , Nil} )
        aAdd(aDados, {'A1_EMAIL  ', jJson:GetJsonObject('EMAIL')    , Nil} )
        aAdd(aDados, {'A1_CEP    ', jJson:GetJsonObject('CEP')      , Nil} )
        aAdd(aDados, {'A1_CGC    ', jJson:GetJsonObject('CNPJ')     , Nil} )
        aAdd(aDados, {'A1_EST    ', jJson:GetJsonObject('ESTADO')   , Nil} )
        aAdd(aDados, {'A1_COD_MUN', jJson:GetJsonObject('COD_MUN')  , Nil} )
        aAdd(aDados, {'A1_COND   ', jJson:GetJsonObject('COND')     , Nil} )
        aAdd(aDados, {'A1_DDD    ', jJson:GetJsonObject('DDD')      , Nil} )
        aAdd(aDados, {'A1_DTCAD  ', jJson:GetJsonObject('DTCAD')    , Nil} )
        aAdd(aDados, {'A1_EMAIL  ', jJson:GetJsonObject('EMAIL')    , Nil} )
        aAdd(aDados, {'A1_END    ', jJson:GetJsonObject('END')      , Nil} )
        aAdd(aDados, {'A1_INSCR  ', jJson:GetJsonObject('INSCR')    , Nil} )
        aAdd(aDados, {'A1_MUN    ', jJson:GetJsonObject('MUNICIPIO'), Nil} )
        aAdd(aDados, {'A1_NATUREZ', jJson:GetJsonObject('NATUREZ')  , Nil} )
        aAdd(aDados, {'A1_OBS    ', 'WMSCLINTE'                     , Nil} )
        aAdd(aDados, {'A1_PESSOA ', jJson:GetJsonObject('PESSOA')   , Nil} )
        aAdd(aDados, {'A1_TIPCLI ', jJson:GetJsonObject('TIPO')     , Nil} )
        aAdd(aDados, {'A1_TIPO   ', jJson:GetJsonObject('TIPO')     , Nil} )
        aAdd(aDados, {'A1_TEL    ', jJson:GetJsonObject('FONE')     , Nil} )
        aAdd(aDados, {'A1_TRANSP ', jJson:GetJsonObject('TRANSP')   , Nil} )
        aAdd(aDados, {'A1_PAIS   ', '105'  							, Nil} )

		//Percorre os dados do execauto
		For nCampo := 1 To Len(aDados)
			//Se o campo for data, retira os hifens e faz a convers�o
			If GetSX3Cache(aDados[nCampo][1], 'X3_TIPO') == 'D'
				aDados[nCampo][2] := StrTran(aDados[nCampo][2], '-', '')
				aDados[nCampo][2] := sToD(aDados[nCampo][2])
			EndIf
		Next

		//Chama a inclus�o autom�tica
        if !lExtCli
			conout("antes do execaut")
			MsExecAuto({|x, y| MATA030(x, y)}, aDados, 3)
		Endif

		//Se houve erro, gera um arquivo de log dentro do diret�rio da protheus data
		If lMsErroAuto
			//Monta o texto do Error Log que ser� salvo
			cErrorLog   := ''
			aLogAuto    := GetAutoGrLog()
			For nLinha := 1 To Len(aLogAuto)
				cErrorLog += aLogAuto[nLinha] + CRLF
			Next nLinha

			//Grava o arquivo de log
			cArqLog := 'wsCliente_New_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
			MemoWrite(cDirLog + cArqLog, cErrorLog)

			//Define o retorno para o WebService
			//SetRestFault(500, cErrorLog) //caso queira usar esse comando, voc� n�o poder� usar outros retornos, como os abaixo
			Self:setStatus(500)
			jResponse['errorId']  := 'NEW005'
			jResponse['error']    := 'Erro na inclus�o do registro'
			jResponse['solution'] := 'Nao foi possivel incluir o registro, foi gerado um arquivo de log em ' + cDirLog + cArqLog + ' '
			lRet := .F.

			cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
			oWS:GRAVALOGMURO(cResponc, cErrorLog, "WSCLIENTE", "INCLUS�O DE CLIENTE")
			//Sen�o, define o retorno
		Else
			jResponse['note']     := 'Registro incluido com sucesso'
		EndIf

	EndIf

	//Define o retorno
	Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
Return lRet

WSMETHOD PUT UPDATE WSRECEIVE cnpj WSSERVICE wsCliente
	Local lRet              := .T.
	Local aDadUpd           := {}
	Local jJson             := Nil
	Local cJson             := Self:GetContent()
	Local cError            := ''
	Local nLinha            := 0
	Local cDirLog           := '\x_logs\'
	Local cArqLog           := ''
	Local cErrorLog         := ''
	Local aLogAuto          := {}
	Local jResponse         := JsonObject():New()
	Local cAliasWS          := 'SA1'

	Local cJason			:= ""
	Local cResponc          := ""
	Local cCnpj  			:= ""
	Local cCodi  			:= ""
	Local cLoja  			:= ""

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
	cJason := cJson
	cError := jJson:FromJson(cJson)
	::cnpj := jJson:GetJsonObject('CNPJ')
	cCnpj  := jJson:GetJsonObject('CNPJ')
	cCodi  := jJson:GetJsonObject('CODIGO')
	cLoja  := jJson:GetJsonObject('LOJA')

	//Se o id estiver vazio
	If Empty(::cnpj)
		//SetRestFault(500, 'Falha ao consultar o registro') //caso queira usar esse comando, voc� n�o poder� usar outros retornos, como os abaixo
		Self:setStatus(500)
		jResponse['errorId']  := 'UPD006'
		jResponse['error']    := 'ID vazio'
		jResponse['solution'] := 'Informe o ID'

		cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
		oWS:GRAVALOGMURO(cResponc, cJason, "WSCLIENTE", "BLOQUEIO DE CLIENTE")
	Else
		//DbSelectArea(cAliasWS)
		//SA1->(DbGoTop())
		//SA1->(DbSetOrder(1))  //FILIAL + CODIGO + LOJA
		//(SA1->( DbSeek( xFilial("SA1") + ::cnpj ) ) )

		//Se n�o encontrar o registro
		If !oWS:temClient(FWxFilial(cAliasWS), ::cnpj) //!(cAliasWS)->(MsSeek(FWxFilial(cAliasWS) + ::cnpj))
			//SetRestFault(500, 'Falha ao consultar ID') //caso queira usar esse comando, voc� n�o poder� usar outros retornos, como os abaixo
			Self:setStatus(500)
			jResponse['errorId']  := 'UPD007'
			jResponse['error']    := 'ID n�o encontrado'
			jResponse['solution'] := 'C�digo ID n�o encontrado na tabela ' + cAliasWS

			cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
			oWS:GRAVALOGMURO(cResponc, cJason, "WSCLIENTE", "ATUALIZA��O DE CLIENTE")
		Else

			//Se tiver algum erro no Parse, encerra a execu��o
			If !Empty(cError)
				//SetRestFault(500, 'Falha ao obter JSON') //caso queira usar esse comando, voc� n�o poder� usar outros retornos, como os abaixo
				Self:setStatus(500)
				jResponse['errorId']  := 'UPD008'
				jResponse['error']    := 'Parse do JSON'
				jResponse['solution'] := 'Erro ao fazer o Parse do JSON'

				cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
				oWS:GRAVALOGMURO(cResponc, cJason, "WSCLIENTE", "ATUALIZA��O DE CLIENTE")
			Else

				//Adiciona os dados do ExecAuto
				aAdd(aDadUpd, {'A1_NOME'   	, jJson:GetJsonObject('NOME')     , Nil} )
				aAdd(aDadUpd, {'A1_NREDUZ'	, jJson:GetJsonObject('NREDUZ')   , Nil} )
				aAdd(aDadUpd, {'A1_BAIRRO'	, jJson:GetJsonObject('BAIRRO')   , Nil} )
				aAdd(aDadUpd, {'A1_EMAIL'	, jJson:GetJsonObject('EMAIL')    , Nil} )
				aAdd(aDadUpd, {'A1_CEP'		, jJson:GetJsonObject('CEP')      , Nil} )
				aAdd(aDadUpd, {'A1_EST'		, jJson:GetJsonObject('ESTADO')   , Nil} )
				aAdd(aDadUpd, {'A1_COD_MUN'	, jJson:GetJsonObject('COD_MUN')  , Nil} )
				aAdd(aDadUpd, {'A1_COND'	, jJson:GetJsonObject('COND')     , Nil} )
				aAdd(aDadUpd, {'A1_DDD'		, jJson:GetJsonObject('DDD')      , Nil} )
				aAdd(aDadUpd, {'A1_END'		, jJson:GetJsonObject('END')      , Nil} )
				aAdd(aDadUpd, {'A1_INSCR'	, jJson:GetJsonObject('INSCR')    , Nil} )
				aAdd(aDadUpd, {'A1_MUN'		, jJson:GetJsonObject('MUNICIPIO'), Nil} )
				aAdd(aDadUpd, {'A1_NATUREZ'	, jJson:GetJsonObject('NATUREZ')  , Nil} )
				aAdd(aDadUpd, {'A1_PESSOA'	, jJson:GetJsonObject('PESSOA')   , Nil} )
				aAdd(aDadUpd, {'A1_TRANSP'	, jJson:GetJsonObject('TRANSP')   , Nil} )

				SA1->(DbGoTop())
				SA1->(DbSetOrder(3)) 
				if (SA1->( DbSeek( xFilial("SA1") + cCnpj ) ) )
					lMsErroAuto :=  oWS:ATUSA1(aDadUpd, xFilial("SA1"),  cCnpj)
					//MsExecAuto({|x, y| MATA030(x, y)}, aDadUpd, 4)
				Endif

				//Se houve erro, gera um arquivo de log dentro do diret�rio da protheus data
				If lMsErroAuto
					//Monta o texto do Error Log que ser� salvo
					cErrorLog   := ''
					aLogAuto    := GetAutoGrLog()
					For nLinha  := 1 To Len(aLogAuto)
						cErrorLog += aLogAuto[nLinha] + CRLF
					Next nLinha

					//Grava o arquivo de log
					cArqLog := 'wsCliente_New_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
					MemoWrite(cDirLog + cArqLog, cErrorLog)

					//Define o retorno para o WebService
					//SetRestFault(500, cErrorLog) //caso queira usar esse comando, voc� n�o poder� usar outros retornos, como os abaixo
					Self:setStatus(500)
					jResponse['errorId']  := 'UPD009'
					jResponse['error']    := 'Erro na atualiza��o do registro'
					jResponse['solution'] := 'Nao foi possivel incluir o registro, foi gerado um arquivo de log em ' + cDirLog + cArqLog + ' '
					lRet := .F.

					cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
					oWS:GRAVALOGMURO(cResponc, cErrorLog, "WSCLIENTE", "ATUALIZA��O DE CLIENTE")
					//Sen�o, define o retorno
				Else
					jResponse['note']     := 'Registro Atualizado com sucesso'
				EndIf

			EndIf
		EndIf
	EndIf

	//Define o retorno
	Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
Return lRet

WSMETHOD PUT ERASE WSRECEIVE cnpj WSSERVICE wsCliente
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
	Local cAliasWS          := 'SA1'

	Local cJason			:= ""
	Local cResponc          := ""

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
	::cnpj := jJson:GetJsonObject('CNPJ')
	cCnpj  := jJson:GetJsonObject('CNPJ')
	cCodi  := jJson:GetJsonObject('CODIGO')
	cLoja  := jJson:GetJsonObject('LOJA')

	//Se o id estiver vazio
	If Empty(::cnpj)
		//SetRestFault(500, 'Falha ao consultar o registro') //caso queira usar esse comando, voc� n�o poder� usar outros retornos, como os abaixo
		Self:setStatus(500)
		jResponse['errorId']  := 'DEL010'
		jResponse['error']    := 'ID vazio'
		jResponse['solution'] := 'Informe o ID'

		cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
		oWS:GRAVALOGMURO(cResponc, cJason, "WSCLIENTE", "BLOQUEIO DE CLIENTE")
	Else
		//Se n�o encontrar o registro
		If !oWS:temClient(FWxFilial(cAliasWS), ::cnpj) //(cAliasWS)->(MsSeek(FWxFilial(cAliasWS) + ::cnpj))
			//SetRestFault(500, 'Falha ao consultar ID') //caso queira usar esse comando, voc� n�o poder� usar outros retornos, como os abaixo
			Self:setStatus(500)
			jResponse['errorId']  := 'DEL011'
			jResponse['error']    := 'ID n�o encontrado'
			jResponse['solution'] := 'C�digo ID n�o encontrado na tabela ' + cAliasWS

			cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
			oWS:GRAVALOGMURO(cResponc, cJason, "WSCLIENTE", "BLOQUEIO DE CLIENTE")			
		Else

			//Se tiver algum erro no Parse, encerra a execu��o
			If ! Empty(cError)
				//SetRestFault(500, 'Falha ao obter JSON') //caso queira usar esse comando, voc� n�o poder� usar outros retornos, como os abaixo
				Self:setStatus(500)
				jResponse['errorId']  := 'DEL012'
				jResponse['error']    := 'Parse do JSON'
				jResponse['solution'] := 'Erro ao fazer o Parse do JSON'

				cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
				oWS:GRAVALOGMURO(cResponc, cJason, "WSCLIENTE", "BLOQUEIO DE CLIENTE")
			Else
				DbSelectArea(cAliasWS)

				//Adiciona os dados do ExecAuto
				aAdd(aDados, {'A1_MSBLQL', '1',   Nil})

				//Percorre os dados do execauto
				For nCampo := 1 To Len(aDados)
					//Se o campo for data, retira os hifens e faz a convers�o
					If GetSX3Cache(aDados[nCampo][1], 'X3_TIPO') == 'D'
						aDados[nCampo][2] := StrTran(aDados[nCampo][2], '-', '')
						aDados[nCampo][2] := sToD(aDados[nCampo][2])
					EndIf
				Next

				SA1->(DbGoTop())
				SA1->(DbSetOrder(3)) 
				if (SA1->( DbSeek( xFilial("SA1") + cCnpj ) ) )
					lMsErroAuto :=  oWS:ATUSA1(aDados, xFilial("SA1"),  cCnpj)
					//MsExecAuto({|x, y| MATA030(x, y)}, aDados, 4)
				Endif

				//Se houve erro, gera um arquivo de log dentro do diret�rio da protheus data
				If lMsErroAuto
					//Monta o texto do Error Log que ser� salvo
					cErrorLog   := ''
					aLogAuto    := GetAutoGrLog()
					For nLinha := 1 To Len(aLogAuto)
						cErrorLog += aLogAuto[nLinha] + CRLF
					Next nLinha

					//Grava o arquivo de log
					cArqLog := 'wsCliente_New_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
					MemoWrite(cDirLog + cArqLog, cErrorLog)

					//Define o retorno para o WebService
					//SetRestFault(500, cErrorLog) //caso queira usar esse comando, voc� n�o poder� usar outros retornos, como os abaixo
					Self:setStatus(500)
					jResponse['errorId']  := 'DEL013'
					jResponse['error']    := 'Erro na exclus�o do registro'
					jResponse['solution'] := 'Nao foi possivel incluir o registro, foi gerado um arquivo de log em ' + cDirLog + cArqLog + ' '
					lRet := .F.

					cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
					oWS:GRAVALOGMURO(cResponc, cErrorLog, "WSCLIENTE", "BLOQUEIO DE CLIENTE")
				Else
					jResponse['note']     := 'Registro Bloqueado com sucesso'
				EndIf

			EndIf
		EndIf
	EndIf

	//Define o retorno
	Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
Return lRet
