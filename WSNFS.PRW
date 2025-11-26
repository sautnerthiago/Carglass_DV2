//Bibliotecas
#Include "Totvs.ch"
#Include "RESTFul.ch"
#Include "TopConn.ch"
#Include 'Protheus.ch'
#INCLUDE 'APWEBSRV.CH'
#Include "tbiconn.ch"

/*/{Protheus.doc} WSRESTFUL WSNFS
GERAÇÃO DE NOTA FISCAL DE Saida
@author JOSE EDILSON DE LIMA PINTO
@since 14/10/2025
@version 1.0
@type wsrestful
/*/

WSSTRUCT ITEMPDV

	WSDATA nitem as INTEGER
	WSDATA cCodProd as String
	WSDATA cDescProd as String
	WSDATA nQuant as Float

ENDWSSTRUCT

WSRESTFUL WSNFS DESCRIPTION 'NOTA FISCAL DE SAIDA'
    //Atributos
    WSDATA NUMPV       AS STRING
    WSDATA emissao     AS STRING
    WSDATA item        AS ITEMPDV
    
    WSDATA page AS INTEGER OPTIONAL
	WSDATA pageSize AS INTEGER OPTIONAL
	WSDATA searchKey AS STRING OPTIONAL

    WSMETHOD POST   NEW    DESCRIPTION 'Inclusão de registro'          WSSYNTAX '/WSNFS/new'                      PATH 'new'           PRODUCES APPLICATION_JSON

END WSRESTFUL

WSMETHOD POST NEW WSRECEIVE NUMPV WSSERVICE WSNFS
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
    
    Local alTemExtr         := {}
    Local aRetGrv           := {}

    Local lTemCli           := .F.

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
    
    ConOut("iniciando Nota Fiscal de Saida")
    
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

    cEnum := jJson:GetJsonObject("IDPEDCOMPREXT")
	cExter:= jJson:GetJsonObject("EXTERNID")

    alTemExtr := ows:PGExtPDV(cEnum + cExter) //ows:PGExtDad(jJson:GetJsonObject("IDPEDCOMPREXT"))

    //_CNPJCPF:= Substr( jJson:GetJsonObject("CHVNFE" ),7, 14) //jJson:GetJsonObject("CNPJ")
    cod    := alTemExtr[1,3]
    loja   := alTemExtr[1,4]
    lTemCli := ows:temCliCod(FWxFilial("SA1"), cod, loja)

    cEmpAt1 := cEmpAnt
    cFilAt1 := cFilAnt

    cEmpAt   := Iif(EMPTY(jJson:GetJsonObject("GRUPO") ), "01", jJson:GetJsonObject("GRUPO" ))
    cFilAt   := Iif(EMPTY(jJson:GetJsonObject("FILIAL")), "01", jJson:GetJsonObject("FILIAL"))

    cEmpAnt  := cEmpAt
    cFilAnt  := cFilAt
    
    RPCSetEnv(cEmpAt, cFilAt)

    IF !lTemCli
		Self:setStatus(501) //erro no JSON
		jResponse['errorId']  := 'NEW0041'
		jResponse['error']    := 'Cliente NAO EXISTE'
        jResponse['errorLog'] := cErrorLog
		jResponse['solution'] := 'CADASTRE UM Cliente'

		cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
		oWS:GRAVALOGMURO(cResponc, cJason, "WSNFS", "INCLUSÃO DE Nota Fiscal de Saida")

        ConOut("erro 002")

        Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
        Return .F.
	EndIF

	IF len(alTemExtr) == 0  //Verifica se tem ExternoID - Numero do Pedido Externo
		Self:setStatus(502)
		jResponse['errorId']  := 'NEW0041'
		jResponse['error']    := 'PEDIDO DE VENDAS NAO EXISTE'
        jResponse['errorLog'] := cErrorLog
		jResponse['solution'] := 'CADASTRE UM PEDIDO DE VENDAS QUE DESEJA GERAR A NOTA'

		cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
		oWS:GRAVALOGMURO(cResponc, cJason, "WSNFS", "INCLUSAO DE Nota Fiscal de Saida")

        ConOut("erro 003 - nfs")
        
        Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
        Return .F.
	EndIF
 
    //Se tiver algum erro no Parse, encerra a execução
    IF !Empty(cError)
        Self:setStatus(503) 
        jResponse['errorId']  := 'NEW004'
        jResponse['error']    := 'Parse do JSON'
        jResponse['errorLog'] := cErrorLog
        jResponse['solution'] := 'Erro ao fazer o Parse do JSON'

        ConOut("erro 004")
        
		cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
		oWS:GRAVALOGMURO(cResponc, cJason, "WSNFS", "INCLUSÃO DE Nota Fiscal de Saida")
    Else
        		
        cPdv    := alTemExtr[1,1]
        aRetGrv := oWS:GerarNota(cPdv, cFilAt)

		If Len(aRetGrv) == 0
			cErrorLog   := ''
			aLogAuto    := aRetGrv // GetAutoGrLog()
			For nLinha := 1 To Len(aLogAuto)
				cErrorLog += aLogAuto[nLinha,1] + CRLF
			Next nLinha

			//Grava o arquivo de log
			cArqLog := 'WSNFS_New_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
			MemoWrite(cDirLog + cArqLog, cErrorLog)

            Self:setStatus(504) 
			jResponse['errorId']  := 'NEW005'
			jResponse['error']    := 'Erro na inclusão do registro'
			jResponse['errorLog'] := cErrorLog
			jResponse['solution'] := 'Nao foi possivel incluir o registro, foi gerado um arquivo de log em ' + cDirLog + cArqLog + ' '
			lRet := .F.

			cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
			oWS:GRAVALOGMURO(cResponc, cJason, "WSNFS", "INCLUSÃO DE Nota Fiscal de Saida")

            ConOut("erro 005")
       
		Else
			jResponse['note']     := 'Registro incluido com sucesso - ' + aRetGrv[1,1] + " - " + aRetGrv[1,2]
		EndIf

    EndIf
    rpcClearEnv()
    cEmpAnt  := cEmpAt1
    cFilAnt  := cFilAt1
    
    ConOut("O sistema Bommm - Gerou a nota saida " )
        
    //Define o retorno
    Self:SetResponse(EncodeUTF8(jResponse:toJSON()))
Return lRet

