#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "RPTDEF.CH"
/*/{Protheus.doc} PrxNrAtv
description Numerador do ativo fixo com base no grupo do bem (SNG)
@type function
@version  
@author ricardo.cavalini  
@since 30/09/2025 
/*/
User Function PrxNrAtv(cGrpAtv)
	Local cAlias  := GetNextAlias()
	Local cRet    := ''
	Local cPrf    := Posicione("SNG",1,XFILIAL("SNG")+cGrpAtv,"NG_C_PRF")
	
	BeginSql Alias cAlias
		SELECT MAX(SN1.N1_CBASE) AS N1ATIV
		FROM %Table:SN1% SN1
        WHERE SN1.%NotDel% AND SUBSTRING(SN1.N1_CBASE,1,3) = %EXP:cPrf%		
	EndSql
	
	If !(cAlias)->(Eof())
		IF !EMPTY(AllTrim((cAlias)->N1ATIV))
  		   cRet := cPrf+STRZERO((VAL(SUBSTR(AllTrim((cAlias)->N1ATIV),4,7))+1),7)
		ELSE
		   cRet := cPrf+"0000001"
		ENDIF    
	EndIf

	(cAlias)->(DbCloseArea())
	
Return cRet
