#INCLUDE "APWIZARD.CH"
#include 'parmtype.ch'
#Include "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#include 'tbiconn.ch'
#INCLUDE "TOTVS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "RESTFUL.CH"
#INCLUDE "FWAdapterEAI.ch"

User Function AJUSTSA2()
	Local aArea := GetArea()
    FWMsgRun(, {|oSay| AJSA2(oSay) }, "Processando", "Processando dados....")
    RestArea(aArea)
Return

//---------------------------------------------------------------------------------
Static Function AJSA2(oMens)

	oMens:SetText('Aguarde...')
	oMens:Refresh()
	ProcessMessages()

	IF cEmpAnt == "01"
		oMens:SetText("Migrando - CARGLASS...")
		oMens:Refresh()
		ProcessMessages()
		Ajust010()
	ENDIF

	IF cEmpAnt == "02"
		oMens:SetText("Migrando - DSK...")
		oMens:Refresh()
		ProcessMessages()
		Ajust020()
	ENDIF

	Alert("Processamento Terminado. Processadas "+Transform(nContador,"@E 999,999")+" tabelas.")
	oMens:SetText("Proc. "+Transform(nContador,"@E 999,999"))
	oMens:Refresh()
	ProcessMessages()

RETURN

//------------------------------------------------------------------------------------------
Static Function Ajust020()
	Local aDados := {}
	Local cQuery := ""

    cQuery := "SELECT A2_FILIAL, A2_COD, A2_LOJA, A2_CGC, A2_NUMCOM FROM SA2020 "
    cQuery += "WHERE D_E_L_E_T_ = '' AND A2_NUMCOM <> '' "
	ZZB	   := CriaTrab(Nil,.F.)
	DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),ZZB, .F., .T.)   

	While !(ZZB)->(EOF())
        
        _FILIAL := (ZZB)->A2_FILIAL
        _COD    := (ZZB)->A2_COD
        _LOJA   := (ZZB)->A2_LOJA
        _CGC    := (ZZB)->A2_CGC
        cConta  := (ZZB)->A2_NUMCOM
        cDig    := ""
        cNCont  := ""
        aDados  := StrTokArr(cConta, '-')

        if Len(aDados) > 0
            cNCont := aDados[1]
            cDig   := aDados[2]
            if IsNumeric(cNCont)
                ATUA(_FILIAL, _COD, _LOJA, _CGC, cDig, "SA2020", cNCont)
            endif
        EndIF
        (ZZB)->(DBSKIP())
	Enddo
	(ZZB)->(DBCLOSEAREA())
	
Return aDados

Static Function Ajust010()
	Local aDados  := {}

    Local cQuery := "SELECT A2_FILIAL, A2_COD, A2_LOJA, A2_CGC, A2_NUMCOM FROM SA2010 "
    cQuery += "WHERE D_E_L_E_T_ = '' AND A2_NUMCOM <> '' "
	QRYO := CriaTrab(Nil,.F.)
	DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),QRYO, .F., .T.)   

	While !(QRYO)->(EOF())
        _FILIAL := (QRYO)->A2_FILIAL
        _COD    := (QRYO)->A2_COD
        _LOJA   := (QRYO)->A2_LOJA
        _CGC    := (QRYO)->A2_CGC
        cConta  := (QRYO)->A2_NUMCOM
        cDig    := ""
        cNCont  := ""
        aDados  := StrTokArr(cConta, '-')
        if Len(aDados) > 0
            cNCont := aDados[1]
            cDig   := aDados[2]
            if IsNumeric(cNCont)
                ATUA(_FILIAL, _COD, _LOJA, _CGC, cDig, "SA2010", cNCont)
            endif
        EndIF
        (QRYO)->(DBSKIP())
	Enddo
	(QRYO)->(DBCLOSEAREA())
	
Return aDados

Static Function ATUA(_FILIAL, _COD, _LOJA, _CGC, cDig, _FIL, cNCont)
    Local cSQL := ""

    cSQL += "UPDATE '"+_FIL+"' "
    cSQL += "SET A2_DVCTA = '"+cDig+"', A2_NUMCOM = '"+cNCont+"' "
    cSQL += "WHERE D_E_L_E_T_ = ' ' AND  A2_FILIAL = '"+_FILIAL+"' AND A2_COD = '"+_COD+"' AND A2_LOJA = '"+_LOJA+"' AND A2_CGC = '"+_CGC+"'  "
    IF TcSqlExec(cSQL) < 0
        TcSqlExec("COMMIT")
    EndIf		
Return
