#include 'protheus.ch'
#include "rwmake.ch"
#Include 'Totvs.ch'
#Include "TopConn.ch"
#INCLUDE "TBICONN.CH"
#Include "FWMVCDef.ch"

 /*---------------------------------------------------------------------*
 | Func:  M460FIM                                                      |
 | Autor: Fabio José Batista                                           |
 | Data:  15/10/2025                                                   |
 | Desc:  Gravação o campo na SE1 após gerar NF de Saída               |
 *---------------------------------------------------------------------*/
User Function AtuSE1()
 
    Local aAreaSE1 := SE1->(GetArea())
    Local aAreaSF2 := SF2->(GetArea())
    Local aAreaSD2 := SD2->(GetArea()) 
    Local aAreaSC5 := SC5->(GetArea())    
        
    cQry := "select R_E_C_N_O_ AS REC from "+RetSqlName("SE1") "
    cQry += "where E1_FILIAL = '" + xFilial("SE1") + "' and D_E_L_E_T_ = ' '  "
    cQry += "and E1_CLIENTE = '" + SF2->F2_CLIENTE + "' and E1_LOJA = '" + SF2->F2_LOJA + "' " 
    cQry += "and E1_PREFIXO = '" + SF2->F2_SERIE + "' and E1_NUM = '" + SF2->F2_DOC + "' "
    cQry += "and E1_TIPO = 'NF' "
    
    cQry := ChangeQuery(cQry)
    TCQuery cQry New Alias "cQry"
     
   cQry->(DbGoTop())
    While !cQry->(Eof())
        If !select('SE1') > 0
            DbSelectArea("SE1")
        EndIf 
        SE1->(DbGoTo(cQry->REC)) 
        If !SE1->(EoF())
            RecLock("SE1",.F.)
                SE1->E1_NRDOC := SC5->C5_ZEXTID // Extern ID 
            SE1->(MsUnlock())
        EndIf
       cQry->(DbSkip())
    Enddo

    cQry->(DbCloseArea())
     
    RestArea(aAreaSF2)
    RestArea(aAreaSD2)
    RestArea(aAreaSE1)
    RestArea(aAreaSC5)
    
Return
