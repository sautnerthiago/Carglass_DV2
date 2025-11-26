#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'APWIZARD.CH'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA  ³ImportCSV ³Autor  ³FELIPE NUNES DE TOLEDO ³Data  ³ 28.Mai.11³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRICAO ³Programa para importacao/carga de dados com base em arquivo ³±±
±±³          ³(.CSV)                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function ImpCSV002() 
	Local oWizard    := NIL
	Local lFinish    := .F.
	Local cHeader    := ''
	Local cMessage   := ''
	Local cText      := ''
	Local cTitleProg := 'TOTVS ImpCSV001 1.0'

	Local cFileImp   := Space(100)
	Local oFileCSV   := Nil
	Local cTextP2    := ''
	Local oTextP2    := Nil

	Local cNameFunc  := Space(100)
	Local oNameFunc  := Nil
	Local cTextP3    := ''
	Local oTextP3    := Nil

	Local nTipoData  := 1
	Local lNoAcento  := .T.
	Local oNoAcento  := Nil
	Local lOrdVetX3  := .T.
	Local oOrdVetX3  := .T.

	Local cFileLog   := ''
/*
	Local aHardLock  := {}  //Lista de hardlocks liberados para uso
	Local aCNPJLib   := {}  //Lista de cnpjs liberados para uso

	//HardLocks liberados para utilizar a rotina
	aAdd(aHardLock, 2100013039)  //TotvsIbirapuera

	//CNPJ's liberados para utilizar a rotina
	aAdd(aCNPJLib, "        ")  //Empresa 99-Teste
	aAdd(aCNPJLib, "20041743")  //NLMK - Cloud Totvs
	aAdd(aCNPJLib, "00610829")  //AVE e SABOR
	aAdd(aCNPJLib, "20966789")  //SOC. COM.
	aAdd(aCNPJLib, "20490214")  //COM. IMP. MUNDIAL
	aAdd(aCNPJLib, "21331902")  //COM. GERAL DE BEBIDAS
	aAdd(aCNPJLib, "08604593")  //EUROTRONICS
	aAdd(aCNPJLib, "01159496")  //SECUR
	aAdd(aCNPJLib, "00845326")  //Grupo WECKERLE - WECKERLE
	aAdd(aCNPJLib, "19860927")  //Grupo WECKERLE - LIBUS
	aAdd(aCNPJLib, "44412435")  //Grupo Tessin
	aAdd(aCNPJLib, "51366185")  //Grupo Tessin
	aAdd(aCNPJLib, "44903516")  //Grupo Tessin
	aAdd(aCNPJLib, "55131841")  //Grupo Tessin
	aAdd(aCNPJLib, "04422405")  //Grupo Tessin
	aAdd(aCNPJLib, "14626301")  //MIP Farma
	aAdd(aCNPJLib, "17489206")  //WFL Millturn
	aAdd(aCNPJLib, "01987230")  //Partagem
	aAdd(aCNPJLib, "12259957")  //Partagem
	aAdd(aCNPJLib, "07305697")  //Partagem
	aAdd(aCNPJLib, "08323866")  //Partagem
	aAdd(aCNPJLib, "12909302")  //Partagem
	aAdd(aCNPJLib, "16417318")  //Partagem
	aAdd(aCNPJLib, "16433025")  //Partagem
	aAdd(aCNPJLib, "16935523")  //Partagem
	aAdd(aCNPJLib, "17007284")  //Partagem
	aAdd(aCNPJLib, "22091324")  //Hevy



	//Valida autorização de execução
	If aScan(aHardLock, LS_GetID()) <= 0  //Verifica o hardlock
		If aScan(aCNPJLib, SubStr(SM0->M0_CGC,1,8)) <= 0  //Verifica o cnpj
			RpcClearEnv()
			DbCloseAll()
			Return
		EndIf
	EndIf
*/
	DEFINE FONT oArial10	NAME 'Arial'       WEIGHT 10
	DEFINE FONT oCouri11	NAME 'Courier New' WEIGHT 11

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³PAINEL PRINCIPAL     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cHeader  := 'ImportCSV - Importação de dados.'
	cMessage := 'Assistente para processamento'
	cText    := 'Este assistente irá auxiliá-lo na configuração dos parâmetros para realização da importação '
	cText    += 'dos dados a partir de um arquivo (.CSV). O objetivo desta aplicação é efetuar a importação '
	cText    += 'consistindo todas as validações existentes no sistema para o cadastramento da tabela.' + Chr(10)+Chr(13)
	cText    += 'Para a realização das validações o programa utilizará o recurso de rotina automática (MSExecAuto).'
	cText    += Chr(10)+Chr(13)
	cText    += Chr(10)+Chr(13)
	cText    += Chr(10)+Chr(13)
	cText    += 'Clique em "Avançar" para continuar...'

	DEFINE	WIZARD	oWizard ;
		TITLE	'ImportCSV v1.0';
		HEADER	cHeader;
		MESSAGE	cMessage;
		TEXT	cText;
		NEXT 	{|| .T.};
		FINISH 	{|| .F.}

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³PAINEL 02            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cMessage := 'Informe o local e o arquivo (.CSV) para importação dos dados...'
	CREATE	PANEL 	oWizard  ;
		HEADER 	cHeader;
		MESSAGE	cMessage;
		BACK	{|| .T.} ;
		NEXT	{|| !Empty(cFileImp) };
		FINISH	{|| .F.}

	cTextP2	:= 'Restrições do arquivo:' + Chr(10)+Chr(13)
	cTextP2	+= Chr(10)+Chr(13)
	cTextP2	+= 'a.) A 1a. linha deve conter o cabeçalho do arquivo, com os nomes exatos de cada campo da tabela, exemplo: B1_COD;B1_DESC;B1_TIPO' + Chr(10)+Chr(13)
	cTextP2	+= Chr(10)+Chr(13)
	cTextP2	+= 'b.) O tamanho da linha (Cabeçalho e Itens) não pode conter mais do que 1023 caracteres.' + Chr(10)+Chr(13)
	cTextP2	+= Chr(10)+Chr(13)
	cTextP2	+= 'c.) No conteúdo dos campos não pode haver caracteres especiais como aspas simples ou duplas ' + "(')" + '(")' + ' e ponto e vírgula (;). Isso ira ocasionar em erro na montagem do arquivo.'

	@ 012, 010 Say oTextP2 PROMPT cTextP2 Size 228, 094 Of oWizard:oMPanel[2] FONT oArial10 Pixel
	@ 085, 005 GROUP To 113, 245 PROMPT "Local e nome do arquivo:" OF oWizard:oMPanel[2] Pixel
	@ 095, 020 MsGet oFileCSV Var cFileImp Valid( If( File(cFileImp), .T., ( Alert("O arquivo informado para importação não existe!") ,.F.) ) .Or. Empty(cFileImp) ) Size 212, 010 Of oWizard:oMPanel[2] F3 "DIR" Pixel

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³PAINEL 03            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cMessage := 'Informe o nome da função para importação dos dados...'
	CREATE	PANEL 	oWizard  ;
		HEADER 	cHeader;
		MESSAGE	cMessage;
		BACK	{|| .T.} ;
		NEXT	{|| !Empty(cNameFunc) };
		FINISH	{|| .F.}

	cTextP3	:= 'Restrições da funcao:' + Chr(10)+Chr(13)
	cTextP3	+= Chr(10)+Chr(13)
	cTextP3	+= 'a.) A função a ser informada deve conter o recurso de rotina automática (MsExecAuto).' + Chr(10)+Chr(13)
	cTextP3	+= Chr(10)+Chr(13)
	cTextP3	+= 'b.) Informe apenas o nome da função, sem o parêntese, exemplo: MATA010' + Chr(10)+Chr(13)
	cTextP3	+= Chr(10)+Chr(13)
	cTextP3	+= 'c.) Utilize somente funções de cadastros ou movimentações simples, que requer apenas uma única tabela. Funções que requerem mais de uma tabela, como Nota Fiscal de Entrada, Pedido de Venda e etc, não podem ser importadas por esse programa.'

	@ 012, 010 Say oTextP3  PROMPT cTextP3 Size 228, 094 Of oWizard:oMPanel[3] FONT oArial10 Pixel
	@ 085, 005 GROUP To 113, 245 PROMPT "Digite o nome da função:" OF oWizard:oMPanel[3] PIXEL
	@ 095, 020 MsGet oNameFunc Var cNameFunc Valid( If( FindFunction(cNameFunc), .T., ( Alert("Função inválida!") ,.F.) ) .Or. Empty(cNameFunc) ) Size 212, 010 Of oWizard:oMPanel[3] Pixel

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³PAINEL 04            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cMessage := 'Informe os parâmetros para processamento...'
	CREATE	PANEL 	oWizard  ;
		HEADER 	cHeader;
		MESSAGE	cMessage;
		BACK	{|| .T.} ;
		NEXT	{|| .T. };
		FINISH	{|| .F.}

	@ 010, 005 GROUP To 055, 200 PROMPT 'Indique o formatado da data utilizada no arquivo CSV:' Of oWizard:oMPanel[4] Pixel
	@ 020, 010 Radio oTipoDia VAR nTipoData Items "1 = AAAAMMDD","2 = DD/MM/AA","3 = DD/MM/AAAA" SIZE 064, 026 Of oWizard:oMPanel[4] Color CLR_BLUE PIXEL

	@ 060, 005 GROUP To 090, 200 PROMPT 'Retira acentuação:' Of oWizard:oMPanel[4] Pixel
	@ 070, 010 CheckBox oNoAcento Var lNoAcento Prompt "Retira os acentos dos textos a serem importados" Size 140, 010 Of oWizard:oMPanel[4] Color CLR_BLUE Pixel

	//@ 095, 005 GROUP To 125, 200 PROMPT 'Ordenação dos campos:' Of oWizard:oMPanel[4] Pixel
	//@ 105, 010 CheckBox oOrdVetX3 Var lOrdVetX3 Prompt "Ordena os campos conforme o dicionários de dados" Size 140, 010 Of oWizard:oMPanel[4] Color CLR_BLUE Pixel

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³PAINEL 05            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cMessage := 'Iniciar o processamento...'
	CREATE	PANEL 	oWizard  ;
		HEADER 	cHeader;
		MESSAGE	cMessage;
		BACK	{|| .T.} ;
		NEXT	{|| .F.};
		FINISH	{|| lFinish := .T.}

	TSay():New(010, 005, {|| 'Ao término do processo será criado o arquivo de log no mesmo diretório do arquivo a ser importado. ' },;
		oWizard:oMPanel[5],, oCouri11,,,, .T.,,, 200, 50)

	TSay():New(045, 005, {|| 'Clique em "Finalizar" para encerrar o assistente e inicar o processamento...' },;
		oWizard:oMPanel[5],, oCouri11,,,, .T.,,, 200, 50)

	ACTIVATE WIZARD oWizard Center

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³INICIO DO PROCESSO DE VERIFICACAO³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lFinish
	//--PROCESSA A IMPORTACAO:
		cFileLog := SubStr(AllTrim(cFileImp), 1, At('.', AllTrim(cFileImp)) - 1) + '.LOG'

		Processa({||  ProcImp(Alltrim(cFileImp), cFileLog, Alltrim(cNameFunc),nTipoData,lNoAcento, lOrdVetX3) }, cTitleProg, 'Processando importação...')
	EndIf

Return Nil
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ProcImp   ³ Autor ³V.RASPA / FELIPE NUNES                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Processa a importacao do arquivo indicado nos parametros  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ProcImp(cFileImp, cFileLog, cNameRot, nTipoData, lNoAcento, lOrdVetX3)
	Local nHdlLog     := 0
	Local nLinha      := 0
	Local aDataCab    := ''
	Local aDataIte    := {}
	Local cBuffer     := ''
	Local aMsExcAuto  := {}
	Local bBlockAuto  := {}
	Local cArqErrAuto := ''
	Local cErrAuto    := ''
	Local nOpc        := 0
	Local nCount      := 0
	Local aMsExecAuto := {}
	Local aTamSX3     := {}
	Local xConteudo   := Nil
	Local nCntFor     := 0
	Local lChaveValidada := .F.,lVrfChave := .F., nIndex := 0, nCot := 0, cChvPesq := '', lCsvSemColunaFilial := .T.
	Private aCposKey := {}, cTabPos := ''
	Private cStructAnt := '-', aLstStruct := {} //<--- exclusivo MATA200
	Private cProdAnt:= '-', cArmazAnt := '-', aLstLotesEndr := {} // < ... exclusivo para utilizacao do MATA220

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³CRIA ARQUIVO DE LOG³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nHdlLog  := MSFCreate(cFileLog,0)
	If nHdlLog < 0
		Aviso('ATENÇÃO', 'PROBLEMAS NA CRIAÇÃO DO ARQUIVO DE LOG DE INCONSISTÊNCIAS!' + Chr(10) + Chr(13) + 'Código do erro: ' + StrZero(FError(),10), {'OK'}, 3)
	Else
	//--Atualiza arquivo de LOG:
		UpdFileLog(nHdlLog, '[' + DtoC(Date()) + ' - ' + Time() + '] INICIANDO PROCESSO DE IMPORTAÇÃO' + Chr(13) + Chr(10))

	//--Abre o arquivo e inicia a importacao:
		FT_FUse(cFileImp)
		ProcRegua(FT_FLastRec())

	//--Atualiza arquivo de LOG:
		UpdFileLog(nHdlLog, '[' + DtoC(Date()) + ' - ' + Time() + '] INICIANDO IMPORTAÇÃO DOS DADOS - ARQUIVO COM ' + StrZero(FT_FLastRec() - 1,7) + ' LINHA(S)' + Chr(13) + Chr(10))


		Do While !FT_FEof()
			nLinha++
			If nLinha == 1
		    //-- Armazena em memoria a 1a. linha (Cabecalho).
				cBuffer  := FT_FReadLn()
				aDataCab := aBIToken(cBuffer, ';',.F.)
			Else
			//-- Armazena em memoria os itens.
				cBuffer  := FT_FReadLn()
				aDataIte := aBIToken(cBuffer, ';',.F.)
				If Len(aDataIte) > 0
					If Len(aDataIte) == Len(aDataCab)
						aMsExcAuto := {}

						If ImpSaldosInicEstq (cNameRot, aDataIte,.F. )
							TrataSaldos(nHdlLog, FT_FLastRec(), nLinha, aDataIte, nTipoData)
						else

							if ImpStruct (cNameRot, aDataIte  )

								StructAtual(nHdlLog, FT_FLastRec(), nLinha, aDataIte,cArqErrAuto ,cErrAuto,nTipoData)
							else
							//--Compatibiliza os campos conforme
							//--dicionario de dados:
								For nCntFor := 1 To Len(aDataCab)
		//					    IF ImpSaldosInicEstq (cNameRot, aDataCab[nCntFor],.T.)
									If !Empty(aDataIte[nCntFor])
										aTamSX3 := TamSX3(aDataCab[nCntFor])
										If aTamSX3[3] == 'N'
											xConteudo := Val(StrTran(aDataIte[nCntFor],",","."))  //melhorar tratamento . e ,
										ElseIf aTamSX3[3] == 'D'
											If nTipoData == 1 //-- AAAAMMDD
												xConteudo := StoD( aDataIte[nCntFor] )
											Else  //-- DD/MM/AA ou DD/MM/AAAA
												xConteudo := CtoD( aDataIte[nCntFor] )
											EndIf
										ElseIf aTamSX3[3] == 'L'
											xConteudo := AllTrim(aDataIte[nCntFor]) == 'T' .Or. AllTrim(aDataIte[nCntFor]) == '.T.'
										ElseIf aTamSX3[3] == 'C'
											If lNoAcento
												xConteudo := NoAcento( PadR( AllTrim( aDataIte[nCntFor] ), aTamSX3[1] ) )
											Else
												xConteudo := PadR( AllTrim( aDataIte[nCntFor] ), aTamSX3[1] )
											EndIf
										EndIf
										AAdd(aMsExcAuto, {aDataCab[nCntFor]	,xConteudo,NIL})
									EndIf

								Next nCntFor

								//Ordena os campos do vetor conforme ordem do SX3
								//If lOrdVetX3
								//	aMsExcAuto := OrdVetX3(aMsExcAuto)
								//EndIf

								//--Determina a acao (3=Inclusao):
								nOpc := 3

								if !lVrfChave
									lChaveValidada := TrataChave(aMsExcAuto, lCsvSemColunaFilial, aDataCab)
									lVrfChave := .T.
								endif

							//--Realiza o processamento da
							//--rotina Automatica:
								lMsErroAuto := .F.

								if  lChaveValidada

									if Len(aCposKey) > 0
										if RegJaExiste (cTabPos, aMsExcAuto, lCsvSemColunaFilial)
											nOpc := 4  //se já existe então muda para ALTERAR
										endif
									endif

									If ImpInventarioEstq (cNameRot)
									//--Monta instrucao para processamento
									//--da rotina automatica:
										bBlockAuto := {|X,Y,Z| &(cNameRot)(X,Y,Z)}

										MSExecAuto(bBlockAuto, aMsExcAuto, Nil, nOpc)
									Else
									//--Monta instrucao para processamento
									//--da rotina automatica:
									/*
									  MATA010   inclui prod
									  MATA020   inclui Fornec
									  MATA030   inclui clientes
									*/
										bBlockAuto := {|X,Y| &(cNameRot)(X,Y)}

										MSExecAuto(bBlockAuto, aMsExcAuto, nOpc)
									EndIf

									If lMsErroAuto
									//-- Reporta o erro retornado pela rotina automatica:
										cArqErrAuto := NomeAutoLog()
										cErrAuto    := Memoread(cArqErrAuto)
										Ferase(cArqErrAuto)
										UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + ']' + IIF(nOpc == 3,' [INCLUSAO] ',' [ALTERACAO] ') + '[LINHA: ' + StrZero(nLinha, 5) + '] CIA NA IMPORTACAO DOS DADOS. DETALHE DO ERRO: ' + Chr(13) + Chr(10) + cErrAuto + Chr(13) + Chr(10))
									ElseINCONSISTEN
										UpdFileLog(nHdlLog, '[' + DtoC(Date()) + ' - ' + Time() + ']' + IIF(nOpc == 3,' [INCLUSAO] ',' [ALTERACAO] ') + '[LINHA: ' + StrZero(nLinha, 5) + '] IMPORTADA COM SUCESSO!' + Chr(13) + Chr(10))
									EndIf
								else
									cArqErrAuto := "O arquivo CSV deve conter também as seguintes colunas[mandatórias para o sistema]: "

									for nIndex := 1 to Len(aCposKey)
										cArqErrAuto += (AllTrim( aCposKey[nIndex] ) + " ")
									next

									cErrAuto    := Memoread(cArqErrAuto)
									Ferase(cArqErrAuto)
									UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero(nLinha, 5) + '] INCONSISTENCIA NA IMPORTACAO DOS DADOS. DETALHE DO ERRO: ' + Chr(13) + Chr(10) + cArqErrAuto + Chr(13) + Chr(10))
								endif
							endif

						endif

					Else
						UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero(nLinha, 5) + '] INCONSISTENCIA NA IMPORTACAO DOS DADOS. ESTRUTURA DO ITEM DIFERENTE DA ESTRUTURA DO CABECALHO!' + Chr(13) + Chr(10))
					EndIf

				else
					InsereStruct(3, cArqErrAuto, cErrAuto,nHdlLog, nTipoData)

				EndIf
			EndIf
			IncProc()

			FT_FSkip()
		EndDo

		if Len(aLstSTruct)> 0 .and. 'MATA200' $ Upper(AllTrim(cNameRot)) //-- Tratamento diferenciado para a rotina de importacao de estruturas
			InsereStruct(3, cArqErrAuto, cErrAuto,nHdlLog, nTipoData)
		endif

	//--Fecha arquivo utilizado para importacao:
		FT_FUse(cFileImp)

	//--Atualiza arquivo de LOG:
		UpdFileLog(nHdlLog, '[' + DtoC(Date()) + ' - ' + Time() + '] FIM DO PROCESSO DE IMPORTACAO' + Chr(13) + Chr(10))

	//--Exibe LOG de processamento:
		FClose(nHdlLog)
		ShowLog(cFileLog)
	EndIf

Return Nil
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³UpdFileLog³ Autor ³V.RASPA                ³Data  ³ 03.Jan.10³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Grava linha no arquivo de log de erro                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function UpdFileLog(nHdlLog, cMsg)
	FWrite(nHdlLog, cMsg)
Return Nil
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ShowLog   ³ Autor ³V.RASPA                ³Data  ³ 03.Jan.10³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Exibe LOG com as inconsistencias                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
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
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³NoAcento  ³Retira os acentos da string                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function NoAcento(cString)
	Local cChar  := ""
	Local nX     := 0
	Local nY     := 0
	Local cVogal := "aeiouAEIOU"
	Local cAgudo := "áéíóú"+"ÁÉÍÓÚ"
	Local cCircu := "âêîôû"+"ÂÊÎÔÛ"
	Local cTrema := "äëïöü"+"ÄËÏÖÜ"
	Local cCrase := "àèìòù"+"ÀÈÌÒÙ"
	Local cTio   := "ãõ"
	Local cCecid := "çÇ"

	For nX:= 1 To Len(cString)
		cChar:=SubStr(cString, nX, 1)
		IF cChar$cAgudo+cCircu+cTrema+cCecid+cTio+cCrase
			nY:= At(cChar,cAgudo)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
			EndIf
			nY:= At(cChar,cCircu)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
			EndIf
			nY:= At(cChar,cTrema)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
			EndIf
			nY:= At(cChar,cCrase)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
			EndIf
			nY:= At(cChar,cTio)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr("ao",nY,1))
			EndIf
			nY:= At(cChar,cCecid)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr("cC",nY,1))
			EndIf
		Endif
	Next
	For nX:=1 To Len(cString)
		cChar:=SubStr(cString, nX, 1)
		If Asc(cChar) < 32 .Or. Asc(cChar) > 123 .Or. cChar $ '&'
			cString:=StrTran(cString,cChar,".")
		Endif
	Next nX
	cString := _NoTags(cString)
Return cString
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³OrdVetX3  ³ Autor ³FELIPE NUNES DE TOLEDO ³Data  ³ 28.Mai.11³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Ordena uma vetor que sera usado no MSEXECAUTO conforme      ³±±
±±³          ³a posicao dos campos no SX3                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function OrdVetX3( aVetor, cTabela )
	Local aRet     := {}
	Local aAux     := {}
	Local nCt      := 1
	Local aArea    := GetArea()
	Local aAreaSX3 := SX3->( GetArea() )

	SX3->( dbSetOrder( 1 ) ) //-- X3_ARQUIVO + X3_ORDEM

	If cTabela == NIL
		cTabela := SubStr( aVetor[1][1], 1, At( '_', aVetor[1][1] ) - 1 )
		cTabela := IIf( Len( cTabela ) == 2, 'S' + cTabela, cTabela )
	EndIf

	SX3->( dbSeek( cTabela ) )

	While !SX3->( Eof () ) .AND. SX3->X3_ARQUIVO == cTabela
		If  ( nPos := aScan( aVetor, { |x| RTrim( SX3->X3_CAMPO ) $ RTrim( x[1] ) } ) ) <> 0
			aAdd( aAux, { StrZero( nCt, 4), aVetor[nPos] } )
			nCt++
		EndIf
		SX3->( dbSkip() )
	End

	aSort( aAux,,, { | x, y | x[1] < y[1] } )
	aEval( aAux, { | x, y | aAdd( aRet, aAux[y][2] ) } )

	RestArea( aAreaSX3 )
	RestArea( aArea )
Return aRet

//================================================================
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA  ³                    ³Autor  ³Oswaldo Leite ³Data  ³ 02-10-14³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRICAO ³ função auxiliar para importação do saldo de estq           ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//verifica se os capos chave da tabela estão no CSV
//verifica se a manutenção dada será de INCLUIR ou ALTERAR
//
//lCsvSemColunaFilial - houve instrução para criar programa desconsiderando coluna filial, como se todos os CSV´s estivessem sem esta coluna.
//                      Futuramente, ito poderá ou não ser tratado e modificado
Static Function TrataChave(aMsExcAuto, lCsvSemColunaFilial, aDataCab)
	Local  cTabEmUso, nIndex, cCampo := '', lFaltaChave := .F., nCot, cKeyTab := ''
	Local  lRet := .T.
	Local cCOnteudo := ''

	aCposKey := {}
	cTabEmUso := aMsExcAuto[1][1]

	if substr(cTabEmUso,3,1) == "_"
		cTabPos := "S" + substr(cTabEmUso,1,2)
	else
		cTabPos := substr(cTabEmUso,1,3)
	endif

	dbSelectArea( "SX2" )
	SX2-> ( dbSetOrder(1) )
	SX2->( dbSeek( cTabPos ) )
	cConteudo := FwFilial(cTabPos)

	cKeyTab := SX2->X2_UNICO

	if !EMpty(cKeyTab)
		cKeyTab := cKeyTab

		for nIndex := 1 to Len(cKeyTab)
			if substr(cKeyTab,nIndex,1) == '+'

				if lCsvSemColunaFilial
					if substr(cTabEmUso,3,1) == "_"
						if AllTrim(substr(cTabEmUso,1,3) + "FILIAL") != AllTrim(cCampo)
							aadd (aCposKey,AllTrim(cCampo))
							cCampo :=   ''
						else
							cCampo := ''
						endif
					else
						if AllTrim(substr(cTabEmUso,1,4) + "FILIAL") != AllTrim(cCampo)
							aadd (aCposKey,AllTrim(cCampo))
							cCampo := ''
						else
							cCampo := ''
						endif
					endif
				else
					aadd (aCposKey,AllTrim(cCampo))
					cCampo := ''
				endif
			else
				cCampo += substr(cKeyTab,nIndex,1)
			endif
		Next

		if lCsvSemColunaFilial
			if substr(cTabEmUso,3,1) == "_"
				if AllTrim(substr(cTabEmUso,1,3) + "FILIAL") != AllTrim(cCampo)
					aadd (aCposKey,AllTrim(cCampo))
					cCampo := ''
				else
					cCampo := ''
				endif
			else
				if AllTrim(substr(cTabEmUso,1,4) + "FILIAL") != AllTrim(cCampo)
					aadd (aCposKey,AllTrim(cCampo))
					cCampo := ''
				else
					cCampo := ''
				endif
			endif
		else
			aadd (aCposKey,AllTrim(cCampo))
			cCampo := ''
		endif

		for nCot := 1 to Len(aCposKey)
	//		nIndex := aScan( aMsExcAuto, { |x| AllTrim( x[1]) == aCposKey[nCot]  } )
			nIndex := aScan( aDataCab, { |x| AllTrim( x) == aCposKey[nCot]  } )
			if nIndex == 0 //falta campo chave no CSV
				lRet := .F.
				exit
			endif
		Next
	endif

return lRet

//==================================================================================
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA  ³   RegJaexiste      ³Autor  ³Oswaldo Leite ³Data  ³ 02-10-14³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRICAO ³ função auxiliar para importação do saldo de estq           ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static FUnction RegJaExiste(cTabela, aMsExcAuto, lCsvSemColunaFilial)
	Local lRet := .F., cQuery := ' ', cAlias := GetNextALias()
	Local nIndex, nCot

	cQuery := "SELECT  COUNT(*) COUNTREGS FROM " + RetSqlName(cTabela) + " WHERE D_E_L_E_T_ <> '*' "

	if lCsvSemColunaFilial
		if substr(cTabPos,1,1) == "S"
			cQuery += (" AND " + substr(cTabPos,2,2)  + "_FILIAL = '" + xfilial(cTabPos) + "'" )
		else
			cQuery += (" AND " + cTabPos + "_FILIAL = '" + xfilial(cTabPos) + "'" )
		endif
	endif

	for nCot := 1 to Len(aCposKey)
		nIndex := aScan( aMsExcAuto, { |x| AllTrim( x[1]) == aCposKey[nCot]  } )

	//no aCposKey temos o campo de filial mas não iremos exigir que exista a coluna filial no CSV
		if nIndex  > 0
			cQuery += (" AND " + aCposKey[nCot] + "  = '" + aMsExcAuto[nIndex][2] + "'" )

		endif
	Next

	cQuery := changequery(cQuery)

	dbUseArea( .t., "TOPCONN", TCGenQry(,,cQuery), cAlias, .f., .t. )

//verifica se o intervalo do registro atual está contido dentro de outro intervalo existente para a respectiva linha
//	if (cAlias)->( !EOF() )
		if (cAlias)->(COUNTREGS) > 0
			lRet := .T.
		endif
//	endif

	(cAlias)->( DbCloseArea() )

return lRet

//==============================================================================================================

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA  ³   TrataSaldos      ³Autor  ³Oswaldo Leite ³Data  ³ 02-10-14³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRICAO ³ função auxiliar para importação do saldo de estq           ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
/*

  PARA UTLIZAR ESTE PORGRAMA OS PARAMETROS DE RASTRO E DE ENDERÇO DO PROTHEUS DEVERÃO ESTAR LIGADOS
                                                                  C
  ESTE PROGRAMA IMPORTA PRODUTOS NAS SEGUINTES SITUAÇÕES:

  		- PRODUTO(X) SEM LOTE E SEM ENDEREÇO
  		- PRODUTO(Y) SEM LOTE E COM ENDEREÇO
  		- PRODUTO(Z) COM LOTE E SEM ENDERECO
  		- PRODUTO(W) COM LOTE E COM ENDEREÇO

O LAYOUT DO ARQUIVO CSV IMPORTADO É FIXO E DEVE SEMPRE CONTER OS SEGUINTES CAMPOS:

B9_COD	B9_LOCAL	B9_QINI	B9_QISEGUM	B9_VINI1	B9_CM1	LOTECTL	QTDE	DTVALID		LOCALIZ	QTDE
W       1  		1000	1000   		1  		5	237	200	20140801	ENDA1	49,25
W	1  		1000	1000   		1  			5  		237		200		20140801	ENDA2	25,75
W	1  		1000	1000   		1 			5 		237		200		20140801	ENDA3	125
W 	1  		1000	1000   		1 			5 		238		800		20140821	ENDA4	650
W 	1  		1000	1000   		1  			5  		238		800		20140821	ENDA5	150
Z  	1  		201	201		1  			5  		337		1  		20140801
Z 	1 		201	201		1  			5		338		100		20140821
Z 	1  		201	201		1  			5  		339		100		20140821
Y	1  		1000	1000   		1  			5			  						ENDA1	200
Y	1  		1000	1000   		1 			5			   						ENDA2	300
Y  	1  		1000	1000   		1 			5			   						ENDA3	500
X	1		3000	3000		1			2

* O PROGRAMA CONFERE SE A SOMATÓRIA DAS QTDES CONFERE COM O TOTAL DO SALDO FAZ ISTO TANTO PARA LOTES QTO PARA ENDEREÇOS

* CASO UM ENDEREÇO NÃO EXISTA NO SISTEMA O PROGRAMA CRIA ELE AUTOMATICAMENTE

* O PROGRAMA EXIGE QUE O PRODUTO INFORMADO JÁ EXISTA NO PROTHEUS

*/

Static Function TrataSaldos(nHdlLog,nUltLinha, nLinha, aRegLido, nTipoData)
	Local lInserir := .F., nCount := 1

	Private lTemLote := .F., lTemEnder := .F.
	PRIVATE aLotesIni := {}


	aRegLido[3] := STRTRAN ( aRegLido[3], ',' , "." , 1 , 1 )
	aRegLido[4] := STRTRAN ( aRegLido[4], ',' , "." , 1 , 1 )
	aRegLido[5] := STRTRAN ( aRegLido[5], ',' , "." , 1 , 1 )
	aRegLido[6] := STRTRAN ( aRegLido[6], ',' , "." , 1 , 1 )
	aRegLido[8] := STRTRAN ( aRegLido[8], ',' , "." , 1 , 1 )
	//aRegLido[11]:= STRTRAN (aRegLido[11], ',' , "." , 1 , 1 )

	if (nLinha ) > nUltLinha //leu a última linha do arquivo!

		//                      B9_COD	    B9_LOCAL	    B9_QINI	       B9_QISEGUM	     B9_VINI1	     B9_CM1	         LOTECTL	      QTDE	        DTVALID      	LOCALIZ   	QTDE
		//Aadd (aLstLotesEndr,  {aRegLido[1],aRegLido[2],Val(aRegLido[3]), Val(aRegLido[4]),Val(aRegLido[5]),Val(aRegLido[6]), aRegLido[7] ,Val(aRegLido[8]),aRegLido[9], aRegLido[10], Val(aRegLido[11]) } )
		Aadd (aLstLotesEndr,  {aRegLido[1],aRegLido[2],Val(aRegLido[3]), Val(aRegLido[4]),Val(aRegLido[5]),Val(aRegLido[6]), aRegLido[7] ,Val(aRegLido[8]),aRegLido[9], aRegLido[10] } )
		lInserir := .T.
		OrdArmaz()
		OrdLote(nTipoData)
		OrdEnder()

		if ProdOk(nHdlLog, nLinha, cProdAnt,cArmazAnt)
			if lTemLote
				IdentificaLotes(nTipoData)
			endif

			for nCount := 1 to Len(aLstLotesEndr)

				if !TemSB9(nHdlLog, nLinha, cProdAnt,cArmazAnt)
					if !ConsistCampos(nHdlLog, nLinha, cProdAnt,cArmazAnt, nCount) .or. !VrfQtdes(nHdlLog, nLinha, cProdAnt,cArmazAnt, nCount)
						lInserir := .F.
						exit
					endif
				else
					lInserir := .F.
					exit
				endif
			next

			if lInserir //varre por uma segunda vez seguro de que pode inserir no sistema
				InsTudo(nHdlLog, nLinha, nTipoData)
			endif
		endif


		//==================== RE INICIALIZAR ======================================================
		cProdAnt  := aRegLido[1]
		cArmazAnt := aRegLido[2]

		                      /*
		nCount := Len(aLstLotesEndr)
		While Len(aLstLotesEndr) > 0
	  		aDel( aLstLotesEndr , nCount)
	  		aSize(aLstLotesEndr, Len(aLstLotesEndr)-1)
	  		nCount -= 1
	 	End                 */
		aLstLotesEndr := Nil
		aLstLotesEndr := {}
		                  /*
		nCOunt := Len(aLotesIni)
		while Len(aLotesIni) > 0
			aDel( aLotesIni , nCount)
			aSize(aLotesIni, Len(aLotesIni)-1)
			nCOunt -= 1
		End             */

		aLotesIni := Nil
		aLotesIni := {}
		//============================================================================================
	else
    //ao mudar de produto tentamos inserir todos os registros lidos daquele produto de uma só vez!
    //obs.: o pré requisito é ter o CSV ordenado por produto.
		if ( cProdAnt != aRegLido[1] .or. cArmazAnt != aRegLido[2]  )  .or.   ;
				( cProdAnt == '-' .and. cArmazAnt == '-' )

			lInserir := .T.
			OrdArmaz()
			OrdLote(nTipoData)
			OrdEnder()

			if ProdOk(nHdlLog, (nLinha-1), cProdAnt,cArmazAnt)
				if lTemLote
					IdentificaLotes(nTipoData)
				endif

				for nCount := 1 to Len(aLstLotesEndr)

					if !TemSB9(nHdlLog, (nLinha-1), cProdAnt,cArmazAnt)
						if !ConsistCampos(nHdlLog, nLinha, cProdAnt,cArmazAnt, nCount)  .or. !VrfQtdes(nHdlLog, nLinha, cProdAnt,cArmazAnt, nCount)
							lInserir := .F.
							exit
						endif
					else
						lInserir := .F.
						exit
					endif
				next

				if lInserir //varre por uma segunda vez seguro de que pode inserir no sistema
					InsTudo(nHdlLog, nLinha,nTipoData)
				endif
			endif


		//==================== RE INICIALIZAR ======================================================
			cProdAnt  := aRegLido[1]
			cArmazAnt := aRegLido[2]
		                      /*
		nCount := Len(aLstLotesEndr)
		While Len(aLstLotesEndr) > 0
	  		aDel( aLstLotesEndr , nCount)
	  		aSize(aLstLotesEndr, Len(aLstLotesEndr)-1)
	  		nCount -= 1
	 	End                 */

			aLstLotesEndr := Nil
			aLstLotesEndr := {}
		                  /*
		nCOunt := Len(aLotesIni)
		while Len(aLotesIni) > 0
			aDel( aLotesIni , nCount)
			aSize(aLotesIni, Len(aLotesIni)-1)
			nCOunt -= 1
		End             */
			aLotesIni := Nil
			aLotesIni := {}
		//============================================================================================
		endif

	//                      B9_COD	    B9_LOCAL	    B9_QINI	       B9_QISEGUM	     B9_VINI1	     B9_CM1	         LOTECTL	      QTDE	        DTVALID      	LOCALIZ   	QTDE
		Aadd (aLstLotesEndr,  {aRegLido[1],aRegLido[2],Val(aRegLido[3]), Val(aRegLido[4]),Val(aRegLido[5]),Val(aRegLido[6]), aRegLido[7] ,Val(aRegLido[8]),aRegLido[9], aRegLido[10]} )

	endif

	if (nLinha + 1) > nUltLinha //ULTIMA LINHA DO ARQUIVO
		lTemLote := .F.
		lTemEnder := .F.

		lInserir := .T.
		OrdArmaz()
		OrdLote(nTipoData)
		OrdEnder()

		if ProdOk(nHdlLog, nLinha, cProdAnt,cArmazAnt)
			if lTemLote
				IdentificaLotes(nTipoData)
			endif

			for nCount := 1 to Len(aLstLotesEndr)

				if !TemSB9(nHdlLog, nLinha, cProdAnt,cArmazAnt)
					if !ConsistCampos(nHdlLog, nLinha, cProdAnt,cArmazAnt, nCount) .or. !VrfQtdes(nHdlLog, nLinha, cProdAnt,cArmazAnt, nCount)
						lInserir := .F.
						exit
					endif
				else
					lInserir := .F.
					exit
				endif
			next

			if lInserir //varre por uma segunda vez seguro de que pode inserir no sistema
				InsTudo(nHdlLog, nLinha, nTipoData)
			endif
		endif


	//==================== RE INICIALIZAR ======================================================
		cProdAnt  := aRegLido[1]
		cArmazAnt := aRegLido[2]

		aLstLotesEndr := Nil
		aLstLotesEndr := {}

		aLotesIni := Nil
		aLotesIni := {}
	ENDIF

return
//Local cAntProd := '-', cAntArmaz := '-', cAntLote := '-', cAntEnder := '-', nItem := 0

//==============================================================================================================

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA  ³  IMpSaldosInicEstq ³Autor  ³Oswaldo Leite ³Data  ³ 02-10-14³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRICAO ³ função auxiliar para importação do saldo de estq           ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
/*
  O ImportCSV() é um programa que importa planilhas CSV que podem conter um numero variavel de colunas

  Foi solicitado a criação de uma função diferenciada que importa um arquivo com qtde 'fixas' de colunas (contendo saldo, lotes e enedereços). COnforme solicitado,
  esta funcionalidade foi incorporada ao ImportCsv().

  Portanto, sempre que o usuário informar função = MATA220 executamos esta segunda funcionalidade totalmente especifica/rigida para importar saldos de estoque!

  Para quaisquer outras funções MATAXXX  executamos os trâmites normais do ImportCsv()
*/
Static Function ImpSaldosInicEstq (cNameRot,aRegLido, lFlagMATA220)
	Local lRet := .F.

	if 'MATA220' $ Upper(AllTrim(cNameRot)) //-- Tratamento diferenciado para a rotina de Saldos de estoque

		if cProdAnt == '-' .and. cArmazAnt == '-'
			cProdAnt  := aRegLido[1]
			cArmazAnt := aRegLido[2]
		endif

		lRet := .T.
	endif



return lRet
//==============================================================================================================
Static Function ImpInventarioEstq (cNameRot)
	Local lRet := .F.

	if 'MATA270' $ Upper(AllTrim(cNameRot)) //-- Tratamento diferenciado para a rotina de Inventario
		lRet := .T.
	endif

return lRet


//================================================================================
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA  ³ OrdArmaz            ³Autor  ³Oswaldo Leite ³Data  ³ 02-10-14³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRICAO ³ função auxiliar para importação do saldo de estq           ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static function OrdArmaz()
	Local  ni, nj, nw, cProd := '', cArmaz := '', cLote := '', cEnder := '', cSerieEnder := ''
	Local nQtMesIni := 0, nQt2aIni := 0, nSldMesIni := 0, nSld2aIni := 0, cSubLt := '', dDataVal := ctod('')

	for ni := 1 to Len(	aLstLotesEndr)
		for nj := ni+1 to Len(	aLstLotesEndr)
			if 	aLstLotesEndr[ni][2] > 	aLstLotesEndr[nj][2]

				cProd    := aLstLotesEndr[ni][1]
				cArmaz   := aLstLotesEndr[ni][2]
				nQtIni 	 := aLstLotesEndr[ni][3]
				nQtSegun := aLstLotesEndr[ni][4]
				nVIni    := aLstLotesEndr[ni][5]
				nCM      := aLstLotesEndr[ni][6]
				cLOte    := aLstLotesEndr[ni][7]
				nQtde    := aLstLotesEndr[ni][8]
				dDataVal := aLstLotesEndr[ni][9]
				cEnder   := aLstLotesEndr[ni][10]
				cQtEnder := aLstLotesEndr[ni][11]

			/*
			cProd    := aLstLotesEndr[ni][1]
			cArmaz   := aLstLotesEndr[ni][2]
			nQtMesIni:= aLstLotesEndr[ni][3]
			nQt2aIni := aLstLotesEndr[ni][4]
			nSldMesIni:= aLstLotesEndr[ni][5]
			nSld2aIni:= aLstLotesEndr[ni][6]
			nUnit1a  := aLstLotesEndr[ni][7]
			nUNit2a  := aLstLotesEndr[ni][8]
			cLote    := aLstLotesEndr[ni][9]
			cSubLt  := aLstLotesEndr[ni][10]
			dDataVal    := aLstLotesEndr[ni][11]
			cEnder   := aLstLotesEndr[ni][12]
			cSerieEnder   := aLstLotesEndr[ni][13]
			*/

				for nw := 1 to Len(aLstLotesEndr[ni])
					aLstLotesEndr[ni][nw] := 	aLstLotesEndr[nj][nw]
				Next
			/*
			aLstLotesEndr[nj][1] := cProd
			aLstLotesEndr[nj][2] := cArmaz
			aLstLotesEndr[nj][3] := nQtMesIni
			aLstLotesEndr[nj][4] := nQt2aIni
			aLstLotesEndr[ni][5] := nSldMesIni
			aLstLotesEndr[nj][6] := nSld2aIni
			aLstLotesEndr[nj][7] := nUnit1a
			aLstLotesEndr[nj][8] := nUNit2a
			aLstLotesEndr[nj][9] := cLote
			aLstLotesEndr[nj][10]:= cSubLt
			aLstLotesEndr[nj][11]:= dDataVal
			aLstLotesEndr[nj][12] := cEnder
			aLstLotesEndr[nj][13] := cSerieEnder
			*/

				aLstLotesEndr[nj][1] := cProd
				aLstLotesEndr[nj][2] := cArmaz
				aLstLotesEndr[nj][3] := nQtIni
				aLstLotesEndr[nj][4] := nQtSegun
				aLstLotesEndr[ni][5] := nVini
				aLstLotesEndr[nj][6] := nCM
				aLstLotesEndr[nj][7] := cLote
				aLstLotesEndr[nj][8] := nQtde
				aLstLotesEndr[nj][9] := dDataVal
				aLstLotesEndr[nj][10]:= cEnder
				aLstLotesEndr[nj][11]:= cQtEnder

			endif
		next
	Next

return

//================================================================================

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA  ³  OrdLote            ³Autor  ³Oswaldo Leite ³Data  ³ 02-10-14³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRICAO ³ função auxiliar para importação do saldo de estq           ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static function OrdLote(nTipoData)
	Local  ni, nj, nw, cProd := '', cArmaz := '', cLote := '', cEnder := '', cSerieEnder := ''
	Local nQtMesIni := 0, nQt2aIni := 0, nSldMesIni := 0, nSld2aIni := 0, cSubLt := '', dDataVal := ctod('')

	for ni := 1 to Len(	aLstLotesEndr)
		for nj := ni+1 to Len(	aLstLotesEndr)
			if 	aLstLotesEndr[ni][9] > 	aLstLotesEndr[nj][9]  .and. aLstLotesEndr[ni][1] ==	aLstLotesEndr[nj][1] .and. aLstLotesEndr[ni][2] ==	aLstLotesEndr[nj][2]

				cProd    := aLstLotesEndr[ni][1]
				cArmaz   := aLstLotesEndr[ni][2]
				nQtIni 	 := aLstLotesEndr[ni][3]
				nQtSegun := aLstLotesEndr[ni][4]
				nVIni    := aLstLotesEndr[ni][5]
				nCM      := aLstLotesEndr[ni][6]
				cLOte    := aLstLotesEndr[ni][7]
				nQtde    := aLstLotesEndr[ni][8]
				dDataVal := aLstLotesEndr[ni][9]
				cEnder   := aLstLotesEndr[ni][10]
				cQtEnder := aLstLotesEndr[ni][11]

			/*
			cProd    := aLstLotesEndr[ni][1]
			cArmaz   := aLstLotesEndr[ni][2]
			nQtMesIni:= aLstLotesEndr[ni][3]
			nQt2aIni := aLstLotesEndr[ni][4]
			nSldMesIni:= aLstLotesEndr[ni][5]
			nSld2aIni:= aLstLotesEndr[ni][6]
			nUnit1a  := aLstLotesEndr[ni][7]
			nUNit2a  := aLstLotesEndr[ni][8]
			cLote    := aLstLotesEndr[ni][9]
			cSubLt  := aLstLotesEndr[ni][10]
			dDataVal    := aLstLotesEndr[ni][11]
			cEnder   := aLstLotesEndr[ni][12]
			cSerieEnder   := aLstLotesEndr[ni][13]
			*/

				for nw := 1 to Len(aLstLotesEndr[ni])
					aLstLotesEndr[ni][nw] := 	aLstLotesEndr[nj][nw]
				Next
			/*
			aLstLotesEndr[nj][1] := cProd
			aLstLotesEndr[nj][2] := cArmaz
			aLstLotesEndr[nj][3] := nQtMesIni
			aLstLotesEndr[nj][4] := nQt2aIni
			aLstLotesEndr[ni][5] := nSldMesIni
			aLstLotesEndr[nj][6] := nSld2aIni
			aLstLotesEndr[nj][7] := nUnit1a
			aLstLotesEndr[nj][8] := nUNit2a
			aLstLotesEndr[nj][9] := cLote
			aLstLotesEndr[nj][10]:= cSubLt
			aLstLotesEndr[nj][11]:= dDataVal
			aLstLotesEndr[nj][12] := cEnder
			aLstLotesEndr[nj][13] := cSerieEnder
			*/

				aLstLotesEndr[nj][1] := cProd
				aLstLotesEndr[nj][2] := cArmaz
				aLstLotesEndr[nj][3] := nQtIni
				aLstLotesEndr[nj][4] := nQtSegun
				aLstLotesEndr[ni][5] := nVini
				aLstLotesEndr[nj][6] := nCM
				aLstLotesEndr[nj][7] := cLote
				aLstLotesEndr[nj][8] := nQtde
				aLstLotesEndr[nj][9] := dDataVal
				aLstLotesEndr[nj][10]:= cEnder
				aLstLotesEndr[nj][11]:= cQtEnder

			endif
		next
	Next



return
//================================================================================
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA  ³  OrdEnder          ³Autor  ³Oswaldo Leite ³Data  ³ 02-10-14³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRICAO ³ função auxiliar para importação do saldo de estq           ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static function OrdEnder()
	Local  ni, nj, nw, cProd := '', cArmaz := '', cLote := '', cEnder := '', cQtEnder := ''
	Local  cSubLt := '', dDataVal := ctod('')
	Local  nQtIni := 0, nQtSegun := 0, nVIni := 0, nCM := 0, nQtde := 0

	for ni := 1 to Len(	aLstLotesEndr)
		for nj := ni+1 to Len(	aLstLotesEndr)
			if 	aLstLotesEndr[ni][10] > aLstLotesEndr[nj][10] .AND. ;
					aLstLotesEndr[ni][7] == aLstLotesEndr[nj][7]  .and. aLstLotesEndr[ni][1] ==	aLstLotesEndr[nj][1] .and. aLstLotesEndr[ni][2] ==	aLstLotesEndr[nj][2]

				cProd     := aLstLotesEndr[ni][1]
				cArmaz    := aLstLotesEndr[ni][2]
				nQtIni := aLstLotesEndr[ni][3]
				nQtSegun  := aLstLotesEndr[ni][4]
				nVIni:= aLstLotesEndr[ni][5]
				nCM:= aLstLotesEndr[ni][6]
				cLOte:= aLstLotesEndr[ni][7]
				nQtde := aLstLotesEndr[ni][8]
				dDataVal    := aLstLotesEndr[ni][9]
				cEnder   := aLstLotesEndr[ni][10]
				cQtEnder   := aLstLotesEndr[ni][11]

				for nw := 1 to Len(aLstLotesEndr[ni])
					aLstLotesEndr[ni][nw] := 	aLstLotesEndr[nj][nw]
				Next

				aLstLotesEndr[nj][1] := cProd
				aLstLotesEndr[nj][2] := cArmaz
				aLstLotesEndr[nj][3] := nQtIni
				aLstLotesEndr[nj][4] := nQtSegun
				aLstLotesEndr[nj][5] := nVIni
				aLstLotesEndr[nj][6] := nCM
				aLstLotesEndr[nj][7] := cLOte
				aLstLotesEndr[nj][8] := nQtde
				aLstLotesEndr[nj][9] := dDataVal
				aLstLotesEndr[nj][10]   := cEnder
				aLstLotesEndr[nj][11] := cQtEnder
			endif
		next
	Next

return

//======================================================================================================

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA  ³ ProdOk             ³Autor  ³Oswaldo Leite ³Data  ³ 02-10-14³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRICAO ³ função auxiliar para importação do saldo de estq           ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static FUnction ProdOk(nHdlLog, nLinha, cProdAnt,cArmazAnt)
	Local cQuery := 'SELECT B1_COD, B1_LOCALIZ, B1_RASTRO, B1_LOCPAD FROM ' + RETSQLNAME('SB1') + " WHERE B1_FILIAL = '" + xfilial('SB1')+ "' and D_E_L_E_T_ <> '*' AND B1_COD = '" + cProdAnt + "'   AND B1_LOCPAD = '" + cArmazAnt + "' "
	Local cAlias := GetNextALias(),lRet := .T.

	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAlias, .T., .T.)

	if 	(cAlias)->(!Eof()) .AND.   Alltrim(	(cAlias)->(B1_COD)) == Alltrim(cProdAnt ) .and.  Alltrim((cAlias)->(B1_LOCPAD)) ==  Alltrim(cArmazAnt)
		lRet := .T.

		if (cAlias)->(B1_RASTRO) == 'L' .or. (cAlias)->(B1_RASTRO) == 'S'
			lTemLote := .T.
		endif

		if (cAlias)->(B1_LOCALIZ) == 'S'
			lTemEnder := .T.
		endif
	else
		lRet := .F.
		UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero((nLinha-1), 5) + '] INCONSISTENCIA NA IMPORTACAO DOS DADOS. PRODUTO NÃO EXISTE NO SISTEMA !' + Chr(13) + Chr(10) )
	endif

	(cAlias)->(dbCLoseArea())

return lRet

//======================================================================================================

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA  ³ ConsistCampos      ³Autor  ³Oswaldo Leite ³Data  ³ 02-10-14³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRICAO ³ função auxiliar para importação do saldo de estq           ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static FUnction ConsistCampos(nHdlLog, nLinha, cProdAnt,cArmazAnt,nCOunt )
	Local lRet := .T.

	/*
	if lTemLote  .and. EMpty(aLstLotesEndr[nCount][7])
		lRet := .F.
		UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero((nLinha-1), 5) + '] INCONSISTENCIA NA IMPORTACAO DOS DADOS. PRODUTO COM RASTRO MAS SEM LOTE INFORMADO NO CSV!' + Chr(13) + Chr(10) )
	endif

	if lTemLote  .and. EMpty(aLstLotesEndr[nCOunt][9])  .and. lRet
		lRet := .F.
		UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero((nLinha-1), 5) + '] INCONSISTENCIA NA IMPORTACAO DOS DADOS. PRODUTO COM RASTRO MAS SEM DATA DE VALIDADE INFORMADA NO CSV!' + Chr(13) + Chr(10) )
	endif

	if lTemEnder  .and. lRet .and. EMpty(aLstLotesEndr[nCOunt][10])
		lRet := .F.
		UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero((nLinha-1), 5) + '] INCONSISTENCIA NA IMPORTACAO DOS DADOS. PRODUTO UTILIZA LOCALIZAÇÃO(ENDEREÇO)! OBRIGATORIO ENDEREÇAR O PRODUTO JÁ NO PRÓPRIO CSV!' + Chr(13) + Chr(10) )
	endif

	//pré-definição deste processo
	//sub-lote e série não serão obrigatórios
	//se item trata endereço, obrigo a já endereçar para o sistema!!! Não deixo carregar sem endereçar(embora seja possível)!

	if lRet  .and. Empty(aLstLotesEndr[ncount][2]) //armazem
		lRet := .F.
		UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero((nLinha-1), 5) + '] INCONSISTENCIA NA IMPORTACAO DOS DADOS. OBRIGATORIO INFORMAR O ENDEREÇO DO PRODUTO NO CSV!' + Chr(13) + Chr(10) )
	endif

	IF lRet .and. Empty(aLstLotesEndr[ncount][3]) //.OR. Empty(aLstLotesEndr[ncount][4])  )//quantidade
		lRet := .F.
		UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero((nLinha-1), 5) + '] INCONSISTENCIA NA IMPORTACAO DOS DADOS. OBRIGATORIO INFORMAR QUANTIDADES NO CSV!' + Chr(13) + Chr(10) )
	endif

	IF lRet .and. (Empty(aLstLotesEndr[ncount][5])  ) //SALDOS
		lRet := .F.
		UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero((nLinha-1), 5) + '] INCONSISTENCIA NA IMPORTACAO DOS DADOS. OBRIGATORIO INFORMAR SALDOS NO CSV!' + Chr(13) + Chr(10) )
	endif

	IF lRet .and. (Empty(aLstLotesEndr[ncount][6])  ) //vlr.unitario
		lRet := .F.
		UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero((nLinha-1), 5) + '] INCONSISTENCIA NA IMPORTACAO DOS DADOS. OBRIGATORIO INFORMAR VALORES UNITÁRIOS NO CSV!' + Chr(13) + Chr(10) )
	endif
	*/
return lRet

//======================================================================================================
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA  ³  TemSB9                  ³Autor  ³Oswaldo Leite ³Data  ³ 02-10-14³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRICAO ³ função auxiliar para importação do saldo de estq           ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static FUnction TemSB9(nHdlLog, nLinha, cProdAnt,cArmazAnt)
	Local cQuery := " "
	Local cAlias := GetNextALias(),lRet := .F.

	cQuery := 'SELECT B9_COD, B9_LOCAL FROM ' + RETSQLNAME('SB9')+ " WHERE B9_FILIAL = '" + xfilial('SB9')+ "' and D_E_L_E_T_ <> '*' AND B9_COD = '" + cProdAnt + "' AND B9_LOCAL = '" + cArmazAnt + "' "

	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAlias, .T., .T.)

	IF 	(cAlias)->(!Eof()) .AND. 	Alltrim((cAlias)->(B9_COD)) == Alltrim(cProdAnt) .AND. 	Alltrim((cAlias)->(B9_LOCAL)) == Alltrim(cArmazAnt)
		lRet := .T.
    //CONFORME ORIENTAÇÃO, SE JÁ HOUVER SB9 ABORTA A OPERAÇÃO! NÃO IMPORTA SE USUÁRIO DESEJA INCLUIR MAIS UM LOTE OU UM ENDEREÇO!!!!!!
		UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero((nLinha-1), 5) + '] INCONSISTENCIA NA IMPORTACAO DOS DADOS. PRODUTO/ARMAZÉM JÁ EXISTE NO SISTEMA ' + Chr(13) + Chr(10) )
	ENDIF

	(cAlias)->(dbCLoseArea())

return lRet

//======================================================================================================
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA  ³ CriaEndereco       ³Autor  ³Oswaldo Leite ³Data  ³ 02-10-14³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRICAO ³ função auxiliar para importação do saldo de estq           ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CriaEndereco( nCount )
	Local cQuery := 'SELECT BE_FILIAL FROM ' + RETSQLNAME('SBE') + " WHERE BE_FILIAL = '" + xfilial('SBE')+ "' and D_E_L_E_T_ <> '*' AND BE_LOCALIZ = '" + aLstLotesEndr[nCount][10] + "' AND BE_LOCAL = '" +aLstLotesEndr[nCount][2] + "'"
	Local cAlias := GetNextALias()

	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAlias, .T., .T.)

	

	(cAlias)->(dbCLoseArea())
return

//==========================================================================

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA  ³ InsTudo            ³Autor  ³Oswaldo Leite ³Data  ³ 02-10-14³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRICAO ³ função auxiliar para importação do saldo de estq           ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static FUnction InsTudo(nHdlLog, nLinha, nTipoData)
	Local nCount := 1, nCn := 1
	Local nLtCount := 1 , aLotes := {}
	Local aItemAuto := {},lOk := .F.
	Local cAntProd := '-', cAntArmaz := '-', cAntLote := '-', cAntEnder := '-', nItem := 0
	LOCAL aLinSDB:={},aCabSDA:={}, aSldIni := {}, nInd := 0
	Local nqInit := 0, nqiSegum := 0, nVini1 := 0  , nVini2 := 0, nCM1:= 0, nCM2 := 0
	lOCAL carqerrauto:= ''
	Local aCabeAuto := {} ,aItemAuto := {} , aItemEnde := {}, aLotes := {}
	Local  cAuxFil,   cAuxPrd, cAuxLoc, dAuxDt, dAuxVaDt, cAuxLt, cAuxSubL, nAuxQt

	cAntLote  := aLstLotesEndr[nCount][9]
	cAntArmaz := aLstLotesEndr[nCount][2]

//	aCabSDA := {{"DA_PRODUTO"   ,aLstLotesEndr[nCount][1],Nil},	{"DA_LOCAL",     cAntArmaz,Nil},	{"DA_LOTECTL",   cAntLote,Nil},	{"DA_NUMSEQ",   '000001',Nil}}
	BEGIN TRANSACTION

		for nCount := 1 to Len(aLstLotesEndr)
			if lTemLote .and. lTemEnder
				CriaEndereco(nCOunt)

				nItem+=1
			endif
		Next

		nCount := 1

		if InsSaldoSB9(nHdlLog, nLinha, nTipoData)
			if InsMov390(nHdlLog, nLinha, nTipoData)
				lOk := .T.
			endif
		endif

	END TRANSACTION

	if lOk
		if lTemEnder
			InsAlocaPorEndereco( nHdlLog, nLinha)
		endif

		if lTemLote
			AjustValidade( )
		endif
	endif

return
//======================================================================================================

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA  ³ IdentificaLotes ³Autor  ³Oswaldo Leite ³Data  ³ 02-10-14³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRICAO ³ função auxiliar para importação do saldo de estq           ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//monta array de lotes existentes(já acumulada) ...ela será usada pelo MATA220 adiante!
Static Function IdentificaLotes(nTipoData)
	Local nPos := 0  , nIndex := 0, dAuxVaDt := ctod('')
	Local cLote := '', cSubLote := '', cLocal := ''

	for nIndex := 1 to Len(	aLstLotesEndr)
    /*
	nPos := aScan( aLotesIni, { |x| AllTrim( x[1] ) == Alltrim(aLstLotesEndr[nIndex][1] ) .and. ;
	                                    AllTrim( x[2] ) == Alltrim(aLstLotesEndr[nIndex][2] ) .and. ;
	                                    AllTrim( x[6] ) == Alltrim(aLstLotesEndr[nIndex][9] )  .and. ;
	                                    AllTrim( x[7] ) == Alltrim(aLstLotesEndr[nIndex][10])    } )
	  */


		nPos := aScan( aLotesIni, { |x| AllTrim( x[2][2] ) == Alltrim(aLstLotesEndr[nIndex][1] ) .and. ;
			AllTrim( x[3][2] ) == Alltrim(aLstLotesEndr[nIndex][2] ) .and. ;
			AllTrim( x[7][2] ) == Alltrim(aLstLotesEndr[nIndex][7] )  .and. ;
			AllTrim( x[8][2] ) == Alltrim(aLstLotesEndr[nIndex][7])    } )
		if nPos == 0
                                             /*
                        		aAdd(aLotesIni, { xfilial('SB8'),;
				  aLstLotesEndr[nIndex][1],; 	// Código do Produto
				  aLstLotesEndr[nIndex][2],;    // Local
				  Date(),;                      // data
				  aLstLotesEndr[nIndex][3],; 	// Quantidade
				  aLstLotesEndr[nIndex][9],; 	// Numero do lote (LOTECTL)
				  aLstLotesEndr[nIndex][10]} ) 	// Sub-lote (NUMLOTE) CARACTER
	  					                   */

			if nTipoData >= 2
				dAuxVaDt:= ctod(aLstLotesEndr[nIndex][9])
			else
				dAuxVaDt:= stod(aLstLotesEndr[nIndex][9])
			endif

			aAdd(aLotesIni, { {"D5_FILIAL"	, xfilial('SB8')			, NIL} ,;
				{"D5_PRODUTO"	, aLstLotesEndr[nIndex][1]	, NIL} ,;
				{"D5_LOCAL"		, aLstLotesEndr[nIndex][2]	, NIL} ,;
				{"D5_DATA"		, dATE()		            , NIL} ,;
				{"D5_DTVALID"	, dAuxVaDt	, NIL} ,;
				{"D5_QUANT"		, aLstLotesEndr[nIndex][3]	, NIL} ,;
				{"D5_LOTECTL"	, aLstLotesEndr[nIndex][7]	, NIL} ,;
				{"D5_NUMLOTE"	, aLstLotesEndr[nIndex][7]	, NIL} } )

		else
		//acumula qtdes
			aLotesIni[nPos][6][2] += aLstLotesEndr[nIndex][3]
//		aLotesIni[nPos][5] += aLstLotesEndr[nIndex][4]
		endif

	Next

return
//===============================================================================
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA  ³ImpStruct ³Autor  ³TOTVS                  ³Data  ³ 28.Mai.11³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRICAO ³importa estruturas da arvores de produção, SG1 do PCP       ³±±
±±³          ³(.CSV)                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpStruct (cNameRot,aRegLido)
	Local lRet := .F.

	if 'MATA200' $ Upper(AllTrim(cNameRot)) //-- Tratamento diferenciado para a rotina de importacao de estruturas

		if cStructAnt == '-'
			cStructAnt := aRegLido[1]
		endif

		lRet := .T.
	endif

return lRet
//===============================================================================
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA  ³ImpStruct ³Autor  ³TOTVS                  ³Data  ³ 28.Mai.11³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRICAO ³guarda array de todas as linhas que pertençam a uma mesma struct³±±
±±³          ³(.CSV)                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


Static Function StructAtual (nHdlLog,nUltLinha, nLinha, aRegLido, cArqErrAuto, cErrAuto,nTipoData)
	aRegLido[3] := STRTRAN ( aRegLido[3], ',' , "." , 1 , 1 )

	if AllTrim(cStructAnt) != AllTrim(aRegLido[1])
		cStructAnt := aRegLido[1]

		InsereStruct(3, cArqErrAuto, cErrAuto,nHdlLog, nTipoData)
		Aadd (aLstStruct,  {aRegLido[1],aRegLido[2], Val(aRegLido[3]), aRegLido[4],aRegLido[5], nLInha } )         //aRegLido[6],
	else

		Aadd (aLstStruct,  {aRegLido[1],aRegLido[2], Val(aRegLido[3]), aRegLido[4],aRegLido[5], nLInha} ) //aRegLido[6],

		if (nLinha + 1) > nUltLinha //leu a última linha do arquivo!
			InsereStruct(3, cArqErrAuto, cErrAuto,nHdlLog, nTipoData)
		endif
	endif

//StructAtual(nHdlLog, FT_FLastRec(), nLinha, aDataIte,cArqErrAuto ,cErrAuto,nTipoData)
//Static Function StructAtual            (nHdlLog, nUltLinha,     nLinha, aRegLido, cArqErrAuto, cErrAuto,nTipoData)
//InsereStruct(3, cArqErrAuto, cErrAuto,nHdlLog, nTipoData)

return
//===============================================================================
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA  ³InsereStruct ³Autor  ³TOTVS               ³Data  ³ 28.Mai.11³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRICAO ³Inserir estrtura lida do CSV  na tabela SG1                 ³±±
±±³          ³(.CSV)                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static FUnction InsereStruct(nOpc, cArqErrAuto, cErrAuto, nHdlLog,nTipoData)
	Local aCab  :={}
	Local aItem := {}
	Local aGets	:= {}
	Local lOK	:= .T., nCount := 1, nLinha := 0
	Local cString, cErr := '', dDt := ctod('')
	Private lMsErroAuto := .F.
	Default nOpc := 3

	for nCount := 1 to Len(aLstStruct)
		nLInha := aLstStruct[nCount][6]
//     nLInha := aLstStruct[nCount][7]
		if nCount == 1
			aCab := {	{"G1_COD"		,aLstStruct[nCount][1]			,NIL},;
				{"G1_QUANT"		,1		     		,NIL},;
				{"NIVALT"		,"S"				,NIL}} //A variavel NIVALT eh utilizada pra recalcular ou nao a estrutura


			dbSelectArea("SB1")
			dbSetOrder(1)
			If !SB1->(MsSeek(xFilial("SB1")+aLstStruct[nCount][2]))
				lOk := .F.
				cErr := "Matriz " + AllTrim(aLstStruct[nCount][2]) + "não cadastrado como Produto no Protheus!"
				exit
			EndIf

			dbselectarea('SG1')
			dbsetorder(1)
			If SG1->(MsSeek(xFilial("SG1")+aLstStruct[nCount][1]) )//		G1_FILIAL+G1_COD+G1_COMP+G1_TRT

				nOpc:= 4 //altera a estrutura existente no protheus
			endif


		endif

		dbSelectArea("SB1")
		dbSetOrder(1)
		If !SB1->(MsSeek(xFilial("SB1")+aLstStruct[nCount][2]))
			lOk := .F.
			cErr := "Componente " + AllTrim(aLstStruct[nCount][2]) + "não cadastrado como Produto no Protheus!"
			exit
		EndIf

		if aLstStruct[nCount][3] <= 0
			lOk := .F.
			cErr := "Componente " + AllTrim(aLstStruct[nCount][2]) + " : Informar a quantidade deste!"
			exit
		endif


		IF !EMPTY(aLstStruct[nCount][4]) .and.  !EMPTY(aLstStruct[nCount][5])
			if nTipoData >= 2
				if cTOD(aLstStruct[nCount][4]) > cTOD(aLstStruct[nCount][5])
					lOk := .F.
					cErr := "Componente " + AllTrim(aLstStruct[nCount][2]) + " : Intervalo de datas inválido!"
					exit
				endif
			endif

			if nTipoData == 1
				if STOD(aLstStruct[nCount][4]) > STOD(aLstStruct[nCount][5])
					lOk := .F.
					cErr := "Componente " + AllTrim(aLstStruct[nCount][2]) + " : Intervalo de datas inválido!"
					exit
				endif
			endif

		endif

		aGets := Nil
		aGets := {}
		aadd(aGets,	{"G1_COD"		,aLstStruct[nCount][1]			,NIL})
		aadd(aGets,	{"G1_COMP"		,aLstStruct[nCount][2] 			,NIL})
		aadd(aGets,	{"G1_TRT"		,Space(3)			,NIL})
		aadd(aGets,	{"G1_QUANT"		,aLstStruct[nCount][3]					,NIL})
		aadd(aGets,	{"G1_PERDA"		,0					,NIL})

		if nTipoData >= 2
			IF EMPTY(aLstStruct[nCount][4])
				aadd(aGets,	{"G1_INI"		,CTOD("01/01/01")	,NIL})
			ELSE
				aadd(aGets,	{"G1_INI"		,cTOD(aLstStruct[nCount][4])	,NIL})
			ENDIF

			IF EMPTY(aLstStruct[nCount][5])
				aadd(aGets,	{"G1_FIM"		,CTOD("31/12/49")	,NIL})
			ELSE
				aadd(aGets,	{"G1_INI"		,cTOD(aLstStruct[nCount][5])	,NIL})
			ENDIF
		else
			IF EMPTY(aLstStruct[nCount][4])
				aadd(aGets,	{"G1_INI"		,CTOD("01/01/01")	,NIL})
			ELSE
				aadd(aGets,	{"G1_INI"		,STOD(aLstStruct[nCount][4])	,NIL})
			ENDIF

			IF EMPTY(aLstStruct[nCount][5])
				aadd(aGets,	{"G1_FIM"		,CTOD("31/12/49")	,NIL})
			ELSE
				aadd(aGets,	{"G1_INI"		,STOD(aLstStruct[nCount][5])	,NIL})
			ENDIF

		endif

    //if nOpc == 3  .or. (nCount != 1 .AND. nOpc == 4 .and. alltrim(aLstStruct[nCount][6]) == "NAO") //registros que nao estao marcados para serem deletados
		aadd(aItem,aGets)
	//endif
	Next



	if Len(aCab) > 0

		if lOk
			MSExecAuto({|x,y,z| mata200(x,y,z)},aCab,aItem,nOpc) //Inclusao
		ELSE
			UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + ']' + ' [INCLUSAO] '+ '[LINHA: ' + StrZero(nLinha, 5) + '] INCONSISTENCIA NA IMPORTACAO DOS DADOS. DETALHE DO ERRO: ' + Chr(13) + Chr(10) + cErr + Chr(13) + Chr(10))
		endif
	endif

	if lMsErroAuto
		cArqErrAuto := NomeAutoLog()
		cErrAuto    := Memoread(cArqErrAuto)
		Ferase(cArqErrAuto)
		UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + ']' + ' [INCLUSAO] '+ '[LINHA: ' + StrZero(nLinha, 5) + '] INCONSISTENCIA NA IMPORTACAO DOS DADOS. DETALHE DO ERRO: ' + Chr(13) + Chr(10) + cErrAuto + Chr(13) + Chr(10))
 /*	 else

	if nOpc == 4
		for nCount := 1 to Len(aLstStruct)
//	 		if aLstStruct[nCount][7] == "SIM"
			 	dbselectarea('SG1')
				dbsetorder(1)
				If SG1->(MsSeek(xFilial("SG1")+aLstStruct[nCount][1]+aLstStruct[nCount][2]) )//		G1_FILIAL+G1_COD+G1_COMP+G1_TRT
					reclock('SG1',.F.)
					SG1->(dbDelete())
					MsUnLock()
				endif
  //	 		endif
	    Next
	endif
             */
	endif


	aLstStruct := Nil
	aLstStruct := {}
return
//======================================================================================================

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA  ³ VrfQtdes           ³Autor  ³Oswaldo Leite ³Data  ³ 02-10-14³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRICAO ³ função auxiliar para importação do saldo de estq           ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function VrfQtdes(nHdlLog, nLinha, cProdAnt,cArmazAnt,nCOunt )
	Local lRet := .T., nIndex := 0, nCount := 0
	Local nQtAux := 0, nQtAux2 := 0
/*/
	IF lTemEnder .or. lTemLote

		if  lTemLote

			if lTemEnder
				for nIndex := 1 to Len(aLotesIni) //soadmin	matória dos endereços ...aglutinado por LOTE

					nQtAux  := 0
					nQtAux2 += (aLotesIni[nIndex][6][2])

					for nCount := 1  to Len(aLstLotesEndr)

						if aLstLotesEndr[nCount][1] == aLotesIni[nIndex][2][2]  .and.  	aLstLotesEndr[nCount][2] == aLotesIni[nIndex][3][2]  ;
								.and. aLstLotesEndr[nCount][7] == aLotesIni[nIndex][7][2]
							nQtAux += (aLstLotesEndr[nCount][11]  )
						endif
					next

					if (aLotesIni[nIndex][6][2]) != (nQtAux)
						UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero( (nLinha-1), 5) + '] INCONSISTENCIA NA SOMATORIA DOS ENDEREÇOS PARA COM A QTDE TOTAL DO LOTE (' + ALLTRIM(aLstLotesEndr[nCount][7]) + '). VERIFIQUE O CSV!' + Chr(13) + Chr(10) )
						lRet := .F.
						exit
					endif

				next

				if lRet
					if (aLstLotesEndr[1][3]) !=  nQtAux2
						UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero((nLinha-1), 5) + '] INCONSISTENCIA NA SOMATORIA DOS LOTES PARA COM A QTDE TOTAL DO PRODUTO A SER IMPORTADO. VERIFIQUE O CSV!' + Chr(13) + Chr(10) )
						lRet := .F.
					endif
				endif
			else//se nao tem endereco
				nQtAux  := 0

				for nCount := 1  to Len(aLstLotesEndr)
					nQtAux += (aLstLotesEndr[nCount][8]  )
				next

				if (aLstLotesEndr[1][4]) !=  nQtAux
					UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero((nLinha-1), 5) + '] INCONSISTENCIA NA SOMATORIA DOS LOTES PARA COM A QTDE TOTAL DO PRODUTO A SER IMPORTADO. VERIFIQUE O CSV!' + Chr(13) + Chr(10) )
					lRet := .F.
				endif
			endif

		else//se tem endereco (mas nao tem lote)
			nQtAux  := 0

			for nCount := 1  to Len(aLstLotesEndr)
				nQtAux += (aLstLotesEndr[nCount][11]  )
			next

			if (aLstLotesEndr[1][4]) !=  nQtAux
				UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero((nLinha-1), 5) + '] INCONSISTENCIA NA SOMATORIA DOS ENDERECOS PARA COM A QTDE TOTAL DO PRODUTO A SER IMPORTADO. VERIFIQUE O CSV!' + Chr(13) + Chr(10) )
				lRet := .F.
			endif

		endif

	endif
/*/
return lRet

//========================================================================================

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA  ³ InsSaldoSB9        ³Autor  ³Oswaldo Leite ³Data  ³ 02-10-14³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRICAO ³ função auxiliar para importação do saldo de estq           ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//Saldo inicial na SB9
Static Function InsSaldoSB9(nHdlLog, nLinha, nTipoData)
	Local lRet := .F., nqInit := 0, nqiSegum := 0 , nVini1 := 0, nVini2 :=	 0, nCM1 := 0 , nCM2 := 0
	Local nCount := 1//basta avaliar primeiro item da lista
	Local aSldIni := {}
	Local cArqErrAuto := '', cErrAuto := ''
	Private lMsErroAuto := .F.

	DbSelectArea("SB2")
	DbSetOrder(1) // B2_FILIAL+B2_COD+B2_LOCAL

	If !(DbSeek(xFilial("SB2")+AllTrim(aLstLotesEndr[nCount][1])+AllTrim(aLstLotesEndr[nCount][2]),.T.))

		nqInit :=(aLstLotesEndr[nCount][3])
		nqiSegum := (aLstLotesEndr[nCount][4])
		nVini1 := (aLstLotesEndr[nCount][5])
		nVini2 := 0
		nCM1 := (aLstLotesEndr[nCount][6])
		nCM2 := 0

		aSldIni := {;
			{"B9_FILIAL", xFilial("SB9")			 , Nil},;
			{"B9_COD"	, AllTrim(aLstLotesEndr[nCount][1])	 , Nil},;        //AllTrim(aLstLotesEndr[nCount][1])
		{"B9_LOCAL"	, AllTrim(aLstLotesEndr[nCount][2])	 , Nil},;     //							{"B9_DATA"	, 	 , Nil},;
			{"B9_DATA"	, CTOD('')	 , Nil},;
			{"B9_QINI"	, nqInit	 , Nil}   ,;
			{"B9_QISEGUM",nqiSegum	 , Nil},;
			{"B9_VINI1"	, nVini1	 , Nil}     ,;   //saldos
		{"B9_VINI2"	, nVini2	 , Nil} , ;
			{"B9_CM1"	, nCM1	 , Nil},;  //c.unit
		{"B9_CM2"	, nCM2	 , Nil}   }  /*,               ;
			{"B9_CUSTD"	, 0, Nil},;
			{"B9_MCUSTD", 0 , Nil} }           */


		lMsErroAuto := .F.

		MsExecAuto({|x,y| MATA220(x,y)}, aSldIni, 3)

		If lMsErroAuto
		//-- Reporta o erro retornado pela rotina automatica:
			cArqErrAuto := NomeAutoLog()
			cErrAuto    := Memoread(cArqErrAuto)
			Ferase(cArqErrAuto)

			UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero(nLinha, 5) + '] Erro ao executar execauto MATA220: ' + cErrAuto + Chr(13) + Chr(10) )
		else
			lRet := .T.
		endif

	endif

return lRet

//=========================================================================================================

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA  ³   InsMov390        ³Autor  ³Oswaldo Leite ³Data  ³ 02-10-14³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRICAO ³ função auxiliar para importação do saldo de estq           ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//movimento de entrada para cada lote referente ao saldo do item
Static FUnction InsMov390(nHdlLog, nLinha, nTipoData)
	Local lRet := .F., nLtCount := 1, lMsErroAuto := .F.,cArqErrAuto := '', cErrAuto := ''
	Local aLotes := {}, cAuxFil := '', cAuxPrd := '',cAuxLoc := '', dAuxDt  := ctod(''), dAuxVaDt := ctod(''), nAuxQt := 0, cAuxLt  := '',cAuxSubL:=''

	IF !lTemLote
		lRet := .T.
	else
		for nLtCount := 1 to Len(aLotesIni) //somatória dos endereços ...agtinado por LOTE
			lMsErroAuto := .F.

			cAuxFil := aLotesIni[nLtCount][1][2]
			cAuxPrd := aLotesIni[nLtCount][2][2]
			cAuxLoc := aLotesIni[nLtCount][3][2]
			dAuxDt  := date()
			dAuxVaDt:= (aLotesIni[nLtCount][4/*na verdade 5*/][2])

			if lTemEnder
				nAuxQt  := aLotesIni[nLtCount][6][2]
			else    //qdo só tem lote e não o endereço ... a array aLstLotesEnder tem o mesmo tamanho da aLotesIni
				nAuxQt  := aLstLotesEnder[nLtCount][8]
			endif

			cAuxLt  := aLotesIni[nLtCount][7][2]
			cAuxSubL:= aLotesIni[nLtCount][7][2]

			aLotes := Nil
			aLotes :=  { 	{"D5_FILIAL"	, cAuxFil			, NIL} ,;
				{"D5_PRODUTO"	, cAuxPrd 	, NIL} ,;
				{"D5_LOCAL"		, cAuxLoc	, NIL} ,;
				{"D5_DATA"		, dAuxDt , NIL} ,;
				{"D5_DTVALID"	, dAuxVaDt	, NIL} ,;
				{"D5_QUANT"		, nAuxQt	, NIL} ,;
				{"D5_LOTECTL"	, cAuxLt 	, NIL} ,;
				{"D5_SLDINI"	, 'B9' 	, NIL} ,;
				{"D5_DOC"	,  STRZERO(nLtCount,9)	, NIL} ,;
				{"D5_NUMLOTE"	, cAuxSubL	, NIL}     }


			MsExecAuto({|x,y| Mata390(x,y)}, aLOtes, 3)

			If lMsErroAuto
				cArqErrAuto := NomeAutoLog()
				cErrAuto    := Memoread(cArqErrAuto)
				Ferase(cArqErrAuto)

				UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero(nLinha, 5) + '] Erro ao executar execauto MATA390: ' + cErrAuto + Chr(13) + Chr(10) )

				lRet := .F.
				exit
			else
				lRet := .T.
			endif
		Next
	endif

return lRet
//=========================================================================================================

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA  ³ InsAlocaPorEndereco ³Autor  ³Oswaldo Leite ³Data  ³ 02-10-14³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRICAO ³ função auxiliar para importação do saldo de estq           ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//aloca as qtes para cada endereço
Static function InsAlocaPorEndereco( nHdlLog, nLinha)
	Local lFlag := .T., lRet := .T., lMsErroAuto := .F.,cArqErrAuto := '', cErrAuto := '', nCOunt:=1
	Local aCabeAUto := {}, aItemAuto := {}, aItemEnde := {}
	Local nLtCount := 1 ,cAuxPrd := '', cAuxLoc := '', cAuxLt := '', cQtAux := '', cNumSeq := ''

	if lTemLote
		for nLtCount := 1 to Len(aLotesIni) //somatória dos endereços ...agtinado por LOTE
			lMsErroAuto := .F.

			cAuxPrd := aLotesIni[nLtCount][2][2]
			cAuxLoc := aLotesIni[nLtCount][3][2]
			cAuxLt  := aLotesIni[nLtCount][7][2]
			cQtAux  := aLotesIni[nLtCount][6][2]

			if lTemLote //então o execauto já gerou a tabela SDA
				cNumSeq := SDAGerPeloExecAuto(cAuxPrd, cAuxLoc, cAuxLt)
			else//caso seja produto sem lote mas com endereço incluir SDA manualmente
				reclock('SDA',.T.)
				SDA->DA_FILIAL := XFILIAL('SDA')
				SDA->DA_PRODUTO := cAuxPrd
				SDA->DA_QTDORI := cQtAux
				SDA->DA_SALDO := cQtAux
				SDA->DA_DATA  := Date()
	//		SDA->DA_LOTECTL := cAuxLt
				SDA->DA_LOCAL   := cAuxLoc
	//		SDA->DA_DOC := '000000001'
				SDA->DA_SERIE := ''
				SDA->DA_CLIFOR:= ''
				SDA->DA_LOJA:= ''
				SDA->DA_ORIGEM := 'SB9'//'SD5'
				SDA->DA_NUMSEQ := '000001'
				cNumSeq := '000001'
				MsUnLock()
			endif


	//    if lFlag == .F.
	//    	exit
	//    endif
		Next
		
	endif

return	lRet
//============================================================================================

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA  ³ SDAGErPeloExecAuto   ³Autor  ³Oswaldo Leite ³Data  ³ 02-10-14³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRICAO ³ função auxiliar para importação do saldo de estq           ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static FUnction SDAGerPeloExecAuto(cAuxPrd, cAuxLoc, cAuxLt)
	Local cALias := GetNextAlias(), cquery := "SELECT * FROM "+ RETSQLNAME('SDA') + " WHERE D_E_L_E_T_ <> '*' AND DA_FILIAL = '"+ XFILIAL('SDA') + "' "
	Local cRet := ''
	cquery += " AND DA_PRODUTO = '" + cAuxPrd + "' AND DA_LOCAL = '" + cAuxLoc + "' "

	IF !EMPTY(cAuxLt)
		cquery +=  " AND DA_LOTECTL = '" + cAuxLt + "' "
	ENDIF

	dbUseArea( .t., "TOPCONN", TCGenQry(,,cQuery), cAlias, .f., .t. )

	if (cAlias)->(!Eof())
		cRet := (cAlias)->(DA_NUMSEQ)

	endif

	(cAlias)->(dbCLoseArea())
return cRet
//------------------------------------------------------------------------------------------
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA  ³ AjustValidade ³Autor  ³Oswaldo Leite ³Data  ³ 02-10-14³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRICAO ³ função auxiliar para importação do saldo de estq           ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustValidade( )
	Local nCount   := 1

	for nCOunt := 1 to Len(aLotesIni)
/* aAdd(aLotesIni, { {"D5_FILIAL"	, xfilial('SB8')			, NIL} ,;
						{"D5_PRODUTO"	, aLstLotesEndr[nIndex][1]	, NIL} ,;
					 	{"D5_LOCAL"		, aLstLotesEndr[nIndex][2]	, NIL} ,;
	  					{"D5_DATA"		, dATE()		            , NIL} ,;
	  					{"D5_DTVALID"	, dAuxVaDt	, NIL} ,;
			  			{"D5_QUANT"		, aLstLotesEndr[nIndex][11]	, NIL} ,;
	  					{"D5_LOTECTL"	, aLstLotesEndr[nIndex][7]	, NIL} ,;
	  					{"D5_NUMLOTE"	, aLstLotesEndr[nIndex][7]	, NIL} } )*/
		if PesqSB8(aLotesIni[nCOunt][2][2], aLotesIni[nCOunt][3][2], aLotesIni[nCOunt][7][2] )
			reclock('SB8',.F.)
			SB8->B8_DTVALID := aLotesIni[nCOunt][5][2]
			MsUnLock()
		ENDIF

	Next

return
//------------------------------------------------------------------------------------------
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA  ³ PESQsb8   ³Autor  ³Oswaldo Leite ³Data  ³ 02-10-14³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRICAO ³ função auxiliar para importação do saldo de estq           ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static FUnction PesqSB8(cProd, cLocal, cLote)
	Local cquery:= "SELECT * FROM " + RETSQLNAME('SB8') + " WHERE B8_FILIAL = '"+ XFILIAL('SB8') + "' AND D_E_L_E_T_ <> '*' AND B8_PRODUTO = '" + cProd + "' AND B8_LOTECTL = '" + cLote + "' AND B8_LOCAL = '" + cLocal + "' "
	Local lPosicionou := .F. , cALias := GetNextALias()
	dbUseArea( .t., "TOPCONN", TCGenQry(,,cQuery), cAlias, .f., .t. )

	if (cAlias)->(!(Eof())) .and. alltrim((cAlias)->(B8_PRODUTO)) == alltrim(cProd) .and. alltrim((cAlias)->(B8_LOCAL))== alltrim(cLocal)   .and. alltrim((cAlias)->(B8_LOTECTL)) == alltrim(cLote)
		lPosicionou := .T.
		SB8->(DBGOTO( (cAlias)->(R_E_C_N_O_) ))
	endif

	(cAlias)->(dbclosearea())

return lPosicionou
