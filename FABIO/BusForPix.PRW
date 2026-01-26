/*/
 |---------------------------------------------------------------------|
 | Func:  BusForPix                                                    |
 | Autor: Fabio José Batista                                           |
 | Data:  05/12/2025                                                   |
 | Desc:  Valida a existencia do fornecedor com PIX                    |
 | Return: cActive                                                     |
 |---------------------------------------------------------------------|
 /*/
Static Function BusForPix()
    Local cQry    := ''
	Local aArea   := GetArea()
    Local cActive := ''
	
	cQry := "SELECT SE2.E2_FORNECE,SE2.E2_LOJA,F72.F72_ACTIVE "
	cQry += "from "+RetSqlName('SE2') + " SE2 " "
    cQry += "inner join "+RetSqlName('F72') + " F72 "
    cQry += "on SE2.E2_FORNECE = F72.F72_COD and SE2.E2_LOJA = F72.F72_LOJA and F72.D_E_L_E_T_ =  ' ' "
	cQry += "where SE2.D_E_L_E_T_ = ' ' "
    cQry += "and SE2.E2_NUM     = '" + SE2->E2_NUM     + "'  "
    cQry += "and SE2.E2_FORNECE = '" + SE2->E2_FORNECE + "'  "
    cQry += "and SE2.E2_LOJA    = '" + SE2->E2_LOJA    + "'  "
    	
	cQry := ChangeQuery(cQry)
    TCQuery cQry New Alias "cQry"
  
    cQry->(DbGoTop())
    While !cQry->(Eof())
    	cActive := cQry->(F72_ACTIVE)
        cQry->(DbSkip())
    EndDo
    
    cQry->(DbCloseArea())

    RestArea(aArea)

Return cActive
