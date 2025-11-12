#include "rwmake.ch"
#include "TOPCONN.CH"

User Function  MT120LOK() 
    Local nPosPrd   := aScan(aHeader,{|x| AllTrim(x[2]) == 'C7_PRODUTO'})
    Local nPosItem  := aScan(aHeader,{|x| AllTrim(x[2]) == 'C7_ITEM'})
    Local nAprov    := aScan(aHeader,{|x| AllTrim(x[2]) == 'C7_APROV'})
    Local lValido   := .T.
    dbSelectArea('SC7')
    dbSetOrder(4)
    IF UPPER(FUNNAME()) == "MATA121" 
        If MsSeek(xFilial('SC7')+aCols[n][nPosPrd]+cA120Num+aCols[n][nPosItem])   
            IF !EMPTY(SC7->C7_ZEXTID)  //11/11/2025 - COLOCADO A NEGAÇÃO //solcitação apos reunião com Victor, Tania, Wellintong e mais- 06/11/2025
                lValido := .T.     
            ELSE
                If EMPTY(aCols[n][nAprov])
                    FWAlertError("Não Ha Aprovador, PEDIDO NÃO será GRAVADO, Por favor INFORME o APROVADOR DO PEDIDO.", "ERRO - APROVADOR") 
                    lValido := .F.     
                else
                    RECLOCK("SC7",.F.)
                    SC7->C7_APROV := aCols[n][nAprov]
                    MSUNLOCK("SC7")
                EndIf
            ENDIF
        EndIf 
    EndIf
Return(lValido) 
