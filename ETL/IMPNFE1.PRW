#include "totvs.ch"
#include "protheus.ch"
#include "TOPCONN.CH"

User Function ImpNFE1()
    Local aArea  := GetArea()
    Processa({||ImpDados()},"Aguarde Gerando Notas de Compras " )
    RestArea(aArea)
Return

Static Function ImpDados()
    Local aAreaIm  := GetArea()

    Local cQueryTab := ""
    Local nTotal    := 0
    Local nConte    := 0

    Count To nTotal
    ProcRegua(nTotal)
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZE") + " ZZE " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZE.D_E_L_E_T_ = '' AND ZZE_STATUS IN ('9', '0') AND " + CRLF
    cQueryTab += "     R_E_C_N_O_ BETWEEN "+'26655'+" AND "+'26955'+" AND ZZE_STATUS IN ('9', '0') " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    nConte := 0
    WHILE !(QRY_TAB->(EOF()))
        nConte++

        IncProc("Qtd: " + Alltrim(Str(nConte)) + " - ExternID: " + Alltrim(QRY_TAB->ZZE_ZEXTID) + " - Registro: " + ALLTRIM(sTR(QRY_TAB->RECNO)) + " de 21650")

        _CNPJCPF:= IIF(EMPTY(QRY_TAB->ZZE_CNPJFO), Substr( QRY_TAB->ZZE_CHVNF,7, 14), QRY_TAB->ZZE_CNPJFO)
        lTemFor := ows:temFornec(FWxFilial("SA2"), _CNPJCPF)

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(QRY_TAB->ZZE_GRUPO),  "01", QRY_TAB->ZZE_GRUPO)
        cFilAt   := Iif(EMPTY(QRY_TAB->ZZE_FILIAL), "01", QRY_TAB->ZZE_FILIAL)

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

        //RPCSetEnv(cEmpAt, cFilAt)

        IF !lTemFor
            oWS:GRAVALOGZZE(nRecn, cExter, "FORNECEDOR NÃO EXISTE", "WSNFE", "INCLUSÃO DE Nota Fiscal de Entrada")
        EndIF

        alTemExtr := ows:PGExtDad(cEnum + cExter) 
        IF len(alTemExtr) == 0  //Verifica se tem ExternoID - Numero do Pedido Externo
            oWS:GRAVALOGZZE(nRecn, cExter, "PEDIDO DE COMPRAS NAO EXISTE", "WSNFE", "INCLUSÃO DE Nota Fiscal de Entrada")
        EndIF
        
        aRetGrv := oWS:GerNFE( cExter, cChavNfe, 3, dAltVct, cDoc, cSeri, cEnum, (cEnum + cExter))  //17/11/2025 - ajustado - //oWS:DGerNFE( jJson:GetJsonObject("IDPEDCOMPREXT"), jJson:GetJsonObject("CHVNFE"), 3) 
        If len(aRetGrv) > 0 
            cErrorLog   := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO
            oWS:GRAVALOGZZE(nRecn, cExter, cErrorLog, "WSNFE", "INCLUSÃO DE Nota Fiscal de Entrada")
        Else
            oWS:mudaSts(nRecn, cExter, "1")
        EndIf
        cEmpAnt  := cEmpAt1
        cFilAnt  := cFilAt1

        QRY_TAB->(dbSkip())
        LOOP
    ENDDO	
    QRY_TAB->(DBCLOSEAREA())
    RestArea(aAreaIm)
    //rpcClearEnv()

Return
