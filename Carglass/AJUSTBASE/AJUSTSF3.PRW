#Include "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

User Function AJUSTSF3()
	_cArea	  := GetArea()
    SF3->(DBGoTop())
    WHILE !SF3->(EOF())
        If SUBSTR(SF3->F3_CFO,1,1) $ "1/2/3"
            IF RecLock("SF3",.F.)
                SF3->F3_CGCNPJ := pegCliFor(SF3->F3_CLIEFOR, SF3->F3_LOJA, 'SA2')
            ENDIF
        ELSE
            IF RecLock("SF3",.F.)
                SF3->F3_CGCNPJ := pegCliFor(SF3->F3_CLIEFOR, SF3->F3_LOJA, 'SA1')
            Endif
        ENDIF
        MsUnLock()

        SF3->(DBSKIP())
        LOOP
    ENDDO

	RestArea(_cArea)
Return .T.

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
