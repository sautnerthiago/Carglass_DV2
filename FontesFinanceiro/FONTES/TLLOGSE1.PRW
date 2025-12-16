#include 'protheus.ch'
#include "rwmake.ch"
#Include 'Totvs.ch'
#Include "TopConn.ch"
#INCLUDE "TBICONN.CH"
#Include "FWMVCDef.ch"

/*---------------------------------------------------------------------*
 | Func:  TLLOGSE1                                                    |
 | Autor: Fabio José Batista                                          |
 | Data:  15/10/2024                                                  |
 | Desc:  Função para cadastro dos logs de títulos não compensados    |
 *---------------------------------------------------------------------*/
User Function TLLOGSE1()
     Local aArea    := GetArea()
    Local aAreaP21  := P21->(GetArea())
    Local cDelOk   := ".T."
    Local cFunTOk  := ".T." 
 
    //Chamando a tela de cadastros
    AxCadastro('P21', 'Logs Titulos a receber não compensados', cDelOk, cFunTOk)
 
    RestArea(aAreaP21)
    RestArea(aArea)
Return
