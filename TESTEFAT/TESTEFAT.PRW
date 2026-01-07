#include "totvs.ch"
#include "protheus.ch"
#include "TOPCONN.CH"
#INCLUDE "TBICONN.CH"


User Function TESTEFAT()
    // Local aRob1 := {}
    // Local aRob2 := {}
    // Local aRob3 := {}
    // Local aRob4 := {}

    // Local aRob5 := {}
    // Local aRob6 := {}
    // Local aRob7 := {}
    // Local aRob8 := {}

    // aRob1 := ROBo01()
    // aRob2 := ROBo02()
    // aRob3 := ROBo03()

    // aRob4 := ROBo04()
    // aRob5 := ROBo05()
    // aRob6 := ROBo06()

    // aRob7 := ROBo07()
    // aRob8 := ROBo08()

    Local aAreaIm  := GetArea()
        StartJob("u_ROBSAI01",GetEnvServer(),.F.)
        StartJob("u_ROBSAI02",GetEnvServer(),.F.)


        // StartJob("u_ROBSAI01",GetEnvServer(),.F., aRob1)
        // StartJob("u_ROBSAI02",GetEnvServer(),.F., aRob2)
        // StartJob("u_ROBSAI03",GetEnvServer(),.F., aRob3)
        
        // StartJob("u_ROBSAI04",GetEnvServer(),.F., aRob4)
        // StartJob("u_ROBSAI05",GetEnvServer(),.F., aRob5)
        // StartJob("u_ROBSAI06",GetEnvServer(),.F., aRob6)

        // StartJob("u_ROBSAI07",GetEnvServer(),.F., aRob7)
        // StartJob("u_ROBSAI08",GetEnvServer(),.F., aRob8)

        //StartJob("u_robENT01",GetEnvServer(),.F.)
        //StartJob("u_robENT15",GetEnvServer(),.F.)

    RestArea(aAreaIm)
Return

//INICIO DAS SAIDAS

User Function ROBSAI01()
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
    cQueryTab += "     AND ZZF_FILIAL IN ('01', '15') AND ZZF_VALOR > 0 " + CRLF
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

User Function ROBSAI02()
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
    cQueryTab += "     AND ZZF_FILIAL NOT IN ('01', '15')  AND ZZF_VALOR > 0 " + CRLF
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


// User Function ROBSAI01(a01)
//     Local cQueryTab := ""
//     Local aRetGrv   := {}
//     Local aArea     := FWGetArea()
//     Local X1

//     FOR X1 := 1 to Len(a01)
//         cExtid  := a01[X1, 1]
//         cFil    := "15"//StrZero(Val(a01[X1, 2]),2)

//         conout("INICIANDO JOBSAI01")
//         RPCSetEnv("01", cFil)
//         oWS    := LIBGLASS():new()	

//         cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
//         cQueryTab += " FROM " + CRLF
//         cQueryTab += "     " + RetSQLName("ZZF") + " ZZF " + CRLF
//         cQueryTab += " WHERE " + CRLF
//         cQueryTab += "     ZZF.D_E_L_E_T_ = ''  " + CRLF
//         cQueryTab += "     AND ZZF_FILIAL = '"+cFil+"' AND ZZF_VALOR > 0 AND ZZF_ZEXTID = '"+cExtid+"' " + CRLF
//         cQueryTab += "     ORDER BY ZZF_VALOR DESC " + CRLF
//         TCQuery cQueryTab New Alias 'QRYTAB0'

//         nConte := 0
//         WHILE !(QRYTAB0->(EOF()))

//             nConte++
//             conout("LACO JOBSAI - " + QRYTAB0->ZZF_ZEXTID)

//             cEmpAt1 := cEmpAnt
//             cFilAt1 := cFilAnt

//             cEmpAt   := Iif(EMPTY(QRYTAB0->ZZF_GRUPO),  "01", QRYTAB0->ZZF_GRUPO)
//             cFilAt   := Iif(EMPTY(QRYTAB0->ZZF_FILIAL), cFil, QRYTAB0->ZZF_FILIAL)

//             cEmpAnt  := cEmpAt
//             cFilAnt  := cFilAt

//             cEnum    := QRYTAB0->ZZF_ZGRPEN
//             cExter   := QRYTAB0->ZZF_ZEXTID
//             cDoc     := QRYTAB0->ZZF_NUMNF
//             cSeri    := QRYTAB0->ZZF_SERNFE
//             dAltVct  := QRYTAB0->ZZF_DTALTE
//             cChavNfe := QRYTAB0->ZZF_CHVNF
//             nRecn    := QRYTAB0->RECNO
//             cCentCus := QRYTAB0->ZZF_CC

//             alTemExtr := ows:PGExtPDV(cEnum + cExter) 

//             IF len(alTemExtr) == 0  //Verifica se tem ExternoID - Numero do Pedido Externo
//                 oWS:GRVALGZZF(nRecn, cExter, "PEDIDO DE VENDAS NAO EXISTE", "WSNFS", "INCLUSÃO DE Nota Fiscal de Saida")
//             ELSE
//                 cPdv   := alTemExtr[1,1]
//                 cod    := alTemExtr[1,3]
//                 loja   := alTemExtr[1,4]
//                 lTemCli := ows:temCliCod(FWxFilial("SA1"), cod, loja)

//                 RPCSetEnv(cEmpAt, cFilAt)

//                 IF !lTemCli
//                     oWS:GRVALGZZF(nRecn, cExter, "CLIENTE NÃO EXISTE", "WSNFS", "INCLUSÃO DE Nota Fiscal de Saida")
//                 EndIF
                
//                 lPrdIg := ows:VLDPRD((cEnum + cExter), alTemExtr) 
//                 IF lPrdIg //ha um produto diferente!?
//                     oWS:GRVALGZZF(nRecn, cExter, "PRODUTOS DIFERENTES ENTRE OC E OV", "WSNFS", "INCLUSÃO DE Nota Fiscal de Saida")
//                 EndIF

//                 lTESEst := ows:PGExtest(cEnum + cExter) 
//                 IF !lTESEst  //Verifica se tem ExternoID - Numero do Pedido Externo
//                     oWS:GRVALGZZF(nRecn, cExter, "TES - NÃO MOVIMENTA ESTOQUE", "WSNFS", "INCLUSÃO DE Nota Fiscal de Saida")
//                     oWS:mudaStsf(nRecn, cExter, "3")  //sem pedido de compras
//                 Else
//                     lPedi   := VldNot(cPdv, cFilAt) //validação de existencia do pedido ja faturado - 08/12/2025 - victor
//                     if !lPedi
//                         aRetGrv := oWS:GerarNota(cPdv, cFilAt)
//                     endif

//                     If len(aRetGrv) == 0
//                         //cErrorLog   := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO
//                         oWS:GRVALGZZF(nRecn, cExter, "ERRO NA GERAÇÃO DA NOTA DE SAIDA", "WSNFS", "INCLUSÃO DE Nota Fiscal de Saida")
//                     Else
//                         oWS:mudaStsf(nRecn, cExter, "1")
//                     EndIf
//                 Endif

//                 cEmpAnt  := cEmpAt1
//                 cFilAnt  := cFilAt1
//             EndIF
            
//             QRYTAB0->(dbSkip())
//             LOOP
//         ENDDO
//         QRYTAB0->(DBCLOSEAREA())    
//     NEXT	

//     RestArea(aArea)
//     CONOUT("FINALIZOUJOB NFS")
//     RpcClearEnv()

// Return

// User Function ROBSAI02(a02)
//     Local cQueryTab := ""
//     Local aRetGrv   := {}
//     Local aArea     := FWGetArea()
//     Local X2

//     FOR X2 := 1 to Len(a02)
//         cExtid  := a02[X2, 1]
//         cFil    := "15"//StrZero(Val(a02[X2, 2]),2)

//         conout("INICIANDO JOBSAI02")
//         RPCSetEnv("01", cFil)
//         oWS    := LIBGLASS():new()	

//         cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
//         cQueryTab += " FROM " + CRLF
//         cQueryTab += "     " + RetSQLName("ZZF") + " ZZF " + CRLF
//         cQueryTab += " WHERE " + CRLF
//         cQueryTab += "     ZZF.D_E_L_E_T_ = ''  " + CRLF
//         cQueryTab += "     AND ZZF_FILIAL = '"+cFil+"' AND ZZF_VALOR > 0 AND ZZF_ZEXTID = '"+cExtid+"' " + CRLF
//         cQueryTab += "     ORDER BY ZZF_VALOR DESC " + CRLF
//         TCQuery cQueryTab New Alias 'QRYTAB1'

//         nConte := 0
//         WHILE !(QRYTAB1->(EOF()))

//             nConte++
//             conout("LACO JOBSAI - " + QRYTAB1->ZZF_ZEXTID)

//             cEmpAt1 := cEmpAnt
//             cFilAt1 := cFilAnt

//             cEmpAt   := Iif(EMPTY(QRYTAB1->ZZF_GRUPO),  "01", QRYTAB1->ZZF_GRUPO)
//             cFilAt   := Iif(EMPTY(QRYTAB1->ZZF_FILIAL), cFil, QRYTAB1->ZZF_FILIAL)

//             cEmpAnt  := cEmpAt
//             cFilAnt  := cFilAt

//             cEnum    := QRYTAB1->ZZF_ZGRPEN
//             cExter   := QRYTAB1->ZZF_ZEXTID
//             cDoc     := QRYTAB1->ZZF_NUMNF
//             cSeri    := QRYTAB1->ZZF_SERNFE
//             dAltVct  := QRYTAB1->ZZF_DTALTE
//             cChavNfe := QRYTAB1->ZZF_CHVNF
//             nRecn    := QRYTAB1->RECNO
//             cCentCus := QRYTAB1->ZZF_CC

//             alTemExtr := ows:PGExtPDV(cEnum + cExter) 

//             IF len(alTemExtr) == 0  //Verifica se tem ExternoID - Numero do Pedido Externo
//                 oWS:GRVALGZZF(nRecn, cExter, "PEDIDO DE VENDAS NAO EXISTE", "WSNFS", "INCLUSÃO DE Nota Fiscal de Saida")
//             ELSE
//                 cPdv   := alTemExtr[1,1]
//                 cod    := alTemExtr[1,3]
//                 loja   := alTemExtr[1,4]
//                 lTemCli := ows:temCliCod(FWxFilial("SA1"), cod, loja)

//                 RPCSetEnv(cEmpAt, cFilAt)

//                 IF !lTemCli
//                     oWS:GRVALGZZF(nRecn, cExter, "CLIENTE NÃO EXISTE", "WSNFS", "INCLUSÃO DE Nota Fiscal de Saida")
//                 EndIF
                
//                 lPrdIg := ows:VLDPRD((cEnum + cExter), alTemExtr) 
//                 IF lPrdIg //ha um produto diferente!?
//                     oWS:GRVALGZZF(nRecn, cExter, "PRODUTOS DIFERENTES ENTRE OC E OV", "WSNFS", "INCLUSÃO DE Nota Fiscal de Saida")
//                 EndIF

//                 lTESEst := ows:PGExtest(cEnum + cExter) 
//                 IF !lTESEst  //Verifica se tem ExternoID - Numero do Pedido Externo
//                     oWS:GRVALGZZF(nRecn, cExter, "TES - NÃO MOVIMENTA ESTOQUE", "WSNFS", "INCLUSÃO DE Nota Fiscal de Saida")
//                     oWS:mudaStsf(nRecn, cExter, "3")  //sem pedido de compras
//                 Else
//                     lPedi   := VldNot(cPdv, cFilAt) //validação de existencia do pedido ja faturado - 08/12/2025 - victor
//                     if !lPedi
//                         aRetGrv := oWS:GerarNota(cPdv, cFilAt)
//                     endif

//                     If len(aRetGrv) == 0
//                         //cErrorLog   := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO
//                         oWS:GRVALGZZF(nRecn, cExter, "ERRO NA GERAÇÃO DA NOTA DE SAIDA", "WSNFS", "INCLUSÃO DE Nota Fiscal de Saida")
//                     Else
//                         oWS:mudaStsf(nRecn, cExter, "1")
//                     EndIf
//                 Endif

//                 cEmpAnt  := cEmpAt1
//                 cFilAnt  := cFilAt1
//             EndIF
            
//             QRYTAB1->(dbSkip())
//             LOOP
//         ENDDO
//         QRYTAB1->(DBCLOSEAREA())
//     NEXT	

//     RestArea(aArea)
//     CONOUT("FINALIZOUJOB NFS")
//     RpcClearEnv()

// Return

User Function ROBSAI03(a03)
    Local cQueryTab := ""
    Local aRetGrv   := {}
    Local aArea     := FWGetArea()
    Local X3

    FOR X3 := 1 to Len(a03)
        cExtid  := a03[X3, 1]
        cFil    := "15"//StrZero(Val(a03[X3, 2]),2)

        conout("INICIANDO JOBSAI03")
        RPCSetEnv("01", cFil)
        oWS    := LIBGLASS():new()	

        cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
        cQueryTab += " FROM " + CRLF
        cQueryTab += "     " + RetSQLName("ZZF") + " ZZF " + CRLF
        cQueryTab += " WHERE " + CRLF
        cQueryTab += "     ZZF.D_E_L_E_T_ = ''  " + CRLF
        cQueryTab += "     AND ZZF_FILIAL = '"+cFil+"' AND ZZF_VALOR > 0 AND ZZF_ZEXTID = '"+cExtid+"' " + CRLF
        cQueryTab += "     ORDER BY ZZF_VALOR DESC " + CRLF
        TCQuery cQueryTab New Alias 'QRYTAB2'

        nConte := 0
        WHILE !(QRYTAB2->(EOF()))

            nConte++
            conout("LACO JOBSAI - " + QRYTAB2->ZZF_ZEXTID)

            cEmpAt1 := cEmpAnt
            cFilAt1 := cFilAnt

            cEmpAt   := Iif(EMPTY(QRYTAB2->ZZF_GRUPO),  "01", QRYTAB2->ZZF_GRUPO)
            cFilAt   := Iif(EMPTY(QRYTAB2->ZZF_FILIAL), cFil, QRYTAB2->ZZF_FILIAL)

            cEmpAnt  := cEmpAt
            cFilAnt  := cFilAt

            cEnum    := QRYTAB2->ZZF_ZGRPEN
            cExter   := QRYTAB2->ZZF_ZEXTID
            cDoc     := QRYTAB2->ZZF_NUMNF
            cSeri    := QRYTAB2->ZZF_SERNFE
            dAltVct  := QRYTAB2->ZZF_DTALTE
            cChavNfe := QRYTAB2->ZZF_CHVNF
            nRecn    := QRYTAB2->RECNO
            cCentCus := QRYTAB2->ZZF_CC

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
            
            QRYTAB2->(dbSkip())
            LOOP
        ENDDO
        QRYTAB2->(DBCLOSEAREA())
    NEXT	

    RestArea(aArea)
    CONOUT("FINALIZOUJOB NFS")
    RpcClearEnv()

Return


User Function ROBSAI04(a04)
    Local cQueryTab := ""
    Local aRetGrv   := {}
    Local aArea     := FWGetArea()
    Local X4

    FOR X4 := 1 to Len(a04)
        cExtid  := a04[X4, 1]
        cFil    := "15"//StrZero(Val(a04[X4, 2]),2)

        conout("INICIANDO JOBSAI04")
        RPCSetEnv("01", cFil)
        oWS    := LIBGLASS():new()	

        cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
        cQueryTab += " FROM " + CRLF
        cQueryTab += "     " + RetSQLName("ZZF") + " ZZF " + CRLF
        cQueryTab += " WHERE " + CRLF
        cQueryTab += "     ZZF.D_E_L_E_T_ = ''  " + CRLF
        cQueryTab += "     AND ZZF_FILIAL = '"+cFil+"' AND ZZF_VALOR > 0 AND ZZF_ZEXTID = '"+cExtid+"' " + CRLF
        cQueryTab += "     ORDER BY ZZF_VALOR DESC " + CRLF
        TCQuery cQueryTab New Alias 'QRYTAB3'

        nConte := 0
        WHILE !(QRYTAB3->(EOF()))

            nConte++
            conout("LACO JOBSAI - " + QRYTAB3->ZZF_ZEXTID)

            cEmpAt1 := cEmpAnt
            cFilAt1 := cFilAnt

            cEmpAt   := Iif(EMPTY(QRYTAB3->ZZF_GRUPO),  "01", QRYTAB3->ZZF_GRUPO)
            cFilAt   := Iif(EMPTY(QRYTAB3->ZZF_FILIAL), cFil, QRYTAB3->ZZF_FILIAL)

            cEmpAnt  := cEmpAt
            cFilAnt  := cFilAt

            cEnum    := QRYTAB3->ZZF_ZGRPEN
            cExter   := QRYTAB3->ZZF_ZEXTID
            cDoc     := QRYTAB3->ZZF_NUMNF
            cSeri    := QRYTAB3->ZZF_SERNFE
            dAltVct  := QRYTAB3->ZZF_DTALTE
            cChavNfe := QRYTAB3->ZZF_CHVNF
            nRecn    := QRYTAB3->RECNO
            cCentCus := QRYTAB3->ZZF_CC

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
            
            QRYTAB3->(dbSkip())
            LOOP
        ENDDO
        QRYTAB3->(DBCLOSEAREA())
    NEXT	

    RestArea(aArea)
    CONOUT("FINALIZOUJOB NFS")
    RpcClearEnv()

Return

User Function ROBSAI05(a05)
    Local cQueryTab := ""
    Local aRetGrv   := {}
    Local aArea     := FWGetArea()
    Local X5

    FOR X5 := 1 to Len(a05)
        cExtid  := a05[X5, 1]
        cFil    := "15"//StrZero(Val(a05[X5, 2]),2)

        conout("INICIANDO JOBSAI05")
        RPCSetEnv("01", cFil)
        oWS    := LIBGLASS():new()	

        cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
        cQueryTab += " FROM " + CRLF
        cQueryTab += "     " + RetSQLName("ZZF") + " ZZF " + CRLF
        cQueryTab += " WHERE " + CRLF
        cQueryTab += "     ZZF.D_E_L_E_T_ = ''  " + CRLF
        cQueryTab += "     AND ZZF_FILIAL = '"+cFil+"' AND ZZF_VALOR > 0 AND ZZF_ZEXTID = '"+cExtid+"' " + CRLF
        cQueryTab += "     ORDER BY ZZF_VALOR DESC " + CRLF
        TCQuery cQueryTab New Alias 'QRYTAB5'

        nConte := 0
        WHILE !(QRYTAB5->(EOF()))

            nConte++
            conout("LACO JOBSAI - " + QRYTAB5->ZZF_ZEXTID)

            cEmpAt1 := cEmpAnt
            cFilAt1 := cFilAnt

            cEmpAt   := Iif(EMPTY(QRYTAB5->ZZF_GRUPO),  "01", QRYTAB5->ZZF_GRUPO)
            cFilAt   := Iif(EMPTY(QRYTAB5->ZZF_FILIAL), cFil, QRYTAB5->ZZF_FILIAL)

            cEmpAnt  := cEmpAt
            cFilAnt  := cFilAt

            cEnum    := QRYTAB5->ZZF_ZGRPEN
            cExter   := QRYTAB5->ZZF_ZEXTID
            cDoc     := QRYTAB5->ZZF_NUMNF
            cSeri    := QRYTAB5->ZZF_SERNFE
            dAltVct  := QRYTAB5->ZZF_DTALTE
            cChavNfe := QRYTAB5->ZZF_CHVNF
            nRecn    := QRYTAB5->RECNO
            cCentCus := QRYTAB5->ZZF_CC

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
            
            QRYTAB5->(dbSkip())
            LOOP
        ENDDO
        QRYTAB5->(DBCLOSEAREA())    
    NEXT	

    RestArea(aArea)
    CONOUT("FINALIZOUJOB NFS")
    RpcClearEnv()

Return

User Function ROBSAI06(a06)
    Local cQueryTab := ""
    Local aRetGrv   := {}
    Local aArea     := FWGetArea()
    Local X6

    FOR X6 := 1 to Len(a06)
        cExtid  := a06[X6, 1]
        cFil    := "15"//StrZero(Val(a06[X6, 2]),2)

        conout("INICIANDO JOBSAI06")
        RPCSetEnv("01", cFil)
        oWS    := LIBGLASS():new()	

        cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
        cQueryTab += " FROM " + CRLF
        cQueryTab += "     " + RetSQLName("ZZF") + " ZZF " + CRLF
        cQueryTab += " WHERE " + CRLF
        cQueryTab += "     ZZF.D_E_L_E_T_ = ''  " + CRLF
        cQueryTab += "     AND ZZF_FILIAL = '"+cFil+"' AND ZZF_VALOR > 0 AND ZZF_ZEXTID = '"+cExtid+"' " + CRLF
        cQueryTab += "     ORDER BY ZZF_VALOR DESC " + CRLF
        TCQuery cQueryTab New Alias 'QRYTAB6'

        nConte := 0
        WHILE !(QRYTAB6->(EOF()))

            nConte++
            conout("LACO JOBSAI - " + QRYTAB6->ZZF_ZEXTID)

            cEmpAt1 := cEmpAnt
            cFilAt1 := cFilAnt

            cEmpAt   := Iif(EMPTY(QRYTAB6->ZZF_GRUPO),  "01", QRYTAB6->ZZF_GRUPO)
            cFilAt   := Iif(EMPTY(QRYTAB6->ZZF_FILIAL), cFil, QRYTAB6->ZZF_FILIAL)

            cEmpAnt  := cEmpAt
            cFilAnt  := cFilAt

            cEnum    := QRYTAB6->ZZF_ZGRPEN
            cExter   := QRYTAB6->ZZF_ZEXTID
            cDoc     := QRYTAB6->ZZF_NUMNF
            cSeri    := QRYTAB6->ZZF_SERNFE
            dAltVct  := QRYTAB6->ZZF_DTALTE
            cChavNfe := QRYTAB6->ZZF_CHVNF
            nRecn    := QRYTAB6->RECNO
            cCentCus := QRYTAB6->ZZF_CC

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
            
            QRYTAB6->(dbSkip())
            LOOP
        ENDDO
        QRYTAB6->(DBCLOSEAREA())
    NEXT	

    RestArea(aArea)
    CONOUT("FINALIZOUJOB NFS")
    RpcClearEnv()

Return

User Function ROBSAI07(a07)
    Local cQueryTab := ""
    Local aRetGrv   := {}
    Local aArea     := FWGetArea()
    Local X7

    FOR X7 := 1 to Len(a07)
        cExtid  := a07[X7, 1]
        cFil    := "15" //StrZero(Val(a07[X7, 2]),2)

        conout("INICIANDO JOBSAI07")
        RPCSetEnv("01", cFil)
        oWS    := LIBGLASS():new()	

        cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
        cQueryTab += " FROM " + CRLF
        cQueryTab += "     " + RetSQLName("ZZF") + " ZZF " + CRLF
        cQueryTab += " WHERE " + CRLF
        cQueryTab += "     ZZF.D_E_L_E_T_ = ''  " + CRLF
        cQueryTab += "     AND ZZF_FILIAL = '"+cFil+"' AND ZZF_VALOR > 0 AND ZZF_ZEXTID = '"+cExtid+"' " + CRLF
        cQueryTab += "     ORDER BY ZZF_VALOR DESC " + CRLF
        TCQuery cQueryTab New Alias 'QRYTAB7'

        nConte := 0
        WHILE !(QRYTAB7->(EOF()))

            nConte++
            conout("LACO JOBSAI - " + QRYTAB7->ZZF_ZEXTID)

            cEmpAt1 := cEmpAnt
            cFilAt1 := cFilAnt

            cEmpAt   := Iif(EMPTY(QRYTAB7->ZZF_GRUPO),  "01", QRYTAB7->ZZF_GRUPO)
            cFilAt   := Iif(EMPTY(QRYTAB7->ZZF_FILIAL), cFil, QRYTAB7->ZZF_FILIAL)

            cEmpAnt  := cEmpAt
            cFilAnt  := cFilAt

            cEnum    := QRYTAB7->ZZF_ZGRPEN
            cExter   := QRYTAB7->ZZF_ZEXTID
            cDoc     := QRYTAB7->ZZF_NUMNF
            cSeri    := QRYTAB7->ZZF_SERNFE
            dAltVct  := QRYTAB7->ZZF_DTALTE
            cChavNfe := QRYTAB7->ZZF_CHVNF
            nRecn    := QRYTAB7->RECNO
            cCentCus := QRYTAB7->ZZF_CC

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
            
            QRYTAB7->(dbSkip())
            LOOP
        ENDDO
        QRYTAB7->(DBCLOSEAREA())
    NEXT	

    RestArea(aArea)
    CONOUT("FINALIZOUJOB NFS")
    RpcClearEnv()

Return


User Function ROBSAI08(a08)
    Local cQueryTab := ""
    Local aRetGrv   := {}
    Local aArea     := FWGetArea()
    Local X8

    FOR X8 := 1 to Len(a08)
        cExtid  := a08[X8, 1]
        cFil    := "15" //StrZero(Val(a08[X8, 2]),2)

        conout("INICIANDO JOBSAI08")
        RPCSetEnv("01", cFil)
        oWS    := LIBGLASS():new()	

        cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
        cQueryTab += " FROM " + CRLF
        cQueryTab += "     " + RetSQLName("ZZF") + " ZZF " + CRLF
        cQueryTab += " WHERE " + CRLF
        cQueryTab += "     ZZF.D_E_L_E_T_ = ''  " + CRLF
        cQueryTab += "     AND ZZF_FILIAL = '"+cFil+"' AND ZZF_VALOR > 0 AND ZZF_ZEXTID = '"+cExtid+"' " + CRLF
        cQueryTab += "     ORDER BY ZZF_VALOR DESC " + CRLF
        TCQuery cQueryTab New Alias 'QRYTAB8'

        nConte := 0
        WHILE !(QRYTAB8->(EOF()))

            nConte++
            conout("LACO JOBSAI - " + QRYTAB8->ZZF_ZEXTID)

            cEmpAt1 := cEmpAnt
            cFilAt1 := cFilAnt

            cEmpAt   := Iif(EMPTY(QRYTAB8->ZZF_GRUPO),  "01", QRYTAB8->ZZF_GRUPO)
            cFilAt   := Iif(EMPTY(QRYTAB8->ZZF_FILIAL), cFil, QRYTAB8->ZZF_FILIAL)

            cEmpAnt  := cEmpAt
            cFilAnt  := cFilAt

            cEnum    := QRYTAB8->ZZF_ZGRPEN
            cExter   := QRYTAB8->ZZF_ZEXTID
            cDoc     := QRYTAB8->ZZF_NUMNF
            cSeri    := QRYTAB8->ZZF_SERNFE
            dAltVct  := QRYTAB8->ZZF_DTALTE
            cChavNfe := QRYTAB8->ZZF_CHVNF
            nRecn    := QRYTAB8->RECNO
            cCentCus := QRYTAB8->ZZF_CC

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
            
            QRYTAB8->(dbSkip())
            LOOP
        ENDDO
        QRYTAB8->(DBCLOSEAREA())
    NEXT	

    RestArea(aArea)
    CONOUT("FINALIZOUJOB NFS")
    RpcClearEnv()

Return


User Function robENT15()
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
    cQueryTab += "     AND ZZE_FILIAL = '15' " + CRLF
    TCQuery cQueryTab New Alias 'QRYENT15'

    nConte := 0
    WHILE !(QRYENT15->(EOF()))
        nResult := Val(substr(Time(),1,2))
        nConte++
        conout("LACO JOBNFE - 15 " + QRYENT15->ZZE_ZEXTID)

        _CNPJCPF:= IIF(EMPTY(QRYENT15->ZZE_CNPJFO), Substr( QRYENT15->ZZE_CHVNF,7, 14), QRYENT15->ZZE_CNPJFO)
        lTemFor := ows:temFornec(FWxFilial("SA2"), _CNPJCPF)

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(QRYENT15->ZZE_GRUPO),  "01", QRYENT15->ZZE_GRUPO)
        cFilAt   := Iif(EMPTY(QRYENT15->ZZE_FILIAL), "15", QRYENT15->ZZE_FILIAL)

        cEmpAnt  := cEmpAt
        cFilAnt  := cFilAt

        cEnum    := QRYENT15->ZZE_ZGRPEN
        cExter   := QRYENT15->ZZE_ZEXTID
        cDoc     := QRYENT15->ZZE_NUMNF
        cSeri    := QRYENT15->ZZE_SERNFE
        dAltVct  := QRYENT15->ZZE_DTALTE
        cChavNfe := QRYENT15->ZZE_CHVNF
        nRecn    := QRYENT15->RECNO
        cCentCus := QRYENT15->ZZE_CC
        
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

        QRYENT15->(dbSkip())
        LOOP
    ENDDO	
    QRYENT15->(DBCLOSEAREA())
    conout("FINALIZOU JOBNFE - 15")
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOB15_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        MemoWrite(cDirLog + cArqLog, cLog)
    EndiF
    ConOut(OemToAnsi("Fim : ")+Time())

Return

User Function robENT01()
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
    cQueryTab += "     AND ZZE_FILIAL = '01' " + CRLF
    TCQuery cQueryTab New Alias 'QRYENT01'

    nConte := 0
    WHILE !(QRYENT01->(EOF()))
        nResult := Val(substr(Time(),1,2))
        nConte++
        conout("LACO JOBNFE - 01 " + QRYENT01->ZZE_ZEXTID)

        _CNPJCPF:= IIF(EMPTY(QRYENT01->ZZE_CNPJFO), Substr( QRYENT01->ZZE_CHVNF,7, 14), QRYENT01->ZZE_CNPJFO)
        lTemFor := ows:temFornec(FWxFilial("SA2"), _CNPJCPF)

        cEmpAt1 := cEmpAnt
        cFilAt1 := cFilAnt

        cEmpAt   := Iif(EMPTY(QRYENT01->ZZE_GRUPO),  "01", QRYENT01->ZZE_GRUPO)
        cFilAt   := Iif(EMPTY(QRYENT01->ZZE_FILIAL), "01", QRYENT01->ZZE_FILIAL)

        cEmpAnt  := cEmpAt
        cFilAnt  := cFilAt

        cEnum    := QRYENT01->ZZE_ZGRPEN
        cExter   := QRYENT01->ZZE_ZEXTID
        cDoc     := QRYENT01->ZZE_NUMNF
        cSeri    := QRYENT01->ZZE_SERNFE
        dAltVct  := QRYENT01->ZZE_DTALTE
        cChavNfe := QRYENT01->ZZE_CHVNF
        nRecn    := QRYENT01->RECNO
        cCentCus := QRYENT01->ZZE_CC
        
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

        QRYENT01->(dbSkip())
        LOOP
    ENDDO	
    QRYENT01->(DBCLOSEAREA())
    conout("FINALIZOU JOBNFE - 01")
    RpcClearEnv()

    if !empty(cLog)
        cArqLog := 'JOB01_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        MemoWrite(cDirLog + cArqLog, cLog)
    endif

    ConOut(OemToAnsi("Fim : ")+Time())

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


Static Function ROBo01()
    Local aPed:= {}
	AAdd(aPed, {'2651077', '15' })
	AAdd(aPed, {'2871189', '15' })
	AAdd(aPed, {'2870107', '15' })
	AAdd(aPed, {'2869703', '15' })
	AAdd(aPed, {'2866895', '15' })
	AAdd(aPed, {'2862994', '15' })
	AAdd(aPed, {'2862934', '15' })
	AAdd(aPed, {'2858147', '15' })
	AAdd(aPed, {'2858074', '15' })
	AAdd(aPed, {'2857156', '15' })
	AAdd(aPed, {'2856816', '15' })
	AAdd(aPed, {'2856154', '15' })
	AAdd(aPed, {'2854163', '15' })
	AAdd(aPed, {'2849232', '15' })
	AAdd(aPed, {'2846759', '15' })
	AAdd(aPed, {'2860937', '15' })
	AAdd(aPed, {'2850129', '15' })
	AAdd(aPed, {'2842690', '15' })
	AAdd(aPed, {'2839411', '15' })
	AAdd(aPed, {'2833142', '15' })
	AAdd(aPed, {'2830494', '15' })
	AAdd(aPed, {'2827788', '15' })
	AAdd(aPed, {'2819851', '15' })
	AAdd(aPed, {'2812677', '15' })
	AAdd(aPed, {'2803343', '15' })
	AAdd(aPed, {'2868055', '15' })
	AAdd(aPed, {'2758800', '15' })
	AAdd(aPed, {'2761699', '15' })
	AAdd(aPed, {'2886834', '15' })
	AAdd(aPed, {'2885202', '15' })
	AAdd(aPed, {'2883643', '15' })
	AAdd(aPed, {'2879977', '15' })
	AAdd(aPed, {'2877737', '15' })
	AAdd(aPed, {'2877044', '15' })
	AAdd(aPed, {'2874563', '15' })
	AAdd(aPed, {'2874217', '15' })
	AAdd(aPed, {'2873973', '15' })
	AAdd(aPed, {'2873055', '15' })
	AAdd(aPed, {'2870215', '15' })
	AAdd(aPed, {'2869134', '15' })
	AAdd(aPed, {'2867618', '15' })
	AAdd(aPed, {'2867382', '15' })
	AAdd(aPed, {'2862398', '15' })
	AAdd(aPed, {'2858062', '15' })
	AAdd(aPed, {'2856381', '15' })
	AAdd(aPed, {'2854388', '15' })
	AAdd(aPed, {'2853596', '15' })
	AAdd(aPed, {'2853523', '15' })
	AAdd(aPed, {'2852367', '15' })
	AAdd(aPed, {'2850328', '15' })
	AAdd(aPed, {'2847441', '15' })
	AAdd(aPed, {'2845356', '15' })
	AAdd(aPed, {'2842254', '15' })
	AAdd(aPed, {'2841558', '15' })
	AAdd(aPed, {'2837209', '15' })
	AAdd(aPed, {'2831569', '15' })
	AAdd(aPed, {'2831324', '15' })
	AAdd(aPed, {'2830748', '15' })
	AAdd(aPed, {'2829809', '15' })
	AAdd(aPed, {'2829019', '15' })
	AAdd(aPed, {'2828494', '15' })
	AAdd(aPed, {'2826387', '15' })
	AAdd(aPed, {'2826187', '15' })
	AAdd(aPed, {'2825977', '15' })
	AAdd(aPed, {'2823190', '15' })
	AAdd(aPed, {'2766610', '15' })
	AAdd(aPed, {'2742297', '15' })
	AAdd(aPed, {'2869337', '15' })
	AAdd(aPed, {'2896848', '15' })
	AAdd(aPed, {'2900781', '15' })
	AAdd(aPed, {'2890899', '15' })
	AAdd(aPed, {'2883787', '15' })
	AAdd(aPed, {'2899359', '15' })
	AAdd(aPed, {'2887015', '15' })
	AAdd(aPed, {'2890333', '15' })
	AAdd(aPed, {'2873415', '15' })
	AAdd(aPed, {'2877296', '15' })
	AAdd(aPed, {'2869643', '15' })
	AAdd(aPed, {'2848021', '15' })
	AAdd(aPed, {'2857324', '15' })
	AAdd(aPed, {'2894082', '15' })
	AAdd(aPed, {'2886052', '15' })
	AAdd(aPed, {'2646614', '15' })
	AAdd(aPed, {'2891000', '15' })
	AAdd(aPed, {'2894546', '15' })
	AAdd(aPed, {'2875594', '15' })
	AAdd(aPed, {'2904411', '15' })
	AAdd(aPed, {'2858811', '15' })
	AAdd(aPed, {'2843915', '15' })
	AAdd(aPed, {'2789839', '15' })
	AAdd(aPed, {'2777588', '15' })
	AAdd(aPed, {'2830901', '15' })
	AAdd(aPed, {'2827294', '15' })
Return aPed

Static Function ROBo02()
    Local aPed := {}
		AAdd(aPed, {'2885754', '15', '2' })
		AAdd(aPed, {'2706756', '15', '2' })
		AAdd(aPed, {'2867378', '15', '2' })
		AAdd(aPed, {'2857928', '15', '2' })
		AAdd(aPed, {'2865752', '15', '2' })
		AAdd(aPed, {'2890435', '15', '2' })
		AAdd(aPed, {'2862934', '15', '2' })
		AAdd(aPed, {'2860546', '15', '2' })
		AAdd(aPed, {'2707790', '15', '2' })
		AAdd(aPed, {'2878400', '15', '2' })
		AAdd(aPed, {'2891804', '15', '2' })
		AAdd(aPed, {'2899344', '15', '2' })
		AAdd(aPed, {'2889127', '15', '2' })
		AAdd(aPed, {'2903827', '15', '2' })
		AAdd(aPed, {'2881986', '15', '2' })
		AAdd(aPed, {'2892098', '15', '2' })
		AAdd(aPed, {'2768398', '15', '2' })
		AAdd(aPed, {'2857156', '15', '2' })
		AAdd(aPed, {'2907417', '15', '2' })
		AAdd(aPed, {'2860057', '15', '2' })
		AAdd(aPed, {'2767679', '15', '2' })
		AAdd(aPed, {'2703263', '15', '2' })
		AAdd(aPed, {'2742911', '15', '2' })
		AAdd(aPed, {'2742297', '15', '2' })
		AAdd(aPed, {'2831569', '15', '2' })
		AAdd(aPed, {'2901005', '15', '2' })
		AAdd(aPed, {'2901086', '15', '2' })
		AAdd(aPed, {'2842690', '15', '2' })
		AAdd(aPed, {'2871189', '15', '2' })
		AAdd(aPed, {'2866552', '15', '2' })
		AAdd(aPed, {'2833142', '15', '2' })
		AAdd(aPed, {'2862994', '15', '2' })
		AAdd(aPed, {'2857848', '15', '2' })
		AAdd(aPed, {'2849186', '15', '2' })
		AAdd(aPed, {'2860183', '15', '2' })
		AAdd(aPed, {'2839927', '15', '2' })
		AAdd(aPed, {'2841242', '15', '2' })
		AAdd(aPed, {'2892228', '15', '2' })
		AAdd(aPed, {'2900605', '15', '2' })
		AAdd(aPed, {'2883787', '15', '2' })
		AAdd(aPed, {'2846484', '15', '2' })
		AAdd(aPed, {'2841174', '15', '2' })
		AAdd(aPed, {'2843915', '15', '2' })
		AAdd(aPed, {'2887176', '15', '2' })
		AAdd(aPed, {'2907089', '15', '2' })
		AAdd(aPed, {'2895788', '15', '2' })
		AAdd(aPed, {'2904097', '15', '2' })
		AAdd(aPed, {'2865209', '15', '2' })
		AAdd(aPed, {'2860692', '15', '2' })
		AAdd(aPed, {'2833098', '15', '2' })    

Return aPed

Static Function ROBo03()
    Local aPed := {}
		AAdd(aPed, {'2766610', '15', '3' })
		AAdd(aPed, {'2801992', '15', '3' })
		AAdd(aPed, {'2865631', '15', '3' })
		AAdd(aPed, {'2851177', '15', '3' })
		AAdd(aPed, {'2850775', '15', '3' })
		AAdd(aPed, {'2856051', '15', '3' })
		AAdd(aPed, {'2872723', '15', '3' })
		AAdd(aPed, {'2889885', '15', '3' })
		AAdd(aPed, {'2870584', '15', '3' })
		AAdd(aPed, {'2898337', '15', '3' })
		AAdd(aPed, {'2868089', '15', '3' })
		AAdd(aPed, {'2877296', '15', '3' })
		AAdd(aPed, {'2890853', '15', '3' })
		AAdd(aPed, {'2867986', '15', '3' })
		AAdd(aPed, {'2858550', '15', '3' })
		AAdd(aPed, {'2858074', '15', '3' })
		AAdd(aPed, {'2839467', '15', '3' })
		AAdd(aPed, {'2909140', '15', '3' })
		AAdd(aPed, {'2851795', '15', '3' })
		AAdd(aPed, {'2856716', '15', '3' })
		AAdd(aPed, {'2877737', '15', '3' })
		AAdd(aPed, {'2840791', '15', '3' })
		AAdd(aPed, {'2879691', '15', '3' })
		AAdd(aPed, {'2832439', '15', '3' })
		AAdd(aPed, {'2826387', '15', '3' })
		AAdd(aPed, {'2900891', '15', '3' })
		AAdd(aPed, {'2879761', '15', '3' })
		AAdd(aPed, {'2885603', '15', '3' })
		AAdd(aPed, {'2869703', '15', '3' })
		AAdd(aPed, {'2861386', '15', '3' })
		AAdd(aPed, {'2784039', '15', '3' })
		AAdd(aPed, {'2908307', '15', '3' })
		AAdd(aPed, {'2907551', '15', '3' })
		AAdd(aPed, {'2881404', '15', '3' })
		AAdd(aPed, {'2903543', '15', '3' })
		AAdd(aPed, {'2855138', '15', '3' })
		AAdd(aPed, {'2863658', '15', '3' })
		AAdd(aPed, {'2909464', '15', '3' })
		AAdd(aPed, {'2872865', '15', '3' })
		AAdd(aPed, {'2887787', '15', '3' })
		AAdd(aPed, {'2707815', '15', '3' })
		AAdd(aPed, {'2851079', '15', '3' })
		AAdd(aPed, {'2787108', '15', '3' })
		AAdd(aPed, {'2891284', '15', '3' })
		AAdd(aPed, {'2891841', '15', '3' })
		AAdd(aPed, {'2879718', '15', '3' })
		AAdd(aPed, {'2858147', '15', '3' })
		AAdd(aPed, {'2777113', '15', '3' })
		AAdd(aPed, {'2758800', '15', '3' })
		AAdd(aPed, {'2877824', '15', '3' })

Return aPed

Static Function ROBo04()
    Local aPed := {}
		AAdd(aPed, {'2886445', '15', '4' })
		AAdd(aPed, {'2863667', '15', '4' })
		AAdd(aPed, {'2891128', '15', '4' })
		AAdd(aPed, {'2496602', '15', '4' })
		AAdd(aPed, {'2906257', '15', '4' })
		AAdd(aPed, {'2901224', '15', '4' })
		AAdd(aPed, {'2769883', '15', '4' })
		AAdd(aPed, {'2772888', '15', '4' })
		AAdd(aPed, {'2803343', '15', '4' })
		AAdd(aPed, {'2877987', '15', '4' })
		AAdd(aPed, {'2853454', '15', '4' })
		AAdd(aPed, {'2894401', '15', '4' })
		AAdd(aPed, {'2903354', '15', '4' })
		AAdd(aPed, {'2869905', '15', '4' })
		AAdd(aPed, {'2883793', '15', '4' })
		AAdd(aPed, {'2770424', '15', '4' })
		AAdd(aPed, {'2855901', '15', '4' })
		AAdd(aPed, {'2872341', '15', '4' })
		AAdd(aPed, {'2902316', '15', '4' })
		AAdd(aPed, {'2806252', '15', '4' })
		AAdd(aPed, {'2886725', '15', '4' })
		AAdd(aPed, {'2899796', '15', '4' })
		AAdd(aPed, {'2896510', '15', '4' })
		AAdd(aPed, {'2907536', '15', '4' })
		AAdd(aPed, {'2785228', '15', '4' })
		AAdd(aPed, {'2498190', '15', '4' })
		AAdd(aPed, {'2874358', '15', '4' })
		AAdd(aPed, {'2885873', '15', '4' })
		AAdd(aPed, {'2837795', '15', '4' })
		AAdd(aPed, {'2850724', '15', '4' })
		AAdd(aPed, {'2895817', '15', '4' })
		AAdd(aPed, {'2856816', '15', '4' })
		AAdd(aPed, {'2872955', '15', '4' })
		AAdd(aPed, {'2856099', '15', '4' })
		AAdd(aPed, {'2769875', '15', '4' })
		AAdd(aPed, {'2837611', '15', '4' })
		AAdd(aPed, {'2870039', '15', '4' })
		AAdd(aPed, {'2900407', '15', '4' })
		AAdd(aPed, {'2837311', '15', '4' })
		AAdd(aPed, {'2870775', '15', '4' })
		AAdd(aPed, {'2871249', '15', '4' })
		AAdd(aPed, {'2867889', '15', '4' })
		AAdd(aPed, {'2896861', '15', '4' })
		AAdd(aPed, {'2868055', '15', '4' })
		AAdd(aPed, {'2892822', '15', '4' })
		AAdd(aPed, {'2906689', '15', '4' })
		AAdd(aPed, {'2848231', '15', '4' })
		AAdd(aPed, {'2839141', '15', '4' })
		AAdd(aPed, {'2791013', '15', '4' })
		AAdd(aPed, {'2773126', '15', '4' })

Return aPed

Static Function ROBo05()
    Local aPed := {}
		AAdd(aPed, {'2766776', '15', '5' })
		AAdd(aPed, {'2857275', '15', '5' })
		AAdd(aPed, {'2850739', '15', '5' })
		AAdd(aPed, {'2850765', '15', '5' })
		AAdd(aPed, {'2851440', '15', '5' })
		AAdd(aPed, {'2875071', '15', '5' })
		AAdd(aPed, {'2892393', '15', '5' })
		AAdd(aPed, {'2829019', '15', '5' })
		AAdd(aPed, {'2885674', '15', '5' })
		AAdd(aPed, {'2878429', '15', '5' })
		AAdd(aPed, {'2905788', '15', '5' })
		AAdd(aPed, {'2883498', '15', '5' })
		AAdd(aPed, {'2909949', '15', '5' })
		AAdd(aPed, {'2829596', '15', '5' })
		AAdd(aPed, {'2834937', '15', '5' })
		AAdd(aPed, {'2860210', '15', '5' })
		AAdd(aPed, {'2781531', '15', '5' })
		AAdd(aPed, {'2866212', '15', '5' })
		AAdd(aPed, {'2901241', '15', '5' })
		AAdd(aPed, {'2861145', '15', '5' })
		AAdd(aPed, {'2856184', '15', '5' })
		AAdd(aPed, {'2869134', '15', '5' })
		AAdd(aPed, {'2873210', '15', '5' })
		AAdd(aPed, {'2787577', '15', '5' })
		AAdd(aPed, {'2656679', '15', '5' })
		AAdd(aPed, {'2764976', '15', '5' })
		AAdd(aPed, {'2785178', '15', '5' })
		AAdd(aPed, {'2869893', '15', '5' })
		AAdd(aPed, {'2907266', '15', '5' })
		AAdd(aPed, {'2721404', '15', '5' })
		AAdd(aPed, {'2854718', '15', '5' })
		AAdd(aPed, {'2854944', '15', '5' })
		AAdd(aPed, {'2853892', '15', '5' })
		AAdd(aPed, {'2853501', '15', '5' })
		AAdd(aPed, {'2853507', '15', '5' })
		AAdd(aPed, {'2853524', '15', '5' })
		AAdd(aPed, {'2906434', '15', '5' })
		AAdd(aPed, {'2876868', '15', '5' })
		AAdd(aPed, {'2885202', '15', '5' })
		AAdd(aPed, {'2880737', '15', '5' })
		AAdd(aPed, {'2872521', '15', '5' })
		AAdd(aPed, {'2891461', '15', '5' })
		AAdd(aPed, {'2886477', '15', '5' })
		AAdd(aPed, {'2877395', '15', '5' })
		AAdd(aPed, {'2857006', '15', '5' })
		AAdd(aPed, {'2857324', '15', '5' })
		AAdd(aPed, {'2849232', '15', '5' })
		AAdd(aPed, {'2890333', '15', '5' })
		AAdd(aPed, {'2884732', '15', '5' })
		AAdd(aPed, {'2732810', '15', '5' })

Return aPed

Static Function ROBo06()
    Local aPed := {}
		AAdd(aPed, {'2867618', '15', '6' })
		AAdd(aPed, {'2854324', '15', '6' })
		AAdd(aPed, {'2887015', '15', '6' })
		AAdd(aPed, {'2877787', '15', '6' })
		AAdd(aPed, {'2875818', '15', '6' })
		AAdd(aPed, {'2869020', '15', '6' })
		AAdd(aPed, {'2879977', '15', '6' })
		AAdd(aPed, {'2878579', '15', '6' })
		AAdd(aPed, {'2725290', '15', '6' })
		AAdd(aPed, {'2811252', '15', '6' })
		AAdd(aPed, {'2781136', '15', '6' })
		AAdd(aPed, {'2780752', '15', '6' })
		AAdd(aPed, {'2837829', '15', '6' })
		AAdd(aPed, {'2791117', '15', '6' })
		AAdd(aPed, {'2900590', '15', '6' })
		AAdd(aPed, {'2900903', '15', '6' })
		AAdd(aPed, {'2859050', '15', '6' })
		AAdd(aPed, {'2884368', '15', '6' })
		AAdd(aPed, {'2884729', '15', '6' })
		AAdd(aPed, {'2896387', '15', '6' })
		AAdd(aPed, {'2894082', '15', '6' })
		AAdd(aPed, {'2770402', '15', '6' })
		AAdd(aPed, {'2867315', '15', '6' })
		AAdd(aPed, {'2814023', '15', '6' })
		AAdd(aPed, {'2866236', '15', '6' })
		AAdd(aPed, {'2905224', '15', '6' })
		AAdd(aPed, {'2888077', '15', '6' })
		AAdd(aPed, {'2864659', '15', '6' })
		AAdd(aPed, {'2857167', '15', '6' })
		AAdd(aPed, {'2854163', '15', '6' })
		AAdd(aPed, {'2854388', '15', '6' })
		AAdd(aPed, {'2890561', '15', '6' })
		AAdd(aPed, {'2856906', '15', '6' })
		AAdd(aPed, {'2856381', '15', '6' })
		AAdd(aPed, {'2872638', '15', '6' })
		AAdd(aPed, {'2876942', '15', '6' })
		AAdd(aPed, {'2839411', '15', '6' })
		AAdd(aPed, {'2856154', '15', '6' })
		AAdd(aPed, {'2868460', '15', '6' })
		AAdd(aPed, {'2869643', '15', '6' })
		AAdd(aPed, {'2896791', '15', '6' })
		AAdd(aPed, {'2873705', '15', '6' })
		AAdd(aPed, {'2888077', '15', '6' })
		AAdd(aPed, {'2870187', '15', '6' })
		AAdd(aPed, {'2812615', '15', '6' })
		AAdd(aPed, {'2839598', '15', '6' })
		AAdd(aPed, {'2891712', '15', '6' })
		AAdd(aPed, {'2850328', '15', '6' })
		AAdd(aPed, {'2900781', '15', '6' })
		AAdd(aPed, {'2896830', '15', '6' })
		AAdd(aPed, {'2816449', '15', '6' })

Return aPed

Static Function ROBo07()
    Local aPed := {}
		AAdd(aPed, {'2852520', '15', '7' })
		AAdd(aPed, {'2816012', '15', '7' })
		AAdd(aPed, {'2825977', '15', '7' })
		AAdd(aPed, {'2850785', '15', '7' })
		AAdd(aPed, {'2844852', '15', '7' })
		AAdd(aPed, {'2855256', '15', '7' })
		AAdd(aPed, {'2852873', '15', '7' })
		AAdd(aPed, {'2873089', '15', '7' })
		AAdd(aPed, {'2856580', '15', '7' })
		AAdd(aPed, {'2845808', '15', '7' })
		AAdd(aPed, {'2892848', '15', '7' })
		AAdd(aPed, {'2896889', '15', '7' })
		AAdd(aPed, {'2875386', '15', '7' })
		AAdd(aPed, {'2891000', '15', '7' })
		AAdd(aPed, {'2896625', '15', '7' })
		AAdd(aPed, {'2901954', '15', '7' })
		AAdd(aPed, {'2820855', '15', '7' })
		AAdd(aPed, {'2892847', '15', '7' })
		AAdd(aPed, {'2879726', '15', '7' })
		AAdd(aPed, {'2850129', '15', '7' })
		AAdd(aPed, {'2844854', '15', '7' })
		AAdd(aPed, {'2870215', '15', '7' })
		AAdd(aPed, {'2856586', '15', '7' })
		AAdd(aPed, {'2886052', '15', '7' })
		AAdd(aPed, {'2858062', '15', '7' })
		AAdd(aPed, {'2875380', '15', '7' })
		AAdd(aPed, {'2875594', '15', '7' })
		AAdd(aPed, {'2890899', '15', '7' })
		AAdd(aPed, {'2897494', '15', '7' })
		AAdd(aPed, {'2881022', '15', '7' })
		AAdd(aPed, {'2770129', '15', '7' })
		AAdd(aPed, {'2761699', '15', '7' })
		AAdd(aPed, {'2853731', '15', '7' })
		AAdd(aPed, {'2855113', '15', '7' })
		AAdd(aPed, {'2902829', '15', '7' })
		AAdd(aPed, {'2874217', '15', '7' })
		AAdd(aPed, {'2910804', '15', '7' })
		AAdd(aPed, {'2853784', '15', '7' })
		AAdd(aPed, {'2894546', '15', '7' })
		AAdd(aPed, {'2853523', '15', '7' })
		AAdd(aPed, {'2877414', '15', '7' })
		AAdd(aPed, {'2873055', '15', '7' })
		AAdd(aPed, {'2831324', '15', '7' })
		AAdd(aPed, {'2846759', '15', '7' })
		AAdd(aPed, {'2789839', '15', '7' })
		AAdd(aPed, {'2864589', '15', '7' })
		AAdd(aPed, {'2873973', '15', '7' })
		AAdd(aPed, {'2882929', '15', '7' })
		AAdd(aPed, {'2864000', '15', '7' })
		AAdd(aPed, {'2906975', '15', '7' })

Return aPed

Static Function ROBo08()
    Local aPed := {}
		AAdd(aPed, {'2853738', '15', '8' })
		AAdd(aPed, {'2899359', '15', '8' })
		AAdd(aPed, {'2853783', '15', '8' })
		AAdd(aPed, {'2904411', '15', '8' })
		AAdd(aPed, {'2862398', '15', '8' })
		AAdd(aPed, {'2829809', '15', '8' })
		AAdd(aPed, {'2856717', '15', '8' })
		AAdd(aPed, {'2886834', '15', '8' })
		AAdd(aPed, {'2897146', '15', '8' })
		AAdd(aPed, {'2869337', '15', '8' })
		AAdd(aPed, {'2865957', '15', '8' })
		AAdd(aPed, {'2827940', '15', '8' })
		AAdd(aPed, {'2830661', '15', '8' })
		AAdd(aPed, {'2865855', '15', '8' })
		AAdd(aPed, {'2823190', '15', '8' })
		AAdd(aPed, {'2830748', '15', '8' })
		AAdd(aPed, {'2863752', '15', '8' })
		AAdd(aPed, {'2853596', '15', '8' })
		AAdd(aPed, {'2757242', '15', '8' })
		AAdd(aPed, {'2769324', '15', '8' })
		AAdd(aPed, {'2860901', '15', '8' })
		AAdd(aPed, {'2859296', '15', '8' })
		AAdd(aPed, {'2905382', '15', '8' })
		AAdd(aPed, {'2908374', '15', '8' })
		AAdd(aPed, {'2846675', '15', '8' })
		AAdd(aPed, {'2847441', '15', '8' })
		AAdd(aPed, {'2874563', '15', '8' })
		AAdd(aPed, {'2898962', '15', '8' })
		AAdd(aPed, {'2838789', '15', '8' })
		AAdd(aPed, {'2884363', '15', '8' })
		AAdd(aPed, {'2646614', '15', '8' })
		AAdd(aPed, {'2651077', '15', '8' })
		AAdd(aPed, {'2827788', '15', '8' })	

Return aPed
