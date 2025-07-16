#Include "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

User Function AJUSTSF3()
	_cArea	  := GetArea()

    WHILE !SF3->(EOF())
        RecLock("SF3",.F.)
        If SUBSTR(SF3->F3_CFO,1,1) $ "1/2/3"
            SF3->F3_CGCNPJ := POSICIONE("SA2",1,XFILIAL("SF3")+SF3->F3_CLIEFOR+SF3->F3_LOJA,'A2_CGC') 
        ELSE
            SF3->F3_CGCNPJ := POSICIONE("SA1",1,XFILIAL("SF3")+SF3->F3_CLIEFOR+SF3->F3_LOJA,'A1_CGC') 
        Endif
        MsUnLock()
        
        SF3->(DBSKIP())
        LOOP
    ENDDO

	RestArea(_cArea)
Return .T.
