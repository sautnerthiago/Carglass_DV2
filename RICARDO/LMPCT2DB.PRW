#INCLUDE "RWMAKE.CH"
#INCLUDE "topconn.ch"
#INCLUDE "Protheus.ch"
#INCLUDE "TBICONN.CH"

user Function LMPCT2DB()

	Local aArea	:= GetArea()
	Local cQuery	:= ""
	Local cAlias	:= GetNextAlias()
	Local _CSEQ     := ""
	Local _NVLR     := 0
	Local CG        := 0

	cQuery := " SELECT CT2_SEQUEN,CT2_VALOR"
	cQuery += " FROM " + RetSQLName("CT2") + " CT2 "
	cQuery += " WHERE "
	cQuery += " CT2.CT2_DEBITO = '11121001' "
	cQuery += " AND CT2.CT2_DC = '3' "
	cQuery += " AND CT2.D_E_L_E_T_ = '' "
	cQuery += " AND CT2.CT2_DATA BETWEEN '20251101' AND '20251130' "
	cQuery += " ORDER BY CT2_SEQUEN  "

	dbUseArea (.T., "TOPCONN", TcGenQry (,,cQuery),cAlias, .T., .T.)

	While (cAlias)->( !EOF() )

		_CSEQ := (cAlias)->CT2_SEQUEN
		_NVLR := (cAlias)->CT2_VALOR

		// ACHA REGISTROS
		_ALCTO := ACHREC(_CSEQ,_NVLR)

		FOR CG := 1 TO LEN (_ALCTO)

			dbSelectArea("CT2")
			CT2->( dbSetOrder(1) )
			CT2->( dbGoTo( _ALCTO[CG,1]) )
			dbSelectArea("CT2")
			RECLOCK("CT2")
			DBDELETE()
			MSUNLOCK("CT2")

		NEXT CG

		(cAlias)->( dbSkip() )

	End

	(cAlias)->( dbCloseArea() )

	RestArea(aArea)

Return

STATIC FUNCTION ACHREC(_CSEQ,_NVLR)
	LOCAL cQry    := ""
	LOcal ADADPLC := {}

	cQry := "SELECT R_E_C_N_O_ NREG "
	cQry += " FROM  " + RetSqlName('CT2') + " CT2A"
	cQry += " WHERE CT2A.CT2_SEQUEN = '"+ _CSEQ + "'"
	cQry += "       AND CT2A.CT2_DC = '3'"
	cQry += "       AND CT2A.CT2_VALOR = "+ALLTRIM(STR(_NVLR,14,2))
	cQry += "       AND CT2A.CT2_DATA BETWEEN '20251101' AND '20251130' "
	cQry += "       AND CT2A.D_E_L_E_T_  <> '*' "
	cQry += "	ORDER BY 1"

//Executando a query
	PLSQuery(cQry, "QRY_PLC")

//Se houve dados
	If ! QRY_PLC->(EoF())
		//Pegando o total de registros
		DbSelectArea("QRY_PLC")
		QRY_PLC->(DbGoTop())

		//Enquanto houver dados
		While ! QRY_PLC->(EoF())
			AADD(ADADPLC, {QRY_PLC->NREG})
			QRY_PLC->(DbSkip())
		End
	ENDIF
RETURN(ADADPLC)







