#Include "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} SF2460I - Atualiza E1_ZEXTID na SE1 a partir do pedido de venda
    @description Esta rotina tem como objetivo atualizar o campo E1_ZEXTID na tabela SE
    @author J.EDILSON
    @since 23/02/2026
/*/

User Function SF2460I()
	Local _cArea	:= GetArea()
    Local cAliasQry := GetNextAlias()
    Local cQuery    := ""

    cQuery := ""
    cQuery += "SELECT SC5.C5_ZEXTID, SD2.D2_DOC "
    cQuery += "FROM " + RetSqlName( "SC5" ) + " SC5 "
    cQuery += "INNER JOIN " + RetSqlName( "SC6" ) + " SC6 "
    cQuery += " ON  SC6.C6_FILIAL = SC5.C5_FILIAL "
    cQuery += " AND SC6.C6_NUM = SC5.C5_NUM "
    cQuery += " AND SC6.C6_CLI = SC5.C5_CLIENTE "
    cQuery += " AND SC6.C6_LOJA = SC5.C5_LOJACLI "
    cQuery += "INNER JOIN " + RetSqlName( "SD2" ) + " SD2 "
    cQuery += " ON  SD2.D2_PEDIDO  = SC6.C6_NUM "
    cQuery += " AND SD2.D2_COD     = SC6.C6_PRODUTO "
    cQuery += " AND SD2.D2_FORNECE = SC6.C6_CLI "
    cQuery += " AND SD2.D2_LOJA	   = SC6.C6_LOJA "
    cQuery += " AND SD2.D_E_L_E_T_ = ' ' "
    cQuery += " WHERE SC5.D_E_L_E_T_ = ' ' "
    cQuery += " AND SD2.D2_DOC <> '' "
    cQuery += " AND D2_DOC ='" + SF2->F2_DOC + "' "
    cQuery += " AND D2_FORNECE ='" + SF2->F2_CLIENTE + "' "
    cQuery += " AND D2_LOJA ='" + SF2->F2_LOJA + "' "
    cQuery := ChangeQuery( cQuery )
    DbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), cAliasQry, .F., .T. )

	WHILE !(cAliasQry)->(EOF())
        AtE1Zext((cAliasQry)->C7_ZEXTID, (cAliasQry)->D2_DOC, SF2->F2_CLIENTE, SF2->F2_LOJA)
		(cAliasQry)->(DBSKIP())
		LOOP
	ENDDO
	(cAliasQry)->( DBCloseArea() )
    
    RestArea(_cArea)
Return .T.

Static Function AtE1Zext(cZext, cDoc, cClient, cLoja)
    Begin Transaction
        //Monta o Update
        cQryUpd := " UPDATE " + RetSqlName("SE1") + " "
        cQryUpd += "     SET E1_ZEXTID = '" + cZext + "' "
        cQryUpd += " WHERE "
        cQryUpd += "     E1_FILIAL = '" + FWxFilial('SE1') + "' "
        cQryUpd += "     AND E1_NUM = '" + cDoc + "' "
        cQryUpd += "     AND E1_FORNECE = '" + cClient + "' "
        cQryUpd += "     AND E1_LOJA = '" + cLoja + "' "
        cQryUpd += "     AND D_E_L_E_T_ = ' ' "    
        nErro := TcSqlExec(cQryUpd)
        //Se houve erro, mostra a mensagem e cancela a transação
        If nErro != 0
            MsgStop("Erro na execução da query: "+TcSqlError(), "Atenção")
            DisarmTransaction()
        EndIf
    End Transaction
Return 
