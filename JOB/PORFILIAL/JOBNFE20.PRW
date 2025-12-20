#include "totvs.ch"
#include "protheus.ch"
#include "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

#Define CTRL Chr(13)+Chr(10)

User Function JOBNFE20()
    Local cQueryTab := ""
    Local nConte    := 0
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    PREPARE ENVIRONMENT EMPRESA '01' FILIAL '20' MODULO 'EST'

    conout("INICIANDO JOBNFE20" )
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZE") + " ZZE " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZE.D_E_L_E_T_ = '' AND ZZE_STATUS IN ('9', '0') " + CRLF
    cQueryTab += "     AND ZZE_FILIAL IN ('20') " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    nConte := 0
    cHora := Val(substr(Time(),1,2))
    WHILE !(QRY_TAB->(EOF()))
        nResult := Val(substr(Time(),1,2))
        if nResult > cHora
            QRY_TAB->(DBCLOSEAREA())
            CONOUT("FINALIZOUJOB NFE")
            RESET ENVIRONMENT
            Return
        endif
        nConte++
        conout("LACO JOBNFE - " + QRY_TAB->ZZE_ZEXTID)

        _CNPJCPF:= IIF(EMPTY(QRY_TAB->ZZE_CNPJFO), Substr( QRY_TAB->ZZE_CHVNF,7, 14), QRY_TAB->ZZE_CNPJFO)
        lTemFor := ows:temFornec(FWxFilial("SA2"), _CNPJCPF)

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(QRY_TAB->ZZE_GRUPO),  "01", QRY_TAB->ZZE_GRUPO)
        cFilAt   := Iif(EMPTY(QRY_TAB->ZZE_FILIAL), "20", QRY_TAB->ZZE_FILIAL)

        cEmpAnt  := cEmpAt
        cFilAnt  := cFilAt

        cEnum    := QRY_TAB->ZZE_ZGRPEN
        cExter   := QRY_TAB->ZZE_ZEXTID
        cDoc     := QRY_TAB->ZZE_NUMNF
        cSeri    := QRY_TAB->ZZE_SERNFE
        dAltVct  := QRY_TAB->ZZE_DTALTE
        cChavNfe := QRY_TAB->ZZE_CHVNF
        nRecn    := QRY_TAB->RECNO
        cCentCus := QRY_TAB->ZZE_CC

        IF !lTemFor
            oWS:GRAVALOGZZE(nRecn, cExter, "FORNECEDOR NÃO EXISTE", "WSNFE", "INCLUSÃO DE Nota Fiscal de Entrada")
            cLog += "JOB 20 Documento: " + cDoc + " - ExtId: " + cExter + " Erro Cad Fornecedor " + CRLF
        EndIF

        alTemExtr := ows:PGExtDad(cEnum + cExter) 
        IF len(alTemExtr) == 0  //Verifica se tem ExternoID - Numero do Pedido Externo
            oWS:GRAVALOGZZE(nRecn, cExter, "PEDIDO DE COMPRAS NAO EXISTE", "WSNFE", "INCLUSÃO DE Nota Fiscal de Entrada")
            cLog += "JOB 20 Documento: " + cDoc + " - ExtId: " + cExter + " PEDIDO DE COMPRAS NÃO EXISTE " + CRLF
        EndIF
        
        aRetGrv := oWS:GerNFE( cExter, cChavNfe, 3, dAltVct, cDoc, cSeri, cEnum, (cEnum + cExter))  //17/11/2025 - ajustado - //oWS:DGerNFE( jJson:GetJsonObject("IDPEDCOMPREXT"), jJson:GetJsonObject("CHVNFE"), 3) 
        If len(aRetGrv) > 0 
            cErrorLog   := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO
            oWS:GRAVALOGZZE(nRecn, cExter, cErrorLog, "WSNFE", "INCLUSÃO DE Nota Fiscal de Entrada")
            cLog += "JOB 20 Documento: " + cDoc + " - ExtId: " + cExter + " Erro na Gravacao da NFE  - " + cErrorLog + CRLF
        Else
            oWS:mudaSts(nRecn, cExter, "1")
        EndIf
        cEmpAnt  := cEmpAt1
        cFilAnt  := cFilAt1

        QRY_TAB->(dbSkip())
        LOOP
    ENDDO	
    QRY_TAB->(DBCLOSEAREA())
    conout("FINALIZOU JOBNFE")
    RESET ENVIRONMENT

    cArqLog := 'JOB20_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
    MemoWrite(cDirLog + cArqLog, cLog)

    ConOut(OemToAnsi("Fim : ")+Time())

Return
