#Include  'Protheus.ch'
 
User Function FA240PA()
 
Local lRet  :=  .T.  // .T. - para o sistema permitir a seleção de PA (com mov. Bancário) na tela de borderô de pagamento e
 
                             // .F. - para não permitir.
 
lRet :=  MsgYesNo("Permite selecionar PA? ")
 
Return lRet
