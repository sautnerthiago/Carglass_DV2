#INCLUDE "TOTVS.CH"
/*/{Protheus.doc} FA040GRV
Utilizado apos a gravacao de todos os dados (na inclusao do ti­tulo) e antes da sua contabilizacao   
@type     function FA040GRV()
@author   Ricardo Cavalini
@since    09.10.2025
/*/
User Function FA040GRV()
Local aAreaE1  := SE1->(GetArea())
Local cClieE1  := SE1->E1_CLIENTE
Local cLojaE1  := SE1->E1_LOJA


SE1->(RecLock("SE1",.F.))
  SE1->E1_ZCNPJ := POSICIONE("SA1",1,XFILIAL("SA1")+cClieE1+cLojaE1,"A1_CGC")
SE1->( MsUnlock() )

Restarea(aAreaE1)

Return( Nil )
