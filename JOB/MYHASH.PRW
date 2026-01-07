#include "totvs.ch"
#include "protheus.ch"
#include "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

User Function MYHASH()
    Local aAreaIm  := GetArea()
        //SAIDAS - INICIO
        StartJob("u_JOBSAI01",GetEnvServer(),.F.)
        StartJob("u_JOBSAI02",GetEnvServer(),.F.)
        // StartJob("u_JOBSAI03",GetEnvServer(),.F.)
        // StartJob("u_JOBSAI04",GetEnvServer(),.F.)
        // StartJob("u_JOBSAI05",GetEnvServer(),.F.)

        // StartJob("u_JOBSAI06",GetEnvServer(),.F.)
        // StartJob("u_JOBSAI07",GetEnvServer(),.F.)
        // StartJob("u_JOBSAI08",GetEnvServer(),.F.)
        // StartJob("u_JOBSAI09",GetEnvServer(),.F.)
        // StartJob("u_JOBSAI10",GetEnvServer(),.F.)

        // StartJob("u_JOBSAI11",GetEnvServer(),.F.)
        // StartJob("u_JOBSAI12",GetEnvServer(),.F.)
        // StartJob("u_JOBSAI13",GetEnvServer(),.F.)
        // StartJob("u_JOBSAI14",GetEnvServer(),.F.)
        // StartJob("u_JOBSAI15",GetEnvServer(),.F.)

        // StartJob("u_JOBSAI16",GetEnvServer(),.F.)
        // StartJob("u_JOBSAI17",GetEnvServer(),.F.)
        // StartJob("u_JOBSAI18",GetEnvServer(),.F.)
        // StartJob("u_JOBSAI19",GetEnvServer(),.F.)
        // StartJob("u_JOBSAI20",GetEnvServer(),.F.)


        //ENTRADAS - INICIO
        // StartJob("u_JOBENT01",GetEnvServer(),.F.)
        // StartJob("u_JOBENT02",GetEnvServer(),.F.)
        // StartJob("u_JOBENT03",GetEnvServer(),.F.)
        // StartJob("u_JOBENT04",GetEnvServer(),.F.)
        // StartJob("u_JOBENT05",GetEnvServer(),.F.)

        // StartJob("u_JOBENT06",GetEnvServer(),.F.)
        // StartJob("u_JOBENT07",GetEnvServer(),.F.)
        // StartJob("u_JOBENT08",GetEnvServer(),.F.)
        // StartJob("u_JOBENT09",GetEnvServer(),.F.)
        // StartJob("u_JOBENT10",GetEnvServer(),.F.)

        // StartJob("u_JOBENT11",GetEnvServer(),.F.)
        // StartJob("u_JOBENT12",GetEnvServer(),.F.)
        // StartJob("u_JOBENT13",GetEnvServer(),.F.)
        // StartJob("u_JOBENT14",GetEnvServer(),.F.)
        // StartJob("u_JOBENT15",GetEnvServer(),.F.)

        // StartJob("u_JOBENT16",GetEnvServer(),.F.)
        // StartJob("u_JOBENT17",GetEnvServer(),.F.)
        // StartJob("u_JOBENT18",GetEnvServer(),.F.)
        // StartJob("u_JOBENT19",GetEnvServer(),.F.)
        // StartJob("u_JOBENT20",GetEnvServer(),.F.)

    RestArea(aAreaIm)
Return

//INICIO DAS SAIDAS
User Function JOBSAI01()
    Local cQueryTab := ""
    Local aRetGrv   := {}
    Local aArea     := FWGetArea()
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    conout("INICIANDO JOBSAI01")
    //PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO 'FAT'
    RPCSetEnv("01", "01")
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZF") + " ZZF " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZF.D_E_L_E_T_ = '' AND ZZF_STATUS = '0' " + CRLF
    cQueryTab += "     AND ZZF_FILIAL IN ('01') AND ZZF_VALOR > 0 " + CRLF
    cQueryTab += "     ORDER BY ZZF_VALOR DESC " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    nConte := 0
    WHILE !(QRY_TAB->(EOF()))

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
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOBS01_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        MemoWrite(cDirLog + cArqLog, cLog)
    endif

Return

User Function JOBSAI02()
    Local cQueryTab := ""
    Local aRetGrv   := {}
    Local aArea     := FWGetArea()
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    conout("INICIANDO JOBSAI02")
    //PREPARE ENVIRONMENT EMPRESA "01" FILIAL "02" MODULO 'FAT'
    RPCSetEnv("01", "02")

    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZF") + " ZZF " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZF.D_E_L_E_T_ = '' AND ZZF_STATUS = '0' " + CRLF
    cQueryTab += "     AND ZZF_FILIAL IN ('02')  AND ZZF_VALOR > 0 " + CRLF
    cQueryTab += "     ORDER BY ZZF_VALOR DESC " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    nConte := 0
    WHILE !(QRY_TAB->(EOF()))

        nConte++
        conout("LACO JOBSAI 02 - " + QRY_TAB->ZZF_ZEXTID)

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
    CONOUT("FINALIZOUJOB NFS - 02")
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOBS02_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        MemoWrite(cDirLog + cArqLog, cLog)
    endif

Return

User Function JOBSAI03()
    Local cQueryTab := ""
    Local aRetGrv   := {}
    Local aArea     := FWGetArea()
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    conout("INICIANDO JOBSAI03")
    //PREPARE ENVIRONMENT EMPRESA "01" FILIAL "03" MODULO 'FAT'
    RPCSetEnv("01", "03")
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZF") + " ZZF " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZF.D_E_L_E_T_ = '' AND ZZF_STATUS = '0' " + CRLF
    cQueryTab += "     AND ZZF_FILIAL IN ('03')  AND ZZF_VALOR > 0 " + CRLF
    cQueryTab += "     ORDER BY ZZF_VALOR DESC " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    nConte := 0
    WHILE !(QRY_TAB->(EOF()))

        nConte++
        conout("LACO JOBSAI - 03 " + QRY_TAB->ZZF_ZEXTID)

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
    CONOUT("FINALIZOUJOB NFS 03")
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOBS03_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        MemoWrite(cDirLog + cArqLog, cLog)
    endif

Return

User Function JOBSAI04()
    Local cQueryTab := ""
    Local aRetGrv   := {}
    Local aArea     := FWGetArea()
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    conout("INICIANDO JOBSAI04")
    //PREPARE ENVIRONMENT EMPRESA "01" FILIAL "04" MODULO 'FAT'
    RPCSetEnv("01", "04")
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZF") + " ZZF " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZF.D_E_L_E_T_ = '' AND ZZF_STATUS = '0' " + CRLF
    cQueryTab += "     AND ZZF_FILIAL IN ('04')  AND ZZF_VALOR > 0 " + CRLF
    cQueryTab += "     ORDER BY ZZF_VALOR DESC " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    nConte := 0
    WHILE !(QRY_TAB->(EOF()))

        nConte++
        conout("LACO JOBSAI - 04 " + QRY_TAB->ZZF_ZEXTID)

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
    CONOUT("FINALIZOUJOB NFS - 04")
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOBS04_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        MemoWrite(cDirLog + cArqLog, cLog)
    endif


Return

User Function JOBSAI05()
    Local cQueryTab := ""
    Local aRetGrv   := {}
    Local aArea     := FWGetArea()
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    conout("INICIANDO JOBSAI05")
    //PREPARE ENVIRONMENT EMPRESA "01" FILIAL "04" MODULO 'FAT'
    RPCSetEnv("01", "05")
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZF") + " ZZF " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZF.D_E_L_E_T_ = '' AND ZZF_STATUS = '0' " + CRLF
    cQueryTab += "     AND ZZF_FILIAL IN ('05')  AND ZZF_VALOR > 0 " + CRLF
    cQueryTab += "     ORDER BY ZZF_VALOR DESC " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    nConte := 0
    WHILE !(QRY_TAB->(EOF()))

        nConte++
        conout("LACO JOBSAI - 05 " + QRY_TAB->ZZF_ZEXTID)

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
    CONOUT("FINALIZOUJOB NFS - 05")
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOBS05_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        MemoWrite(cDirLog + cArqLog, cLog)
    endif

Return


User Function JOBSAI06()
    Local cQueryTab := ""
    Local aRetGrv   := {}
    Local aArea     := FWGetArea()
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    conout("INICIANDO JOBSAI 06")
    RPCSetEnv("01", "06")
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZF") + " ZZF " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZF.D_E_L_E_T_ = '' AND ZZF_STATUS = '0' " + CRLF
    cQueryTab += "     AND ZZF_FILIAL IN ('06') AND ZZF_VALOR > 0 " + CRLF
    cQueryTab += "     ORDER BY ZZF_VALOR DESC " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    nConte := 0
    WHILE !(QRY_TAB->(EOF()))

        nConte++
        conout("LACO JOBSAI - 06 " + QRY_TAB->ZZF_ZEXTID)

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(QRY_TAB->ZZF_GRUPO),  "01", QRY_TAB->ZZF_GRUPO)
        cFilAt   := Iif(EMPTY(QRY_TAB->ZZF_FILIAL), "06", QRY_TAB->ZZF_FILIAL)

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
    CONOUT("FINALIZOUJOB NFS - 06")
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOBS06_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        MemoWrite(cDirLog + cArqLog, cLog)
    endif


Return

User Function JOBSAI07()
    Local cQueryTab := ""
    Local aRetGrv   := {}
    Local aArea     := FWGetArea()
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    conout("INICIANDO JOBSAI 07")
    RPCSetEnv("01", "07")

    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZF") + " ZZF " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZF.D_E_L_E_T_ = '' AND ZZF_STATUS = '0' " + CRLF
    cQueryTab += "     AND ZZF_FILIAL IN ('07')  AND ZZF_VALOR > 0 " + CRLF
    cQueryTab += "     ORDER BY ZZF_VALOR DESC " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    nConte := 0
    WHILE !(QRY_TAB->(EOF()))

        nConte++
        conout("LACO JOBSAI 07 - " + QRY_TAB->ZZF_ZEXTID)

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(QRY_TAB->ZZF_GRUPO),  "01", QRY_TAB->ZZF_GRUPO)
        cFilAt   := Iif(EMPTY(QRY_TAB->ZZF_FILIAL), "07", QRY_TAB->ZZF_FILIAL)

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
    CONOUT("FINALIZOUJOB NFS - 07")

    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOBS07_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        MemoWrite(cDirLog + cArqLog, cLog)
    endif


Return

User Function JOBSAI08()
    Local cQueryTab := ""
    Local aRetGrv   := {}
    Local aArea     := FWGetArea()
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    conout("INICIANDO JOBSAI 08")
    //PREPARE ENVIRONMENT EMPRESA "01" FILIAL "03" MODULO 'FAT'
    RPCSetEnv("01", "08")
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZF") + " ZZF " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZF.D_E_L_E_T_ = '' AND ZZF_STATUS = '0' " + CRLF
    cQueryTab += "     AND ZZF_FILIAL IN ('08')  AND ZZF_VALOR > 0 " + CRLF
    cQueryTab += "     ORDER BY ZZF_VALOR DESC " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    nConte := 0
    WHILE !(QRY_TAB->(EOF()))

        nConte++
        conout("LACO JOBSAI - 08 " + QRY_TAB->ZZF_ZEXTID)

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(QRY_TAB->ZZF_GRUPO),  "01", QRY_TAB->ZZF_GRUPO)
        cFilAt   := Iif(EMPTY(QRY_TAB->ZZF_FILIAL), "08", QRY_TAB->ZZF_FILIAL)

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
    CONOUT("FINALIZOUJOB NFS 08")
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOBS08_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        MemoWrite(cDirLog + cArqLog, cLog)
    endif

Return

User Function JOBSAI09()
    Local cQueryTab := ""
    Local aRetGrv   := {}
    Local aArea     := FWGetArea()
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    conout("INICIANDO JOBSAI 09")
    RPCSetEnv("01", "09")
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZF") + " ZZF " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZF.D_E_L_E_T_ = '' AND ZZF_STATUS = '0' " + CRLF
    cQueryTab += "     AND ZZF_FILIAL IN ('09')  AND ZZF_VALOR > 0 " + CRLF
    cQueryTab += "     ORDER BY ZZF_VALOR DESC " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    nConte := 0
    WHILE !(QRY_TAB->(EOF()))

        nConte++
        conout("LACO JOBSAI - 09 " + QRY_TAB->ZZF_ZEXTID)

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(QRY_TAB->ZZF_GRUPO),  "01", QRY_TAB->ZZF_GRUPO)
        cFilAt   := Iif(EMPTY(QRY_TAB->ZZF_FILIAL), "09", QRY_TAB->ZZF_FILIAL)

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
    CONOUT("FINALIZOUJOB NFS - 09")
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOBS09_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        MemoWrite(cDirLog + cArqLog, cLog)
    endif


Return

User Function JOBSAI10()
    Local cQueryTab := ""
    Local aRetGrv   := {}
    Local aArea     := FWGetArea()
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    conout("INICIANDO JOBSAI 10")
    RPCSetEnv("01", "10")
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZF") + " ZZF " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZF.D_E_L_E_T_ = '' AND ZZF_STATUS = '0' " + CRLF
    cQueryTab += "     AND ZZF_FILIAL IN ('10')  AND ZZF_VALOR > 0 " + CRLF
    cQueryTab += "     ORDER BY ZZF_VALOR DESC " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    nConte := 0
    WHILE !(QRY_TAB->(EOF()))

        nConte++
        conout("LACO JOBSAI - 10 " + QRY_TAB->ZZF_ZEXTID)

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(QRY_TAB->ZZF_GRUPO),  "01", QRY_TAB->ZZF_GRUPO)
        cFilAt   := Iif(EMPTY(QRY_TAB->ZZF_FILIAL), "10", QRY_TAB->ZZF_FILIAL)

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
    CONOUT("FINALIZOUJOB NFS - 10")
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOBS10_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        MemoWrite(cDirLog + cArqLog, cLog)
    endif


Return

User Function JOBSAI11()
    Local cQueryTab := ""
    Local aRetGrv   := {}
    Local aArea     := FWGetArea()
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    conout("INICIANDO JOBSAI 11")
    RPCSetEnv("01", "11")
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZF") + " ZZF " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZF.D_E_L_E_T_ = '' AND ZZF_STATUS = '0' " + CRLF
    cQueryTab += "     AND ZZF_FILIAL IN ('11')  AND ZZF_VALOR > 0 " + CRLF
    cQueryTab += "     ORDER BY ZZF_VALOR DESC " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    nConte := 0
    WHILE !(QRY_TAB->(EOF()))

        nConte++
        conout("LACO JOBSAI - 11 " + QRY_TAB->ZZF_ZEXTID)

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(QRY_TAB->ZZF_GRUPO),  "01", QRY_TAB->ZZF_GRUPO)
        cFilAt   := Iif(EMPTY(QRY_TAB->ZZF_FILIAL), "11", QRY_TAB->ZZF_FILIAL)

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
    CONOUT("FINALIZOUJOB NFS - 11")
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOBS11_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        MemoWrite(cDirLog + cArqLog, cLog)
    endif

Return

User Function JOBSAI12()
    Local cQueryTab := ""
    Local aRetGrv   := {}
    Local aArea     := FWGetArea()
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    conout("INICIANDO JOBSAI 12")
    //PREPARE ENVIRONMENT EMPRESA "01" FILIAL "04" MODULO 'FAT'
    RPCSetEnv("01", "12")
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZF") + " ZZF " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZF.D_E_L_E_T_ = '' AND ZZF_STATUS = '0' " + CRLF
    cQueryTab += "     AND ZZF_FILIAL IN ('12')  AND ZZF_VALOR > 0 " + CRLF
    cQueryTab += "     ORDER BY ZZF_VALOR DESC " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    nConte := 0
    WHILE !(QRY_TAB->(EOF()))

        nConte++
        conout("LACO JOBSAI - 12 " + QRY_TAB->ZZF_ZEXTID)

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(QRY_TAB->ZZF_GRUPO),  "01", QRY_TAB->ZZF_GRUPO)
        cFilAt   := Iif(EMPTY(QRY_TAB->ZZF_FILIAL), "12", QRY_TAB->ZZF_FILIAL)

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
    CONOUT("FINALIZOUJOB NFS - 12")
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOBS12_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        MemoWrite(cDirLog + cArqLog, cLog)
    endif

Return

User Function JOBSAI13()
    Local cQueryTab := ""
    Local aRetGrv   := {}
    Local aArea     := FWGetArea()
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    conout("INICIANDO JOBSAI 13")
    RPCSetEnv("01", "13")
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZF") + " ZZF " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZF.D_E_L_E_T_ = '' AND ZZF_STATUS = '0' " + CRLF
    cQueryTab += "     AND ZZF_FILIAL IN ('13')  AND ZZF_VALOR > 0 " + CRLF
    cQueryTab += "     ORDER BY ZZF_VALOR DESC " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    nConte := 0
    WHILE !(QRY_TAB->(EOF()))

        nConte++
        conout("LACO JOBSAI - 13 " + QRY_TAB->ZZF_ZEXTID)

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(QRY_TAB->ZZF_GRUPO),  "01", QRY_TAB->ZZF_GRUPO)
        cFilAt   := Iif(EMPTY(QRY_TAB->ZZF_FILIAL), "13", QRY_TAB->ZZF_FILIAL)

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
    CONOUT("FINALIZOUJOB NFS - 13")
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOBS13_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        MemoWrite(cDirLog + cArqLog, cLog)
    endif

Return

User Function JOBSAI14()
    Local cQueryTab := ""
    Local aRetGrv   := {}
    Local aArea     := FWGetArea()
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    conout("INICIANDO JOBSAI 14")
    RPCSetEnv("01", "14")
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZF") + " ZZF " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZF.D_E_L_E_T_ = '' AND ZZF_STATUS = '0' " + CRLF
    cQueryTab += "     AND ZZF_FILIAL IN ('14')  AND ZZF_VALOR > 0 " + CRLF
    cQueryTab += "     ORDER BY ZZF_VALOR DESC " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    nConte := 0
    WHILE !(QRY_TAB->(EOF()))

        nConte++
        conout("LACO JOBSAI - 14 " + QRY_TAB->ZZF_ZEXTID)

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(QRY_TAB->ZZF_GRUPO),  "01", QRY_TAB->ZZF_GRUPO)
        cFilAt   := Iif(EMPTY(QRY_TAB->ZZF_FILIAL), "14", QRY_TAB->ZZF_FILIAL)

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
    CONOUT("FINALIZOUJOB NFS - 14")
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOBS14_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        MemoWrite(cDirLog + cArqLog, cLog)
    endif

Return

User Function JOBSAI15()
    Local cQueryTab := ""
    Local aRetGrv   := {}
    Local aArea     := FWGetArea()
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    conout("INICIANDO JOBSAI 15")
    RPCSetEnv("01", "15")
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZF") + " ZZF " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZF.D_E_L_E_T_ = '' AND ZZF_STATUS = '0' " + CRLF
    cQueryTab += "     AND ZZF_FILIAL IN ('15')  AND ZZF_VALOR > 0 " + CRLF
    cQueryTab += "     ORDER BY ZZF_VALOR DESC " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    nConte := 0
    WHILE !(QRY_TAB->(EOF()))

        nConte++
        conout("LACO JOBSAI - 15 " + QRY_TAB->ZZF_ZEXTID)

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(QRY_TAB->ZZF_GRUPO),  "01", QRY_TAB->ZZF_GRUPO)
        cFilAt   := Iif(EMPTY(QRY_TAB->ZZF_FILIAL), "15", QRY_TAB->ZZF_FILIAL)

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
    CONOUT("FINALIZOUJOB NFS - 15")
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOBS15_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        MemoWrite(cDirLog + cArqLog, cLog)
    endif

Return

User Function JOBSAI16()
    Local cQueryTab := ""
    Local aRetGrv   := {}
    Local aArea     := FWGetArea()
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    conout("INICIANDO JOBSAI 16")
    RPCSetEnv("01", "16")
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZF") + " ZZF " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZF.D_E_L_E_T_ = '' AND ZZF_STATUS = '0' " + CRLF
    cQueryTab += "     AND ZZF_FILIAL IN ('16')  AND ZZF_VALOR > 0 " + CRLF
    cQueryTab += "     ORDER BY ZZF_VALOR DESC " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    nConte := 0
    WHILE !(QRY_TAB->(EOF()))

        nConte++
        conout("LACO JOBSAI - 16 " + QRY_TAB->ZZF_ZEXTID)

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(QRY_TAB->ZZF_GRUPO),  "01", QRY_TAB->ZZF_GRUPO)
        cFilAt   := Iif(EMPTY(QRY_TAB->ZZF_FILIAL), "16", QRY_TAB->ZZF_FILIAL)

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
    CONOUT("FINALIZOUJOB NFS - 16")
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOBS16_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        MemoWrite(cDirLog + cArqLog, cLog)
    endif

Return

User Function JOBSAI17()
    Local cQueryTab := ""
    Local aRetGrv   := {}
    Local aArea     := FWGetArea()
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    conout("INICIANDO JOBSAI 17")
    RPCSetEnv("01", "17")
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZF") + " ZZF " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZF.D_E_L_E_T_ = '' AND ZZF_STATUS = '0' " + CRLF
    cQueryTab += "     AND ZZF_FILIAL IN ('17')  AND ZZF_VALOR > 0 " + CRLF
    cQueryTab += "     ORDER BY ZZF_VALOR DESC " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    nConte := 0
    WHILE !(QRY_TAB->(EOF()))

        nConte++
        conout("LACO JOBSAI - 17 " + QRY_TAB->ZZF_ZEXTID)

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(QRY_TAB->ZZF_GRUPO),  "01", QRY_TAB->ZZF_GRUPO)
        cFilAt   := Iif(EMPTY(QRY_TAB->ZZF_FILIAL), "17", QRY_TAB->ZZF_FILIAL)

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
    CONOUT("FINALIZOUJOB NFS - 17")
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOBS17_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        MemoWrite(cDirLog + cArqLog, cLog)
    endif

Return

User Function JOBSAI18()
    Local cQueryTab := ""
    Local aRetGrv   := {}
    Local aArea     := FWGetArea()
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    conout("INICIANDO JOBSAI 18")
    RPCSetEnv("01", "18")
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZF") + " ZZF " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZF.D_E_L_E_T_ = '' AND ZZF_STATUS = '0' " + CRLF
    cQueryTab += "     AND ZZF_FILIAL IN ('18')  AND ZZF_VALOR > 0 " + CRLF
    cQueryTab += "     ORDER BY ZZF_VALOR DESC " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    nConte := 0
    WHILE !(QRY_TAB->(EOF()))

        nConte++
        conout("LACO JOBSAI - 18 " + QRY_TAB->ZZF_ZEXTID)

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(QRY_TAB->ZZF_GRUPO),  "01", QRY_TAB->ZZF_GRUPO)
        cFilAt   := Iif(EMPTY(QRY_TAB->ZZF_FILIAL), "18", QRY_TAB->ZZF_FILIAL)

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
    CONOUT("FINALIZOUJOB NFS - 18")
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOBS18_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        MemoWrite(cDirLog + cArqLog, cLog)
    endif

Return

User Function JOBSAI19()
    Local cQueryTab := ""
    Local aRetGrv   := {}
    Local aArea     := FWGetArea()
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    conout("INICIANDO JOBSAI 19")
    //PREPARE ENVIRONMENT EMPRESA "01" FILIAL "04" MODULO 'FAT'
    RPCSetEnv("01", "19")
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZF") + " ZZF " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZF.D_E_L_E_T_ = '' AND ZZF_STATUS = '0' " + CRLF
    cQueryTab += "     AND ZZF_FILIAL IN ('19')  AND ZZF_VALOR > 0 " + CRLF
    cQueryTab += "     ORDER BY ZZF_VALOR DESC " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    nConte := 0
    WHILE !(QRY_TAB->(EOF()))

        nConte++
        conout("LACO JOBSAI - 19 " + QRY_TAB->ZZF_ZEXTID)

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(QRY_TAB->ZZF_GRUPO),  "01", QRY_TAB->ZZF_GRUPO)
        cFilAt   := Iif(EMPTY(QRY_TAB->ZZF_FILIAL), "19", QRY_TAB->ZZF_FILIAL)

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
    CONOUT("FINALIZOUJOB NFS - 19")
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOBS19_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        MemoWrite(cDirLog + cArqLog, cLog)
    endif

Return

User Function JOBSAI20()
    Local cQueryTab := ""
    Local aRetGrv   := {}
    Local aArea     := FWGetArea()
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'    

    conout("INICIANDO JOBSAI 20")
    RPCSetEnv("01", "20")
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZF") + " ZZF " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZF.D_E_L_E_T_ = '' AND ZZF_STATUS = '0' " + CRLF
    cQueryTab += "     AND ZZF_FILIAL IN ('20')  AND ZZF_VALOR > 0 " + CRLF
    cQueryTab += "     ORDER BY ZZF_VALOR DESC " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    nConte := 0
    WHILE !(QRY_TAB->(EOF()))

        nConte++
        conout("LACO JOBSAI - 20 " + QRY_TAB->ZZF_ZEXTID)

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(QRY_TAB->ZZF_GRUPO),  "01", QRY_TAB->ZZF_GRUPO)
        cFilAt   := Iif(EMPTY(QRY_TAB->ZZF_FILIAL), "20", QRY_TAB->ZZF_FILIAL)

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
    CONOUT("FINALIZOUJOB NFS - 20")
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOBS20_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        MemoWrite(cDirLog + cArqLog, cLog)
    endif

Return

// FINAL DA SAIDA \\
//---------------------\\
// INICIO DA ENTRADA \\

User Function JOBENT01()
    Local cQueryTab := ""
    Local nConte    := 0
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    //PREPARE ENVIRONMENT EMPRESA '01' FILIAL '12' MODULO 'EST'
    RPCSetEnv("01", "01")

    conout("INICIANDO JOBENTRADA 01" )
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZE") + " ZZE " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZE.D_E_L_E_T_ = '' AND ZZE_STATUS IN ('9', '0') " + CRLF
    cQueryTab += "     AND ZZE_FILIAL IN ('01') " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    nConte := 0
    WHILE !(QRY_TAB->(EOF()))
        nResult := Val(substr(Time(),1,2))
        nConte++
        conout("LACO JOBNFE - 01 " + QRY_TAB->ZZE_ZEXTID)

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
        
        IF !lTemFor
            oWS:GRAVALOGZZE(nRecn, cExter, "FORNECEDOR NÃO EXISTE", "WSNFE", "INCLUSÃO DE Nota Fiscal de Entrada")
            cLog += "JOB 12 Documento: " + cDoc + " - ExtId: " + cExter + " Erro Cad Fornecedor " + CRLF
        EndIF

        alTemExtr := ows:PGExtDad(cEnum + cExter) 
        IF len(alTemExtr) == 0  //Verifica se tem ExternoID - Numero do Pedido Externo
            oWS:GRAVALOGZZE(nRecn, cExter, "PEDIDO DE COMPRAS NAO EXISTE", "WSNFE", "INCLUSÃO DE Nota Fiscal de Entrada")
            cLog += "JOB 01 Documento: " + cDoc + " - ExtId: " + cExter + " PEDIDO DE COMPRAS NÃO EXISTE " + CRLF
        EndIF
        
        aRetGrv := oWS:GerNFE( cExter, cChavNfe, 3, dAltVct, cDoc, cSeri, cEnum, (cEnum + cExter))  //17/11/2025 - ajustado - //oWS:DGerNFE( jJson:GetJsonObject("IDPEDCOMPREXT"), jJson:GetJsonObject("CHVNFE"), 3) 
        If len(aRetGrv) > 0 
            cErrorLog   := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO
            oWS:GRAVALOGZZE(nRecn, cExter, cErrorLog, "WSNFE", "ERRO NA INCLUSAO")
            cLog += "JOB 01 Documento: " + cDoc + " - ExtId: " + cExter + " Erro na Gravacao da NFE  - " + cErrorLog + CRLF
        Else
            oWS:mudaSts(nRecn, cExter, "1")
        EndIf
        cEmpAnt  := cEmpAt1
        cFilAnt  := cFilAt1

        QRY_TAB->(dbSkip())
        LOOP
    ENDDO	
    QRY_TAB->(DBCLOSEAREA())
    conout("FINALIZOU JOBNFE - 01")
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOB01_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        MemoWrite(cDirLog + cArqLog, cLog)
    endif

    ConOut(OemToAnsi("Fim : ")+Time())

Return

User Function JOBENT02()
    Local cQueryTab := ""
    Local nConte    := 0
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    //PREPARE ENVIRONMENT EMPRESA '01' FILIAL '12' MODULO 'EST'
    RPCSetEnv("01", "02")

    conout("INICIANDO JOBENTRADA 02" )
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZE") + " ZZE " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZE.D_E_L_E_T_ = '' AND ZZE_STATUS IN ('9', '0') " + CRLF
    cQueryTab += "     AND ZZE_FILIAL IN ('02') " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    nConte := 0
    WHILE !(QRY_TAB->(EOF()))
        nResult := Val(substr(Time(),1,2))
        nConte++
        conout("LACO JOBNFE - 02 " + QRY_TAB->ZZE_ZEXTID)

        _CNPJCPF:= IIF(EMPTY(QRY_TAB->ZZE_CNPJFO), Substr( QRY_TAB->ZZE_CHVNF,7, 14), QRY_TAB->ZZE_CNPJFO)
        lTemFor := ows:temFornec(FWxFilial("SA2"), _CNPJCPF)

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(QRY_TAB->ZZE_GRUPO),  "01", QRY_TAB->ZZE_GRUPO)
        cFilAt   := Iif(EMPTY(QRY_TAB->ZZE_FILIAL), "02", QRY_TAB->ZZE_FILIAL)

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
            cLog += "JOB 02 Documento: " + cDoc + " - ExtId: " + cExter + " Erro Cad Fornecedor " + CRLF
        EndIF

        alTemExtr := ows:PGExtDad(cEnum + cExter) 
        IF len(alTemExtr) == 0  //Verifica se tem ExternoID - Numero do Pedido Externo
            oWS:GRAVALOGZZE(nRecn, cExter, "PEDIDO DE COMPRAS NAO EXISTE", "WSNFE", "INCLUSÃO DE Nota Fiscal de Entrada")
            cLog += "JOB 02 Documento: " + cDoc + " - ExtId: " + cExter + " PEDIDO DE COMPRAS NÃO EXISTE " + CRLF
        EndIF
        
        aRetGrv := oWS:GerNFE( cExter, cChavNfe, 3, dAltVct, cDoc, cSeri, cEnum, (cEnum + cExter))  //17/11/2025 - ajustado - //oWS:DGerNFE( jJson:GetJsonObject("IDPEDCOMPREXT"), jJson:GetJsonObject("CHVNFE"), 3) 
        If len(aRetGrv) > 0 
            cErrorLog   := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO
            oWS:GRAVALOGZZE(nRecn, cExter, cErrorLog, "WSNFE", "INCLUSÃO DE Nota Fiscal de Entrada")
            cLog += "JOB 02 Documento: " + cDoc + " - ExtId: " + cExter + " Erro na Gravacao da NFE  - " + cErrorLog + CRLF
        Else
            oWS:mudaSts(nRecn, cExter, "1")
        EndIf
        cEmpAnt  := cEmpAt1
        cFilAnt  := cFilAt1

        QRY_TAB->(dbSkip())
        LOOP
    ENDDO	
    QRY_TAB->(DBCLOSEAREA())
    conout("FINALIZOU JOBNFE - 02")
    //RESET ENVIRONMENT
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOB02_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        MemoWrite(cDirLog + cArqLog, cLog)
    Endif

    ConOut(OemToAnsi("Fim : ")+Time())

Return

User Function JOBENT03()
    Local cQueryTab := ""
    Local nConte    := 0
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    //PREPARE ENVIRONMENT EMPRESA '01' FILIAL '12' MODULO 'EST'
    RPCSetEnv("01", "03")

    conout("INICIANDO JOBENTRADA 03" )
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZE") + " ZZE " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZE.D_E_L_E_T_ = '' AND ZZE_STATUS IN ('9', '0') " + CRLF
    cQueryTab += "     AND ZZE_FILIAL IN ('03') " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    nConte := 0
    WHILE !(QRY_TAB->(EOF()))
        nResult := Val(substr(Time(),1,2))
        nConte++
        conout("LACO JOBNFE - 03 " + QRY_TAB->ZZE_ZEXTID)

        _CNPJCPF:= IIF(EMPTY(QRY_TAB->ZZE_CNPJFO), Substr( QRY_TAB->ZZE_CHVNF,7, 14), QRY_TAB->ZZE_CNPJFO)
        lTemFor := ows:temFornec(FWxFilial("SA2"), _CNPJCPF)

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(QRY_TAB->ZZE_GRUPO),  "01", QRY_TAB->ZZE_GRUPO)
        cFilAt   := Iif(EMPTY(QRY_TAB->ZZE_FILIAL), "03", QRY_TAB->ZZE_FILIAL)

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
            cLog += "JOB 03 Documento: " + cDoc + " - ExtId: " + cExter + " Erro Cad Fornecedor " + CRLF
        EndIF

        alTemExtr := ows:PGExtDad(cEnum + cExter) 
        IF len(alTemExtr) == 0  //Verifica se tem ExternoID - Numero do Pedido Externo
            oWS:GRAVALOGZZE(nRecn, cExter, "PEDIDO DE COMPRAS NAO EXISTE", "WSNFE", "INCLUSÃO DE Nota Fiscal de Entrada")
            cLog += "JOB 03 Documento: " + cDoc + " - ExtId: " + cExter + " PEDIDO DE COMPRAS NÃO EXISTE " + CRLF
        EndIF
        
        aRetGrv := oWS:GerNFE( cExter, cChavNfe, 3, dAltVct, cDoc, cSeri, cEnum, (cEnum + cExter))  //17/11/2025 - ajustado - //oWS:DGerNFE( jJson:GetJsonObject("IDPEDCOMPREXT"), jJson:GetJsonObject("CHVNFE"), 3) 
        If len(aRetGrv) > 0 
            cErrorLog   := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO
            oWS:GRAVALOGZZE(nRecn, cExter, cErrorLog, "WSNFE", "INCLUSÃO DE Nota Fiscal de Entrada")
            cLog += "JOB 03 Documento: " + cDoc + " - ExtId: " + cExter + " Erro na Gravacao da NFE  - " + cErrorLog + CRLF
        Else
            oWS:mudaSts(nRecn, cExter, "1")
        EndIf
        cEmpAnt  := cEmpAt1
        cFilAnt  := cFilAt1

        QRY_TAB->(dbSkip())
        LOOP
    ENDDO	
    QRY_TAB->(DBCLOSEAREA())
    conout("FINALIZOU JOBNFE - 03")
    //RESET ENVIRONMENT
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOB03_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        MemoWrite(cDirLog + cArqLog, cLog)
    Endif

    ConOut(OemToAnsi("Fim : ")+Time())

Return

User Function JOBENT04()
    Local cQueryTab := ""
    Local nConte    := 0
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    //PREPARE ENVIRONMENT EMPRESA '01' FILIAL '12' MODULO 'EST'
    RPCSetEnv("01", "04")

    conout("INICIANDO JOBENTRADA 04" )
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZE") + " ZZE " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZE.D_E_L_E_T_ = '' AND ZZE_STATUS IN ('9', '0') " + CRLF
    cQueryTab += "     AND ZZE_FILIAL IN ('04') " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    nConte := 0
    WHILE !(QRY_TAB->(EOF()))
        nResult := Val(substr(Time(),1,2))
        nConte++
        conout("LACO JOBNFE - 04 " + QRY_TAB->ZZE_ZEXTID)

        _CNPJCPF:= IIF(EMPTY(QRY_TAB->ZZE_CNPJFO), Substr( QRY_TAB->ZZE_CHVNF,7, 14), QRY_TAB->ZZE_CNPJFO)
        lTemFor := ows:temFornec(FWxFilial("SA2"), _CNPJCPF)

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(QRY_TAB->ZZE_GRUPO),  "01", QRY_TAB->ZZE_GRUPO)
        cFilAt   := Iif(EMPTY(QRY_TAB->ZZE_FILIAL), "04", QRY_TAB->ZZE_FILIAL)

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
            cLog += "JOB 04 Documento: " + cDoc + " - ExtId: " + cExter + " Erro Cad Fornecedor " + CRLF
        EndIF

        alTemExtr := ows:PGExtDad(cEnum + cExter) 
        IF len(alTemExtr) == 0  //Verifica se tem ExternoID - Numero do Pedido Externo
            oWS:GRAVALOGZZE(nRecn, cExter, "PEDIDO DE COMPRAS NAO EXISTE", "WSNFE", "INCLUSÃO DE Nota Fiscal de Entrada")
            cLog += "JOB 04 Documento: " + cDoc + " - ExtId: " + cExter + " PEDIDO DE COMPRAS NÃO EXISTE " + CRLF
        EndIF
        
        aRetGrv := oWS:GerNFE( cExter, cChavNfe, 3, dAltVct, cDoc, cSeri, cEnum, (cEnum + cExter))  //17/11/2025 - ajustado - //oWS:DGerNFE( jJson:GetJsonObject("IDPEDCOMPREXT"), jJson:GetJsonObject("CHVNFE"), 3) 
        If len(aRetGrv) > 0 
            cErrorLog   := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO
            oWS:GRAVALOGZZE(nRecn, cExter, cErrorLog, "WSNFE", "INCLUSÃO DE Nota Fiscal de Entrada")
            cLog += "JOB 04 Documento: " + cDoc + " - ExtId: " + cExter + " Erro na Gravacao da NFE  - " + cErrorLog + CRLF
        Else
            oWS:mudaSts(nRecn, cExter, "1")
        EndIf
        cEmpAnt  := cEmpAt1
        cFilAnt  := cFilAt1

        QRY_TAB->(dbSkip())
        LOOP
    ENDDO	
    QRY_TAB->(DBCLOSEAREA())
    conout("FINALIZOU JOBNFE - 04")
    //RESET ENVIRONMENT
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOB04_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        MemoWrite(cDirLog + cArqLog, cLog)
    EndIF
    ConOut(OemToAnsi("Fim : ")+Time())

Return

User Function JOBENT05()
    Local cQueryTab := ""
    Local nConte    := 0
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    //PREPARE ENVIRONMENT EMPRESA '01' FILIAL '12' MODULO 'EST'
    RPCSetEnv("01", "05")

    conout("INICIANDO JOBENTRADA 05" )
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZE") + " ZZE " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZE.D_E_L_E_T_ = '' AND ZZE_STATUS IN ('9', '0') " + CRLF
    cQueryTab += "     AND ZZE_FILIAL IN ('05') " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    nConte := 0
    WHILE !(QRY_TAB->(EOF()))
        nResult := Val(substr(Time(),1,2))
        nConte++
        conout("LACO JOBNFE - 05 " + QRY_TAB->ZZE_ZEXTID)

        _CNPJCPF:= IIF(EMPTY(QRY_TAB->ZZE_CNPJFO), Substr( QRY_TAB->ZZE_CHVNF,7, 14), QRY_TAB->ZZE_CNPJFO)
        lTemFor := ows:temFornec(FWxFilial("SA2"), _CNPJCPF)

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(QRY_TAB->ZZE_GRUPO),  "01", QRY_TAB->ZZE_GRUPO)
        cFilAt   := Iif(EMPTY(QRY_TAB->ZZE_FILIAL), "05", QRY_TAB->ZZE_FILIAL)

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
            cLog += "JOB 05 Documento: " + cDoc + " - ExtId: " + cExter + " Erro Cad Fornecedor " + CRLF
        EndIF

        alTemExtr := ows:PGExtDad(cEnum + cExter) 
        IF len(alTemExtr) == 0  //Verifica se tem ExternoID - Numero do Pedido Externo
            oWS:GRAVALOGZZE(nRecn, cExter, "PEDIDO DE COMPRAS NAO EXISTE", "WSNFE", "INCLUSÃO DE Nota Fiscal de Entrada")
            cLog += "JOB 05 Documento: " + cDoc + " - ExtId: " + cExter + " PEDIDO DE COMPRAS NÃO EXISTE " + CRLF
        EndIF
        
        aRetGrv := oWS:GerNFE( cExter, cChavNfe, 3, dAltVct, cDoc, cSeri, cEnum, (cEnum + cExter))  //17/11/2025 - ajustado - //oWS:DGerNFE( jJson:GetJsonObject("IDPEDCOMPREXT"), jJson:GetJsonObject("CHVNFE"), 3) 
        If len(aRetGrv) > 0 
            cErrorLog   := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO
            oWS:GRAVALOGZZE(nRecn, cExter, cErrorLog, "WSNFE", "INCLUSÃO DE Nota Fiscal de Entrada")
            cLog += "JOB 05 Documento: " + cDoc + " - ExtId: " + cExter + " Erro na Gravacao da NFE  - " + cErrorLog + CRLF
        Else
            oWS:mudaSts(nRecn, cExter, "1")
        EndIf
        cEmpAnt  := cEmpAt1
        cFilAnt  := cFilAt1

        QRY_TAB->(dbSkip())
        LOOP
    ENDDO	
    QRY_TAB->(DBCLOSEAREA())
    conout("FINALIZOU JOBNFE - 05")
    //RESET ENVIRONMENT
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOB05_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        MemoWrite(cDirLog + cArqLog, cLog)
    EndIF
    ConOut(OemToAnsi("Fim : ")+Time())

Return

User Function JOBENT06()
    Local cQueryTab := ""
    Local nConte    := 0
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    //PREPARE ENVIRONMENT EMPRESA '01' FILIAL '12' MODULO 'EST'
    RPCSetEnv("01", "06")

    conout("INICIANDO JOBENTRADA 06" )
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZE") + " ZZE " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZE.D_E_L_E_T_ = '' AND ZZE_STATUS IN ('9', '0') " + CRLF
    cQueryTab += "     AND ZZE_FILIAL IN ('06') " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    nConte := 0
    WHILE !(QRY_TAB->(EOF()))
        nResult := Val(substr(Time(),1,2))
        nConte++
        conout("LACO JOBNFE - 06 " + QRY_TAB->ZZE_ZEXTID)

        _CNPJCPF:= IIF(EMPTY(QRY_TAB->ZZE_CNPJFO), Substr( QRY_TAB->ZZE_CHVNF,7, 14), QRY_TAB->ZZE_CNPJFO)
        lTemFor := ows:temFornec(FWxFilial("SA2"), _CNPJCPF)

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(QRY_TAB->ZZE_GRUPO),  "01", QRY_TAB->ZZE_GRUPO)
        cFilAt   := Iif(EMPTY(QRY_TAB->ZZE_FILIAL), "06", QRY_TAB->ZZE_FILIAL)

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
            cLog += "JOB 06 Documento: " + cDoc + " - ExtId: " + cExter + " Erro Cad Fornecedor " + CRLF
        EndIF

        alTemExtr := ows:PGExtDad(cEnum + cExter) 
        IF len(alTemExtr) == 0  //Verifica se tem ExternoID - Numero do Pedido Externo
            oWS:GRAVALOGZZE(nRecn, cExter, "PEDIDO DE COMPRAS NAO EXISTE", "WSNFE", "INCLUSÃO DE Nota Fiscal de Entrada")
            cLog += "JOB 06 Documento: " + cDoc + " - ExtId: " + cExter + " PEDIDO DE COMPRAS NÃO EXISTE " + CRLF
        EndIF
        
        aRetGrv := oWS:GerNFE( cExter, cChavNfe, 3, dAltVct, cDoc, cSeri, cEnum, (cEnum + cExter))  //17/11/2025 - ajustado - //oWS:DGerNFE( jJson:GetJsonObject("IDPEDCOMPREXT"), jJson:GetJsonObject("CHVNFE"), 3) 
        If len(aRetGrv) > 0 
            cErrorLog   := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO
            oWS:GRAVALOGZZE(nRecn, cExter, cErrorLog, "WSNFE", "INCLUSÃO DE Nota Fiscal de Entrada")
            cLog += "JOB 06 Documento: " + cDoc + " - ExtId: " + cExter + " Erro na Gravacao da NFE  - " + cErrorLog + CRLF
        Else
            oWS:mudaSts(nRecn, cExter, "1")
        EndIf
        cEmpAnt  := cEmpAt1
        cFilAnt  := cFilAt1

        QRY_TAB->(dbSkip())
        LOOP
    ENDDO	
    QRY_TAB->(DBCLOSEAREA())
    conout("FINALIZOU JOBNFE - 06")
    //RESET ENVIRONMENT
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOB06_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        MemoWrite(cDirLog + cArqLog, cLog)
    EndIF
    ConOut(OemToAnsi("Fim : ")+Time())

Return

User Function JOBENT07()
    Local cQueryTab := ""
    Local nConte    := 0
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    //PREPARE ENVIRONMENT EMPRESA '01' FILIAL '12' MODULO 'EST'
    RPCSetEnv("01", "07")

    conout("INICIANDO JOBENTRADA 07" )
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZE") + " ZZE " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZE.D_E_L_E_T_ = '' AND ZZE_STATUS IN ('9', '0') " + CRLF
    cQueryTab += "     AND ZZE_FILIAL IN ('07') " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    nConte := 0
    WHILE !(QRY_TAB->(EOF()))
        nResult := Val(substr(Time(),1,2))
        nConte++
        conout("LACO JOBNFE - 07 " + QRY_TAB->ZZE_ZEXTID)

        _CNPJCPF:= IIF(EMPTY(QRY_TAB->ZZE_CNPJFO), Substr( QRY_TAB->ZZE_CHVNF,7, 14), QRY_TAB->ZZE_CNPJFO)
        lTemFor := ows:temFornec(FWxFilial("SA2"), _CNPJCPF)

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(QRY_TAB->ZZE_GRUPO),  "01", QRY_TAB->ZZE_GRUPO)
        cFilAt   := Iif(EMPTY(QRY_TAB->ZZE_FILIAL), "07", QRY_TAB->ZZE_FILIAL)

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
            cLog += "JOB 07 Documento: " + cDoc + " - ExtId: " + cExter + " Erro Cad Fornecedor " + CRLF
        EndIF

        alTemExtr := ows:PGExtDad(cEnum + cExter) 
        IF len(alTemExtr) == 0  //Verifica se tem ExternoID - Numero do Pedido Externo
            oWS:GRAVALOGZZE(nRecn, cExter, "PEDIDO DE COMPRAS NAO EXISTE", "WSNFE", "INCLUSÃO DE Nota Fiscal de Entrada")
            cLog += "JOB 07 Documento: " + cDoc + " - ExtId: " + cExter + " PEDIDO DE COMPRAS NÃO EXISTE " + CRLF
        EndIF
        
        aRetGrv := oWS:GerNFE( cExter, cChavNfe, 3, dAltVct, cDoc, cSeri, cEnum, (cEnum + cExter))  //17/11/2025 - ajustado - //oWS:DGerNFE( jJson:GetJsonObject("IDPEDCOMPREXT"), jJson:GetJsonObject("CHVNFE"), 3) 
        If len(aRetGrv) > 0 
            cErrorLog   := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO
            oWS:GRAVALOGZZE(nRecn, cExter, cErrorLog, "WSNFE", "INCLUSÃO DE Nota Fiscal de Entrada")
            cLog += "JOB 07 Documento: " + cDoc + " - ExtId: " + cExter + " Erro na Gravacao da NFE  - " + cErrorLog + CRLF
        Else
            oWS:mudaSts(nRecn, cExter, "1")
        EndIf
        cEmpAnt  := cEmpAt1
        cFilAnt  := cFilAt1

        QRY_TAB->(dbSkip())
        LOOP
    ENDDO	
    QRY_TAB->(DBCLOSEAREA())
    conout("FINALIZOU JOBNFE - 07")
    //RESET ENVIRONMENT
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOB07_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        MemoWrite(cDirLog + cArqLog, cLog)
    EndIF
    ConOut(OemToAnsi("Fim : ")+Time())

Return

User Function JOBENT08()
    Local cQueryTab := ""
    Local nConte    := 0
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    //PREPARE ENVIRONMENT EMPRESA '01' FILIAL '12' MODULO 'EST'
    RPCSetEnv("01", "08")

    conout("INICIANDO JOBENTRADA 08" )
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZE") + " ZZE " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZE.D_E_L_E_T_ = '' AND ZZE_STATUS IN ('9', '0') " + CRLF
    cQueryTab += "     AND ZZE_FILIAL IN ('08') " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    nConte := 0
    WHILE !(QRY_TAB->(EOF()))
        nResult := Val(substr(Time(),1,2))
        nConte++
        conout("LACO JOBNFE - 08 " + QRY_TAB->ZZE_ZEXTID)

        _CNPJCPF:= IIF(EMPTY(QRY_TAB->ZZE_CNPJFO), Substr( QRY_TAB->ZZE_CHVNF,7, 14), QRY_TAB->ZZE_CNPJFO)
        lTemFor := ows:temFornec(FWxFilial("SA2"), _CNPJCPF)

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(QRY_TAB->ZZE_GRUPO),  "01", QRY_TAB->ZZE_GRUPO)
        cFilAt   := Iif(EMPTY(QRY_TAB->ZZE_FILIAL), "08", QRY_TAB->ZZE_FILIAL)

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
            cLog += "JOB 08 Documento: " + cDoc + " - ExtId: " + cExter + " Erro Cad Fornecedor " + CRLF
        EndIF

        alTemExtr := ows:PGExtDad(cEnum + cExter) 
        IF len(alTemExtr) == 0  //Verifica se tem ExternoID - Numero do Pedido Externo
            oWS:GRAVALOGZZE(nRecn, cExter, "PEDIDO DE COMPRAS NAO EXISTE", "WSNFE", "INCLUSÃO DE Nota Fiscal de Entrada")
            cLog += "JOB 08 Documento: " + cDoc + " - ExtId: " + cExter + " PEDIDO DE COMPRAS NÃO EXISTE " + CRLF
        EndIF
        
        aRetGrv := oWS:GerNFE( cExter, cChavNfe, 3, dAltVct, cDoc, cSeri, cEnum, (cEnum + cExter))  //17/11/2025 - ajustado - //oWS:DGerNFE( jJson:GetJsonObject("IDPEDCOMPREXT"), jJson:GetJsonObject("CHVNFE"), 3) 
        If len(aRetGrv) > 0 
            cErrorLog   := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO
            oWS:GRAVALOGZZE(nRecn, cExter, cErrorLog, "WSNFE", "INCLUSÃO DE Nota Fiscal de Entrada")
            cLog += "JOB 08 Documento: " + cDoc + " - ExtId: " + cExter + " Erro na Gravacao da NFE  - " + cErrorLog + CRLF
        Else
            oWS:mudaSts(nRecn, cExter, "1")
        EndIf
        cEmpAnt  := cEmpAt1
        cFilAnt  := cFilAt1

        QRY_TAB->(dbSkip())
        LOOP
    ENDDO	
    QRY_TAB->(DBCLOSEAREA())
    conout("FINALIZOU JOBNFE - 08")
    //RESET ENVIRONMENT
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOB08_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        MemoWrite(cDirLog + cArqLog, cLog)
    EndiF

    ConOut(OemToAnsi("Fim : ")+Time())

Return

User Function JOBENT09()
    Local cQueryTab := ""
    Local nConte    := 0
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    //PREPARE ENVIRONMENT EMPRESA '01' FILIAL '12' MODULO 'EST'
    RPCSetEnv("01", "09")

    conout("INICIANDO JOBENTRADA 09" )
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZE") + " ZZE " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZE.D_E_L_E_T_ = '' AND ZZE_STATUS IN ('9', '0') " + CRLF
    cQueryTab += "     AND ZZE_FILIAL IN ('09') " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    nConte := 0
    WHILE !(QRY_TAB->(EOF()))
        nResult := Val(substr(Time(),1,2))
        nConte++
        conout("LACO JOBNFE - 09 " + QRY_TAB->ZZE_ZEXTID)

        _CNPJCPF:= IIF(EMPTY(QRY_TAB->ZZE_CNPJFO), Substr( QRY_TAB->ZZE_CHVNF,7, 14), QRY_TAB->ZZE_CNPJFO)
        lTemFor := ows:temFornec(FWxFilial("SA2"), _CNPJCPF)

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(QRY_TAB->ZZE_GRUPO),  "01", QRY_TAB->ZZE_GRUPO)
        cFilAt   := Iif(EMPTY(QRY_TAB->ZZE_FILIAL), "09", QRY_TAB->ZZE_FILIAL)

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
            cLog += "JOB 09 Documento: " + cDoc + " - ExtId: " + cExter + " Erro Cad Fornecedor " + CRLF
        EndIF

        alTemExtr := ows:PGExtDad(cEnum + cExter) 
        IF len(alTemExtr) == 0  //Verifica se tem ExternoID - Numero do Pedido Externo
            oWS:GRAVALOGZZE(nRecn, cExter, "PEDIDO DE COMPRAS NAO EXISTE", "WSNFE", "INCLUSÃO DE Nota Fiscal de Entrada")
            cLog += "JOB 09 Documento: " + cDoc + " - ExtId: " + cExter + " PEDIDO DE COMPRAS NÃO EXISTE " + CRLF
        EndIF
        
        aRetGrv := oWS:GerNFE( cExter, cChavNfe, 3, dAltVct, cDoc, cSeri, cEnum, (cEnum + cExter))  //17/11/2025 - ajustado - //oWS:DGerNFE( jJson:GetJsonObject("IDPEDCOMPREXT"), jJson:GetJsonObject("CHVNFE"), 3) 
        If len(aRetGrv) > 0 
            cErrorLog   := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO
            oWS:GRAVALOGZZE(nRecn, cExter, cErrorLog, "WSNFE", "INCLUSÃO DE Nota Fiscal de Entrada")
            cLog += "JOB 09 Documento: " + cDoc + " - ExtId: " + cExter + " Erro na Gravacao da NFE  - " + cErrorLog + CRLF
        Else
            oWS:mudaSts(nRecn, cExter, "1")
        EndIf
        cEmpAnt  := cEmpAt1
        cFilAnt  := cFilAt1

        QRY_TAB->(dbSkip())
        LOOP
    ENDDO	
    QRY_TAB->(DBCLOSEAREA())
    conout("FINALIZOU JOBNFE - 09")
    //RESET ENVIRONMENT
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOB09_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        MemoWrite(cDirLog + cArqLog, cLog)
    EndiF
    ConOut(OemToAnsi("Fim : ")+Time())

Return

User Function JOBENT10()
    Local cQueryTab := ""
    Local nConte    := 0
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    //PREPARE ENVIRONMENT EMPRESA '01' FILIAL '12' MODULO 'EST'
    RPCSetEnv("01", "10")

    conout("INICIANDO JOBENTRADA 10" )
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZE") + " ZZE " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZE.D_E_L_E_T_ = '' AND ZZE_STATUS IN ('9', '0') " + CRLF
    cQueryTab += "     AND ZZE_FILIAL IN ('10') " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    nConte := 0
    WHILE !(QRY_TAB->(EOF()))
        nResult := Val(substr(Time(),1,2))
        nConte++
        conout("LACO JOBNFE - 10 " + QRY_TAB->ZZE_ZEXTID)

        _CNPJCPF:= IIF(EMPTY(QRY_TAB->ZZE_CNPJFO), Substr( QRY_TAB->ZZE_CHVNF,7, 14), QRY_TAB->ZZE_CNPJFO)
        lTemFor := ows:temFornec(FWxFilial("SA2"), _CNPJCPF)

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(QRY_TAB->ZZE_GRUPO),  "01", QRY_TAB->ZZE_GRUPO)
        cFilAt   := Iif(EMPTY(QRY_TAB->ZZE_FILIAL), "10", QRY_TAB->ZZE_FILIAL)

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
            cLog += "JOB 10 Documento: " + cDoc + " - ExtId: " + cExter + " Erro Cad Fornecedor " + CRLF
        EndIF

        alTemExtr := ows:PGExtDad(cEnum + cExter) 
        IF len(alTemExtr) == 0  //Verifica se tem ExternoID - Numero do Pedido Externo
            oWS:GRAVALOGZZE(nRecn, cExter, "PEDIDO DE COMPRAS NAO EXISTE", "WSNFE", "INCLUSÃO DE Nota Fiscal de Entrada")
            cLog += "JOB 10 Documento: " + cDoc + " - ExtId: " + cExter + " PEDIDO DE COMPRAS NÃO EXISTE " + CRLF
        EndIF
        
        aRetGrv := oWS:GerNFE( cExter, cChavNfe, 3, dAltVct, cDoc, cSeri, cEnum, (cEnum + cExter))  //17/11/2025 - ajustado - //oWS:DGerNFE( jJson:GetJsonObject("IDPEDCOMPREXT"), jJson:GetJsonObject("CHVNFE"), 3) 
        If len(aRetGrv) > 0 
            cErrorLog   := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO
            oWS:GRAVALOGZZE(nRecn, cExter, cErrorLog, "WSNFE", "INCLUSÃO DE Nota Fiscal de Entrada")
            cLog += "JOB 10 Documento: " + cDoc + " - ExtId: " + cExter + " Erro na Gravacao da NFE  - " + cErrorLog + CRLF
        Else
            oWS:mudaSts(nRecn, cExter, "1")
        EndIf
        cEmpAnt  := cEmpAt1
        cFilAnt  := cFilAt1

        QRY_TAB->(dbSkip())
        LOOP
    ENDDO	
    QRY_TAB->(DBCLOSEAREA())
    conout("FINALIZOU JOBNFE - 10")
    //RESET ENVIRONMENT
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOB10_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        MemoWrite(cDirLog + cArqLog, cLog)
    Endif
    ConOut(OemToAnsi("Fim : ")+Time())

Return

User Function JOBENT11()
    Local cQueryTab := ""
    Local nConte    := 0
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    //PREPARE ENVIRONMENT EMPRESA '01' FILIAL '12' MODULO 'EST'
    RPCSetEnv("01", "11")

    conout("INICIANDO JOBENTRADA 11" )
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZE") + " ZZE " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZE.D_E_L_E_T_ = '' AND ZZE_STATUS IN ('9', '0') " + CRLF
    cQueryTab += "     AND ZZE_FILIAL IN ('11') " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    nConte := 0
    WHILE !(QRY_TAB->(EOF()))
        nResult := Val(substr(Time(),1,2))
        nConte++
        conout("LACO JOBNFE - 11 " + QRY_TAB->ZZE_ZEXTID)

        _CNPJCPF:= IIF(EMPTY(QRY_TAB->ZZE_CNPJFO), Substr( QRY_TAB->ZZE_CHVNF,7, 14), QRY_TAB->ZZE_CNPJFO)
        lTemFor := ows:temFornec(FWxFilial("SA2"), _CNPJCPF)

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(QRY_TAB->ZZE_GRUPO),  "01", QRY_TAB->ZZE_GRUPO)
        cFilAt   := Iif(EMPTY(QRY_TAB->ZZE_FILIAL), "11", QRY_TAB->ZZE_FILIAL)

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
            cLog += "JOB 11 Documento: " + cDoc + " - ExtId: " + cExter + " Erro Cad Fornecedor " + CRLF
        EndIF

        alTemExtr := ows:PGExtDad(cEnum + cExter) 
        IF len(alTemExtr) == 0  //Verifica se tem ExternoID - Numero do Pedido Externo
            oWS:GRAVALOGZZE(nRecn, cExter, "PEDIDO DE COMPRAS NAO EXISTE", "WSNFE", "INCLUSÃO DE Nota Fiscal de Entrada")
            cLog += "JOB 11 Documento: " + cDoc + " - ExtId: " + cExter + " PEDIDO DE COMPRAS NÃO EXISTE " + CRLF
        EndIF
        
        aRetGrv := oWS:GerNFE( cExter, cChavNfe, 3, dAltVct, cDoc, cSeri, cEnum, (cEnum + cExter))  //17/11/2025 - ajustado - //oWS:DGerNFE( jJson:GetJsonObject("IDPEDCOMPREXT"), jJson:GetJsonObject("CHVNFE"), 3) 
        If len(aRetGrv) > 0 
            cErrorLog   := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO
            oWS:GRAVALOGZZE(nRecn, cExter, cErrorLog, "WSNFE", "INCLUSÃO DE Nota Fiscal de Entrada")
            cLog += "JOB 11 Documento: " + cDoc + " - ExtId: " + cExter + " Erro na Gravacao da NFE  - " + cErrorLog + CRLF
        Else
            oWS:mudaSts(nRecn, cExter, "1")
        EndIf
        cEmpAnt  := cEmpAt1
        cFilAnt  := cFilAt1

        QRY_TAB->(dbSkip())
        LOOP
    ENDDO	
    QRY_TAB->(DBCLOSEAREA())
    conout("FINALIZOU JOBNFE - 11")
    //RESET ENVIRONMENT
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOB11_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        MemoWrite(cDirLog + cArqLog, cLog)
    EndiF
    ConOut(OemToAnsi("Fim : ")+Time())

Return

User Function JOBENT12()
    Local cQueryTab := ""
    Local nConte    := 0
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    //PREPARE ENVIRONMENT EMPRESA '01' FILIAL '12' MODULO 'EST'
    RPCSetEnv("01", "12")

    conout("INICIANDO JOBENTRADA 12" )
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZE") + " ZZE " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZE.D_E_L_E_T_ = '' AND ZZE_STATUS IN ('9', '0') " + CRLF
    cQueryTab += "     AND ZZE_FILIAL IN ('12') " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    nConte := 0
    WHILE !(QRY_TAB->(EOF()))
        nResult := Val(substr(Time(),1,2))
        nConte++
        conout("LACO JOBNFE - 12 " + QRY_TAB->ZZE_ZEXTID)

        _CNPJCPF:= IIF(EMPTY(QRY_TAB->ZZE_CNPJFO), Substr( QRY_TAB->ZZE_CHVNF,7, 14), QRY_TAB->ZZE_CNPJFO)
        lTemFor := ows:temFornec(FWxFilial("SA2"), _CNPJCPF)

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(QRY_TAB->ZZE_GRUPO),  "01", QRY_TAB->ZZE_GRUPO)
        cFilAt   := Iif(EMPTY(QRY_TAB->ZZE_FILIAL), "12", QRY_TAB->ZZE_FILIAL)

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
            cLog += "JOB 12 Documento: " + cDoc + " - ExtId: " + cExter + " Erro Cad Fornecedor " + CRLF
        EndIF

        alTemExtr := ows:PGExtDad(cEnum + cExter) 
        IF len(alTemExtr) == 0  //Verifica se tem ExternoID - Numero do Pedido Externo
            oWS:GRAVALOGZZE(nRecn, cExter, "PEDIDO DE COMPRAS NAO EXISTE", "WSNFE", "INCLUSÃO DE Nota Fiscal de Entrada")
            cLog += "JOB 12 Documento: " + cDoc + " - ExtId: " + cExter + " PEDIDO DE COMPRAS NÃO EXISTE " + CRLF
        EndIF
        
        aRetGrv := oWS:GerNFE( cExter, cChavNfe, 3, dAltVct, cDoc, cSeri, cEnum, (cEnum + cExter))  //17/11/2025 - ajustado - //oWS:DGerNFE( jJson:GetJsonObject("IDPEDCOMPREXT"), jJson:GetJsonObject("CHVNFE"), 3) 
        If len(aRetGrv) > 0 
            cErrorLog   := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO
            oWS:GRAVALOGZZE(nRecn, cExter, cErrorLog, "WSNFE", "INCLUSÃO DE Nota Fiscal de Entrada")
            cLog += "JOB 12 Documento: " + cDoc + " - ExtId: " + cExter + " Erro na Gravacao da NFE  - " + cErrorLog + CRLF
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
    //RESET ENVIRONMENT
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOB12_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        MemoWrite(cDirLog + cArqLog, cLog)
    EndiF
    ConOut(OemToAnsi("Fim : ")+Time())

Return

User Function JOBENT13()
    Local cQueryTab := ""
    Local nConte    := 0
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    //PREPARE ENVIRONMENT EMPRESA '01' FILIAL '12' MODULO 'EST'
    RPCSetEnv("01", "13")

    conout("INICIANDO JOBENTRADA 13" )
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZE") + " ZZE " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZE.D_E_L_E_T_ = '' AND ZZE_STATUS IN ('9', '0') " + CRLF
    cQueryTab += "     AND ZZE_FILIAL IN ('13') " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    nConte := 0
    WHILE !(QRY_TAB->(EOF()))
        nResult := Val(substr(Time(),1,2))
        nConte++
        conout("LACO JOBNFE - 13 " + QRY_TAB->ZZE_ZEXTID)

        _CNPJCPF:= IIF(EMPTY(QRY_TAB->ZZE_CNPJFO), Substr( QRY_TAB->ZZE_CHVNF,7, 14), QRY_TAB->ZZE_CNPJFO)
        lTemFor := ows:temFornec(FWxFilial("SA2"), _CNPJCPF)

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(QRY_TAB->ZZE_GRUPO),  "01", QRY_TAB->ZZE_GRUPO)
        cFilAt   := Iif(EMPTY(QRY_TAB->ZZE_FILIAL), "13", QRY_TAB->ZZE_FILIAL)

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
            cLog += "JOB 13 Documento: " + cDoc + " - ExtId: " + cExter + " Erro Cad Fornecedor " + CRLF
        EndIF

        alTemExtr := ows:PGExtDad(cEnum + cExter) 
        IF len(alTemExtr) == 0  //Verifica se tem ExternoID - Numero do Pedido Externo
            oWS:GRAVALOGZZE(nRecn, cExter, "PEDIDO DE COMPRAS NAO EXISTE", "WSNFE", "INCLUSÃO DE Nota Fiscal de Entrada")
            cLog += "JOB 13 Documento: " + cDoc + " - ExtId: " + cExter + " PEDIDO DE COMPRAS NÃO EXISTE " + CRLF
        EndIF
        
        aRetGrv := oWS:GerNFE( cExter, cChavNfe, 3, dAltVct, cDoc, cSeri, cEnum, (cEnum + cExter))  //17/11/2025 - ajustado - //oWS:DGerNFE( jJson:GetJsonObject("IDPEDCOMPREXT"), jJson:GetJsonObject("CHVNFE"), 3) 
        If len(aRetGrv) > 0 
            cErrorLog   := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO
            oWS:GRAVALOGZZE(nRecn, cExter, cErrorLog, "WSNFE", "INCLUSÃO DE Nota Fiscal de Entrada")
            cLog += "JOB 13 Documento: " + cDoc + " - ExtId: " + cExter + " Erro na Gravacao da NFE  - " + cErrorLog + CRLF
        Else
            oWS:mudaSts(nRecn, cExter, "1")
        EndIf
        cEmpAnt  := cEmpAt1
        cFilAnt  := cFilAt1

        QRY_TAB->(dbSkip())
        LOOP
    ENDDO	
    QRY_TAB->(DBCLOSEAREA())
    conout("FINALIZOU JOBNFE - 13")
    //RESET ENVIRONMENT
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOB13_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        MemoWrite(cDirLog + cArqLog, cLog)
    EndIF
    ConOut(OemToAnsi("Fim : ")+Time())

Return

User Function JOBENT14()
    Local cQueryTab := ""
    Local nConte    := 0
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    //PREPARE ENVIRONMENT EMPRESA '01' FILIAL '12' MODULO 'EST'
    RPCSetEnv("01", "14")

    conout("INICIANDO JOBENTRADA 14" )
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZE") + " ZZE " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZE.D_E_L_E_T_ = '' AND ZZE_STATUS IN ('9', '0') " + CRLF
    cQueryTab += "     AND ZZE_FILIAL IN ('14') " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    nConte := 0
    WHILE !(QRY_TAB->(EOF()))
        nResult := Val(substr(Time(),1,2))
        nConte++
        conout("LACO JOBNFE - 14 " + QRY_TAB->ZZE_ZEXTID)

        _CNPJCPF:= IIF(EMPTY(QRY_TAB->ZZE_CNPJFO), Substr( QRY_TAB->ZZE_CHVNF,7, 14), QRY_TAB->ZZE_CNPJFO)
        lTemFor := ows:temFornec(FWxFilial("SA2"), _CNPJCPF)

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(QRY_TAB->ZZE_GRUPO),  "01", QRY_TAB->ZZE_GRUPO)
        cFilAt   := Iif(EMPTY(QRY_TAB->ZZE_FILIAL), "14", QRY_TAB->ZZE_FILIAL)

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
            cLog += "JOB 14 Documento: " + cDoc + " - ExtId: " + cExter + " Erro Cad Fornecedor " + CRLF
        EndIF

        alTemExtr := ows:PGExtDad(cEnum + cExter) 
        IF len(alTemExtr) == 0  //Verifica se tem ExternoID - Numero do Pedido Externo
            oWS:GRAVALOGZZE(nRecn, cExter, "PEDIDO DE COMPRAS NAO EXISTE", "WSNFE", "INCLUSÃO DE Nota Fiscal de Entrada")
            cLog += "JOB 14 Documento: " + cDoc + " - ExtId: " + cExter + " PEDIDO DE COMPRAS NÃO EXISTE " + CRLF
        EndIF
        
        aRetGrv := oWS:GerNFE( cExter, cChavNfe, 3, dAltVct, cDoc, cSeri, cEnum, (cEnum + cExter))  //17/11/2025 - ajustado - //oWS:DGerNFE( jJson:GetJsonObject("IDPEDCOMPREXT"), jJson:GetJsonObject("CHVNFE"), 3) 
        If len(aRetGrv) > 0 
            cErrorLog   := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO
            oWS:GRAVALOGZZE(nRecn, cExter, cErrorLog, "WSNFE", "INCLUSÃO DE Nota Fiscal de Entrada")
            cLog += "JOB 14 Documento: " + cDoc + " - ExtId: " + cExter + " Erro na Gravacao da NFE  - " + cErrorLog + CRLF
        Else
            oWS:mudaSts(nRecn, cExter, "1")
        EndIf
        cEmpAnt  := cEmpAt1
        cFilAnt  := cFilAt1

        QRY_TAB->(dbSkip())
        LOOP
    ENDDO	
    QRY_TAB->(DBCLOSEAREA())
    conout("FINALIZOU JOBNFE - 14")
    //RESET ENVIRONMENT
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOB14_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        MemoWrite(cDirLog + cArqLog, cLog)
    EndiF
    ConOut(OemToAnsi("Fim : ")+Time())

Return

User Function JOBENT15()
    Local cQueryTab := ""
    Local nConte    := 0
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    //PREPARE ENVIRONMENT EMPRESA '01' FILIAL '12' MODULO 'EST'
    RPCSetEnv("01", "15")

    conout("INICIANDO JOBENTRADA 15" )
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZE") + " ZZE " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZE.D_E_L_E_T_ = '' AND ZZE_STATUS IN ('9', '0') " + CRLF
    cQueryTab += "     AND ZZE_FILIAL IN ('15') " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    nConte := 0
    WHILE !(QRY_TAB->(EOF()))
        nResult := Val(substr(Time(),1,2))
        nConte++
        conout("LACO JOBNFE - 15 " + QRY_TAB->ZZE_ZEXTID)

        _CNPJCPF:= IIF(EMPTY(QRY_TAB->ZZE_CNPJFO), Substr( QRY_TAB->ZZE_CHVNF,7, 14), QRY_TAB->ZZE_CNPJFO)
        lTemFor := ows:temFornec(FWxFilial("SA2"), _CNPJCPF)

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(QRY_TAB->ZZE_GRUPO),  "01", QRY_TAB->ZZE_GRUPO)
        cFilAt   := Iif(EMPTY(QRY_TAB->ZZE_FILIAL), "15", QRY_TAB->ZZE_FILIAL)

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
            cLog += "JOB 15 Documento: " + cDoc + " - ExtId: " + cExter + " Erro Cad Fornecedor " + CRLF
        EndIF

        alTemExtr := ows:PGExtDad(cEnum + cExter) 
        IF len(alTemExtr) == 0  //Verifica se tem ExternoID - Numero do Pedido Externo
            oWS:GRAVALOGZZE(nRecn, cExter, "PEDIDO DE COMPRAS NAO EXISTE", "WSNFE", "INCLUSÃO DE Nota Fiscal de Entrada")
            cLog += "JOB 15 Documento: " + cDoc + " - ExtId: " + cExter + " PEDIDO DE COMPRAS NÃO EXISTE " + CRLF
        EndIF
        
        aRetGrv := oWS:GerNFE( cExter, cChavNfe, 3, dAltVct, cDoc, cSeri, cEnum, (cEnum + cExter))  //17/11/2025 - ajustado - //oWS:DGerNFE( jJson:GetJsonObject("IDPEDCOMPREXT"), jJson:GetJsonObject("CHVNFE"), 3) 
        If len(aRetGrv) > 0 
            cErrorLog   := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO
            oWS:GRAVALOGZZE(nRecn, cExter, cErrorLog, "WSNFE", "INCLUSÃO DE Nota Fiscal de Entrada")
            cLog += "JOB 15 Documento: " + cDoc + " - ExtId: " + cExter + " Erro na Gravacao da NFE  - " + cErrorLog + CRLF
        Else
            oWS:mudaSts(nRecn, cExter, "1")
        EndIf
        cEmpAnt  := cEmpAt1
        cFilAnt  := cFilAt1

        QRY_TAB->(dbSkip())
        LOOP
    ENDDO	
    QRY_TAB->(DBCLOSEAREA())
    conout("FINALIZOU JOBNFE - 15")
    //RESET ENVIRONMENT
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOB15_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        MemoWrite(cDirLog + cArqLog, cLog)
    EndiF
    ConOut(OemToAnsi("Fim : ")+Time())

Return

User Function JOBENT16()
    Local cQueryTab := ""
    Local nConte    := 0
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    //PREPARE ENVIRONMENT EMPRESA '01' FILIAL '12' MODULO 'EST'
    RPCSetEnv("01", "16")

    conout("INICIANDO JOBENTRADA 16" )
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZE") + " ZZE " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZE.D_E_L_E_T_ = '' AND ZZE_STATUS IN ('9', '0') " + CRLF
    cQueryTab += "     AND ZZE_FILIAL IN ('16') " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    nConte := 0
    WHILE !(QRY_TAB->(EOF()))
        nResult := Val(substr(Time(),1,2))
        nConte++
        conout("LACO JOBNFE - 16 " + QRY_TAB->ZZE_ZEXTID)

        _CNPJCPF:= IIF(EMPTY(QRY_TAB->ZZE_CNPJFO), Substr( QRY_TAB->ZZE_CHVNF,7, 14), QRY_TAB->ZZE_CNPJFO)
        lTemFor := ows:temFornec(FWxFilial("SA2"), _CNPJCPF)

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(QRY_TAB->ZZE_GRUPO),  "01", QRY_TAB->ZZE_GRUPO)
        cFilAt   := Iif(EMPTY(QRY_TAB->ZZE_FILIAL), "16", QRY_TAB->ZZE_FILIAL)

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
            cLog += "JOB 16 Documento: " + cDoc + " - ExtId: " + cExter + " Erro Cad Fornecedor " + CRLF
        EndIF

        alTemExtr := ows:PGExtDad(cEnum + cExter) 
        IF len(alTemExtr) == 0  //Verifica se tem ExternoID - Numero do Pedido Externo
            oWS:GRAVALOGZZE(nRecn, cExter, "PEDIDO DE COMPRAS NAO EXISTE", "WSNFE", "INCLUSÃO DE Nota Fiscal de Entrada")
            cLog += "JOB 16 Documento: " + cDoc + " - ExtId: " + cExter + " PEDIDO DE COMPRAS NÃO EXISTE " + CRLF
        EndIF
        
        aRetGrv := oWS:GerNFE( cExter, cChavNfe, 3, dAltVct, cDoc, cSeri, cEnum, (cEnum + cExter))  //17/11/2025 - ajustado - //oWS:DGerNFE( jJson:GetJsonObject("IDPEDCOMPREXT"), jJson:GetJsonObject("CHVNFE"), 3) 
        If len(aRetGrv) > 0 
            cErrorLog   := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO
            oWS:GRAVALOGZZE(nRecn, cExter, cErrorLog, "WSNFE", "INCLUSÃO DE Nota Fiscal de Entrada")
            cLog += "JOB 16 Documento: " + cDoc + " - ExtId: " + cExter + " Erro na Gravacao da NFE  - " + cErrorLog + CRLF
        Else
            oWS:mudaSts(nRecn, cExter, "1")
        EndIf
        cEmpAnt  := cEmpAt1
        cFilAnt  := cFilAt1

        QRY_TAB->(dbSkip())
        LOOP
    ENDDO	
    QRY_TAB->(DBCLOSEAREA())
    conout("FINALIZOU JOBNFE - 16")
    //RESET ENVIRONMENT
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOB16_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        MemoWrite(cDirLog + cArqLog, cLog)
    EndIF
    ConOut(OemToAnsi("Fim : ")+Time())

Return

User Function JOBENT17()
    Local cQueryTab := ""
    Local nConte    := 0
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    //PREPARE ENVIRONMENT EMPRESA '01' FILIAL '12' MODULO 'EST'
    RPCSetEnv("01", "17")

    conout("INICIANDO JOBENTRADA 17" )
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZE") + " ZZE " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZE.D_E_L_E_T_ = '' AND ZZE_STATUS IN ('9', '0') " + CRLF
    cQueryTab += "     AND ZZE_FILIAL IN ('17') " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    nConte := 0
    WHILE !(QRY_TAB->(EOF()))
        nResult := Val(substr(Time(),1,2))
        nConte++
        conout("LACO JOBNFE - 17 " + QRY_TAB->ZZE_ZEXTID)

        _CNPJCPF:= IIF(EMPTY(QRY_TAB->ZZE_CNPJFO), Substr( QRY_TAB->ZZE_CHVNF,7, 14), QRY_TAB->ZZE_CNPJFO)
        lTemFor := ows:temFornec(FWxFilial("SA2"), _CNPJCPF)

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(QRY_TAB->ZZE_GRUPO),  "01", QRY_TAB->ZZE_GRUPO)
        cFilAt   := Iif(EMPTY(QRY_TAB->ZZE_FILIAL), "17", QRY_TAB->ZZE_FILIAL)

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
            cLog += "JOB 17 Documento: " + cDoc + " - ExtId: " + cExter + " Erro Cad Fornecedor " + CRLF
        EndIF

        alTemExtr := ows:PGExtDad(cEnum + cExter) 
        IF len(alTemExtr) == 0  //Verifica se tem ExternoID - Numero do Pedido Externo
            oWS:GRAVALOGZZE(nRecn, cExter, "PEDIDO DE COMPRAS NAO EXISTE", "WSNFE", "INCLUSÃO DE Nota Fiscal de Entrada")
            cLog += "JOB 17 Documento: " + cDoc + " - ExtId: " + cExter + " PEDIDO DE COMPRAS NÃO EXISTE " + CRLF
        EndIF
        
        aRetGrv := oWS:GerNFE( cExter, cChavNfe, 3, dAltVct, cDoc, cSeri, cEnum, (cEnum + cExter))  //17/11/2025 - ajustado - //oWS:DGerNFE( jJson:GetJsonObject("IDPEDCOMPREXT"), jJson:GetJsonObject("CHVNFE"), 3) 
        If len(aRetGrv) > 0 
            cErrorLog   := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO
            oWS:GRAVALOGZZE(nRecn, cExter, cErrorLog, "WSNFE", "INCLUSÃO DE Nota Fiscal de Entrada")
            cLog += "JOB 17 Documento: " + cDoc + " - ExtId: " + cExter + " Erro na Gravacao da NFE  - " + cErrorLog + CRLF
        Else
            oWS:mudaSts(nRecn, cExter, "1")
        EndIf
        cEmpAnt  := cEmpAt1
        cFilAnt  := cFilAt1

        QRY_TAB->(dbSkip())
        LOOP
    ENDDO	
    QRY_TAB->(DBCLOSEAREA())
    conout("FINALIZOU JOBNFE - 17")
    //RESET ENVIRONMENT
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOB17_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        MemoWrite(cDirLog + cArqLog, cLog)
    EndIF
    ConOut(OemToAnsi("Fim : ")+Time())

Return

User Function JOBENT18()
    Local cQueryTab := ""
    Local nConte    := 0
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    //PREPARE ENVIRONMENT EMPRESA '01' FILIAL '12' MODULO 'EST'
    RPCSetEnv("01", "18")

    conout("INICIANDO JOBENTRADA 18" )
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZE") + " ZZE " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZE.D_E_L_E_T_ = '' AND ZZE_STATUS IN ('9', '0') " + CRLF
    cQueryTab += "     AND ZZE_FILIAL IN ('18') " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    nConte := 0
    WHILE !(QRY_TAB->(EOF()))
        nResult := Val(substr(Time(),1,2))
        nConte++
        conout("LACO JOBNFE - 18 " + QRY_TAB->ZZE_ZEXTID)

        _CNPJCPF:= IIF(EMPTY(QRY_TAB->ZZE_CNPJFO), Substr( QRY_TAB->ZZE_CHVNF,7, 14), QRY_TAB->ZZE_CNPJFO)
        lTemFor := ows:temFornec(FWxFilial("SA2"), _CNPJCPF)

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(QRY_TAB->ZZE_GRUPO),  "01", QRY_TAB->ZZE_GRUPO)
        cFilAt   := Iif(EMPTY(QRY_TAB->ZZE_FILIAL), "18", QRY_TAB->ZZE_FILIAL)

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
            cLog += "JOB 18 Documento: " + cDoc + " - ExtId: " + cExter + " Erro Cad Fornecedor " + CRLF
        EndIF

        alTemExtr := ows:PGExtDad(cEnum + cExter) 
        IF len(alTemExtr) == 0  //Verifica se tem ExternoID - Numero do Pedido Externo
            oWS:GRAVALOGZZE(nRecn, cExter, "PEDIDO DE COMPRAS NAO EXISTE", "WSNFE", "INCLUSÃO DE Nota Fiscal de Entrada")
            cLog += "JOB 18 Documento: " + cDoc + " - ExtId: " + cExter + " PEDIDO DE COMPRAS NÃO EXISTE " + CRLF
        EndIF
        
        aRetGrv := oWS:GerNFE( cExter, cChavNfe, 3, dAltVct, cDoc, cSeri, cEnum, (cEnum + cExter))  //17/11/2025 - ajustado - //oWS:DGerNFE( jJson:GetJsonObject("IDPEDCOMPREXT"), jJson:GetJsonObject("CHVNFE"), 3) 
        If len(aRetGrv) > 0 
            cErrorLog   := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO
            oWS:GRAVALOGZZE(nRecn, cExter, cErrorLog, "WSNFE", "INCLUSÃO DE Nota Fiscal de Entrada")
            cLog += "JOB 18 Documento: " + cDoc + " - ExtId: " + cExter + " Erro na Gravacao da NFE  - " + cErrorLog + CRLF
        Else
            oWS:mudaSts(nRecn, cExter, "1")
        EndIf
        cEmpAnt  := cEmpAt1
        cFilAnt  := cFilAt1

        QRY_TAB->(dbSkip())
        LOOP
    ENDDO	
    QRY_TAB->(DBCLOSEAREA())
    conout("FINALIZOU JOBNFE - 18")
    //RESET ENVIRONMENT
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOB18_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        MemoWrite(cDirLog + cArqLog, cLog)
    EndIF
    ConOut(OemToAnsi("Fim : ")+Time())

Return

User Function JOBENT19()
    Local cQueryTab := ""
    Local nConte    := 0
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    //PREPARE ENVIRONMENT EMPRESA '01' FILIAL '12' MODULO 'EST'
    RPCSetEnv("01", "19")

    conout("INICIANDO JOBENTRADA 19" )
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZE") + " ZZE " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZE.D_E_L_E_T_ = '' AND ZZE_STATUS IN ('9', '0') " + CRLF
    cQueryTab += "     AND ZZE_FILIAL IN ('19') " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    nConte := 0
    WHILE !(QRY_TAB->(EOF()))
        nResult := Val(substr(Time(),1,2))
        nConte++
        conout("LACO JOBNFE - 19 " + QRY_TAB->ZZE_ZEXTID)

        _CNPJCPF:= IIF(EMPTY(QRY_TAB->ZZE_CNPJFO), Substr( QRY_TAB->ZZE_CHVNF,7, 14), QRY_TAB->ZZE_CNPJFO)
        lTemFor := ows:temFornec(FWxFilial("SA2"), _CNPJCPF)

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(QRY_TAB->ZZE_GRUPO),  "01", QRY_TAB->ZZE_GRUPO)
        cFilAt   := Iif(EMPTY(QRY_TAB->ZZE_FILIAL), "19", QRY_TAB->ZZE_FILIAL)

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
            cLog += "JOB 19 Documento: " + cDoc + " - ExtId: " + cExter + " Erro Cad Fornecedor " + CRLF
        EndIF

        alTemExtr := ows:PGExtDad(cEnum + cExter) 
        IF len(alTemExtr) == 0  //Verifica se tem ExternoID - Numero do Pedido Externo
            oWS:GRAVALOGZZE(nRecn, cExter, "PEDIDO DE COMPRAS NAO EXISTE", "WSNFE", "INCLUSÃO DE Nota Fiscal de Entrada")
            cLog += "JOB 19 Documento: " + cDoc + " - ExtId: " + cExter + " PEDIDO DE COMPRAS NÃO EXISTE " + CRLF
        EndIF
        
        aRetGrv := oWS:GerNFE( cExter, cChavNfe, 3, dAltVct, cDoc, cSeri, cEnum, (cEnum + cExter))  //17/11/2025 - ajustado - //oWS:DGerNFE( jJson:GetJsonObject("IDPEDCOMPREXT"), jJson:GetJsonObject("CHVNFE"), 3) 
        If len(aRetGrv) > 0 
            cErrorLog   := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO
            oWS:GRAVALOGZZE(nRecn, cExter, cErrorLog, "WSNFE", "INCLUSÃO DE Nota Fiscal de Entrada")
            cLog += "JOB 19 Documento: " + cDoc + " - ExtId: " + cExter + " Erro na Gravacao da NFE  - " + cErrorLog + CRLF
        Else
            oWS:mudaSts(nRecn, cExter, "1")
        EndIf
        cEmpAnt  := cEmpAt1
        cFilAnt  := cFilAt1

        QRY_TAB->(dbSkip())
        LOOP
    ENDDO	
    QRY_TAB->(DBCLOSEAREA())
    conout("FINALIZOU JOBNFE - 19")
    //RESET ENVIRONMENT
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOB19_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        MemoWrite(cDirLog + cArqLog, cLog)
    EndIF
    ConOut(OemToAnsi("Fim : ")+Time())

Return

User Function JOBENT20()
    Local cQueryTab := ""
    Local nConte    := 0
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    //PREPARE ENVIRONMENT EMPRESA '01' FILIAL '12' MODULO 'EST'
    RPCSetEnv("01", "20")

    conout("INICIANDO JOBENTRADA 20" )
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZE") + " ZZE " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZE.D_E_L_E_T_ = '' AND ZZE_STATUS IN ('9', '0') " + CRLF
    cQueryTab += "     AND ZZE_FILIAL IN ('20') " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    nConte := 0
    WHILE !(QRY_TAB->(EOF()))
        nResult := Val(substr(Time(),1,2))
        nConte++
        conout("LACO JOBNFE - 20 " + QRY_TAB->ZZE_ZEXTID)

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
    conout("FINALIZOU JOBNFE - 20")
    //RESET ENVIRONMENT
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOB20_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        MemoWrite(cDirLog + cArqLog, cLog)
    EndIF
    ConOut(OemToAnsi("Fim : ")+Time())

Return

// FINAL DA ENTRADA \\

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
