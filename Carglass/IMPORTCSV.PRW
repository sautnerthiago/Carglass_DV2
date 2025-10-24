#include 'protheus.ch'
#include 'parmtype.ch'

//Função parambox com todos os tipos e botões  extras.
User function IMPORTCSV()
	local aPergs   := {}
	local aRet     := {}
	local aButtons := {}
	Local aDados   := {}
	local cArquivo := ""
    Local aEscolh  := {"001 - Mercado Livre", "002 - Shoppee"}


	//Tipo 5 - Cria Opções de CheckBox.
	aAdd( aPergs ,{9,"Selecione o Cliente para Criação do Pedido"   ,200, 40,.T.})
    aAdd( aPergs ,{2,"Qual o Client? ",01,aEscolh,90,"",.T.})

	//Tipo 6 - Cria um botão tipo File para buscar arquivos e retorna o caminho apontado.
	aAdd( aPergs ,{9,"Selecione o Arquivo CSV para Importação"      ,200, 40,.T.})
	aAdd( aPergs ,{6,"Aponte o arquivo:",Space(100),"","",""        ,70,.F.,"Todos os arquivos (*.*) |*.*"})

	//Chamada com bloco de bOK
	If ParamBox(aPergs ,"Importação Pedido de Vendas",aRet,{|| bOKaRet(aRet)},aButtons,,,,,,,)
		If ! Empty(aRet[04])

			aDados := fLerArq( alltrim( aRet[04]) )
            
            //GerDad(aDados)
            GerSBE(aDados)

			MsgInfo("Arquivo apontado:" + left(alltrim(cArquivo),20),"Importação Pedido de Vendas")
			Return
		EndIf
	Else
		MsgAlert("Processo Cancelado pelo usuário","Importação Pedido de Vendas")
		return
	EndIf

return
//------------------------
Static Function bOKaRet(aRet)
	local w
	local lRet := .T.

	For w := 1  To Len(aRet)

		If Empty(aRet[04])
			MsgInfo("Nenhum arquivo foi apontado na busca","bOKaRet")
			lRet := .F.
			Exit
		EndIf

	Next w

Return lRet
//-------------------------
user function IMPARBOX()
	Local oTFont     := TFont():New("Arial",,40,,.F.,,,,.T.,.F.)
	Private oPatch, cGetPatch := "https://terminaldeinformacao.com/knowledgebase/parambox/"
	Private oDlg, oPanel1

	DEFINE FONT oBold NAME "Arial" SIZE 0, -12 BOLD
	DEFINE MSDIALOG oDlg TITLE "Teste PARBOX" STYLE DS_MODALFRAME FROM 000, 000  TO 460, 800 COLORS 0, 16777215 PIXEL

	oPanel1 := TPanel():New(01,01,"Rotina em Manutenção!!! TI vai arrumar!!!!",oPanel1,oTFont,.T.,,CLR_RED,/*CLR_BLUE*/,600,230,.T.,.T.)
	oPanel1 := TWebEngine():New(oPanel1, 01, 01, 600, 230, cGetPatch,  )

	oDlg:lEscClose := .F.
	Activate MSDialog oDlg Centered On Init EnchoiceBar(oDlg, {||OK()}, { ||oDlg:End()},,,,,.F.,.F., .F., .T.,.F.,)

return
//-------------------------------------------------
Static Function OK()
	oDlg:End()
Return


Static Function GerDad(aDados)
	Local lRet := .T.
	Local nX 

	FOR nX := 1 TO lEN(aDados)
		NNR->( RecLock("NNR", .T.))
			NNR->NNR_FILIAL	:= aDados[nX,01]
			NNR->NNR_CODIGO	:= aDados[nX,02]
			NNR->NNR_DESCRI	:= aDados[nX,03]
		NNR->( msUnLock())
	NEXT

Return lRet

Static Function GerSBE(aDados)
	Local lRet := .T.
	Local nX 

	FOR nX := 1 TO lEN(aDados)
		SBE->( RecLock("SBE", .T.))
			SBE->BE_FILIAL	:= aDados[nX,01]
			SBE->BE_LOCAL	:= aDados[nX,02]
			SBE->BE_LOCALIZ	:= aDados[nX,03]
			SBE->BE_DESCRIC	:= aDados[nX,04]
		SBE->( msUnLock())
	NEXT

Return lRet


Static Function fLerArq(_cArq)
    Local nHandle    := 0

    Default cArquivo := _cArq
    Default lCon	 := .f.

	Local aLinhas    := {}
	Local aRet       := {}

    If File(cArquivo)

		// Abre o arquivo
		nHandle := FT_FUSE(cArquivo)
		// Se houver erro de abertura abandona processamento
		if nHandle = -1
			return
		endif
		// Posiciona na primeria linha
		FT_FGoTop()
		// Retorna o número de linhas do arquivo
		nLast := FT_FLastRec()
		ProcRegua(FT_FLASTREC())
    
		While !FT_FEOF()
			cLine  := FT_FReadLn()
			// Retorna a linha corrente
			nRecno := FT_FRecno()
			// Retorna o recno da Linha
			aLinhas := StrTokArr(cLine, ";")
			AAdd(aRet, aLinhas)
			FT_FSKIP()
			INCPROC("Lendo arquivo texto...")
		End
		// Fecha o Arquivo
		FT_FUSE()		
        FCLOSE(nHandle)
        if len(aRet) > 0 
            conout("Arquivo lido: " +cArquivo )
        Endif 
    Else 
        //cString := "erro - 003 - Arquivo nao Encontrado"
		conout("erro - 003 - Arquivo nao Encontrado" )
    Endif 
		
Return aRet
