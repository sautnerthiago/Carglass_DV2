#include 'protheus.ch'
#include 'parmtype.ch'
/*/{Protheus.doc} MT100GE2
Localização.: Function A103AtuSE2 - Rotina que efetua a integração entre o documento de entrada e os títulos financeiros a pagar,após a gravação de cada parcela. 
Finalidade...: Complementar a gravação na tabela dos títulos financeiros a pagar.
@type     function MT100GE2()
@author   Ricardo Cavalini
@since    08.10.2025
/*/
User Function MT100GE2()
// Local aTitAtual := PARAMIXB[1]  // ACols dos títulos financeiro a pagar
Local nOpc      := PARAMIXB[2]  // 1=inclusão de títulos  2=exclusão de títulos
// Local aHeadSE2  := PARAMIXB[3]  // AHeader dos títulos financeiros a pagar
// Local nX        := ParamIXB[4]  // Numero da parcela sendo processada
// Local aParcelas := ParamIXB[5]  // Array das parcelas do titulo

If nOpc == 1 //.. inclusao
        SE2->E2_ZCNPJ :=  SA2->A2_CGC
Endif

Retur
