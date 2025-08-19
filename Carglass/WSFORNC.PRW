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
    WSDATA cnpj       AS STRING OPTIONAL
	WSDATA estado     AS STRING OPTIONAL
	WSDATA dataDe     AS STRING OPTIONAL
	WSDATA dataAte    AS STRING OPTIONAL
	WSDATA tipo       AS STRING OPTIONAL
	WSDATA tpFiliado  AS STRING 


	WSDATA page AS INTEGER OPTIONAL
	WSDATA pageSize AS INTEGER OPTIONAL
	WSDATA searchKey AS STRING OPTIONAL

	//Métodos
	WSMETHOD GET supplier DESCRIPTION "Retorna lista de Fornecedores" WSSYNTAX "/WSFORNEC/fornecedores " PATH '/WSFORNEC/fornecedores' PRODUCES APPLICATION_JSON
	//Métodos 
	WSMETHOD GET CNPJ    DESCRIPTION 'Retorna o Registro pesquisado - CNPJ'   		WSSYNTAX '/WSFORNEC/listcnpj/cnpj?{cnpj}' 			  	PATH '/WSFORNEC/cnpj/{cnpj}'  					PRODUCES APPLICATION_JSON
	WSMETHOD GET TIPO    DESCRIPTION 'Retorna o registro pesquisado - TIPO'   		WSSYNTAX '/WSFORNEC/tipolist/{tipo}'   	 			  	PATH '/WSFORNEC/tipolist/{tipo}' 				PRODUCES APPLICATION_JSON
	WSMETHOD GET ESTADO  DESCRIPTION 'Retorna o registro pesquisado - ESTADO' 		WSSYNTAX '/WSFORNEC/estadolist/{estado}'   			  	PATH '/WSFORNEC/estadolist/{estado}'        	PRODUCES APPLICATION_JSON
	WSMETHOD GET FORDATA DESCRIPTION 'Retorna o registro pesquisado - DATA'   		WSSYNTAX '/WSFORNEC/dataslist/data?{dataDe}&{dataAte}'  PATH '/WSFORNEC/dataslist/{dataDe}/{dataAte}'  	PRODUCES APPLICATION_JSON
	WSMETHOD GET INTEGRA DESCRIPTION 'Retorna o registro pesquisado - INTEGRADO'   	WSSYNTAX '/WSFORNEC/integrado/{tpFiliado}'				PATH '/WSFORNEC/integrado/{tpFiliado}'			PRODUCES APPLICATION_JSON

    WSMETHOD POST NEW    DESCRIPTION 'Inclusão de registro'                   WSSYNTAX '/WSFORNEC/new'              PATH 'new'      PRODUCES APPLICATION_JSON
    WSMETHOD PUT  UPDATE DESCRIPTION 'Atualização de registro'                WSSYNTAX '/WSFORNEC/update'           PATH 'update'   PRODUCES APPLICATION_JSON
    WSMETHOD PUT  ERASE  DESCRIPTION 'Blaqueio de registro'                   WSSYNTAX '/WSFORNEC/delete'           PATH 'delete'    PRODUCES APPLICATION_JSON
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
    Local cJason	 := ""
    ::cnpj			 := Self:cnpj //SELF:AQUERYSTRING[1][1]  //self:querystring[1,1]

	oWS    := LIBGLASS():new()

    //Se o id estiver vazio
    If Empty(::cnpj)
        //SetRestFault(500, 'Falha ao consultar o registro') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
        Self:setStatus(500) 
        jResponse['errorId']  := 'ID001'
        jResponse['error']    := 'ID vazio'
        jResponse['solution'] := 'Informe o ID'

		cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
		oWS:GRAVALOGMURO(cResponc, cJason, "WSFORNC", "NAO DIGITADO O FORNECEDOR")

    Else
        //DbSelectArea(cAliasWS)
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
            jResponse['FILIAL'] 		:= Rtrim( (cAliasWS)->A2_FILIAL)
            jResponse['CODIGO']			:= Rtrim( (cAliasWS)->A2_COD)
            jResponse['LOJA'] 			:= Rtrim( (cAliasWS)->A2_LOJA )
			jResponse['NOME'] 			:= Rtrim( (cAliasWS)->A2_NOME)
			jResponse['NREDUZ'] 		:= Rtrim( (cAliasWs)->A2_NREDUZ )
        	jResponse['BAIRRO'] 		:= Rtrim( (cAliasWs)->A2_BAIRRO )
        	jResponse['EMAIL'] 			:= Rtrim( (cAliasWs)->A2_EMAIL  )
        	jResponse['CEP'] 			:= Rtrim( (cAliasWs)->A2_CEP    )
        	jResponse['CNPJ'] 			:= Rtrim( (cAliasWs)->A2_CGC    )
        	jResponse['ESTADO']			:= Rtrim( (cAliasWs)->A2_ESTADO )
        	jResponse['COD_MUN']		:= Rtrim( (cAliasWs)->A2_COD_MUN)
        	jResponse['COND'] 			:= Rtrim( (cAliasWs)->A2_COND   )
        	jResponse['DDD'] 			:= Rtrim( (cAliasWs)->A2_DDD    )
        	jResponse['DTCAD'] 			:= (cAliasWs)->A2_DTNASC
        	jResponse['END']			:= Rtrim( (cAliasWs)->A2_END    )
        	jResponse['INSCR'] 			:= Rtrim( (cAliasWs)->A2_INSCR  )
        	jResponse['MUNICIPIO']		:= Rtrim( (cAliasWs)->A2_MUN    )
        	jResponse['NATUREZ']		:= Rtrim( (cAliasWs)->A2_NATUREZ)
        	jResponse['PESSOA'] 		:= Rtrim( (cAliasWs)->A2_TPESSOA)
        	jResponse['TIPO']	 		:= Rtrim( (cAliasWs)->A2_TIPO )
        	jResponse['FONE'] 			:= Rtrim( (cAliasWs)->A2_TEL    )
        	jResponse['TRANSP'] 		:= Rtrim( (cAliasWs)->A2_TRANSP )
        	jResponse['PAIS']			:= Rtrim( (cAliasWS)->A2_PAIS   )
        	jResponse['BLOQUEADO'] 		:= IF ((cAliasWS)->A2_MSBLQL == "2", "NAO", "SIM")
			jResponse['MOVEL']			:= (cAliasWS)->A2_ZMOBILE
			jResponse['TIPOVEICULO']	:= (cAliasWS)->A2_ZTPVEIC
			jResponse['DTCRIACAO']		:= (cAliasWS)->A2_ZDTCRIA
			jResponse['ATIVO']			:= (cAliasWS)->A2_ZATIVO
			jResponse['PAGAMENTOADT']	:= (cAliasWS)->A2_ZPGTADT
			jResponse['REVENDEAFIAL']	:= (cAliasWS)->A2_ZREVAFI
			jResponse['AFILIADOCONV']	:= (cAliasWS)->A2_ZAFICON
			jResponse['TIPOAFILIADO']	:= (cAliasWS)->A2_ZTPAFIL
			jResponse['INTEGRADO']	    := (cAliasWS)->A2_ZINTEGR
        EndIf
    EndIf

    //Define o retorno
    Self:SetContentType('application/json')
    Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
Return lRet

WSMETHOD GET TIPO WSRECEIVE tipo WSSERVICE WSFORNEC
	Local lRet       := .T.
	Local jResponse  := JsonObject():New()
	//Local cAliasWS   := 'SA1'
	::tipo			 := self:tipo //SELF:AQUERYSTRING[1][1]  //self:querystring[1,1]
	Local cJason	 := ""
	oWS    := LIBGLASS():new()

	//Se o id estiver vazio
	If Empty(::tipo)
		//SetRestFault(500, 'Falha ao consultar o registro') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
		Self:setStatus(500)
		jResponse['errorId']  := 'Tipo014'
		jResponse['error']    := 'Tipo Vazio'
		jResponse['solution'] := 'Informe o Tipo'

		cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
		oWS:GRAVALOGMURO(cResponc, cJason, "wsFornTipo", "NAO DIGITADO O TIPO")
	Else
		//Se não encontrar o registro
		If  !(::tipo $("0/1/2"))
			//SetRestFault(500, 'Falha ao consultar ID') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
			Self:setStatus(500)
			jResponse['errorId']  := 'ID015'
			jResponse['error']    := 'TIPO ('+::tipo+') não encontrado'
			jResponse['solution'] := 'TIPO não encontrado na tabela '

			cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
			oWS:GRAVALOGMURO(cResponc, cJason, "wsFornTipo", "BLOQUEIO DE FORNECEDOR")
		Else
   			//jResponse['FORNECEDORES'] := oWS:FornTipo(::tipo)
		    cJson:= FwJsonSerialize( oWS:FornTipo(::tipo) )			

			Self:SetContentType('application/json')
			Self:SetResponse(cJson)
			RETURN lRet
		EndIf
	EndIf

	//Define o retorno
	Self:SetContentType('application/json')
	Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
Return lRet

WSMETHOD GET ESTADO WSRECEIVE estado WSSERVICE WSFORNEC
	Local lRet       := .T.
	Local jResponse  := JsonObject():New()
	//Local cAliasWS   := 'SA1'
	::estado		 := self:estado //SELF:AQUERYSTRING[1][1]  //self:querystring[1,1]
	Local cJason	 := ""
	oWS    := LIBGLASS():new()

	//Se o id estiver vazio
	If Empty(::estado)
		//SetRestFault(500, 'Falha ao consultar o registro') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
		Self:setStatus(500)
		jResponse['errorId']  := 'estado011'
		jResponse['error']    := 'estado vazio'
		jResponse['solution'] := 'Informe o estado'

		cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
		oWS:GRAVALOGMURO(cResponc, cJason, "WSFORNEC", "NAO DIGITADO O ESTADO")
	Else
		//Se não encontrar o registro
		If (oWS:TemEstado(::estado))
			//SetRestFault(500, 'Falha ao consultar ID') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
			Self:setStatus(500)
			jResponse['errorId']  := 'ID012'
			jResponse['error']    := 'Estado ('+::estado+') não encontrado'
			jResponse['solution'] := 'Estado não encontrado na tabela '

			cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
			oWS:GRAVALOGMURO(cResponc, cJason, "WSFORNECE", "BLOQUEIO DE FORNECEDOR")
		Else
			//jResponse['FORNECEDORES'] := oWS:FornEst(::estado)
		    cJson:= FwJsonSerialize( oWS:FornEst(::estado) )			

			Self:SetContentType('application/json')
			Self:SetResponse(cJson)
			Return lRet
		EndIf
	EndIf

	//Define o retorno
	Self:SetContentType('application/json')
	Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
Return lRet

WSMETHOD GET FORDATA WSRECEIVE dataDe, dataAte WSSERVICE WSFORNEC
	Local lRet       := .T.
	Local jResponse  := JsonObject():New()
	//Local cAliasWS   := 'SA1'

	Local dDataDe	 := self:dataDe
	Local dDataAt	 := self:dataAte
	
	Local cJason	 := ""
	oWS    := LIBGLASS():new()

	//Se o id estiver vazio
	If Empty(dDataDe) .and. Empty(dDataAt)
		Self:setStatus(500)
		jResponse['errorId']  := 'Tipo016'
		jResponse['error']    := 'Datas Vazias'
		jResponse['solution'] := 'Informe datas'

		cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
		oWS:GRAVALOGMURO(cResponc, cJason, "WSFORNC", "NAO DIGITADAS AS DATAS")
	Else
		// Converte para JSON
		//jResponse['FORNECEDORES'] := oWS:FornDatas( dDataDe, dDataAt) 
		cJson:= FwJsonSerialize( oWS:FornDatas( dDataDe, dDataAt) )			

		Self:SetContentType('application/json')
		Self:SetResponse(cJson)
		Return lRet

	EndIf

	//Define o retorno
	Self:SetContentType('application/json')
	Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
Return lRet

WSMETHOD GET INTEGRA WSRECEIVE tpFiliado WSSERVICE WSFORNEC
	Local lRet       := .T.
	Local jResponse  := JsonObject():New()
	Local cTpFld	 := self:tpFiliado

	oWS     := LIBGLASS():new()
	cJsonNfs:= FwJsonSerialize( oWS:Integrado( "SA2", cTpFld )  )

	If Empty(cJsonNfs) 
		Self:setStatus(500)
		jResponse['errorId']  := 'Tipo016'
		jResponse['error']    := 'Não ha dados a serem integrados'
		jResponse['solution'] := 'Não ha dados a Integrar'

		cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
		oWS:GRAVALOGMURO(cResponc, cJason, "WSFORNECE", "NAO HA DADOS A SEREM INTEGRADOS")
	Else
	//Define o retorno
		Self:SetContentType('application/json')
		Self:SetResponse(cJsonNfs)
	ENDIF	

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

 	cEmpAt1 := cEmpAnt
    cFilAt1 := cFilAnt

    cEmpAt   := Iif(EMPTY(jJson:GetJsonObject("GRUPO") ), "01", jJson:GetJsonObject("GRUPO" ))
    cFilAt   := Iif(EMPTY(jJson:GetJsonObject("FILIAL")), "01", jJson:GetJsonObject("FILIAL"))

    cEmpAnt  := cEmpAt
    cFilAnt  := cFilAt
    
    RPCSetEnv(cEmpAt, cFilAt)

    //Definindo o conteúdo como JSON, e pegando o content e dando um parse para ver se a estrutura está ok
    Self:SetContentType('application/json')
    jJson  := JsonObject():New()
    cError := jJson:FromJson(cJson)
	cJason := cJson
	::cnpj := jJson:GetJsonObject('CNPJ')

	//cCodi  := jJson:GetJsonObject('CODIGO')
	//cLoja  := jJson:GetJsonObject('LOJA')
  
	cCodi  := Iif(empty(jJson:GetJsonObject('CODIGO')), oWS:GerCdFor() , jJson:GetJsonObject('CODIGO'))
	cLoja  := iif(empty(jJson:GetJsonObject('LOJA')), "01", jJson:GetJsonObject('LOJA'))

	lBloq  := iif(jJson:GetJsonObject('BLOQUEADO')=="N" .or. Empty(jJson:GetJsonObject('BLOQUEADO')), "2", "1")
	lAtivo := iif( jJson:GetJsonObject('ATIVO')=="N" .or. Empty(jJson:GetJsonObject('ATIVO')), "N", "S")

    cMOVEL := iif( jJson:GetJsonObject('MOVEL') == "" 		 , "N", jJson:GetJsonObject('MOVEL') )
    cTIPOV := iif( jJson:GetJsonObject('TIPOVEICULO')  == "" , "N", jJson:GetJsonObject('TIPOVEICULO') )
    cPAGAM := iif( jJson:GetJsonObject('PAGAMENTOADT') == "" , "N", jJson:GetJsonObject('PAGAMENTOADT') )
    cREVEN := iif( jJson:GetJsonObject('REVENDEAFIAL') == "" , "N", jJson:GetJsonObject('REVENDEAFIAL') )
    cAFILI := iif( jJson:GetJsonObject('AFILIADOCONV') == "" , "N", jJson:GetJsonObject('AFILIADOCONV') )
    cTIPOA := iif( jJson:GetJsonObject('TIPOAFILIADO') == "" , "N", jJson:GetJsonObject('TIPOAFILIADO') )

   	CONFIRMSX8()


	IF oWS:temFornec(FWxFilial(cAliasWS), ::cnpj) //.OR. oWS:temForCod(FWxFilial(cAliasWS), cCodi, cLoja)    
		//SetRestFault(500, 'Falha ao obter JSON') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
		Self:setStatus(500)
		jResponse['errorId']  := 'NEW0041'
		jResponse['error']    := 'FORNECEDOR JA EXISTE'
		jResponse['errorLog'] := cErrorLog
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
		jResponse['errorLog'] := cErrorLog
        jResponse['solution'] := 'Erro ao fazer o Parse do JSON'

		cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
		oWS:GRAVALOGMURO(cResponc, cJason, "WSFORNC", "INCLUSÃO DE FORNECEDOR")
    Else
		DbSelectArea(cAliasWS)

		//Adiciona os dados do ExecAuto
		aAdd(aDados, {'A2_FILIAL' , FWCodFil()                      , Nil} )
		aAdd(aDados, {'A2_COD'    , cCodi   						, Nil} )
		aAdd(aDados, {'A2_LOJA'   , cLoja   						, Nil} )
		aAdd(aDados, {'A2_NOME'   , jJson:GetJsonObject('NOME')     , Nil} )
		aAdd(aDados, {'A2_NREDUZ ', jJson:GetJsonObject('NREDUZ')   , Nil} )
        aAdd(aDados, {'A2_BAIRRO ', jJson:GetJsonObject('BAIRRO')   , Nil} )
        aAdd(aDados, {'A2_EMAIL  ', jJson:GetJsonObject('EMAIL')    , Nil} )
        aAdd(aDados, {'A2_CEP    ', jJson:GetJsonObject('CEP')      , Nil} )
        aAdd(aDados, {'A2_CGC    ', jJson:GetJsonObject('CNPJ')     , Nil} )
        aAdd(aDados, {'A2_EST    ', jJson:GetJsonObject('ESTADO')   , Nil} )
        aAdd(aDados, {'A2_COD_MUN', jJson:GetJsonObject('COD_MUN')  , Nil} )
        //aAdd(aDados, {'A2_COND   ', jJson:GetJsonObject('COND')     , Nil} )
        aAdd(aDados, {'A2_DDD    ', jJson:GetJsonObject('DDD')      , Nil} )
        aAdd(aDados, {'A2_END    ', jJson:GetJsonObject('END')      , Nil} )
        aAdd(aDados, {'A2_INSCR  ', jJson:GetJsonObject('INSCR')    , Nil} )
        aAdd(aDados, {'A2_MUN    ', jJson:GetJsonObject('MUNICIPIO'), Nil} )
        //aAdd(aDados, {'A2_NATUREZ', jJson:GetJsonObject('NATUREZ')  , Nil} )
        aAdd(aDados, {'A2_TIPO   ', jJson:GetJsonObject('TIPO')     , Nil} )
        aAdd(aDados, {'A2_TEL    ', jJson:GetJsonObject('FONE')     , Nil} )
        //aAdd(aDados, {'A2_TRANSP ', jJson:GetJsonObject('TRANSP')   , Nil} )
        aAdd(aDados, {'A2_PAIS   ', '105'  							, Nil} )
		aAdd(aDados, {'A2_ZINTEGR', jJson:GetJsonObject('INTEGRADO'), Nil} )
		aAdd(aDados, {'A2_ZMOBILE', cMOVEL							, Nil} )
		aAdd(aDados, {'A2_ZTPVEIC', cTIPOV							, Nil} )
		aAdd(aDados, {'A2_ZPGTADT', cPAGAM							, Nil} )
		aAdd(aDados, {'A2_ZREVAFI', cREVEN							, Nil} )
		aAdd(aDados, {'A2_ZAFICON', cAFILI							, Nil} )
		aAdd(aDados, {'A2_ZTPAFIL', cTIPOA							, Nil} )
		aAdd(aDados, {'A2_MSBLQL' , lBloq 							, Nil} )
		aAdd(aDados, {'A2_ZATIVO' , lAtivo	    					, Nil} )

		//Percorre os dados do execauto
		For nCampo := 1 To Len(aDados)
			//Se o campo for data, retira os hifens e faz a conversão
			If GetSX3Cache(aDados[nCampo][1], 'X3_TIPO') == 'D'
				//aDados[nCampo][2] := StrTran(aDados[nCampo][2], '-', '')
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
			jResponse['errorLog'] := cErrorLog
			jResponse['solution'] := 'Nao foi possivel incluir o registro, foi gerado um arquivo de log em ' + cDirLog + cArqLog + ' '
			lRet := .F.

			cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
			oWS:GRAVALOGMURO(cResponc, cErrorLog, "WSFORNC", "INCLUSÃO DE FORNECEDOR")

		//Senão, define o retorno
		Else
			jResponse['note']     := 'Registro incluido com sucesso'
		EndIf

    EndIf

	rpcClearEnv()
    cEmpAnt  := cEmpAt1
    cFilAnt  := cFilAt1
	
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

	lBloq  := iif(jJson:GetJsonObject('BLOQUEADO')=="N" .or. Empty(jJson:GetJsonObject('BLOQUEADO')), "2", "1")
	lAtivo := iif( jJson:GetJsonObject('ATIVO')=="N" .or. Empty(jJson:GetJsonObject('ATIVO')), "N", "S")

    //cMOVEL := iif( jJson:GetJsonObject('MOVEL') == "" , "N", "S")
    //cTIPOV := iif( jJson:GetJsonObject('TIPOVEICULO')  == "" , "N", "S")
    //cPAGAM := iif( jJson:GetJsonObject('PAGAMENTOADT') == "" , "N", "S")
    //cREVEN := iif( jJson:GetJsonObject('REVENDEAFIAL') == "" , "N", "S")
    //cAFILI := iif( jJson:GetJsonObject('AFILIADOCONV') == "" , "N", "S")
    //cTIPOA := iif( jJson:GetJsonObject('TIPOAFILIADO') == "" , "N", "S")

    cMOVEL := iif( jJson:GetJsonObject('MOVEL') == "" 		 , "N", jJson:GetJsonObject('MOVEL') )
    cTIPOV := iif( jJson:GetJsonObject('TIPOVEICULO')  == "" , "N", jJson:GetJsonObject('TIPOVEICULO') )
    cPAGAM := iif( jJson:GetJsonObject('PAGAMENTOADT') == "" , "N", jJson:GetJsonObject('PAGAMENTOADT') )
    cREVEN := iif( jJson:GetJsonObject('REVENDEAFIAL') == "" , "N", jJson:GetJsonObject('REVENDEAFIAL') )
    cAFILI := iif( jJson:GetJsonObject('AFILIADOCONV') == "" , "N", jJson:GetJsonObject('AFILIADOCONV') )
    cTIPOA := iif( jJson:GetJsonObject('TIPOAFILIADO') == "" , "N", jJson:GetJsonObject('TIPOAFILIADO') )


    //Se o id estiver vazio
    If Empty(::cnpj) 
        //SetRestFault(500, 'Falha ao consultar o registro') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
        Self:setStatus(500) 
        jResponse['errorId']  := 'UPD006'
        jResponse['error']    := 'CNPJ VAZIO E/OU CODIGO E LOJA VAZIOS'
		jResponse['errorLog'] := cErrorLog
        jResponse['solution'] := 'Informe o CNPJ, CODIGO E LOJA'

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
            jResponse['error']    := 'CNPJ não encontrado'
			jResponse['errorLog'] := cErrorLog
            jResponse['solution'] := 'CNPJ não encontrado na tabela ' + cAliasWS

			cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
			oWS:GRAVALOGMURO(cResponc, cJason, "WSFORNC", "ATUALIZAÇÃO DE FORNECEDOR")
        Else
 
            //Se tiver algum erro no Parse, encerra a execução
            If ! Empty(cError)
                //SetRestFault(500, 'Falha ao obter JSON') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
                Self:setStatus(500) 
                jResponse['errorId']  := 'UPD008'
                jResponse['error']    := 'Parse do JSON'
				jResponse['errorLog'] := cErrorLog
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
				aAdd(aDados, {'A2_ZINTEGR', jJson:GetJsonObject('INTEGRADO'), Nil} )
				aAdd(aDados, {'A2_ZMOBILE', cMOVEL							, Nil} )
				aAdd(aDados, {'A2_ZTPVEIC', cTIPOV							, Nil} )
				aAdd(aDados, {'A2_ZPGTADT', cPAGAM							, Nil} )
				aAdd(aDados, {'A2_ZREVAFI', cREVEN							, Nil} )
				aAdd(aDados, {'A2_ZAFICON', cAFILI							, Nil} )
				aAdd(aDados, {'A2_ZTPAFIL', cTIPOA							, Nil} )
				aAdd(aDados, {'A2_MSBLQL' , lBloq    						, Nil} )
				aAdd(aDados, {'A2_ZATIVO' , lAtivo	    					, Nil} )
		         
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
					jResponse['errorLog'] := cErrorLog
		            jResponse['solution'] := 'Nao foi possivel incluir o registro, foi gerado um arquivo de log em ' + cDirLog + cArqLog + ' '
		            lRet := .F.

					cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
					oWS:GRAVALOGMURO(cResponc, cErrorLog, "WSFORNC", "ATUALIZAÇÃO DE FORNECEDOR")

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
    If Empty(::cnpj) .OR. !oWS:temForCod(FWxFilial(cAliasWS), cCodi, cLoja)    
        //SetRestFault(500, 'Falha ao consultar o registro') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
        Self:setStatus(500) 
        jResponse['errorId']  := 'DEL010'
        jResponse['error']    := 'CNPJ VAZIO E/OU CODIGO E LOJA VAZIOS'
		jResponse['errorLog'] := cErrorLog
        jResponse['solution'] := 'Informe o CNPJ, CODIGO E LOJA'

		cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
		oWS:GRAVALOGMURO(cResponc, cJason, "WSFORNC", "BLOQUEIO DE FORNECEDOR")

    Else
        If !oWS:temFornec(FWxFilial(cAliasWS), ::cnpj) //(cAliasWS)->(MsSeek(FWxFilial(cAliasWS) + ::cnpj))
            //SetRestFault(500, 'Falha ao consultar ID') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
            Self:setStatus(500) 
            jResponse['errorId']  := 'DEL011'
            jResponse['error']    := 'CNPJ não encontrado'
			jResponse['errorLog'] := cErrorLog
            jResponse['solution'] := 'CNPJ não encontrado na tabela ' + cAliasWS
	
			cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
			oWS:GRAVALOGMURO(cResponc, cJason, "WSFORNC", "BLOQUEIO DE FORNECEDOR")
        Else
 
            //Se tiver algum erro no Parse, encerra a execução
            If ! Empty(cError)
                //SetRestFault(500, 'Falha ao obter JSON') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
                Self:setStatus(500) 
                jResponse['errorId']  := 'DEL012'
                jResponse['error']    := 'Parse do JSON'
				jResponse['errorLog'] := cErrorLog
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
					jResponse['errorLog'] := cErrorLog
		            jResponse['solution'] := 'Nao foi possivel incluir o registro, foi gerado um arquivo de log em ' + cDirLog + cArqLog + ' '
		            lRet := .F.
					cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
					oWS:GRAVALOGMURO(cResponc, cErrorLog, "WSFORNC", "BLOQUEIO DE FORNECEDOR")
		         Else
		         	jResponse['note']     := 'Registro Bloqueado com sucesso'
		         EndIf

		     EndIf
		 EndIf
    EndIf

    //Define o retorno
    Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
Return lRet

WSMETHOD GET supplier WSRECEIVE searchKey, page, pageSize WSREST WSFORNEC

	Local aList := {}

	Local cAlias := GetNextAlias()
	Local cJsonFor := ''
	Local cSearch := ''
	Local cWhere := "AND SA2.A2_FILIAL = '"+xFilial('SA2')+"' AND SA2.A2_ZINTEGR <> 'S' "

	Local lRet := .T.

	Local nCount := 0
	Local nStart := 1
	Local nReg := 0
	Local nAux := 0

	Local oJsonFor := JsonObject():New()

	Default self:searchKey := ''
	Default self:page := 1
	Default self:pageSize := 10

	//-------------------------------------------------------------------
	// Tratativas para a chave de busca
	//-------------------------------------------------------------------
	If !Empty(self:searchKey)
		cSearch := AllTrim( Upper( Self:SearchKey ) )
		cWhere += " AND ( SA2.A2_COD LIKE '%" + cSearch + "%' OR "
		cWhere += " SA2.A2_LOJA LIKE '%" + cSearch + "%' OR "
		cWhere += " SA2.A2_NOME LIKE '%" + FwNoAccent( cSearch ) + "%' OR "
		cWhere += " SA2.A2_NOME LIKE '%" + cSearch + "%' ) "
	EndIf

	cWhere := '%'+cWhere+'%'

	//-------------------------------------------------------------------
	// Query para selecionar clientes
	//-------------------------------------------------------------------
	BEGINSQL Alias cAlias
 
	SELECT SA2.A2_FILIAL,SA2.A2_COD,SA2.A2_LOJA ,SA2.A2_NOME,SA2.A2_NREDUZ,;
	SA2.A2_BAIRRO ,SA2.A2_EMAIL  ,SA2.A2_CEP    ,SA2.A2_CGC,;
	SA2.A2_ESTADO ,SA2.A2_COD_MUN,SA2.A2_COND   ,SA2.A2_DDD,;
	SA2.A2_DTNASC,SA2.A2_END    ,SA2.A2_INSCR  ,SA2.A2_MUN,;
	SA2.A2_NATUREZ,SA2.A2_TPESSOA,SA2.A2_TIPO ,SA2.A2_TEL,;
	SA2.A2_TRANSP ,SA2.A2_PAIS   ,SA2.A2_MSBLQL,SA2.A2_ZMOBILE,;
	SA2.A2_ZTPVEIC,SA2.A2_ZDTCRIA,SA2.A2_ZATIVO,SA2.A2_ZPGTADT,;
	SA2.A2_ZREVAFI,SA2.A2_ZAFICON,SA2.A2_ZTPAFIL,SA2.A2_ZINTEGR
	FROM %table:SA2% SA2
	WHERE SA2.%NotDel%
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
			oJsonFor['hasNext'] := .T.
		Else
			oJsonFor['hasNext'] := .F.
		EndIf
	Else
		//-------------------------------------------------------------------
		// Nao encontrou registros
		//-------------------------------------------------------------------
		oJsonFor['hasNext'] := .F.
	EndIf

	//-------------------------------------------------------------------
	// Alimenta array de clientes
	//-------------------------------------------------------------------
	While ( cAlias )->( ! Eof() )

		nCount++

		If nCount >= nStart

			nAux++
			aAdd( aList , JsonObject():New() )
            aList[nAux]['FILIAL'] 	:= Rtrim( (cAlias)->A2_FILIAL)
            aList[nAux]['CODIGO']	:= Rtrim( (cAlias)->A2_COD)
            aList[nAux]['LOJA'] 	:= Rtrim( (cAlias)->A2_LOJA )
			aList[nAux]['NOME'] 	:= Rtrim( (cAlias)->A2_NOME)
			aList[nAux]['NREDUZ'] 	:= Rtrim( (cAlias)->A2_NREDUZ )
        	aList[nAux]['BAIRRO'] 	:= Rtrim( (cAlias)->A2_BAIRRO )
        	aList[nAux]['EMAIL'] 	:= Rtrim( (cAlias)->A2_EMAIL  )
        	aList[nAux]['CEP'] 		:= Rtrim( (cAlias)->A2_CEP    )
        	aList[nAux]['CNPJ'] 	:= Rtrim( (cAlias)->A2_CGC    )
        	aList[nAux]['ESTADO']	:= Rtrim( (cAlias)->A2_ESTADO )
        	aList[nAux]['COD_MUN']	:= Rtrim( (cAlias)->A2_COD_MUN)
        	aList[nAux]['COND'] 	:= Rtrim( (cAlias)->A2_COND   )
        	aList[nAux]['DDD'] 		:= Rtrim( (cAlias)->A2_DDD    )
        	aList[nAux]['DTCAD'] 	:= (cAlias)->A2_DTNASC
        	aList[nAux]['END']		:= Rtrim( (cAlias)->A2_END    )
        	aList[nAux]['INSCR'] 	:= Rtrim( (cAlias)->A2_INSCR  )
        	aList[nAux]['MUNICIPIO']:= Rtrim( (cAlias)->A2_MUN    )
        	aList[nAux]['NATUREZ']	:= Rtrim( (cAlias)->A2_NATUREZ)
        	aList[nAux]['PESSOA'] 	:= Rtrim( (cAlias)->A2_TPESSOA)
        	aList[nAux]['TIPO']	 	:= Rtrim( (cAlias)->A2_TIPO )
        	aList[nAux]['FONE'] 	:= Rtrim( (cAlias)->A2_TEL    )
        	aList[nAux]['TRANSP'] 	:= Rtrim( (cAlias)->A2_TRANSP )
        	aList[nAux]['PAIS']		:= Rtrim( (cAlias)->A2_PAIS   )
        	aList[nAux]['BLOQUEADO']:= IF ((cAlias)->A2_MSBLQL == "2", "NAO", "SIM")
			aList[nAux]['MOVEL']	:= (cAlias)->A2_ZMOBILE
			aList[nAux]['TIPOVEICULO']	:= (cAlias)->A2_ZTPVEIC
			aList[nAux]['DTCRIACAO']	:= (cAlias)->A2_ZDTCRIA
			aList[nAux]['ATIVO']		:= (cAlias)->A2_ZATIVO
			aList[nAux]['PAGAMENTOADT']	:= (cAlias)->A2_ZPGTADT
			aList[nAux]['REVENDEAFIAL']	:= (cAlias)->A2_ZREVAFI
			aList[nAux]['AFILIADOCONV']	:= (cAlias)->A2_ZAFICON
			aList[nAux]['TIPOAFILIADO']	:= (cAlias)->A2_ZTPAFIL
			aList[nAux]['INTEGRADO']    := (cAlias)->A2_ZINTEGR
			If Len(aList) >= self:pageSize
				Exit
			EndIf

		EndIf

		( cAlias )->( DBSkip() )

	End

	( cAlias )->( DBCloseArea() )

	oJsonFor['Fornecedores'] := aList

	//-------------------------------------------------------------------
	// Serializa objeto Json
	//-------------------------------------------------------------------
	cJsonFor:= FwJsonSerialize( oJsonFor )

	//-------------------------------------------------------------------
	// Elimina objeto da memoria
	//-------------------------------------------------------------------
	FreeObj(oJsonFor)

	Self:SetResponse( cJsonFor ) //-- Seta resposta

Return( lRet )
