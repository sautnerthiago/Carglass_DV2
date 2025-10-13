#INCLUDE "TOTVS.CH"
/*/{Protheus.doc} MT094FIL
Filtra registros da mBrowse da rotna de liberação de pedidos
@type     function
@author      Ricardo Cavalini
@since       02.09.2025
/*/
User Function MT094FIL()
Local cFilOr  := ""
Local cFiltro := ""

cFilOr  := FWCodFil()
cFiltro := "CR_MSFIL == '"+cFilOr+"' " 

Return( cFiltro )
