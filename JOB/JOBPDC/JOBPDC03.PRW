#include "totvs.ch"
#include "protheus.ch"
#include "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

User Function JOBPDC03()
    Local aArea  := GetArea()
   
    Local cTBjob  := GetNextAlias()
    Local cTBEXT  := GetNextAlias()
    Local lTemPr  := .T.
    Local lTemFor := .T.
    Local lTemNota:= .F.
    Local aItens  := {}
    Local aCab    := {}
    Local nLinha
    Local _Fil    := "03"

    Local aPDC01  := {}
    Local X01     := 0  

    Local lExcl   := .T.

    Local aRetGrv := {}

    RPCSetEnv("01", _Fil)

	oWS    := LIBGLASS():new()
    ConOut("iniciando pedido de compras - " + _Fil)

    cQueryTab := " SELECT TOP 20 *, R_E_C_N_O_ RECNO " + CRLF
    cQueryTab += " FROM " + CRLF
    cQueryTab += "     " + RetSQLName("ZZI") + " ZZI WITH (NOLOCK) " + CRLF
    cQueryTab += " WHERE ZZI_FILIAL = '"+_Fil+"' " + CRLF
    cQueryTab += "     AND ZZI.D_E_L_E_T_ = '' AND ZZI_STATUS = '0' " + CRLF
    DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQueryTab),cTBjob, .F., .T.)   
    
    WHILE !((cTBjob)->(EOF()))
        AADD(aPDC01, { (cTBjob)->ZZI_ZGRPEN, (cTBjob)->ZZI_ZEXTID})
        (cTBjob)->(dbSkip())
        LOOP
    ENDDO	
    (cTBjob)->(DBCLOSEAREA()) 

    FOR X01 := 1 TO LEN(aPDC01)
        cExter := aPDC01[X01, 2]
        aItens := {}
        aCab   := {}

        cQuery := " SELECT *, R_E_C_N_O_ RECNO " + CRLF
        cQuery += " FROM " + CRLF
        cQuery += "     " + RetSQLName("ZZI") + " ZZI WITH (NOLOCK) " + CRLF
        cQuery += " WHERE ZZI_FILIAL = '"+ _Fil +"' " + CRLF
        cQuery += "     AND ZZI.D_E_L_E_T_ = '' AND ZZI_STATUS = '0' AND ZZI_ZEXTID = '"+cExter+"' " + CRLF
        DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cTBEXT, .F., .T.)    

        WHILE !(cTBEXT)->(Eof()) 
            aRet    := {}
            aLinhaC1:= {}
            
            IncProc("ExternID: " + Alltrim((cTBEXT)->ZZI_ZEXTID) )

            _cod    := (cTBEXT)->ZZI_PRODUT
            lTemPr  := oWS:temProd(FWxFilial("SB1"), _cod)

            cTamSp  := (cTBEXT)->ZZI_FORNEC
            _For    := cTamSp + Space(10-len(cTamSp))
            _lojFor := "01"
            lTemFor := ows:temForCod(FWxFilial("SA2"), _For, _lojFor)
            nRecn   := (cTBEXT)->RECNO
            _cCusto := (cTBEXT)->ZZI_CENTRO

            _ZEXTID := (cTBEXT)->ZZI_ZEXTID
            _Enum   := (cTBEXT)->ZZI_ZGRPEN
            aRet    := oWs:PGExtDad( _Enum + _ZEXTID ) 
            cTemCont:= oWs:TemCont(_cod)

            if len(aRet) > 0 //tem pedido
                _cNumPed := aRet[1,1]
                lTemNota:= oWs:TemNFE( aRet[1,1] )   //verifica se tem nota
            ELSE
                lExcl := .F.
                _cNumPed := oWs:GrPedCom(cFilAnt)
            endif

            IF Empty(cTemCont)
                ConOut("ERRO PRODUTO SEM CONTA CONTABIL - " + _Fil)
                cError      := "PRODUTO NÃO TEM CONTA CONTABIL"
                cErrorLog   := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO
                oWS:GRVLGZZI(nRecn, cExter, cErrorLog, "IMPPDC", "INCLUSÃO DE PEDIDO DE COMPRAS", cError)
                (cTBEXT)->(DBSKIP())
                LOOP
            Endif

            IF !lTemFor
                ConOut("ERRO FORNECEDOR - " + _Fil)
                cError      := "FORNECEDOR NÃO EXISTE"
                cErrorLog   := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO
                oWS:GRVLGZZI(nRecn, cExter, cErrorLog, "IMPPDC", "INCLUSÃO DE PEDIDO DE COMPRAS", cError)
                (cTBEXT)->(DBSKIP())
                LOOP
            EndIF

            IF !lTemPr
                ConOut("ERRO PRODUTO - " + _Fil)
                cError      := "PRODUTO NÃO EXISTE"
                cErrorLog   := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO
                oWS:GRVLGZZI(nRecn, cExter, cErrorLog, "IMPPDC", "INCLUSÃO DE PEDIDO DE COMPRAS", cError)
                (cTBEXT)->(DBSKIP())
                LOOP
            EndIF

            IF !(oWs:temCC( _cCusto ))
                ConOut("ERRO CENTRO DE CUSTO")
                cError      := "CENTRO DE CUSTOS NÃO EXISTE"
                cErrorLog   := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO
                oWS:GRVLGZZI(nRecn, cExter, cErrorLog, "IMPPDC", "INCLUSÃO DE PEDIDO DE COMPRAS", cError)
                (cTBEXT)->(DBSKIP())
                LOOP
            Endif
            
            IF lTemNota
                ConOut("ERRO EXTERID")
                cError      := "EXTERID - NOTA JA FATURADA"
                cErrorLog   := MostraErro("/dirdoc", "error.log") // ARMAZENA A MENSAGEM DE ERRO
                oWS:GRVLGZZI(nRecn, cExter, cErrorLog, "IMPPDC", "INCLUSÃO DE PEDIDO DE COMPRAS", cError)
                (cTBEXT)->(DBSKIP())
                LOOP
            Endif

            IF LEN(aCab) == 0
                aadd(aCab, {"C7_FILIAL"    , cFilAnt                ,Nil})
                aadd(aCab, {"C7_NUM"       , _cNumPed               ,Nil})
                aadd(aCab, {"C7_EMISSAO"   , (cTBEXT)->ZZI_EMISS    ,Nil})
                aadd(aCab, {"C7_MOEDA"     , 1			            ,Nil})
                aadd(aCab, {"C7_TXMOEDA"   , 1			            ,Nil})
                aadd(aCab, {"C7_FORNECE"   , _For                   ,Nil})
                aadd(aCab, {"C7_LOJA"      , _lojFor                ,Nil})
                aadd(aCab, {"C7_COND"      , (cTBEXT)->ZZI_COND     ,Nil})
                aadd(aCab, {"C7_CONTATO"   , (cTBEXT)->ZZI_CONTAT   ,Nil})
                aadd(aCab, {"C7_FILENT"    , (cTBEXT)->ZZI_FILENT   ,Nil})
                aadd(aCab, {"C7_ZINTEGR"   , (cTBEXT)->ZZI_INTEG    ,Nil})
            EndIF

            nTotal := ((cTBEXT)->ZZI_QUANTI * (cTBEXT)->ZZI_PRECO)
        
            aadd(aLinhaC1, {"C7_PRODUTO" , (cTBEXT)->ZZI_PRODUT     ,NIL})
            aadd(aLinhaC1, {"C7_QUANT"   , (cTBEXT)->ZZI_QUANTI     ,NIL})
            aadd(aLinhaC1, {"C7_PRECO"   , (cTBEXT)->ZZI_PRECO      ,NIL})
            aadd(aLinhaC1, {"C7_DESC1"   , (cTBEXT)->ZZI_DESC       ,NIL})
            aadd(aLinhaC1, {"C7_VLDESC"  , (cTBEXT)->ZZI_DESC       ,NIL})
            aadd(aLinhaC1, {"C7_TOTAL"   , nTotal                   ,NIL})
            aadd(aLinhaC1, {"C7_OPER"    , (cTBEXT)->ZZI_OPERA      ,NIL})

            cUM     := POSICIONE("SB1",1,xFilial("SB1")+(cTBEXT)->ZZI_PRODUT,"B1_UM")
            cDesc   := POSICIONE("SB1",1,xFilial("SB1")+(cTBEXT)->ZZI_PRODUT,"B1_DESC")
            cIdUiv  := _Enum + _ZEXTID  

            aadd(aLinhaC1,{"C7_ITEM"    ,(cTBEXT)->ZZI_ITEM          ,nil})
            aadd(aLinhaC1,{"C7_UM"      ,cUM                         ,nil})
            aadd(aLinhaC1,{"C7_DESCRI"  ,cDesc                       ,nil})
            aadd(aLinhaC1,{"C7_LOCAL"   ,"01"                        ,Nil})   
            aadd(aLinhaC1,{"C7_CC"      ,_cCusto                     ,Nil})
            aadd(aLinhaC1,{"C7_OBS"     ,""                          ,Nil})
            aadd(aLinhaC1,{"C7_CONTATO" ,""                          ,Nil})
            aadd(aLinhaC1,{"C7_DATPRF"  ,dDataBase                   ,NIL})
            aadd(aLinhaC1,{"C7_EMISSAO" ,(cTBEXT)->ZZI_EMISS         ,NIL})
            aadd(aLinhaC1,{"C7_SEGURO"  ,0.00                        ,NIL})
            aadd(aLinhaC1,{"C7_DESPESA" ,0.00                        ,NIL})  
            aadd(aLinhaC1,{"C7_VALFRE"  ,0.00                        ,NIL})         
            aadd(aLinhaC1,{"C7_ZEXTID"  ,_ZEXTID                     ,Nil})            
            aadd(aLinhaC1,{"C7_ZGRPNUM" ,_Enum                       ,Nil})
            aadd(aLinhaC1,{"C7_ZIDPDCI" ,cIdUiv                      ,Nil})
            aadd(aLinhaC1,{"C7_CONTA"   ,cTemCont                    ,Nil})
            aadd(aItens,aLinhaC1)

            (cTBEXT)->(DBSKIP())
            LOOP
        ENDDO
        (cTBEXT)->(dbclosearea())

        if len(aCab) > 0
            IF lExcl
                aRetGrv := oWS:pedCompra(aCab, aItens, 5) 
                If !aRetGrv[1,2] 
                    ConOut("ERRO EXCLUSÃO DO PEDIDO DE COMPRAS")
                    cErrorLog   := ''
                    aLogAuto    := aRetGrv 
                    For nLinha := 1 To Len(aLogAuto)
                        cErrorLog += aLogAuto[nLinha,1] + CRLF
                    Next nLinha
                    cError      := "ERRO EXCLUSÃO DO PEDIDO DE COMPRAS"
                    oWS:GRVLGZZI(nRecn, cExter, cErrorLog, "IMPPDC", "ERRO EXCLUSÃO DO PEDIDO DE COMPRAS", cError)
                Else
                    aRetGrv := oWS:pedCompra(aCab, aItens, 3) //StartJob("U_TESTEJOB",GetEnvServer(),.F., "05", aCab, aItens, 3)

                    If !aRetGrv[1,2] 
                        ConOut("ERRO GRAVAÇÃO DO PEDIDO DE COMPRAS")
                        cErrorLog   := ''
                        aLogAuto    := aRetGrv // GetAutoGrLog()
                        For nLinha := 1 To Len(aLogAuto)
                            cErrorLog += aLogAuto[nLinha,1] + CRLF
                        Next nLinha
                        cError      := "EXTERID JA CADASTRADO"
                        oWS:GRVLGZZI(nRecn, cExter, cErrorLog, "IMPPDC", "INCLUSÃO DE PEDIDO DE COMPRAS", cError)
                    Else
                        oWS:mudStZZI(nRecn, cExter, "1")
                    EndIf
                EndIF
            ELSE
                aRetGrv := oWS:pedCompra(aCab, aItens, 3) //StartJob("U_TESTEJOB",GetEnvServer(),.F., "05", aCab, aItens, 3)

                If !aRetGrv[1,2] 
                    ConOut("ERRO GRAVAÇÃO DO PEDIDO DE COMPRAS")
                    cErrorLog   := ''
                    aLogAuto    := aRetGrv // GetAutoGrLog()
                    For nLinha := 1 To Len(aLogAuto)
                        cErrorLog += aLogAuto[nLinha,1] + CRLF
                    Next nLinha
                    cError      := "EXTERID JA CADASTRADO"
                    oWS:GRVLGZZI(nRecn, cExter, cErrorLog, "IMPPDC", "INCLUSÃO DE PEDIDO DE COMPRAS", cError)
                Else
                    oWS:mudStZZI(nRecn, cExter, "1")
                EndIf
            ENDIF
        Endif
    NEXT
    RpcClearEnv()
    RestArea(aArea)

RETURN
