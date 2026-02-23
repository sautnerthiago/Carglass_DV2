#Include "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"


/*/{Protheus.doc} Gqreentr - Atualiza E2_ZEXTID na SE2 a partir da entrada de mercadoria
    @description Esta rotina tem como objetivo atualizar o campo E2_ZEXTID na tabela SE a partir da entrada de mercadoria 
    @author J.EDILSON
    @since 23/02/2026
/*/

User Function Gqreentr()
	Local _cArea	:= GetArea()
    Local cAliasQry := GetNextAlias()
    Local cQuery    := ""

    cQuery := ""
    cQuery += "SELECT SC7.C7_ZEXTID, SD1.D1_DOC "
    cQuery += "FROM " + RetSqlName( "SC7" ) + " SC7 "
    cQuery += "INNER JOIN " + RetSqlName( "SD1" ) + " SD1 "
    cQuery += " ON  SD1.D1_PEDIDO  = SC7.C7_NUM "
    cQuery += " AND SD1.D1_COD     = SC7.C7_PRODUTO "
    cQuery += " AND SD1.D1_FORNECE = SC7.C7_FORNECE "
    cQuery += " AND SD1.D1_LOJA	   = SC7.C7_LOJA "
    cQuery += " AND SD1.D_E_L_E_T_ = ' ' "
    cQuery += " WHERE SC7.D_E_L_E_T_ = ' ' "
    cQuery += " AND SD1.D1_DOC <> '' "
    cQuery += " AND D1_DOC ='" + SF1->F1_DOC + "' "
    cQuery += " AND D1_FORNECE ='" + SF1->F1_FORNECE + "' "
    cQuery += " AND D1_LOJA ='" + SF1->F1_LOJA + "' "
    cQuery := ChangeQuery( cQuery )
    DbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), cAliasQry, .F., .T. )

	WHILE !(cAliasQry)->(EOF())
        AtE2Zext((cAliasQry)->C7_ZEXTID, (cAliasQry)->D1_DOC, SF1->F1_FORNECE, SF1->F1_LOJA)
		(cAliasQry)->(DBSKIP())
		LOOP
	ENDDO
	(cAliasQry)->( DBCloseArea() )
    
    RestArea(_cArea)
Return

Static Function AtE2Zext(cZext, cDoc, cForn, cLoja)
    Begin Transaction
        //Monta o Update
        cQryUpd := " UPDATE " + RetSqlName("SE2") + " "
        cQryUpd += "     SET E2_ZEXTID = '" + cZext + "' "
        cQryUpd += " WHERE "
        cQryUpd += "     E2_FILIAL = '" + FWxFilial('SE2') + "' "
        cQryUpd += "     AND E2_NUM = '" + cDoc + "' "
        cQryUpd += "     AND E2_FORNECE = '" + cForn + "' "
        cQryUpd += "     AND E2_LOJA = '" + cLoja + "' "
        cQryUpd += "     AND D_E_L_E_T_ = ' ' "    
        nErro := TcSqlExec(cQryUpd)
        //Se houve erro, mostra a mensagem e cancela a transação
        If nErro != 0
            MsgStop("Erro na execução da query: "+TcSqlError(), "Atenção")
            DisarmTransaction()
        EndIf
    End Transaction
Return 
