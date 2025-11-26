#include "totvs.ch"
#include "protheus.ch"
#include "TOPCONN.CH"

User Function EXCLNFE()
    Local aArea  := GetArea()
    lOCAL oExcNf := LIBGLASS():new()	
    	Processa({||oExcNf:EXCNFE()},"Aguarde Excluindo Notas de Compras.... " )
    RestArea(aArea)
Return


