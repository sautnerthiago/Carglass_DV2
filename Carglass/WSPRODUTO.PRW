//Bibliotecas
#Include "Totvs.ch"
#Include "RESTFul.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} WSRESTFUL WSPRODUTO
CADASTRO DE PRODUTOS
@author JOSE EDILSON DE LIMA PINTO
@since 26/05/2025
@version 1.0
/*/

WSRESTFUL WSPRODUTO DESCRIPTION 'CADASTRO DE PRODUTOS'
    //Atributos
    WSDATA produto   AS STRING
 
    //Métodos
	//M�todos 
	WSMETHOD GET  INTEGRA DESCRIPTION 'Retorna o registro pesquisado - INTEGRADO'   WSSYNTAX '/WSPRODUTO/integrado' 				PATH '/WSPRODUTO/integrado'  				PRODUCES APPLICATION_JSON
    WSMETHOD GET  CODIGO  DESCRIPTION 'Retorna o registro pesquisado'               WSSYNTAX '/WSPRODUTO/codigo/?{produto}'         PATH '/WSPRODUTO/codigo/{produto}'          PRODUCES APPLICATION_JSON
    //WSMETHOD POST NEW     DESCRIPTION 'Inclusao de registro'                        WSSYNTAX '/WSPRODUTO/new'                       PATH 'new'                                  PRODUCES APPLICATION_JSON
    //WSMETHOD PUT  UPDATE  DESCRIPTION 'Atualizacao de registro'                     WSSYNTAX '/WSPRODUTO/update'                    PATH 'update'                               PRODUCES APPLICATION_JSON
    //WSMETHOD PUT  ERASE   DESCRIPTION 'Bloqueio de registro'                        WSSYNTAX '/WSPRODUTO/delete'                    PATH 'delete'                               PRODUCES APPLICATION_JSON
END WSRESTFUL

WSMETHOD GET CODIGO WSRECEIVE produto WSSERVICE WSPRODUTO
    Local lRet       := .T.
    Local jResponse  := JsonObject():New()
    Local cAliasWS   := 'ZA2'
    ::produto		 := self:produto
    oWS              := LIBGLASS():new()

    //Se o CODIGO estiver vazio
    If Empty(::produto)
        Self:setStatus(500) 
        jResponse['errorId']  := 'ID001'
        jResponse['error']    := 'C�digo de Produto Vazio'
        jResponse['solution'] := 'Informe o Codigo'
    Else
        DbSelectArea(cAliasWS)
        (cAliasWS)->(DbSetOrder(2))

        //Se não encontrar o registro
        If !(cAliasWS)->(MsSeek(FWxFilial(cAliasWS) + ::produto))
            //SetRestFault(500, 'Falha ao consultar ID') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
            Self:setStatus(500) 
            jResponse['errorId']  := 'ID002'
            jResponse['error']    := 'C�digo nao encontrado'
            jResponse['solution'] := 'Digite um codigo valido. - tabela ' + cAliasWS
        Else
            //Define o retorno

            cQuery := " SELECT B1_COD, B1_DESC, B1_TIPO, B1_UM, B1_LOCPAD, B1_PICM, B1_IPI, B1_LOCALIZ, B1_MSBLQL, B1_ZCODPRD "
            cQuery += " FROM "+RetSQLName("SB1") + " AS SB1 WITH (NOLOCK) "
            cQuery += " WHERE B1_FILIAL = '" + FWxFilial("SB1") + "' "
            cQuery += " AND SB1.B1_ZCODPRD = '"+::produto+"' "
            cQuery += " AND SB1.D_E_L_E_T_ = '' "
            cAlSB1:= CriaTrab(Nil,.F.)
            DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSB1, .F., .T.)    

            jResponse['CODIGO']         := Rtrim((cAlSB1)->B1_COD)
            jResponse['DESCRICAO']      := Rtrim((cAlSB1)->B1_DESC)
            jResponse['TIPO']           := (cAlSB1)->B1_TIPO 
            jResponse['UM']             := (cAlSB1)->B1_UM 
            jResponse['ALMOXARIF']      := (cAlSB1)->B1_LOCPAD 
            jResponse['PERICMS']        := (cAlSB1)->B1_PICM 
            jResponse['PERIPI']         := (cAlSB1)->B1_IPI 
            jResponse['LOCALIZACAO']    := (cAlSB1)->B1_LOCALIZ 
        	jResponse['BLOQUEADO'] 		:= IF((cAlSB1)->B1_MSBLQL == "2", "NAO", "SIM")
            jResponse['CODLEGADO']      := Rtrim((cAlSB1)->B1_ZCODPRD)

            (cAlSB1)->(dbclosearea())


        EndIf
    EndIf

    //Define o retorno
    Self:SetContentType('application/json')
    Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
Return lRet

WSMETHOD GET INTEGRA WSRECEIVE WSSERVICE WSPRODUTO
	Local lRet       := .T.
	Local jResponse  := JsonObject():New()

	oWS    := LIBGLASS():new()
	cJsonNfs:= FwJsonSerialize( oWS:Integrado( "SB1" )  )			

	//Define o retorno
	Self:SetContentType('application/json')
	Self:SetResponse(EncodeUTF8(jResponse:toJSON()))

Return lRet

/*
WSMETHOD POST NEW WSRECEIVE WSSERVICE WSPRODUTO
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
    Local cAliasWS          := 'SB1'
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
 
    //Se tiver algum erro no Parse, encerra a execução
    IF ! Empty(cError)
        //SetRestFault(500, 'Falha ao obter JSON') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
        Self:setStatus(500) 
        jResponse['errorId']  := 'NEW004'
        jResponse['error']    := 'Parse do JSON'
        jResponse['solution'] := 'Erro ao fazer o Parse do JSON'

    Else
		DbSelectArea(cAliasWS)
       
		//Adiciona os dados do ExecAuto
		aAdd(aDados, {'B1_COD',     jJson:GetJsonObject('CODIGO'),      Nil})
		aAdd(aDados, {'B1_DESC',    jJson:GetJsonObject('DESCRICAO'),   Nil})
		aAdd(aDados, {'B1_TIPO',    jJson:GetJsonObject('TIPO'),        Nil})
		aAdd(aDados, {'B1_UM',      jJson:GetJsonObject('UM'),          Nil})
		aAdd(aDados, {'B1_LOCPAD',  jJson:GetJsonObject('ALMOXARIF'),   Nil})
		aAdd(aDados, {'B1_PICM',    jJson:GetJsonObject('PERICMS'),     Nil})
		aAdd(aDados, {'B1_IPI',     jJson:GetJsonObject('PERIPI'),      Nil})
		aAdd(aDados, {'B1_LOCALIZ', jJson:GetJsonObject('LOCALIZACAO'), Nil})
		
		//Chama a inclusão automática
		MsExecAuto({|x, y| MATA010(x, y)}, aDados, 3)

		//Se houve erro, gera um arquivo de log dentro do diretório da protheus data
		If lMsErroAuto
			//Monta o texto do Error Log que será salvo
			cErrorLog   := ''
			aLogAuto    := GetAutoGrLog()
			For nLinha := 1 To Len(aLogAuto)
				cErrorLog += aLogAuto[nLinha] + CRLF
			Next nLinha

			//Grava o arquivo de log
			cArqLog := 'WSPRODUTO_New_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
			MemoWrite(cDirLog + cArqLog, cErrorLog)

			//Define o retorno para o WebService
			//SetRestFault(500, cErrorLog) //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
           Self:setStatus(500) 
			jResponse['errorId']  := 'NEW005'
			jResponse['error']    := 'Erro na inclusão do registro'
			jResponse['solution'] := 'Nao foi possivel incluir o registro, foi gerado um arquivo de log em ' + cDirLog + cArqLog + ' '
			lRet := .F.

		//Senão, define o retorno
		Else
			jResponse['note']     := 'Registro incluido com sucesso'
		EndIf

    EndIf

    //Define o retorno
    Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
Return lRet

WSMETHOD PUT UPDATE WSRECEIVE WSSERVICE WSPRODUTO
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
    Local cAliasWS          := 'SB1'
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
    cCod   := jJson:GetJsonObject('CODIGO')

    //Se o id estiver vazio
    If Empty(cCod)
        //SetRestFault(500, 'Falha ao consultar o registro') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
        Self:setStatus(500) 
        jResponse['errorId']  := 'UPD006'
        jResponse['error']    := 'ID vazio'
        jResponse['solution'] := 'Informe o ID'
    Else
        DbSelectArea(cAliasWS)
        (cAliasWS)->(DbSetOrder(1))

        //Se não encontrar o registro
        If ! (cAliasWS)->(MsSeek(FWxFilial(cAliasWS) + cCod))
            //SetRestFault(500, 'Falha ao consultar ID') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
            Self:setStatus(500) 
            jResponse['errorId']  := 'UPD007'
            jResponse['error']    := 'ID nao encontrado'
            jResponse['solution'] := 'Codigo do produto nao encontrado na tabela ' + cAliasWS
        Else
 
            //Se tiver algum erro no Parse, encerra a execução
            If ! Empty(cError)
                //SetRestFault(500, 'Falha ao obter JSON') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
                Self:setStatus(500) 
                jResponse['errorId']  := 'UPD008'
                jResponse['error']    := 'Parse do JSON'
                jResponse['solution'] := 'Erro ao fazer o Parse do JSON'

            Else
		        DbSelectArea(cAliasWS)
                
    	        //Adiciona os dados do ExecAuto
                aAdd(aDados, {'B1_COD',     jJson:GetJsonObject('CODIGO'),      Nil})
                aAdd(aDados, {'B1_DESC',    jJson:GetJsonObject('DESCRICAO'),   Nil})
                aAdd(aDados, {'B1_TIPO',    jJson:GetJsonObject('TIPO'),        Nil})
                aAdd(aDados, {'B1_UM',      jJson:GetJsonObject('UM'),          Nil})
                aAdd(aDados, {'B1_LOCPAD',  jJson:GetJsonObject('ALMOXARIF'),   Nil})
                aAdd(aDados, {'B1_PICM',    jJson:GetJsonObject('PERICMS'),     Nil})
                aAdd(aDados, {'B1_IPI',     jJson:GetJsonObject('PERIPI'),      Nil})
                aAdd(aDados, {'B1_LOCALIZ', jJson:GetJsonObject('LOCALIZACAO'), Nil})
		         
		         //Chama a atualização automática
		         MsExecAuto({|x, y| MATA010(x, y)}, aDados, 4)

		         //Se houve erro, gera um arquivo de log dentro do diretório da protheus data
		         If lMsErroAuto
		         	//Monta o texto do Error Log que será salvo
		         	cErrorLog   := ''
		         	aLogAuto    := GetAutoGrLog()
		         	For nLinha := 1 To Len(aLogAuto)
		         		cErrorLog += aLogAuto[nLinha] + CRLF
		         	Next nLinha

		            //Grava o arquivo de log
		            cArqLog := 'WSPRODUTO_New_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
		            MemoWrite(cDirLog + cArqLog, cErrorLog)

		            //Define o retorno para o WebService
		            //SetRestFault(500, cErrorLog) //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
		            Self:setStatus(500) 
		            jResponse['errorId']  := 'UPD009'
		            jResponse['error']    := 'Erro na atualizacao do registro'
		            jResponse['solution'] := 'Nao foi possivel incluir o registro, foi gerado um arquivo de log em ' + cDirLog + cArqLog + ' '
		            lRet := .F.

		         //Senão, define o retorno
		         Else
		         	jResponse['note']     := 'Registro Alterado com sucesso'
		         EndIf

		     EndIf
		 EndIf
    EndIf

    //Define o retorno
    Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
Return lRet

WSMETHOD PUT ERASE WSRECEIVE WSSERVICE WSPRODUTO
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
    Local cAliasWS          := 'SB1'
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
    cCod   := jJson:GetJsonObject('CODIGO')

    //Se o id estiver vazio
    If Empty(cCod)
        //SetRestFault(500, 'Falha ao consultar o registro') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
        Self:setStatus(500) 
        jResponse['errorId']  := 'DEL010'
        jResponse['error']    := 'ID vazio'
        jResponse['solution'] := 'Informe o ID'
    Else
        DbSelectArea(cAliasWS)
        (cAliasWS)->(DbSetOrder(1))

        //Se não encontrar o registro
        If ! (cAliasWS)->(MsSeek(FWxFilial(cAliasWS) + cCod))
            //SetRestFault(500, 'Falha ao consultar ID') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
            Self:setStatus(500) 
            jResponse['errorId']  := 'DEL011'
            jResponse['error']    := 'Codigo nao encontrado'
            jResponse['solution'] := 'Codigodigo Produto naoo encontrado na tabela ' + cAliasWS
        Else
 
            //Se tiver algum erro no Parse, encerra a execução
            If ! Empty(cError)
                //SetRestFault(500, 'Falha ao obter JSON') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
                Self:setStatus(500) 
                jResponse['errorId']  := 'DEL012'
                jResponse['error']    := 'Parse do JSON'
                jResponse['solution'] := 'Erro ao fazer o Parse do JSON'

            Else
		        DbSelectArea(cAliasWS)
                
		        //Adiciona os dados do ExecAuto
                aAdd(aDados, {'B1_MSBLQL', '1',   Nil})
                aAdd(aDados, {'B1_COD',     jJson:GetJsonObject('CODIGO'),      Nil})

		         //Chama a exclusão automática
		         MsExecAuto({|x, y| MATA010(x, y)}, aDados, 4)

		         //Se houve erro, gera um arquivo de log dentro do diretório da protheus data
		         If lMsErroAuto
		         	//Monta o texto do Error Log que será salvo
		         	cErrorLog   := ''
		         	aLogAuto    := GetAutoGrLog()
		         	For nLinha := 1 To Len(aLogAuto)
		         		cErrorLog += aLogAuto[nLinha] + CRLF
		         	Next nLinha

		            //Grava o arquivo de log
		            cArqLog := 'WSPRODUTO_New_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
		            MemoWrite(cDirLog + cArqLog, cErrorLog)

		            //Define o retorno para o WebService
		            //SetRestFault(500, cErrorLog) //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
		            Self:setStatus(500) 
		            jResponse['errorId']  := 'DEL013'
		            jResponse['error']    := 'Erro no bloqueio do registro'
		            jResponse['solution'] := 'Nao foi possivel bloquear o registro, foi gerado um arquivo de log em ' + cDirLog + cArqLog + ' '
		            lRet := .F.

		         //Senão, define o retorno
		         Else
		         	jResponse['note']     := 'Registro bloqueado com sucesso'
		         EndIf

		     EndIf
		 EndIf
    EndIf

    //Define o retorno
    Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
Return lRet
*/
