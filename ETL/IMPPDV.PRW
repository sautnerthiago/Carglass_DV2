#include "totvs.ch"
#include "protheus.ch"
#include "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

User Function ImpPDV()
    Local cTBjob  := GetNextAlias()
    Local cTBEXT  := GetNextAlias()
    Local lTemPr  := .T.
    Local lTemCli := .T.
    Local aItens  := {}
    Local aCab    := {}
    Local nLinha

    Local cDirLog := '\x_logs\'
    Local cArqLog := ''
    
    Local cEmpAt1 := cEmpAnt
    Local cFilAt1 := cFilAnt

    PREPARE ENVIRONMENT EMPRESA '01' FILIAL '01' MODULO 'FAT'

    IF !ExistDir(cDirLog)
        MakeDir(cDirLog)
    EndIF    

	oWS    := LIBGLASS():new()
    ConOut("iniciando pedido de Vendas")

    cQueryTab := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZG") + " ZZG " + CRLF
    cQueryTab += " WHERE " + CRLF
    cQueryTab += "     ZZG.D_E_L_E_T_ = '' AND ZZG_STATUS = '0' AND ZZG_TIPO = 'OV' " + CRLF
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
        cQuery += "     ZZG.D_E_L_E_T_ = '' AND ZZG_STATUS = '0' AND ZZG_ZEXTID = '"+cExter+"' AND ZZG_TIPO = 'OV' " + CRLF
        DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cTBEXT, .F., .T.)    

        WHILE !(cTBEXT)->(Eof()) 
            aRet    := {}
            aLinhaC1:= {}
            
            // IncProc("ExternID: " + Alltrim((cTBEXT)->ZZG_ZEXTID) )

            _cod    := (cTBEXT)->ZZG_PRODUT
            lTemPr  := oWS:temProd(FWxFilial("SB1"), _cod)

            _Cli    := (cTBEXT)->ZZG_CLIENT
            _lojCli := "01"
            lTemCLi := ows:temCliCod(FWxFilial("SA1"), _Cli, _lojCli)

            nRecn   := (cTBEXT)->RECNO
            _cCusto := (cTBEXT)->ZZG_CC

            _ZEXTID := (cTBEXT)->ZZG_ZEXTID
            _Enum   := (cTBEXT)->ZZG_ENUM
            aRet    := oWs:PGExtPDV( _Enum + _ZEXTID )
            cTemCont:= oWs:TemCont(_cod)

            IF !lTemCLi
                ConOut("ERRO CLIENTE")
                cErrorLog   := "CLIENTE NÃO EXISTE"
                oWS:GRVLGZZG(nRecn, cExter, cErrorLog, "IMPPDV", "INCLUSÃO DE PEDIDO DE Vendas")
                (cTBEXT)->(DBSKIP())
                LOOP
            EndIF

            IF !lTemPr
                ConOut("ERRO PRODUTO")
                cErrorLog   := "PRODUTO NÃO EXISTE"
                oWS:GRVLGZZG(nRecn, cExter, cErrorLog, "IMPPDV", "INCLUSÃO DE PEDIDO DE Vendas")
                (cTBEXT)->(DBSKIP())
                LOOP
            EndIF

            IF len(aRet) > 0
                ConOut("ERRO EXTERID")
                cErrorLog   := "EXTERID JA CADASTRADO"
                oWS:GRVLGZZG(nRecn, cExter, cErrorLog, "IMPPDV", "INCLUSÃO DE PEDIDO DE Vendas")
                (cTBEXT)->(DBSKIP())
                LOOP
            Endif

            _cNumPed := oWs:GrPedVd(cFilAt)
            cIdUiv  := _Enum + _ZEXTID  

            IF LEN(aCab) == 0
                aadd(aCab, {"C5_NUM"       , _cNumPed               ,Nil})
                aadd(aCab, {"C5_EMISSAO"   , (cTBEXT)->ZZG_DTEMIS   ,Nil})
                aadd(aCab, {"C5_CLIENTE"   , _Cli                   ,nIL})    
                aadd(aCab, {"C5_LOJACLI"   , _lojCli                ,nIL})    
                aadd(aCab, {"C5_LOJAENT"   , (cTBEXT)->ZZG_FILENT   ,Nil})
                aadd(aCab, {"C5_CONDPAG"   , (cTBEXT)->ZZG_COND     ,Nil})
                aadd(aCab, {"C5_ZINTEGR"   , (cTBEXT)->ZZG_INTEGR   ,Nil})
                aadd(aCab, {"C5_ZEXTID"    , (cTBEXT)->ZZG_ZEXTID   ,Nil})
                aadd(aCab, {"C5_SINISTR"   , (cTBEXT)->ZZG_SINIST   ,Nil})
                aadd(aCab, {"C5_PLACA"     , (cTBEXT)->ZZG_PLACA    ,Nil})
                aadd(aCab, {"C5_INDPRES"   , "1"                    ,Nil})
                aadd(aCab, {"C5_TIPOCLI"   , _TpCli                 ,Nil})
                aadd(aCab, {"C5_TPFRETE"   , "S"                    ,Nil})
                aadd(aCab, {"C5_ZGRPNUM"   , (cTBEXT)->ZZG_ENUM     ,Nil})
                aadd(aCab, {"C5_ZIDPDVI"   , cIdUiv                 ,Nil})

            EndIF

            nTotal  := ((cTBEXT)->ZZG_QUANTI * (cTBEXT)->ZZG_VLRUNI)
            cUM     := POSICIONE("SB1",1,xFilial("SB1")+(cTBEXT)->ZZG_PRODUT,"B1_UM")
            cDesc   := POSICIONE("SB1",1,xFilial("SB1")+(cTBEXT)->ZZG_PRODUT,"B1_DESC")

            aadd(aLinhaC1, {"C6_ITEM"     , (cTBEXT)->ZZG_ITEM      , NIL})
            aadd(aLinhaC1, {"C6_PRODUTO"  , (cTBEXT)->ZZG_PRODUT    , NIL})
            aadd(aLinhaC1, {"C6_QTDVEN"   , (cTBEXT)->ZZG_QUANTI    , NIL})
            aadd(aLinhaC1, {"C6_QTDLIB"   , (cTBEXT)->ZZG_QUANTI    , NIL})
            aadd(aLinhaC1, {"C6_PRCVEN"   , (cTBEXT)->ZZG_VLRUNI    , NIL})
            aadd(aLinhaC1, {"C6_VALDESC"  , (cTBEXT)->ZZG_DESC      , NIL})
            aadd(aLinhaC1, {"C6_VALOR"    , nTotal                  , Nil}) 
            aadd(aLinhaC1, {"C6_OPER"     , (cTBEXT)->ZZG_TPOPER    , NIL})
            aadd(aLinhaC1, {"C6_DESCRI"   , cDesc                   , NIL})
            aadd(aLinhaC1, {"C6_CCUSTO"   , _cCusto                 , NIL})            
            aadd(aLinhaC1, {"C6_CONTA"    , cTemCont                , NIL})          
            aadd(aItens,aLinhaC1)

            (cTBEXT)->(DBSKIP())
            LOOP
        ENDDO
        (cTBEXT)->(dbclosearea())

        if len(aCab) > 0
            RPCSetEnv(cEmpAt, cFilAt)
    
            MSExecAuto({|X,Y,Z| MATA410(X,Y,Z)}, aCab, aItens, 3)
            If !lMsErroAuto
                ConOut("ERRO GRAVAÇÃO DO PEDIDO DE Vendas")
                cErrorLog   := ''
                aLogAuto    := aRetGrv // GetAutoGrLog()
                For nLinha := 1 To Len(aLogAuto)
                    cErrorLog += aLogAuto[nLinha,1] + CRLF
                Next nLinha
                cArqLog := 'WSPEDCOM_New_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
                MemoWrite(cDirLog + cArqLog, cErrorLog)
                cErrorLog   := "EXTERID JA CADASTRADO"
                oWS:GRVLGZZG(nRecn, cExter, cErrorLog, "IMPPDV", "INCLUSÃO DE PEDIDO DE Vendas")
            Else
                oWS:mudStZZG(nRecn, cExter, "1")
            EndIf
        Endif
        (cTBjob)->(dbSkip())
        LOOP
    EndDo
    (cTBjob)->(dbclosearea())
    cEmpAnt  := cEmpAt1
    cFilAnt  := cFilAt1
    RESET ENVIRONMENT
    
RETURN
