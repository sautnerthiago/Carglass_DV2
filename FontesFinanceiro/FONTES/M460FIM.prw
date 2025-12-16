#Include "PROTHEUS.CH"
#Include "TOPCONN.CH"

User Function M460FIM()
    Local _aArea   := GetArea()
    Local cTpNFS   := SF2->F2_TIPO
    Local cNrCGC   := ""

	If ExistBlock("AtuSE1")
	   U_AtuSE1()
	EndIf

    IF !ALLTRIM(cTpNFS) $ "B/D" 

	   cNrCGC := POSICIONE("SA1",1,XFILIAL("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_CGC")

       //Filtra tI­tulos dessa nota
    	cSql := "SELECT R_E_C_N_O_ AS REC FROM "+RetSqlName("SE1") 
    	cSql += " WHERE E1_FILIAL = '"+xFilial("SE1")+"' AND D_E_L_E_T_<>'*' "
    	cSql += " AND E1_PREFIXO = '"+SF2->F2_SERIE+"' AND E1_NUM = '"+SF2->F2_DOC+"' "
 
    	TcQuery ChangeQuery(cSql) New Alias "_QRY"
    
    	//Enquanto tiver dados na query
   	 	While !_QRY->(eof())
        	DbSelectArea("SE1")
        	SE1->(DbGoTo(_QRY->REC))

        	If !SE1->(EoF())
            	 RecLock("SE1",.F.)
                	Replace E1_ZCNPJ WITH cNrCGC
            	 MsUnlock("SE1")
        	EndIf
         
	        _QRY->(DbSkip())
    	End

ELSE 

	   cNrCGC := POSICIONE("SA2",1,XFILIAL("SA2")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A2_CGC")
	   
       //Filtra tI­tulos dessa nota
    	cSql := "SELECT R_E_C_N_O_ AS REC FROM "+RetSqlName("SE2") 
    	cSql += " WHERE E2_FILIAL = '"+xFilial("SE2")+"' AND D_E_L_E_T_<>'*' "
    	cSql += " AND E2_PREFIXO = '"+SF2->F2_SERIE+"' AND E2_NUM = '"+SF2->F2_DOC+"' "
 
    	TcQuery ChangeQuery(cSql) New Alias "_QRY"
    
    	//Enquanto tiver dados na query
   	 	While !_QRY->(eof())
        	DbSelectArea("SE2")
        	SE2->(DbGoTo(_QRY->REC))

        	If !SE2->(EoF())
            	 RecLock("SE2",.F.)
                	Replace E2_ZCNPJ WITH cNrCGC
            	 MsUnlock("SE2")
        	EndIf
         
	        _QRY->(DbSkip())
    	End

ENDIF 

    _QRY->(DbCloseArea())
    RestArea(_aArea)
 
Return
