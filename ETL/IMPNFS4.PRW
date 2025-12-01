#include "totvs.ch"
#include "protheus.ch"
#include "TOPCONN.CH"

User Function ImpNFS4()
    Local aArea  := GetArea()
	Processa({||ImpDados()},"Aguarde Gerando Notas de Vendas.." )
    RestArea(aArea)
Return

Static Function ImpDados()
    Local cQueryTab := ""
    Local nTotal := 0
    Local nInicio := '4001'
    Local nFinal  := '5000'

    Count To nTotal
    ProcRegua(nTotal)
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZF") + " ZZF " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZF.D_E_L_E_T_ = '' AND ZZF_STATUS = '0' " + CRLF
    cQueryTab += "     AND R_E_C_N_O_ BETWEEN "+nInicio+" AND "+nFinal+" " + CRLF
    cQueryTab += "     ORDER BY ZZF_VALOR DESC " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    nConte := 0
    WHILE !(QRY_TAB->(EOF()))
        nConte++
        //IncProc("Externi: " + QRY_TAB->ZZF_ZEXTID )
        IncProc("Qtd: " + Alltrim(Str(nConte)) + " - ExternID: " + Alltrim(QRY_TAB->ZZF_ZEXTID) + " - Registro: " + ALLTRIM(sTR(QRY_TAB->RECNO))  )

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(QRY_TAB->ZZF_GRUPO),  "01", QRY_TAB->ZZF_GRUPO)
        cFilAt   := Iif(EMPTY(QRY_TAB->ZZF_FILIAL), "01", QRY_TAB->ZZF_FILIAL)

        cEmpAnt  := cEmpAt
        cFilAnt  := cFilAt

        cEnum    := QRY_TAB->ZZF_ZGRPEN
        cExter   := QRY_TAB->ZZF_ZEXTID
        cDoc     := QRY_TAB->ZZF_NUMNF
        cSeri    := QRY_TAB->ZZF_SERNFE
        dAltVct  := QRY_TAB->ZZF_DTALTE
        cChavNfe := QRY_TAB->ZZF_CHVNF
        nRecn    := QRY_TAB->RECNO
        cCentCus := QRY_TAB->ZZF_CC

        alTemExtr := ows:PGExtPDV(cEnum + cExter) 

        IF len(alTemExtr) == 0  //Verifica se tem ExternoID - Numero do Pedido Externo
            oWS:GRVALGZZF(nRecn, cExter, "PEDIDO DE VENDAS NAO EXISTE", "WSNFS", "INCLUSÃO DE Nota Fiscal de Saida")
        ELSE
            cPdv   := alTemExtr[1,1]
            cod    := alTemExtr[1,3]
            loja   := alTemExtr[1,4]
            lTemCli := ows:temCliCod(FWxFilial("SA1"), cod, loja)

            RPCSetEnv(cEmpAt, cFilAt)

            IF !lTemCli
                oWS:GRVALGZZF(nRecn, cExter, "CLIENTE NÃO EXISTE", "WSNFS", "INCLUSÃO DE Nota Fiscal de Saida")
            EndIF
            
            lPrdIg := ows:VLDPRD((cEnum + cExter), alTemExtr) 
            IF lPrdIg //ha um produto diferente!?
                oWS:GRVALGZZF(nRecn, cExter, "PRODUTOS DIFERENTES ENTRE OC E OV", "WSNFS", "INCLUSÃO DE Nota Fiscal de Saida")
            EndIF

            lTESEst := ows:PGExtest(cEnum + cExter) 
            IF !lTESEst  //Verifica se tem ExternoID - Numero do Pedido Externo
                oWS:GRVALGZZF(nRecn, cExter, "TES - NÃO MOVIMENTA ESTOQUE", "WSNFS", "INCLUSÃO DE Nota Fiscal de Saida")
                oWS:mudaStsf(nRecn, cExter, "3")  //sem pedido de compras
            Else
                aRetGrv := oWS:GerarNota(cPdv, cFilAt)
                If len(aRetGrv) == 0 
                    //cErrorLog   := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO
                    oWS:GRVALGZZF(nRecn, cExter, "ERRO NA GERAÇÃO DA NOTA DE SAIDA", "WSNFS", "INCLUSÃO DE Nota Fiscal de Saida")
                Else
                    oWS:mudaStsf(nRecn, cExter, "1")
                EndIf
            Endif

            cEmpAnt  := cEmpAt1
            cFilAnt  := cFilAt1
    	EndIF
        
        QRY_TAB->(dbSkip())
        LOOP
    ENDDO	
    QRY_TAB->(DBCLOSEAREA())
    //rpcClearEnv()

Return
