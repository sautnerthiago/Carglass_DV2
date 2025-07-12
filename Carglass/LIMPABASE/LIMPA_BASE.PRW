#include "rwmake.ch"
#include "Topconn.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"
#include "fileio.ch"
#include "protheus.ch"

/*/


?
Programa             Autor  Mario Chagas        Data   12/2009    
?
Descricao  Rotina para ler arquivos TXT e efetuar a limpeza dos       
           dos movimentos da base de dados SQL                        
?
Uso                                                                   
?


/*/

USER FUNCTION LIMPA_BASE()

	Private aFilesTxt
	Private nHdl2
	Private cEOL    := "CHR(13)+CHR(10)"

	If Empty(cEOL)
		cEOL := CHR(13)+CHR(10)
	Else
		cEOL := Trim(cEOL)
		cEOL := &cEOL
	Endif


	If MsgYesNo("Essa rotina ir limpar os movimentos da base de dados SQL"+Chr(13)+"Deseja Continuar ?")
		cTipo := "Arquivos de Dados (*.TXT)  |*.TXT | "
		cArq :=  cGetFile(cTipo, "Selecione o arquivo") // seleciona o arquivo com as tabelas a serem limpas
		aFilesTxt    := Directory(cArq)
		If Len(aFilesTxt) <= 0
			MsgBox("Arquivo no encontrado !","A T E N C A O","ALERT")
			Return
		EndIf

		nHdl2    := FT_FUSE(cArq)
		If nHdl2 == -1
			MsgBox("Problema com leitura do arquivo "+Alltrim(aFilesTxt[i,1]),"A T E N C A O","ALERT")
			Return .F.
		Else
			Processa({|| LIMPA() },"Limpando tabelas...")
		Endif
	Endif
Return

/*


?
Programa   LIMPA    Autor  Mario Chagas         Data   12/2009     
?
Desc.      Limpeza                                                    
?


*/

Static Function LIMPA()

	FT_FGOTOP()

	ProcRegua(FT_FLASTREC())

	While !FT_FEOF() //Processa enqto houver dados no arquivo texto
		IncProc("Processando Leitura do Arquivo Texto..." + Alltrim(aFilesTxt[1,1]))
		cQuery := "DELETE FROM "+Left(Alltrim(FT_FREADLN()),6)
		TCSqlExec(cQuery)
		FT_FSKIP()

	EndDo

	FT_FUSE()

Return
