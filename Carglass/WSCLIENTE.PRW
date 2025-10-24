//Bibliotecas
#Include "Totvs.ch"
#Include "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RESTFUL.CH"

/*/{Protheus.doc} WSRESTFUL wsCliente
Cadastro de Cliente
@author JOSE EDILSON DE LIMA PINTO
@since 13/05/2025
@version 1.0
@type wsrestful
@obs Codigo gerado automaticamente pelo Autumn Code Maker
/*/

WSRESTFUL wsCliente DESCRIPTION 'Cadastro de Cliente' FORMAT APPLICATION_JSON
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
	WSMETHOD GET customers DESCRIPTION "Retorna lista de clientes" WSSYNTAX "/wsCliente/clientes " PATH '/wsCliente/clientes' PRODUCES APPLICATION_JSON
	WSMETHOD GET CLICNPJ DESCRIPTION 'Retorna o Registro pesquisado - CNPJ'   		WSSYNTAX '/wsCliente/listcnpj/cnpj?{cnpj}' 			  	PATH '/wsCliente/cnpj/{cnpj}'  					PRODUCES APPLICATION_JSON
	WSMETHOD GET TIPO    DESCRIPTION 'Retorna o registro pesquisado - TIPO'   		WSSYNTAX '/wsCliente/tipolist/{tipo}'   	 			PATH '/wsCliente/tipolist/{tipo}' 				PRODUCES APPLICATION_JSON
	WSMETHOD GET ESTADO  DESCRIPTION 'Retorna o registro pesquisado - ESTADO' 		WSSYNTAX '/wsCliente/estadolist/{estado}'   			PATH '/wsCliente/estadolist/{estado}'        	PRODUCES APPLICATION_JSON
	WSMETHOD GET CLIDATA DESCRIPTION 'Retorna o registro pesquisado - DATA'   		WSSYNTAX '/wsCliente/dataslist/data?{dataDe}&{dataAte}' PATH '/wsCliente/dataslist/{dataDe}/{dataAte}'  PRODUCES APPLICATION_JSON
	WSMETHOD GET INTEGRA DESCRIPTION 'Retorna o registro pesquisado - INTEGRADO'   	WSSYNTAX '/wsCliente/integrado/{tpFiliado}'				PATH '/wsCliente/integrado/{tpFiliado}'			PRODUCES APPLICATION_JSON
	WSMETHOD POST NEW    DESCRIPTION 'Inclusão de registro'          		  		WSSYNTAX '/wsCliente/new'      							PATH 'new'        								PRODUCES APPLICATION_JSON
	WSMETHOD PUT  UPDATE DESCRIPTION 'Atualização de registro'       		  		WSSYNTAX '/wsCliente/update'   							PATH 'update'     								PRODUCES APPLICATION_JSON
	WSMETHOD PUT  ERASE  DESCRIPTION 'Bloquear Registro'             		  		WSSYNTAX '/wsCliente/delete'    						PATH 'delete'     								PRODUCES APPLICATION_JSON

END WSRESTFUL


WSMETHOD GET CLICNPJ WSRECEIVE cnpj WSSERVICE wsCliente
	Local lRet       := .T.
	Local jResponse  := JsonObject():New()
	Local cAliasWS   := 'SA1'
    Local cAlSA1     := GetNextAlias()

	::cnpj			 := Self:cnpj //SELF:AQUERYSTRING[1][1]  //self:querystring[1,1]
	Local cJason	 := ""
	oWS    := LIBGLASS():new()

	//Se o id estiver vazio
	If Empty(::cnpj)
		//SetRestFault(500, 'Falha ao consultar o registro') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
		Self:setStatus(500)
		jResponse['errorId']  := 'ID001'
		jResponse['error']    := 'ID vazio'
		jResponse['solution'] := 'Informe o ID'

		cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
		oWS:GRAVALOGMURO(cResponc, cJason, "WSCLIENTE", "NAO DIGITADO O CLIENTE")
	Else
		//DbSelectArea(cAliasWS)
		//(cAliasWS)->(DbSetOrder(3))   //PESQUISA CGC/CPF

		//Se não encontrar o registro
		If !oWS:temClient( FWxFilial(cAliasWS),  ::cnpj) //!(cAliasWS)->(MsSeek(FWxFilial(cAliasWS) + ::cnpj))
			//SetRestFault(500, 'Falha ao consultar ID') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
			Self:setStatus(500)
			jResponse['errorId']  := 'ID002'
			jResponse['error']    := 'CNPJ/CPF ('+::cnpj+') não encontrado'
			jResponse['solution'] := 'CNPJ/CPF não encontrado na tabela ' + cAliasWS

			cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']

			oWS:GRAVALOGMURO(cResponc, cJason, "WSCLIENTE", "BLOQUEIO DE CLIENTE")
			ConOut("erro 002 - nao exsite o cliente")

			Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
			Return .F.

		Else

			cQuery := " SELECT * "
			cQuery += " FROM "+RetSQLName("SA1") + " AS SA1 WITH (NOLOCK) "
			cQuery += " WHERE "
			cQuery += " SA1.A1_CGC = '"+::cnpj+"' "
			cQuery += " AND SA1.D_E_L_E_T_ = '' "
			//cAlSA1:= CriaTrab(Nil,.F.)
			DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSA1, .F., .T.)    

			//Define o retorno
			jResponse['GRUPO'] 			:= cEmpAnt
			jResponse['FILIAL'] 		:= (cAlSA1)->A1_FILIAL
			jResponse['CODIGO']			:= (cAlSA1)->A1_COD
			jResponse['LOJA'] 			:= (cAlSA1)->A1_LOJA
			jResponse['NOME'] 			:= Rtrim( (cAlSA1)->A1_NOME)
			jResponse['NREDUZ'] 		:= Rtrim( (cAlSA1)->A1_NREDUZ )
			jResponse['BAIRRO'] 		:= Rtrim( (cAlSA1)->A1_BAIRRO )
			jResponse['EMAIL'] 			:= Rtrim( (cAlSA1)->A1_EMAIL  )
			jResponse['CEP']			:= Rtrim( (cAlSA1)->A1_CEP    )
			jResponse['CNPJ'] 			:= Rtrim( (cAlSA1)->A1_CGC    )
			jResponse['ESTADO']			:= Rtrim( (cAlSA1)->A1_ESTADO )
			jResponse['COD_MUN']		:= Rtrim( (cAlSA1)->A1_COD_MUN)
			jResponse['COND'] 			:= Rtrim( (cAlSA1)->A1_COND   )
			jResponse['DDD'] 			:= Rtrim( (cAlSA1)->A1_DDD    )
			jResponse['DTCAD'] 			:= (cAlSA1)->A1_DTCAD
			jResponse['END']			:= Rtrim( (cAlSA1)->A1_END    )
			jResponse['INSCR'] 			:= Rtrim( (cAlSA1)->A1_INSCR  )
			jResponse['MUNCIPIO'] 		:= Rtrim( (cAlSA1)->A1_MUN    )
			jResponse['NATUREZ']		:= Rtrim( (cAlSA1)->A1_NATUREZ)
			jResponse['PESSOA'] 		:= Rtrim( (cAlSA1)->A1_TPESSOA)
			jResponse['TIPO'] 			:= Rtrim( (cAlSA1)->A1_TIPCLI )
			jResponse['FONE'] 			:= Rtrim( (cAlSA1)->A1_TEL    )
			jResponse['TRANSP'] 		:= Rtrim( (cAlSA1)->A1_TRANSP )
			jResponse['PAIS'] 			:= Rtrim( (cAlSA1)->A1_PAIS   )
			jResponse['BLOQUEADO'] 		:= IF((cAlSA1)->A1_MSBLQL == "2", "NAO", "SIM")
			jResponse['MOVEL']			:= (cAlSA1)->A1_ZMOBILE
			jResponse['TIPOVEICULO']	:= (cAlSA1)->A1_ZTPVEIC
			jResponse['DTCRIACAO']		:= (cAlSA1)->A1_ZDTCRIA
			jResponse['ATIVO']			:= (cAlSA1)->A1_ZATIVO
			jResponse['PAGAMENTOADT']	:= (cAlSA1)->A1_ZPGTADT
			jResponse['REVENDEAFIAL']	:= (cAlSA1)->A1_ZREVAFI
			jResponse['AFILIADOCONV']	:= (cAlSA1)->A1_ZAFICON
			jResponse['TIPOAFILIADO']	:= (cAlSA1)->A1_ZTPAFIL
			jResponse['INTEGRADO']		:= (cAlSA1)->A1_ZINTEGR

			(cAlSA1)->(dbclosearea())		

		EndIf
	EndIf

	//Define o retorno
	Self:SetContentType('application/json')
	Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
Return lRet

WSMETHOD GET TIPO WSRECEIVE tipo WSSERVICE wsCliente
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
		oWS:GRAVALOGMURO(cResponc, cJason, "wsClieTipo", "NAO DIGITADO O TIPO")
	Else
		//Se não encontrar o registro
		If  !(::tipo $("0/1/2"))
			//SetRestFault(500, 'Falha ao consultar ID') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
			Self:setStatus(500)
			jResponse['errorId']  := 'ID015'
			jResponse['error']    := 'TIPO ('+::tipo+') não encontrado'
			jResponse['solution'] := 'TIPO não encontrado na tabela '

			cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
			oWS:GRAVALOGMURO(cResponc, cJason, "wsClieTipo", "BLOQUEIO DE CLIENTE")
		Else
			// Converte para JSON
			//jResponse['CLIENTES'] := oWS:CLieTipo(::tipo)
			cJsonNfs:= FwJsonSerialize( oWS:CLieTipo(::tipo) )

			Self:SetContentType('application/json')
			Self:SetResponse(cJsonNfs)
			RETURN lRet

		EndIf
	EndIf

	//Define o retorno
	Self:SetContentType('application/json')
	Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
Return lRet

WSMETHOD GET ESTADO WSRECEIVE estado WSSERVICE wsCliente
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
		oWS:GRAVALOGMURO(cResponc, cJason, "WSCLIENTE", "NAO DIGITADO O ESTADO")
	Else
		//Se não encontrar o registro
		If (oWS:TemEstado(::estado))
			//SetRestFault(500, 'Falha ao consultar ID') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
			Self:setStatus(500)
			jResponse['errorId']  := 'ID012'
			jResponse['error']    := 'Estado ('+::estado+') não encontrado'
			jResponse['solution'] := 'Estado não encontrado na tabela '

			cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
			oWS:GRAVALOGMURO(cResponc, cJason, "WSCLIENTE", "BLOQUEIO DE CLIENTE")
		Else
			//jResponse['CLIENTES'] := oWS:CLieEst(::estado)
			cJsonNfs:= FwJsonSerialize( oWS:CLieEst(::estado) )

			Self:SetContentType('application/json')
			Self:SetResponse(cJsonNfs)
			RETURN lRet

		EndIf
	EndIf

	//Define o retorno
	Self:SetContentType('application/json')
	Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
Return lRet

WSMETHOD GET CLIDATA WSRECEIVE dataDe, dataAte WSSERVICE wsCliente
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
		oWS:GRAVALOGMURO(cResponc, cJason, "WSCLIENTE", "NAO DIGITADAS AS DATAS")
	Else
		//jResponse['CLIENTES'] := oWS:CLieDatas( dDataDe, dDataAt)
		cJsonNfs:= FwJsonSerialize( oWS:CLieDatas( dDataDe, dDataAt)  )

		Self:SetContentType('application/json')
		Self:SetResponse(cJsonNfs)
		Return lRet

	EndIf

	//Define o retorno
	Self:SetContentType('application/json')
	Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
Return lRet

WSMETHOD GET INTEGRA WSRECEIVE tpFiliado  WSSERVICE wsCliente
	Local lRet       := .T.
	Local jResponse  := JsonObject():New()
	
	Local cTpFld	 := self:tpFiliado

	oWS     := LIBGLASS():new()
	cJsonNfs:= FwJsonSerialize( oWS:Integrado( "SA1", cTpFld )  )

	If Empty(cJsonNfs) 
		Self:setStatus(500)
		jResponse['errorId']  := 'Tipo016'
		jResponse['error']    := 'Não ha dados a serem integrados'
		jResponse['solution'] := 'Não ha dados a Integrar'

		cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
		oWS:GRAVALOGMURO(cResponc, cJason, "WSCLIENTE", "NAO HA DADOS A SEREM INTEGRADOS")
	Else
	//Define o retorno
		Self:SetContentType('application/json')
		Self:SetResponse(cJsonNfs)
	ENDIF

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

	//Local aAI0Auto 			:= {}

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

	cEmpAt1 := cEmpAnt
    cFilAt1 := cFilAnt

    cEmpAt   := Iif(EMPTY(jJson:GetJsonObject("GRUPO") ), "01", jJson:GetJsonObject("GRUPO" ))
    cFilAt   := "  "

    cEmpAnt  := cEmpAt
    cFilAnt  := cFilAt
    
    RPCSetEnv(cEmpAt, cFilAt)

	cError := jJson:FromJson(cJson)
	cJason := cJson
	::cnpj := jJson:GetJsonObject('CNPJ')
	_COD   := Iif(empty(jJson:GetJsonObject('CODIGO')), GetSXENum('SA1', 'A1_COD') , jJson:GetJsonObject('CODIGO'))
	_LOJA  := iif(empty(jJson:GetJsonObject('LOJA')), "01", jJson:GetJsonObject('LOJA'))

	lBloq  := iif(jJson:GetJsonObject('BLOQUEADO')=="N" .or. Empty(jJson:GetJsonObject('BLOQUEADO')), "2", "1")
	lAtivo := iif( jJson:GetJsonObject('ATIVO')=="N" .or. Empty(jJson:GetJsonObject('ATIVO')), "N", "S")
	cMOVEL := iif( jJson:GetJsonObject('MOVEL') == "" , "N", jJson:GetJsonObject('MOVEL') )
	cTIPOV := iif( jJson:GetJsonObject('TIPOVEICULO')  == "" , "N", jJson:GetJsonObject('TIPOVEICULO') )
	cPAGAM := iif( jJson:GetJsonObject('PAGAMENTOADT') == "" , "N", jJson:GetJsonObject('PAGAMENTOADT') )
	cREVEN := iif( jJson:GetJsonObject('REVENDEAFIAL') == "" , "N", jJson:GetJsonObject('REVENDEAFIAL') )
	cAFILI := iif( jJson:GetJsonObject('AFILIADOCONV') == "" , "N", jJson:GetJsonObject('AFILIADOCONV') )
	cTIPOA := iif( jJson:GetJsonObject('TIPOAFILIADO') == "" , "N", jJson:GetJsonObject('TIPOAFILIADO') )
	CONFIRMSX8()

	IF oWS:temClient(FWxFilial(cAliasWS), ::cnpj) //.OR. oWS:temCliCod(FWxFilial(cAliasWS), _cod, _loja)
		//SetRestFault(500, 'Falha ao obter JSON') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
		Self:setStatus(500)
		jResponse['errorId']  := 'NEW0041'
		jResponse['error']    := 'CLIENTE JA EXISTE'
		jResponse['errorLog'] := cErrorLog
		jResponse['solution'] := 'CADASTRE UM CLIENTE CUJO CNPJ NAO SEJA O MESMO'

		cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
		oWS:GRAVALOGMURO(cResponc, cJason, "WSCLIENTE", "INCLUSÃO DE CLIENTE")

        ConOut("erro 003 - cliente JA existe")

		rpcClearEnv()
		cEmpAnt  := cEmpAt1
		cFilAnt  := cFilAt1
        
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

		cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
		oWS:GRAVALOGMURO(cResponc, cJason, "WSCLIENTE", "INCLUSÃO DE CLIENTE")
	Else

		DbSelectArea(cAliasWS)
		//Adiciona os dados do ExecAuto
		aAdd(aDados, {'A1_FILIAL' , FWCodFil()                      , Nil} )
		aAdd(aDados, {'A1_COD'    , _cod   							, Nil} )
		aAdd(aDados, {'A1_LOJA'   , _loja   						, Nil} )
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
		aAdd(aDados, {'A1_END    ', jJson:GetJsonObject('END')      , Nil} )
		aAdd(aDados, {'A1_INSCR  ', jJson:GetJsonObject('INSCR')    , Nil} )
		aAdd(aDados, {'A1_MUN    ', jJson:GetJsonObject('MUNICIPIO'), Nil} )
		//aAdd(aDados, {'A1_NATUREZ', jJson:GetJsonObject('NATUREZ')  , Nil} )
		//aAdd(aDados, {'A1_OBS    ', 'WMSCLINTE'                     , Nil} )
		aAdd(aDados, {'A1_PESSOA ', jJson:GetJsonObject('PESSOA')   , Nil} )
		//aAdd(aDados, {'A1_TIPCLI ', jJson:GetJsonObject('TIPO')   	, Nil} )
		aAdd(aDados, {'A1_TIPO   ', jJson:GetJsonObject('TIPO') 	, Nil} )
		aAdd(aDados, {'A1_TEL    ', jJson:GetJsonObject('FONE')     , Nil} )
		//aAdd(aDados, {'A1_TRANSP ', jJson:GetJsonObject('TRANSP')   , Nil} )
		aAdd(aDados, {'A1_PAIS   ', '105'  							, Nil} )
		aAdd(aDados, {'A1_ZINTEGR', jJson:GetJsonObject('INTEGRADO'), Nil} )
		aAdd(aDados, {'A1_ZMOBILE', cMOVEL							, Nil} )
		aAdd(aDados, {'A1_ZTPVEIC', cTIPOV							, Nil} )
		aAdd(aDados, {'A1_ZPGTADT', cPAGAM							, Nil} )
		aAdd(aDados, {'A1_ZREVAFI', cREVEN							, Nil} )
		aAdd(aDados, {'A1_ZAFICON', cAFILI							, Nil} )
		aAdd(aDados, {'A1_ZTPAFIL', cTIPOA							, Nil} )
		aAdd(aDados, {'A1_MSBLQL' , lBloq 							, Nil} )
		aAdd(aDados, {'A1_ZATIVO' , lAtivo	    					, Nil} )

		//Percorre os dados do execauto
		For nCampo := 1 To Len(aDados)
			//Se o campo for data, retira os hifens e faz a conversão
			If GetSX3Cache(aDados[nCampo][1], 'X3_TIPO') == 'D'
				aDados[nCampo][2] := sToD(aDados[nCampo][2])
			EndIf
		Next

		//Chama a inclusão automática
		if !lExtCli
			conout("json - " + cJason)
			conout("Cliente - antes do execaut - " + ::cnpj)
			MsExecAuto({|x, y| MATA030(x, y)}, aDados, 3)  //- ANTIGA
            //MSExecAuto({|a,b,c| CRMA980(a,b,c)},aDados,3,aAI0Auto)      			
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
			cArqLog := 'wsCliente_New_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
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
			oWS:GRAVALOGMURO(cResponc, cErrorLog, "WSCLIENTE", "INCLUSÃO DE CLIENTE")
			//Senão, define o retorno
		Else
			conout(" Cliente - Gravado com Sucesso... ")
			jResponse['note']     := 'Registro incluido com sucesso'
		EndIf

	EndIf
	rpcClearEnv()
    cEmpAnt  := cEmpAt1
    cFilAnt  := cFilAt1

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
	//Local aAI0Auto			:= {}

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
	cJason := cJson

	cEmpAt1 := cEmpAnt
    cFilAt1 := cFilAnt

    cEmpAt   := Iif(EMPTY(jJson:GetJsonObject("GRUPO") ), "01", jJson:GetJsonObject("GRUPO" ))
    cFilAt   := "  "

    cEmpAnt  := cEmpAt
    cFilAnt  := cFilAt
    
    RPCSetEnv(cEmpAt, cFilAt)


	cError := jJson:FromJson(cJson)
	::cnpj := jJson:GetJsonObject('CNPJ')
	cCnpj  := jJson:GetJsonObject('CNPJ')
	cCodi  := jJson:GetJsonObject('CODIGO')
	cLoja  := jJson:GetJsonObject('LOJA')
	lBloq  := iif(jJson:GetJsonObject('BLOQUEADO')=="N" .or. Empty(jJson:GetJsonObject('BLOQUEADO')), "2", "1")
	lAtivo := iif( jJson:GetJsonObject('ATIVO')=="N" .or. Empty(jJson:GetJsonObject('ATIVO')), "N", "S")

	cMOVEL := iif( jJson:GetJsonObject('MOVEL') == "" , "N", jJson:GetJsonObject('MOVEL') )
	cTIPOV := iif( jJson:GetJsonObject('TIPOVEICULO')  == "" , "N", jJson:GetJsonObject('TIPOVEICULO') )
	cPAGAM := iif( jJson:GetJsonObject('PAGAMENTOADT') == "" , "N", jJson:GetJsonObject('PAGAMENTOADT') )
	cREVEN := iif( jJson:GetJsonObject('REVENDEAFIAL') == "" , "N", jJson:GetJsonObject('REVENDEAFIAL') )
	cAFILI := iif( jJson:GetJsonObject('AFILIADOCONV') == "" , "N", jJson:GetJsonObject('AFILIADOCONV') )
	cTIPOA := iif( jJson:GetJsonObject('TIPOAFILIADO') == "" , "N", jJson:GetJsonObject('TIPOAFILIADO') )


	//Se o id estiver vazio
	If Empty(::cnpj) //.OR. !oWS:temCliCod(FWxFilial(cAliasWS), cCodi, cLoja)
		//SetRestFault(500, 'Falha ao consultar o registro') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
		Self:setStatus(500)
		jResponse['errorId']  := 'UPD006'
		jResponse['error']    := 'CNPJ VAZIO E/OU CODIGO E LOJA VAZIOS'
		jResponse['errorLog'] := cErrorLog
		jResponse['solution'] := 'Informe o CNPJ, CODIGO E LOJA'

		cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
		oWS:GRAVALOGMURO(cResponc, cJason, "WSCLIENTE", "BLOQUEIO DE CLIENTE")
	Else
		//DbSelectArea(cAliasWS)
		//SA1->(DbGoTop())
		//SA1->(DbSetOrder(1))  //FILIAL + CODIGO + LOJA
		//(SA1->( DbSeek( xFilial("SA1") + ::cnpj ) ) )

		//Se não encontrar o registro
		If !oWS:temClient(FWxFilial(cAliasWS), ::cnpj) //!(cAliasWS)->(MsSeek(FWxFilial(cAliasWS) + ::cnpj))
			//SetRestFault(500, 'Falha ao consultar ID') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
			Self:setStatus(500)
			jResponse['errorId']  := 'UPD007'
			jResponse['error']    := 'ID não encontrado'
			jResponse['errorLog'] := cErrorLog
			jResponse['solution'] := 'Código ID não encontrado na tabela ' + cAliasWS

			cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
			oWS:GRAVALOGMURO(cResponc, cJason, "WSCLIENTE", "ATUALIZAÇÃO DE CLIENTE")
		Else

			//Se tiver algum erro no Parse, encerra a execução
			If !Empty(cError)
				//SetRestFault(500, 'Falha ao obter JSON') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
				Self:setStatus(500)
				jResponse['errorId']  := 'UPD008'
				jResponse['error']    := 'Parse do JSON'
				jResponse['errorLog'] := cErrorLog
				jResponse['solution'] := 'Erro ao fazer o Parse do JSON'

				cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
				oWS:GRAVALOGMURO(cResponc, cJason, "WSCLIENTE", "ATUALIZAÇÃO DE CLIENTE")
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
				// aAdd(aDadUpd, {'A1_TRANSP'	, jJson:GetJsonObject('TRANSP')   , Nil} )
				aAdd(aDadUpd, {'A1_ZINTEGR' , jJson:GetJsonObject('INTEGRADO'), Nil} )
				aAdd(aDadUpd, {'A1_ZMOBILE' , cMOVEL						  , Nil} )
				aAdd(aDadUpd, {'A1_ZTPVEIC' , cTIPOV					  	  , Nil} )
				aAdd(aDadUpd, {'A1_ZPGTADT' , cPAGAM						  , Nil} )
				aAdd(aDadUpd, {'A1_ZREVAFI' , cREVEN						  , Nil} )
				aAdd(aDadUpd, {'A1_ZAFICON' , cAFILI						  , Nil} )
				aAdd(aDadUpd, {'A1_ZTPAFIL' , cTIPOA						  , Nil} )
				aAdd(aDadUpd, {'A1_MSBLQL'  , lBloq 						  , Nil} )
				aAdd(aDadUpd, {'A1_ZATIVO'  , lAtivo	    				  , Nil} )

				//SA1->(DbGoTop())
				//SA1->(DbSetOrder(3))
				//if (SA1->( DbSeek( xFilial("SA1") + cCnpj ) ) )
				if oWS:temClient(FWxFilial(cAliasWS), ::cnpj)
					lMsErroAuto :=  oWS:ATUSA1(aDadUpd, xFilial("SA1"),  cCnpj) //- ANTIGO - UPDATE DIRETO
					//MsExecAuto({|x, y| MATA030(x, y)}, aDadUpd, 4)
		            //MSExecAuto({|a,b,c| CRMA980(a,b,c)},aDadUpd, 4,aAI0Auto)      			
				Endif

				//Se houve erro, gera um arquivo de log dentro do diretório da protheus data
				If lMsErroAuto
					//Monta o texto do Error Log que será salvo
					cErrorLog   := ''
					aLogAuto    := GetAutoGrLog()
					For nLinha  := 1 To Len(aLogAuto)
						cErrorLog += aLogAuto[nLinha] + CRLF
					Next nLinha

					//Grava o arquivo de log
					cArqLog := 'wsCliente_New_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
					MemoWrite(cDirLog + cArqLog, cErrorLog)

					//Define o retorno para o WebService
					//SetRestFault(500, cErrorLog) //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
					Self:setStatus(500)
					jResponse['errorId']  := 'UPD009'
					jResponse['error']    := 'Erro na atualizacao do registro'
					jResponse['errorLog'] := cErrorLog
					jResponse['solution'] := 'Nao foi possivel incluir o registro, foi gerado um arquivo de log em ' + cDirLog + cArqLog + ' '
					lRet := .F.

					cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
					oWS:GRAVALOGMURO(cResponc, cErrorLog, "WSCLIENTE", "ATUALIZAÇÃO DE CLIENTE")
					//Senão, define o retorno
				Else
					jResponse['note']     := 'Registro Atualizado com sucesso'
				EndIf

			EndIf
		EndIf
	EndIf
	rpcClearEnv()
    cEmpAnt  := cEmpAt1
    cFilAnt  := cFilAt1

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

	//Local aAI0Auto			:= {}

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

	cEmpAt1 := cEmpAnt
    cFilAt1 := cFilAnt

    cEmpAt   := Iif(EMPTY(jJson:GetJsonObject("GRUPO") ), "01", jJson:GetJsonObject("GRUPO" ))
    cFilAt   := "  "

    cEmpAnt  := cEmpAt
    cFilAnt  := cFilAt
    
    RPCSetEnv(cEmpAt, cFilAt)

	cJason := cJson
	::cnpj := jJson:GetJsonObject('CNPJ')
	cCnpj  := jJson:GetJsonObject('CNPJ')
	cCodi  := jJson:GetJsonObject('CODIGO')
	cLoja  := jJson:GetJsonObject('LOJA')

	//Se o id estiver vazio
	If Empty(::cnpj) //.OR. !oWS:temCliCod(FWxFilial(cAliasWS), cCodi, cLoja)
		//SetRestFault(500, 'Falha ao consultar o registro') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
		Self:setStatus(500)
		jResponse['errorId']  := 'DEL010'
		jResponse['error']    := 'CNPJ VAZIO E/OU CODIGO E LOJA VAZIOS'
		jResponse['errorLog'] := cErrorLog
		jResponse['solution'] := 'Informe o CNPJ, CODIGO E LOJA'

		cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
		oWS:GRAVALOGMURO(cResponc, cJason, "WSCLIENTE", "BLOQUEIO DE CLIENTE")
	Else
		//Se não encontrar o registro
		If !oWS:temClient(FWxFilial(cAliasWS), ::cnpj) //(cAliasWS)->(MsSeek(FWxFilial(cAliasWS) + ::cnpj))
			//SetRestFault(500, 'Falha ao consultar ID') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
			Self:setStatus(500)
			jResponse['errorId']  := 'DEL011'
			jResponse['error']    := 'CNPJ não encontrado'
			jResponse['errorLog'] := cErrorLog
			jResponse['solution'] := 'CNPJ não encontrado na tabela ' + cAliasWS

			cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
			oWS:GRAVALOGMURO(cResponc, cJason, "WSCLIENTE", "BLOQUEIO DE CLIENTE")
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
				oWS:GRAVALOGMURO(cResponc, cJason, "WSCLIENTE", "BLOQUEIO DE CLIENTE")
			Else
				DbSelectArea(cAliasWS)

				//Adiciona os dados do ExecAuto
				aAdd(aDados, {'A1_MSBLQL', '1',   Nil})
				aAdd(aDados, {'A1_ZATIVO', 'N',   Nil})

				//Percorre os dados do execauto
				For nCampo := 1 To Len(aDados)
					//Se o campo for data, retira os hifens e faz a conversão
					If GetSX3Cache(aDados[nCampo][1], 'X3_TIPO') == 'D'
						//aDados[nCampo][2] := StrTran(aDados[nCampo][2], '-', '')
						aDados[nCampo][2] := sToD(aDados[nCampo][2])
					EndIf
				Next

				//SA1->(DbGoTop())
				//SA1->(DbSetOrder(3))
				//if (SA1->( DbSeek( xFilial("SA1") + cCnpj ) ) )
				IF oWS:temClient(xFilial("SA1"), cCnpj)
					lMsErroAuto :=  oWS:ATUSA1(aDados, xFilial("SA1"),  cCnpj) //- antigo, update
					//MsExecAuto({|x, y| MATA030(x, y)}, aDados, 4)
		            //MSExecAuto({|a,b,c| CRMA980(a,b,c)},aDados, 4,aAI0Auto)      			
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
					cArqLog := 'wsCliente_New_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
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
					oWS:GRAVALOGMURO(cResponc, cErrorLog, "WSCLIENTE", "BLOQUEIO DE CLIENTE")
				Else
					jResponse['note']     := 'Registro Bloqueado com sucesso'
				EndIf

			EndIf
		EndIf
	EndIf

	rpcClearEnv()
    cEmpAnt  := cEmpAt1
    cFilAnt  := cFilAt1

	//Define o retorno
	Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
Return lRet

WSMETHOD GET customers WSRECEIVE searchKey, page, pageSize WSREST wsCliente

	Local aListCli := {}

	Local cAliasSA1 := GetNextAlias()
	Local cJsonCli := ''
	Local cSearch := ''
	Local cWhere := "AND SA1.A1_FILIAL = '"+xFilial('SA1')+"' AND SA1.A1_ZINTEGR <> 'S' "

	Local lRet := .T.

	Local nCount := 0
	Local nStart := 1
	Local nReg := 0
	Local nAux := 0

	Local oJsonCli := JsonObject():New()

	Default self:searchKey := ''
	Default self:page := 1
	Default self:pageSize := 10

	//-------------------------------------------------------------------
	// Tratativas para a chave de busca
	//-------------------------------------------------------------------
	If !Empty(self:searchKey)
		cSearch := AllTrim( Upper( Self:SearchKey ) )
		cWhere += " AND ( SA1.A1_COD LIKE '%" + cSearch + "%' OR "
		cWhere += " SA1.A1_LOJA LIKE '%" + cSearch + "%' OR "
		cWhere += " SA1.A1_NOME LIKE '%" + FwNoAccent( cSearch ) + "%' OR "
		cWhere += " SA1.A1_NOME LIKE '%" + cSearch + "%' ) "
	EndIf

	cWhere := '%'+cWhere+'%'

	//-------------------------------------------------------------------
	// Query para selecionar clientes
	//-------------------------------------------------------------------
	BEGINSQL Alias cAliasSA1
 
	SELECT SA1.A1_FILIAL,SA1.A1_COD,SA1.A1_LOJA,SA1.A1_NOME,SA1.A1_NREDUZ ,SA1.A1_BAIRRO,;
	SA1.A1_EMAIL  ,SA1.A1_CEP    ,SA1.A1_CGC    ,SA1.A1_ESTADO ,SA1.A1_COD_MUN,SA1.A1_COND,;
	SA1.A1_DDD    ,SA1.A1_DTCAD,SA1.A1_END    ,SA1.A1_INSCR  ,SA1.A1_MUN    ,SA1.A1_NATUREZ,;
	SA1.A1_TPESSOA,SA1.A1_TIPCLI ,SA1.A1_TEL    ,SA1.A1_TRANSP ,SA1.A1_PAIS   ,SA1.A1_MSBLQL,;
	SA1.A1_ZMOBILE,SA1.A1_ZTPVEIC,SA1.A1_ZDTCRIA,SA1.A1_ZATIVO,SA1.A1_ZPGTADT,SA1.A1_ZREVAFI,;
	SA1.A1_ZAFICON,SA1.A1_ZTPAFIL,SA1.A1_ZINTEGR
	FROM %table:SA1% SA1
	WHERE SA1.%NotDel%
	%exp:cWhere%
	
	ENDSQL

	If ( cAliasSA1 )->( ! Eof() )

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
		( cAliasSA1 )->( DBGoTop() )

		//-------------------------------------------------------------------
		// Valida a exitencia de mais paginas
		//-------------------------------------------------------------------
		If nReg > self:pageSize
			oJsonCli['hasNext'] := .T.
		Else
			oJsonCli['hasNext'] := .F.
		EndIf
	Else
		//-------------------------------------------------------------------
		// Nao encontrou registros
		//-------------------------------------------------------------------
		oJsonCli['hasNext'] := .F.
	EndIf

	//-------------------------------------------------------------------
	// Alimenta array de clientes
	//-------------------------------------------------------------------
	While ( cAliasSA1 )->( ! Eof() )

		nCount++

		If nCount >= nStart

			nAux++
			aAdd( aListCli , JsonObject():New() )
			aListCli[nAux]['FILIAL'] 	:= (cAliasSA1)->A1_FILIAL
			aListCli[nAux]['CODIGO']	:= (cAliasSA1)->A1_COD
			aListCli[nAux]['LOJA'] 		:= (cAliasSA1)->A1_LOJA
			aListCli[nAux]['NOME'] 		:= Rtrim( (cAliasSA1)->A1_NOME)
			aListCli[nAux]['NREDUZ'] 	:= Rtrim( (cAliasSA1)->A1_NREDUZ )
			aListCli[nAux]['BAIRRO'] 	:= Rtrim( (cAliasSA1)->A1_BAIRRO )
			aListCli[nAux]['EMAIL'] 	:= Rtrim( (cAliasSA1)->A1_EMAIL  )
			aListCli[nAux]['CEP']		:= Rtrim( (cAliasSA1)->A1_CEP    )
			aListCli[nAux]['CNPJ'] 		:= Rtrim( (cAliasSA1)->A1_CGC    )
			aListCli[nAux]['ESTADO']	:= Rtrim( (cAliasSA1)->A1_ESTADO )
			aListCli[nAux]['COD_MUN']	:= Rtrim( (cAliasSA1)->A1_COD_MUN)
			aListCli[nAux]['COND'] 		:= Rtrim( (cAliasSA1)->A1_COND   )
			aListCli[nAux]['DDD'] 		:= Rtrim( (cAliasSA1)->A1_DDD    )
			aListCli[nAux]['DTCAD'] 	:= (cAliasSA1)->A1_DTCAD
			aListCli[nAux]['END']		:= Rtrim( (cAliasSA1)->A1_END    )
			aListCli[nAux]['INSCR'] 	:= Rtrim( (cAliasSA1)->A1_INSCR  )
			aListCli[nAux]['MUNCIPIO'] 	:= Rtrim( (cAliasSA1)->A1_MUN    )
			aListCli[nAux]['NATUREZ']	:= Rtrim( (cAliasSA1)->A1_NATUREZ)
			aListCli[nAux]['PESSOA'] 	:= Rtrim( (cAliasSA1)->A1_TPESSOA)
			aListCli[nAux]['TIPO'] 	    := Rtrim( (cAliasSA1)->A1_TIPCLI )
			aListCli[nAux]['FONE'] 		:= Rtrim( (cAliasSA1)->A1_TEL    )
			aListCli[nAux]['TRANSP'] 	:= Rtrim( (cAliasSA1)->A1_TRANSP )
			aListCli[nAux]['PAIS'] 		:= Rtrim( (cAliasSA1)->A1_PAIS   )
			aListCli[nAux]['BLOQUEADO']	:= IF((cAliasSA1)->A1_MSBLQL == "2", "NAO", "SIM")
			aListCli[nAux]['MOVEL']		:= (cAliasSA1)->A1_ZMOBILE
			aListCli[nAux]['TIPOVEICULO']	:= (cAliasSA1)->A1_ZTPVEIC
			aListCli[nAux]['DTCRIACAO']	:= (cAliasSA1)->A1_ZDTCRIA
			aListCli[nAux]['ATIVO']		:= (cAliasSA1)->A1_ZATIVO
			aListCli[nAux]['PAGAMENTOADT']	:= (cAliasSA1)->A1_ZPGTADT
			aListCli[nAux]['REVENDEAFIAL']	:= (cAliasSA1)->A1_ZREVAFI
			aListCli[nAux]['AFILIADOCONV']	:= (cAliasSA1)->A1_ZAFICON
			aListCli[nAux]['TIPOAFILIADO']	:= (cAliasSA1)->A1_ZTPAFIL
			aListCli[nAux]['INTEGRADO']	:= (cAliasSA1)->A1_ZINTEGR
			If Len(aListCli) >= self:pageSize
				Exit
			EndIf

		EndIf

		( cAliasSA1 )->( DBSkip() )

	End

	( cAliasSA1 )->( DBCloseArea() )

	oJsonCli['clients'] := aListCli

	//-------------------------------------------------------------------
	// Serializa objeto Json
	//-------------------------------------------------------------------
	cJsonCli:= FwJsonSerialize( oJsonCli )

	//-------------------------------------------------------------------
	// Elimina objeto da memoria
	//-------------------------------------------------------------------
	FreeObj(oJsonCli)

	Self:SetResponse( cJsonCli ) //-- Seta resposta

Return( lRet )
