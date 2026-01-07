#include "totvs.ch"
#include "protheus.ch"
#include "TOPCONN.CH"

User Function EXCLNFS()
    Local aArea  := GetArea()
    	Processa({|| AEXCLUIR() },"Aguarde Excluindo Notas Saida - SEM FROTISTA.... " )
    	//Processa({|| AEXCL001() },"Aguarde Excluindo Notas Saida - COM FROTISTA E cfop 5949.... " )
    RestArea(aArea)
Return

Static Function AEXCLUIR()
    Local Y, X
    Local aRexId  := PedAExc(cFilAnt)
    Local cDirLog := '\x_logs\'
    Local cLog    := ""
    
    FOR Y := 1 TO LEN(aRexId)
        
        aPedi := retAped(aRexId[Y,1], aRexId[Y,2])
        IncProc("Pedido " + aRexId[Y,1] )
        nTot := LEN(aPedi)

        FOR X := 1 TO nTot

            //Define as variáveis base
            cDocumento := AvKey(aPedi[X,1], "F2_DOC")
            cSerie     := AvKey(aPedi[X,2], "F2_SERIE")
            cCliente   := AvKey(aPedi[X,3], "F2_CLIENTE")
            cLoja      := AvKey(aPedi[X,4], "F2_LOJA")
            cFil       := aPedi[X,5]
            dEmiss     := aPedi[X,6]
            nRecNo     := aPedi[X,7]
            dDataBase  := StoD(dEmiss)
            
            IncProc("Pedido " + aRexId[Y,1] + " - Nota fiscal: " + Alltrim(cDocumento) + " - Serie: " + cSerie  )

            //Define as variáveis específicas do processo de exclusão
            cMarca     := GetMark(, "SF2", "F2_OK")
            aRegSD2    := {}
            aRegSE1    := {}
            aRegSE2    := {}
            lMostraCtb := .F.
            lAglCtb    := .F.
            lContab    := .F.
            lCarteira  := .F.
            lPodeExcl  := .F.
            lDeuCerto  := .F.
            nRecE1     := 0

            SC5->(DBGoTop())
            SC5->(dbSeek(cFil+aRexId[Y,1]))

            SA1->(DBGoTop())
            SA1->(dbSeek(Xfilial("SA1") + cCliente + cLoja))

            cEmpAt1 := cEmpAnt
            cFilAt1 := cFilAnt

            cEmpAt   := "01"
            cFilAt   := Iif(EMPTY(cFil), "01", cFil)

            lServic := (SB1->B1_TIPO == "SV")  

            //Abre a tabela de documentos de saída
            DbSelectArea("SF2")
            SF2->(DbSetOrder(1)) // F2_FILIAL + F2_DOC + F2_SERIE + F2_CLIENTE + F2_LOJA + F2_FORMUL + F2_TIPO
            
            //Se conseguir posicionar na Nota
            If SF2->(MsSeek(cFil + cDocumento + cSerie + cCliente + cLoja))
                //Simula a marcação da tela de exclusão de Documento de Saída
                RecLock("SF2", .F.)
                    SF2->F2_OK := cMarca
                SF2->(MsUnlock())
                //nRecE1 := recTit(cDocumento, cSerie, cCliente, cLoja)
            
                //Verifica se é possível excluir a NF ou tem alguma restrição
                lPodeExcl := MaCanDelF2("SF2", SF2->(RecNo()), @aRegSD2, @aRegSE1, @aRegSE2)
            
                //Se for possível excluir, aciona a rotina para efetivar a exclusão
                If lPodeExcl
                    lDeuCerto := MaDelNFS(aRegSD2, aRegSE1, aRegSE2, lMostraCtb, lAglCtb, lContab, lCarteira)
                    //Se deu tudo certo, mostra mensagem de sucesso
                    If lDeuCerto
                        //FWAlertSuccess("Nota de número '" + cDocumento + "'  foi excluída com sucesso!", "Sucesso")
                        cLog += 'EXCLUSÃO REALIZADA COM SUCESSO - ' + cDocumento + CRLF
                    ELSE
                        cLog += 'EXCLUSÃO NAO REALIZADA - ' + cDocumento + CRLF
                    EndIf
                EndIf
            EndIf
            cEmpAnt  := cEmpAt1
            cFilAnt  := cFilAt1
        NEXT
    Next
    if !empty(cLog)
        cArqLog := 'EXCLNFS_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
        MemoWrite(cDirLog + cArqLog, cLog)
    endif

Return

Static Function PedAExc(_Fil)
    Local aRet   := {}
    Local cAlSC5 := GetNextAlias()

    // cQuery := " SELECT COUNT(D2_DOC) AS QTD, D2_PEDIDO, D2_EMISSAO, D2_FILIAL FROM SD2010 D2 "
    // cQuery += " INNER JOIN SC5010 C5 ON C5_NUM = D2_PEDIDO AND C5_FILIAL = D2_FILIAL "
    // cQuery += " WHERE C5.D_E_L_E_T_ = '' AND D2.D_E_L_E_T_ = '' AND D2_FILIAL = '"+_Fil+"' "
    // cQuery += " AND D2_EMISSAO > '20251201' AND D2_CLIENTE NOT IN ('0050539327', '0051278112', '0050635124', '0050783270', '0050630011', '0001634036', '0050604254', '0001963653') "    
    // cQuery += " GROUP BY D2_PEDIDO, D2_EMISSAO, D2_FILIAL "
    // cQuery += " HAVING COUNT(*) > 1 "
    // cQuery += " ORDER BY D2_FILIAL, D2_EMISSAO, D2_PEDIDO "
    
    cQuery := " SELECT D2_PEDIDO, D2_FILIAL FROM SD2010 WHERE D_E_L_E_T_ = '' AND D2_FILIAL  = '"+_Fil+"' AND D2_DOC BETWEEN '000456182' AND '000457869' "
    DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSC5, .F., .T.) 

    WHILE !(cAlSC5)->(EOF())
        AADD(aRet, { (cAlSC5)->D2_PEDIDO, (cAlSC5)->D2_FILIAL} )
        (cAlSC5)->(DBSKIP())
        LOOP
    ENDDO
    (cAlSC5)->(DBCLOSEAREA())        

Return aRet

Static Function retAped(cPedi, cFil)
    local aRet := {}
    Local cAlSC5 := GetNextAlias()

    cQuery := " SELECT *, R_E_C_N_O_ RECNO "
    cQuery += " FROM "+RetSQLName("SD2") + " WITH (NOLOCK) "
    cQuery += " WHERE D_E_L_E_T_ = '' AND D2_PEDIDO = '"+cPedi+"' AND D2_FILIAL = '"+cFil+"' "
    DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSC5, .F., .T.) 

    WHILE !(cAlSC5)->(EOF())
        cDocumento := (cAlSC5)->D2_DOC
        cSerie     := (cAlSC5)->D2_SERIE
        cCliente   := (cAlSC5)->D2_CLIENTE
        cLoja      := (cAlSC5)->D2_LOJA
        cFil       := (cAlSC5)->D2_FILIAL
        dEmiss     := (cAlSC5)->D2_EMISSAO
        nRecN      := (cAlSC5)->RECNO
        AADD(aRet, {cDocumento, cSerie, cCliente, cLoja, cFil, dEmiss, nRecN})
        (cAlSC5)->(DBSKIP())
        LOOP
    ENDDO
    (cAlSC5)->(DBCLOSEAREA())
    
Return aRet


Static Function recTit( _Docu, _Serie, _Clien, _Loja)
    Local nRet := 0
    Local cAlSC5 := GetNextAlias()

    cQuery := " SELECT *, R_E_C_N_O_ RECNO "
    cQuery += " FROM "+RetSQLName("SE1") + " WITH (NOLOCK) "
    cQuery += " WHERE D_E_L_E_T_ = '' AND E1_NUM = '"+_Docu+"' AND E1_FILIAL = '"+cFil+"' AND E1_CLIENTE = '"+_Clien+"' AND E1_LOJA = '"+_Loja+"' "
    DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSC5, .F., .T.) 

    nRecN  := (cAlSC5)->RECNO
    (cAlSC5)->(DBCLOSEAREA())

RETURN nRet


Static Function AEXCL001()
    Local Y, X
    Local aRexId  := PedAExc1(cFilant)
    Local cDirLog := '\x_logs\'
    Local cLog    := ""
    
    FOR Y := 1 TO LEN(aRexId)
        
        aPedi := retAped(aRexId[Y,1], aRexId[Y,2])
        IncProc("Pedido " + aRexId[Y,1] )
        nTot := (LEN(aPedi) - 1)

        FOR X := 1 TO nTot

            //Define as variáveis base
            cDocumento := AvKey(aPedi[X,1], "F2_DOC")
            cSerie     := AvKey(aPedi[X,2], "F2_SERIE")
            cCliente   := AvKey(aPedi[X,3], "F2_CLIENTE")
            cLoja      := AvKey(aPedi[X,4], "F2_LOJA")
            cFil       := aPedi[X,5]
            dEmiss     := aPedi[X,6]
            nRecNo     := aPedi[X,7]
            dDataBase  := StoD(dEmiss)
            
            IncProc("Pedido " + aRexId[Y,1] + " - Nota fiscal: " + Alltrim(cDocumento) + " - Serie: " + cSerie  )

            //Define as variáveis específicas do processo de exclusão
            cMarca     := GetMark(, "SF2", "F2_OK")
            aRegSD2    := {}
            aRegSE1    := {}
            aRegSE2    := {}
            lMostraCtb := .F.
            lAglCtb    := .F.
            lContab    := .F.
            lCarteira  := .F.
            lPodeExcl  := .F.
            lDeuCerto  := .F.
            nRecE1     := 0

            SC5->(DBGoTop())
            SC5->(dbSeek(cFil+aRexId[Y,1]))

            SA1->(DBGoTop())
            SA1->(dbSeek(Xfilial("SA1") + cCliente + cLoja))

            cEmpAt1 := cEmpAnt
            cFilAt1 := cFilAnt

            cEmpAt   := "01"
            cFilAt   := Iif(EMPTY(cFil), "01", cFil)

            lServic := (SB1->B1_TIPO == "SV")  

            //Abre a tabela de documentos de saída
            DbSelectArea("SF2")
            SF2->(DbSetOrder(1)) // F2_FILIAL + F2_DOC + F2_SERIE + F2_CLIENTE + F2_LOJA + F2_FORMUL + F2_TIPO
            
            //Se conseguir posicionar na Nota
            If SF2->(MsSeek(cFil + cDocumento + cSerie + cCliente + cLoja))
                //Simula a marcação da tela de exclusão de Documento de Saída
                RecLock("SF2", .F.)
                    SF2->F2_OK := cMarca
                SF2->(MsUnlock())
                //nRecE1 := recTit(cDocumento, cSerie, cCliente, cLoja)
            
                //Verifica se é possível excluir a NF ou tem alguma restrição
                lPodeExcl := MaCanDelF2("SF2", SF2->(RecNo()), @aRegSD2, @aRegSE1, @aRegSE2)
            
                //Se for possível excluir, aciona a rotina para efetivar a exclusão
                If lPodeExcl
                    lDeuCerto := MaDelNFS(aRegSD2, aRegSE1, aRegSE2, lMostraCtb, lAglCtb, lContab, lCarteira)
                    //Se deu tudo certo, mostra mensagem de sucesso
                    If lDeuCerto
                        //FWAlertSuccess("Nota de número '" + cDocumento + "'  foi excluída com sucesso!", "Sucesso")
                        cLog += 'EXCLUSÃO REALIZADA COM SUCESSO - ' + cDocumento + CRLF
                    ELSE
                        cLog += 'EXCLUSÃO NAO REALIZADA - ' + cDocumento + CRLF
                    EndIf
                EndIf
            EndIf
        NEXT
    Next
    cArqLog := 'EXCLNFS_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
    MemoWrite(cDirLog + cArqLog, cLog)

    cEmpAnt  := cEmpAt1
    cFilAnt  := cFilAt1

Return

Static Function PedAExc1(_Fil)
    Local aRet   := {}
    Local cAlSC5 := GetNextAlias()

    cQuery := " SELECT COUNT(D2_DOC) AS QTD, D2_PEDIDO, D2_EMISSAO, D2_FILIAL FROM SD2010 D2 "
    cQuery += " INNER JOIN SC5010 C5 ON C5_NUM = D2_PEDIDO AND C5_FILIAL = D2_FILIAL "
    cQuery += " WHERE C5.D_E_L_E_T_ = '' AND D2.D_E_L_E_T_ = '' AND D2_FILIAL = '"+_Fil+"' "
    cQuery += " AND D2_EMISSAO > '20251201' AND D2_CF = '5949' "    
    cQuery += " GROUP BY D2_PEDIDO, D2_EMISSAO, D2_FILIAL "
    cQuery += " HAVING COUNT(*) > 1 "
    cQuery += " ORDER BY D2_FILIAL, D2_EMISSAO, D2_PEDIDO "
    DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSC5, .F., .T.) 

    // cQuery := " SELECT COUNT(D2_DOC) AS QTD, D2_PEDIDO, D2_EMISSAO, D2_FILIAL "
    // cQuery += " FROM "+RetSQLName("SD2") + " WITH (NOLOCK) "
    // cQuery += " WHERE D_E_L_E_T_ = '' AND D2_PEDIDO IN ( SELECT DISTINCT C5_NUM FROM SC5010  WHERE D_E_L_E_T_= '' AND C5_ZEXTID <> '' AND C5_FILIAL = '15'  ) "
    // cQuery += " AND D2_EMISSAO > '20251201' AND D2_CLIENTE NOT IN ('0050539327', '0051278112', '0050635124', '0050783270', '0050630011', '0001634036', '0050604254', '0001963653') "
    // cQuery += " AND D2_FILIAL = '15' "
    // cQuery += " GROUP BY D2_PEDIDO, D2_EMISSAO, D2_FILIAL "
    // cQuery += " HAVING COUNT(*) > 1 "
    // cQuery += " ORDER BY D2_FILIAL, D2_EMISSAO, D2_PEDIDO "
    // DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSC5, .F., .T.) 

    WHILE !(cAlSC5)->(EOF())
        AADD(aRet, { (cAlSC5)->D2_PEDIDO, (cAlSC5)->D2_FILIAL} )
        (cAlSC5)->(DBSKIP())
        LOOP
    ENDDO
    (cAlSC5)->(DBCLOSEAREA())          
    
Return aRet


