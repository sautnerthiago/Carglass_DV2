#include "rwmake.ch"
#include "TOPCONN.CH"

User Function Gqreentr()
	_cArea	  := GetArea()
    
    dbSelectarea("SF3")
    DBSETORDER(4)
    dbGotop()
    IF dbSeek(xFilial("SF3") + SF1->F1_FORNECE + SF1->F1_LOJA + SF1->F1_DOC + SF1->F1_SERIE,.T.)
        RecLock("SF3",.F.)
        SF3->F3_CGCNPJ := POSICIONE("SA2",1,XFILIAL("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,'A2_CGC') 
        MSUnlock()
    Endif
    
    RestArea(_cArea)
Return
