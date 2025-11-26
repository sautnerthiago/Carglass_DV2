#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#DEFINE CRLF CHR(13)+CHR(10)

/*/{Protheus.doc} YCOMJ001
    ENVIO DE EMAIL COM ORÇAMENTOS DE VENDAS DE CONSIGNAÇÃO VENCIDOS
    @type  Function
    @author J.EDILSON
    @since 01/10/2025
/*/

User Function YCOMJ001()
    Local cAlSE1  := GetNextAlias()
    Local cAlSE2  := GetNextAlias()
    Local cQuery  := ""
    Local cUpdate := ""

	PREPARE ENVIRONMENT EMPRESA cEmpAnt FILIAL cFilAnt MODULO 'FAT'

    cQuery := " SELECT * "
    cQuery += " FROM "+RetSQLName("SE1") + " AS E1 WITH (NOLOCK) "
    cQuery += " WHERE E1.D_E_L_E_T_ <> '*' AND E1_XCNPNJ = ' ' "
    DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSE1, .F., .T.)    

	Do While !(cAlSE1)->(eof())
        cClient := (cAlSE1)->E1_CLIENTE
        cLojaCl := (cAlSE1)->E1_LOJA
        cCnpj   := Posicione("SA1",1, xFilial("SA1") + cClient + cLojaCl ,"A1_CGC")

        cUpdate := "UPDATE " + RetSqlName("SE1")
        cUpdate += " SET E1_XCNPNJ = '"+cCnpj+"' "
        cUpdate += " WHERE E1_CLIENTE = '" + cClient + "' AND E1_LOJA = '" + cLojaCl + "' "
        TCSqlExec( cUpdate )

		(cAlSE1)->( dbSkip() )	
		Loop
	EndDo

    cQuery := " SELECT * "
    cQuery += " FROM "+RetSQLName("SE2") + " AS E2 WITH (NOLOCK) "
    cQuery += " WHERE E2.D_E_L_E_T_ <> '*' AND E2_XCNPJ = ' ' "
    DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSE2, .F., .T.)    

	Do While !(cAlSE2)->(eof())
        cFornec := (cAlSE2)->E2_FORNECE
        cLojaFr := (cAlSE2)->E2_LOJA
        cCnpj   := Posicione("SA2",1, xFilial("SA2") + cFornec + cLojaFr ,"A2_CGC")

        cUpdate := "UPDATE " + RetSqlName("SE2")
        cUpdate += " SET E2_XCNPJ = '"+cCnpj+"' "
        cUpdate += " WHERE E2_FORNECE = '" + cFornec + "' AND E2_LOJA = '" + cLojaFr + "' "
        TCSqlExec( cUpdate )

		(cAlSE2)->( dbSkip() )	
		Loop
	EndDo

    (cAlSE1)->(dbclosearea())
    (cAlSE2)->(dbclosearea())

    RESET ENVIRONMENT

Return
