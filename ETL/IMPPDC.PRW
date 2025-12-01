#include "totvs.ch"
#include "protheus.ch"
#include "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

User Function ImpPDC()
    Local aArea  := GetArea()
    	Processa({||ImpDados()},"Aguarde Gerando Pedido de Compras - OC " )
    RestArea(aArea)
Return
Static Function ImpDados()
    Local cTBjob  := GetNextAlias()
    Local cTBEXT  := GetNextAlias()
    Local lTemPr  := .T.
    Local lTemFor := .T.
    Local aItens  := {}
    Local aCab    := {}
    Local nLinha

    Local cDirLog := '\x_logs\'
    Local cArqLog := ''
    
    Local cEmpAt1 := cEmpAnt
    Local cFilAt1 := cFilAnt

    IF !ExistDir(cDirLog)
        MakeDir(cDirLog)
    EndIF    

	oWS    := LIBGLASS():new()
    ConOut("iniciando pedido de compras")

    cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZG") + " ZZG " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZG.D_E_L_E_T_ = '' AND ZZG_STATUS = '0' AND ZZG_TIPO = 'OC' " + CRLF
    DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQueryTab),cTBjob, .F., .T.)    

    cEmpAt   := Iif(EMPTY((cTBjob)->ZZG_GRUPO ), "01", (cTBjob)->ZZG_GRUPO )
    cFilAt   := Iif(EMPTY((cTBjob)->ZZG_FILIAL), "01", (cTBjob)->ZZG_FILIAL)

    cEmpAnt  := cEmpAt
    cFilAnt  := cFilAt

	(cTBjob)->(DBGoTop())
    While !(cTBjob)->(Eof())
        cExter := (cTBjob)->ZZG_ZEXTID
        aItens := {}
        aCab   := {}

        cQuery := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
        cQuery += " FROM " + CRLF
        cQuery += "     " + RetSQLName("ZZG") + " ZZG " + CRLF
        cQuery += " WHERE " + CRLF
        cQuery += "     ZZG.D_E_L_E_T_ = '' AND ZZG_STATUS = '0' AND ZZG_ZEXTID = '"+cExter+"' AND ZZG_TIPO = 'OC' " + CRLF
        DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cTBEXT, .F., .T.)    

        WHILE !(cTBEXT)->(Eof()) 
            aRet    := {}
            aLinhaC1:= {}
            
            IncProc("ExternID: " + Alltrim((cTBEXT)->ZZG_ZEXTID) )

            _cod    := (cTBEXT)->ZZG_PRODUT
            lTemPr  := oWS:temProd(FWxFilial("SB1"), _cod)

            cTamSp  := (cTBEXT)->ZZG_FORNEC
            _For    := cTamSp + Space(10-len(cTamSp))
            _lojFor := "01"
            lTemFor := ows:temForCod(FWxFilial("SA2"), _For, _lojFor)
            nRecn   := (cTBEXT)->RECNO
            _cCusto := (cTBEXT)->ZZG_CC

            _ZEXTID := (cTBEXT)->ZZG_ZEXTID
            _Enum   := (cTBEXT)->ZZG_ENUM
            aRet    := oWs:PGExtDad( _Enum + _ZEXTID )
            cTemCont:= oWs:TemCont(_cod)

            IF Empty(cTemCont)
                ConOut("ERRO PRODUTO SEM CONTA CONTABIL")
                cErrorLog   := "PRODUTO NÃO TEM CONTA CONTABIL"
                oWS:GRVLGZZG(nRecn, cExter, cErrorLog, "IMPPDC", "INCLUSÃO DE PEDIDO DE COMPRAS")
                (cTBEXT)->(DBSKIP())
                LOOP
            Endif

            IF !lTemFor
                ConOut("ERRO FORNECEDOR")
                cErrorLog   := "FORNECEDOR NÃO EXISTE"
                oWS:GRVLGZZG(nRecn, cExter, cErrorLog, "IMPPDC", "INCLUSÃO DE PEDIDO DE COMPRAS")
                (cTBEXT)->(DBSKIP())
                LOOP
            EndIF

            IF !lTemPr
                ConOut("ERRO PRODUTO")
                cErrorLog   := "PRODUTO NÃO EXISTE"
                oWS:GRVLGZZG(nRecn, cExter, cErrorLog, "IMPPDC", "INCLUSÃO DE PEDIDO DE COMPRAS")
                (cTBEXT)->(DBSKIP())
                LOOP
            EndIF

            IF !(oWs:temCC( _cCusto ))
                ConOut("ERRO CENTRO DE CUSTO")
                cErrorLog   := "CENTRO DE CUSTOS NÃO EXISTE"
                oWS:GRVLGZZG(nRecn, cExter, cErrorLog, "IMPPDC", "INCLUSÃO DE PEDIDO DE COMPRAS")
                (cTBEXT)->(DBSKIP())
                LOOP
            Endif
            
            IF len(aRet) > 0
                ConOut("ERRO EXTERID")
                cErrorLog   := "EXTERID JA CADASTRADO"
                oWS:GRVLGZZG(nRecn, cExter, cErrorLog, "IMPPDC", "INCLUSÃO DE PEDIDO DE COMPRAS")
                (cTBEXT)->(DBSKIP())
                LOOP
            Endif

            _cNumPed := oWs:GrPedCom(cFilAnt)

            IF LEN(aCab) == 0
                aadd(aCab, {"C7_FILIAL"    , cFilAnt                 ,Nil})
                aadd(aCab, {"C7_NUM"       , _cNumPed               ,Nil})
                aadd(aCab, {"C7_EMISSAO"   , (cTBEXT)->ZZG_DTEMIS   ,Nil})
                aadd(aCab, {"C7_MOEDA"     , 1			            ,Nil})
                aadd(aCab, {"C7_TXMOEDA"   , 1			            ,Nil})
                aadd(aCab, {"C7_FORNECE"   , _For                   ,Nil})
                aadd(aCab, {"C7_LOJA"      , _lojFor                ,Nil})
                aadd(aCab, {"C7_COND"      , (cTBEXT)->ZZG_COND     ,Nil})
                aadd(aCab, {"C7_CONTATO"   , (cTBEXT)->ZZG_CONTAT   ,Nil})
                aadd(aCab, {"C7_FILENT"    , (cTBEXT)->ZZG_FILENT   ,Nil})
                aadd(aCab, {"C7_ZINTEGR"   , (cTBEXT)->ZZG_INTEGR   ,Nil})
            EndIF

            nTotal := ((cTBEXT)->ZZG_QUANTI * (cTBEXT)->ZZG_VLRUNI)
        
            aadd(aLinhaC1, {"C7_PRODUTO" , (cTBEXT)->ZZG_PRODUT     ,NIL})
            aadd(aLinhaC1, {"C7_QUANT"   , (cTBEXT)->ZZG_QUANTI     ,NIL})
            aadd(aLinhaC1, {"C7_PRECO"   , (cTBEXT)->ZZG_VLRUNI     ,NIL})
            aadd(aLinhaC1, {"C7_DESC1"   , (cTBEXT)->ZZG_DESC       ,NIL})
            aadd(aLinhaC1, {"C7_VLDESC"  , (cTBEXT)->ZZG_DESC       ,NIL})
            aadd(aLinhaC1, {"C7_TOTAL"   , nTotal                   ,NIL})
            aadd(aLinhaC1, {"C7_OPER"    , (cTBEXT)->ZZG_TPOPER     ,NIL})

            cUM     := POSICIONE("SB1",1,xFilial("SB1")+(cTBEXT)->ZZG_PRODUT,"B1_UM")
            cDesc   := POSICIONE("SB1",1,xFilial("SB1")+(cTBEXT)->ZZG_PRODUT,"B1_DESC")
            cIdUiv  := _Enum + _ZEXTID  

            aadd(aLinhaC1,{"C7_ITEM"    ,(cTBEXT)->ZZG_ITEM          ,nil})
            aadd(aLinhaC1,{"C7_UM"      ,cUM                         ,nil})
            aadd(aLinhaC1,{"C7_DESCRI"  ,cDesc                       ,nil})
            aadd(aLinhaC1,{"C7_LOCAL"   ,"01"                        ,Nil})   
            aadd(aLinhaC1,{"C7_CC"      ,_cCusto                     ,Nil})
            aadd(aLinhaC1,{"C7_OBS"     ,""                          ,Nil})
            aadd(aLinhaC1,{"C7_CONTATO" ,""                          ,Nil})
            aadd(aLinhaC1,{"C7_DATPRF"  ,dDataBase                   ,NIL})
            aadd(aLinhaC1,{"C7_EMISSAO" ,(cTBEXT)->ZZG_DTEMIS        ,NIL})
            aadd(aLinhaC1,{"C7_SEGURO"  ,0.00                        ,NIL})
            aadd(aLinhaC1,{"C7_DESPESA" ,0.00                        ,NIL})  
            aadd(aLinhaC1,{"C7_VALFRE"  ,0.00                        ,NIL})         
            aadd(aLinhaC1,{"C7_ZEXTID"  ,_ZEXTID                     ,Nil})            
            aadd(aLinhaC1,{"C7_ZGRPNUM" , _Enum                      ,Nil})
            aadd(aLinhaC1,{"C7_ZIDPDCI" , cIdUiv                     ,Nil})
            aadd(aLinhaC1,{"C7_CONTA"   , cTemCont                   ,Nil})
            aadd(aItens,aLinhaC1)

            (cTBEXT)->(DBSKIP())
            LOOP
        ENDDO
        (cTBEXT)->(dbclosearea())

        if len(aCab) > 0
            RPCSetEnv(cEmpAt, cFilAt)

            aRetGrv := oWS:pedCompra(aCab, aItens, 5) 
            If !aRetGrv[1,2] 
                ConOut("ERRO EXCLUSÃO DO PEDIDO DE COMPRAS")
                cErrorLog   := ''
                aLogAuto    := aRetGrv 
                For nLinha := 1 To Len(aLogAuto)
                    cErrorLog += aLogAuto[nLinha,1] + CRLF
                Next nLinha
                cArqLog := 'WSPEDCOM_New_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
                MemoWrite(cDirLog + cArqLog, cErrorLog)
                cErrorLog   := "ERRO EXCLUSÃO DO PEDIDO DE COMPRAS"
                oWS:GRVLGZZG(nRecn, cExter, cErrorLog, "IMPPDC", "ERRO EXCLUSÃO DO PEDIDO DE COMPRAS")
            Else
                aRetGrv := oWS:pedCompra(aCab, aItens, 3) 

                If !aRetGrv[1,2] 
                    ConOut("ERRO GRAVAÇÃO DO PEDIDO DE COMPRAS")
                    cErrorLog   := ''
                    aLogAuto    := aRetGrv // GetAutoGrLog()
                    For nLinha := 1 To Len(aLogAuto)
                        cErrorLog += aLogAuto[nLinha,1] + CRLF
                    Next nLinha
                    cArqLog := 'WSPEDCOM_New_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
                    MemoWrite(cDirLog + cArqLog, cErrorLog)
                    cErrorLog   := "EXTERID JA CADASTRADO"
                    oWS:GRVLGZZG(nRecn, cExter, cErrorLog, "IMPPDC", "INCLUSÃO DE PEDIDO DE COMPRAS")
                Else
                    oWS:mudStZZG(nRecn, cExter, "1")
                EndIf
            EndIF
        Endif
        (cTBjob)->(dbSkip())
        LOOP
    EndDo
    (cTBjob)->(dbclosearea())
    cEmpAnt  := cEmpAt1
    cFilAnt  := cFilAt1
    
RETURN
