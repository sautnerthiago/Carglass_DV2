#INCLUDE "TOTVS.CH"
/*/{Protheus.doc} FA050GRV
Utilizado apos a gravacao de todos os dados (na inclusao do ti­tulo) e antes da sua contabilizacao   
@type     function FA050GRV()
@author   Ricardo Cavalini
@since    08.10.2025
/*/
User Function FA050GRV()
Local aAreaE2  := SE2->(GetArea())
Local cFornE2  := SE2->E2_FORNECE
Local cLojaE2  := SE2->E2_LOJA


SE2->(RecLock("SE2",.F.))
  SE2->E2_ZCNPJ := POSICIONE("SA2",1,XFILIAL("SA2")+cFornE2+cLojaE2,"A2_CGC")
SE2->( MsUnlock() )

Restarea(aAreaE2)

Return( Nil )




