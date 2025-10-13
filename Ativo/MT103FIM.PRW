#include "PROTHEUS.CH"
/*/{Protheus.doc} MT103FIM
@description	O ponto de entrada MT103FIM encontra-se no final da função A103NFISCAL.
		Após o destravamento de todas as tabelas envolvidas na gravação do documento de entrada, depois de fechar a operação realizada neste.
		É utilizado para realizar alguma operação após a gravação da NFE.
@author 	Ricardo Cavalini 
@since 		08/10/2025
@source		MT103FIM.PRW
@type 		function
/*/
User Function MT103FIM()

Local aArea 		:= GetArea()
Local nOpc			:= Paramixb[1]  // 3 - INCLUSAO 4 - CLASSIFICACAO
Local lBotaoOK		:= iif(Paramixb[2]==1,.t.,.f.)

If lBotaoOK  //.T.
	IF (nOpc = 3 .or. nOpc = 4) .AND. SF1->F1_TIPO $ "D/B"

       IF !EMPTY(ALLTRIM(SF1->F1_DUPL))
			DbselectArea("SE1")
			RecLock("SE1",.F.)
		 	 SE1->E1_ZCNPJ := SA1->A1_CGC
			MsUnlock("SE1")
	   ENDIF 
	ENDIF 
ENDIF

RestArea(aArea)

Return
