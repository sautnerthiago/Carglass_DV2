#INCLUDE "Protheus.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#Include 'FWMVCDef.ch'
#INCLUDE "TOPCONN.CH"
#define CRLF chr(13) + chr(10)

/*
===================================================================================
Programa............: IMP_SALDO
Autor...............: Anderson Fernandes
Data................: 19/05/2020
Descricao / Objetivo: Importar arquivo de Saldos de Estoque, Produtos, Fornecedores,
                      Clientes, Saldo a Pagar e Saldo a Receber
====================================================================================
Ambipar
*/

User Function IMP_SALDO()    // U_IMP_SALDO()

	Local aMensagem := {}
	Local aBotoes   := {}
	Local bSair     := .T.
	Local oButton1
	Local oRadMenu1
	Local oSay1
	Static oDlg



	Private cTitulo  := "Importação de Cadastros Básicos"
	Private nEscolha := 1

	Aadd( aMensagem, OemToAnsi("Este programa tem como objetivo importar cadastros padrões através de arquivos textos                              "))
	Aadd( aMensagem, OemToAnsi("    "))
	Aadd( aMensagem, OemToAnsi("Este arquivo deverá ser separado por ponto e virgulas(.CSV) e o primeiro registro conterá os  nomes dos campos a serem importados"))
	Aadd( aMensagem, OemToAnsi("    "))
	AAdd( aMensagem, OemToAnsi("Será questionado se deverá ser excluidos os registros das tabelas destinos antes da importação."))
	AAdd( aBotoes, { 19, .T., { || FechaBatch(), bSair     := .F. } } )
	AAdd( aBotoes, { 02, .T., { || FechaBatch(), bSair     := .T. } } )
	FormBatch( cTitulo, aMensagem, aBotoes, , 260,700  )
	IF !bSair


		DEFINE MSDIALOG oDlg TITLE "Importação de Cadastros" FROM 000, 000  TO 250, 400 COLORS 0, 16777215 PIXEL

		@ 020, 006 RADIO oRadMenu1 VAR nEscolha ITEMS "Produtos","Fornecedor","Clientes","Saldos de Estoque","Saldo a Pagar","Saldo a Receber","Lotes de Estoque","Pedidos de Venda em Aberto","Ativo fixo","Transportadora" SIZE 159, 130 OF oDlg COLOR 0, 16777215 PIXEL
		@ 006, 006 SAY oSay1 PROMPT "Selecione o cadastro a importar :" SIZE 091, 007 OF oDlg COLORS 0, 16777215 PIXEL
		oButton1 := TButton():New( 104, 141 ,'Importar', oDlg,{|| Processa( { || ImpSal_Exec() }, cTitulo , 'Importando...', .F. ),oDLG:end() } ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )

		ACTIVATE MSDIALOG oDlg CENTERED

	ENDIF


Return
	***********************************************************************************************************************
Static Function ImpSal_Exec()
	Local cArq	    := ""
	Local cLinha    := ''
	Local lPrim     := .T.
	Local aCampos   := {}
	Local aDados    := {}
	Local cBKFilial := cFilAnt
	Local nCampos   := 0
	Local aExecAuto := {}
	Local aTipoImp  := {}
	Local nTipoImp  := 0
	Local cTipo     := ''
	Local cTab      := ''
	Local aMensagem :={}
	Local aCab      := {}
	Local aItem     := {}
	Local nI        := 0
	Local cPedido   := ''
	Local nLinha	:= 1
	Local lContinua := .T.

	Private lMsErroAuto    := .F.
	Private aTabExclui     := { {'B1',{"SB1"}} ,;
		{'B9',{"SB2","SB9"} },;
		{'A2',{"SA2"} },;
		{'A1',{"SA1"} },;
		{'E2',{"SE2"} },;
		{'E1',{"SE1"} },;
		{'C5',{"SC5","SC6"} },;
		{'C6',{"SC5","SC6"} },;
		{'D5',{"SD5","SD5"} },;
		{'N1',{"SN3","SN3"} },;
		{'N3',{"SN3"} },;
		{'A4',{"SA4"} }}




	AAdd( aMensagem, OemToAnsi("Para importar a tabela de Produto, o arquivo deverá conter campos da SB1"))
	AAdd( aMensagem, OemToAnsi("Para importar a tabela de Fornecedor o arquivo deverá conter campos da SA2"))
	AAdd( aMensagem, OemToAnsi("Para importar a tabela de Clientes, o arquivo deverá conter campos da SA1"))
	AAdd( aMensagem, OemToAnsi("Para importar a tabela de Saldo de Estoque, o arquivo deverá conter campos da SB9"))
	AAdd( aMensagem, OemToAnsi("Para importar a tabela de Saldo a Pagar, o arquivo deverá conter campos da SE2"))
	AAdd( aMensagem, OemToAnsi("Para importar a tabela de Saldo a Receber, o arquivo deverá conter campos da SE1"))
	AAdd( aMensagem, OemToAnsi("Para importar a tabela de Lotes do Estoque, o arquivo deverá conter campos da SD5"))
	AAdd( aMensagem, OemToAnsi("Para importar a Pedidos de Venda o arquivo deverá conter registros das tabelas SC5 e SC6"+CRLF+;
		"Sendo que o primeiro deverá conter os campos da SC5 e depois da SC6"+CRLF+;
		"Obrigatoriamente deverá conter o campo C5_NUM"+CRLF+;
		"Quando mudar o C5_NUM será entendido que será um novo pedido de venda"))
	AAdd( aMensagem, OemToAnsi("Para importar a tabela de Ativo fixo, o arquivo deverá conter campos da SN3"))
	AAdd( aMensagem, OemToAnsi("Para importar a tabela de Transportadora Ativo fixo, o arquivo deverá conter campos da SA4"))
	MsgAlert(aMensagem[nEscolha])

	cArq := cGetFile("Todos os Arquivos|*.csv", OemToAnsi("Informe o diretório que está o arquivo"), 0, "SERVIDOR\", .F., GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE ,.T.)

	If !File(cArq)
		MsgStop("O arquivo " +cArq + " não foi encontrado. A importação será abortada!","ATENCAO")
		Return
	EndIf

	FT_FUSE(cArq)
	FT_FGOTOP()
	cLinha    := FT_FREADLN()
	aTipoImp  := Separa(cLinha,";",.T.)
	cTIPO     := SUBSTR(aTipoImp[1],1,2)

	IF !(cTIPO $('B1 B9 A1 A2 E1 E2 D5 C5 N3 N1 A4'))
		MsgAlert('Não é possivel importar a tabela: '+cTipo+ '  !!')
		Return
	ENDIF

	IF  (cTIPO=='B1'.And. nEscolha<> 1) .OR. ;
			(cTIPO=='A2'.And. nEscolha<> 2) .OR. ;
			(cTIPO=='A1'.And. nEscolha<> 3) .OR. ;
			(cTIPO=='B9'.And. nEscolha<> 4) .OR. ;
			(cTIPO=='E2'.And. nEscolha<> 5) .OR. ;
			(cTIPO=='E1'.And. nEscolha<> 6) .OR. ;
			(cTIPO=='D5'.And. nEscolha<> 7) .OR. ;
			(cTIPO=='C5'.And. nEscolha<> 8) .OR. ;
			(cTIPO $ 'N3|N1' .And. nEscolha<> 9) .OR. ;
			(cTIPO=='A4'.And. nEscolha<> 10)
		MsgAlert('Escolha é diferente do Arquivo Texto'+cTipo+ '  !!')
		Return
	ENDIF

	dbSelectArea("SX3")
	DbSetOrder(2)
	For nI := 1 To Len(aTipoImp)
		IF cTipo <> SUBSTR(aTipoImp[nI],1,2) .And. cTipo <> 'C5' .And. cTipo <> 'N1'
			MsgAlert('Todos os campos devem pertencer a mesma tabela !!')
			Return
		ENDIF
		IF !SX3->(dbSeek(Alltrim(aTipoImp[nI])))
			MsgAlert('Campo não encontrado na tabela :'+aTipoImp[nI]+' !!')
			Return
			//ELSEIF (SX3->X3_VISUAL $ ('V') ) //.OR. (SX3->X3_CONTEXT == "V"  )
		ELSEIF  (SX3->X3_CONTEXT == "V"  )
			MsgAlert('Campo marcado na tabela como visual :'+aTipoImp[nI]+' !!')
			Return
		ENDIF
	Next nI

	nTipoImp  := aScan( aTabExclui, { |x| AllTrim( x[1] ) == cTipo } )

	cTab := ''
	For nI := 1 To Len(aTabExclui[nTipoImp,2])
		cTab += aTabExclui[nTipoImp,2,nI]+' '
	Next nI
/*
If MsgYesNo("Deseja excluir os dados da(s) tabela(s):"+cTab+"antes da importação ? ")
	For nI := 1 To Len(aTabExclui[nTipoImp,2])
		cSQL := "delete from "+RetSqlName(aTabExclui[nTipoImp,2,nI])
		If (TCSQLExec(cSQL) < 0)
			Return MsgStop("TCSQLError() " + TCSQLError())
	  	EndIf
	Next nI
EndIf	
*/
	ProcRegua(FT_FLASTREC())
	FT_FGOTOP()
	While !FT_FEOF()
		IncProc("Lendo arquivo texto...")
		cLinha := FT_FREADLN()
		If lPrim
			aCampos := Separa(cLinha,";",.T.)
			lPrim := .F.
		Else
			cLinha := U_zLimpaEsp(cLinha)
			AADD(aDados,Separa(UPPER(NOACENTO(cLinha)),";",.T.))
		EndIf
		FT_FSKIP()
	EndDo
	aCab    := {}
	cPedido := aDados[01,01]

	cFileImp := cArq
	cFileLog := SubStr(AllTrim(cFileImp), 1, At('.', AllTrim(cFileImp)) - 1) + '.LOG'
	nHdlLog  := MSFCreate(cFileLog,0)
//--Atualiza arquivo de LOG:
	UpdFileLog(nHdlLog, '[' + DtoC(Date()) + ' - ' + Time() + '] INICIANDO IMPORTAÇÃO DOS DADOS - ARQUIVO COM ' + StrZero(FT_FLastRec() - 1,7) + ' LINHA(S)' + Chr(13) + Chr(10))


	For nCampos := 1 To Len(aCampos)
		IF  SUBSTR(Upper(aCampos[nCampos]),4,6)=='FILIAL'
			IF !EMpty(aDados[1,nCampos])
				cFilAnt := aDados[1,nCampos]
			ENDIF
		Else
			IF SUBSTR(Upper(aCampos[nCampos]),1,2)='C5'
				IF  TamSx3(Upper(aCampos[nCampos]))[3] =='N'
					aAdd(aCab ,{Upper(aCampos[nCampos]), 	Val(StrTran(aDados[nI][nCampos],",",".")) 	,Nil})
				ELSEIF TamSx3(Upper(aCampos[nCampos]))[3] =='D'
					aAdd(aCab ,{Upper(aCampos[nCampos]),  CTOD(aDados[1,nCampos] )	,Nil})
				ELSE
					aAdd(aCab ,{Upper(aCampos[nCampos]), 	aDados[1,nCampos] 	,Nil})
				ENDIF
			EndIF
		ENDIF
	Next nCampos
	aItem := {}
	ProcRegua(Len(aDados))
//Begin Transaction

//VALIDA O ARQUIVO ANTES DA IMPORTAÇÃO EM RELAÇÃO AO CC
	lErro := .F.
	If cTipo $ "E2|E1"
		For nI:=1 to  Len(aDados)
			aExecAuto := {}
			For nCampos := 1 To Len(aCampos)
				IF  SUBSTR(Upper(aCampos[nCampos]),4,6)=='FILIAL'
					IF !EMpty(aDados[nI,nCampos])
						cFilAnt := aDados[nI,nCampos]
					ENDIF
					aAdd(aExecAuto ,{Upper(aCampos[nCampos]), 	aDados[nI,nCampos] 	,Nil})
				Else
					IF  TamSx3(Upper(aCampos[nCampos]))[3] =='N'
						aAdd(aExecAuto ,{Upper(aCampos[nCampos]), Val(StrTran(aDados[nI][nCampos],",",".")) 	,Nil})
					ELSEIF TamSx3(Upper(aCampos[nCampos]))[3] =='D'
						aAdd(aExecAuto ,{Upper(aCampos[nCampos]),  CTOD(aDados[nI,nCampos] )	,Nil})
					ELSE
						aAdd(aExecAuto ,{Upper(aCampos[nCampos]), 	AllTrim(aDados[nI,nCampos]) 	,Nil})
					ENDIF
				ENDIF
			Next nCampos
			If cTipo == 'E2'   // Pagar
				//VALIDAÇÃO DE CENTROS DE CUSTO
				nPosCCD := aScan( aExecAuto, { |x| AllTrim( x[1] ) == "E2_CCD" } )
				nPosCCC := aScan( aExecAuto, { |x| AllTrim( x[1] ) == "E2_CCC" } )
				nPosFil := aScan( aExecAuto, { |x| AllTrim( x[1] ) == "E2_FILIAL" } )
				cFil := aExecAuto[nPosFil][2]
				If nPosCCD <= 0 .and. nPosCCC <= 0
					cErrAuto := "Não foram encontradas informações de centro de custo para o titulo"
					UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero(nLinha, 5) + '] INCONSISTENCIA NA IMPORTACAO DOS DADOS. DETALHE DO ERRO: ' + Chr(13) + Chr(10) + cErrAuto + Chr(13) + Chr(10))
					lErro := .T.
				EndIf
				If nPosCCD > 0
					nPosITD := aScan( aExecAuto, { |x| AllTrim( x[1] ) == "E2_ITEMD" } )
					nPosCLD := aScan( aExecAuto, { |x| AllTrim( x[1] ) == "E2_CLVLDB" } )
					cCCD := aExecAuto[nPosCCD][2]
					cITD := aExecAuto[nPosITD][2]
					cCLD := aExecAuto[nPosCLD][2]
					//
					cQueZZ1 := " SELECT * "
					cQueZZ1 += " FROM  "+RetSqlName("ZZ1")
					cQueZZ1 += " WHERE ZZ1_FILIAL = '"+cFil+"' "
					cQueZZ1 += " AND ZZ1_RECDES = 'D' "
					cQueZZ1 += " AND ZZ1_CCUSTO = '"+cCCD+"' "
					cQueZZ1 += " AND ZZ1_ITEM = '"+cITD+"' "
					cQueZZ1 += " AND ZZ1_CLASSE = '"+cCLD+"' "
					cQueZZ1 += " AND D_E_L_E_T_ = ''

					IF SELECT("cQueZZ1") > 0
						cQueZZ1->(DbCloseArea())
					ENDIF

					TcQuery cQueZZ1 New Alias "cQueZZ1"
					DbSelectArea("cQueZZ1")
					cQueZZ1->(DbGoTop())

					If cQueZZ1->(Eof())
						cErrAuto := "Filial + C Custo + Item + Classe nao cadastrado. "+cFil +' D '+" "+cCCD+" "+cITD+" "+cCLD
						UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero(nLinha, 5) + '] INCONSISTENCIA NA IMPORTACAO DOS DADOS. DETALHE DO ERRO: ' + Chr(13) + Chr(10) + cErrAuto + Chr(13) + Chr(10))

						cQueZZ1->(DbCloseArea())
						lErro := .T.
					Endif
				EndIf
				If nPosCCC > 0
					nPosITC := aScan( aExecAuto, { |x| AllTrim( x[1] ) == "E2_ITEMC" } )
					nPosCLC := aScan( aExecAuto, { |x| AllTrim( x[1] ) == "E2_CLVLCR" } )
					cCCC 	:= aExecAuto[nPosCCC][2]
					If nPosITC > 0
						cITC 	:= aExecAuto[nPosITC][2]
					Else
						cITC 	:= ""
					EndIf
					If nPosCLC > 0
						cCLC 	:= aExecAuto[nPosCLC][2]
					Else
						cCLC 	:= 	""
					EndIf

					cQueZZ1 := " SELECT * "
					cQueZZ1 += " FROM  "+RetSqlName("ZZ1")
					cQueZZ1 += " WHERE ZZ1_FILIAL = '"+cFil+"' "
					cQueZZ1 += " AND ZZ1_RECDES = 'D' "
					cQueZZ1 += " AND ZZ1_CCUSTO = '"+cCCC+"' "
					cQueZZ1 += " AND ZZ1_ITEM = '"+cITC+"' "
					cQueZZ1 += " AND ZZ1_CLASSE = '"+cCLC+"' "
					cQueZZ1 += " AND D_E_L_E_T_ = ''

					IF SELECT("cQueZZ1") > 0
						cQueZZ1->(DbCloseArea())
					ENDIF

					TcQuery cQueZZ1 New Alias "cQueZZ1"
					DbSelectArea("cQueZZ1")
					cQueZZ1->(DbGoTop())

					If cQueZZ1->(Eof())
						cErrAuto := "Filial + C Custo + Item + Classe nao cadastrado. "
						UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero(nLinha, 5) + '] INCONSISTENCIA NA IMPORTACAO DOS DADOS. DETALHE DO ERRO: ' + Chr(13) + Chr(10) + cErrAuto + Chr(13) + Chr(10))

						cQueZZ1->(DbCloseArea())
						lErro := .T.
					Endif

				EndIf

			ELSEIF cTipo == 'E1'   // Receber
				SE1->(dbSetOrder(1))
				If SE1->(dbSeek(AEXECAUTO[1][2]+AEXECAUTO[2][2]+AEXECAUTO[3][2]+padr(AEXECAUTO[4][2],2)+AEXECAUTO[5][2]))
					UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero(nLinha, 5) + '] INCONSISTENCIA NA IMPORTACAO DOS DADOS.: TITULO DUPLICADO ' + Chr(13) + Chr(10) )
				Else
					//Validação do centro de custo
					nPosCCD := aScan( aExecAuto, { |x| AllTrim( x[1] ) == "E1_CCD" } )
					nPosCCC := aScan( aExecAuto, { |x| AllTrim( x[1] ) == "E1_CCC" } )
					nPosFil := aScan( aExecAuto, { |x| AllTrim( x[1] ) == "E1_FILIAL" } )
					cFil := aExecAuto[nPosFil][2]

					If nPosCCD <= 0 .and. nPosCCC <= 0
						cErrAuto := "Não foram encontradas informações de centro de custo para o titulo"
						UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero(nLinha, 5) + '] INCONSISTENCIA NA IMPORTACAO DOS DADOS. DETALHE DO ERRO: ' + Chr(13) + Chr(10) + cErrAuto + Chr(13) + Chr(10))

						lErro := .T.
					EndIf
				EndIf
				If nPosCCD > 0
					nPosITD := aScan( aExecAuto, { |x| AllTrim( x[1] ) == "E1_ITEMD" } )
					nPosCLD := aScan( aExecAuto, { |x| AllTrim( x[1] ) == "E1_CLVLDB" } )
					cCCD 	:= aExecAuto[nPosCCD][2]
					If nPosITD > 0
						cITD := aExecAuto[nPosITD][2]
					Else
						cITD := ""
					EndIf
					If cCLD > 0
						cCLD := aExecAuto[nPosCLD][2]
					Else
						cCLD := ""
					EndIf
					//
					cQueZZ1 := " SELECT * "
					cQueZZ1 += " FROM  "+RetSqlName("ZZ1")
					cQueZZ1 += " WHERE ZZ1_FILIAL = '"+cFil+"' "
					cQueZZ1 += " AND ZZ1_RECDES = 'D' "
					cQueZZ1 += " AND ZZ1_CCUSTO = '"+cCCD+"' "
					cQueZZ1 += " AND ZZ1_ITEM = '"+cITD+"' "
					cQueZZ1 += " AND ZZ1_CLASSE = '"+cCLD+"' "
					cQueZZ1 += " AND D_E_L_E_T_ = ''

					IF SELECT("cQueZZ1") > 0
						cQueZZ1->(DbCloseArea())
					ENDIF

					TcQuery cQueZZ1 New Alias "cQueZZ1"
					DbSelectArea("cQueZZ1")
					cQueZZ1->(DbGoTop())

					If cQueZZ1->(Eof())
						cErrAuto := "Filial + C Custo + Item + Classe nao cadastrado. "
						UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero(nLinha, 5) + '] INCONSISTENCIA NA IMPORTACAO DOS DADOS. DETALHE DO ERRO: ' + Chr(13) + Chr(10) + cErrAuto + Chr(13) + Chr(10))

						cQueZZ1->(DbCloseArea())
						lErro := .T.
					Endif

				EndIf
				If nPosCCC > 0
					nPosITC := aScan( aExecAuto, { |x| AllTrim( x[1] ) == "E1_ITEMC" } )
					nPosCLC := aScan( aExecAuto, { |x| AllTrim( x[1] ) == "E1_CLVLCR" } )
					cCCC 	:= aExecAuto[nPosCCC][2]
					cITC 	:= aExecAuto[nPosITC][2]
					cCLC 	:= aExecAuto[nPosCLC][2]

					cQueZZ1 := " SELECT * "
					cQueZZ1 += " FROM  "+RetSqlName("ZZ1")
					cQueZZ1 += " WHERE ZZ1_FILIAL = '"+cFil+"' "
					cQueZZ1 += " AND ZZ1_RECDES = 'D' "
					cQueZZ1 += " AND ZZ1_CCUSTO = '"+cCCC+"' "
					cQueZZ1 += " AND ZZ1_ITEM = '"+cITC+"' "
					cQueZZ1 += " AND ZZ1_CLASSE = '"+cCLC+"' "
					cQueZZ1 += " AND D_E_L_E_T_ = ''

					IF SELECT("cQueZZ1") > 0
						cQueZZ1->(DbCloseArea())
					ENDIF

					TcQuery cQueZZ1 New Alias "cQueZZ1"
					DbSelectArea("cQueZZ1")
					cQueZZ1->(DbGoTop())

					If cQueZZ1->(Eof())
						cErrAuto := "Filial + C Custo + Item + Classe nao cadastrado. "+cFil +' R '+" "+cCCC+" "+cITC+" "+cCLC
						UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero(nLinha, 5) + '] INCONSISTENCIA NA IMPORTACAO DOS DADOS. DETALHE DO ERRO: ' + Chr(13) + Chr(10) + cErrAuto + Chr(13) + Chr(10))
						cQueZZ1->(DbCloseArea())
						lErro := .T.
					Endif

				EndIf

			EndIf
		Next
	EndIf
	/*
	If lErro
		UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] **********************************************' + Chr(13) + Chr(10))
		UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] * Nao sera importado nenhum item da planilha *' + Chr(13) + Chr(10))
		UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] **********************************************' + Chr(13) + Chr(10))
		DisarmTransaction()
		break
	EndIf
	*/
//
	For nI:=1 to  Len(aDados)
		nLinha++
		IncProc("Importando arquivo...")
		IF nEscolha <> 8 .and. nEscolha <> 9
			aExecAuto := {}
			For nCampos := 1 To Len(aCampos)
				IF  SUBSTR(Upper(aCampos[nCampos]),4,6)=='FILIAL'
					IF !EMpty(aDados[nI,nCampos])
						cFilAnt := aDados[nI,nCampos]
					ENDIF
					aAdd(aExecAuto ,{Upper(aCampos[nCampos]), 	aDados[nI,nCampos] 	,Nil})
				Else
					IF  TamSx3(Upper(aCampos[nCampos]))[3] =='N'
						aAdd(aExecAuto ,{Upper(aCampos[nCampos]), Val(StrTran(aDados[nI][nCampos],",",".")) 	,Nil})
					ELSEIF TamSx3(Upper(aCampos[nCampos]))[3] =='D'
						aAdd(aExecAuto ,{Upper(aCampos[nCampos]),  CTOD(aDados[nI,nCampos] )	,Nil})
					ELSE
						aAdd(aExecAuto ,{Upper(aCampos[nCampos]),  Substr(AllTrim(aDados[nI,nCampos]),1,TamSX3(aCampos[nCampos])[1]) 	,Nil})
						// aAdd(aExecAuto ,{Upper(aCampos[nCampos]),  Substr(AllTrim(aDados[nI,nCampos]),1,TamSX3(aCampos[nCampos])[1]) ,TamSX3(aCampos[nCampos])[1] 	,Nil})
					ENDIF
				ENDIF
			Next nCampos
			lMsErroAuto := .F.
			IF cTipo == 'B1'       // Produto
				DbSelectArea("SB1")
				//SB1->(dbSetOrder(1))
				If DbSeek(xFilial("SB1")+aDados[nI][1],.T.)
					MSExecAuto({|x,y| MATA010(x,y)},aExecAuto,4)
				Else
					MSExecAuto({|x,y| MATA010(x,y)},aExecAuto,3)
				EndIf
				If lMsErroAuto
					//-- Reporta o erro retornado pela rotina automatica:
					cArqErrAuto := NomeAutoLog()
					cErrAuto    := Memoread(cArqErrAuto)
					Ferase(cArqErrAuto)
					UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero(nLinha, 5) + '] INCONSISTENCIA NA IMPORTACAO DOS DADOS. DETALHE DO ERRO: ' + Chr(13) + Chr(10) + cErrAuto + Chr(13) + Chr(10))
				Else
					UpdFileLog(nHdlLog, '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero(nLinha, 5) + '] IMPORTADA COM SUCESSO!' + Chr(13) + Chr(10))
				EndIf
			ELSEIF cTipo == 'A2'   // Fornecedor
				DbSelectArea("SA2")
				If DbSeek(xFilial("SA2")+aDados[nI][1]+aDados[nI][2],.T.)
					MSExecAuto({|x,y| MATA020(x,y)},aExecAuto,4)
				Else
					MSExecAuto({|x,y| MATA020(x,y)},aExecAuto,3)
				EndIf

				If lMsErroAuto
					//-- Reporta o erro retornado pela rotina automatica:
					cArqErrAuto := NomeAutoLog()
					cErrAuto    := Memoread(cArqErrAuto)
					Ferase(cArqErrAuto)
					UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero(nLinha, 5) + '] INCONSISTENCIA NA IMPORTACAO DOS DADOS. DETALHE DO ERRO: ' + Chr(13) + Chr(10) + cErrAuto + Chr(13) + Chr(10))
				Else
					UpdFileLog(nHdlLog, '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero(nLinha, 5) + '] IMPORTADA COM SUCESSO!' + Chr(13) + Chr(10))
				EndIf
			ELSEIF cTipo == 'A4'   // TRANSPORTADORA
				DbSelectArea("SA4")
				If DbSeek(xFilial("SA4")+aDados[nI][1],.T.)
					MSExecAuto({|x,y| MATA050(x,y)},aExecAuto,4)
				Else
					MSExecAuto({|x,y| MATA050(x,y)},aExecAuto,3)
				EndIf

				If lMsErroAuto
					//-- Reporta o erro retornado pela rotina automatica:
					cArqErrAuto := NomeAutoLog()
					cErrAuto    := Memoread(cArqErrAuto)
					Ferase(cArqErrAuto)
					UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero(nLinha, 5) + '] INCONSISTENCIA NA IMPORTACAO DOS DADOS. DETALHE DO ERRO: ' + Chr(13) + Chr(10) + cErrAuto + Chr(13) + Chr(10))
				Else
					UpdFileLog(nHdlLog, '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero(nLinha, 5) + '] IMPORTADA COM SUCESSO!' + Chr(13) + Chr(10))
				EndIf
			ELSEIF cTipo == 'A1'   //Cliente
				DbSelectArea("SA1")
				If DbSeek(xFilial("SA1")+aDados[nI][1]+aDados[nI][2],.T.)
					MSExecAuto({|x,y| MATA030(x,y)},aExecAuto,3)
				Else
					MSExecAuto({|x,y| MATA030(x,y)},aExecAuto,3)
				EndIf
				If lMsErroAuto
					//-- Reporta o erro retornado pela rotina automatica:
					cArqErrAuto := NomeAutoLog()
					cErrAuto    := Memoread(cArqErrAuto)
					Ferase(cArqErrAuto)
					UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero(nLinha, 5) + '] INCONSISTENCIA NA IMPORTACAO DOS DADOS. DETALHE DO ERRO: ' + Chr(13) + Chr(10) + cErrAuto + Chr(13) + Chr(10))
				Else
					UpdFileLog(nHdlLog, '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero(nLinha, 5) + '] IMPORTADA COM SUCESSO!' + Chr(13) + Chr(10))
				EndIf
			ELSEIF cTipo == 'B9'   // Saldo de Estoque
				MSExecAuto({|x,y| MATA220(x,y)}, aExecAuto, 3)
				If lMsErroAuto
					//-- Reporta o erro retornado pela rotina automatica:
					cArqErrAuto := NomeAutoLog()
					cErrAuto    := Memoread(cArqErrAuto)
					Ferase(cArqErrAuto)
					UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero(nLinha, 5) + '] INCONSISTENCIA NA IMPORTACAO DOS DADOS. DETALHE DO ERRO: ' + Chr(13) + Chr(10) + cErrAuto + Chr(13) + Chr(10))
				Else
					UpdFileLog(nHdlLog, '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero(nLinha, 5) + '] IMPORTADA COM SUCESSO!' + Chr(13) + Chr(10))
				EndIf
			ELSEIF cTipo == 'E2'   // Pagar

				MSExecAuto({|x,y| FINA050(x,y)},aExecAuto,3)
				If lMsErroAuto
					//-- Reporta o erro retornado pela rotina automatica:
					cArqErrAuto := NomeAutoLog()
					cErrAuto    := Memoread(cArqErrAuto)
					Ferase(cArqErrAuto)
					UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero(nLinha, 5) + '] INCONSISTENCIA NA IMPORTACAO DOS DADOS. DETALHE DO ERRO: ' + Chr(13) + Chr(10) + cErrAuto + Chr(13) + Chr(10))
				Else
					UpdFileLog(nHdlLog, '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero(nLinha, 5) + '] IMPORTADA COM SUCESSO!' + Chr(13) + Chr(10))
				EndIf
			ELSEIF cTipo == 'E1'   // Receber
				SE1->(dbSetOrder(1))
				If SE1->(dbSeek(AEXECAUTO[1][2]+AEXECAUTO[2][2]+AEXECAUTO[3][2]+padr(AEXECAUTO[4][2],2)+AEXECAUTO[5][2]))
					UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero(nLinha, 5) + '] INCONSISTENCIA NA IMPORTACAO DOS DADOS.: TITULO DUPLICADO ' + Chr(13) + Chr(10) )
				Else

					MSExecAuto({|x,y| FINA040(x,y)},aExecAuto,3)
					If lMsErroAuto
						//-- Reporta o erro retornado pela rotina automatica:
						cArqErrAuto := NomeAutoLog()
						cErrAuto    := Memoread(cArqErrAuto)
						Ferase(cArqErrAuto)
						UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero(nLinha, 5) + '] INCONSISTENCIA NA IMPORTACAO DOS DADOS. DETALHE DO ERRO: ' + Chr(13) + Chr(10) + cErrAuto + Chr(13) + Chr(10))
					Else
						UpdFileLog(nHdlLog, '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero(nLinha, 5) + '] IMPORTADA COM SUCESSO!' + Chr(13) + Chr(10))
					EndIf

				EndIf
			ELSEIF cTipo == 'D5'   // Lotes Saldo
				MSExecAuto({|x,y| Mata390(x,y)},aExecAuto,3)
				If lMsErroAuto
					//-- Reporta o erro retornado pela rotina automatica:
					cArqErrAuto := NomeAutoLog()
					cErrAuto    := Memoread(cArqErrAuto)
					Ferase(cArqErrAuto)
					UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero(nLinha, 5) + '] INCONSISTENCIA NA IMPORTACAO DOS DADOS. DETALHE DO ERRO: ' + Chr(13) + Chr(10) + cErrAuto + Chr(13) + Chr(10))
				Else
					UpdFileLog(nHdlLog, '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero(nLinha, 5) + '] IMPORTADA COM SUCESSO!' + Chr(13) + Chr(10))
				EndIf
			EndIf

		ElseIf nEscolha == 9
			aCampit:= {}
			aCab:= {}
			aItem:= {}
			For nCampos := 1 To Len(aCampos)
				IF SUBSTR(Upper(aCampos[nCampos]),4,6)=='FILIAL'
					cFilAnt := aDados[nI][nCampos]
				EndIf
				IF SUBSTR(Upper(aCampos[nCampos]),4,6)=='CHAPA'
					cChapa := aDados[nI][nCampos]
				EndIf
				If Substr(aCampos[nCampos],1,2) == "N1"
					If TamSx3(Upper(aCampos[nCampos]))[3] =='N'
						aadd(aCab,{ aCampos[nCampos]	,Val(StrTran(aDados[nI][nCampos],",",".")) 		, NIL})
					ElseIf TamSx3(Upper(aCampos[nCampos]))[3] =='D'
						aadd(aCab,{ aCampos[nCampos]	,CtoD(aDados[nI][nCampos])		, NIL})
					Else
						aadd(aCab,{ aCampos[nCampos]	,aDados[nI][nCampos]		, NIL})
					EndIf
				Else
					If TamSx3(Upper(aCampos[nCampos]))[3] =='N'
						aadd(aItem,{ aCampos[nCampos]	,Val(StrTran(aDados[nI][nCampos],",",".")) 		, NIL})
					ElseIf TamSx3(Upper(aCampos[nCampos]))[3] =='D'
						aadd(aItem,{ aCampos[nCampos]	,CtoD(aDados[nI][nCampos])		, NIL})
					Else
						aadd(aItem,{ aCampos[nCampos]	,aDados[nI][nCampos]		, NIL})
					EndIf
					aadd(aCampit,aCampos[nCampos])
				EndIf
			Next
			aItens := {}     //N3_FILIAL	N3_CBASE	N3_ITEM	N3_TIPO	N3_SEQ	N3_HISTOR	N3_CCONTAB	N3_CUSTBEM	N3_CDEPREC	N3_CCUSTO	N3_CCDEPR	N3_DINDEPR	N3_AQUISIC	N3_VORIG1	N3_TXDEPR1	N3_TXDEPR2	N3_TXDEPR3	N3_TXDEPR4	N3_TXDEPR5	N3_VRDACM1	N3_SUBCCON	N3_CLVLCON
			aadd(aItens,{{aCampit[1]		,aItem[1][2]         				, NIL},; //N3_FILIAL
			{ aCampit[2] 		,aItem[2][2] 		    			, NIL},; //N3_CBASE
			{ aCampit[3]  		,aItem[3][2]    					, NIL},; //N3_ITEM
			{ aCampit[4]   		,aItem[4][2] 						, NIL},; //N3_TIPO
			{ aCampit[5]   		,aItem[5][2] 						, NIL},; //N3_HISTOR
			{ aCampit[6]   		,aItem[6][2] 						, NIL},; //N3_TPSALDO
			{ aCampit[7]   		,aItem[7][2] 						, NIL},; //N3_TPDEPR
			{ aCampit[8]   		,aItem[8][2] 						, NIL},; //N3_CCONTAB
			{ aCampit[9]   	    ,aItem[9][2] 						, NIL},; //N3_CUSTBEM
			{ aCampit[10]   	,aItem[10][2] 						, NIL},; //N3_CDEPREC
			{ aCampit[11]   	,aItem[11][2] 						, NIL},; //N3_CCUSTO
			{ aCampit[12]   	,aItem[12][2] 						, NIL},; //N3_CCDEPR
			{ aCampit[13]   	,aItem[13][2] 						, NIL},; //N3_DINDEPR // errada
			{ aCampit[14]   	,aItem[14][2] 						, NIL},; //N3_VORIG1
			{ aCampit[15]   	,aItem[15][2] 						, NIL},; //N3_TXDEPR1
			{ aCampit[16]   	,aItem[16][2] 						, NIL},; //N3_VRDACM1
			{ aCampit[17]   	,aItem[17][2] 						, NIL},; //N3_VORIG2
			{ aCampit[18]   	,aItem[18][2] 						, NIL},; //N3_TXDEPR2
			{ aCampit[19]   	,aItem[19][2] 						, NIL},; //N3_VRDACM2
			{ aCampit[20]  		,aItem[20][2]						, NIL},; //N3_VRDACM2
			{ aCampit[21]  		,aItem[21][2]						, NIL}}) //N3_FILORIG

			lMsErroAuto := .F.
			If !Empty(ACAB[1][2])
				//Verifica se ja existe
				cQuery := " SELECT N1_CHAPA AS CHAPA "
				cQuery += " FROM  "+RetSqlName("SN1")
				cQuery += " WHERE D_E_L_E_T_ = '' "
				cQuery += " AND N1_CHAPA = '"+cChapa+"' "
				cQuery += "	AND N1_FILIAL = '"+cFilAnt+"' "

				IF SELECT("cQuery") > 0
					cQuery->(DbCloseArea())
				ENDIF

				TcQuery cQuery New Alias "cQuery"
				DbSelectArea("cQuery")
				cQuery->(DbGoTop())
				nSeq := 1
				If  cQuery->(Eof())
					MsExecAuto({|x,y,z| ATFA012(x,y,z)}, aCab, aItens, 3)
					If lMsErroAuto
						//-- Reporta o erro retornado pela rotina automatica:
						cArqErrAuto := NomeAutoLog()
						cErrAuto    := Memoread(cArqErrAuto)
						Ferase(cArqErrAuto)
						UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero(nLinha, 5) + '] INCONSISTENCIA NA IMPORTACAO DOS DADOS. DETALHE DO ERRO: ' + Chr(13) + Chr(10) + cErrAuto + Chr(13) + Chr(10))
					Else
						UpdFileLog(nHdlLog, '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero(nLinha, 5) + '] IMPORTADA COM SUCESSO!' + Chr(13) + Chr(10))
					EndIf
				Else
					nSeq ++
					nSeq:= StrZero(nSeq,3)
					dbSelectArea("SN3")
					RecLock("SN3",.T.)
					SN3->N3_FILIAL      := aItem[1][2]
					SN3->N3_CBASE       := aItem[2][2]
					SN3->N3_ITEM        := Strzero(Val(aItem[3][2]),TamSx3("N3_ITEM")[1])
					SN3->N3_TIPO	    := aItem[4][2]
					SN3->N3_HISTOR      := aItem[5][2]
					SN3->N3_CCONTAB     := aItem[6][2]
					SN3->N3_CUSTBEM     := aItem[7][2]
					SN3->N3_CDEPREC     := aItem[8][2]
					SN3->N3_CCUSTO 	    := aItem[9][2]
					SN3->N3_CCDEPR      := aItem[10][2]
					SN3->N3_DINDEPR     := aItem[11][2]
					SN3->N3_AQUISIC     := aItem[12][2]
					SN3->N3_VORIG1      := aItem[13][2]
					SN3->N3_TXDEPR1     := aItem[14][2]
					SN3->N3_TXDEPR2     := aItem[15][2]
					SN3->N3_TXDEPR3     := aItem[16][2]
					SN3->N3_TXDEPR4     := aItem[17][2]
					SN3->N3_TXDEPR5     := aItem[18][2]
					SN3->N3_VRDACM1     := aItem[19][2]
					SN3->N3_SUBCCON     := aItem[20][2]
					SN3->N3_CLVLCON     := aItem[21][2]
					SN3->N3_TPSALDO		:= aItem[22][2]
					SN3->N3_TPDEPR		:= aItem[23][2]
					SN3->N3_BAIXA		:= aItem[24][2]
					SN3->N3_CALCDEP		:= aItem[25][2]
					SN3->N3_FILORIG		:= aItem[26][2]
					SN3->N3_RATEIO		:= "2"
					SN3->N3_INTP		:= "2"
					SN3->N3_ATFCPR		:= "2"
					SN3->N3_SEQ			:= nSeq
					SN3->(MsUnlock())
					UpdFileLog(nHdlLog, '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero(nLinha, 5) + '] IMPORTADA COM SUCESSO!' + Chr(13) + Chr(10))

				/*dbSelectArea("SN3")
				RecLock("SN3",.T.)
					SN3->N3_FILIAL      := aItem[1][2]
					SN3->N3_CBASE       := aItem[2][2]
					SN3->N3_ITEM        := aItem[3][2]
					SN3->N3_TIPO	    := aItem[4][2]
					SN3->N3_HISTOR      := aItem[5][2]
					SN3->N3_CCONTAB     := aItem[6][2]
					SN3->N3_CUSTBEM     := aItem[7][2]
					SN3->N3_CDEPREC     := aItem[8][2]
					SN3->N3_CCUSTO 	    := aItem[9][2]
					SN3->N3_CCDEPR      := aItem[10][2]
					SN3->N3_DINDEPR     := aItem[11][2]
					SN3->N3_AQUISIC     := aItem[12][2]
					SN3->N3_VORIG1      := aItem[13][2]
					SN3->N3_TXDEPR1     := aItem[14][2]
					SN3->N3_TXDEPR2     := aItem[15][2]
					SN3->N3_TXDEPR3     := aItem[16][2]
					SN3->N3_TXDEPR4     := aItem[17][2]
					SN3->N3_TXDEPR5     := aItem[18][2]
					SN3->N3_VRDACM1     := aItem[9][2]       			
					SN3->N3_SUBCCON     := aItem[20][2]
					SN3->N3_CLVLCON     := aItem[21][2]*/
			Endif	
		EndIf	
	ElseIf nEscolha == 8 
		aExecAuto :={}
		For nCampos := 1 To Len(aCampos)
			IF  SUBSTR(Upper(aCampos[nCampos]),4,6)=='FILIAL'
				IF !EMpty(aDados[nI,nCampos])
					cFilAnt := aDados[nI,nCampos]
				ENDIF
			Else
				IF SUBSTR(Upper(aCampos[nCampos]),1,2)=='C6'
					IF  TamSx3(Upper(aCampos[nCampos]))[3] =='N'
						aAdd(aExecAuto ,{Upper(aCampos[nCampos]), 	VAL(aDados[nI,nCampos] )	,Nil})
					ELSEIF TamSx3(Upper(aCampos[nCampos]))[3] =='D'
						aAdd(aExecAuto ,{Upper(aCampos[nCampos]),  CTOD(aDados[nI,nCampos] )	,Nil})
					ELSE
						aAdd(aExecAuto ,{Upper(aCampos[nCampos]), 	aDados[nI,nCampos] 	,Nil})
					ENDIF
				EndIF
			ENDIF
		Next nCampos
		IF cPedido == aDados[nI,01]
			aAdd(aItem,aExecAuto)
		Else
			lMsErroAuto := .F.
				MATA410(aCab,aItem,3)
				If lMsErroAuto
					DisarmTransaction()
					MostraErro()
					cFilAnt := cBKFilial
					Return
				EndIF
			cPedido :=  aDados[nI,01]
			aCab      := {}
			aItem     := {}
			For nCampos := 1 To Len(aCampos)
				IF  SUBSTR(Upper(aCampos[nCampos]),4,6)=='FILIAL'
					IF !EMpty(aDados[nI,nCampos])
						cFilAnt := aDados[nI,nCampos]
					ENDIF
				Else
					IF SUBSTR(Upper(aCampos[nCampos]),1,2)='C5'
						IF  TamSx3(Upper(aCampos[nCampos]))[3] =='N'
							aAdd(aCab ,{Upper(aCampos[nCampos]), 	VAL(aDados[nI,nCampos] )	,Nil})
						ELSEIF TamSx3(Upper(aCampos[nCampos]))[3] =='D'
							aAdd(aCab ,{Upper(aCampos[nCampos]),  CTOD(aDados[nI,nCampos] )	,Nil})
						ELSE
							aAdd(aCab ,{Upper(aCampos[nCampos]), 	aDados[nI,nCampos] 	,Nil})
						ENDIF
					EndIF
				ENDIF
				
			Next nCampos
			aAdd(aItem,aExecAuto)
		EndIF
		IF nI == Len(aDados)
			lMsErroAuto := .F.
				MATA410(aCab,aItem,3)
				If lMsErroAuto
					DisarmTransaction()
					MostraErro()
					cFilAnt := cBKFilial
					Return
				EndIF
			
		EndIF
	EndIF
Next nI
//End Transaction
//msgAlert('Arquivo importado com sucesso !!')

//--Atualiza arquivo de LOG:
UpdFileLog(nHdlLog, '[' + DtoC(Date()) + ' - ' + Time() + '] FIM DO PROCESSO DE IMPORTACAO' + Chr(13) + Chr(10))
//--Exibe LOG de processamento:
FClose(nHdlLog)		
ShowLog(cFileLog)
	
FT_FUSE()            

cFilAnt := cBKFilial

Return

Static Function UpdFileLog(nHdlLog, cMsg)
FWrite(nHdlLog, cMsg)
Return Nil

Static Function ShowLog(cFileLog)
Local oDlg     := NIL
Local oFont    := NIL
Local cMemo    := ''
Local oMemo    := NIL

cMemo := MemoRead(cFileLog)
DEFINE FONT oFont NAME "Courier New" SIZE 5,0
DEFINE MSDIALOG oDlg TITLE 'LOG' From 3,0 to 340,617 PIXEL
	@ 5,5 GET oMemo  VAR cMemo MEMO SIZE 300,145 OF oDlg PIXEL 
	oMemo:bRClicked := {|| AllwaysTrue()}
	oMemo:oFont:=oFont
	DEFINE SBUTTON  FROM 153,280 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg PIXEL //Apaga
ACTIVATE MSDIALOG oDlg CENTER
Return Nil


//Bibliotecas
#Include "Protheus.ch"
 
/*/{Protheus.doc} zLimpaEsp
Função que limpa os caracteres especiais dentro de um campo
@type function
@author Atilio / Achoa
@since 25/04/2016
@version 1.0
@param lEndereco, Lógico, Define se o campo é endereço (caso sim, o traço e vírgula serão ignorados)
    @example
    u_zLimpaEsp()
/*/
 
User Function zLimpaEsp(cLinha)
    Local aArea       := GetArea()
    Local cLinhanov   := cLinha
    Default lEndereco := .F.
    //Retirando caracteres
    cLinhanov := StrTran(cLinhanov, "'", "")
	cLinhanov := StrTran(cLinhanov, "-", "")
    cLinhanov := StrTran(cLinhanov, "#", "")
    cLinhanov := StrTran(cLinhanov, "%", "")
    cLinhanov := StrTran(cLinhanov, "*", "")
    cLinhanov := StrTran(cLinhanov, "&", "E")
    cLinhanov := StrTran(cLinhanov, ">", "")
    cLinhanov := StrTran(cLinhanov, "<", "")
    cLinhanov := StrTran(cLinhanov, "!", "")
    cLinhanov := StrTran(cLinhanov, "@", "")
    cLinhanov := StrTran(cLinhanov, "$", "")
    cLinhanov := StrTran(cLinhanov, "(", "")
    cLinhanov := StrTran(cLinhanov, ")", "")
    cLinhanov := StrTran(cLinhanov, "_", "")
    cLinhanov := StrTran(cLinhanov, "=", "")
    cLinhanov := StrTran(cLinhanov, "+", "")
    cLinhanov := StrTran(cLinhanov, "{", "")
    cLinhanov := StrTran(cLinhanov, "}", "")
    cLinhanov := StrTran(cLinhanov, "[", "")
    cLinhanov := StrTran(cLinhanov, "]", "")
    cLinhanov := StrTran(cLinhanov, "/", "")
    cLinhanov := StrTran(cLinhanov, "?", "")
    cLinhanov := StrTran(cLinhanov, ".", "")
    cLinhanov := StrTran(cLinhanov, "\", "")
    cLinhanov := StrTran(cLinhanov, "|", "")
    cLinhanov := StrTran(cLinhanov, ":", "")
    cLinhanov := StrTran(cLinhanov, '"', '')
    cLinhanov := StrTran(cLinhanov, '°', '')
    cLinhanov := StrTran(cLinhanov, 'ª', '')

    RestArea(aArea)

Return (cLinhanov)
 