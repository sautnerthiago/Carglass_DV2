#INCLUDE "RWMAKE.CH"

//----------------------------------------------------------------------
//Programa.......: BLQFINA
//Objetivo.......: Função para bloquear Financeiro
//Autor..........: Alan 
//Data...........: 09/12/2025
//--------------------------------------------------------------------*/

User Function BLQFINA() 

// Definição das variáveis do programa. 
Local cCodUsr := RetCodUsr() 
Public _mvDATAFIN := GetMv("MV_DATAFIN") 
Public _mvBXDTFIN := GetMv("MV_BXDTFIN") 
Public _mvusuarios := GetMv("MV_X_ALFIN")
Private oPermBx
Private oMyDlg

// Verifica se o usuário é o Administrador do sistema ou usuários autorizados. 
If !Alltrim(cCodUsr) $ _mvusuarios 
     Alert("Somente o Administrador ou usuários autorizados podem executar esta rotina.") 
     Return 
EndIf 

// Solicita ao usuário informação 
@ 150, 1 TO 400, 635 DIALOG oMyDlg TITLE OemToAnsi("Bloqueio de movimentação financeira") 
@   2, 10 TO 110, 610 
@ 10, 18 Say OemToAnsi(" Movimentações somente a partir de ") 
@ 10,150 Get _mvDATAFIN Size 50,50 
@ 30, 18 Say OemToAnsi(" Permite baixas P/R anteriores a data do bloqueio? ") 
//@ 18,115 Get _mvBXDTFIN Size 50,50
@ 30,150 MSCOMBOBOX oPermBx VAR IIF(AllTrim(_mvBXDTFIN)=="1","Permite","Nao permite") ITEMS {OemToAnsi("Permite"),OemToAnsi("Não permite")} SIZE 056, 010 OF oMyDlg COLORS 0, 16777215 PIXEL 

@ 110,150 BMPBUTTON TYPE 01 ACTION (RunProc(), Close(oMyDlg)) 
@ 110,180 BMPBUTTON TYPE 02 ACTION Close(oMyDlg) 
Activate Dialog oMyDlg Centered 
Return 

Static Function RunProc() 

// Faz validações e Altera os parâmetros. 
If !Empty(_mvDATAFIN) 
     PutMv("MV_DATAFIN",_mvDATAFIN)
EndIf

If oPermBx:nAt == 1
	  PutMv("MV_BXDTFIN","1")
Else
	  PutMv("MV_BXDTFIN","2")
EndIf 

return
