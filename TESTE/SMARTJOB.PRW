#include "totvs.ch"
#include "protheus.ch"
#include "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

User Function SMARTJOB()
    Local aAreaIm  := GetArea()
        SmartJob("u_JOBSAI01",GetEnvServer(),.F.)
        SmartJob("u_JOBSAI02",GetEnvServer(),.F.)
        SmartJob("u_JOBSAI03",GetEnvServer(),.F.)
        SmartJob("u_JOBSAI04",GetEnvServer(),.F.)
    RestArea(aAreaIm)
Return

User Function JOBSAI01()
    Local cQueryTab := ""
    Local aRetGrv   := {}
    Local aArea     := FWGetArea()

    conout("INICIANDO JOBSAI01")
    PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO 'FAT'
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZF") + " ZZF " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZF.D_E_L_E_T_ = '' AND ZZF_STATUS = '0' " + CRLF
    cQueryTab += "     AND ZZF_FILIAL IN ('01', '02', '03', '04', '05') AND ZZF_VALOR > 0 " + CRLF
    cQueryTab += "     ORDER BY ZZF_VALOR DESC " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    nConte := 0
    cHora := Val(substr(Time(),1,2))
    WHILE !(QRY_TAB->(EOF()))

        nResult := Val(substr(Time(),1,2))
        if nResult > cHora
            QRY_TAB->(DBCLOSEAREA())
            RestArea(aArea)
            CONOUT("FINALIZOU JOB NFS")
            RESET ENVIRONMENT
            Return
        endif

        nConte++
        conout("LACO JOBSAI - " + QRY_TAB->ZZF_ZEXTID)

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
                lPedi   := VldNot(cPdv, cFilAt) //validação de existencia do pedido ja faturado - 08/12/2025 - victor
                if !lPedi
                    aRetGrv := oWS:GerarNota(cPdv, cFilAt)
                endif

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
    RestArea(aArea)
    CONOUT("FINALIZOUJOB NFS")
    RESET ENVIRONMENT

Return

User Function JOBSAI02()
    Local cQueryTab := ""
    Local aRetGrv   := {}
    Local aArea     := FWGetArea()

    conout("INICIANDO JOBSAI02")
    PREPARE ENVIRONMENT EMPRESA "01" FILIAL "02" MODULO 'FAT'
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZF") + " ZZF " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZF.D_E_L_E_T_ = '' AND ZZF_STATUS = '0' " + CRLF
    cQueryTab += "     AND ZZF_FILIAL IN ('06', '07', '08', '09', '10')  AND ZZF_VALOR > 0 " + CRLF
    cQueryTab += "     ORDER BY ZZF_VALOR DESC " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    nConte := 0
    cHora := Val(substr(Time(),1,2))
    WHILE !(QRY_TAB->(EOF()))

        nResult := Val(substr(Time(),1,2))
        if nResult > cHora
            QRY_TAB->(DBCLOSEAREA())
            RestArea(aArea)
            CONOUT("FINALIZOUJOB NFS")
            RESET ENVIRONMENT
            Return
        endif

        nConte++
        conout("LACO JOBSAI - " + QRY_TAB->ZZF_ZEXTID)

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

                lPedi   := VldNot(cPdv, cFilAt) //validação de existencia do pedido ja faturado - 08/12/2025 - victor
                if !lPedi
                    aRetGrv := oWS:GerarNota(cPdv, cFilAt)
                endif
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
    RestArea(aArea)
    CONOUT("FINALIZOUJOB NFS")
    RESET ENVIRONMENT

Return

User Function JOBSAI03()
    Local cQueryTab := ""
    Local aRetGrv   := {}
    Local aArea     := FWGetArea()

    conout("INICIANDO JOBSAI03")
    PREPARE ENVIRONMENT EMPRESA "01" FILIAL "03" MODULO 'FAT'
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZF") + " ZZF " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZF.D_E_L_E_T_ = '' AND ZZF_STATUS = '0' " + CRLF
    cQueryTab += "     AND ZZF_FILIAL IN ('11', '12', '13', '14', '15')  AND ZZF_VALOR > 0 " + CRLF
    cQueryTab += "     ORDER BY ZZF_VALOR DESC " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    nConte := 0
    cHora := Val(substr(Time(),1,2))
    WHILE !(QRY_TAB->(EOF()))

        nResult := Val(substr(Time(),1,2))
        if nResult > cHora
            QRY_TAB->(DBCLOSEAREA())
            RestArea(aArea)
            CONOUT("FINALIZOUJOB NFS")
            RESET ENVIRONMENT
            Return
        endif
        nConte++
        conout("LACO JOBSAI - " + QRY_TAB->ZZF_ZEXTID)

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

                lPedi   := VldNot(cPdv, cFilAt) //validação de existencia do pedido ja faturado - 08/12/2025 - victor
                if !lPedi
                    aRetGrv := oWS:GerarNota(cPdv, cFilAt)
                endif

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
    RestArea(aArea)
    CONOUT("FINALIZOUJOB NFS")
    RESET ENVIRONMENT

Return

User Function JOBSAI04()
    Local cQueryTab := ""
    Local aRetGrv   := {}
    Local aArea     := FWGetArea()

    conout("INICIANDO JOBSAI04")
    PREPARE ENVIRONMENT EMPRESA "01" FILIAL "04" MODULO 'FAT'
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZF") + " ZZF " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZF.D_E_L_E_T_ = '' AND ZZF_STATUS = '0' " + CRLF
    cQueryTab += "     AND ZZF_FILIAL IN ('16', '17', '18', '19', '20')  AND ZZF_VALOR > 0 " + CRLF
    cQueryTab += "     ORDER BY ZZF_VALOR DESC " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    nConte := 0
    cHora := Val(substr(Time(),1,2))
    WHILE !(QRY_TAB->(EOF()))

        nResult := Val(substr(Time(),1,2))
        if nResult > cHora
            QRY_TAB->(DBCLOSEAREA())
            RestArea(aArea)
            CONOUT("FINALIZOUJOB NFS")
            RESET ENVIRONMENT
            Return
        endif
        nConte++
        conout("LACO JOBSAI - " + QRY_TAB->ZZF_ZEXTID)

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
                lPedi   := VldNot(cPdv, cFilAt) //validação de existencia do pedido ja faturado - 08/12/2025 - victor
                if !lPedi
                    aRetGrv := oWS:GerarNota(cPdv, cFilAt)
                endif

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
    RestArea(aArea)
    CONOUT("FINALIZOUJOB NFS")
    RESET ENVIRONMENT

Return

Static Function VldNot(cPdv, _Fil)
    Local lRet := .F.
    conout("VERIFNCANDO SE TEM NOTA PARA PEDIDO DE VENDAS")

    cQueryTab := " SELECT COUNT(*) AS QTD " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("SD2") + " SD2 " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     SD2.D_E_L_E_T_ = ''  " + CRLF
    cQueryTab += "     AND D2_FILIAL = '"+_Fil+"' AND D2_PEDIDO = '"+cPdv+"' " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TMP'    

    IF QRY_TMP->QTD > 0
        lRet := .T.
        conout("NAO SERÁ GERADA A FATURA - TEM PEDIDO DE VENDAS JA FATURADO")
    ENDIF

    QRY_TMP->(DBCLOSEAREA())

Return lret 

