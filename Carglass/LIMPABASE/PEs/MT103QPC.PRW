#Include "Protheus.ch"
#Include "RwMake.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} ${MT103QPC}
(Ponto de entrada para manupulação da consulta de Pedidos de Compra na tela de Lancamento NF MATA103)
@type function
@author Ricardo Cavalini
@since 17/10/2025
@version 1.0
@return ${return}, ${return_description}
/*/
User Function MT103QPC()
Local cQuery   := ParamIxb[1]
Local nOpcX    := ParamIxb[2]
Local cRstNF   := SuperGetMV("MV_RESTNFE")
Local cQryC7   := ""
Local cFiliLog := ""
local nPosProd := 0

cFiliLog := FWCodFil()

cQryC7 := "SELECT R_E_C_N_O_ RECSC7 FROM "
cQryC7 += RetSqlName("SC7") + " SC7 "
cQryC7 += "WHERE C7_MSFIL = '" + cFiliLog  + "' AND "
cQryC7 += "C7_FORNECE = '"+cA100For+"' AND "
cQryC7 += "C7_LOJA = '"+cLoja+"' AND "
cQryC7 += "(C7_QUANT-C7_QUJE-C7_QTDACLA) > 0 AND "
cQryC7 += "C7_RESIDUO = ' ' AND "
cQryC7 += "C7_TPOP <> 'P' AND "

If cRstNF == "S"
	cQryC7 += "C7_CONAPRO <> 'B' AND C7_CONAPRO <> 'R' AND "
EndIf

if nOpcX == 2
   nPosProd := Ascan(aHeader,{|x|Alltrim(Upper(x[2]))=="D1_COD"})
   cQryC7 += "C7_PRODUTO = '" + ACOLS[N][nPosProd] + "' AND "
endif

cQryC7 += "D_E_L_E_T_ = ' '"
cQryC7 += "ORDER BY " + SqlOrder(SC7->(IndexKey()))

// retorna a nova query
cQuery := cQryC7

Return cQuery
