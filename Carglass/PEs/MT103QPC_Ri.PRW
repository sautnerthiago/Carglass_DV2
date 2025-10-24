#Include "Protheus.ch"
#Include "RwMake.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} ${MT103QPC}
(Ponto de entrada para manupulaùùo da consulta de Pedidos de Compra na tela de Lancamento NF MATA103)
@type function
@author Erick
@since 12/05/2023
@version 1.0
@return ${return}, ${return_description}
/*/
User Function MT103QPC()
Local cQuery := ParamIxb[1]
Local nOpc   := ParamIxb[2]
Local lMVAutFat := SuperGetMV("TP_AUTFAT",,.F.)

    cQueryC7 := "WHERE C7_NUM NOT IN ( SELECT C7_NUM "
    cQueryC7 += " FROM " + RetSQLName("SC7") + " SC7 "
	cQueryC7 += " WHERE C7_FILIAL = '" + FwxFilial("SC7") + "' "
	cQueryC7 += "   AND SC7.D_E_L_E_T_ <> '*' "
	cQueryC7 += "   AND C7_NFNUM <> '' "
	cQueryC7 += " GROUP BY C7_NUM "
	cQueryC7 += " ) AND "

    if (lMVAutFat)
        cQuery := STRTRAN( cQuery, 'WHERE', cQueryC7 )
    endif

Return cQuery
