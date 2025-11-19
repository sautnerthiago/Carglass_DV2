#include "rwmake.ch"
#include "TOPCONN.CH"

User Function Gqreentr()
	_cArea	  := GetArea()
    
    dbSelectarea("SF3")
    DBSETORDER(4)
    dbGotop()
    IF dbSeek(xFilial("SF3") + SF1->F1_FORNECE + SF1->F1_LOJA + SF1->F1_DOC + SF1->F1_SERIE,.T.)
        IF RecLock("SF3",.F.)
            SF3->F3_CGCNPJ :=  pegCliFor(SF3->F3_CLIEFOR, SF3->F3_LOJA, 'SA2') //POSICIONE("SA2",1,XFILIAL("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,'A2_CGC') 
        ENDIF
        MSUnlock()
    Endif
    
    RestArea(_cArea)
Return

Static Function pegCliFor(_CLIEFOR, _LOJA, cTab)
    Local cCNPJ     := ""
    Local cAliasQry := "CLIFOR"

    if cTab == "SA1"
        cQuery := ""
        cQuery += "SELECT A1_CGC FROM " + RetSqlName( "SA1" ) + " "
        cQuery += "WHERE "
        cQuery += "A1_FILIAL='" + xFilial( "SA1" ) + "' AND "
        cQuery += "A1_COD ='" + _CLIEFOR + "' AND "
        cQuery += "A1_LOJA ='" + _LOJA + "' AND "
        cQuery += "D_E_L_E_T_='' "
        cQuery := ChangeQuery( cQuery )
        DbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), cAliasQry, .F., .T. )
        cCNPJ := (cAliasQry)->A1_CGC
        ( cAliasQry )->( DbCloseArea() )
    else
        cQuery := ""
        cQuery += "SELECT A2_CGC FROM " + RetSqlName( "SA2" ) + " "
        cQuery += "WHERE "
        cQuery += "A2_FILIAL='" + xFilial( "SA2" ) + "' AND "
        cQuery += "A2_COD ='" + _CLIEFOR + "' AND "
        cQuery += "A2_LOJA ='" + _LOJA + "' AND "
        cQuery += "D_E_L_E_T_='' "
        cQuery := ChangeQuery( cQuery )
        DbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), cAliasQry, .F., .T. )
        cCNPJ := (cAliasQry)->A2_CGC
        ( cAliasQry )->( DbCloseArea() )

    endif

Return cCNPJ
