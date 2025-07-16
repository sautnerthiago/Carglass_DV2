#Include "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

User Function SF2460I()
	_cArea	  := GetArea()
    DbSelectArea("SF3")             
    DbSetOrder(5)
    If DbSeek(xFilial("SF3")+SF2->F2_SERIE+SF2->F2_DOC+SF2->F2_CLIENTE)
        RecLock("SF3",.F.)
        SF3->F3_CGCNPJ := POSICIONE("SA1",1,XFILIAL("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,'A1_CGC') 
        MsUnLock()
    Endif

	RestArea(_cArea)
Return .T.
