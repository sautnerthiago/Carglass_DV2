//Bibliotecas
#Include "Totvs.ch"
#Include "RESTFul.ch"
#Include "TopConn.ch"
#Include 'Protheus.ch'
#INCLUDE 'APWEBSRV.CH'
#Include "tbiconn.ch"

/*/{Protheus.doc} WSRESTFUL WSNFE
GERAÇÃO DE NOTA FISCAL DE ENTRADA
@author JOSE EDILSON DE LIMA PINTO
@since 14/10/2025
@version 1.0
@type wsrestful
/*/

WSSTRUCT ITEMPDC

	WSDATA nitem as INTEGER
	WSDATA cCodProd as String
	WSDATA cDescProd as String
	WSDATA nQuant as Float

ENDWSSTRUCT

WSRESTFUL WSNFE DESCRIPTION 'NOTA FISCAL DE ENTRADA'
    //Atributos
    WSDATA NUMPC       AS STRING
    WSDATA solicitante AS STRING
    WSDATA emissao     AS STRING
    WSDATA item        AS ITEMPDC
    
    WSDATA page AS INTEGER OPTIONAL
	WSDATA pageSize AS INTEGER OPTIONAL
	WSDATA searchKey AS STRING OPTIONAL

    WSMETHOD POST   NEW    DESCRIPTION 'Inclusão de registro'          WSSYNTAX '/WSNFE/new'                      PATH 'new'           PRODUCES APPLICATION_JSON

END WSRESTFUL

WSMETHOD POST NEW WSRECEIVE NUMPC WSSERVICE WSNFE
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
    Local dAltVct           := "" //17/11/2025 - ajuste
    Local cChavNfe          := "" //17/11/2025 - ajuste
    
    Local alTemExtr         := {}
    Local aRetGrv           := {}

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
    
    ConOut("iniciando Nota Fiscal de Entrada")
    
    cError := jJson:FromJson(cJson)

    if !(empty(cError)) 
		Self:setStatus(500)
		jResponse['errorId']  := 'NEW0000'
		jResponse['error']    := 'ERRO NO JSON'
        jResponse['errorLog'] := cError
		jResponse['solution'] := 'ANALISE A INFORMACAO DE ENVIO'
        
        ConOut("erro 001")

        Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
        Return .F.
    ENDIF

	cJason := cJson 
    lTemPr := .F.

    _CNPJCPF:= IIF(EMPTY(jJson:GetJsonObject("CNPJ")), Substr( jJson:GetJsonObject("CHVNFE" ),7, 14), jJson:GetJsonObject("CNPJ")) //jJson:GetJsonObject("CNPJ")
    lTemFor := ows:temFornec(FWxFilial("SA2"), _CNPJCPF)

    cEmpAt1 := cEmpAnt
    cFilAt1 := cFilAnt

    dAltVct := jJson:GetJsonObject("DTALTERA") //17/11/2025 - ajuste

    cEmpAt  := Iif(EMPTY(jJson:GetJsonObject("GRUPO") ), "01", jJson:GetJsonObject("GRUPO" ))
    cFilAt  := Iif(EMPTY(jJson:GetJsonObject("FILIAL")), "01", jJson:GetJsonObject("FILIAL"))

    cEmpAnt := cEmpAt
    cFilAnt := cFilAt
    cChavNfe:= jJson:GetJsonObject("CHVNFE")  //17/11/2025 - ajuste
    
    RPCSetEnv(cEmpAt, cFilAt)

    IF !lTemFor
		//SetRestFault(500, 'Falha ao obter JSON') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
		Self:setStatus(501) //erro no JSON
		jResponse['errorId']  := 'NEW0041'
		jResponse['error']    := 'FORNECEDOR NAO EXISTE'
        jResponse['errorLog'] := cErrorLog
		jResponse['solution'] := 'CADASTRE UM FORNECEDOR'

		cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
		oWS:GRAVALOGMURO(cResponc, cJason, "WSNFE", "INCLUSÃO DE Nota Fiscal de Entrada")

        ConOut("erro 002")

        Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
        Return .F.
	EndIF

    cEnum := jJson:GetJsonObject("IDPEDCOMPREXT")
	cExter:= jJson:GetJsonObject("EXTERNID")
    cDoc  := jJson:GetJsonObject("NUMNF")
    cSeri := jJson:GetJsonObject("SERIENF")

    alTemExtr := ows:PGExtDad(cEnum + cExter) //ows:PGExtDad(jJson:GetJsonObject("IDPEDCOMPREXT"))

	IF len(alTemExtr) == 0  //Verifica se tem ExternoID - Numero do Pedido Externo
		Self:setStatus(502)
		jResponse['errorId']  := 'NEW0041'
		jResponse['error']    := 'PEDIDO DE VENDAS NÃO EXISTE'
        jResponse['errorLog'] := cErrorLog
		jResponse['solution'] := 'CADASTRE UM PEDIDO DE VENDAS QUE DESEJA GERAR A NOTA'

		cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
		oWS:GRAVALOGMURO(cResponc, cJason, "WSNFE", "INCLUSÃO DE Nota Fiscal de Entrada")

        ConOut("erro 003 - nfe")
        
        Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
        Return .F.
	EndIF
 
    //Se tiver algum erro no Parse, encerra a execução
    IF !Empty(cError)
        //SetRestFault(500, 'Falha ao obter JSON') //caso queira usar esse comando, você não poderá usar outros retornos, como os abaixo
        Self:setStatus(503) 
        jResponse['errorId']  := 'NEW004'
        jResponse['error']    := 'Parse do JSON'
        jResponse['errorLog'] := cErrorLog
        jResponse['solution'] := 'Erro ao fazer o Parse do JSON'

        ConOut("erro 004")
        
		cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
		oWS:GRAVALOGMURO(cResponc, cJason, "WSNFE", "INCLUSÃO DE Nota Fiscal de Entrada")
    Else

        aRetGrv := oWS:GerNFE( (cEnum + cExter), cChavNfe, 3, dAltVct, cDoc, cSeri, _CNPJCPF)  //17/11/2025 - ajustado - //oWS:GerNFE( jJson:GetJsonObject("IDPEDCOMPREXT"), jJson:GetJsonObject("CHVNFE"), 3) 

		If len(aRetGrv) > 0 
			cErrorLog   := ''
			aLogAuto    := aRetGrv // GetAutoGrLog()
			For nLinha := 1 To Len(aLogAuto)
				cErrorLog += aLogAuto[nLinha,1] + CRLF
			Next nLinha

            Self:setStatus(504) 
			jResponse['errorId']  := 'NEW005'
			jResponse['error']    := 'Erro na inclusão do registro'
			jResponse['errorLog'] := cErrorLog
			jResponse['solution'] := 'Nao foi possivel incluir o registro, foi gerado um arquivo de log em ' + cDirLog + cArqLog + ' '
			lRet := .F.

			cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
			oWS:GRAVALOGMURO(cResponc, cJason, "WSNFE", "INCLUSÃO DE Nota Fiscal de Entrada")

            ConOut("erro 005")
       
		Else
			jResponse['note']     := 'Registro incluido com sucesso - ' 
		EndIf

    EndIf
    rpcClearEnv()
    cEmpAnt  := cEmpAt1
    cFilAnt  := cFilAt1
    
    ConOut("ô sistema Bommm " )
        
    //Define o retorno
    Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
Return lRet

