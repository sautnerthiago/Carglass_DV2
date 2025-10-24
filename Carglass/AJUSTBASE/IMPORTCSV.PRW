#INCLUDE 'TOTVS.CH'
#INCLUDE 'APWIZARD.CH'
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜpÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA  ³ImportCSV ³Autor  ³FELIPE NUNES DE TOLEDO ³Data  ³ 28.Mai.11³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRICAO ³Programa para importacao/carga de dados com base em arquivo ³±±
±±³          ³(.CSV)                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³ALTERAÇÕES³16/05/16 - Alterações para permitir a importação de pedidos ³±±
±±³          ³de compras pois execauto considera cabeçalho e itens como   ³±±
±±³          ³parâmetros apesar de compras usar somente a SC7.            ³±±
±±³          ³19/05/16 - Alteração para efetuar import de lista de preços ³±±
±±³          ³de vendas e de compras com reclock devido ao grande volume  ³±±
±±³          ³registros.                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function ImportCSV()
	Local oWizard    := NIL
	Local lFinish    := .F.
	Local cHeader    := ''
	Local cMessage   := ''
	Local cText      := ''
	Local cTitleProg := 'TOTVS ImportCSV 1.0'

	Local cFileImp   := Space(250)
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

	Local aHardLock  := {}  //Lista de hardlocks liberados para uso
	Local aCNPJLib   := {}  //Lista de cnpjs liberados para uso
	
	Local oLayout    := nil
	Local nLayout    := 1
	
	Local oTpGrv     := nil
	Local nTpGrv     := 1
	Local oSobrIt	
	Local nSobrIt := 2


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
	aAdd(aCNPJLib, "60658762")  //Armarinhos AMBAR
	aAdd(aCNPJLib, "19364481")  //FACA FACIL
	aAdd(aCNPJLib, "00463883")  //DEMARCHE
	aAdd(aCNPJLib, "54437553")  //Multijuntas
	aAdd(aCNPJLib, "02882381")  //Multijuntas
	aAdd(aCNPJLib, "05676122")  //Multijuntas
	aAdd(aCNPJLib, "03586087")  //Multijuntas
	aAdd(aCNPJLib, "48791685")  //C B S
	aAdd(aCNPJLib, "62025606")  //Federação Paulista
	aAdd(aCNPJLib, "52493970")  //Induspeças
	aAdd(aCNPJLib, "07169450")  //Private (PERFECT)
	aAdd(aCNPJLib, "00960272")  //Grupo GP - Eletronica
	aAdd(aCNPJLib, "02740984")  //Qualife Alimentos
	aAdd(aCNPJLib, "13438856")  //Sabor e Arte
	aAdd(aCNPJLib, "11914922")  //Pic Nic
	aAdd(aCNPJLib, "01987230") //PARTAGE
	aAdd(aCNPJLib, "00971855") //GPZINHA - MATRIZ
	aAdd(aCNPJLib, "04349636") //CTT
	aAdd(aCNPJLib, "14365637") //NIHON KOHDEN
	aAdd(aCNPJLib, "60910023") //IRAJA
	aAdd(aCNPJLib, "48873608") //INSTRONIC
	aAdd(aCNPJLib, "60960895") //INTEST
	aAdd(aCNPJLib, "14742208") //MAURICIO JOSE                                   
	aAdd(aCNPJLib, "74372285") //KAWAGRAF
	aAdd(aCNPJLib, "05266821") //NOVATA
	aAdd(aCNPJLib, "17774501") //SICES BRASIL
	aAdd(aCNPJLib, "02505572") //OR BRASIL
	aAdd(aCNPJLib, "09312003") //GMM
	aAdd(aCNPJLib, "01778972") //AMERICANET
	aAdd(aCNPJLib, "58066036") //KIARTES (KIARTES)
	aAdd(aCNPJLib, "09471791") //K2 COMUNICACAO (KIARTES)	
	aAdd(aCNPJLib, "21775120") //PRINT COMERCIO (PIMENTA PRINT)	
	aAdd(aCNPJLib, "10219302") //BRUNO BENEIT (PIMENTA PRINT)
	aAdd(aCNPJLib, "11312680") //ARMANDO EDUARDO (PIMENTA PRINT)
	aAdd(aCNPJLib, "18511372") //SHER (REGINA FESTAS)
	aAdd(aCNPJLib, "13727162") //TAWCOPLAST
	aAdd(aCNPJLib, "03803992") //KONSERV
	aAdd(aCNPJLib, "10372279") //PRONTSERV
	aAdd(aCNPJLib, "14367666") //VITTA FORTIS	                
	aAdd(aCNPJLib, "23481429") //AC MELKO
	aAdd(aCNPJLib, "23993079") //VILLA PARQUE	
	aAdd(aCNPJLib, "02116756") //NEO GEO
	aAdd(aCNPJLib, "05555591") //THERMOSET			

	DEFINE FONT oArial10	NAME 'Arial'       WEIGHT 10
	DEFINE FONT oCouri11	NAME 'Courier New' WEIGHT 11

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³PAINEL PRINCIPAL     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cHeader  := 'ImportCSV - Importação de dados.'
	cMessage := 'Assistente para processamento'
	cText    := 'Este assistente irá auxiliá-lo na configuração dos parâmetros para realização da importação '
	cText    += 'dos dados a partir de um arquivo (.CSV). O objetivo desta aplicação é efetuar a importação '
	cText    += 'consistindo todas as validações existentes no sistema para o cadastramento da tabela.' + Chr(10) + Chr(13)
	cText    += 'Para a realização das validações o programa utilizará o recurso de rotina automática (MSExecAuto).'+ Chr(10) + Chr(13)
	cText    += ' ' + Chr(10) + Chr(13)
	cText    += ' ' + Chr(10) + Chr(13)
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
	@ 095, 020 MsGet oNameFunc Var cNameFunc Valid( If( FindFunction(cNameFunc), .T., ( Alert("Função inválida!") ,.F.) ) .Or. Empty(cNameFunc) ) Size 212, 010 Picture "@!" Of oWizard:oMPanel[3] Pixel

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

	If Alltrim(cNameFunc) == 'MATA220' //considera layout cabeçalho e itens
		nLayout := 2
	Endif

	@ 010, 005 GROUP To 055, 200 PROMPT 'Indique o formatado da data utilizada no arquivo CSV:' Of oWizard:oMPanel[4] Pixel
	@ 020, 010 Radio oTipoDia VAR nTipoData Items "1 = AAAAMMDD","2 = DD/MM/AA","3 = DD/MM/AAAA" SIZE 064, 026 Of oWizard:oMPanel[4] Color CLR_BLUE PIXEL

	@ 060, 005 GROUP To 090, 200 PROMPT 'Retira acentuação:' Of oWizard:oMPanel[4] Pixel
	@ 070, 010 CheckBox oNoAcento Var lNoAcento Prompt "Retira os acentos dos textos a serem importados" Size 140, 010 Of oWizard:oMPanel[4] Color CLR_BLUE Pixel

	@ 095, 005 GROUP To 125, 200 PROMPT 'Os dados do arquivo CSV referem-se:' Of oWizard:oMPanel[4] Pixel
	@ 105, 010 Radio oLayout VAR nLayout Items "1 = Somente 1 tabela","2 = Cabeçalho e Itens" SIZE 070, 026 Of oWizard:oMPanel[4] Color CLR_BLUE PIXEL

	@ 130, 005 GROUP To 160, 205 PROMPT 'Quando os dados do cabeçalho ja estiverem gravados(layout Cabeçalho/Itens):' Of oWizard:oMPanel[4] Pixel
	@ 140, 010 Radio oTpGrv VAR nTpGrv Items "1 = Sobrescreve dados","2 =Não Sobrescreve dados" SIZE 080, 026 Of oWizard:oMPanel[4] Color CLR_BLUE PIXEL


		@ 165, 005 GROUP To 195, 205 PROMPT 'Quando o produto ja existir(somente COMA010 e OMSA010):' Of oWizard:oMPanel[4] Pixel
		@ 175, 010 Radio oSobrIt VAR nSobrIt Items "1 = Sobrescreve dados","2 =Não Sobrescreve dados" SIZE 080, 026 Of oWizard:oMPanel[4] Color CLR_BLUE PIXEL 
	//Endif
	////@ 095, 005 GROUP To 125, 200 PROMPT 'Ordenação dos campos:' Of oWizard:oMPanel[4] Pixel
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
		
		If Alltrim(cNameFunc) == 'MATA220' //considera layout cabeçalho e itens
			nLayout := 2
		Endif
		
		If nLayout == 1//tabela unica
			Processa({||  ProcImp(Alltrim(cFileImp), cFileLog, Alltrim(cNameFunc),nTipoData,lNoAcento, lOrdVetX3) }, cTitleProg, 'Processando importação...')
		Else //tabela cabeçalho e itens
			If Alltrim(cNameFunc) == 'MATA220' //tabela SB9, enderecos e lotes
				Processa({||  ProcImp2(Alltrim(cFileImp), cFileLog, Alltrim(cNameFunc),nTipoData,lNoAcento, lOrdVetX3,nTpGrv) }, cTitleProg, 'Processando importação...')
			Else //outras tabelas, cabecalho e itens
				Processa({||  ProcImp3(Alltrim(cFileImp), cFileLog, Alltrim(cNameFunc),nTipoData,lNoAcento, lOrdVetX3,nTpGrv,nSobrIt) }, cTitleProg, 'Processando importação...')
			Endif
		Endif
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
	Local oModel   := nil
	Local aMVC := {}
	Local nHdl := -1
	Local nPos := 0
	Local nBytes := 0
	Local cLinha := ''
	Local cChar := ''
	Local cVersao := GetVersao(.F.,.F.) //versao protheus
		
	Private aCposKey := {}, cTabPos := ''
	Private cStructAnt := '-', aLstStruct := {} //<--- exclusivo MATA200
	Private cProdAnt:= '-', cArmazAnt := '-', aLstLotesEndr := {} // < ... exclusivo para utilizacao do MATA220


	oModel := FWLoadModel( cNameRot )

	If oModel <> nil
		//If !("12" $ cVersao)
		//	Aviso('ATENÇÃO', 'Esta rotina não está habilitada para importação em versões do protheus anteriores a Versao 12!")
		//	Return
		//Endif
		aMVC := DadosModel(cNameRot)
	Endif
	
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
		nHdl := Fopen(cFileImp)
		//FT_FUse(cFileImp)
		//ProcRegua(FT_FLastRec())

	//--Atualiza arquivo de LOG:
		//UpdFileLog(nHdlLog, '[' + DtoC(Date()) + ' - ' + Time() + '] INICIANDO IMPORTAÇÃO DOS DADOS - ARQUIVO COM ' + StrZero(FT_FLastRec() - 1,7) + ' LINHA(S)' + Chr(13) + Chr(10))
		UpdFileLog(nHdlLog, '[' + DtoC(Date()) + ' - ' + Time() + '] INICIANDO IMPORTAÇÃO DOS DADOS' + Chr(13) + Chr(10))

		If nHdl <> -1
			nBytes := FSeek(nHdl, 0, 2)
			FSeek(nHdl, 0)

			If nBytes > 0
				ProcRegua(nBytes)
				For nPos := 1 To nBytes
					IncProc()
					FRead(nHdl, @cChar, 1)
					
					// Quebra de linha (chr(13)+chr(10) = CR+LF)
					If cChar == Chr(10) .Or. nPos == nBytes
						
						IF !Empty(cLinha)
							
							//Do While !FT_FEof()
							nLinha++
							If nLinha == 1
						    //-- Armazena em memoria a 1a. linha (Cabecalho).
								cBuffer  := cLinha //FT_FReadLn()
								aDataCab := Separa(cBuffer, ';')
								//aDataCab := aBIToken(cBuffer, ';',.F.)
							Else
							//-- Armazena em memoria os itens.
								cBuffer  := cLinha //FT_FReadLn()
								//aDataIte := aBIToken(cBuffer, ';',.F.)
								aDataIte := Separa(cBuffer,';')
												
								If Len(aDataIte) > 0
									If Len(aDataIte) == Len(aDataCab)
										aMsExcAuto := {}
				
										If ImpSaldosInicEstq (cNameRot, aDataIte,.F. )
											//TrataSaldos(nHdlLog, FT_FLastRec(), nLinha, aDataIte, nTipoData)
											//nao utiliza mais tratasaldos na Procimp, pois a importacao do SB9 agora eh na PROCIMP2
										else
				
											if ImpStruct (cNameRot, aDataIte  )
				
												//StructAtual(nHdlLog, FT_FLastRec(), nLinha, aDataIte,cArqErrAuto ,cErrAuto,nTipoData)
												StructAtual(nHdlLog, nLinha, aDataIte,cArqErrAuto ,cErrAuto,nTipoData)
											else
											//--Compatibiliza os campos conforme
											//--dicionario de dados:
												For nCntFor := 1 To Len(aDataCab)
						//					    IF ImpSaldosInicEstq (cNameRot, aDataCab[nCntFor],.T.)
													If !Empty(aDataIte[nCntFor])
														aTamSX3 := TamSX3(aDataCab[nCntFor])
														If Len(aTamSX3) <> 0
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
															ElseIf aTamSX3[3] == 'M'
																xConteudo := StrTran(aDataIte[nCntFor],"|",CRLF)//caso o enter tenha sido trocado por |, no csv.
																If lNoAcento
																	xConteudo := NoAcento(  xConteudo  )
																EndIf
															EndIf
															AAdd(aMsExcAuto, {aDataCab[nCntFor]	,xConteudo,NIL})
														Endif
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
													
														If oModel <> NIL .and. len(aMVC) > 0 //significa que o cadastro está em MVC
															FAJMdlAuto( aMsExcAuto , {} , nOpc , cNameRot , aMVC[1,2] , NIL , aMVC[1,3] ,  ,.T. , NIL, nHdlLog, nLinha)
															
														Else
															bBlockAuto := {|X,Y| &(cNameRot)(X,Y)}
				
															MSExecAuto(bBlockAuto, aMsExcAuto, nOpc)
														Endif
													EndIf
				
													If lMsErroAuto
													//-- Reporta o erro retornado pela rotina automatica:
														cArqErrAuto := NomeAutoLog()
														cErrAuto    := Memoread(cArqErrAuto)
														Ferase(cArqErrAuto)
														UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + ']' + IIF(nOpc == 3,' [INCLUSAO] ',' [ALTERACAO] ') + '[LINHA: ' + StrZero(nLinha, 5) + '] INCONSISTENCIA NA IMPORTACAO DOS DADOS. DETALHE DO ERRO: ' + Chr(13) + Chr(10) + cErrAuto + Chr(13) + Chr(10))
													Else
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
												endif //if chavevalida
											endif //if ImpStruct
											
											/*If Len(aLstStruct) .and. 'MATA200' $ Upper(AllTrim(cNameRot))
												InsereStruct(3, cArqErrAuto, cErrAuto,nHdlLog, nTipoData)
											Endif
											*/
										endif //If ImpSaldosInicEstq
				
									Else  //If Len(aDataIte) == Len(aDataCab)
										UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero(nLinha, 5) + '] INCONSISTENCIA NA IMPORTACAO DOS DADOS. ESTRUTURA DO ITEM DIFERENTE DA ESTRUTURA DO CABECALHO!' + Chr(13) + Chr(10))
									EndIf
				
								//else // If Len(aDataIte) > 0
									//InsereStruct(3, cArqErrAuto, cErrAuto,nHdlLog, nTipoData)
				
								EndIf
							EndIf
							//IncProc()
	
							//FT_FSkip()
						Endif
					
						cLinha :=  ""
											 
					ElseIf cChar <> Chr(13)
	
						cLinha += cChar
	
					EndIf
				
				Next //EndDo

			Endif
			if Len(aLstSTruct)> 0 .and. 'MATA200' $ Upper(AllTrim(cNameRot)) //-- Tratamento diferenciado para a rotina de importacao de estruturas
				InsereStruct(3, cArqErrAuto, cErrAuto,nHdlLog, nTipoData)
			endif
		
			//--Fecha arquivo utilizado para importacao:
				//FT_FUse(cFileImp)
			FClose(nHdl)
		
			//--Atualiza arquivo de LOG:
			UpdFileLog(nHdlLog, '[' + DtoC(Date()) + ' - ' + Time() + '] FIM DO PROCESSO DE IMPORTACAO' + Chr(13) + Chr(10))
		
			//--Exibe LOG de processamento:
			FClose(nHdlLog)
			ShowLog(cFileLog)
		EndIf
	Endif

Return Nil

/*/{Protheus.doc} VldCab
Valida linha de cabeçalho dos arquivos CSV
@author Giane
@since 02/10/2015
@version 1.0
@param aCampos, array, (Descrição do parâmetro)
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
Static Function VldCab(aDataCab,cNameFunc)
	Local lRet  := .T.
	Local aHead := {}
	Local nLen  := 0
	Local aTamSX3 := {}
	Local nx := 0
	Local cTab := ''
	Local nPos := 0
	Local cCpo := ''

//retira espaços em branco caso exista, do header
	For nx := 1 to Len(aDataCab)
		aDataCab[nx] := alltrim(aDataCab[nx])
	Next

	If cNameFunc == 'MATA220' //SB9
		aHead := {"B9_COD","B9_LOCAL","B9_QINI","B9_QISEGUM","B9_VINI1","B9_CM1","D5_LOTECTL","D5_QUANT","D5_DTVALID","BF_LOCALIZ","BF_QUANT","BF_NUMSERI"}
	Endif

	nLen := Len(aHead)

	If nLen > 0
	//Verifica se as rotinas que tem cabeçalho fixo, o header do CSV veio correto
		If nLen <> Len(aDataCab)
		//cabeçalho do CSV esta diferente do que deveria ser enviado, no caso do MATA220 por ex, o cabeçalho é fixo
			lRet := .F.
		Else
			For nx := 1 to Len(aHead)
				If aHead[nx] <> aDataCab[nx]
				//cabeçalho do CSV esta diferente do que deveria ser enviado, no caso do MATA220 por ex, o cabeçalho é fixo			
					lRet := .F.
					Exit
				Endif
			Next
		Endif
	Endif

//agora verifica se todos os campos que vieram no header do CSV realmente existem no SX3
	If lRet

		For Nx := 1 to Len(aDataCab)
			aTamSX3 := TamSX3(aDataCab[Nx])
			If Len(aTamSX3) == 0
				lRet := .F.
				Exit
			Endif
		Next
	
		If lRet
		//verifica se algum campo obrigatorio nao existe no header do CSV
		//monta nome da tabela pai(cabeçalho) a ser importada
			cTab := aDataCab[1]
			nPos := AT("_",cTab)
			If nPos == 3  //tabelas cujo alias tem 2 posicoes, todas as que começam com S
				cTab := 'S' + Left(cTab,2) //nome da tabela pai
			Elseif nPos == 4
				cTab := Left(cTab,3)
			Endif
		
			SX3->(DbSetOrder(1))
			SX3->(DbSeek( cTab ))
			Do While SX3->(!Eof()) .and. SX3->X3_ARQUIVO == cTab
		
				cCpo := Alltrim(SX3->X3_CAMPO)
				If Right(cCpo,5) <> 'FILIAL'
					If X3Obrigat(cCpo)
						If AsCan(aDataCab, {|x| x == cCpo}) == 0 .and. Empty(SX3->X3_RELACAO)
							lRet := .F.
						Endif
					Endif
				Endif
		
				SX3->(DbSkip())
			Enddo
	
		Endif

	Endif

Return lRet

/*/{Protheus.doc} fCriaTrab
Função cria arquivo de trabalho
@author Giane
@since 02/10/2015
@version 1.0
@param @cAliasT, ${param_type}, (Descrição do parâmetro)
@param @cIndex, ${param_type}, (Descrição do parâmetro)
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
Static Function fCriaTrab(cCriaTrab, cAliasT, cIndex, aDataCab, cNameRot, aPosChv, aPosChvI)
	Local aStruct := {}
	Local cIndTRB
	Local Nx   := 0
	Local cCpo := ''
	Local nPos := 0
	Local nLen := 0
	Local cKeyTab := ''
	Local aRet  := {}
	Local aPos  := {}
	Local nOrdem := 1
	Local cIndIte := ''
 
	cAliasT := GetNextAlias()

//monta nome da tabela pai(cabeçalho) a ser importada
	cTab := aDataCab[1]
	nPos := AT("_",cTab)
	If nPos == 3  //tabelas cujo alias tem 2 posicoes, todas as que começam com S
		cLtab := Left(cTab,2) //alias da tabela pai , que inicia os nomes dos campos
		cTab := 'S' + Left(cTab,2) //nome da tabela pai
	Elseif nPos == 4
		cTab := Left(cTab,3)
		cLtab := Left(cTab,3)
	Endif


//os CSVs nao vem com o campo _FILIAL no header, entao incluimos no TRB para o indice do TRB ficar igual da tab.padrao

	cCpo := cLtab + "_FILIAL"
	If Ascan(aDataCab, {|x| x == cCpo}) == 0
		AAdd(aStruct,{cCpo,"C",FwSizeFilial() ,0} )
	Endif
	AAdd(aStruct,{"LINHA","N",5,0} )

	For Nx := 1 to Len(aDataCab)
		cCpo := aDataCab[nx]
		If Left(cCpo,nPos-1) == cLTab .or. cNameRot == 'MATA220' //por enquanto adiciona so os campos da tabela pai na estrutura

			aTamSX3 := TamSX3(aDataCab[Nx])
	
			AAdd(aStruct, {cCpo ,aTamSX3[3],TamSX3(cCpo)[1],TamSX3(cCpo)[2]} )
		Endif

	Next

//pega indice da tabela pai e seta a ordem 

	SX2-> ( dbSetOrder(1) )
	SX2->( dbSeek( cTab ) )
	cIndTRB := alltrim(SX2->X2_UNICO)


	SIX->(DbSetOrder(1))
	If SIX->(Dbseek( cTab ))
		If Empty(cIndTRB)
			cIndTRB := alltrim(SIX->SIX_CHAVE) //caso nao exista x2_unico para a tabela, pega o primeiro indice
		Endif
	Endif
//pega o numero do indice que corresponde a chave unica
	Do While SIX->(!Eof()) .and. SIX->INDICE == cTab
		If alltrim(SIX->CHAVE) == cIndTRB
			nOrdem := val(SIX->ORDEM)
			Exit
		Endif
		SIX->(DbSkip())
	Enddo

	(cTab)->(DbSetOrder(nOrdem)) // necessario para pesquisar a chave antes do execauto e saber se é inclusao ou alteracao

	If cNameRot == 'MATA220'
		cIndTRB := "B9_FILIAL+B9_COD+B9_LOCAL"
	Endif

	aPosChv := MCposChv(cIndTRB, aDataCab)

	If Len(aPosChv) > 0

	//descobrir a chave agora da tabela filha:
		If cNameRot == 'MATA220'
			cIndIte := "+D5_LOTECTL+BF_LOCALIZ"
		Else
	
			For nx := 1 to len(aDataCab)
				If Empty(cTabI) .and. Left(aDataCab[nx],nPos-1) <> cLTab // se existem campos diferentes da tabela pai
					nPos := AT("_",aDataCab[nx])
					If nPos == 3 //tabelas cujo alias tem 2 posicoes, todas as que começam com S
						cLtabI := Left(aDataCab[nx],2)
						cTabI := 'S' + Left(aDataCab[nx],2)
					Elseif nPos == 4 //tabelas cujo alias tem 3 posicoes, exemplo DA0
						cTabI := Left(aDataCab[nx],3)
						cLtabI := Left(aDataCab[nx],3)
					Endif
				Endif
			Next
		
			If !Empty(cTabI)

				For Nx := 1 to Len(aDataCab)
					cCpo := aDataCab[nx]
					If Left(cCpo,nPos-1) == cLTabI
				
						aTamSX3 := TamSX3(aDataCab[Nx])
				
						AAdd(aStruct, {cCpo ,aTamSX3[3],TamSX3(cCpo)[1],TamSX3(cCpo)[2]} )
					Endif
				
				Next

			Endif
		Endif

	Endif

//depois que montou o indice principal acrescenta o indice da tabela filha
	cIndTRB += cIndIte

	cIndex := CriaTrab(Nil, .F.)

	cCriaTrab := CriaTrab(aStruct,.T.)
	dbUseArea(.T.,,cCriaTrab,cAliasT,.T.,.F.)
	If Len(aPosChv) > 0
		IndRegua(cAliasT, cIndex, cIndTRB, , , "Selecionando Registros...")

		dbSetIndex(cIndex+OrdBagExt())
	Endif

	(cAliasT)->(DbSetorder(1))

Return

/*/{Protheus.doc} MCposChv
Encontra a chave unica das tabelas a serem importadas e em que posicoes estao no cabeçalho do CSV, os campos do indice
@author Giane
@since 05/10/2015
@version 1.0
@param cIndice, character, (Descrição do parâmetro)
@param aDataCab, array, (Descrição do parâmetro)
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
Static Function MCposChv(cIndice, aDataCab)
	Local nLen := 0
	Local nx := 0
	Local aPos := {}
	Local aRet := {}
	Local nPos := 0
	Local aPosChv := {}

//qtos campos compoem o indice :
	nLen := Len(cIndice)
	For nx := 1 to nLen
		If Substr(cIndice,nx,1) == "+"
			aadd(aPos, nx)
		Endif
	Next

//quais campos compoem o indice unico da tabela:
	If Len(aPos) > 0
	
		nLen := Len(aPos)
		For nx := 1 to nLen //o campo filial nao sera adicionado em aRet, pois os CSV nao vem com FILIAL
	
			If nx <> nLen
				AAdd(aRet, Substr(cIndice,aPos[nx]+1, aPos[nx+1] - aPos[nx] - 1 ) )
			Endif
	
		Next
	
	//pega ultimo campo do indice
		nLen := Len(cIndice)
		AAdd(aRet, Substr(cIndice, aPos[Len(aPos)]+1, nLen - Len(aPos) ) )
	
	//procura em que posicao do aDatacab estao os campos que compoem o indice:
		For nx := 1 to Len(aRet)
			nPos := AsCan(aDataCab, {|x| x == aRet[nx] })
			If nPos > 0
				AAdd(aPosChv, nPos)
			Else
			//se algum campo chave nao existe no CSV, entao esta errado e nao importar o arquivo
				aPosChv := {}
				Exit
			Endif
		
		Next

	Endif

Return aPosChv

/*/{Protheus.doc} TrataCpo
Trata conteudo dos campos numerico, data, logico ou caracter antes de gravar
@author Giane
@since 02/10/2015
@version 1.0
@param cNomeCampo, character, (Descrição do parâmetro)
@param cConteudo, character, (Descrição do parâmetro)
@param nTipoData, numérico, (Descrição do parâmetro)
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
Static Function TrataCpo(cNameRot, lNoAcento, cNomeCampo, cConteudo, nTipoData, lObrigat)
	Local aTamSX3   := {}
	Local xConteudo := cConteudo
	Local lRet      := .T.
	Local cInicPad  := ''

	Default lObrigat := .F.

	If !lObrigat
		lObrigat := X3Obrigat(cNomeCampo)
		If cNameRot == 'MATA220' .and. Left(cNomeCampo,2) <> 'B9'
		//nao validar os campos ref. LOTE e ENDERECO, pois podem ou nao ser informados no layout para a rotina MATA220
			lObrigat := .F.
		Endif
	Endif

	SX3->(DbSetOrder(2)) //campo
	If SX3->(DbSeek(cNomeCampo))
		cInicPad := CriaVar(cNomeCampo,.T.) //SX3->X3_RELACAO
	Endif

	aTamSX3 := TamSX3(cNomeCampo)
	If aTamSX3[3] == 'N'
		xConteudo := Val(StrTran(cConteudo,",","."))
	  
		If lObrigat .and. xConteudo == 0
			If !Empty(cInicPad)
				xConteudo := cInicPad
			Else
				lRet := .F.
			Endif
		Endif
	
	ElseIf aTamSX3[3] == 'D'
		If nTipoData == 1 //-- AAAAMMDD
			xConteudo := StoD( cConteudo )
		Else  //-- DD/MM/AA ou DD/MM/AAAA
			xConteudo := CtoD( cConteudo )
		EndIf
		If lObrigat .and. Empty(xConteudo)
			If !Empty(cInicPad)
				xConteudo := cInicPad
			Else
				lRet := .F.
			Endif
		Endif
	ElseIf aTamSX3[3] == 'L'
		xConteudo := AllTrim(cConteudo) == 'T' .Or. AllTrim(cConteudo) == '.T.'
	ElseIf aTamSX3[3] == 'C'
		If lNoAcento
			xConteudo := NoAcento( PadR( AllTrim( cConteudo ), aTamSX3[1] ) )
		Else
			xConteudo := PadR( AllTrim( cConteudo ), aTamSX3[1] )
		EndIf
	
		If lObrigat .and. Empty(xConteudo)
			If !Empty(cInicPad)
				xConteudo := cInicPad
			Else
				lRet := .F.
			Endif
		Endif

	EndIf

	cConteudo := xConteudo
										
Return lRet

/*/{Protheus.doc} ChkTab

@author Giane
@since 17/11/2015
@version 1.0
@param cIndex, character, (Descrição do parâmetro)
@param aDataCab, array, (Descrição do parâmetro)
@param aPosChv, array, (Descrição do parâmetro)
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
Static Function ChkTab(cIndex, aDataCab, aPosChv)
	Local cIndTRB
	Local Nx   := 0
	Local cCpo := ''
	Local nPos := 0
	Local nLen := 0
	Local aRet  := {}
	Local aPos  := {}
	Local nOrdem := 1
	Local cIndIte := ''


//monta nome da tabela pai(cabeçalho) a ser importada
	cTab := aDataCab[1]
	nPos := AT("_",cTab)
	If nPos == 3  //tabelas cujo alias tem 2 posicoes, todas as que começam com S
		cLtab := Left(cTab,2) //alias da tabela pai , que inicia os nomes dos campos
		cTab := 'S' + Left(cTab,2) //nome da tabela pai
	Elseif nPos == 4
		cTab := Left(cTab,3)
		cLtab := Left(cTab,3)
	Endif


//os CSVs nao vem com o campo _FILIAL no header, entao incluimos no TRB para o indice do TRB ficar igual da tab.padrao

	cCpo := cLtab + "_FILIAL"

//pega indice da tabela pai e seta a ordem 

	SX2-> ( dbSetOrder(1) )
	SX2->( dbSeek( cTab ) )
	cIndTRB := alltrim(SX2->X2_UNICO)


	SIX->(DbSetOrder(1))
	If SIX->(Dbseek( cTab ))
		If Empty(cIndTRB)
			cIndTRB := alltrim(SIX->SIX_CHAVE) //caso nao exista x2_unico para a tabela, pega o primeiro indice
		Endif
	Endif
//pega o numero do indice que corresponde a chave unica
	Do While SIX->(!Eof()) .and. SIX->INDICE == cTab
		If alltrim(SIX->CHAVE) == cIndTRB
			nOrdem := val(SIX->ORDEM)
			Exit
		Endif
		SIX->(DbSkip())
	Enddo

	(cTab)->(DbSetOrder(nOrdem)) // necessario para pesquisar a chave antes do execauto e saber se é inclusao ou alteracao


	aPosChv := MCposChv(cIndTRB, aDataCab)

	If Len(aPosChv) > 0

	//descobrir a chave agora da tabela filha:
	
	
		For nx := 1 to len(aDataCab)
			If Empty(cTabI) .and. Left(aDataCab[nx],nPos-1) <> cLTab // se existem campos diferentes da tabela pai
				nPos := AT("_",aDataCab[nx])
				If nPos == 3 //tabelas cujo alias tem 2 posicoes, todas as que começam com S
					cLtabI := Left(aDataCab[nx],2)
					cTabI := 'S' + Left(aDataCab[nx],2)
				Elseif nPos == 4 //tabelas cujo alias tem 3 posicoes, exemplo DA0
					cTabI := Left(aDataCab[nx],3)
					cLtabI := Left(aDataCab[nx],3)
				Endif
			Endif
		Next
		

	Endif


Return


/*/{Protheus.doc} ProcImp2
Importa cadastros que possuem cabeçalho e itens
@author Giane
@since 02/10/2015
@version 1.0
@param cFileImp, character, (Descrição do parâmetro)
@param cFileLog, character, (Descrição do parâmetro)
@param cNameRot, character, (Descrição do parâmetro)
@param nTipoData, numérico, (Descrição do parâmetro)
@param lNoAcento, ${param_type}, (Descrição do parâmetro)
@param lOrdVetX3, ${param_type}, (Descrição do parâmetro)
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
Static Function ProcImp2(cFileImp, cFileLog, cNameRot, nTipoData, lNoAcento, lOrdVetX3, nTpGrv)
	Local nHdlLog     := 0
	Local nLinha      := 0
	Local aDataCab    := ''
	Local aDataIte    := {}
	Local cBuffer     := ''
	Local cAliasT
	Local cIndex
	Local nCpoChv 	 := 0 //varivel que diz qtos campos da tabela fazem parte do indice unico
	Local cCriaTrab
	Local aPosChv		:= {}
	Local aPosChvI	:= {}
	Local cChave 		:= ''
	Local nx			:= 0
	Local nCpos		:= 0
	Local nCampo		:= 0
	Local cNomeCamp	:= ''
	Local lGrv 		:= .F.
	
	Local cTime := Time()
	
	Private cTab 		:= ''
	Private cLTab 	:= ''	//guarda alias da tabela principal(tabela pai)
	Private cTabI 	:= ''
	Private cLTabI 	:= ''
	
	

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
	
		SX3->(DbSetOrder(2)) // X3_CAMPO

		Do While !FT_FEof()
			nLinha++
			cBuffer  := FT_FReadLn()
					
			If nLinha == 1
				aDataCab := Separa(cBuffer, ';')
				
				If !VldCab(aDataCab,cNameRot)
					UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero(nLinha, 5) + '] INCONSISTENCIA NA IMPORTACAO DOS DADOS. LINHAS DO HEADER INCORRETA!"' + Chr(13) + Chr(10))
					Exit
				Endif
				
				//cria arquivo Temporario para gravar dados do CSV
				fCriaTrab(@cCriaTrab, @cAliasT, @cIndex, aDataCab, cNameRot, @aPosChv)//,@aPosChvI)
				
				If Len(aPosChv) == 0 //.or. Len(aPosChvI) == 0
					UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero(nLinha, 5) + '] INCONSISTENCIA NA IMPORTACAO DOS DADOS. CAMPOS QUE COMPOEM O INDICE DA(S) TABELA(S) NAO FORAM ENCONTRADOS NO HEADER!"' + Chr(13) + Chr(10))
					Exit
				Endif

			Else
			//-- Armazena no arquivo temporario os itens
				aDataIte := Separa(cBuffer, ';')
				If Len(aDataIte) > 0
					If Len(aDataIte) == Len(aDataCab)
	
						lGrv := .T.
						//Verifica se algum campo chave da tabela pai nao esta correto seu conteudo no CSV
						For nx := 1 to len(aPosChv)
						
							//primeiro trata o conteudo do campo chave, se estiver tudo ok, monta a chave de pesquisa							
							If !TrataCpo(cNameRot,lNoAcento, aDataCab[nx], @aDataIte[nx], nTipoData, .T.)
							
								//nao ira importar este registro, pois os campos chaves nao estao com conteudo corretos
								UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero(nLinha, 5) + '] INCONSISTENCIA NA IMPORTACAO DOS DADOS. CAMPOS QUE COMPOEM O INDICE DA TABELA SAO INVALIDOS!"' + Chr(13) + Chr(10))
								
								lGrv := .F.
								Exit
							Endif
						Next
						

						If lGrv
															
							//grava dados do registro, no arquivo temporario, verificando antes se nenhum campo obrigatorio esta vazio ou invalido									
							nCpos := (cAliasT)->(FCount())
							For nCampo := 3 To nCpos
								cNomeCamp := AllTrim((cAliasT)->(FieldName(nCampo)) )
								
								If !TrataCpo(cNameRot,lNoAcento, cNomeCamp, @aDataIte[nCampo-2], nTipoData)
									UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero(nLinha, 5) + '] INCONSISTENCIA NA IMPORTACAO DOS DADOS. CAMPOS OBRIGATORIOS NAO PREENCHIDOS OU INVALIDOS!"' + Chr(13) + Chr(10))
									lGrv := .F.
									Exit
								Endif
								 																									
							Next
							
							If lGrv //grava reg. no arquivo temporario
								RecLock(cAliasT,.T.)
								
								For nCampo := 3 To nCpos
									cNomeCamp := AllTrim((cAliasT)->(FieldName(nCampo)) )
															
									(cAliasT)->&cNomeCamp := aDataIte[nCampo-2] //-2 pq FILIAL e LINHA estao no TRB mas nao no CSV
									
								Next
								(cAliasT)->LINHA := nLinha
								(cAliasT)->(MsUnlock())
							Endif
						Endif

					Else
						UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero(nLinha, 5) + '] INCONSISTENCIA NA IMPORTACAO DOS DADOS. ESTRUTURA DO ITEM DIFERENTE DA ESTRUTURA DO CABECALHO!' + Chr(13) + Chr(10))
					EndIf
				
				Else
					UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero(nLinha, 5) + '] INCONSISTENCIA NA IMPORTACAO DOS DADOS. ESTRUTURA DO ITEM VAZIA OU INCORRETA!' + Chr(13) + Chr(10))
				EndIf
				
			EndIf
			IncProc()

			FT_FSkip()
		EndDo

		If Select(cAliasT) > 0
		
			If Len(aPosChv) > 0 .and. (cAliasT)->(!Eof())
				If cNameRot == 'MATA220'
					ProcMs220(cAliasT, aDataCab, aPosChv,aPosChvI, cNameRot,nHdlLog)
				Else
					ProcMsExec(cAliasT, aDataCab, aPosChv, cNameRot,nHdlLog,nTpGrv)
				Endif
			Endif
			
			(cAliasT)->(DbCloseArea())
			Ferase(cCriaTrab+GetDBExtension())
			Ferase(cCriatrab+OrdBagExt())
		Endif

	//--Fecha arquivo utilizado para importacao:
		FT_FUse(cFileImp)

	//--Atualiza arquivo de LOG:
		UpdFileLog(nHdlLog, '[' + DtoC(Date()) + ' - ' + Time() + '] FIM DO PROCESSO DE IMPORTACAO' + Chr(13) + Chr(10))

		//MsgInfo( 'tempo decorrido: ' + ElapTime( cTime, Time() ), 'IMPORTCSV' )	
		ConOut( 'tempo decorrido: ' + ElapTime( cTime, Time() ) )

	//--Exibe LOG de processamento:
		FClose(nHdlLog)
		ShowLog(cFileLog)
	EndIf

Return Nil

/*/{Protheus.doc} ProcImp3
Importa cadastros que possuem cabeçalho e itens
@author Giane
@since 02/10/2015
@version 1.0
@param cFileImp, character, (Descrição do parâmetro)
@param cFileLog, character, (Descrição do parâmetro)
@param cNameRot, character, (Descrição do parâmetro)
@param nTipoData, numérico, (Descrição do parâmetro)
@param lNoAcento, ${param_type}, (Descrição do parâmetro)
@param lOrdVetX3, ${param_type}, (Descrição do parâmetro)
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
Static Function ProcImp3(cFileImp, cFileLog, cNameRot, nTipoData, lNoAcento, lOrdVetX3, nTpGrv, nSobrIt)
	Local nHdlLog     := 0
	Local nLinha      := 0
	Local aDataCab    := ''
	Local aDataIte    := {}
	Local cBuffer     := ''
	Local cIndex
	Local nCpoChv 	 := 0 //varivel que diz qtos campos da tabela fazem parte do indice unico
	Local aPosChv		:= {}
	Local aPosChvI	:= {}
	Local cChave 		:= ''
	Local nx			:= 0
	Local nCpos		:= 0
	Local nCampo		:= 0
	Local cNomeCamp	:= ''
	Local lGrv 		:= .F.
	Local aMsExcIte  := {}
	Local aMsExcCab  := {}
	Local cChvIte 	:= ''
	Local nPosIte   := 0
	Local cItem     := ''
	Local aCpoCab   := {}
	Local aLin		  := {}
	Local aAux		:= {}
	
	Local cTime 	:= Time()
	Local nHdl 		:= -1
	Local nPos 		:= 0
	Local nBytes 	:= 0
	Local cLinha 	:= ''
	Local cChar 	:= ''
	
	Private cTab 	:= ''
	Private cLTab 	:= ''	//guarda alias da tabela principal(tabela pai)
	Private cTabI 	:= ''
	Private cLTabI 	:= ''
	
	
	If cNameRot == 'MATA061' //SA5 (PROD X FORNECEDOR), precisa tratar de forma diferente, pois o MVC espera receber cabecalho e itens, porem da mesma tabela SA5!
		aCpoCab := {"A5_PRODUTO"}
	Endif
	
	If cNameRot == 'MATA120' //SC7 (PEDIDOS DE COMPRAS), campos de cabeçalho da SC7 para atender EXECAUTO que recebe cabeçalho e itens apesar de ser a mesma tabela
		aCpoCab := {"C7_NUM","C7_EMISSAO","C7_FORNECE","C7_LOJA","C7_COND","C7_CONTATO","C7_FILENT"}
	Endif
	
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
		//FT_FUse(cFileImp)
		//(FT_FLastRec())

		//--Atualiza arquivo de LOG:
		UpdFileLog(nHdlLog, '[' + DtoC(Date()) + ' - ' + Time() + '] INICIANDO IMPORTAÇÃO DOS DADOS ' + Chr(13) + Chr(10))
	
		SX3->(DbSetOrder(2)) // X3_CAMPO

		Begin Transaction
		
			nHdl := FOpen(cFileImp)
		
			If nHdl <> -1
				nBytes := FSeek(nHdl, 0, 2)
				FSeek(nHdl, 0)

				If nBytes > 0
					ProcRegua(nBytes)
					For nPos := 1 To nBytes
						IncProc()
						FRead(nHdl, @cChar, 1)
					
					// Quebra de linha (chr(13)+chr(10) = CR+LF)
						If cChar == Chr(10) .Or. nPos == nBytes
						
							IF !Empty(cLinha)
		
						//Do While !FT_FEof()
								nLinha++
								cBuffer  := cLinha //FT_FReadLn()
								
									
								If nLinha == 1
									aDataCab := Separa(cBuffer, ';')
								
									If !VldCab(aDataCab,cNameRot)
										UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero(nLinha, 5) + '] INCONSISTENCIA NA IMPORTACAO DOS DADOS. LINHAS DO HEADER INCORRETA!"' + Chr(13) + Chr(10))
										Exit
									Endif
								
									ChkTab(@cIndex, aDataCab, @aPosChv)
													
									If cNameRot == 'MATA061'
									//monta campos chaves para a SA5, pq o model deste caso é diferente dos models master/detail
										aPosChv := {}
										For nx := 1 to len(aCpoCab)
											nPos := Ascan(aDataCab,{|x| x==aCpoCab[nx]})
											If nPos > 0
												AAdd(aPosChv, nPos)
											Endif
										Next
									
									Endif
								
															
									nTam := len(cLTab)
								
									If Len(aPosChv) == 0 //.or. Len(aPosChvI) == 0
										UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero(nLinha, 5) + '] INCONSISTENCIA NA IMPORTACAO DOS DADOS. CAMPOS QUE COMPOEM O INDICE DA(S) TABELA(S) NAO FORAM ENCONTRADOS NO HEADER!"' + Chr(13) + Chr(10))
										Exit
									Endif
								
									If cNameRot == 'OMSA010'
										cItem := Strzero(0,TamSX3('DA1_ITEM')[1])
										nPosIte := Ascan(aDataCab, {|x| x=='DA1_ITEM' })
									Endif
				
									If cNameRot == 'COMA010'
										cItem := Strzero(0,TamSX3('AIB_ITEM')[1])
										nPosIte := Ascan(aDataCab, {|x| x=='AIB_ITEM' })
									Endif
								Else
								
									//aadd(alin, nLinha)
							//-- Armazena no arquivo temporario os itens
									aDataIte := Separa(cBuffer, ';')
									If Len(aDataIte) > 0
										If Len(aDataIte) == Len(aDataCab)
					
											lGrv := .T.
										//Verifica se algum campo chave da tabela pai nao esta correto seu conteudo no CSV
										/*For nx := 1 to len(aPosChv)
										
											//primeiro trata o conteudo do campo chave, se estiver tudo ok, monta a chave de pesquisa							
											If !TrataCpo(cNameRot,lNoAcento, aDataCab[nx], @aDataIte[nx], nTipoData, .T.)		
											
												//nao ira importar este registro, pois os campos chaves nao estao com conteudo corretos
												UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero(nLinha, 5) + '] INCONSISTENCIA NA IMPORTACAO DOS DADOS. CAMPOS QUE COMPOEM O INDICE DA TABELA SAO INVALIDOS!"' + Chr(13) + Chr(10))								
												
												lGrv := .F.
												Exit
											Endif
										Next
										*/
				
											If lGrv
											//verifica se a chave do item ainda é igual a do cabecalho 
												cChvIte := ''
												For Nx := 1 to len(aPosChv)
												//Se a rotina é de pedido de compras, considerar como chave somente o número do pedido
													If cNameRot == 'MATA120' .and. Nx>1
														Nx := len(aPosChv)
													Else
														cCpo := aDataCab[nx]
														cChvIte += Padr( aDataIte[ aPosChv[nx] ], TamSX3(cCpo)[1] )
													EndIf
												Next
														
												If (!Empty(cChave) .and. cChave <> cChvIte) .or. ( len(aMsExcIte) > 300 .and. cNameRot <> 'COMA010' .and. cNameRot <> 'OMSA010' )
												
													If cNameRot <> 'COMA010' .and. cNameRot <> 'OMSA010'
												
														//enviar os itens da mesma chave do cabeçalho para o execauto
														GravaDados(aMsExcCab,aMsExcIte,cChave,cNameRot,nHdlLog, nLinha-1, nTpGrv)
														
													Else
														GrvRecLock(aMsExcCab,aMsExcIte,cChave,cNameRot,nHdlLog, nLinha, nTpGrv, nSobrIt, aLin)
													Endif
													If cChave <> cChvIte
														aMsExcCab := {}
														cChave := ''
													Endif
													aMsExcIte := {}
													aAux := {}
													aLin := {}
												Endif
				
												aAux := {}
												
											
												For nCampo := 1 To Len(aDataCab)
											    //adiciona item no array para o execauto
													If Left(aDataCab[nCampo], nTam) == cLTabI  .or. ( len(aCpoCab) > 0 .and. Ascan(aCpoCab,{|x| x==aDataCab[nCampo]})== 0   ) //campos da tabela filha
											    	//caso seja mata061, procura se o campo é do cabeçalho ou nao pelo array aCpoCab
														cNomeCamp := aDataCab[nCampo]
														If !TrataCpo(cNameRot,lNoAcento, cNomeCamp, @aDataIte[nCampo], nTipoData)
															UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero(nLinha, 5) + '] INCONSISTENCIA NA IMPORTACAO DOS DADOS DO ITEM. CONTEUDO DO CAMPO ' + cNomeCamp + ' INVALIDO!' + Chr(13) + Chr(10))
															lGrv := .F.
															Exit
														Else
														
															AAdd(aAux, {cNomeCamp	,aDataIte[nCampo],NIL})
															
														
														Endif
													ElseIf Left(aDataCab[nCampo], nTam) == cLTab .or. ( len(aCpoCab) > 0 .and. Ascan(aCpoCab,{|x| x==aDataCab[nCampo]})> 0   )  // campos da tabela pai
														If Len(aMsExcIte) == 0  //adiciona os dados do cabecalho para o execauto
															cNomeCamp := aDataCab[nCampo]
															If !TrataCpo(cNameRot,lNoAcento, cNomeCamp, @aDataIte[nCampo], nTipoData)
																UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero(nLinha, 5) + '] INCONSISTENCIA NA IMPORTACAO DOS DADOS. DADOS INVALIDOS DA TABELA CABECALHO!"' + Chr(13) + Chr(10))
																lGrv := .F.
																Exit
															Else
																AAdd(aMsExcCab, {cNomeCamp	,aDataIte[nCampo],NIL})
																cChave := ''
																For Nx := 1 to len(aPosChv)
																//Se a rotina é de pedido de compras, considerar como chave somente o número do pedido
																	If cNameRot == 'MATA120' .and. Nx>1
																		Nx := len(aPosChv)
																	Else
																		cCpo := aDataCab[nx]
																		cChave += Padr( aDataIte[ aPosChv[nx] ], TamSX3(cCpo)[1]   )
																	EndIf
																Next
															Endif
														Endif
													Endif
												Next
											
												If len(aAux) > 0 .and. lGrv
												/*
													If nPosIte == 0 .and. cNameRot == 'OMSA010'
														AAdd(aAux, {"DA1_ITEM", Soma1(cItem), nil})
														cItem := Soma1(cItem)
													Endif
													 nao inserir o item aqui, sera tratado na hora de gravar
													If nPosIte == 0 .and. cNameRot == 'COMA010'
														AAdd(aAux, {"AIB_ITEM", Soma1(cItem), nil})
														cItem := Soma1(cItem)
													Endif
													*/
													AAdd(aMsExcIte, aAux)
													AAdd(aLin, nLinha)
													
												Endif
										
											Endif
				
										Else
											UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero(nLinha, 5) + '] INCONSISTENCIA NA IMPORTACAO DOS DADOS. ESTRUTURA DO ITEM DIFERENTE DA ESTRUTURA DO CABECALHO!' + Chr(13) + Chr(10))
										EndIf
								
									Else
										UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero(nLinha, 5) + '] INCONSISTENCIA NA IMPORTACAO DOS DADOS. ESTRUTURA DO ITEM VAZIA OU INCORRETA!' + Chr(13) + Chr(10))
									EndIf
								
								EndIf
							//IncProc()
				
							//FT_FSkip()
							Endif
					
							cLinha :=  ""
											 
						ElseIf cChar <> Chr(13)
	
							cLinha += cChar
	
						EndIf
						//EndDo
					Next
				Endif
						
				ConOut( 'Tempo leitura CSV: ' + ElapTime( cTime, Time() ) )
		
				If len(aMsExcIte) > 0
					If Alltrim(cNameRot) == 'OMSA010' .Or. Alltrim(cNameRot) == 'COMA010'
						GrvRecLock(aMsExcCab,aMsExcIte,cChave,cNameRot,nHdlLog, nLinha, nTpGrv, nSobrIt, aLin)
					Else
						GravaDados(aMsExcCab,aMsExcIte,cChave,cNameRot,nHdlLog, nLinha, nTpGrv)
					Endif
				Endif
			EndIf
		
		End Transaction
				
		//--Fecha arquivo utilizado para importacao:
		//FT_FUse(cFileImp)
		FClose(cFileImp)
		
		//--Atualiza arquivo de LOG:
		UpdFileLog(nHdlLog, '[' + DtoC(Date()) + ' - ' + Time() + '] FIM DO PROCESSO DE IMPORTACAO' + Chr(13) + Chr(10))
		
		//MsgInfo( 'tempo decorrido: ' + ElapTime( cTime, Time() ), 'IMPORTCSV' )	
		//ConOut( 'tempo decorrido: ' + ElapTime( cTime, Time() ) )	
		
		//--Exibe LOG de processamento:
		FClose(nHdlLog)
		ShowLog(cFileLog)
		//EndIf
	Endif

Return Nil

/*/{Protheus.doc} MontaChv
Monta Chave de pesquisa
@author Giane
@since 05/10/2015
@version 1.0
@param aPosChv, array, (Descrição do parâmetro)
@param aDataCab, array, (Descrição do parâmetro)
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
Static Function MontaChv(aPosChv, aDataCab)
	Local cCpos := ''
	Local Nx := 0

	For Nx := 1 to len(aPosChv)
		cCpos += aDataCab[ aPosChv[nx] ] + IIf(Nx < len(aPosChv), "+",'')
	Next

Return cCpos

/*/{Protheus.doc} ProcMs220
Monta Execauto da rotina MATA220, endereços e lotes
@author Giane
@since 05/10/2015
@version 1.0
@param cAliasT, character, (Descrição do parâmetro)
@param aDataCab, array, (Descrição do parâmetro)
@param aPosChv, array, (Descrição do parâmetro)
@param aPosChvI, array, (Descrição do parâmetro)
@param cNameRot, character, (Descrição do parâmetro)
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
Static Function ProcMs220(cAliasT, aDataCab, aPosChv,aPosChvI, cNameRot,nHdlLog)
	Local cChvPai := ''
	Local cChvIte := ''
	local cCpos   := ''
	Local cCposI  := ''
	Local nx      := 0
	Local cCampo  := ''
	Local nQtCpo  := 0
	Local cNomeCamp := ''
	Local aCabec  := {}
	Local nOpc    := 3
	Local nLinE   := 0
	Local nLinL   := 0
	Local cArqErrAuto := ''
	Local cMsgErro := ''
	Local bBlockAuto := nil
	Local lRastro := .F.
	Local lLocaliz := .F.
	Local nQtdB9 := 0
	Local nQtdD5 := 0
	Local lLote := .T.
	Local nQtdD5Lote := 0

	Local aLotesIni := {}
	Local aEnd      := {}

	Private lMsErroAuto := .F.
	Private lMsHelpAuto := .T.

	cCpos := MontaChv(aPosChv, aDataCab) //campos chave da tabela pai
	cCposI := MontaChv(aPosChvI, aDataCab) //campos chave da tabela filha

	(cAliasT)->(DbGotop())
	Do While (cAliasT)->(!Eof())

		cChvPai := ''
		For Nx := 1 to len(aPosChv)
			cCampo := aDataCab[ aPosChv[nx] ]
			cChvPai += (cAliasT)->&cCampo
		Next
	
		nQtCpo := (cAliasT)->(FCount())

		aCabec := {}
	//monta o array da tabela cabeçalho para o execauto, com o primeiro registro da chave
		For Nx := 1 to nQtCpo
			cNomeCamp := AllTrim((cAliasT)->(FieldName(Nx)) )
		
			If Left(cNomeCamp,2) == cLTab .and. Right(cNOmeCamp,6) <> 'FILIAL' //se os campos sao da tabela principal(pai)
			
				AAdd( aCabec, { cNomeCamp    , (cAliasT)->&cNomeCamp , Nil } )
				If cNomeCamp == 'B9_QINI'
					nQtdB9 := (cAliasT)->B9_QINI
				Endif
			
			Elseif cNomeCamp == 'LINHA'
				nLinE := (cAliasT)->LINHA
			Endif

		Next
	
		If cNameRot == 'MATA220'
			lRastro := Rastro((cAliasT)->B9_COD)
			lLocaliz := Localiza((cAliasT)->B9_COD)
			nQtdD5 := 0
			aLotesIni := {}
			aEnd := {}
			Do While (cAliasT)->(!Eof()) .and. (cAliasT)->B9_FILIAL + (cAliasT)->&cCpos == space(FwSizeFilial()) + cChvPai
		
				cChvIte := (cAliasT)->D5_LOTECTL
						
				If !Empty(cChvIte)
	
					If lRastro
					//caso o produto controle lote, e os dados do lote tenham sido informados
						If (cAliasT)->D5_QUANT > 0 .and. !Empty((cAliasT)->D5_DTVALID)
						//alimenta array que o execauto MATA220 utiliza para gravar o lotes juntamente com a SB9
							
							aAdd(aLotesIni, {	{"D5_PRODUTO"	, (cAliasT)->B9_COD		, NIL} ,;
								{"D5_LOCAL"	, (cAliasT)->B9_LOCAL	, NIL} ,;
								{"D5_DATA"		, dDataBase				, NIL}	,;
								{"D5_QUANT"	, (cAliasT)->D5_QUANT	, NIL} ,;
								{"D5_LOTECTL"	, (cAliasT)->D5_LOTECTL	, NIL} ,;
								{"D5_DTVALID"	, (cAliasT)->D5_DTVALID	, NIL} ,;
								{"D5_ORIGLAN"	, "MAN"					, NIL} ,;
								{"D5_SLDINI"	, "B9"						, NIL} })
				  		
				  		//nQtdD5 += (cAliasT)->D5_QUANT			
							nLinL:= (cAliasT)->LINHA
			
						Endif
					Endif
				Endif
			
				nQtdD5Lote := 0
				Do While (cAliasT)->(!Eof()) .and. (cAliasT)->B9_FILIAL + (cAliasT)->&cCpos + (cAliasT)->D5_LOTECTL == space(FwSizeFilial()) + cChvPai + cChvIte
					If !Empty((cAliasT)->BF_LOCALIZ) .and. lLocaliz
						AAdd(aEnd, {(cAliasT)->B9_COD,(cAliasT)->B9_LOCAL,(cAliasT)->D5_LOTECTL, (cAliasT)->BF_LOCALIZ, (cAliasT)->BF_QUANT , (cAliasT)->LINHA, (cAliasT)->BF_NUMSERI  })
					Endif
				
					If lRastro
					//caso o produto controle lote, e os dados do lote tenham sido informados
						If (cAliasT)->D5_QUANT > 0 .and. !Empty((cAliasT)->D5_DTVALID)
							nQtdD5 += (cAliasT)->D5_QUANT
							nQtdD5Lote += (cAliasT)->D5_QUANT
						Endif
					Endif
				
					(cAliasT)->(DbSkip())
				Enddo
			
			// alterar a qtdade do lote, com a soma das qtdades de cada lote
				If nQtdD5Lote  > 0 .and. len(aLotesIni) > 0
			
					aLotesIni[len(aLotesIni),4,2] := nQtdD5Lote
					
				Endif
				
			Enddo
		
			If len(aCabec) > 0 //.and. len(aItens) > 0
	
			//verifica se ja existe o registro, para mandar opçao incluir ou alterar no execauto:
				If (cTab)->(DbSeek( FwxFilial(cTab) + cChvPai ))
					nOpc := 4
				Endif
				
				Begin TransacTion
				
					lMsErroAuto := .F.
			
					bBlockAuto := {|X,Y| &(cNameRot)(X,Y)}
					MSExecAuto(bBlockAuto,aCabec,nOpc)
						
					If lMsErroAuto
						DisarmTransaction()
						cArqErrAuto 	:= NomeAutoLog()
						cMsgErro 		:= Memoread(cArqErrAuto)
						Ferase(cArqErrAuto)
						UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero(nLinE, 5) + '] INCONSISTENCIA NA IMPORTACAO DOS DADOS. DETALHE DO ERRO: ' + Chr(13) + Chr(10) + cMsgErro + Chr(13) + Chr(10))
								
					Else
						lLote := .T. //mesmo que nao haja lotes, a variavel fica .T. para efetuar os enderecamentos
					//gravar lotes se houver
						lLote := MovLote(aLotesIni, nQtdB9, nQtdD5, nLinL, nHdlLog) //caso tenha lotes e nao consiga efetuar, nao faz enderecamento tb
					//efetua enderecamentos	
						If lLote
							MovEnd(aEnd,nHdlLog, nQtdD5, nQtdB9, lRastro)
						Endif
		
					Endif
				
				End Transaction
	
			Endif
		
		Endif
	Enddo

Return
/*/{Protheus.doc} ProcMsExec
Monta e processa Execautos 
@author Giane
@since 07/10/2015
@version 1.0
@param cAliasT, character, (Descrição do parâmetro)
@param aDataCab, array, (Descrição do parâmetro)
@param aPosChv, array, (Descrição do parâmetro)
@param aPosChvI, array, (Descrição do parâmetro)
@param cNameRot, character, (Descrição do parâmetro)
@param nHdlLog, numérico, (Descrição do parâmetro)
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
Static Function ProcMsExec(cAliasT, aDataCab, aPosChv, cNameRot,nHdlLog,nTpGrv)
	Local cChvPai := ''
	local cCpos   := ''
	Local nx      := 0
	Local cCampo  := ''
	Local nQtCpo  := 0
	Local cNomeCamp := ''
	Local aCabec  := {}
	Local aItens  := {}
	Local nLinE   := 0
	Local aAux 	:= {}
	Local cItem 	:= ''
	Local cCpoIte := ''
	Local lTemIte := .F.
	Local nItens 	:= 0
	Local cCodTab := ''

	cCpos := MontaChv(aPosChv, aDataCab) //campos chave da tabela pai

	Begin Transaction

		(cAliasT)->(DbGotop())
		Do While (cAliasT)->(!Eof())

			cChvPai := ''
			For Nx := 1 to len(aPosChv)
				cCampo := aDataCab[ aPosChv[nx] ]
				cChvPai += (cAliasT)->&cCampo
			Next
	
			nQtCpo := (cAliasT)->(FCount())

			aCabec := {}
			aItens := {}
	//monta o array da tabela cabeçalho para o execauto, com o primeiro registro da chave
			For Nx := 1 to nQtCpo
				cNomeCamp := AllTrim((cAliasT)->(FieldName(Nx)) )
		
				If Left(cNomeCamp,len(cLTab)) == cLTab .and. Right(cNOmeCamp,6) <> 'FILIAL' //se os campos sao da tabela principal(pai)
			
					AAdd( aCabec, { cNomeCamp    , (cAliasT)->&cNomeCamp , Nil } )
			
				Elseif cNomeCamp == 'LINHA'
					nLinE := (cAliasT)->LINHA
				Endif

			Next
	
			If Alltrim(cNameRot) == 'OMSA010' .or. Alltrim(cNameRot) == 'COMA010'
	
				If cNameRot == 'OMSA010'
					cCpoIte := "DA1_ITEM"
					cCodTab := (cAliasT)->DA0_CODTAB
				Else
					cCpoIte := "AIB_ITEM"
					cCodTab := (cAliasT)->AIA_CODTAB
				Endif
				cItem := Strzero(0,TamSX3(cCpoIte)[1])
		
				If (cTab)->(DbSeek( FwxFilial(cTab) + cChvPai ))
					cItem := fNumIte(cTabI, cCpoIte, cChvPai )
			
			//deleta registros de itens existentes								
					ExcItens( cCodTab )
		
				Endif
	
			Endif
	
			lTemIte := .F.
			nItens  := 0
			Do While (cAliasT)->(!Eof()) .and. (cAliasT)->&cCpos == cChvPai
	
				nItens++
		
				aAux := {}
				For Nx := 1 to nQtCpo
					cNomeCamp := AllTrim((cAliasT)->(FieldName(Nx)) )
			
					If cNomeCamp =='DA1_ITEM' .or. cNomeCamp == 'AIB_ITEM'
						lTemIte := .T.
					Endif
		
					If Left(cNomeCamp,len(cLTabI)) == cLTabI .and. Right(cNomeCamp,6) <> 'FILIAL' //se os campos sao da tabela itens
			
						AAdd( aAux, { cNomeCamp    , (cAliasT)->&cNomeCamp , Nil } )
				
					Endif

				Next
			
				If !lTemIte
					If Alltrim(cNameRot) == 'OMSA010'
				//nItem 
				//caso no CSV nao tenha o campo DA1_ITEM, incluo ele manualmente
						cItem := Soma1( cItem )
						AAdd( aAux, { "DA1_ITEM" ,cItem  , Nil } )
				
					Elseif Alltrim(cNameRot) == 'COMA010'
						cItem := Soma1( cItem )
						AAdd( aAux, { "AIB_ITEM" , cItem , Nil } )
					Endif
				Endif
				
				If	Len(aAux) > 0
					AAdd(aItens, aAux)
				Endif
		
				IncProc()
		
				If nItens == 500 .and. len(aCabec) > 0 .and. len(aItens) > 0 //quebrar de 500 em 500 itens a gravacao, dentro de uma mesma chave (ex: tab precos-> dentro do mesmo codigo de tabela)
					GravaDados(aCabec,aItens,cChvPai,cNameRot,nHdlLog, nLinE, nTpGrv)
					aItens := {}
					nItens := 0
				Endif
				
				(cAliasT)->(DbSkip())
					
			Enddo
		
			If len(aCabec) > 0 .and. len(aItens) > 0
				GravaDados(aCabec,aItens,cChvPai,cNameRot,nHdlLog, nLinE, nTpGrv)
			Endif
	
		Enddo

	End Transaction

Return

/*/{Protheus.doc} ExcItens
Exclusao dos Itens ja existentes
@author Giane
@since 13/11/2015
@version 1.0
@param cCodTab, character, (Descrição do parâmetro)
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
Static Function ExcItens( cCodTab )
	Local aAreaE  := GetArea()
	Local cAliasE := GetNextAlias()
	Local cCpoFil := cTabI + '_FILIAL'
	Local cCpoCod := cTabI + '_CODTAB'

	BeginSql Alias cAliasE
		SELECT
		R_E_C_N_O_ AS NREG
		FROM %Exp:cTabI%
		WHERE
		%Exp:(cCpoFil)% = %Exp:FwxFilial(cTabI)%
		AND %NotDel%
		AND %Exp:cCpoCod% = %Exp:cCodTab%
	EndSql

	Do While (cAliasE)->(!Eof())

		(cTabI)->(DbGoto( (cAliasE)->NREG ))
		(cTabI)->(DbDelete())
		(cTabI)->(MsUnlock())

		(cAliasE)->(DbSkip())
	Enddo

	(cAliasE)->(DbCloseArea())

	RestArea(aAreaE)
Return

/*/{Protheus.doc} GravaDados
Efetua o ExecAuto
@author Giane
@since 13/11/2015
@version 1.0
@param aCabec, array, (Descrição do parâmetro)
@param aItens, array, (Descrição do parâmetro)
@param cChvPai, character, (Descrição do parâmetro)
@param cNameRot, character, (Descrição do parâmetro)
@param nHdlLog, numérico, (Descrição do parâmetro)
@param nLinE, numérico, (Descrição do parâmetro)
@param nTpGrv, numérico, (Descrição do parâmetro)
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
Static Function GravaDados(aCabec,aItens,cChvPai,cNameRot,nHdlLog, nLinE, nTpGrv)
	Local oModel
	Local aMVC := {}
	Local nOpc := 3
	Local cArqErrAuto := ''
	Local cMsgErro := ''
	Local bBlockAuto := nil

	Private lMsErroAuto := .F.
	Private lMsHelpAuto := .T.

	oModel := FWLoadModel( cNameRot )

	If oModel <> nil
		aMVC := DadosModel(cNameRot)
	Endif

//verifica se ja existe o registro, para mandar opçao incluir ou alterar no execauto:
	If (cTab)->(DbSeek( FwxFilial(cTab) + cChvPai ))
		nOpc := 4
		If !Empty(cTabI)
			(cTabI)->(DbSeek( FwxFilial(cTabI) + cChvPai ))
		Endif
	Endif
				
//Begin TransacTion
		
	If oModel <> NIL .and. len(aMVC) > 0 //significa que o cadastro está em MVC
		Processa({|| FAJMdlAuto( aCabec , aItens , nOpc , cNameRot , aMVC[1,2] , aMVC[1,4] , aMVC[1,3] ,aMVC[1,5]  ,.T. , NIL, nHdlLog, nLinE, nTpGrv)  }, 'TOTVS ImportCSV 1.0', 'Processando Rotina Automática...')
	
		//FAJMdlAuto( aCabec , aItens , nOpc , cNameRot , aMVC[1,2] , aMVC[1,4] , aMVC[1,3] ,aMVC[1,5]  ,.T. , NIL, nHdlLog, nLinE, nTpGrv)
																			
	Else
				
		lMsErroAuto := .F.
				
		bBlockAuto := {|X,Y,Z| &(cNameRot)(X,Y,Z)}
				
		Do Case
		Case Alltrim(cNameRot) == 'OMSA010' .Or. Alltrim(cNameRot) == 'COMA010'
			GrvRecLock(aCabec,aItens,cChvPai,cNameRot,nHdlLog, nLinE, nTpGrv)
				//MSExecAuto(bBlockAuto,nOpc,aCabec,aItens)
		Case Alltrim(cNameRot) == 'MATA120'
			MSExecAuto(bBlockAuto,1,aCabec,aItens,nOpc)
		Otherwise
			MSExecAuto(bBlockAuto,aCabec,aItens,nOpc)
		EndCase
		If lMsErroAuto
			DisarmTransaction()
			cArqErrAuto 	:= NomeAutoLog()
			cMsgErro 		:= Memoread(cArqErrAuto)
			Ferase(cArqErrAuto)
			UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero(nLinE, 5) + '] INCONSISTENCIA NA IMPORTACAO DOS DADOS. DETALHE DO ERRO: ' + Chr(13) + Chr(10) + cMsgErro + Chr(13) + Chr(10))
											
		Endif
	Endif
				
//End Transaction

Return


/*/{Protheus.doc} GrvRecLock
Grava import de registros utilizando reclock
@author Ana Utsumi
@since 20/05/2016
@version 1.0
@param aCabec, array, (Descrição do parâmetro)
@param aItens, array, (Descrição do parâmetro)
@param cChvPai, character, (Descrição do parâmetro)
@param cNameRot, character, (Descrição do parâmetro)
@param nHdlLog, numérico, (Descrição do parâmetro)
@param nLinE, numérico, (Descrição do parâmetro)
@param nTpGrv, numérico, (Descrição do parâmetro)
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
Static Function GrvRecLock(aCabec,aItens,cChvPai,cNameRot,nHdlLog, nLinE, nTpGrv, nSobrIt, aLin)
	Local lAchouCab		:= .F.
	Local lAchouItem	:= .F.
	Local lContinua		:= .T.
	Local cCampoFil		:= ''
	Local lErro 		:= .F.
	Local cItem			:= 0
	Local bBlockAuto 	:= nil
	Local nX			:= 0
	Local nY			:= 0
	Local cConteudo		:= ''
	Local nLenIt		:= ''
	Local nPosItem	:= 0
	Local cItem		:= ''
	Local nTamLIn		:= 0

	Private cMsgErro	:= ''
	Private lMsErroAuto := .F.
	Private lMsHelpAuto := .T.

	Default nSobrIt := 2
	Default aLin := {}
	
	nTamLin := Len(aLin)

//Validações
	Do Case
	Case Alltrim(cNameRot) == 'OMSA010'
		nX := 1
		While cConteudo = '' .and. nX <= Len(aCabec)
			If (aCabec[nX][1]) == 'DA0_CONDPG'
				cConteudo := aCabec[nX][2]
			Else
				nX++
			EndIf
		EndDo
		
		If !Empty(cConteudo)
			If !ExistCpo("SE4", cConteudo,1)
				lErro := .T.
				cMsgErro := 'Condição de pagamento não cadastrada.'
				UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero(nLinE, 5) + '] INCONSISTENCIA NA IMPORTACAO DOS DADOS. DETALHE DO ERRO: ' + Chr(13) + Chr(10) + cMsgErro + Chr(13) + Chr(10))
			Endif
		Endif
/*		If !ExistCpo("SE4", cConteudo,1) 
			lErro := .T.
			cMsgErro := 'Condição de pagamento não cadastrada.'
			UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero(nLinE, 5) + '] INCONSISTENCIA NA IMPORTACAO DOS DADOS. DETALHE DO ERRO: ' + Chr(13) + Chr(10) + cMsgErro + Chr(13) + Chr(10))
		Endif */	
	Case Alltrim(cNameRot) == 'COMA010'

		For nX := 1 To Len(aCabec)
			If aCabec[nX][1] == "AIA_CODFOR"
				cCodFor := aCabec[nX][2]
			ElseIf aCabec[nX][1] == "AIA_LOJFOR"
				cLojFor := aCabec[nX][2]
			ElseIf aCabec[nX][1] == "AIA_CONDPG"
				cCondPag := aCabec[nX][2]
			ElseIf aCabec[nX][1] == "AIB_ITEM"
				nPosItem := nX
			EndIf
		Next nX

		If !ExistCpo("SA2", cCodFor + cLojFor,1)
			lErro := .T.
			cMsgErro := 'Fornecedor não cadastrado.'
			UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero(nLinE, 5) + '] INCONSISTENCIA NA IMPORTACAO DOS DADOS. DETALHE DO ERRO: ' + Chr(13) + Chr(10) + cMsgErro + Chr(13) + Chr(10))
		Endif
		If !Empty(cCondPag)
			If !ExistCpo("SE4", cCondPag,1)
				lErro := .T.
				cMsgErro := 'Condição de pagamento não cadastrada.'
				UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero(nLinE, 5) + '] INCONSISTENCIA NA IMPORTACAO DOS DADOS. DETALHE DO ERRO: ' + Chr(13) + Chr(10) + cMsgErro + Chr(13) + Chr(10))
			Endif
		EndIf
/*		If !ExistCpo("SE4", AIA->AIA_CONDPG,1) 
			lErro := .T.
			cMsgErro := 'Condição de pagamento não cadastrada.'
			UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero(nLinE, 5) + '] INCONSISTENCIA NA IMPORTACAO DOS DADOS. DETALHE DO ERRO: ' + Chr(13) + Chr(10) + cMsgErro + Chr(13) + Chr(10))
		Endif	*/
	EndCase

	If !lErro
		//verifica se ja existe a tabela de precos
		If (cTab)->(DbSeek( FwxFilial(cTab) + cChvPai ))
			lAchouCab := .T.
		Endif

		If !lAchouCab
			RecLock(cTab,.T.)
			cCampoFil := cTab + '_FILIAL'
			(cTab)->&cCampoFil := xFilial(cTab)
			
			For nX = 1 to Len(aCabec)
				(cTab)->&(aCabec[nX][1])	:= aCabec[nX][2]
			Next
			(cTab)->(MsUnlock())
			
		//Else
			/*
			lErro := .T.
			cMsgErro := 'Registro já existe.'
			UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero(nLinE, 5) + '] INCONSISTENCIA NA IMPORTACAO DOS DADOS. DETALHE DO ERRO: ' + Chr(13) + Chr(10) + cMsgErro + Chr(13) + Chr(10))
			*/
		Endif

		If !lErro
		//Grava dados do cabeçalho

			For nX = 1 to Len(aItens)
			
				If nTamLin >= nX
					nLinE := aLin[nx]
				Endif
	
				Do Case
				Case Alltrim(cNameRot) == 'OMSA010'
					nY := 1
					cConteudo := ''
					While cConteudo = '' .and. nY <= Len(aCabec)
						If (aItens[nX][nY][1]) == 'DA1_CODPRO'
							cConteudo := aItens[nX][nY][2]
						Else
							nY++
						EndIf
					EndDo
					
					cCodProd := cConteudo
					If !ExistCpo("SB1", cConteudo,1)
						lErro := .T.
						cMsgErro := 'Produto não cadastrado.'
						UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero(nLinE, 5) + '] INCONSISTENCIA NA IMPORTACAO DOS DADOS. DETALHE DO ERRO: ' + Chr(13) + Chr(10) + cMsgErro + Chr(13) + Chr(10))
					Endif
					
				Case Alltrim(cNameRot) == 'COMA010'
					//verifica se o produto existe no SB1
					aItAtu := aItens[nX]
					nLenIt := Len (aItAtu)
					For nY := 1 To nLenIt
						If aItAtu[nY][1] == "AIB_CODPRO"
							cCodProd := aItAtu[nY][2]
							Exit
						EndIf
					Next nY
					
					lErro := .F.
					If !ExistCpo("SB1", cCodProd,1)
						lErro := .T.
						cMsgErro := 'Produto não cadastrado.'
						UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero(nLinE, 5) + '] INCONSISTENCIA NA IMPORTACAO DOS DADOS. DETALHE DO ERRO: ' + Chr(13) + Chr(10) + cMsgErro + Chr(13) + Chr(10))
					Endif

				EndCase
		
				If !lErro
				
					If cNameRot == 'COMA010'
						AIB->(dbSetOrder(2))
						lExist := AIB->(dbSeek( FwxFilial("AIB") + AIA->AIA_CODFOR + AIA->AIA_LOJFOR + AIA->AIA_CODTAB + cCodProd ))
					Else
						DA1->(DbSetOrder(1))
						lExist := DA1->(dbSeek( FwxFilial("DA1") + DA0->DA0_CODTAB + cCodProd ))						
					Endif 
					
					If !lExist
						//produto nao existe ainda na tabela
						RecLock(cTabI,.T.)
						Do Case
						Case Alltrim(cNameRot) == 'OMSA010'
							DA1->DA1_FILIAL	:= FwxFilial("DA1")
							DA1->DA1_CODTAB	:= DA0->DA0_CODTAB
							DA1->DA1_ATIVO 	:= '1'
							
														
							cItem := fNumIte(cTabI, "DA1_ITEM", cChvPai )
							cItem := Soma1(cItem)
						
							(cTabI)->DA1_ITEM := cItem	
						Case Alltrim(cNameRot) == 'COMA010'
							AIB->AIB_FILIAL	:= FwxFilial("AIB")
							AIB->AIB_CODFOR := AIA->AIA_CODFOR
							AIB->AIB_LOJFOR := AIA->AIA_LOJFOR
							AIB->AIB_CODTAB	:= AIA->AIA_CODTAB
							
							cItem := fNumIte(cTabI, "AIB_ITEM", cChvPai )
							cItem := Soma1(cItem)
						
							(cTabI)->AIB_ITEM := cItem							
						EndCase											
						
						//Grava dados do item
						For nY = 1 to Len(aItens[1])
							If !(nPosItem > 0 .and. nPosItem == nY) 
				
								(cTabI)->&(aItens[nX][nY][1]) := aItens[nX][nY][2]
							Endif
						Next
						(cTabI)->(MsUnlock())
					Else
	
						If nSobrIt == 1  
							//sobrepoe os dados do produto que ja existe na tabela de preco
							RecLock(cTabI,.F.)		
												
							For nY = 1 to Len(aItens[1])
								If !(nPosItem > 0 .and. nPosItem == nY) //se existir o campo AIB_ITEM no CSV, nao grava 																										
									(cTabI)->&(aItens[nX][nY][1]) := aItens[nX][nY][2]
								Endif
							Next
							(cTabI)->(MsUnlock())
						
						Else
							//lErro := .T.
							cMsgErro := 'Produto ' + cCodProd + ' já existe na tabela de preço, e não será sobreposto.'
							UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero(nLinE, 5) + '] NÃO IMPORTADA. DETALHE: ' + Chr(13) + Chr(10) + cMsgErro + Chr(13) + Chr(10))
							
						Endif						
					Endif	
				EndIf
				
				
			Next nX
		EndIf
	EndIf

Return



/*/{Protheus.doc} fNumIte
Pega ultimo item existente na tabela
@author Giane
@since 11/11/2015
@version 1.0
@param cTab, character, (Descrição do parâmetro)
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
Static Function fNumIte(cTabI, cCampo, cCod)
	Local aAreaN := GetArea()
	Local cAliasN := GetNextAlias()
	Local cCpoFil := cTabI + '_FILIAL'
	Local cCpoTab := cTabI + '_CODTAB'
	Local cCpoFor := cTabI + '_CODFOR'
	Local cCpoLoj := cTabI + '_LOJFOR'
	Local cRet		:= ''
	Local cQry := ''

	cQry := "SELECT MAX(" + cCampo + ") AS UITEM "
	cQry += "FROM " + RetSqlName(cTabI) + " "
	cQry += "WHERE "
	cQry += cCpoFil + " = '" + Fwxfilial(cTabI) + "' "
	cQry += "	AND " + cCpoTab + " = '" + Right(cCod,3)+ "' "
	
	If cTabI == "AIB"
		cQry += "  AND " + cCpoFor +  " = '" + Left(cCod,6)+ "' "
		cQry += "  AND " + cCpoLoj +  " = '" + Substr(cCod,7,2)+ "' "
	Endif
	cQry += "	AND D_E_L_E_T_ = ' ' "

	DbUseArea(.T., "TOPCONN", TCGENQRY(,,cQry), cAliasN, .F., .T.)

	cRet := (cAliasN)->UITEM
	(cAliasN)->(dbCloseArea())

	RestArea(aAreaN)
Return cRet

/*/{Protheus.doc} MovEnd
Efetua endereçamentos
@author Giane
@since 05/10/2015
@version 1.0
@param aEnd, array, (Descrição do parâmetro)
@param nHdlLog, numérico, (Descrição do parâmetro)
@param nQtdD5, numérico, (Descrição do parâmetro)
@param nQtdB9, numérico, (Descrição do parâmetro)
@param lRastro, ${param_type}, (Descrição do parâmetro)
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
Static Function MovEnd(aEnd,nHdlLog, nQtdD5, nQtdB9, lRastro)
	Local aArea := GetArea()
	Local nx := 0
	Local aMVC := {}
	Local lTemEnd := .T.
	Local aItEnd  := {}
	Local aCbEnd  := {}
	Local aExEnd := {}
	Local cChvLote := ''
	Local nLin := 0
	Local nQtd := 0
	Local cAliasE
	Local cQry := ''

	If Len(aEnd) > 0
	
	//verifica se os endereços ja estao cadastrados, senao inclui os mesmos
		aMVC := DadosModel("MATA015")//cadastro de enderecos SBE
	
		SBE->(DbSetOrder(1))
		For Nx := 1 to Len(aEnd)
	
			If cChvLote <> aEnd[nx,1] + aEnd[nx,2] + aEnd[nx,3]
		
				If Len(aItEnd) > 0
					GrvEnd(aCbEnd,aItEnd, nHdlLog, nQtdD5, nQtdB9, lRastro,nLin, nQtd)
				Endif
			
				cChvLote := aEnd[nx,1] + aEnd[nx,2] + aEnd[nx,3]
				nLin := aEnd[Nx,6]
				nQtd := 0
					
				aItEnd  := {}
				aCbEnd  := {}
			//verifica se ja existe saldo a enderecar para o produto, local, lote
			//ja deve existir pois as rotinas mata220 e mata390 devem ter inserido automaticamente no SDA
			
				cAliasE := GetNextAlias()
			
				cQry := "SELECT ISNULL(SDA.R_E_C_N_O_,0) NREG "
				cQry += "FROM " + RetSqlName("SDA") + " SDA "
				cQry += "WHERE "
				cQry += " DA_FILIAL = '" + FwxFilial("SDA") + "' "
				cQry += "  AND SDA.DA_PRODUTO = '" + aEnd[nx,1] + "' "
				cQry += "	AND SDA.DA_LOCAL = '" + aEnd[nx,2] + "' "
				cQry += "	AND SDA.DA_LOTECTL = '" + aEnd[nx,3] + "' "
				cQry += "	AND SDA.D_E_L_E_T_ = ' ' "

				DbUseArea(.T., "TOPCONN", TCGENQRY(,,cQry), cAliasE, .F., .T.)
			
				If (cAliasE)->NREG == 0
					lTemEnd := .F.
				Else
					SDA->(DbGoto((cAliasE)->NREG))
				Endif
			
				(cAliasE)->(DbCloseArea())
			
			/*SDA->(DbSetOrder(2)) //FILIAL + PRODUTO + LOCAL + LOTECTL
			If !SDA->(DbSeek( FwxFilial("SDA") + aEnd[nx,1] + aEnd[nx,2] + aEnd[nx,3] ))
				lTemEnd := .F.
			Endif
			*/
		
			Endif
	
			If !SBE->(DbSeek( FwxFilial("SBE") + aEnd[Nx,2] + aEnd[Nx,4] ))
				aExEnd := { {"BE_LOCAL" , aEnd[nx,2],nil},;
					{"BE_LOCALIZ", aEnd[nx,4],nil},;
					{"BE_DESCRIC", aEnd[nx,4],nil}}
			            
				If !FAJMdlAuto( aExEnd , {} , 3 , 'MATA015' , aMVC[1,2] , NIL , aMVC[1,3] ,  ,.T. , NIL, nHdlLog, aEnd[Nx,6]) //inclui endereco se ainda nao existir
					lTemEnd := .F.
				Endif
			Endif
		
			If lTemEnd .and. aEnd[Nx,5] > 0 //qtdade a enderecar
				nQtd += aEnd[Nx,5]
			
				AAdd(aItEnd, {{"DB_ITEM"		, StrZero(nX, Len(SDB->DB_ITEM))	, NIL},;
					{"DB_PRODUTO"	, SDA->DA_PRODUTO						, NIL},;
					{"DB_LOCAL"	, SDA->DA_LOCAL						, NIL},;
					{"DB_LOCALIZ"	, aEnd[Nx,4]							, NIL},;
					{"DB_QUANT"	, aEnd[Nx,5]							, NIL},;
					{"DB_DATA"		, dDataBase							, NIL},;
					{"DB_NUMSERI"	, aEnd[Nx,7]							, NIL},;
					{"DB_LOTECTL"	, aEnd[Nx,3]							, NIL}} )
									
			Endif
		
		Next

		If Len(aItEnd) > 0
			GrvEnd(aCbEnd,aItEnd, nHdlLog, nQtdD5, nQtdB9, lRastro,nLin, nQtd)
		Endif

	Endif

	RestArea(aArea)
Return

/*/{Protheus.doc} GrvEnd
Roda execauto de endeçamento
@author Giane
@since 06/10/2015
@version 1.0
@param aCbEnd, array, (Descrição do parâmetro)
@param aItEnd, array, (Descrição do parâmetro)
@param nHdlLog, numérico, (Descrição do parâmetro)
@param nQtdD5, numérico, (Descrição do parâmetro)
@param nQtdB9, numérico, (Descrição do parâmetro)
@param lRastro, ${param_type}, (Descrição do parâmetro)
@param nLin, numérico, (Descrição do parâmetro)
@param nQtd, numérico, (Descrição do parâmetro)
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
Static Function GrvEnd(aCbEnd,aItEnd,nHdlLog, nQtdD5, nQtdB9, lRastro,nLin, nQtd)
	Local cArqErrAuto := ''
	Local cMsgErro := ''

	Private lMSErroAuto := .F.

//existem qtdes a enderecar
	If lRastro .and.  nQtd > nQtdD5
	//qtde total a endereçar nao pode ser diferente da qtde do lote
		UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero(nLin, 5) + '] INCONSISTENCIA NA IMPORTACAO DOS DADOS. 	QTDE A ENDEREÇAR ESTA MAIOR QUE A QTDE DO LOTE.' )
	Elseif !lRastro .and. nQtd > nQtdB9
		UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero(nLin, 5) + '] INCONSISTENCIA NA IMPORTACAO DOS DADOS. 	QTDE A ENDEREÇAR ESTA MAIOR QUE A QTDE DO SALDO INICIAL.' )
	Else
	//EFETUAR ENDERECAMENTO
	
		aCbEnd  := {	{"DA_PRODUTO"	, SDA->DA_PRODUTO	, NIL},;
			{"DA_LOCAL"	, SDA->DA_LOCAL	, NIL},;
			{"DA_NUMSEQ"	, SDA->DA_NUMSEQ	, NIL},;
			{"DA_DOC"		, SDA->DA_DOC		, NIL},;
			{"DA_SERIE"	, SDA->DA_SERIE	, NIL},;
			{"DA_LOTECTL"	, SDA->DA_LOTECTL	, NIL}}
					//{"DA_QTDORI"	, nQtd				, NIL},;
									
		lMSErroAuto := .F.
	
		MATA265(  aCbEnd, aItEnd, 3)
						
	//MSExecAuto({|x,y,z| MATA265(x,y,z)}, aCbEnd, aItEnd, 3)
		If lMsErroAuto
			DisarmTransaction()
			cArqErrAuto 	:= NomeAutoLog()
			cMsgErro 		:= Memoread(cArqErrAuto)
			Ferase(cArqErrAuto)
			UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero(nLin, 5) + '] INCONSISTENCIA NA IMPORTACAO DOS DADOS. DETALHE DO ERRO: ' + Chr(13) + Chr(10) + cMsgErro + Chr(13) + Chr(10))
		Endif
								
	Endif
Return

/*/{Protheus.doc} MovLote
Efetua movimentos dos lotes
@author Giane
@since 05/10/2015
@version 1.0
@param aLotesIni, array, (Descrição do parâmetro)
@param nQtdB9, numérico, (Descrição do parâmetro)
@param nQtdD5, numérico, (Descrição do parâmetro)
@param nLinL, numérico, (Descrição do parâmetro)
@param nHdlLog, numérico, (Descrição do parâmetro)
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
Static Function MovLote(aLotesIni, nQtdB9, nQtdD5, nLinL, nHdlLog)
	Local aArea := GetArea()
	Local Nx := 0
	Local cArqErrAuto := ''
	Local cMsgErro := ''
	Local lRet := .T.
	Local lA390QTD  := SuperGetMv("MV_A390QTD",.F.,.F.) //se lA390QTD = .T. entao só pode ter 1 lote, senao pode haver varios
	Local aLote := {}
	Local nDoc := 0
	Local cDoc := ''

	Private lMsErroAuto := .F.

	If Len(aLotesIni) > 0

		If lA390QTD .and. Len(aLotesIni) > 1
		//se aceita somente 1 lote, mas no aLotesIni existem varios lotes, entao dados estao inconsistentes
			UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero(nLinL, 5) + '] INCONSISTENCIA NA IMPORTACAO DOS DADOS. INCONSISTENCIA NOS LOTES INFORMADOS PARA O PRODUTO. ')
			lRet := .F.
		Else

			If nQtdD5 > nQtdB9
				UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero(nLinL, 5) + '] INCONSISTENCIA NA IMPORTACAO DOS DADOS. INCONSISTENCIA NAS QTDES DOS LOTES PARA O PRODUTO. ')
				lRet := .F.
			Else
				nDoc := 0
				For nX := 1 to Len(aLotesIni)
					lMsErroAuto := .F.
				
					aLote := aLotesIni[nx]
				
					nDoc++
					cDoc := Strzero(nDoc,TamSX3("D5_DOC")[1])
				
					aadd(aLotesIni[nx], {"D5_DOC"	, cDoc			, NIL} )
				
					MSExecAuto({|x,y| Mata390(x,y)}, aLotesIni[nx], 3)
					If lMsErroAuto
						DisarmTransaction()
						cArqErrAuto 	:= NomeAutoLog()
						cMsgErro 		:= Memoread(cArqErrAuto)
						Ferase(cArqErrAuto)
						UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero(nLinL, 5) + '] INCONSISTENCIA NA IMPORTACAO DOS DADOS. DETALHE DO ERRO: ' + Chr(13) + Chr(10) + cMsgErro + Chr(13) + Chr(10))
						lRet := .F.
					Endif
				
				Next
			Endif
		Endif
	Endif
	RestArea(aArea)
Return lRet

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
	Local cIndice := ''
	Local nOrdem  := 0
	Local nLen    := 0
	Local cChave  := ''
 
	cQuery := "SELECT  COUNT(*) COUNTREGS FROM " + RetSqlName(cTabela) + " WHERE D_E_L_E_T_ <> '*' "

	if lCsvSemColunaFilial
		if substr(cTabPos,1,1) == "S"
			cQuery += (" AND " + substr(cTabPos,2,2)  + "_FILIAL = '" + xfilial(cTabPos) + "'" )
			cIndice += substr(cTabPos,2,2)  + "_FILIAL+"
		else
			cQuery += (" AND " + cTabPos + "_FILIAL = '" + xfilial(cTabPos) + "'" )
			cIndice += cTabPos + "_FILIAL+"
		endif
	endif

	for nCot := 1 to Len(aCposKey)
		nIndex := aScan( aMsExcAuto, { |x| AllTrim( x[1]) == aCposKey[nCot]  } )

	//no aCposKey temos o campo de filial mas não iremos exigir que exista a coluna filial no CSV
		if nIndex  > 0
			cQuery += (" AND " + aCposKey[nCot] + "  = '" + aMsExcAuto[nIndex][2] + "'" )
			cIndice += aCposKey[nCot] + IIf(nCot < len(aCposKey),"+",'')
			cChave += aMsExcAuto[nIndex][2]

		endif
	Next

	cQuery := changequery(cQuery)

	dbUseArea( .t., "TOPCONN", TCGenQry(,,cQuery), cAlias, .f., .t. )

//verifica se o intervalo do registro atual está contido dentro de outro intervalo existente para a respectiva linha
//	if (cAlias)->( !EOF() )
	if (cAlias)->(COUNTREGS) > 0
		lRet := .T.
			
			//pega o indice da tabela, e posiciona no registro a ser alterado:
		nLen := len(cIndice)
		SIX->(DbSeek( cTabela  ))
		Do While SIX->(!eof()) .and. SIX->INDICE == cTabela
			If Padr(SIX->CHAVE, nLen) == cIndice
				nOrdem := VAL(SIX->ORDEM)
				Exit
			Endif
				
			SIX->(DbSkip())
		Enddo
			
		If nOrdem > 0
			(cTabela)->(DbSetOrder(nOrdem))
			(cTabela)->(DbSeek( FwxFilial(cTabela) + cChave ))
		Endif
			
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
W       1  		1000	    1000   		1  		5	    237	    200	20140801	   ENDA1	49,25
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
	aRegLido[11]:= STRTRAN (aRegLido[11], ',' , "." , 1 , 1 )

	if (nLinha ) > nUltLinha //leu a última linha do arquivo!

		//                      B9_COD	    B9_LOCAL	    B9_QINI	       B9_QISEGUM	     B9_VINI1	     B9_CM1	         LOTECTL	      QTDE	        DTVALID      	LOCALIZ   	QTDE
		Aadd (aLstLotesEndr,  {aRegLido[1],aRegLido[2],Val(aRegLido[3]), Val(aRegLido[4]),Val(aRegLido[5]),Val(aRegLido[6]), aRegLido[7] ,Val(aRegLido[8]),aRegLido[9], aRegLido[10], Val(aRegLido[11])} )

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
		Aadd (aLstLotesEndr,  {aRegLido[1],aRegLido[2],Val(aRegLido[3]), Val(aRegLido[4]),Val(aRegLido[5]),Val(aRegLido[6]), aRegLido[7] ,Val(aRegLido[8]),aRegLido[9], aRegLido[10], Val(aRegLido[11])} )

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

	if (cAlias)->(Eof())
		reclock('SBE',.T.)
		SBE->BE_FILIAL := xfilial('SBE')
		SBE->BE_LOCAL  := aLstLotesEndr[nCount][2]
		SBE->BE_LOCALIZ:= aLstLotesEndr[nCount][10]
		SBE->BE_PRIOR  := 'ZZZ'
		SBE->BE_STATUS := '2'//status de "ocupado"
		SBE->BE_DATGER := Date()
		MsUnlock()
	endif

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
			if lTemLote .or. lTemEnder //giane alterou em 30/09
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
				{"D5_QUANT"		, aLstLotesEndr[nIndex][11]	, NIL} ,;
				{"D5_LOTECTL"	, aLstLotesEndr[nIndex][7]	, NIL} ,;
				{"D5_NUMLOTE"	, aLstLotesEndr[nIndex][7]	, NIL} } )

		else
		//acumula qtdes
			aLotesIni[nPos][6][2] += aLstLotesEndr[nIndex][11]
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
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


//Static Function StructAtual (nHdlLog,nUltLinha, nLinha, aRegLido, cArqErrAuto, cErrAuto,nTipoData)
Static Function StructAtual (nHdlLog, nLinha, aRegLido, cArqErrAuto, cErrAuto,nTipoData)
	aRegLido[3] := STRTRAN ( aRegLido[3], ',' , "." , 1 , 1 )

	if AllTrim(cStructAnt) != AllTrim(aRegLido[1])
		cStructAnt := aRegLido[1]

		InsereStruct(3, cArqErrAuto, cErrAuto,nHdlLog, nTipoData)
		Aadd (aLstStruct,  {aRegLido[1],aRegLido[2], Val(aRegLido[3]), aRegLido[4],aRegLido[5], nLInha } )         //aRegLido[6],
	else

		Aadd (aLstStruct,  {aRegLido[1],aRegLido[2], Val(aRegLido[3]), aRegLido[4],aRegLido[5], nLInha} ) //aRegLido[6],

		//if (nLinha + 1) > nUltLinha //leu a última linha do arquivo!
		//	InsereStruct(3, cArqErrAuto, cErrAuto,nHdlLog, nTipoData)
		//endif
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
				aadd(aGets,	{"G1_FIM"		,cTOD(aLstStruct[nCount][5])	,NIL})
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
				aadd(aGets,	{"G1_FIM"		,STOD(aLstStruct[nCount][5])	,NIL})
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

				if (aLstLotesEndr[1][3]) !=  nQtAux
					UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero((nLinha-1), 5) + '] INCONSISTENCIA NA SOMATORIA DOS LOTES PARA COM A QTDE TOTAL DO PRODUTO A SER IMPORTADO. VERIFIQUE O CSV!' + Chr(13) + Chr(10) )
					lRet := .F.
				endif
			endif

		else//se tem endereco (mas nao tem lote)
			nQtAux  := 0

			for nCount := 1  to Len(aLstLotesEndr)
				nQtAux += (aLstLotesEndr[nCount][11]  )
			next

			if (aLstLotesEndr[1][3]) !=  nQtAux
				UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero((nLinha-1), 5) + '] INCONSISTENCIA NA SOMATORIA DOS ENDERECOS PARA COM A QTDE TOTAL DO PRODUTO A SER IMPORTADO. VERIFIQUE O CSV!' + Chr(13) + Chr(10) )
				lRet := .F.
			endif

		endif

	endif

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

	/*
		aCabeAuto := {{"DA_PRODUTO" ,cAuxPrd ,Nil},;
					{"DA_LOCAL" ,cAuxLoc ,Nil},;
					{"DA_CLIFOR",'',Nil},;
					{"DA_LOJA"  ,'',Nil},;
					{"DA_DOC"   ,'',Nil},;
					{"DA_SERIE" ,'',Nil},;
					{"DA_NUMSEQ",'000001',Nil},;
					{"DA_LOTECTL",cAuxLt,Nil}}*/

			if !Empty(cNumSeq)
				for nCOunt := 1 to Len(aLstLotesEndr)

					if aLstLotesEndr[nCount][7] == cAuxLt

						reclock('SDB',.T.)
						SDB->DB_FILIAL   := XFILIAL('SDB')
						SDB->DB_ITEM   :=  strzero(nCOunt,4)
						SDB->DB_PRODUTO   := cAuxPrd
						SDB->DB_LOCAL   := cAuxLoc
						SDB->DB_LOCALIZ   := aLstLotesEndr[nCount][10]

						IF lTemLote
							SDB->DB_DOC  := '000000001'
						ENDIF

						SDB->DB_SERIE   := ''
						SDB->DB_CLIFOR   := ''
						SDB->DB_LOJA   := ''
						SDB->DB_TM   := '499'

						IF lTemLote
							SDB->DB_ORIGEM   := 'SD5'
						ELSE
							SDB->DB_ORIGEM   := 'SB9'
						ENDIF

						SDB->DB_QUANT   := aLstLotesEndr[nCount][11]
						SDB->DB_DATA  := Date()


						IF lTemLote
							SDB->DB_LOTECTL   := cAuxLt
						ENDIF

						SDB->DB_NUMSEQ   := cNumSeq//'000001'
						SDB->DB_NUMSERI   := ''
						SDB->DB_TIPO   := 'D'
						SDB->DB_SERVIC   := '499'
						SDB->DB_ATIVID   := 'ZZZ'
						SDB->DB_ATUEST   := 'S'
						SDB->DB_STATUS   := 'M'
						SDB->DB_ORDATIV  := 'ZZ'
						SDB->DB_HRINI    := Time()
						MsUnLock()
					                          /*
					aItemEnde := Nil
					aItemAuto := Nil
					aItemAuto := {}
					aItemEnde :={{"DB_ITEM"   ,'0001', Nil},;
								 {"DB_LOCALIZ",aLstLotesEndr[nCount][10],Nil},;
								 {"DB_QUANT"  ,aLstLotesEndr[nCount][11], Nil},;
								 {"DB_LOTECTL",aLstLotesEndr[nCount][7],Nil},;
								 {"DB_DTVALID",Date(),Nil},;
								 {"DB_NUMSERI",'',Nil},;
								 {"DB_DATA"   ,Date(),Nil}}

					aAdd(aItemAuto,aItemEnde)

					lMsErroAuto := .F.
					MSExecAuto({|x,y,z|Mata265(x,y,z)},aCabeAuto,aItemAuto,3)

					If lMsErroAuto
						cArqErrAuto := NomeAutoLog()
						cErrAuto    := Memoread(cArqErrAuto)
						Ferase(cArqErrAuto)

						UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero(nLinha, 5) + '] Erro ao executar execauto MATA265: ' + cErrAuto + Chr(13) + Chr(10) )
				    	lRet := .F.
				    	lFlag := .F.
				    	exit

					endif                   */

					endif
				Next

			endif

	//    if lFlag == .F.
	//    	exit
	//    endif
		Next
	else
		for nLtCount := 1 to Len(aLstLOtesEndr) //somatória dos endereços ...agtinado por LOTE
			lMsErroAuto := .F.

			cAuxPrd := aLstLOtesEndr[nLtCount][1]
			cAuxLoc := aLstLOtesEndr[nLtCount][2]
			cAuxLt  := ''//aLotesIni[nLtCount][7][2]
			cQtAux  := aLstLOtesEndr[nLtCount][11]

			cNumSeq := SDAGerPeloExecAuto(cAuxPrd, cAuxLoc, '')
			if !Empty(cNumSeq)

				reclock('SDB',.T.)
				SDB->DB_FILIAL   := XFILIAL('SDB')
				SDB->DB_ITEM   :=  strzero(nLtCOunt,4)
				SDB->DB_PRODUTO   := cAuxPrd
				SDB->DB_LOCAL   := cAuxLoc
				SDB->DB_LOCALIZ   := aLstLotesEndr[nLtCount][10]

			//qdo nao temos lotes existem campos da SDB que nao sao alimentados ...diferente de qdo tem lote

				SDB->DB_SERIE   := ''
				SDB->DB_CLIFOR   := ''
				SDB->DB_LOJA   := ''
				SDB->DB_TM   := '499'

				SDB->DB_ORIGEM   := 'SB9'

				SDB->DB_QUANT   := aLstLotesEndr[nLtCount][11]
				SDB->DB_DATA  := Date()

				SDB->DB_NUMSEQ   := cNumSeq//'000001'
				SDB->DB_NUMSERI   := ''
				SDB->DB_TIPO   := 'D'
				SDB->DB_SERVIC   := '499'
				SDB->DB_ATIVID   := 'ZZZ'
				SDB->DB_ATUEST   := 'S'
				SDB->DB_STATUS   := 'M'
				SDB->DB_ORDATIV  := 'ZZ'
				SDB->DB_HRINI    := Time()
				MsUnLock()

			endif

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

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    FAJMdlAuto Autor ³Caio Murakami          ³ Data ³18.02.2013³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Executa operacoes do model pai/filho                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FAJMdlAuto()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³       													  ³±±
±±³          ³ ExpA1 = Array com campos e valores do cabecalho            ³±±  
±±³          ³ ExpA2 = Array com campos e valores do grid                 ³±±  
±±³          ³ ExpN1 = Operacao do modelo                                 ³±± 
±±³          ³ ExpC1 = Nome do Model                                      ³±±  
±±³			 ³ ExpC2 = Nome do model cabecalho (FIELD)                    ³±±
±±³          ³ ExpC3 = Nome do model detalhe   (GRID)                     ³±± 
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±  
±±³ Uso      ³ TMSAO35                                                    ³±±  
±±³          ³ TMSA350                                                    ³±±  
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/

Static Function FAJMdlAuto( aCpoMaster , aCpoDetail , nOpc , cModel , cMaster , cDetail , cAliasMast , cAliasGrid ,lExibErro , nReg, nHdlLog, nLinha, nTpGrv )
	Local oModel, oAux, oStruct
	Local nI 		:= 0
	Local nJ 		:= 0
	Local nPos 		:= 0
	Local lRet 		:= .T.
	Local aAux 		:= {}
	Local aC 			:= {}
	Local aH 			:= {}
	Local nItErro 	:= 0
	Local lAux 		:= .T.
	Local lGrid		:= .F.
	Local aArea		:= GetArea()
	Local cArqErrAuto := ''
	Local cIndice 	:= ''
	Local cTime     := Time()
	Local nTamDet    := len(aCpoDetail)
	
	Default cDetail 	:= ""
	Default aCpoDetail	:= {}
	Default cAliasGrid	:= ""
	Default lExibErro	:= .T.
	Default nReg		:= 0
	DeFault nTpGrv 	:= 2 //nao sobrescreve dados do cabecalho caso ja exista

	If !Empty(cDetail)
		lGrid	:= .T.
	EndIf

	If lGrid .and. nOpc == MODEL_OPERATION_INSERT
		dbSelectArea( cAliasGrid )
		dbSetOrder( 1 )
	EndIf

	If nOpc == MODEL_OPERATION_INSERT
		dbSelectArea( cAliasMast )
		dbSetOrder( 1 )
	Endif

	If nReg	> 0
		dbGoTo( nReg )
	EndIf

	ProcRegua(nTamDet)

// Aqui ocorre o instânciamento do modelo de dados (Model)
// Neste exemplo instanciamos o modelo de dados do fonte COMP022_MVC
// que é a rotina de manutenção de musicas

	oModel := FWLoadModel( cModel )


// Temos que definir qual a operação deseja: 3 – Inclusão / 4 – Alteração / 5 - Exclusão
	oModel:SetOperation( nOpc )

// Antes de atribuirmos os valores dos campos temos que ativar o modelo
	oModel:Activate()

// Instanciamos apenas a parte do modelo referente aos dados de cabeçalho
	oAux := oModel:GetModel( cMaster  )

// Obtemos a estrutura de dados do cabeçalho
	oStruct 	:= oAux:GetStruct()
	aAux 		:= oStruct:GetFields()


//-- Para operação que nao seja visualizacao, o registro pai deve estar posicionado 
	If lRet

		If nOpc == MODEL_OPERATION_INSERT .Or. !lGrid .or. (nOpc == MODEL_OPERATION_UPDATE .and. nTpGrv == 1)

			If (nOpc == MODEL_OPERATION_UPDATE .and. nTpGrv == 1)//esta alterando os dados do cabecalho
				SIX->(DbSetOrder(1))
				If SIX->(DbSeek(cAliasMast))
					cIndice := Alltrim(SIX->CHAVE)
				Endif
			Endif


			For nI := 1 To Len( aCpoMaster )
		
			// Verifica se os campos passados existem na estrutura do cabeçalho
				If ( nPos := aScan( aAux, { |x| AllTrim( x[3] ) == AllTrim( aCpoMaster[nI][1] ) } ) ) > 0
				// È feita a atribuição do dado aos campo do Model do cabeçalho
					If !Empty(cIndice) .and. aCpoMaster[nI][1] $ cIndice
						loop //caso o campo seja chave e o registro ja existe, entao nao passar pelo setvalue para nao dar erro
					Endif
					If !( lAux := oModel:SetValue( cMaster , aCpoMaster[nI][1],aCpoMaster[nI][2] ) )
					// Caso a atribuição não possa ser feita, por algum motivo (validação, por exemplo)
					// o método SetValue retorna .F.
						lRet := .F.
					
						Exit
					EndIf
				EndIf
			
			Next
	
		EndIf
	
	EndIf

	If lRet .And. lGrid
	
	// Instanciamos apenas a parte do modelo referente aos dados do item
		oAux := oModel:GetModel( cDetail  )
	
	// Obtemos a estrutura de dados do item
		oStruct := oAux:GetStruct()
		aAux := oStruct:GetFields()
		nItErro := 0
	
	/*If nOpc == MODEL_OPERATION_UPDATE 
		For nI := 1 To oAux:Length()
			oAux:GoLine(nI)
			oAux:DeleteLine()
		Next nI
	EndIf
	*/
		For nI := 1 To nTamDet
	
			IncProc()
	
		// Incluímos uma linha nova se alteração 
			If nOpc == MODEL_OPERATION_UPDATE
		    
				oAux:AddLine()
		
		// ATENÇÃO: O itens são criados em uma estrutura de grid (FORMGRID), portanto já é criada uma primeira linha
		//branco automaticamente, desta forma começamos a inserir novas linhas a partir da 2ª vez	
			ElseIf  nOpc == MODEL_OPERATION_INSERT  .And. nI > 1
		
			// Incluímos uma nova linha de item
				If ( nItErro := oAux:AddLine(.T.) ) <> nI
		  		// Se por algum motivo o método AddLine() não consegue incluir a linha, // ele retorna a quantidade de linhas já // existem no grid. Se conseguir retorna a quantidade mais 1
					lRet := .F.
					Exit
				EndIf
			
			EndIf
	
		
			For nJ := 1 To Len( aCpoDetail[nI] )
		
	  		// Verifica se os campos passados existem na estrutura de item
				If ( nPos := aScan( aAux, { |x| AllTrim( x[3] ) == AllTrim( aCpoDetail[nI][nJ][1] ) } ) ) > 0
								
					If !( lAux := oModel:SetValue( cDetail, aCpoDetail[nI][nJ][1], aCpoDetail[nI][nJ][2] ) )
				
					// Caso a atribuição não possa ser feita, por algum motivo (validação, por exemplo)
					// o método SetValue retorna .F.
						lRet := .F.
						nItErro := nI
						Exit
					
					EndIf
			
				EndIf
			Next
		
					
			If !lRet
				Exit
			EndIf
		
		Next
	EndIf

	ConOut('Tempo validaçoes execauto: ' + ElapTime( cTime, Time() ) )

	cTime := Time()

	If lRet
	// Faz-se a validação dos dados, note que diferentemente das tradicionais "rotinas automáticas"
	// neste momento os dados não são gravados, são somente validados.
	
	//COnOut("MDLAUTO - Valid") 
		If nTamDet > 2000
					
			FwFormCommit(oModel)//CommitData()
			ConOut('Tempo FwFormCommit Model: ' + ElapTime( cTime, Time() ) )
		Else
			If ( lRet := oModel:VldData() )
		
				ConOut('Tempo VldData Model: ' + ElapTime( cTime, Time() ) )
		
			// Se o dados foram validados faz-se a gravação efetiva dos
			// dados (commit)
				cTime := Time()
			
				FwFormCommit(oModel)//CommitData()
				ConOut('Tempo FwFormCommit Model: ' + ElapTime( cTime, Time() ) )
			
				ConOut("MDLAuto - Commit ")
			EndIf
		Endif
	EndIf

	If !lRet //.And. lExibErro
  	//ConOut("MDLAuto - Erro") 
	// Se os dados não foram validados obtemos a descrição do erro para gerar
	// LOG ou mensagem de aviso
		aErro := oModel:GetErrorMessage()
	
	// A estrutura do vetor com erro é:
	// [1] identificador (ID) do formulário de origem
	// [2] identificador (ID) do campo de origem
	// [3] identificador (ID) do formulário de erro
	// [4] identificador (ID) do campo de erro
	// [5] identificador (ID) do erro
	// [6] mensagem do erro
	// [7] mensagem da solução
	// [8] Valor atribuído
	// [9] Valor anterior
	

		cArqErrAuto := "Id do formulário de origem:"+ ' [' + AllToChar( aErro[1] ) + ']' + Chr(13) + Chr(10)
		cArqErrAuto += "Id do campo de origem: " 	+ ' [' + AllToChar( aErro[2] ) + ']' + Chr(13) + Chr(10)
		cArqErrAuto += "Id do formulário de erro: " + ' [' + AllToChar( aErro[3] ) + ']' + Chr(13) + Chr(10)
		cArqErrAuto += "Id do campo de erro: " 		+ ' [' + AllToChar( aErro[4] ) + ']' + Chr(13) + Chr(10)
		cArqErrAuto += "Id do erro: " 				+ ' [' + AllToChar( aErro[5] ) + ']'  + Chr(13) + Chr(10)
		cArqErrAuto += "Mensagem do erro: " 		+ ' [' + AllToChar( aErro[6] ) + ']'  + Chr(13) + Chr(10)
		cArqErrAuto += "Mensagem da solução: " 		+ ' [' + AllToChar( aErro[7] ) + ']' + Chr(13) + Chr(10)
		cArqErrAuto += "Valor atribuído: " 			+ ' [' + AllToChar( aErro[8] ) + ']' + Chr(13) + Chr(10)
		cArqErrAuto += "Valor anterior: " 			+ ' [' + AllToChar( aErro[9] ) + ']'  + Chr(13) + Chr(10)
	
		UpdFileLog(nHdlLog, Chr(13) + Chr(10) + '[' + DtoC(Date()) + ' - ' + Time() + '] [LINHA: ' + StrZero(nLinha, 5) + '] INCONSISTENCIA NA IMPORTACAO DOS DADOS. DETALHE DO ERRO: ' + Chr(13) + Chr(10) + cArqErrAuto + Chr(13) + Chr(10))
	
		If nItErro > 0
			AutoGrLog( "Erro no Item: " + ' [' + AllTrim( AllToChar( nItErro ) ) + ']' )  //-- "Erro no Item: "
		EndIf
	
	//MostraErro()
	EndIf

// Desativamos o Model
	oModel:DeActivate()

	RestArea( aArea )
Return lRet

/*/{Protheus.doc} DadosModel
Função tem as definicoes de rotinas que foram desenvolvidas em MVC, necessarias para a gravação dos dados
@author Giane
@since 30/09/2015
@version 1.0
@param cNameRot, character, (Nome da rotina padrao)
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
Static Function DadosModel(cNameRot)
	Local aRet    := {}
	Local aRotMVC := {}
	Local nPos    := 0

//            {rotina padrao, nome do master em MVC, nome da tabela}
	aadd(aRotMVC, {'MATA370','SA7MASTER' ,'SA7',nil,nil} )
	aadd(aRotMVC, {'MATA015',"MdFieldSBE",'SBE',nil,nil} )
//aadd(aRotMVC, {'OMSA010',"DA0MASTER" ,'DA0','DA1DETAIL','DA1'} ) --> rotina será executa com reclock
	aadd(aRotMVC, {'MATA061','MdFieldSA5','SA5',"MdGridSA5",'SA5'} )
	aadd(aRotMVC, {'ATFA012','SN1MASTER','SN1',"SN3DETAIL",'SN3'} )

	nPos := Ascan(aRotMVC,{|X| X[1] == cNameRot} )

	If nPos > 0
		aadd(aRet,  aRotMVC[nPos] )
	Endif

Return aRet
