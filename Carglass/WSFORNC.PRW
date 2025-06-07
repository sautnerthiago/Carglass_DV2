//Bibliotecas
#Include "Totvs.ch"
#Include "RESTFul.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} WSRESTFUL WSFORNEC
CADASTRO DE FORNECEDOR
@author JOSE EDILSON DE LIMA PINTO
@since 19/05/2025
@version 1.0
@type wsrestful
/*/

WSRESTFUL WSFORNEC DESCRIPTION 'CADASTRO DE FORNECEDOR'
    //Atributos
    WSDATA cnpj       AS STRING
    WSDATA updated_at AS STRING
    WSDATA limit      AS INTEGER
    WSDATA page       AS INTEGER
 
    //Métodos
    WSMETHOD GET    CNPJ   DESCRIPTION 'Retorna o registro pesquisado' WSSYNTAX '/WSFORNEC/{cnpj}'                     PATH '{cnpj}'        PRODUCES APPLICATION_JSON
    WSMETHOD POST   NEW    DESCRIPTION 'Inclusão de registro'          WSSYNTAX '/WSFORNEC/new'                        PATH 'new'           PRODUCES APPLICATION_JSON
    WSMETHOD PUT    UPDATE DESCRIPTION 'Atualização de registro'       WSSYNTAX '/WSFORNEC/update'                     PATH 'update'        PRODUCES APPLICATION_JSON
    WSMETHOD PUT    ERASE  DESCRIPTION 'Blaqueio de registro'          WSSYNTAX '/WSFORNEC/bloqu'                      PATH 'bloqu'         PRODUCES APPLICATION_JSON
END WSRESTFUL

/*/{Protheus.doc} WSMETHOD GET ID
Busca registro via ID
@author JOSE EDILSON DE LIMA PINTO
@since 19/05/2025
/*/

WSMETHOD GET CNPJ WSRECEIVE cnpj WSSERVICE WSFORNEC
    Local lRet       := .T.
    Local jResponse  := JsonObject():New()
    Local cAliasWS   := 'SA2'
    ::cnpj			 := self:aUrlParms[1]

	oWS    := LIBGLASS():new()

    //Se o id estiver vazio
    If Empty(::cnpj)
        //SetRestFault(500, 'Falha ao consultar o registro') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
        Self:setStatus(500) 
        jResponse['errorId']  := 'ID001'
        jResponse['error']    := 'ID vazio'
        jResponse['solution'] := 'Informe o ID'
    Else
        DbSelectArea(cAliasWS)
        (cAliasWS)->(DbSetOrder(3))

        //Se não encontrar o registro
        If ! (cAliasWS)->(MsSeek(FWxFilial(cAliasWS) + ::cnpj))
            //SetRestFault(500, 'Falha ao consultar ID') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
            Self:setStatus(500) 
            jResponse['errorId']  := 'ID002'
			jResponse['error']    := 'CNPJ/CPF ('+::cnpj+') não encontrado'
			jResponse['solution'] := 'CNPJ/CPF não encontrado na tabela ' + cAliasWS
        Else
            //Define o retorno
            jResponse['filial'] 	:= (cAliasWS)->A2_FILIAL 
            jResponse['cod'] 		:= (cAliasWS)->A2_COD 
            jResponse['loja'] 		:= (cAliasWS)->A2_LOJA 
            jResponse['nome'] 		:= (cAliasWS)->A2_NOME 
        EndIf
    EndIf

    //Define o retorno
    Self:SetContentType('application/json')
    Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
Return lRet

WSMETHOD POST NEW WSRECEIVE WSSERVICE WSFORNEC
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
	::cnpj := jJson:GetJsonObject('CNPJ')

	IF oWS:temFornec(FWxFilial(cAliasWS), ::cnpj)
		//SetRestFault(500, 'Falha ao obter JSON') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
		Self:setStatus(500)
		jResponse['errorId']  := 'NEW0041'
		jResponse['error']    := 'FORNECEDOR JA EXISTE'
		jResponse['solution'] := 'CADASTRE UM FORNECEDOR CUJO CNPJ NÃO SEJA O MESMO'

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
        aAdd(aDados, {'A2_CGC    ', jJson:GetJsonObject('CNPJ')     , Nil} )
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
			cArqLog := 'WSFORNEC_New_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
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

WSMETHOD PUT UPDATE WSRECEIVE cnpj WSSERVICE WSFORNEC
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
	cCnpj  := jJson:GetJsonObject('CNPJ')
	cCodi  := jJson:GetJsonObject('CODIGO')
	cLoja  := jJson:GetJsonObject('LOJA')
	::cnpj := jJson:GetJsonObject('CNPJ')

    //Se o id estiver vazio
    If Empty(::cnpj)
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
        If !oWS:temFornec(FWxFilial(cAliasWS), ::cnpj) //(cAliasWS)->(MsSeek(FWxFilial(cAliasWS) + ::cnpj))
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
				 if (SA2->( DbSeek( xFilial("SA2") + cCnpj ) ) )
			 		lMsErroAuto :=  oWS:ATUSA2(aDados, xFilial("SA2"),  cCnpj)
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
		            cArqLog := 'WSFORNEC_New_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
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

WSMETHOD PUT ERASE WSRECEIVE id WSSERVICE WSFORNEC
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
	cCnpj  := jJson:GetJsonObject('CNPJ')
	cCodi  := jJson:GetJsonObject('CODIGO')
	cLoja  := jJson:GetJsonObject('LOJA')
	::cnpj := jJson:GetJsonObject('CNPJ')

    //Se o id estiver vazio
    If Empty(::cnpj)
        //SetRestFault(500, 'Falha ao consultar o registro') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
        Self:setStatus(500) 
        jResponse['errorId']  := 'DEL010'
        jResponse['error']    := 'ID vazio'
        jResponse['solution'] := 'Informe o ID'

		cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
		oWS:GRAVALOGMURO(cResponc, cJason, "WSFORNC", "BLOQUEIO DE FORNECEDOR")

    Else
        If !oWS:temFornec(FWxFilial(cAliasWS), ::cnpj) //(cAliasWS)->(MsSeek(FWxFilial(cAliasWS) + ::cnpj))
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
				 if (SA2->( DbSeek( xFilial("SA2") + cCnpj ) ) )
			 		lMsErroAuto :=  oWS:ATUSA2(aDados, xFilial("SA2"),  cCnpj)
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
		            cArqLog := 'WSFORNEC_New_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
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
