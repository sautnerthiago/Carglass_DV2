#include "totvs.ch"
#include "protheus.ch"
#include "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

User Function MYHASH()
    Local aAreaIm  := GetArea()
    ConOut(OemToAnsi("INICIO DO MYHASH: ")+Time())

    //SAIDAS - INICIO
    // StartJob("u_JOBSAI01",GetEnvServer(),.F.)
    // StartJob("u_JOBSAI02",GetEnvServer(),.F.)
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
    StartJob("u_JOBENT01",GetEnvServer(),.F.)
    StartJob("u_JOBENT02",GetEnvServer(),.F.)
    StartJob("u_JOBENT03",GetEnvServer(),.F.)
    StartJob("u_JOBENT04",GetEnvServer(),.F.)
    StartJob("u_JOBENT05",GetEnvServer(),.F.)

    StartJob("u_JOBENT06",GetEnvServer(),.F.)
    StartJob("u_JOBENT07",GetEnvServer(),.F.)
    StartJob("u_JOBENT08",GetEnvServer(),.F.)
    StartJob("u_JOBENT09",GetEnvServer(),.F.)
    StartJob("u_JOBENT10",GetEnvServer(),.F.)

    StartJob("u_JOBENT11",GetEnvServer(),.F.)
    StartJob("u_JOBENT12",GetEnvServer(),.F.)
    StartJob("u_JOBENT13",GetEnvServer(),.F.)
    StartJob("u_JOBENT14",GetEnvServer(),.F.)
    StartJob("u_JOBENT15",GetEnvServer(),.F.)

    StartJob("u_JOBENT16",GetEnvServer(),.F.)
    StartJob("u_JOBENT17",GetEnvServer(),.F.)
    StartJob("u_JOBENT18",GetEnvServer(),.F.)
    StartJob("u_JOBENT19",GetEnvServer(),.F.)
    StartJob("u_JOBENT20",GetEnvServer(),.F.)

    //PEDIDO DE COMPRAS
    StartJob("u_JOBPDC01",GetEnvServer(),.F.,"01")
    StartJob("u_JOBPDC02",GetEnvServer(),.F.,"02")
    StartJob("u_JOBPDC03",GetEnvServer(),.F.,"03")
    StartJob("u_JOBPDC04",GetEnvServer(),.F.,"04")
    StartJob("u_JOBPDC05",GetEnvServer(),.F.,"05")

    StartJob("u_JOBPDC06",GetEnvServer(),.F.,"06")
    StartJob("u_JOBPDC07",GetEnvServer(),.F.,"07")
    StartJob("u_JOBPDC08",GetEnvServer(),.F.,"08")
    StartJob("u_JOBPDC09",GetEnvServer(),.F.,"09")
    StartJob("u_JOBPDC10",GetEnvServer(),.F.,"10")

    StartJob("u_JOBPDC11",GetEnvServer(),.F.,"11")
    StartJob("u_JOBPDC12",GetEnvServer(),.F.,"12")
    StartJob("u_JOBPDC13",GetEnvServer(),.F.,"13")
    StartJob("u_JOBPDC14",GetEnvServer(),.F.,"14")
    StartJob("u_JOBPDC15",GetEnvServer(),.F.,"15")

    StartJob("u_JOBPDC16",GetEnvServer(),.F.,"16")
    StartJob("u_JOBPDC17",GetEnvServer(),.F.,"17")
    StartJob("u_JOBPDC18",GetEnvServer(),.F.,"18")
    StartJob("u_JOBPDC19",GetEnvServer(),.F.,"19")
    StartJob("u_JOBPDC20",GetEnvServer(),.F.,"20")

    //PEDIDO DE VENDAS

    RpcClearEnv()
    ConOut(OemToAnsi("FINAL DO MYHASH: ")+Time())
    RestArea(aAreaIm)

Return

//INICIO DAS SAIDAS
User Function JOBSAI01()
    Local cQueryTab := ""
    Local aRetGrv   := {}
    Local aArea     := FWGetArea()
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    Local aSai01    := {}
    Local Xx        := 0
    
    RPCSetEnv("01", "01")
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT TOP 20 *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZF") + " ZZF WITH (NOLOCK)  " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZF.D_E_L_E_T_ = '' AND ZZF_STATUS = '0' " + CRLF
    cQueryTab += "     AND ZZF_FILIAL IN ('01') AND ZZF_VALOR > 0 " + CRLF
    cQueryTab += "     ORDER BY ZZF_VALOR DESC " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    conout("MONTANDO O OBJETO - INICIANDO JOBSAI01")
    WHILE !(QRY_TAB->(EOF()))
        AADD(aSai01, { QRY_TAB->ZZF_ZGRPEN, QRY_TAB->ZZF_ZEXTID,; 
                       QRY_TAB->ZZF_NUMNF,  QRY_TAB->ZZF_SERNFE,; 
                       QRY_TAB->ZZF_DTALTE, QRY_TAB->ZZF_CHVNF, ; 
                       QRY_TAB->ZZF_GRUPO,  QRY_TAB->ZZF_FILIAL, ; 
                       QRY_TAB->RECNO,      QRY_TAB->ZZF_CC     }) 
        QRY_TAB->(dbSkip())
        LOOP
    ENDDO	
    QRY_TAB->(DBCLOSEAREA())

    nConte := 0
    FOR Xx := 1 TO lEN(aSai01)

        nConte++
        conout("LACO JOBSAI - " + aSai01[XX, 01])

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(aSai01[xx, 07]), "01", aSai01[xx, 07])
        cFilAt   := Iif(EMPTY(aSai01[xx, 08]), "01", aSai01[xx, 08])

        cEmpAnt  := cEmpAt
        cFilAnt  := cFilAt

        cEnum    := aSai01[xx, 01 ]
        cExter   := aSai01[xx, 02 ]
        cDoc     := aSai01[xx, 03 ]
        cSeri    := aSai01[xx, 04 ]
        dAltVct  := aSai01[xx, 05 ]
        cChavNfe := aSai01[xx, 06 ]
        nRecn    := aSai01[xx, 09 ]
        cCentCus := aSai01[xx, 10 ]

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
    NEXT	
    RestArea(aArea)
    CONOUT("FINALIZOUJOB NFS")
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOBS01_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        //MemoWrite(cDirLog + cArqLog, cLog)
    endif

Return

User Function JOBSAI02()
    Local cQueryTab := ""
    Local aRetGrv   := {}
    Local aArea     := FWGetArea()
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'
    
    Local aSai02    := {}
    Local X2        := 0
    
    conout("INICIANDO JOBSAI02")
    RPCSetEnv("01", "02")
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZF") + " ZZF WITH (NOLOCK) " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZF.D_E_L_E_T_ = '' AND ZZF_STATUS = '0' " + CRLF
    cQueryTab += "     AND ZZF_FILIAL IN ('02')  AND ZZF_VALOR > 0 " + CRLF
    cQueryTab += "     ORDER BY ZZF_VALOR DESC " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    WHILE !(QRY_TAB->(EOF()))
        AADD(aSai02, { QRY_TAB->ZZF_ZGRPEN, QRY_TAB->ZZF_ZEXTID,; 
                       QRY_TAB->ZZF_NUMNF,  QRY_TAB->ZZF_SERNFE,; 
                       QRY_TAB->ZZF_DTALTE, QRY_TAB->ZZF_CHVNF, ; 
                       QRY_TAB->ZZF_GRUPO,  QRY_TAB->ZZF_FILIAL, ; 
                       QRY_TAB->RECNO,      QRY_TAB->ZZF_CC     }) 
        QRY_TAB->(dbSkip())
        LOOP
    ENDDO	
    QRY_TAB->(DBCLOSEAREA())    

    nConte := 0
    FOR X2 := 1 TO lEN(aSai02)

        nConte++
        conout("LACO JOBSAI - " + aSai02[X2, 01])

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(aSai02[x2, 07]), "01", aSai02[x2, 07])
        cFilAt   := Iif(EMPTY(aSai02[x2, 08]), "02", aSai02[x2, 08])

        cEmpAnt  := cEmpAt
        cFilAnt  := cFilAt

        cEnum    := aSai02[x2, 01 ]
        cExter   := aSai02[x2, 02 ]
        cDoc     := aSai02[x2, 03 ]
        cSeri    := aSai02[x2, 04 ]
        dAltVct  := aSai02[x2, 05 ]
        cChavNfe := aSai02[x2, 06 ]
        nRecn    := aSai02[x2, 09 ]
        cCentCus := aSai02[x2, 10 ]
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
    NEXT	

    RestArea(aArea)
    CONOUT("FINALIZOUJOB NFS - 02")
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOBS02_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        //MemoWrite(cDirLog + cArqLog, cLog)
    endif

Return

User Function JOBSAI03()
    Local cQueryTab := ""
    Local aRetGrv   := {}
    Local aArea     := FWGetArea()
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    Local aSai03    := {}
    Local X3        := 0

    conout("INICIANDO JOBSAI03")
    RPCSetEnv("01", "03")
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZF") + " ZZF WITH (NOLOCK) " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZF.D_E_L_E_T_ = '' AND ZZF_STATUS = '0' " + CRLF
    cQueryTab += "     AND ZZF_FILIAL IN ('03')  AND ZZF_VALOR > 0 " + CRLF
    cQueryTab += "     ORDER BY ZZF_VALOR DESC " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    WHILE !(QRY_TAB->(EOF()))
        AADD(aSai03, { QRY_TAB->ZZF_ZGRPEN, QRY_TAB->ZZF_ZEXTID,; 
                       QRY_TAB->ZZF_NUMNF,  QRY_TAB->ZZF_SERNFE,; 
                       QRY_TAB->ZZF_DTALTE, QRY_TAB->ZZF_CHVNF, ; 
                       QRY_TAB->ZZF_GRUPO,  QRY_TAB->ZZF_FILIAL, ; 
                       QRY_TAB->RECNO,      QRY_TAB->ZZF_CC     }) 
        QRY_TAB->(dbSkip())
        LOOP
    ENDDO	
    QRY_TAB->(DBCLOSEAREA())

    nConte := 0
    FOR X3 := 1 TO lEN(aSai03)

        nConte++
        conout("LACO JOBSAI - " + aSai03[X3, 01])

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(aSai03[x3, 07]), "01", aSai03[x3, 07])
        cFilAt   := Iif(EMPTY(aSai03[x3, 08]), "03", aSai03[x3, 08])

        cEmpAnt  := cEmpAt
        cFilAnt  := cFilAt

        cEnum    := aSai03[x3, 01 ]
        cExter   := aSai03[x3, 02 ]
        cDoc     := aSai03[x3, 03 ]
        cSeri    := aSai03[x3, 04 ]
        dAltVct  := aSai03[x3, 05 ]
        cChavNfe := aSai03[x3, 06 ]
        nRecn    := aSai03[x3, 09 ]
        cCentCus := aSai03[x3, 10 ]
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
    NEXT	

    RestArea(aArea)
    CONOUT("FINALIZOUJOB NFS 03")
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOBS03_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        //MemoWrite(cDirLog + cArqLog, cLog)
    endif

Return

User Function JOBSAI04()
    Local cQueryTab := ""
    Local aRetGrv   := {}
    Local aArea     := FWGetArea()
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    Local aSai04    := {}
    Local X4        := 0

    conout("INICIANDO JOBSAI04")
    RPCSetEnv("01", "04")
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZF") + " ZZF WITH (NOLOCK)  " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZF.D_E_L_E_T_ = '' AND ZZF_STATUS = '0' " + CRLF
    cQueryTab += "     AND ZZF_FILIAL IN ('04')  AND ZZF_VALOR > 0 " + CRLF
    cQueryTab += "     ORDER BY ZZF_VALOR DESC " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    WHILE !(QRY_TAB->(EOF()))
        AADD(aSai04, { QRY_TAB->ZZF_ZGRPEN, QRY_TAB->ZZF_ZEXTID,; 
                       QRY_TAB->ZZF_NUMNF,  QRY_TAB->ZZF_SERNFE,; 
                       QRY_TAB->ZZF_DTALTE, QRY_TAB->ZZF_CHVNF, ; 
                       QRY_TAB->ZZF_GRUPO,  QRY_TAB->ZZF_FILIAL, ; 
                       QRY_TAB->RECNO,      QRY_TAB->ZZF_CC     }) 
        QRY_TAB->(dbSkip())
        LOOP
    ENDDO	
    QRY_TAB->(DBCLOSEAREA())    

    nConte := 0
    FOR X4 := 1 TO lEN(aSai04)

        nConte++
        conout("LACO JOBSAI - " + aSai04[X4, 01])

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(aSai04[x4, 07]), "01", aSai04[x4, 07])
        cFilAt   := Iif(EMPTY(aSai04[x4, 08]), "04", aSai04[x4, 08])

        cEmpAnt  := cEmpAt
        cFilAnt  := cFilAt

        cEnum    := aSai04[x4, 01 ]
        cExter   := aSai04[x4, 02 ]
        cDoc     := aSai04[x4, 03 ]
        cSeri    := aSai04[x4, 04 ]
        dAltVct  := aSai04[x4, 05 ]
        cChavNfe := aSai04[x4, 06 ]
        nRecn    := aSai04[x4, 09 ]
        cCentCus := aSai04[x4, 10 ]
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
    NEXT	
    RestArea(aArea)
    CONOUT("FINALIZOUJOB NFS - 04")
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOBS04_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        //MemoWrite(cDirLog + cArqLog, cLog)
    endif

Return

User Function JOBSAI05()
    Local cQueryTab := ""
    Local aRetGrv   := {}
    Local aArea     := FWGetArea()
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    Local aSai05    := {}
    Local X5        := 0

    conout("INICIANDO JOBSAI05")
    RPCSetEnv("01", "05")
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZF") + " ZZF WITH (NOLOCK) " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZF.D_E_L_E_T_ = '' AND ZZF_STATUS = '0' " + CRLF
    cQueryTab += "     AND ZZF_FILIAL IN ('05')  AND ZZF_VALOR > 0 " + CRLF
    cQueryTab += "     ORDER BY ZZF_VALOR DESC " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    WHILE !(QRY_TAB->(EOF()))
        AADD(aSai05, { QRY_TAB->ZZF_ZGRPEN, QRY_TAB->ZZF_ZEXTID,; 
                       QRY_TAB->ZZF_NUMNF,  QRY_TAB->ZZF_SERNFE,; 
                       QRY_TAB->ZZF_DTALTE, QRY_TAB->ZZF_CHVNF, ; 
                       QRY_TAB->ZZF_GRUPO,  QRY_TAB->ZZF_FILIAL, ; 
                       QRY_TAB->RECNO,      QRY_TAB->ZZF_CC     }) 
        QRY_TAB->(dbSkip())
        LOOP
    ENDDO	
    QRY_TAB->(DBCLOSEAREA())

    nConte := 0
    FOR X5 := 1 TO lEN(aSai05)
        nConte++
        conout("LACO JOBSAI - " + aSai05[X5, 01])

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(aSai05[x5, 07]), "01", aSai05[x5, 07])
        cFilAt   := Iif(EMPTY(aSai05[x5, 08]), "05", aSai05[x5, 08])

        cEmpAnt  := cEmpAt
        cFilAnt  := cFilAt

        cEnum    := aSai05[x5, 01 ]
        cExter   := aSai05[x5, 02 ]
        cDoc     := aSai05[x5, 03 ]
        cSeri    := aSai05[x5, 04 ]
        dAltVct  := aSai05[x5, 05 ]
        cChavNfe := aSai05[x5, 06 ]
        nRecn    := aSai05[x5, 09 ]
        cCentCus := aSai05[x5, 10 ]

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
    NEXT	

    RestArea(aArea)
    CONOUT("FINALIZOUJOB NFS - 05")
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOBS05_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        //MemoWrite(cDirLog + cArqLog, cLog)
    endif

Return

User Function JOBSAI06()
    Local cQueryTab := ""
    Local aRetGrv   := {}
    Local aArea     := FWGetArea()
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    Local aSai06    := {}
    Local X6        := 0
    
    conout("INICIANDO JOBSAI 06")
    RPCSetEnv("01", "06")
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZF") + " ZZF WITH (NOLOCK)  " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZF.D_E_L_E_T_ = '' AND ZZF_STATUS = '0' " + CRLF
    cQueryTab += "     AND ZZF_FILIAL IN ('06') AND ZZF_VALOR > 0 " + CRLF
    cQueryTab += "     ORDER BY ZZF_VALOR DESC " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    WHILE !(QRY_TAB->(EOF()))
        AADD(aSai06, { QRY_TAB->ZZF_ZGRPEN, QRY_TAB->ZZF_ZEXTID,; 
                       QRY_TAB->ZZF_NUMNF,  QRY_TAB->ZZF_SERNFE,; 
                       QRY_TAB->ZZF_DTALTE, QRY_TAB->ZZF_CHVNF, ; 
                       QRY_TAB->ZZF_GRUPO,  QRY_TAB->ZZF_FILIAL, ; 
                       QRY_TAB->RECNO,      QRY_TAB->ZZF_CC     }) 
        QRY_TAB->(dbSkip())
        LOOP
    ENDDO	
    QRY_TAB->(DBCLOSEAREA())

    nConte := 0
    FOR X6 := 1 TO lEN(aSai06)
        nConte++
        conout("LACO JOBSAI - " + aSai06[X6, 01])

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(aSai06[x6, 07]), "01", aSai06[x6, 07])
        cFilAt   := Iif(EMPTY(aSai06[x6, 08]), "06", aSai06[x6, 08])

        cEmpAnt  := cEmpAt
        cFilAnt  := cFilAt

        cEnum    := aSai06[x6, 01 ]
        cExter   := aSai06[x6, 02 ]
        cDoc     := aSai06[x6, 03 ]
        cSeri    := aSai06[x6, 04 ]
        dAltVct  := aSai06[x6, 05 ]
        cChavNfe := aSai06[x6, 06 ]
        nRecn    := aSai06[x6, 09 ]
        cCentCus := aSai06[x6, 10 ]

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
    NEXT	

    RestArea(aArea)
    CONOUT("FINALIZOUJOB NFS - 06")
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOBS06_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        //MemoWrite(cDirLog + cArqLog, cLog)
    endif


Return

User Function JOBSAI07()
    Local cQueryTab := ""
    Local aRetGrv   := {}
    Local aArea     := FWGetArea()
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    Local aSai07    := {}
    Local X7        := 0
    
    conout("INICIANDO JOBSAI 07")
    RPCSetEnv("01", "07")

    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZF") + " ZZF WITH (NOLOCK) " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZF.D_E_L_E_T_ = '' AND ZZF_STATUS = '0' " + CRLF
    cQueryTab += "     AND ZZF_FILIAL IN ('07')  AND ZZF_VALOR > 0 " + CRLF
    cQueryTab += "     ORDER BY ZZF_VALOR DESC " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    WHILE !(QRY_TAB->(EOF()))
        AADD(aSai07, { QRY_TAB->ZZF_ZGRPEN, QRY_TAB->ZZF_ZEXTID,; 
                       QRY_TAB->ZZF_NUMNF,  QRY_TAB->ZZF_SERNFE,; 
                       QRY_TAB->ZZF_DTALTE, QRY_TAB->ZZF_CHVNF, ; 
                       QRY_TAB->ZZF_GRUPO,  QRY_TAB->ZZF_FILIAL, ; 
                       QRY_TAB->RECNO,      QRY_TAB->ZZF_CC     }) 
        QRY_TAB->(dbSkip())
        LOOP
    ENDDO	
    QRY_TAB->(DBCLOSEAREA())

    nConte := 0
    FOR X7 := 1 TO lEN(aSai07)

        nConte++
        conout("LACO JOBSAI - " + aSai07[X7, 01])

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(aSai07[x7, 07]), "01", aSai07[x7, 07])
        cFilAt   := Iif(EMPTY(aSai07[x7, 08]), "07", aSai07[x7, 08])

        cEmpAnt  := cEmpAt
        cFilAnt  := cFilAt

        cEnum    := aSai07[x7, 01 ]
        cExter   := aSai07[x7, 02 ]
        cDoc     := aSai07[x7, 03 ]
        cSeri    := aSai07[x7, 04 ]
        dAltVct  := aSai07[x7, 05 ]
        cChavNfe := aSai07[x7, 06 ]
        nRecn    := aSai07[x7, 09 ]
        cCentCus := aSai07[x7, 10 ]

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
    NEXT	

    RestArea(aArea)
    CONOUT("FINALIZOUJOB NFS - 07")

    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOBS07_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        //MemoWrite(cDirLog + cArqLog, cLog)
    endif


Return

User Function JOBSAI08()
    Local cQueryTab := ""
    Local aRetGrv   := {}
    Local aArea     := FWGetArea()
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'
    
    Local aSai08    := {}
    Local X8        := 0
        
    conout("INICIANDO JOBSAI 08")
    
    RPCSetEnv("01", "08")
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZF") + " ZZF WITH (NOLOCK) " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZF.D_E_L_E_T_ = '' AND ZZF_STATUS = '0' " + CRLF
    cQueryTab += "     AND ZZF_FILIAL IN ('08')  AND ZZF_VALOR > 0 " + CRLF
    cQueryTab += "     ORDER BY ZZF_VALOR DESC " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    WHILE !(QRY_TAB->(EOF()))
        AADD(aSai08, { QRY_TAB->ZZF_ZGRPEN, QRY_TAB->ZZF_ZEXTID,; 
                       QRY_TAB->ZZF_NUMNF,  QRY_TAB->ZZF_SERNFE,; 
                       QRY_TAB->ZZF_DTALTE, QRY_TAB->ZZF_CHVNF, ; 
                       QRY_TAB->ZZF_GRUPO,  QRY_TAB->ZZF_FILIAL, ; 
                       QRY_TAB->RECNO,      QRY_TAB->ZZF_CC     }) 
        QRY_TAB->(dbSkip())
        LOOP
    ENDDO	
    QRY_TAB->(DBCLOSEAREA())

    nConte := 0
    FOR X8 := 1 TO lEN(aSai08)

        nConte++
        conout("LACO JOBSAI - " + aSai08[X8, 01])

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(aSai08[x8, 07]), "01", aSai08[x8, 07])
        cFilAt   := Iif(EMPTY(aSai08[x8, 08]), "08", aSai08[x8, 08])

        cEmpAnt  := cEmpAt
        cFilAnt  := cFilAt

        cEnum    := aSai08[x8, 01 ]
        cExter   := aSai08[x8, 02 ]
        cDoc     := aSai08[x8, 03 ]
        cSeri    := aSai08[x8, 04 ]
        dAltVct  := aSai08[x8, 05 ]
        cChavNfe := aSai08[x8, 06 ]
        nRecn    := aSai08[x8, 09 ]
        cCentCus := aSai08[x8, 10 ]


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
    NEXT	

    RestArea(aArea)
    CONOUT("FINALIZOUJOB NFS 08")
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOBS08_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        //MemoWrite(cDirLog + cArqLog, cLog)
    endif

Return

User Function JOBSAI09()
    Local cQueryTab := ""
    Local aRetGrv   := {}
    Local aArea     := FWGetArea()
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    Local aSai09    := {}
    Local X9        := 0

    conout("INICIANDO JOBSAI 09")
    RPCSetEnv("01", "09")
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZF") + " ZZF WITH (NOLOCK) " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZF.D_E_L_E_T_ = '' AND ZZF_STATUS = '0' " + CRLF
    cQueryTab += "     AND ZZF_FILIAL IN ('09')  AND ZZF_VALOR > 0 " + CRLF
    cQueryTab += "     ORDER BY ZZF_VALOR DESC " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    WHILE !(QRY_TAB->(EOF()))
        AADD(aSai09, { QRY_TAB->ZZF_ZGRPEN, QRY_TAB->ZZF_ZEXTID,; 
                       QRY_TAB->ZZF_NUMNF,  QRY_TAB->ZZF_SERNFE,; 
                       QRY_TAB->ZZF_DTALTE, QRY_TAB->ZZF_CHVNF, ; 
                       QRY_TAB->ZZF_GRUPO,  QRY_TAB->ZZF_FILIAL, ; 
                       QRY_TAB->RECNO,      QRY_TAB->ZZF_CC     }) 
        QRY_TAB->(dbSkip())
        LOOP
    ENDDO	
    QRY_TAB->(DBCLOSEAREA())

    nConte := 0
    FOR X9 := 1 TO lEN(aSai09)

        nConte++
        conout("LACO JOBSAI - " + aSai09[X9, 01])

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(aSai09[x9, 07]), "01", aSai09[x9, 07])
        cFilAt   := Iif(EMPTY(aSai09[x9, 08]), "09", aSai09[x9, 08])

        cEmpAnt  := cEmpAt
        cFilAnt  := cFilAt

        cEnum    := aSai09[x9, 01 ]
        cExter   := aSai09[x9, 02 ]
        cDoc     := aSai09[x9, 03 ]
        cSeri    := aSai09[x9, 04 ]
        dAltVct  := aSai09[x9, 05 ]
        cChavNfe := aSai09[x9, 06 ]
        nRecn    := aSai09[x9, 09 ]
        cCentCus := aSai09[x9, 10 ]

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
    NEXT	

    RestArea(aArea)
    CONOUT("FINALIZOUJOB NFS - 09")
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOBS09_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        //MemoWrite(cDirLog + cArqLog, cLog)
    endif


Return

User Function JOBSAI10()
    Local cQueryTab := ""
    Local aRetGrv   := {}
    Local aArea     := FWGetArea()
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    Local aSai10    := {}
    Local X10       := 0    

    conout("INICIANDO JOBSAI 10")
    RPCSetEnv("01", "10")
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZF") + " ZZF WITH (NOLOCK) " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZF.D_E_L_E_T_ = '' AND ZZF_STATUS = '0' " + CRLF
    cQueryTab += "     AND ZZF_FILIAL IN ('10')  AND ZZF_VALOR > 0 " + CRLF
    cQueryTab += "     ORDER BY ZZF_VALOR DESC " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    WHILE !(QRY_TAB->(EOF()))
        AADD(aSai10, { QRY_TAB->ZZF_ZGRPEN, QRY_TAB->ZZF_ZEXTID,; 
                       QRY_TAB->ZZF_NUMNF,  QRY_TAB->ZZF_SERNFE,; 
                       QRY_TAB->ZZF_DTALTE, QRY_TAB->ZZF_CHVNF, ; 
                       QRY_TAB->ZZF_GRUPO,  QRY_TAB->ZZF_FILIAL, ; 
                       QRY_TAB->RECNO,      QRY_TAB->ZZF_CC     }) 
        QRY_TAB->(dbSkip())
        LOOP
    ENDDO	
    QRY_TAB->(DBCLOSEAREA())

    nConte  := 0
    FOR X10 := 1 TO lEN(aSai10)

        nConte++
        conout("LACO JOBSAI - " + aSai10[X10, 01])

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(aSai10[x10, 07]), "01", aSai10[x10, 07])
        cFilAt   := Iif(EMPTY(aSai10[x10, 08]), "10", aSai10[x10, 08])

        cEmpAnt  := cEmpAt
        cFilAnt  := cFilAt

        cEnum    := aSai10[x10, 01 ]
        cExter   := aSai10[x10, 02 ]
        cDoc     := aSai10[x10, 03 ]
        cSeri    := aSai10[x10, 04 ]
        dAltVct  := aSai10[x10, 05 ]
        cChavNfe := aSai10[x10, 06 ]
        nRecn    := aSai10[x10, 09 ]
        cCentCus := aSai10[x10, 10 ]

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
    NEXT	

    RestArea(aArea)
    CONOUT("FINALIZOUJOB NFS - 10")
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOBS10_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        //MemoWrite(cDirLog + cArqLog, cLog)
    endif


Return

User Function JOBSAI11()
    Local cQueryTab := ""
    Local aRetGrv   := {}
    Local aArea     := FWGetArea()
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    Local aSai11    := {}
    Local X11       := 0

    conout("INICIANDO JOBSAI 11")
    RPCSetEnv("01", "11")
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZF") + " ZZF WITH (NOLOCK) " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZF.D_E_L_E_T_ = '' AND ZZF_STATUS = '0' " + CRLF
    cQueryTab += "     AND ZZF_FILIAL IN ('11')  AND ZZF_VALOR > 0 " + CRLF
    cQueryTab += "     ORDER BY ZZF_VALOR DESC " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    WHILE !(QRY_TAB->(EOF()))
        AADD(aSai11, { QRY_TAB->ZZF_ZGRPEN, QRY_TAB->ZZF_ZEXTID,; 
                       QRY_TAB->ZZF_NUMNF,  QRY_TAB->ZZF_SERNFE,; 
                       QRY_TAB->ZZF_DTALTE, QRY_TAB->ZZF_CHVNF, ; 
                       QRY_TAB->ZZF_GRUPO,  QRY_TAB->ZZF_FILIAL, ; 
                       QRY_TAB->RECNO,      QRY_TAB->ZZF_CC     }) 
        QRY_TAB->(dbSkip())
        LOOP
    ENDDO	
    QRY_TAB->(DBCLOSEAREA())

    nConte := 0
    FOR X11 := 1 TO lEN(aSai11)

        nConte++
        conout("LACO JOBSAI - " + aSai11[X11, 01])

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(aSai11[x11, 07]), "01", aSai11[x11, 07])
        cFilAt   := Iif(EMPTY(aSai11[x11, 08]), "11", aSai11[x11, 08])

        cEmpAnt  := cEmpAt
        cFilAnt  := cFilAt

        cEnum    := aSai11[x11, 01 ]
        cExter   := aSai11[x11, 02 ]
        cDoc     := aSai11[x11, 03 ]
        cSeri    := aSai11[x11, 04 ]
        dAltVct  := aSai11[x11, 05 ]
        cChavNfe := aSai11[x11, 06 ]
        nRecn    := aSai11[x11, 09 ]
        cCentCus := aSai11[x11, 10 ]
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
    NEXT	

    RestArea(aArea)
    CONOUT("FINALIZOUJOB NFS - 11")
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOBS11_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        //MemoWrite(cDirLog + cArqLog, cLog)
    endif

Return

User Function JOBSAI12()
    Local cQueryTab := ""
    Local aRetGrv   := {}
    Local aArea     := FWGetArea()
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    Local aSai12    := {}
    Local X12       := 0

    conout("INICIANDO JOBSAI 12")
    
    RPCSetEnv("01", "12")
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZF") + " ZZF WITH (NOLOCK) " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZF.D_E_L_E_T_ = '' AND ZZF_STATUS = '0' " + CRLF
    cQueryTab += "     AND ZZF_FILIAL IN ('12')  AND ZZF_VALOR > 0 " + CRLF
    cQueryTab += "     ORDER BY ZZF_VALOR DESC " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    WHILE !(QRY_TAB->(EOF()))
        AADD(aSai12, { QRY_TAB->ZZF_ZGRPEN, QRY_TAB->ZZF_ZEXTID,; 
                       QRY_TAB->ZZF_NUMNF,  QRY_TAB->ZZF_SERNFE,; 
                       QRY_TAB->ZZF_DTALTE, QRY_TAB->ZZF_CHVNF, ; 
                       QRY_TAB->ZZF_GRUPO,  QRY_TAB->ZZF_FILIAL, ; 
                       QRY_TAB->RECNO,      QRY_TAB->ZZF_CC     }) 
        QRY_TAB->(dbSkip())
        LOOP
    ENDDO	
    QRY_TAB->(DBCLOSEAREA())

    nConte  := 0
    FOR X12 := 1 TO lEN(aSai12)    

        nConte++
        conout("LACO JOBSAI - " + aSai12[X12, 01])

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(aSai12[x12, 07]), "01", aSai12[x12, 07])
        cFilAt   := Iif(EMPTY(aSai12[x12, 08]), "12", aSai12[x12, 08])

        cEmpAnt  := cEmpAt
        cFilAnt  := cFilAt

        cEnum    := aSai12[x12, 01 ]
        cExter   := aSai12[x12, 02 ]
        cDoc     := aSai12[x12, 03 ]
        cSeri    := aSai12[x12, 04 ]
        dAltVct  := aSai12[x12, 05 ]
        cChavNfe := aSai12[x12, 06 ]
        nRecn    := aSai12[x12, 09 ]
        cCentCus := aSai12[x12, 10 ]

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
    NEXT	

    RestArea(aArea)
    CONOUT("FINALIZOUJOB NFS - 12")
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOBS12_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        //MemoWrite(cDirLog + cArqLog, cLog)
    endif

Return

User Function JOBSAI13()
    Local cQueryTab := ""
    Local aRetGrv   := {}
    Local aArea     := FWGetArea()
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    Local aSai13    := {}
    Local X13       := 0

    conout("INICIANDO JOBSAI 13")
    RPCSetEnv("01", "13")
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZF") + " ZZF WITH (NOLOCK) " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZF.D_E_L_E_T_ = '' AND ZZF_STATUS = '0' " + CRLF
    cQueryTab += "     AND ZZF_FILIAL IN ('13')  AND ZZF_VALOR > 0 " + CRLF
    cQueryTab += "     ORDER BY ZZF_VALOR DESC " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    WHILE !(QRY_TAB->(EOF()))
        AADD(aSai13, { QRY_TAB->ZZF_ZGRPEN, QRY_TAB->ZZF_ZEXTID,; 
                       QRY_TAB->ZZF_NUMNF,  QRY_TAB->ZZF_SERNFE,; 
                       QRY_TAB->ZZF_DTALTE, QRY_TAB->ZZF_CHVNF, ; 
                       QRY_TAB->ZZF_GRUPO,  QRY_TAB->ZZF_FILIAL, ; 
                       QRY_TAB->RECNO,      QRY_TAB->ZZF_CC     }) 
        QRY_TAB->(dbSkip())
        LOOP
    ENDDO	
    QRY_TAB->(DBCLOSEAREA())

    nConte := 0
    FOR X13 := 1 TO lEN(aSai13)    

        nConte++
        conout("LACO JOBSAI - " + aSai13[X13, 01])

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(aSai13[x13, 07]), "01", aSai13[x13, 07])
        cFilAt   := Iif(EMPTY(aSai13[x13, 08]), "13", aSai13[x13, 08])

        cEmpAnt  := cEmpAt
        cFilAnt  := cFilAt

        cEnum    := aSai13[x13, 01 ]
        cExter   := aSai13[x13, 02 ]
        cDoc     := aSai13[x13, 03 ]
        cSeri    := aSai13[x13, 04 ]
        dAltVct  := aSai13[x13, 05 ]
        cChavNfe := aSai13[x13, 06 ]
        nRecn    := aSai13[x13, 09 ]
        cCentCus := aSai13[x13, 10 ]

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
    NEXT	

    RestArea(aArea)
    CONOUT("FINALIZOUJOB NFS - 13")
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOBS13_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        //MemoWrite(cDirLog + cArqLog, cLog)
    endif

Return

User Function JOBSAI14()
    Local cQueryTab := ""
    Local aRetGrv   := {}
    Local aArea     := FWGetArea()
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    Local aSai14    := {}
    Local X14       := 0

    conout("INICIANDO JOBSAI 14")
    RPCSetEnv("01", "14")
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZF") + " ZZF WITH (NOLOCK) " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZF.D_E_L_E_T_ = '' AND ZZF_STATUS = '0' " + CRLF
    cQueryTab += "     AND ZZF_FILIAL IN ('14')  AND ZZF_VALOR > 0 " + CRLF
    cQueryTab += "     ORDER BY ZZF_VALOR DESC " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    WHILE !(QRY_TAB->(EOF()))
        AADD(aSai14, { QRY_TAB->ZZF_ZGRPEN, QRY_TAB->ZZF_ZEXTID,; 
                       QRY_TAB->ZZF_NUMNF,  QRY_TAB->ZZF_SERNFE,; 
                       QRY_TAB->ZZF_DTALTE, QRY_TAB->ZZF_CHVNF, ; 
                       QRY_TAB->ZZF_GRUPO,  QRY_TAB->ZZF_FILIAL, ; 
                       QRY_TAB->RECNO,      QRY_TAB->ZZF_CC     }) 
        QRY_TAB->(dbSkip())
        LOOP
    ENDDO	
    QRY_TAB->(DBCLOSEAREA())

    nConte  := 0
    FOR X14 := 1 TO lEN(aSai14)
        nConte++
        conout("LACO JOBSAI - " + aSai14[X14, 01])

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(aSai14[x14, 07]), "01", aSai14[x14, 07])
        cFilAt   := Iif(EMPTY(aSai14[x14, 08]), "14", aSai14[x14, 08])

        cEmpAnt  := cEmpAt
        cFilAnt  := cFilAt

        cEnum    := aSai14[x14, 01 ]
        cExter   := aSai14[x14, 02 ]
        cDoc     := aSai14[x14, 03 ]
        cSeri    := aSai14[x14, 04 ]
        dAltVct  := aSai14[x14, 05 ]
        cChavNfe := aSai14[x14, 06 ]
        nRecn    := aSai14[x14, 09 ]
        cCentCus := aSai14[x14, 10 ]
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
    NEXT	

    RestArea(aArea)
    CONOUT("FINALIZOUJOB NFS - 14")
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOBS14_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        //MemoWrite(cDirLog + cArqLog, cLog)
    endif

Return

User Function JOBSAI15()
    Local cQueryTab := ""
    Local aRetGrv   := {}
    Local aArea     := FWGetArea()
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    Local aSai15    := {}
    Local X15       := 0
    
    conout("INICIANDO JOBSAI 15")
    RPCSetEnv("01", "15")
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZF") + " ZZF WITH (NOLOCK) " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZF.D_E_L_E_T_ = '' AND ZZF_STATUS = '0' " + CRLF
    cQueryTab += "     AND ZZF_FILIAL IN ('15')  AND ZZF_VALOR > 0 " + CRLF
    cQueryTab += "     ORDER BY ZZF_VALOR DESC " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    WHILE !(QRY_TAB->(EOF()))
        AADD(aSai15, { QRY_TAB->ZZF_ZGRPEN, QRY_TAB->ZZF_ZEXTID,; 
                       QRY_TAB->ZZF_NUMNF,  QRY_TAB->ZZF_SERNFE,; 
                       QRY_TAB->ZZF_DTALTE, QRY_TAB->ZZF_CHVNF, ; 
                       QRY_TAB->ZZF_GRUPO,  QRY_TAB->ZZF_FILIAL, ; 
                       QRY_TAB->RECNO,      QRY_TAB->ZZF_CC     }) 
        QRY_TAB->(dbSkip())
        LOOP
    ENDDO	
    QRY_TAB->(DBCLOSEAREA())

    nConte  := 0
    FOR X15 := 1 TO lEN(aSai15)

        nConte++
        conout("LACO JOBSAI - " + aSai15[X15, 01])

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(aSai15[x15, 07]), "01", aSai15[x15, 07])
        cFilAt   := Iif(EMPTY(aSai15[x15, 08]), "15", aSai15[x15, 08])

        cEmpAnt  := cEmpAt
        cFilAnt  := cFilAt

        cEnum    := aSai15[x15, 01 ]
        cExter   := aSai15[x15, 02 ]
        cDoc     := aSai15[x15, 03 ]
        cSeri    := aSai15[x15, 04 ]
        dAltVct  := aSai15[x15, 05 ]
        cChavNfe := aSai15[x15, 06 ]
        nRecn    := aSai15[x15, 09 ]
        cCentCus := aSai15[x15, 10 ]
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
    NEXT	

    RestArea(aArea)
    CONOUT("FINALIZOUJOB NFS - 15")
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOBS15_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        //MemoWrite(cDirLog + cArqLog, cLog)
    endif

Return

User Function JOBSAI16()
    Local cQueryTab := ""
    Local aRetGrv   := {}
    Local aArea     := FWGetArea()
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    Local aSai16    := {}
    Local X16       := 0    

    conout("INICIANDO JOBSAI 16")
    RPCSetEnv("01", "16")
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZF") + " ZZF  WITH (NOLOCK) " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZF.D_E_L_E_T_ = '' AND ZZF_STATUS = '0' " + CRLF
    cQueryTab += "     AND ZZF_FILIAL IN ('16')  AND ZZF_VALOR > 0 " + CRLF
    cQueryTab += "     ORDER BY ZZF_VALOR DESC " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'
    
    WHILE !(QRY_TAB->(EOF()))
        AADD(aSai16, { QRY_TAB->ZZF_ZGRPEN, QRY_TAB->ZZF_ZEXTID,; 
                       QRY_TAB->ZZF_NUMNF,  QRY_TAB->ZZF_SERNFE,; 
                       QRY_TAB->ZZF_DTALTE, QRY_TAB->ZZF_CHVNF, ; 
                       QRY_TAB->ZZF_GRUPO,  QRY_TAB->ZZF_FILIAL, ; 
                       QRY_TAB->RECNO,      QRY_TAB->ZZF_CC     }) 
        QRY_TAB->(dbSkip())
        LOOP
    ENDDO	
    QRY_TAB->(DBCLOSEAREA())    

    nConte := 0
    FOR X16 := 1 TO lEN(aSai16)

        nConte++
        conout("LACO JOBSAI - " + aSai16[X16, 01])

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(aSai16[x16, 07]), "01", aSai16[x16, 07])
        cFilAt   := Iif(EMPTY(aSai16[x16, 08]), "16", aSai16[x16, 08])

        cEmpAnt  := cEmpAt
        cFilAnt  := cFilAt

        cEnum    := aSai16[x16, 01 ]
        cExter   := aSai16[x16, 02 ]
        cDoc     := aSai16[x16, 03 ]
        cSeri    := aSai16[x16, 04 ]
        dAltVct  := aSai16[x16, 05 ]
        cChavNfe := aSai16[x16, 06 ]
        nRecn    := aSai16[x16, 09 ]
        cCentCus := aSai16[x16, 10 ]
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
    NEXT	

    RestArea(aArea)
    CONOUT("FINALIZOUJOB NFS - 16")
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOBS16_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        //MemoWrite(cDirLog + cArqLog, cLog)
    endif

Return

User Function JOBSAI17()
    Local cQueryTab := ""
    Local aRetGrv   := {}
    Local aArea     := FWGetArea()
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    Local aSai17    := {}
    Local X17       := 0

    conout("INICIANDO JOBSAI 17")
    RPCSetEnv("01", "17")
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZF") + " ZZF  WITH (NOLOCK) " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZF.D_E_L_E_T_ = '' AND ZZF_STATUS = '0' " + CRLF
    cQueryTab += "     AND ZZF_FILIAL IN ('17')  AND ZZF_VALOR > 0 " + CRLF
    cQueryTab += "     ORDER BY ZZF_VALOR DESC " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    WHILE !(QRY_TAB->(EOF()))
        AADD(aSai17, { QRY_TAB->ZZF_ZGRPEN, QRY_TAB->ZZF_ZEXTID,; 
                       QRY_TAB->ZZF_NUMNF,  QRY_TAB->ZZF_SERNFE,; 
                       QRY_TAB->ZZF_DTALTE, QRY_TAB->ZZF_CHVNF, ; 
                       QRY_TAB->ZZF_GRUPO,  QRY_TAB->ZZF_FILIAL, ; 
                       QRY_TAB->RECNO,      QRY_TAB->ZZF_CC     }) 
        QRY_TAB->(dbSkip())
        LOOP
    ENDDO	
    QRY_TAB->(DBCLOSEAREA())

    nConte  := 0
    FOR X17 := 1 TO lEN(aSai17)

        nConte++
        conout("LACO JOBSAI - " + aSai17[X17, 01])

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(aSai17[x17, 07]), "01", aSai17[x17, 07])
        cFilAt   := Iif(EMPTY(aSai17[x17, 08]), "17", aSai17[x17, 08])

        cEmpAnt  := cEmpAt
        cFilAnt  := cFilAt

        cEnum    := aSai17[x17, 01 ]
        cExter   := aSai17[x17, 02 ]
        cDoc     := aSai17[x17, 03 ]
        cSeri    := aSai17[x17, 04 ]
        dAltVct  := aSai17[x17, 05 ]
        cChavNfe := aSai17[x17, 06 ]
        nRecn    := aSai17[x17, 09 ]
        cCentCus := aSai17[x17, 10 ]

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
    NEXT	

    RestArea(aArea)
    CONOUT("FINALIZOUJOB NFS - 17")
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOBS17_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        //MemoWrite(cDirLog + cArqLog, cLog)
    endif

Return

User Function JOBSAI18()
    Local cQueryTab := ""
    Local aRetGrv   := {}
    Local aArea     := FWGetArea()
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    Local aSai18    := {}
    Local X18       := 0
    
    conout("INICIANDO JOBSAI 18")
    RPCSetEnv("01", "18")
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZF") + " ZZF  WITH (NOLOCK) " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZF.D_E_L_E_T_ = '' AND ZZF_STATUS = '0' " + CRLF
    cQueryTab += "     AND ZZF_FILIAL IN ('18')  AND ZZF_VALOR > 0 " + CRLF
    cQueryTab += "     ORDER BY ZZF_VALOR DESC " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    WHILE !(QRY_TAB->(EOF()))
        AADD(aSai18, { QRY_TAB->ZZF_ZGRPEN, QRY_TAB->ZZF_ZEXTID,; 
                       QRY_TAB->ZZF_NUMNF,  QRY_TAB->ZZF_SERNFE,; 
                       QRY_TAB->ZZF_DTALTE, QRY_TAB->ZZF_CHVNF, ; 
                       QRY_TAB->ZZF_GRUPO,  QRY_TAB->ZZF_FILIAL, ; 
                       QRY_TAB->RECNO,      QRY_TAB->ZZF_CC     }) 
        QRY_TAB->(dbSkip())
        LOOP
    ENDDO	
    QRY_TAB->(DBCLOSEAREA())

    nConte  := 0
    FOR X18 := 1 TO lEN(aSai18)

        nConte++
        conout("LACO JOBSAI - " + aSai18[X18, 01])

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(aSai18[x18, 07]), "01", aSai18[x18, 07])
        cFilAt   := Iif(EMPTY(aSai18[x18, 08]), "18", aSai18[x18, 08])

        cEmpAnt  := cEmpAt
        cFilAnt  := cFilAt

        cEnum    := aSai18[x18, 01 ]
        cExter   := aSai18[x18, 02 ]
        cDoc     := aSai18[x18, 03 ]
        cSeri    := aSai18[x18, 04 ]
        dAltVct  := aSai18[x18, 05 ]
        cChavNfe := aSai18[x18, 06 ]
        nRecn    := aSai18[x18, 09 ]
        cCentCus := aSai18[x18, 10 ]

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
    NEXT	

    RestArea(aArea)
    CONOUT("FINALIZOUJOB NFS - 18")
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOBS18_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        //MemoWrite(cDirLog + cArqLog, cLog)
    endif

Return

User Function JOBSAI19()
    Local cQueryTab := ""
    Local aRetGrv   := {}
    Local aArea     := FWGetArea()
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    Local aSai19    := {}
    Local X19       := 0
    
    conout("INICIANDO JOBSAI 19")
    RPCSetEnv("01", "19")
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZF") + " ZZF  WITH (NOLOCK) " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZF.D_E_L_E_T_ = '' AND ZZF_STATUS = '0' " + CRLF
    cQueryTab += "     AND ZZF_FILIAL IN ('19')  AND ZZF_VALOR > 0 " + CRLF
    cQueryTab += "     ORDER BY ZZF_VALOR DESC " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    WHILE !(QRY_TAB->(EOF()))
        AADD(aSai19, { QRY_TAB->ZZF_ZGRPEN, QRY_TAB->ZZF_ZEXTID,; 
                       QRY_TAB->ZZF_NUMNF,  QRY_TAB->ZZF_SERNFE,; 
                       QRY_TAB->ZZF_DTALTE, QRY_TAB->ZZF_CHVNF, ; 
                       QRY_TAB->ZZF_GRUPO,  QRY_TAB->ZZF_FILIAL, ; 
                       QRY_TAB->RECNO,      QRY_TAB->ZZF_CC     }) 
        QRY_TAB->(dbSkip())
        LOOP
    ENDDO	
    QRY_TAB->(DBCLOSEAREA())

    nConte  := 0
    FOR X19 := 1 TO lEN(aSai19)

        nConte++
        conout("LACO JOBSAI - " + aSai19[X19, 01])

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(aSai19[x19, 07]), "01", aSai19[x19, 07])
        cFilAt   := Iif(EMPTY(aSai19[x19, 08]), "20", aSai19[x19, 08])

        cEmpAnt  := cEmpAt
        cFilAnt  := cFilAt

        cEnum    := aSai19[x19, 01 ]
        cExter   := aSai19[x19, 02 ]
        cDoc     := aSai19[x19, 03 ]
        cSeri    := aSai19[x19, 04 ]
        dAltVct  := aSai19[x19, 05 ]
        cChavNfe := aSai19[x19, 06 ]
        nRecn    := aSai19[x19, 09 ]
        cCentCus := aSai19[x19, 10 ]

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
    NEXT	

    RestArea(aArea)
    CONOUT("FINALIZOUJOB NFS - 19")
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOBS19_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        //MemoWrite(cDirLog + cArqLog, cLog)
    endif

Return

User Function JOBSAI20()
    Local cQueryTab := ""
    Local aRetGrv   := {}
    Local aArea     := FWGetArea()
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'    

    Local aSai20    := {}
    Local X20       := 0
    
    conout("INICIANDO JOBSAI 20")
    RPCSetEnv("01", "20")
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZF") + " ZZF WITH (NOLOCK) " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZF.D_E_L_E_T_ = '' AND ZZF_STATUS = '0' " + CRLF
    cQueryTab += "     AND ZZF_FILIAL IN ('20')  AND ZZF_VALOR > 0 " + CRLF
    cQueryTab += "     ORDER BY ZZF_VALOR DESC " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    WHILE !(QRY_TAB->(EOF()))
        AADD(aSai20, { QRY_TAB->ZZF_ZGRPEN, QRY_TAB->ZZF_ZEXTID,; 
                       QRY_TAB->ZZF_NUMNF,  QRY_TAB->ZZF_SERNFE,; 
                       QRY_TAB->ZZF_DTALTE, QRY_TAB->ZZF_CHVNF, ; 
                       QRY_TAB->ZZF_GRUPO,  QRY_TAB->ZZF_FILIAL, ; 
                       QRY_TAB->RECNO,      QRY_TAB->ZZF_CC     }) 
        QRY_TAB->(dbSkip())
        LOOP
    ENDDO	
    QRY_TAB->(DBCLOSEAREA())

    nConte := 0
    FOR X20 := 1 TO lEN(aSai20)

        nConte++
        conout("LACO JOBSAI - " + aSai20[X20, 01])

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(aSai20[x20, 07]), "01", aSai20[x20, 07])
        cFilAt   := Iif(EMPTY(aSai20[x20, 08]), "20", aSai20[x20, 08])

        cEmpAnt  := cEmpAt
        cFilAnt  := cFilAt

        cEnum    := aSai20[x20, 01 ]
        cExter   := aSai20[x20, 02 ]
        cDoc     := aSai20[x20, 03 ]
        cSeri    := aSai20[x20, 04 ]
        dAltVct  := aSai20[x20, 05 ]
        cChavNfe := aSai20[x20, 06 ]
        nRecn    := aSai20[x20, 09 ]
        cCentCus := aSai20[x20, 10 ]

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
    NEXT	

    RestArea(aArea)
    CONOUT("FINALIZOUJOB NFS - 20")
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOBS20_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        //MemoWrite(cDirLog + cArqLog, cLog)
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

    Local aEnt01    := {}
    Local YY        := 0

    RPCSetEnv("01", "01")

    conout("INICIANDO JOBENTRADA 01" )
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT TOP 20 *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZE") + " ZZE WITH (NOLOCK)" + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZE.D_E_L_E_T_ = '' AND ZZE_STATUS IN ('9', '0') " + CRLF
    cQueryTab += "     AND ZZE_FILIAL IN ('01') " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    WHILE !(QRY_TAB->(EOF()))
        AADD(aEnt01, { QRY_TAB->ZZE_ZGRPEN, QRY_TAB->ZZE_ZEXTID,; 
                       QRY_TAB->ZZE_NUMNF,  QRY_TAB->ZZE_SERNFE,; 
                       QRY_TAB->ZZE_DTALTE, QRY_TAB->ZZE_CHVNF, ; 
                       QRY_TAB->ZZE_GRUPO,  QRY_TAB->ZZE_FILIAL, ; 
                       QRY_TAB->RECNO,      QRY_TAB->ZZE_CC, ; 
                       QRY_TAB->ZZE_CNPJFO }) 
        QRY_TAB->(dbSkip())
        LOOP
    ENDDO	
    QRY_TAB->(DBCLOSEAREA())

    nConte := 0
    FOR YY := 1 TO lEN(aEnt01)  

        nResult := Val(substr(Time(),1,2))
        nConte++
        conout("LACO JOBNFE - 01 " + aEnt01[YY, 02])

        _CNPJCPF:= IIF(EMPTY(aEnt01[YY, 11]), Substr( aEnt01[YY, 06],7, 14), aEnt01[YY, 11])
        lTemFor := ows:temFornec(FWxFilial("SA2"), _CNPJCPF)

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(aEnt01[YY, 07]), "01", aEnt01[YY, 07])
        cFilAt   := Iif(EMPTY(aEnt01[YY, 08]), "01", aEnt01[YY, 08])

        cEmpAnt  := cEmpAt
        cFilAnt  := cFilAt

        cEnum    := aEnt01[YY, 01]
        cExter   := aEnt01[YY, 02]
        cDoc     := aEnt01[YY, 03]
        cSeri    := aEnt01[YY, 04]
        dAltVct  := aEnt01[YY, 05]
        cChavNfe := aEnt01[YY, 06]
        nRecn    := aEnt01[YY, 09]
        cCentCus := aEnt01[YY, 10]
        
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
    NEXT	

    conout("FINALIZOU JOBNFE - 01")
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOB01_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        //MemoWrite(cDirLog + cArqLog, cLog)
    endif

    ConOut(OemToAnsi("Fim : ")+Time())

Return

User Function JOBENT02()
    Local cQueryTab := ""
    Local nConte    := 0
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    Local aEnt02    := {}
    Local Y2        := 0

    RPCSetEnv("01", "02")

    conout("INICIANDO JOBENTRADA 02" )
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT TOP 20 *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZE") + " ZZE WITH (NOLOCK) " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZE.D_E_L_E_T_ = '' AND ZZE_STATUS IN ('9', '0') " + CRLF
    cQueryTab += "     AND ZZE_FILIAL IN ('02') " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    WHILE !(QRY_TAB->(EOF()))
        AADD(aEnt02, { QRY_TAB->ZZE_ZGRPEN, QRY_TAB->ZZE_ZEXTID,; 
                       QRY_TAB->ZZE_NUMNF,  QRY_TAB->ZZE_SERNFE,; 
                       QRY_TAB->ZZE_DTALTE, QRY_TAB->ZZE_CHVNF, ; 
                       QRY_TAB->ZZE_GRUPO,  QRY_TAB->ZZE_FILIAL, ; 
                       QRY_TAB->RECNO,      QRY_TAB->ZZE_CC, ; 
                       QRY_TAB->ZZE_CNPJFO }) 
        QRY_TAB->(dbSkip())
        LOOP
    ENDDO	
    QRY_TAB->(DBCLOSEAREA())

    nConte := 0
    FOR Y2 := 1 TO lEN(aEnt02)      
        nResult := Val(substr(Time(),1,2))
        nConte++
        conout("LACO JOBNFE - 01 " + aEnt02[Y2, 02])

        _CNPJCPF:= IIF(EMPTY(aEnt02[Y2, 11]), Substr( aEnt02[Y2, 06],7, 14), aEnt02[Y2, 11])
        lTemFor := ows:temFornec(FWxFilial("SA2"), _CNPJCPF)

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(aEnt02[Y2, 07]), "01", aEnt02[Y2, 07])
        cFilAt   := Iif(EMPTY(aEnt02[Y2, 08]), "02", aEnt02[Y2, 08])

        cEmpAnt  := cEmpAt
        cFilAnt  := cFilAt

        cEnum    := aEnt02[Y2, 01]
        cExter   := aEnt02[Y2, 02]
        cDoc     := aEnt02[Y2, 03]
        cSeri    := aEnt02[Y2, 04]
        dAltVct  := aEnt02[Y2, 05]
        cChavNfe := aEnt02[Y2, 06]
        nRecn    := aEnt02[Y2, 09]
        cCentCus := aEnt02[Y2, 10]
        
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

    NEXT	

    conout("FINALIZOU JOBNFE - 02")
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOB02_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        //MemoWrite(cDirLog + cArqLog, cLog)
    Endif

    ConOut(OemToAnsi("Fim : ")+Time())

Return

User Function JOBENT03()
    Local cQueryTab := ""
    Local nConte    := 0
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'
    
    Local aEnt03    := {}
    Local Y3        := 0    

    RPCSetEnv("01", "03")

    conout("INICIANDO JOBENTRADA 03" )
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT TOP 20 *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZE") + " ZZE WITH (NOLOCK) " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZE.D_E_L_E_T_ = '' AND ZZE_STATUS IN ('9', '0') " + CRLF
    cQueryTab += "     AND ZZE_FILIAL IN ('03') " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    WHILE !(QRY_TAB->(EOF()))
        AADD(aEnt03, { QRY_TAB->ZZE_ZGRPEN, QRY_TAB->ZZE_ZEXTID,; 
                       QRY_TAB->ZZE_NUMNF,  QRY_TAB->ZZE_SERNFE,; 
                       QRY_TAB->ZZE_DTALTE, QRY_TAB->ZZE_CHVNF, ; 
                       QRY_TAB->ZZE_GRUPO,  QRY_TAB->ZZE_FILIAL, ; 
                       QRY_TAB->RECNO,      QRY_TAB->ZZE_CC, ; 
                       QRY_TAB->ZZE_CNPJFO }) 
        QRY_TAB->(dbSkip())
        LOOP
    ENDDO	
    QRY_TAB->(DBCLOSEAREA())

    nConte := 0
    FOR Y3 := 1 TO lEN(aEnt03)  

        nConte++
        conout("LACO JOBNFE - 01 " + aEnt03[Y3, 02])

        _CNPJCPF:= IIF(EMPTY(aEnt03[Y3, 11]), Substr( aEnt03[Y3, 06],7, 14), aEnt03[Y3, 11])
        lTemFor := ows:temFornec(FWxFilial("SA2"), _CNPJCPF)

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(aEnt03[Y3, 07]), "01", aEnt03[Y3, 07])
        cFilAt   := Iif(EMPTY(aEnt03[Y3, 08]), "03", aEnt03[Y3, 08])

        cEmpAnt  := cEmpAt
        cFilAnt  := cFilAt

        cEnum    := aEnt03[Y3, 01]
        cExter   := aEnt03[Y3, 02]
        cDoc     := aEnt03[Y3, 03]
        cSeri    := aEnt03[Y3, 04]
        dAltVct  := aEnt03[Y3, 05]
        cChavNfe := aEnt03[Y3, 06]
        nRecn    := aEnt03[Y3, 09]
        cCentCus := aEnt03[Y3, 10]
        
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
    NEXT

    conout("FINALIZOU JOBNFE - 03")
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOB03_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        //MemoWrite(cDirLog + cArqLog, cLog)
    Endif

    ConOut(OemToAnsi("Fim : ")+Time())

Return

User Function JOBENT04()
    Local cQueryTab := ""
    Local nConte    := 0
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    Local aEnt04    := {}
    Local Y4        := 0

    RPCSetEnv("01", "04")

    conout("INICIANDO JOBENTRADA 04" )
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT TOP 20 *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZE") + " ZZE WITH (NOLOCK) " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZE.D_E_L_E_T_ = '' AND ZZE_STATUS IN ('9', '0') " + CRLF
    cQueryTab += "     AND ZZE_FILIAL IN ('04') " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    WHILE !(QRY_TAB->(EOF()))
        AADD(aEnt04, { QRY_TAB->ZZE_ZGRPEN, QRY_TAB->ZZE_ZEXTID,; 
                       QRY_TAB->ZZE_NUMNF,  QRY_TAB->ZZE_SERNFE,; 
                       QRY_TAB->ZZE_DTALTE, QRY_TAB->ZZE_CHVNF, ; 
                       QRY_TAB->ZZE_GRUPO,  QRY_TAB->ZZE_FILIAL, ; 
                       QRY_TAB->RECNO,      QRY_TAB->ZZE_CC, ; 
                       QRY_TAB->ZZE_CNPJFO }) 
        QRY_TAB->(dbSkip())
        LOOP
    ENDDO	
    QRY_TAB->(DBCLOSEAREA())

    nConte := 0
    FOR Y4 := 1 TO lEN(aEnt04)  

        nConte++
        conout("LACO JOBNFE - 01 " + aEnt04[Y4, 02])

        _CNPJCPF:= IIF(EMPTY(aEnt04[Y4, 11]), Substr( aEnt04[Y4, 06],7, 14), aEnt04[Y4, 11])
        lTemFor := ows:temFornec(FWxFilial("SA2"), _CNPJCPF)

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(aEnt04[Y4, 07]), "01", aEnt04[Y4, 07])
        cFilAt   := Iif(EMPTY(aEnt04[Y4, 08]), "04", aEnt04[Y4, 08])

        cEmpAnt  := cEmpAt
        cFilAnt  := cFilAt

        cEnum    := aEnt04[Y4, 01]
        cExter   := aEnt04[Y4, 02]
        cDoc     := aEnt04[Y4, 03]
        cSeri    := aEnt04[Y4, 04]
        dAltVct  := aEnt04[Y4, 05]
        cChavNfe := aEnt04[Y4, 06]
        nRecn    := aEnt04[Y4, 09]
        cCentCus := aEnt04[Y4, 10]
        
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
    NEXT

    conout("FINALIZOU JOBNFE - 04")

    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOB04_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        //MemoWrite(cDirLog + cArqLog, cLog)
    EndIF
    ConOut(OemToAnsi("Fim : ")+Time())

Return

User Function JOBENT05()
    Local cQueryTab := ""
    Local nConte    := 0
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    Local aEnt05    := {}
    Local Y5        := 0

    RPCSetEnv("01", "05")

    conout("INICIANDO JOBENTRADA 05" )
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT TOP 20 *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZE") + " ZZE WITH (NOLOCK) " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZE.D_E_L_E_T_ = '' AND ZZE_STATUS IN ('9', '0') " + CRLF
    cQueryTab += "     AND ZZE_FILIAL IN ('05') " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    WHILE !(QRY_TAB->(EOF()))
        AADD(aEnt05, { QRY_TAB->ZZE_ZGRPEN, QRY_TAB->ZZE_ZEXTID,; 
                       QRY_TAB->ZZE_NUMNF,  QRY_TAB->ZZE_SERNFE,; 
                       QRY_TAB->ZZE_DTALTE, QRY_TAB->ZZE_CHVNF, ; 
                       QRY_TAB->ZZE_GRUPO,  QRY_TAB->ZZE_FILIAL, ; 
                       QRY_TAB->RECNO,      QRY_TAB->ZZE_CC, ; 
                       QRY_TAB->ZZE_CNPJFO }) 
        QRY_TAB->(dbSkip())
        LOOP
    ENDDO	
    QRY_TAB->(DBCLOSEAREA())

    nConte := 0
    FOR Y5 := 1 TO lEN(aEnt05)  

        nConte++
        conout("LACO JOBNFE - 01 " + aEnt05[Y5, 02])

        _CNPJCPF:= IIF(EMPTY(aEnt05[Y5, 11]), Substr( aEnt05[Y5, 06],7, 14), aEnt05[Y5, 11])
        lTemFor := ows:temFornec(FWxFilial("SA2"), _CNPJCPF)

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(aEnt05[Y5, 07]), "01", aEnt05[Y5, 07])
        cFilAt   := Iif(EMPTY(aEnt05[Y5, 08]), "05", aEnt05[Y5, 08])

        cEmpAnt  := cEmpAt
        cFilAnt  := cFilAt

        cEnum    := aEnt05[Y5, 01]
        cExter   := aEnt05[Y5, 02]
        cDoc     := aEnt05[Y5, 03]
        cSeri    := aEnt05[Y5, 04]
        dAltVct  := aEnt05[Y5, 05]
        cChavNfe := aEnt05[Y5, 06]
        nRecn    := aEnt05[Y5, 09]
        cCentCus := aEnt05[Y5, 10]
        
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
    NEXT	

    conout("FINALIZOU JOBNFE - 05")
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOB05_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        //MemoWrite(cDirLog + cArqLog, cLog)
    EndIF
    ConOut(OemToAnsi("Fim : ")+Time())

Return

User Function JOBENT06()
    Local cQueryTab := ""
    Local nConte    := 0
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'


    Local aEnt06    := {}
    Local Y6        := 0

    RPCSetEnv("01", "06")

    conout("INICIANDO JOBENTRADA 06" )
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT  TOP 20 *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZE") + " ZZE WITH (NOLOCK) " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZE.D_E_L_E_T_ = '' AND ZZE_STATUS IN ('9', '0') " + CRLF
    cQueryTab += "     AND ZZE_FILIAL IN ('06') " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    WHILE !(QRY_TAB->(EOF()))
        AADD(aEnt06, { QRY_TAB->ZZE_ZGRPEN, QRY_TAB->ZZE_ZEXTID,; 
                       QRY_TAB->ZZE_NUMNF,  QRY_TAB->ZZE_SERNFE,; 
                       QRY_TAB->ZZE_DTALTE, QRY_TAB->ZZE_CHVNF, ; 
                       QRY_TAB->ZZE_GRUPO,  QRY_TAB->ZZE_FILIAL, ; 
                       QRY_TAB->RECNO,      QRY_TAB->ZZE_CC, ; 
                       QRY_TAB->ZZE_CNPJFO }) 
        QRY_TAB->(dbSkip())
        LOOP
    ENDDO	
    QRY_TAB->(DBCLOSEAREA())

    nConte := 0
    FOR Y6 := 1 TO lEN(aEnt06)  

        nConte++
        conout("LACO JOBNFE - 01 " + aEnt06[Y6, 02])

        _CNPJCPF:= IIF(EMPTY(aEnt06[Y6, 11]), Substr( aEnt06[Y6, 06],7, 14), aEnt06[Y6, 11])
        lTemFor := ows:temFornec(FWxFilial("SA2"), _CNPJCPF)

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(aEnt06[Y6, 07]), "01", aEnt06[Y6, 07])
        cFilAt   := Iif(EMPTY(aEnt06[Y6, 08]), "06", aEnt06[Y6, 08])

        cEmpAnt  := cEmpAt
        cFilAnt  := cFilAt

        cEnum    := aEnt06[Y6, 01]
        cExter   := aEnt06[Y6, 02]
        cDoc     := aEnt06[Y6, 03]
        cSeri    := aEnt06[Y6, 04]
        dAltVct  := aEnt06[Y6, 05]
        cChavNfe := aEnt06[Y6, 06]
        nRecn    := aEnt06[Y6, 09]
        cCentCus := aEnt06[Y6, 10]

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
    NEXT	

    conout("FINALIZOU JOBNFE - 06")
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOB06_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        //MemoWrite(cDirLog + cArqLog, cLog)
    EndIF
    ConOut(OemToAnsi("Fim : ")+Time())

Return

User Function JOBENT07()
    Local cQueryTab := ""
    Local nConte    := 0
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    Local aEnt07    := {}
    Local Y7        := 0

    RPCSetEnv("01", "07")

    conout("INICIANDO JOBENTRADA 07" )
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT  TOP 20 *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZE") + " ZZE WITH (NOLOCK) " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZE.D_E_L_E_T_ = '' AND ZZE_STATUS IN ('9', '0') " + CRLF
    cQueryTab += "     AND ZZE_FILIAL IN ('07') " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    WHILE !(QRY_TAB->(EOF()))
        AADD(aEnt07, { QRY_TAB->ZZE_ZGRPEN, QRY_TAB->ZZE_ZEXTID,; 
                       QRY_TAB->ZZE_NUMNF,  QRY_TAB->ZZE_SERNFE,; 
                       QRY_TAB->ZZE_DTALTE, QRY_TAB->ZZE_CHVNF, ; 
                       QRY_TAB->ZZE_GRUPO,  QRY_TAB->ZZE_FILIAL, ; 
                       QRY_TAB->RECNO,      QRY_TAB->ZZE_CC, ; 
                       QRY_TAB->ZZE_CNPJFO }) 
        QRY_TAB->(dbSkip())
        LOOP
    ENDDO	
    QRY_TAB->(DBCLOSEAREA())

    nConte := 0
    FOR Y7 := 1 TO lEN(aEnt07)  

        nConte++
        conout("LACO JOBNFE - 01 " + aEnt07[Y7, 02])

        _CNPJCPF:= IIF(EMPTY(aEnt07[Y7, 11]), Substr( aEnt07[Y7, 06],7, 14), aEnt07[Y7, 11])
        lTemFor := ows:temFornec(FWxFilial("SA2"), _CNPJCPF)

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(aEnt07[Y7, 07]), "01", aEnt07[Y7, 07])
        cFilAt   := Iif(EMPTY(aEnt07[Y7, 08]), "07", aEnt07[Y7, 08])

        cEmpAnt  := cEmpAt
        cFilAnt  := cFilAt

        cEnum    := aEnt07[Y7, 01]
        cExter   := aEnt07[Y7, 02]
        cDoc     := aEnt07[Y7, 03]
        cSeri    := aEnt07[Y7, 04]
        dAltVct  := aEnt07[Y7, 05]
        cChavNfe := aEnt07[Y7, 06]
        nRecn    := aEnt07[Y7, 09]
        cCentCus := aEnt07[Y7, 10]
        
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
    NEXT	
    conout("FINALIZOU JOBNFE - 07")
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOB07_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        //MemoWrite(cDirLog + cArqLog, cLog)
    EndIF
    ConOut(OemToAnsi("Fim : ")+Time())

Return

User Function JOBENT08()
    Local cQueryTab := ""
    Local nConte    := 0
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    Local aEnt08    := {}
    Local Y8        := 0

    RPCSetEnv("01", "08")

    conout("INICIANDO JOBENTRADA 08" )
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT  TOP 20 *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZE") + " ZZE WITH (NOLOCK) " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZE.D_E_L_E_T_ = '' AND ZZE_STATUS IN ('9', '0') " + CRLF
    cQueryTab += "     AND ZZE_FILIAL IN ('08') " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    WHILE !(QRY_TAB->(EOF()))
        AADD(aEnt08, { QRY_TAB->ZZE_ZGRPEN, QRY_TAB->ZZE_ZEXTID,; 
                       QRY_TAB->ZZE_NUMNF,  QRY_TAB->ZZE_SERNFE,; 
                       QRY_TAB->ZZE_DTALTE, QRY_TAB->ZZE_CHVNF, ; 
                       QRY_TAB->ZZE_GRUPO,  QRY_TAB->ZZE_FILIAL, ; 
                       QRY_TAB->RECNO,      QRY_TAB->ZZE_CC, ; 
                       QRY_TAB->ZZE_CNPJFO }) 
        QRY_TAB->(dbSkip())
        LOOP
    ENDDO	
    QRY_TAB->(DBCLOSEAREA())

    nConte := 0
    FOR Y8 := 1 TO lEN(aEnt08)  

        nConte++
        conout("LACO JOBNFE - 01 " + aEnt08[Y8, 02])

        _CNPJCPF:= IIF(EMPTY(aEnt08[Y8, 11]), Substr( aEnt08[Y8, 06],7, 14), aEnt08[Y8, 11])
        lTemFor := ows:temFornec(FWxFilial("SA2"), _CNPJCPF)

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(aEnt08[Y8, 07]), "01", aEnt08[Y8, 07])
        cFilAt   := Iif(EMPTY(aEnt08[Y8, 08]), "08", aEnt08[Y8, 08])

        cEmpAnt  := cEmpAt
        cFilAnt  := cFilAt

        cEnum    := aEnt08[Y8, 01]
        cExter   := aEnt08[Y8, 02]
        cDoc     := aEnt08[Y8, 03]
        cSeri    := aEnt08[Y8, 04]
        dAltVct  := aEnt08[Y8, 05]
        cChavNfe := aEnt08[Y8, 06]
        nRecn    := aEnt08[Y8, 09]
        cCentCus := aEnt08[Y8, 10]
        
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
    NEXT	
    conout("FINALIZOU JOBNFE - 08")
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOB08_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        ////MemoWrite(cDirLog + cArqLog, cLog)
    EndiF

    ConOut(OemToAnsi("Fim : ")+Time())

Return

User Function JOBENT09()
    Local cQueryTab := ""
    Local nConte    := 0
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    Local aEnt09    := {}
    Local Y9        := 0

    RPCSetEnv("01", "09")

    conout("INICIANDO JOBENTRADA 09" )
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT  TOP 20 *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZE") + " ZZE WITH (NOLOCK) " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZE.D_E_L_E_T_ = '' AND ZZE_STATUS IN ('9', '0') " + CRLF
    cQueryTab += "     AND ZZE_FILIAL IN ('09') " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    WHILE !(QRY_TAB->(EOF()))
        AADD(aEnt09, { QRY_TAB->ZZE_ZGRPEN, QRY_TAB->ZZE_ZEXTID,; 
                       QRY_TAB->ZZE_NUMNF,  QRY_TAB->ZZE_SERNFE,; 
                       QRY_TAB->ZZE_DTALTE, QRY_TAB->ZZE_CHVNF, ; 
                       QRY_TAB->ZZE_GRUPO,  QRY_TAB->ZZE_FILIAL, ; 
                       QRY_TAB->RECNO,      QRY_TAB->ZZE_CC, ; 
                       QRY_TAB->ZZE_CNPJFO }) 
        QRY_TAB->(dbSkip())
        LOOP
    ENDDO	
    QRY_TAB->(DBCLOSEAREA())

    nConte := 0
    FOR Y9 := 1 TO lEN(aEnt09)  

        nConte++
        conout("LACO JOBNFE - 01 " + aEnt09[Y9, 02])

        _CNPJCPF:= IIF(EMPTY(aEnt09[Y9, 11]), Substr( aEnt09[Y9, 06],7, 14), aEnt09[Y9, 11])
        lTemFor := ows:temFornec(FWxFilial("SA2"), _CNPJCPF)

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(aEnt09[Y9, 07]), "01", aEnt09[Y9, 07])
        cFilAt   := Iif(EMPTY(aEnt09[Y9, 08]), "09", aEnt09[Y9, 08])

        cEmpAnt  := cEmpAt
        cFilAnt  := cFilAt

        cEnum    := aEnt09[Y9, 01]
        cExter   := aEnt09[Y9, 02]
        cDoc     := aEnt09[Y9, 03]
        cSeri    := aEnt09[Y9, 04]
        dAltVct  := aEnt09[Y9, 05]
        cChavNfe := aEnt09[Y9, 06]
        nRecn    := aEnt09[Y9, 09]
        cCentCus := aEnt09[Y9, 10]
        
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

    NEXT	
    conout("FINALIZOU JOBNFE - 09")
    
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOB09_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        //MemoWrite(cDirLog + cArqLog, cLog)
    EndiF
    ConOut(OemToAnsi("Fim : ")+Time())

Return

User Function JOBENT10()
    Local cQueryTab := ""
    Local nConte    := 0
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    Local aEnt10    := {}
    Local Y10       := 0

    RPCSetEnv("01", "10")

    conout("INICIANDO JOBENTRADA 10" )
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT  TOP 20 *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZE") + " ZZE WITH (NOLOCK) " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZE.D_E_L_E_T_ = '' AND ZZE_STATUS IN ('9', '0') " + CRLF
    cQueryTab += "     AND ZZE_FILIAL IN ('10') " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    WHILE !(QRY_TAB->(EOF()))
        AADD(aEnt10, { QRY_TAB->ZZE_ZGRPEN, QRY_TAB->ZZE_ZEXTID,; 
                       QRY_TAB->ZZE_NUMNF,  QRY_TAB->ZZE_SERNFE,; 
                       QRY_TAB->ZZE_DTALTE, QRY_TAB->ZZE_CHVNF, ; 
                       QRY_TAB->ZZE_GRUPO,  QRY_TAB->ZZE_FILIAL, ; 
                       QRY_TAB->RECNO,      QRY_TAB->ZZE_CC, ; 
                       QRY_TAB->ZZE_CNPJFO }) 
        QRY_TAB->(dbSkip())
        LOOP
    ENDDO	
    QRY_TAB->(DBCLOSEAREA())

    nConte  := 0
    FOR Y10 := 1 TO lEN(aEnt10)  

        nConte++
        conout("LACO JOBNFE - 01 " + aEnt10[Y10, 02])

        _CNPJCPF:= IIF(EMPTY(aEnt10[Y10, 11]), Substr( aEnt10[Y10, 06],7, 14), aEnt10[Y10, 11])
        lTemFor := ows:temFornec(FWxFilial("SA2"), _CNPJCPF)

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(aEnt10[Y10, 07]), "01", aEnt10[Y10, 07])
        cFilAt   := Iif(EMPTY(aEnt10[Y10, 08]), "10", aEnt10[Y10, 08])

        cEmpAnt  := cEmpAt
        cFilAnt  := cFilAt

        cEnum    := aEnt10[Y10, 01]
        cExter   := aEnt10[Y10, 02]
        cDoc     := aEnt10[Y10, 03]
        cSeri    := aEnt10[Y10, 04]
        dAltVct  := aEnt10[Y10, 05]
        cChavNfe := aEnt10[Y10, 06]
        nRecn    := aEnt10[Y10, 09]
        cCentCus := aEnt10[Y10, 10]
                
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

    NEXT
    conout("FINALIZOU JOBNFE - 10")

    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOB10_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        //MemoWrite(cDirLog + cArqLog, cLog)
    Endif
    ConOut(OemToAnsi("Fim : ")+Time())

Return

User Function JOBENT11()
    Local cQueryTab := ""
    Local nConte    := 0
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    Local aEnt11    := {}
    Local Y11       := 0

    RPCSetEnv("01", "11")

    conout("INICIANDO JOBENTRADA 11" )
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT  TOP 20 *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZE") + " ZZE WITH (NOLOCK) " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZE.D_E_L_E_T_ = '' AND ZZE_STATUS IN ('9', '0') " + CRLF
    cQueryTab += "     AND ZZE_FILIAL IN ('11') " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    WHILE !(QRY_TAB->(EOF()))
        AADD(aEnt11, { QRY_TAB->ZZE_ZGRPEN, QRY_TAB->ZZE_ZEXTID,; 
                       QRY_TAB->ZZE_NUMNF,  QRY_TAB->ZZE_SERNFE,; 
                       QRY_TAB->ZZE_DTALTE, QRY_TAB->ZZE_CHVNF, ; 
                       QRY_TAB->ZZE_GRUPO,  QRY_TAB->ZZE_FILIAL, ; 
                       QRY_TAB->RECNO,      QRY_TAB->ZZE_CC, ; 
                       QRY_TAB->ZZE_CNPJFO }) 
        QRY_TAB->(dbSkip())
        LOOP
    ENDDO	
    QRY_TAB->(DBCLOSEAREA())

    nConte  := 0
    FOR Y11 := 1 TO lEN(aEnt11)  

        nConte++
        conout("LACO JOBNFE - 01 " + aEnt11[Y11, 02])

        _CNPJCPF:= IIF(EMPTY(aEnt11[Y11, 11]), Substr( aEnt11[Y11, 06],7, 14), aEnt11[Y11, 11])
        lTemFor := ows:temFornec(FWxFilial("SA2"), _CNPJCPF)

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(aEnt11[Y11, 07]), "01", aEnt11[Y11, 07])
        cFilAt   := Iif(EMPTY(aEnt11[Y11, 08]), "11", aEnt11[Y11, 08])

        cEmpAnt  := cEmpAt
        cFilAnt  := cFilAt

        cEnum    := aEnt11[Y11, 01]
        cExter   := aEnt11[Y11, 02]
        cDoc     := aEnt11[Y11, 03]
        cSeri    := aEnt11[Y11, 04]
        dAltVct  := aEnt11[Y11, 05]
        cChavNfe := aEnt11[Y11, 06]
        nRecn    := aEnt11[Y11, 09]
        cCentCus := aEnt11[Y11, 10]
        
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

    NEXT	
    conout("FINALIZOU JOBNFE - 11")
    
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOB11_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        //MemoWrite(cDirLog + cArqLog, cLog)
    EndiF
    ConOut(OemToAnsi("Fim : ")+Time())

Return

User Function JOBENT12()
    Local cQueryTab := ""
    Local nConte    := 0
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    Local aEnt12    := {}
    Local Y12       := 0

    RPCSetEnv("01", "12")

    conout("INICIANDO JOBENTRADA 12" )
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT  TOP 20 *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZE") + " ZZE WITH (NOLOCK) " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZE.D_E_L_E_T_ = '' AND ZZE_STATUS IN ('9', '0') " + CRLF
    cQueryTab += "     AND ZZE_FILIAL IN ('12') " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    WHILE !(QRY_TAB->(EOF()))
        AADD(aEnt12, { QRY_TAB->ZZE_ZGRPEN, QRY_TAB->ZZE_ZEXTID,; 
                       QRY_TAB->ZZE_NUMNF,  QRY_TAB->ZZE_SERNFE,; 
                       QRY_TAB->ZZE_DTALTE, QRY_TAB->ZZE_CHVNF, ; 
                       QRY_TAB->ZZE_GRUPO,  QRY_TAB->ZZE_FILIAL, ; 
                       QRY_TAB->RECNO,      QRY_TAB->ZZE_CC, ; 
                       QRY_TAB->ZZE_CNPJFO }) 
        QRY_TAB->(dbSkip())
        LOOP
    ENDDO	
    QRY_TAB->(DBCLOSEAREA())

    nConte := 0
    FOR Y12 := 1 TO lEN(aEnt12)  

        nConte++
        conout("LACO JOBNFE - 01 " + aEnt12[Y12, 02])

        _CNPJCPF:= IIF(EMPTY(aEnt12[Y12, 11]), Substr( aEnt12[Y12, 06],7, 14), aEnt12[Y12, 11])
        lTemFor := ows:temFornec(FWxFilial("SA2"), _CNPJCPF)

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(aEnt12[Y12, 07]), "01", aEnt12[Y12, 07])
        cFilAt   := Iif(EMPTY(aEnt12[Y12, 08]), "12", aEnt12[Y12, 08])

        cEmpAnt  := cEmpAt
        cFilAnt  := cFilAt

        cEnum    := aEnt12[Y12, 01]
        cExter   := aEnt12[Y12, 02]
        cDoc     := aEnt12[Y12, 03]
        cSeri    := aEnt12[Y12, 04]
        dAltVct  := aEnt12[Y12, 05]
        cChavNfe := aEnt12[Y12, 06]
        nRecn    := aEnt12[Y12, 09]
        cCentCus := aEnt12[Y12, 10]
        
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
    NEXT	
    
    conout("FINALIZOU JOBNFE")

    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOB12_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        //MemoWrite(cDirLog + cArqLog, cLog)
    EndiF
    ConOut(OemToAnsi("Fim : ")+Time())

Return

User Function JOBENT13()
    Local cQueryTab := ""
    Local nConte    := 0
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    Local aEnt13    := {}
    Local Y13       := 0

    RPCSetEnv("01", "13")

    conout("INICIANDO JOBENTRADA 13" )
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT  TOP 20 *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZE") + " ZZE WITH (NOLOCK) " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZE.D_E_L_E_T_ = '' AND ZZE_STATUS IN ('9', '0') " + CRLF
    cQueryTab += "     AND ZZE_FILIAL IN ('13') " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    WHILE !(QRY_TAB->(EOF()))
        AADD(aEnt13, { QRY_TAB->ZZE_ZGRPEN, QRY_TAB->ZZE_ZEXTID,; 
                       QRY_TAB->ZZE_NUMNF,  QRY_TAB->ZZE_SERNFE,; 
                       QRY_TAB->ZZE_DTALTE, QRY_TAB->ZZE_CHVNF, ; 
                       QRY_TAB->ZZE_GRUPO,  QRY_TAB->ZZE_FILIAL, ; 
                       QRY_TAB->RECNO,      QRY_TAB->ZZE_CC, ; 
                       QRY_TAB->ZZE_CNPJFO }) 
        QRY_TAB->(dbSkip())
        LOOP
    ENDDO	
    QRY_TAB->(DBCLOSEAREA())

    nConte  := 0
    FOR Y13 := 1 TO lEN(aEnt13)  

        nConte++
        conout("LACO JOBNFE - 01 " + aEnt13[Y13, 02])

        _CNPJCPF:= IIF(EMPTY(aEnt13[Y13, 11]), Substr( aEnt13[Y13, 06],7, 14), aEnt13[Y13, 11])
        lTemFor := ows:temFornec(FWxFilial("SA2"), _CNPJCPF)

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(aEnt13[Y13, 07]), "01", aEnt13[Y13, 07])
        cFilAt   := Iif(EMPTY(aEnt13[Y13, 08]), "13", aEnt13[Y13, 08])

        cEmpAnt  := cEmpAt
        cFilAnt  := cFilAt

        cEnum    := aEnt13[Y13, 01]
        cExter   := aEnt13[Y13, 02]
        cDoc     := aEnt13[Y13, 03]
        cSeri    := aEnt13[Y13, 04]
        dAltVct  := aEnt13[Y13, 05]
        cChavNfe := aEnt13[Y13, 06]
        nRecn    := aEnt13[Y13, 09]
        cCentCus := aEnt13[Y13, 10]
        
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
    NEXT	
    
    conout("FINALIZOU JOBNFE - 13")

    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOB13_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        //MemoWrite(cDirLog + cArqLog, cLog)
    EndIF
    ConOut(OemToAnsi("Fim : ")+Time())

Return

User Function JOBENT14()
    Local cQueryTab := ""
    Local nConte    := 0
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    Local aEnt14    := {}
    Local Y14       := 0

    RPCSetEnv("01", "14")

    conout("INICIANDO JOBENTRADA 14" )
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT  TOP 20 *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZE") + " ZZE WITH (NOLOCK) " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZE.D_E_L_E_T_ = '' AND ZZE_STATUS IN ('9', '0') " + CRLF
    cQueryTab += "     AND ZZE_FILIAL IN ('14') " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    WHILE !(QRY_TAB->(EOF()))
        AADD(aEnt14, { QRY_TAB->ZZE_ZGRPEN, QRY_TAB->ZZE_ZEXTID,; 
                       QRY_TAB->ZZE_NUMNF,  QRY_TAB->ZZE_SERNFE,; 
                       QRY_TAB->ZZE_DTALTE, QRY_TAB->ZZE_CHVNF, ; 
                       QRY_TAB->ZZE_GRUPO,  QRY_TAB->ZZE_FILIAL, ; 
                       QRY_TAB->RECNO,      QRY_TAB->ZZE_CC, ; 
                       QRY_TAB->ZZE_CNPJFO }) 
        QRY_TAB->(dbSkip())
        LOOP
    ENDDO	
    QRY_TAB->(DBCLOSEAREA())

    nConte  := 0
    FOR Y14 := 1 TO lEN(aEnt14)  

        nConte++
        conout("LACO JOBNFE - 01 " + aEnt14[Y14, 02])

        _CNPJCPF:= IIF(EMPTY(aEnt14[Y14, 11]), Substr( aEnt14[Y14, 06],7, 14), aEnt14[Y14, 11])
        lTemFor := ows:temFornec(FWxFilial("SA2"), _CNPJCPF)

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(aEnt14[Y14, 07]), "01", aEnt14[Y14, 07])
        cFilAt   := Iif(EMPTY(aEnt14[Y14, 08]), "14", aEnt14[Y14, 08])

        cEmpAnt  := cEmpAt
        cFilAnt  := cFilAt

        cEnum    := aEnt14[Y14, 01]
        cExter   := aEnt14[Y14, 02]
        cDoc     := aEnt14[Y14, 03]
        cSeri    := aEnt14[Y14, 04]
        dAltVct  := aEnt14[Y14, 05]
        cChavNfe := aEnt14[Y14, 06]
        nRecn    := aEnt14[Y14, 09]
        cCentCus := aEnt14[Y14, 10]
        
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
    NEXT	
    conout("FINALIZOU JOBNFE - 14")
    
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOB14_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        //MemoWrite(cDirLog + cArqLog, cLog)
    EndiF
    ConOut(OemToAnsi("Fim : ")+Time())

Return

User Function JOBENT15()
    Local cQueryTab := ""
    Local nConte    := 0
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    Local aEnt15    := {}
    Local Y15       := 0

    RPCSetEnv("01", "15")

    conout("INICIANDO JOBENTRADA 15" )
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT  TOP 20 *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZE") + " ZZE WITH (NOLOCK)" + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZE.D_E_L_E_T_ = '' AND ZZE_STATUS IN ('9', '0') " + CRLF
    cQueryTab += "     AND ZZE_FILIAL IN ('15') " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    WHILE !(QRY_TAB->(EOF()))
        AADD(aEnt15, { QRY_TAB->ZZE_ZGRPEN, QRY_TAB->ZZE_ZEXTID,; 
                       QRY_TAB->ZZE_NUMNF,  QRY_TAB->ZZE_SERNFE,; 
                       QRY_TAB->ZZE_DTALTE, QRY_TAB->ZZE_CHVNF, ; 
                       QRY_TAB->ZZE_GRUPO,  QRY_TAB->ZZE_FILIAL, ; 
                       QRY_TAB->RECNO,      QRY_TAB->ZZE_CC, ; 
                       QRY_TAB->ZZE_CNPJFO }) 
        QRY_TAB->(dbSkip())
        LOOP
    ENDDO	
    QRY_TAB->(DBCLOSEAREA())

    nConte  := 0
    FOR Y15 := 1 TO lEN(aEnt15)  

        nConte++
        conout("LACO JOBNFE - 01 " + aEnt15[Y15, 02])

        _CNPJCPF:= IIF(EMPTY(aEnt15[Y15, 11]), Substr( aEnt15[Y15, 06],7, 14), aEnt15[Y15, 11])
        lTemFor := ows:temFornec(FWxFilial("SA2"), _CNPJCPF)

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(aEnt15[Y15, 07]), "01", aEnt15[Y15, 07])
        cFilAt   := Iif(EMPTY(aEnt15[Y15, 08]), "15", aEnt15[Y15, 08])

        cEmpAnt  := cEmpAt
        cFilAnt  := cFilAt

        cEnum    := aEnt15[Y15, 01]
        cExter   := aEnt15[Y15, 02]
        cDoc     := aEnt15[Y15, 03]
        cSeri    := aEnt15[Y15, 04]
        dAltVct  := aEnt15[Y15, 05]
        cChavNfe := aEnt15[Y15, 06]
        nRecn    := aEnt15[Y15, 09]
        cCentCus := aEnt15[Y15, 10]
        
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

    NEXT	
    conout("FINALIZOU JOBNFE - 15")

    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOB15_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        //MemoWrite(cDirLog + cArqLog, cLog)
    EndiF
    ConOut(OemToAnsi("Fim : ")+Time())

Return

User Function JOBENT16()
    Local cQueryTab := ""
    Local nConte    := 0
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    Local aEnt16    := {}
    Local Y16        := 0

    RPCSetEnv("01", "16")

    conout("INICIANDO JOBENTRADA 16" )
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT  TOP 20 *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZE") + " ZZE WITH (NOLOCK) " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZE.D_E_L_E_T_ = '' AND ZZE_STATUS IN ('9', '0') " + CRLF
    cQueryTab += "     AND ZZE_FILIAL IN ('16') " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    WHILE !(QRY_TAB->(EOF()))
        AADD(aEnt16, { QRY_TAB->ZZE_ZGRPEN, QRY_TAB->ZZE_ZEXTID,; 
                       QRY_TAB->ZZE_NUMNF,  QRY_TAB->ZZE_SERNFE,; 
                       QRY_TAB->ZZE_DTALTE, QRY_TAB->ZZE_CHVNF, ; 
                       QRY_TAB->ZZE_GRUPO,  QRY_TAB->ZZE_FILIAL, ; 
                       QRY_TAB->RECNO,      QRY_TAB->ZZE_CC, ; 
                       QRY_TAB->ZZE_CNPJFO }) 
        QRY_TAB->(dbSkip())
        LOOP
    ENDDO	
    QRY_TAB->(DBCLOSEAREA())

    nConte := 0
    FOR Y16 := 1 TO lEN(aEnt16)  

        nConte++
        conout("LACO JOBNFE - 01 " + aEnt16[Y16, 02])

        _CNPJCPF:= IIF(EMPTY(aEnt16[Y16, 11]), Substr( aEnt16[Y16, 06],7, 14), aEnt16[Y16, 11])
        lTemFor := ows:temFornec(FWxFilial("SA2"), _CNPJCPF)

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(aEnt16[Y16, 07]), "01", aEnt16[Y16, 07])
        cFilAt   := Iif(EMPTY(aEnt16[Y16, 08]), "16", aEnt16[Y16, 08])

        cEmpAnt  := cEmpAt
        cFilAnt  := cFilAt

        cEnum    := aEnt16[Y16, 01]
        cExter   := aEnt16[Y16, 02]
        cDoc     := aEnt16[Y16, 03]
        cSeri    := aEnt16[Y16, 04]
        dAltVct  := aEnt16[Y16, 05]
        cChavNfe := aEnt16[Y16, 06]
        nRecn    := aEnt16[Y16, 09]
        cCentCus := aEnt16[Y16, 10]
        
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
    NEXT	
    conout("FINALIZOU JOBNFE - 16")

    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOB16_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        //MemoWrite(cDirLog + cArqLog, cLog)
    EndIF
    ConOut(OemToAnsi("Fim : ")+Time())

Return

User Function JOBENT17()
    Local cQueryTab := ""
    Local nConte    := 0
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    Local aEnt17    := {}
    Local Y17       := 0

    RPCSetEnv("01", "17")

    conout("INICIANDO JOBENTRADA 17" )
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT  TOP 20 *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZE") + " ZZE WITH (NOLOCK) " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZE.D_E_L_E_T_ = '' AND ZZE_STATUS IN ('9', '0') " + CRLF
    cQueryTab += "     AND ZZE_FILIAL IN ('17') " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    WHILE !(QRY_TAB->(EOF()))
        AADD(aEnt17, { QRY_TAB->ZZE_ZGRPEN, QRY_TAB->ZZE_ZEXTID,; 
                       QRY_TAB->ZZE_NUMNF,  QRY_TAB->ZZE_SERNFE,; 
                       QRY_TAB->ZZE_DTALTE, QRY_TAB->ZZE_CHVNF, ; 
                       QRY_TAB->ZZE_GRUPO,  QRY_TAB->ZZE_FILIAL, ; 
                       QRY_TAB->RECNO,      QRY_TAB->ZZE_CC, ; 
                       QRY_TAB->ZZE_CNPJFO }) 
        QRY_TAB->(dbSkip())
        LOOP
    ENDDO	
    QRY_TAB->(DBCLOSEAREA())

    nConte  := 0
    FOR Y17 := 1 TO lEN(aEnt17)  

        nConte++
        conout("LACO JOBNFE - 01 " + aEnt17[Y17, 02])

        _CNPJCPF:= IIF(EMPTY(aEnt17[Y17, 11]), Substr( aEnt17[Y17, 06],7, 14), aEnt17[Y17, 11])
        lTemFor := ows:temFornec(FWxFilial("SA2"), _CNPJCPF)

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(aEnt17[Y17, 07]), "01", aEnt17[Y17, 07])
        cFilAt   := Iif(EMPTY(aEnt17[Y17, 08]), "17", aEnt17[Y17, 08])

        cEmpAnt  := cEmpAt
        cFilAnt  := cFilAt

        cEnum    := aEnt17[Y17, 01]
        cExter   := aEnt17[Y17, 02]
        cDoc     := aEnt17[Y17, 03]
        cSeri    := aEnt17[Y17, 04]
        dAltVct  := aEnt17[Y17, 05]
        cChavNfe := aEnt17[Y17, 06]
        nRecn    := aEnt17[Y17, 09]
        cCentCus := aEnt17[Y17, 10]
        
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
    NEXT	
    conout("FINALIZOU JOBNFE - 17")
    
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOB17_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        //MemoWrite(cDirLog + cArqLog, cLog)
    EndIF
    ConOut(OemToAnsi("Fim : ")+Time())

Return

User Function JOBENT18()
    Local cQueryTab := ""
    Local nConte    := 0
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    Local aEnt18    := {}
    Local Y18       := 0

    RPCSetEnv("01", "18")

    conout("INICIANDO JOBENTRADA 18" )
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT  TOP 20 *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZE") + " ZZE WITH (NOLOCK) " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZE.D_E_L_E_T_ = '' AND ZZE_STATUS IN ('9', '0') " + CRLF
    cQueryTab += "     AND ZZE_FILIAL IN ('18') " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    WHILE !(QRY_TAB->(EOF()))
        AADD(aEnt18, { QRY_TAB->ZZE_ZGRPEN, QRY_TAB->ZZE_ZEXTID,; 
                       QRY_TAB->ZZE_NUMNF,  QRY_TAB->ZZE_SERNFE,; 
                       QRY_TAB->ZZE_DTALTE, QRY_TAB->ZZE_CHVNF, ; 
                       QRY_TAB->ZZE_GRUPO,  QRY_TAB->ZZE_FILIAL, ; 
                       QRY_TAB->RECNO,      QRY_TAB->ZZE_CC, ; 
                       QRY_TAB->ZZE_CNPJFO }) 
        QRY_TAB->(dbSkip())
        LOOP
    ENDDO	
    QRY_TAB->(DBCLOSEAREA())

    nConte := 0
    FOR Y18 := 1 TO lEN(aEnt18)  

        nConte++
        conout("LACO JOBNFE - 01 " + aEnt18[Y18, 02])

        _CNPJCPF:= IIF(EMPTY(aEnt18[Y18, 11]), Substr( aEnt18[Y18, 06],7, 14), aEnt18[Y18, 11])
        lTemFor := ows:temFornec(FWxFilial("SA2"), _CNPJCPF)

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(aEnt18[Y18, 07]), "01", aEnt18[Y18, 07])
        cFilAt   := Iif(EMPTY(aEnt18[Y18, 08]), "18", aEnt18[Y18, 08])

        cEmpAnt  := cEmpAt
        cFilAnt  := cFilAt

        cEnum    := aEnt18[Y18, 01]
        cExter   := aEnt18[Y18, 02]
        cDoc     := aEnt18[Y18, 03]
        cSeri    := aEnt18[Y18, 04]
        dAltVct  := aEnt18[Y18, 05]
        cChavNfe := aEnt18[Y18, 06]
        nRecn    := aEnt18[Y18, 09]
        cCentCus := aEnt18[Y18, 10]
        
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
    NEXT	
    conout("FINALIZOU JOBNFE - 18")
    
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOB18_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        //MemoWrite(cDirLog + cArqLog, cLog)
    EndIF
    ConOut(OemToAnsi("Fim : ")+Time())

Return

User Function JOBENT19()
    Local cQueryTab := ""
    Local nConte    := 0
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    Local aEnt19    := {}
    Local Y19       := 0

    RPCSetEnv("01", "19")

    conout("INICIANDO JOBENTRADA 19" )
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT  TOP 20 *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZE") + " ZZE WITH (NOLOCK) " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZE.D_E_L_E_T_ = '' AND ZZE_STATUS IN ('9', '0') " + CRLF
    cQueryTab += "     AND ZZE_FILIAL IN ('19') " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    WHILE !(QRY_TAB->(EOF()))
        AADD(aEnt19, { QRY_TAB->ZZE_ZGRPEN, QRY_TAB->ZZE_ZEXTID,; 
                       QRY_TAB->ZZE_NUMNF,  QRY_TAB->ZZE_SERNFE,; 
                       QRY_TAB->ZZE_DTALTE, QRY_TAB->ZZE_CHVNF, ; 
                       QRY_TAB->ZZE_GRUPO,  QRY_TAB->ZZE_FILIAL, ; 
                       QRY_TAB->RECNO,      QRY_TAB->ZZE_CC, ; 
                       QRY_TAB->ZZE_CNPJFO }) 
        QRY_TAB->(dbSkip())
        LOOP
    ENDDO	
    QRY_TAB->(DBCLOSEAREA())

    nConte := 0
    FOR Y19 := 1 TO lEN(aEnt19)

        nConte++
        conout("LACO JOBNFE - 01 " + aEnt19[Y19, 02])

        _CNPJCPF:= IIF(EMPTY(aEnt19[Y19, 11]), Substr( aEnt19[Y19, 06],7, 14), aEnt19[Y19, 11])
        lTemFor := ows:temFornec(FWxFilial("SA2"), _CNPJCPF)

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(aEnt19[Y19, 07]), "01", aEnt19[Y19, 07])
        cFilAt   := Iif(EMPTY(aEnt19[Y19, 08]), "19", aEnt19[Y19, 08])

        cEmpAnt  := cEmpAt
        cFilAnt  := cFilAt

        cEnum    := aEnt19[Y19, 01]
        cExter   := aEnt19[Y19, 02]
        cDoc     := aEnt19[Y19, 03]
        cSeri    := aEnt19[Y19, 04]
        dAltVct  := aEnt19[Y19, 05]
        cChavNfe := aEnt19[Y19, 06]
        nRecn    := aEnt19[Y19, 09]
        cCentCus := aEnt19[Y19, 10]
        
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
    NEXT	
    conout("FINALIZOU JOBNFE - 19")
    
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOB19_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        //MemoWrite(cDirLog + cArqLog, cLog)
    EndIF
    ConOut(OemToAnsi("Fim : ")+Time())

Return

User Function JOBENT20()
    Local cQueryTab := ""
    Local nConte    := 0
    Local cLog      := ""
    Local cDirLog   := '\x_logs\'

    Local aEnt20    := {}
    Local Y20       := 0

    RPCSetEnv("01", "20")

    conout("INICIANDO JOBENTRADA 20" )
    oWS    := LIBGLASS():new()	

    cQueryTab := " SELECT  TOP 20 *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZE") + " ZZE WITH (NOLOCK) " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZE.D_E_L_E_T_ = '' AND ZZE_STATUS IN ('9', '0') " + CRLF
    cQueryTab += "     AND ZZE_FILIAL IN ('20') " + CRLF
    TCQuery cQueryTab New Alias 'QRY_TAB'

    WHILE !(QRY_TAB->(EOF()))
        AADD(aEnt20, { QRY_TAB->ZZE_ZGRPEN, QRY_TAB->ZZE_ZEXTID,; 
                       QRY_TAB->ZZE_NUMNF,  QRY_TAB->ZZE_SERNFE,; 
                       QRY_TAB->ZZE_DTALTE, QRY_TAB->ZZE_CHVNF, ; 
                       QRY_TAB->ZZE_GRUPO,  QRY_TAB->ZZE_FILIAL, ; 
                       QRY_TAB->RECNO,      QRY_TAB->ZZE_CC, ; 
                       QRY_TAB->ZZE_CNPJFO }) 
        QRY_TAB->(dbSkip())
        LOOP
    ENDDO	
    QRY_TAB->(DBCLOSEAREA())

    nConte  := 0
    FOR Y20 := 1 TO lEN(aEnt20)  

        nConte++
        conout("LACO JOBNFE - 01 " + aEnt20[Y20, 02])

        _CNPJCPF:= IIF(EMPTY(aEnt20[Y20, 11]), Substr( aEnt20[Y20, 06],7, 14), aEnt20[Y20, 11])
        lTemFor := ows:temFornec(FWxFilial("SA2"), _CNPJCPF)

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(aEnt20[Y20, 07]), "01", aEnt20[Y20, 07])
        cFilAt   := Iif(EMPTY(aEnt20[Y20, 08]), "20", aEnt20[Y20, 08])

        cEmpAnt  := cEmpAt
        cFilAnt  := cFilAt

        cEnum    := aEnt20[Y20, 01]
        cExter   := aEnt20[Y20, 02]
        cDoc     := aEnt20[Y20, 03]
        cSeri    := aEnt20[Y20, 04]
        dAltVct  := aEnt20[Y20, 05]
        cChavNfe := aEnt20[Y20, 06]
        nRecn    := aEnt20[Y20, 09]
        cCentCus := aEnt20[Y20, 10]
        
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
    NEXT	
    conout("FINALIZOU JOBNFE - 20")
    
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOB20_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        //MemoWrite(cDirLog + cArqLog, cLog)
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
