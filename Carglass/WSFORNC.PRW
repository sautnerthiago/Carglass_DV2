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

	//M�todos 
	WSMETHOD GET CNPJ    DESCRIPTION 'Retorna o Registro pesquisado - CNPJ'   WSSYNTAX '/WSFORNEC/listcnpj/cnpj?{cnpj}' 			  PATH '/WSFORNEC/cnpj/{cnpj}'  					PRODUCES APPLICATION_JSON
	WSMETHOD GET TIPO    DESCRIPTION 'Retorna o registro pesquisado - TIPO'   WSSYNTAX '/WSFORNEC/tipolist/{tipo}'   	 			  PATH '/WSFORNEC/tipolist/{tipo}' 					PRODUCES APPLICATION_JSON
	WSMETHOD GET ESTADO  DESCRIPTION 'Retorna o registro pesquisado - ESTADO' WSSYNTAX '/WSFORNEC/estadolist/{estado}'   			  PATH '/WSFORNEC/estadolist/{estado}'        		PRODUCES APPLICATION_JSON
	WSMETHOD GET FORDATA DESCRIPTION 'Retorna o registro pesquisado - DATA'   WSSYNTAX '/WSFORNEC/dataslist/data?{dataDe}&{dataAte}'  PATH '/WSFORNEC/dataslist/{dataDe}/{dataAte}'  	PRODUCES APPLICATION_JSON

    WSMETHOD POST NEW    DESCRIPTION 'Inclus�o de registro'                   WSSYNTAX '/WSFORNEC/new'              PATH 'new'      PRODUCES APPLICATION_JSON
    WSMETHOD PUT  UPDATE DESCRIPTION 'Atualiza��o de registro'                WSSYNTAX '/WSFORNEC/update'           PATH 'update'   PRODUCES APPLICATION_JSON
    WSMETHOD PUT  ERASE  DESCRIPTION 'Blaqueio de registro'                   WSSYNTAX '/WSFORNEC/bloqu'            PATH 'bloqu'    PRODUCES APPLICATION_JSON
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
        //SetRestFault(500, 'Falha ao consultar o registro') //caso queira usar esse comando, voc� n�o poder� usar outros retornos, como os abaixo
        Self:setStatus(500) 
        jResponse['errorId']  := 'ID001'
        jResponse['error']    := 'ID vazio'
        jResponse['solution'] := 'Informe o ID'

		cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
		oWS:GRAVALOGMURO(cResponc, cJason, "WSFORNC", "NAO DIGITADO O FORNECEDOR")

    Else
        DbSelectArea(cAliasWS)
        (cAliasWS)->(DbSetOrder(3))

        //Se n�o encontrar o registro
        If ! (cAliasWS)->(MsSeek(FWxFilial(cAliasWS) + ::cnpj))
            //SetRestFault(500, 'Falha ao consultar ID') //caso queira usar esse comando, voc� n�o poder� usar outros retornos, como os abaixo
            Self:setStatus(500) 
            jResponse['errorId']  := 'ID002'
			jResponse['error']    := 'CNPJ/CPF ('+::cnpj+') n�o encontrado'
			jResponse['solution'] := 'CNPJ/CPF n�o encontrado na tabela ' + cAliasWS
        Else
            //Define o retorno
            jResponse['FILIAL'] 		:= (cAliasWS)->A2_FILIAL 
            jResponse['CODIGO']			:= (cAliasWS)->A2_COD 
            jResponse['LOJA'] 			:= (cAliasWS)->A2_LOJA 
			jResponse['NAME'] 			:= Rtrim( (cAliasWS)->A2_NOME)
			jResponse['NREDUZ'] 		:= Rtrim( (cAliasWs)->A2_NREDUZ )
        	jResponse['DISTRICT'] 		:= Rtrim( (cAliasWs)->A2_BAIRRO )
        	jResponse['EMAIL'] 			:= Rtrim( (cAliasWs)->A2_EMAIL  )
        	jResponse['ZIPCODE'] 		:= Rtrim( (cAliasWs)->A2_CEP    )
        	jResponse['CNPJ'] 			:= Rtrim( (cAliasWs)->A2_CGC    )
        	jResponse['STATE'] 			:= Rtrim( (cAliasWs)->A2_ESTADO )
        	jResponse['COD_MUN']		:= Rtrim( (cAliasWs)->A2_COD_MUN)
        	jResponse['COND'] 			:= Rtrim( (cAliasWs)->A2_COND   )
        	jResponse['DDD'] 			:= Rtrim( (cAliasWs)->A2_DDD    )
        	jResponse['DTCAD'] 			:= (cAliasWs)->A2_DTNASC
        	jResponse['ADDRESS']		:= Rtrim( (cAliasWs)->A2_END    )
        	jResponse['INSCR'] 			:= Rtrim( (cAliasWs)->A2_INSCR  )
        	jResponse['CITY'] 			:= Rtrim( (cAliasWs)->A2_MUN    )
        	jResponse['NATUREZ']		:= Rtrim( (cAliasWs)->A2_NATUREZ)
        	jResponse['PESSOA'] 		:= Rtrim( (cAliasWs)->A2_TPESSOA)
        	jResponse['TIPCLI'] 		:= Rtrim( (cAliasWs)->A2_TIPO )
        	jResponse['TEL'] 			:= Rtrim( (cAliasWs)->A2_TEL    )
        	jResponse['TRANSP'] 		:= Rtrim( (cAliasWs)->A2_TRANSP )
        	jResponse['COUNTRY']		:= Rtrim( (cAliasWS)->A2_PAIS   )
        	jResponse['BLOQUEADO'] 		:= IF ((cAliasWS)->A2_MSBLQL == "2", "NAO", "SIM")
			jResponse['MOVEL']			:= (cAliasWS)->A2_ZMOBILE
			jResponse['TIPOVEICULO']	:= (cAliasWS)->A2_ZTPVEIC
			jResponse['DTCRIACAO']		:= (cAliasWS)->A2_ZDTCRIA
			jResponse['ATIVO']			:= (cAliasWS)->A2_ZATIVO
			jResponse['PAGAMENTOADT']	:= (cAliasWS)->A2_ZPGTADT
			jResponse['REVENDEAFIAL']	:= (cAliasWS)->A2_ZREVAFI
			jResponse['AFILIADOCONV']	:= (cAliasWS)->A2_ZAFICON
			jResponse['TIPOAFILIADO']	:= (cAliasWS)->A2_ZTPAFIL
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
		//SetRestFault(500, 'Falha ao consultar o registro') //caso queira usar esse comando, voc� n�o poder� usar outros retornos, como os abaixo
		Self:setStatus(500)
		jResponse['errorId']  := 'Tipo014'
		jResponse['error']    := 'Tipo Vazio'
		jResponse['solution'] := 'Informe o Tipo'

		cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
		oWS:GRAVALOGMURO(cResponc, cJason, "wsFornTipo", "NAO DIGITADO O TIPO")
	Else
		//Se n�o encontrar o registro
		If  !(::tipo $("0/1/2"))
			//SetRestFault(500, 'Falha ao consultar ID') //caso queira usar esse comando, voc� n�o poder� usar outros retornos, como os abaixo
			Self:setStatus(500)
			jResponse['errorId']  := 'ID015'
			jResponse['error']    := 'TIPO ('+::tipo+') n�o encontrado'
			jResponse['solution'] := 'TIPO n�o encontrado na tabela '

			cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
			oWS:GRAVALOGMURO(cResponc, cJason, "wsFornTipo", "BLOQUEIO DE FORNECEDOR")
		Else
   			jResponse['FORNECEDORES'] := oWS:FornTipo(::tipo)
		    cJson:= FwJsonSerialize( jResponse )			

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
		//SetRestFault(500, 'Falha ao consultar o registro') //caso queira usar esse comando, voc� n�o poder� usar outros retornos, como os abaixo
		Self:setStatus(500)
		jResponse['errorId']  := 'estado011'
		jResponse['error']    := 'estado vazio'
		jResponse['solution'] := 'Informe o estado'

		cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
		oWS:GRAVALOGMURO(cResponc, cJason, "WSFORNEC", "NAO DIGITADO O ESTADO")
	Else
		//Se n�o encontrar o registro
		If (oWS:TemEstado(::estado))
			//SetRestFault(500, 'Falha ao consultar ID') //caso queira usar esse comando, voc� n�o poder� usar outros retornos, como os abaixo
			Self:setStatus(500)
			jResponse['errorId']  := 'ID012'
			jResponse['error']    := 'Estado ('+::estado+') n�o encontrado'
			jResponse['solution'] := 'Estado n�o encontrado na tabela '

			cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
			oWS:GRAVALOGMURO(cResponc, cJason, "WSFORNECE", "BLOQUEIO DE FORNECEDOR")
		Else
			jResponse['FORNECEDORES'] := oWS:FornEst(::estado)
		    cJson:= FwJsonSerialize( jResponse )			

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
		jResponse['FORNECEDORES'] := oWS:FornDatas( dDataDe, dDataAt) 
		cJson:= FwJsonSerialize( jResponse )			

		Self:SetContentType('application/json')
		Self:SetResponse(cJson)
		Return lRet

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

	IF oWS:temFornec(FWxFilial(cAliasWS), ::cnpj)
		//SetRestFault(500, 'Falha ao obter JSON') //caso queira usar esse comando, voc� n�o poder� usar outros retornos, como os abaixo
		Self:setStatus(500)
		jResponse['errorId']  := 'NEW0041'
		jResponse['error']    := 'FORNECEDOR JA EXISTE'
		jResponse['solution'] := 'CADASTRE UM FORNECEDOR CUJO CNPJ N�O SEJA O MESMO'

		cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
		oWS:GRAVALOGMURO(cResponc, cJason, "WSFORNC", "INCLUS�O DE FORNECEDOR")
		lExtFor := .T.
	EndIF
 
    //Se tiver algum erro no Parse, encerra a execu��o
    IF ! Empty(cError)
        //SetRestFault(500, 'Falha ao obter JSON') //caso queira usar esse comando, voc� n�o poder� usar outros retornos, como os abaixo
        Self:setStatus(500) 
        jResponse['errorId']  := 'NEW004'
        jResponse['error']    := 'Parse do JSON'
        jResponse['solution'] := 'Erro ao fazer o Parse do JSON'

		cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
		oWS:GRAVALOGMURO(cResponc, cJason, "WSFORNC", "INCLUS�O DE FORNECEDOR")
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
			//Se o campo for data, retira os hifens e faz a convers�o
			If GetSX3Cache(aDados[nCampo][1], 'X3_TIPO') == 'D'
				aDados[nCampo][2] := StrTran(aDados[nCampo][2], '-', '')
				aDados[nCampo][2] := sToD(aDados[nCampo][2])
			EndIf
		Next

		if !lExtFor
			//Chama a inclus�o autom�tica
			conout("antes do execaut")
			MsExecAuto({|x, y| MATA020(x, y)}, aDados, 3)
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
			cArqLog := 'WSFORNEC_New_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
			MemoWrite(cDirLog + cArqLog, cErrorLog)

			//Define o retorno para o WebService
			//SetRestFault(500, cErrorLog) //caso queira usar esse comando, voc� n�o poder� usar outros retornos, como os abaixo
           Self:setStatus(500) 
			jResponse['errorId']  := 'NEW005'
			jResponse['error']    := 'Erro na inclus�o do registro'
			jResponse['solution'] := 'Nao foi possivel incluir o registro, foi gerado um arquivo de log em ' + cDirLog + cArqLog + ' '
			lRet := .F.

			cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
			oWS:GRAVALOGMURO(cResponc, cErrorLog, "WSFORNC", "INCLUS�O DE FORNECEDOR")

		//Sen�o, define o retorno
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

    //Se n�o existir a pasta de logs, cria
    IF ! ExistDir(cDirLog)
        MakeDir(cDirLog)
    EndIF    

    //Definindo o conte�do como JSON, e pegando o content e dando um parse para ver se a estrutura est� ok
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
        //SetRestFault(500, 'Falha ao consultar o registro') //caso queira usar esse comando, voc� n�o poder� usar outros retornos, como os abaixo
        Self:setStatus(500) 
        jResponse['errorId']  := 'UPD006'
        jResponse['error']    := 'ID vazio'
        jResponse['solution'] := 'Informe o ID'

		cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
		oWS:GRAVALOGMURO(cResponc, cJason, "WSFORNC", "ATUALIZA��O DE FORNECEDOR")
    Else
        DbSelectArea(cAliasWS)
        (cAliasWS)->(DbSetOrder(1))

        //Se n�o encontrar o registro
        If !oWS:temFornec(FWxFilial(cAliasWS), ::cnpj) //(cAliasWS)->(MsSeek(FWxFilial(cAliasWS) + ::cnpj))
            //SetRestFault(500, 'Falha ao consultar ID') //caso queira usar esse comando, voc� n�o poder� usar outros retornos, como os abaixo
            Self:setStatus(500) 
            jResponse['errorId']  := 'UPD007'
            jResponse['error']    := 'ID n�o encontrado'
            jResponse['solution'] := 'C�digo ID n�o encontrado na tabela ' + cAliasWS

			cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
			oWS:GRAVALOGMURO(cResponc, cJason, "WSFORNC", "ATUALIZA��O DE FORNECEDOR")
        Else
 
            //Se tiver algum erro no Parse, encerra a execu��o
            If ! Empty(cError)
                //SetRestFault(500, 'Falha ao obter JSON') //caso queira usar esse comando, voc� n�o poder� usar outros retornos, como os abaixo
                Self:setStatus(500) 
                jResponse['errorId']  := 'UPD008'
                jResponse['error']    := 'Parse do JSON'
                jResponse['solution'] := 'Erro ao fazer o Parse do JSON'

				cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
				oWS:GRAVALOGMURO(cResponc, cJason, "WSFORNC", "ATUALIZA��O DE FORNECEDOR")
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
		         //Se houve erro, gera um arquivo de log dentro do diret�rio da protheus data
		         If lMsErroAuto
		         	//Monta o texto do Error Log que ser� salvo
		         	cErrorLog   := ''
		         	aLogAuto    := GetAutoGrLog()
		         	For nLinha := 1 To Len(aLogAuto)
		         		cErrorLog += aLogAuto[nLinha] + CRLF
		         	Next nLinha

		            //Grava o arquivo de log
		            cArqLog := 'WSFORNEC_New_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
		            MemoWrite(cDirLog + cArqLog, cErrorLog)

		            //Define o retorno para o WebService
		            //SetRestFault(500, cErrorLog) //caso queira usar esse comando, voc� n�o poder� usar outros retornos, como os abaixo
		            Self:setStatus(500) 
		            jResponse['errorId']  := 'UPD009'
		            jResponse['error']    := 'Erro na atualiza��o do registro'
		            jResponse['solution'] := 'Nao foi possivel incluir o registro, foi gerado um arquivo de log em ' + cDirLog + cArqLog + ' '
		            lRet := .F.

					cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
					oWS:GRAVALOGMURO(cResponc, cErrorLog, "WSFORNC", "ATUALIZA��O DE FORNECEDOR")

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

    //Se n�o existir a pasta de logs, cria
    IF ! ExistDir(cDirLog)
        MakeDir(cDirLog)
    EndIF    

    //Definindo o conte�do como JSON, e pegando o content e dando um parse para ver se a estrutura est� ok
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
        //SetRestFault(500, 'Falha ao consultar o registro') //caso queira usar esse comando, voc� n�o poder� usar outros retornos, como os abaixo
        Self:setStatus(500) 
        jResponse['errorId']  := 'DEL010'
        jResponse['error']    := 'ID vazio'
        jResponse['solution'] := 'Informe o ID'

		cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
		oWS:GRAVALOGMURO(cResponc, cJason, "WSFORNC", "BLOQUEIO DE FORNECEDOR")

    Else
        If !oWS:temFornec(FWxFilial(cAliasWS), ::cnpj) //(cAliasWS)->(MsSeek(FWxFilial(cAliasWS) + ::cnpj))
            //SetRestFault(500, 'Falha ao consultar ID') //caso queira usar esse comando, voc� n�o poder� usar outros retornos, como os abaixo
            Self:setStatus(500) 
            jResponse['errorId']  := 'DEL011'
            jResponse['error']    := 'ID n�o encontrado'
            jResponse['solution'] := 'C�digo ID n�o encontrado na tabela ' + cAliasWS
	
			cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
			oWS:GRAVALOGMURO(cResponc, cJason, "WSFORNC", "BLOQUEIO DE FORNECEDOR")
        Else
 
            //Se tiver algum erro no Parse, encerra a execu��o
            If ! Empty(cError)
                //SetRestFault(500, 'Falha ao obter JSON') //caso queira usar esse comando, voc� n�o poder� usar outros retornos, como os abaixo
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


		         //Se houve erro, gera um arquivo de log dentro do diret�rio da protheus data
		         If lMsErroAuto
		         	//Monta o texto do Error Log que ser� salvo
		         	cErrorLog   := ''
		         	aLogAuto    := GetAutoGrLog()
		         	For nLinha := 1 To Len(aLogAuto)
		         		cErrorLog += aLogAuto[nLinha] + CRLF
		         	Next nLinha

		            //Grava o arquivo de log
		            cArqLog := 'WSFORNEC_New_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
		            MemoWrite(cDirLog + cArqLog, cErrorLog)

		            //Define o retorno para o WebService
		            //SetRestFault(500, cErrorLog) //caso queira usar esse comando, voc� n�o poder� usar outros retornos, como os abaixo
		            Self:setStatus(500) 
		            jResponse['errorId']  := 'DEL013'
		            jResponse['error']    := 'Erro na exclus�o do registro'
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
