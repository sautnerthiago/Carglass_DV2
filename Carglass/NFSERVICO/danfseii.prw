#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch" 

#DEFINE IMP_SPOOL 2

#DEFINE VBOX       080
#DEFINE VSPACE     008
#DEFINE HSPACE     010
#DEFINE SAYVSPACE  008
#DEFINE SAYHSPACE  008
#DEFINE HMARGEM    030
#DEFINE VMARGEM    030
#DEFINE MAXITEM    022					// M�ximo de produtos para a primeira p�gina
#DEFINE MAXITEMP2  049					// M�ximo de produtos para a pagina 2 em diante
#DEFINE MAXITEMP2F 069					// M�ximo de produtos para a p�gina 2 em diante quando a p�gina n�o possui informa��es complementares
#DEFINE MAXITEMP3  025					// M�ximo de produtos para a pagina 2 em diante (caso utilize a op��o de impressao em verso) - Tratamento implementado para atender a legislacao que determina que a segunda pagina de ocupar 50%.
#DEFINE MAXITEMC   035					// M�xima de caracteres por linha de produtos/servi�os
#DEFINE MAXMENLIN  080					// M�ximo de caracteres por linha de dados adicionais
#DEFINE MAXMSG     013					// M�ximo de dados adicionais por p�gina
#DEFINE MAXVALORC  009					// M�ximo de caracteres por linha de valores num�ricos
#DEFINE MAXCODPRD  050					// M�ximo de caracteres do codigo de produtos/servicos conforme o tamanho do quadro "Cod. prod"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �PrtNfse � Autor � Eduardo Riera         � Data �16.11.2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Rdmake de exemplo para impress�o da DANFE no formato Retrato���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function PrtNfse(	cIdEnt, oDanfse, oSetup, cFilePrint	, lIsLoja	, nTipo )

Local aArea     := GetArea()
Local lExistNfe := .F.
Local lPergunte	:= .T.
Local lRet		:= .T.
local lVerPerg	:= .T.
local lJob		:= .F.
local cProg		:= iif(existBlock("DANFSEPrc"),"U_DANFSEPrc","DANFSEPrc")


Default lIsLoja	:= .F.	//indica se foi chamado de alguma rotina do SIGALOJA
Default nTipo	:= 0

Private nConsNeg := 0.4 // Constante para concertar o c�lculo retornado pelo GetTextWidth para fontes em negrito.
Private nConsTex := 0.5 // Constante para concertar o c�lculo retornado pelo GetTextWidth.
private oRetUnic

//If nTipo <> 1
	lJob := (oDanfse:lInJob .or. oSetup == nil)
	oDanfse:SetResolution(78) //Tamanho estipulado para a Danfe
	oDanfse:SetPortrait()
	oDanfse:SetPaperSize(DMPAPER_A4)
	oDanfse:SetMargin(60,60,60,60)
	oDanfse:lServer := if( lJob , .T., oSetup:GetProperty(PD_DESTINATION)==AMB_SERVER )
	// ----------------------------------------------
	// Define saida de impress�o
	// ----------------------------------------------
	If lJob .or. oSetup:GetProperty(PD_PRINTTYPE) == IMP_PDF
		oDanfse:nDevice := IMP_PDF
		// ----------------------------------------------
		// Define para salvar o PDF
		// ----------------------------------------------
		oDanfse:cPathPDF := if ( lJob , SuperGetMV('MV_RELT',,"\SPOOL\") , oSetup:aOptions[PD_VALUETYPE] )
	elseIf oSetup:GetProperty(PD_PRINTTYPE) == IMP_SPOOL
		oDanfse:nDevice := IMP_SPOOL
		oDanfse:SetParm( "-RFS")
		// ----------------------------------------------
		// Salva impressora selecionada
		// ----------------------------------------------
		fwWriteProfString(GetPrinterSession(),"DEFAULT", oSetup:aOptions[PD_VALUETYPE], .T.)
		oDanfse:cPrinter := oSetup:aOptions[PD_VALUETYPE]
	Endif

	If lVerPerg
		if !lJob
			lPergunte := Pergunte("NFSEDANFSE",.T.)
		else
			lPergunte := .T.
			Pergunte("NFSEDANFSE",.F.)
		endif
	EndIf


	If lPergunte
		if lJob
			&cProg.(@oDanfse, @lEnd, cIDEnt, @lExistNFe, lIsLoja, )			
		else
			RPTStatus( {|lEnd| &cProg.(@oDanfse, @lEnd, cIDEnt, @lExistNFe, lIsLoja,)}, "Imprimindo DANFSE..." )
		endif
	EndIf

	If lExistNFe 
		oDanfse:Preview()//Visualiza antes de imprimir
	Else
		if !lIsLoja .and. !lJob
			Aviso("DANFSE","Nenhuma NF-e a ser impressa nos parametros utilizados.",{"OK"},3)
		EndIf
	EndIf

	FreeObj(oDanfse)
	oDanfse := Nil	


RestArea(aArea)

Return lRet


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �DANFSEPrc� Autor � Eduardo Riera         � Data �16.11.2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Rdmake de exemplo para impress�o da DANFE no formato Retrato���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto grafico de impressao                    (OPC) ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function DANFSEPrc(	oDanfse	, lEnd		, cIdEnt	, ;
					lExistNfe	, lIsLoja	 )

Local aArea      := GetArea()
Local aAreaSF3   := {}
Local aNotas     := {}
Local aXML       := {}
Local cNaoAut    := ""
Local cAliasSF3  := "SF3"
Local cWhere     := ""
Local cAviso     := ""
Local cCodRetNFE := ""
Local cCodRetSF3 := ""
Local cMsgSF3    := ""
Local cErro      := ""
Local cAutoriza  := ""
Local cChaveSFT  := ""
Local cAliasSFT  := "SFT"
Local cCondicao	 := ""
Local cIndex	 := ""
Local cChave	 := ""
Local lQuery     := .F.
Local nX         := 0
Local nI		 := 0
Local oNfse
Local nLenNotas
Local lImpDir	:= GetNewPar("MV_IMPDIR",.F.)
Local aGrvSF3   := {}
Local lMVGfe	:= GetNewPar( "MV_INTGFE", .F. ) // Se tem integra��o com o GFE
Local lSdoc  	:= TamSx3("F3_SERIE")[1] == 14
Local cSerie 	:= ""
Local cSerId 	:= ""
Local cFrom 	:= ""
Local cxFilial	:= ""
Local cCampos	:= ""
local lChave	:= .F.
Local cChavSF3	:= ""
local lPossuiF3	:= .F.
local lQuerySFW	:= .F.
Local cPdf		:= ""
Local nHandle 	:= 0
Local cGetDir	:= ""
Default lEnd		:= .F.
Default lIsLoja		:= .F.
Default nTipo		:= 0


public nMaxItem := MAXITEM

MV_PAR01 := AllTrim(MV_PAR01)
MV_PAR02 := AllTrim(MV_PAR02)

If !lImpDir .or. MV_PAR04 == 0 /* Caso impress�o de DANFSE seja realizada via AutoDistMail */
	dbSelectArea("SF3")
	dbSetOrder(5)
	#IFDEF TOP
		If MV_PAR04==1

				cSerie := Padr(MV_PAR03,TamSx3("F3_SERIE")[1])
				cWhere := "%SubString(SF3.F3_CFO,1,1) < '5' AND SF3.F3_CODISS <> '' AND F3_CODRET = '111' "
		ElseIf MV_PAR04==2

				cSerie := Padr(MV_PAR03,TamSx3("F3_SERIE")[1])
				cWhere := "%SubString(SF3.F3_CFO,1,1) >= '5' AND SF3.F3_CODISS <> '' AND F3_CODRET = '111' "  
		EndIf
		
		If !Empty(MV_PAR05) .Or. !Empty(MV_PAR06)
			cWhere += " AND (SF3.F3_EMISSAO >= '"+ SubStr(DTOS(MV_PAR05),1,4) + SubStr(DTOS(MV_PAR05),5,2) + SubStr(DTOS(MV_PAR05),7,2) + "' AND SF3.F3_EMISSAO <= '"+ SubStr(DTOS(MV_PAR06),1,4) + SubStr(DTOS(MV_PAR06),5,2) + SubStr(DTOS(MV_PAR06),7,2) + "')"
		EndIF

		cWhere +=  IIf(Empty( cWhere ), "%SF3.F3_CODISS <> '' %", "%" )

		cAliasSF3 := GetNextAlias()
		lQuery    := .T.

		//�����������������������������������������������������������������Ŀ
		//�Campos que serao adicionados a query somente se existirem na base�
		//�������������������������������������������������������������������
		If Empty(cCampos)
			cCampos := "%%"
		Else
			cCampos := "% " + cCampos + " %"
		Endif

		BeginSql Alias cAliasSF3

			COLUMN F3_ENTRADA AS DATE
			COLUMN F3_DTCANC AS DATE

			SELECT	F3_FILIAL,F3_ENTRADA,F3_NFELETR,F3_CFO,F3_FORMUL,F3_NFISCAL,F3_SERIE,F3_CLIEFOR,F3_LOJA,F3_ESPECIE,F3_DTCANC
			%Exp:cCampos%
			FROM %Table:SF3% SF3
			WHERE
			SF3.F3_FILIAL = %xFilial:SF3% AND
			SF3.F3_SERIE = %Exp:MV_PAR03% AND
			SF3.F3_NFISCAL >= %Exp:MV_PAR01% AND
			SF3.F3_NFISCAL <= %Exp:MV_PAR02% AND
			%Exp:cWhere% AND
			SF3.F3_DTCANC = %Exp:Space(8)% AND
			SF3.%notdel%
			ORDER BY F3_NFISCAL
		EndSql

	#ELSE
		cIndex    		:= CriaTrab(NIL, .F.)
		cChave			:= IndexKey(6)
		cCondicao 		:= 'F3_FILIAL == "' + xFilial("SF3") + '" .And. '
		cCondicao 		+= 'SF3->F3_SERIE =="'+ MV_PAR03+'" .And. '
		cCondicao 		+= 'SF3->F3_NFISCAL >="'+ MV_PAR01+'" .And. '
		cCondicao		+= 'SF3->F3_NFISCAL <="'+ MV_PAR02+'" .And. '
		cCondicao		+= 'Empty(SF3->F3_DTCANC)'
		IndRegua(cAliasSF3, cIndex, cChave, , cCondicao)
		nIndex := RetIndex(cAliasSF3)
	            DBSetIndex(cIndex + OrdBagExt())
	            DBSetOrder(nIndex + 1)
		DBGoTop()
	#ENDIF
	If MV_PAR04==1
		cWhere := "SubStr(F3_CFO,1,1) < '5' .AND. F3_FORMUL=='S'"
	Elseif MV_PAR04==2
		cWhere := "SubStr(F3_CFO,1,1) >= '5'"
	Else
		cWhere := ".T."
	EndIf
	
	If lSdoc
		cSerId := (cAliasSF3)->F3_SDOC
	Else
		cSerId := (cAliasSF3)->F3_SERIE
	EndIf

	While !Eof() .And. xFilial("SF3") == (cAliasSF3)->F3_FILIAL .And.;
		cSerId == MV_PAR03 .And.;
		(cAliasSF3)->F3_NFISCAL >= MV_PAR01 .And.;
		(cAliasSF3)->F3_NFISCAL <= MV_PAR02

		dbSelectArea(cAliasSF3)

		If  Empty((cAliasSF3)->F3_DTCANC) .And. &cWhere 

			If (SubStr((cAliasSF3)->F3_CFO,1,1)>="5" .Or. (cAliasSF3)->F3_FORMUL=="S") .And. aScan(aNotas,{|x| x[4]+x[5]+x[6]+x[7]==(cAliasSF3)->F3_SERIE+(cAliasSF3)->F3_NFISCAL+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA})==0

				aadd(aNotas,{})
				aadd(Atail(aNotas),.F.)
				aadd(Atail(aNotas),IIF((cAliasSF3)->F3_CFO<"5","E","S"))
				aadd(Atail(aNotas),(cAliasSF3)->F3_ENTRADA)
				aadd(Atail(aNotas),(cAliasSF3)->F3_SERIE)
				aadd(Atail(aNotas),(cAliasSF3)->F3_NFISCAL)
				aadd(Atail(aNotas),(cAliasSF3)->F3_CLIEFOR)
				aadd(Atail(aNotas),(cAliasSF3)->F3_LOJA)

			EndIf
		EndIf

		dbSelectArea(cAliasSF3)
		dbSkip()

		If lSdoc
			cSerId := (cAliasSF3)->F3_SDOC
		Else
			cSerId := (cAliasSF3)->F3_SERIE
		EndIf

		If lEnd
			Exit
		EndIf
		If (cAliasSF3)->(Eof())
			aAreaSF3 := (cAliasSF3)->(GetArea())
			aXml := GetXML(cIdEnt,aNotas,if( valtype(oDanfse) == "O", oDanfse:lInJob, nil ) )

			nLenNotas := Len(aNotas)

			For nX := 1 To nLenNotas
				IF !Empty(aXML[nX][1])
					oRetUnic := XmlParser(aXML[nX][1],"_",@cAviso,@cErro)
					oNFse := oRetUnic
					If Empty(cAviso) .And. Empty(cErro)
						ImpNfse(@oDanfse,oNFse,aXML[nX])
						lExistNfe := .T.
					EndIf
					fwFreeObj (oNfse)
					oNfse     := nil
					fwFreeObj (oRetUnic)
					oRetUnic:=nil
				EndIf

			Next nX

			aNotas := {}

			lPossuiF3	:= .T.				   
			RestArea(aAreaSF3)
			DelClassIntF()
		EndIf
	EndDo

	if lQuery
		(cAliasSF3)->(dbCloseArea())
	else
		DBClearFilter()
		Ferase(cIndex+OrdBagExt())
	endif

	If !lIsLoja .AND. !Empty(cNaoAut) .and. if( valtype(oDanfse) == "O", !oDanfse:lInJob, .T. )
		Aviso("SPED","As seguintes notas n�o foram autorizadas: "+CRLF+CRLF+cNaoAut,{"Ok"},3)
	EndIf
EndIf


RestArea(aArea)
Return .T.

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Program   � ImpNfse   � Autor � Eduardo Riera         � Data �16.11.2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Controle de Fluxo do Relatorio.                             ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto grafico de impressao                    (OPC) ���
���          �ExpC2: String com o XML da NFe                              ���
���          �ExpC3: Codigo de Autorizacao do fiscal                (OPC) ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ImpNfse(	oDanfse		, oNfse, aXMLRet	)

DEFAULT lImpSimp	:= .F.
Default nTipo		:= 0
Default cMsgRet		:= ""

//If nTipo <> 1
	PRIVATE oFont10N   := TFontEx():New(oDanfse,"Times New Roman",08,08,.T.,.T.,.F.)// 1
	PRIVATE oFont07N   := TFontEx():New(oDanfse,"Times New Roman",06,06,.T.,.T.,.F.)// 2
	PRIVATE oFont07    := TFontEx():New(oDanfse,"Times New Roman",06,06,.F.,.T.,.F.)// 3
	PRIVATE oFont08    := TFontEx():New(oDanfse,"Times New Roman",07,07,.F.,.T.,.F.)// 4
	PRIVATE oFont08N   := TFontEx():New(oDanfse,"Times New Roman",06,06,.T.,.T.,.F.)// 5
	PRIVATE oFont09N   := TFontEx():New(oDanfse,"Times New Roman",08,08,.T.,.T.,.F.)// 6
	PRIVATE oFont09    := TFontEx():New(oDanfse,"Times New Roman",08,08,.F.,.T.,.F.)// 7
	PRIVATE oFont10    := TFontEx():New(oDanfse,"Times New Roman",09,09,.F.,.T.,.F.)// 8
	PRIVATE oFont11    := TFontEx():New(oDanfse,"Times New Roman",10,10,.F.,.T.,.F.)// 9
	PRIVATE oFont12    := TFontEx():New(oDanfse,"Times New Roman",11,11,.F.,.T.,.F.)// 10
	PRIVATE oFont11N   := TFontEx():New(oDanfse,"Times New Roman",10,10,.T.,.T.,.F.)// 11
	PRIVATE oFont18N   := TFontEx():New(oDanfse,"Times New Roman",17,17,.T.,.T.,.F.)// 12
	PRIVATE OFONT12N   := TFontEx():New(oDanfse,"Times New Roman",11,11,.T.,.T.,.F.)// 12	 
	PRIVATE oFont13N   := TFontEx():New(oDanfse,"Times New Roman",08,08,.T.,.T.,.F.)// 13
	PRIVATE oFont05N   := TFontEx():New(oDanfse,"Times New Roman",05,05,.T.,.T.,.F.)// 
	

	PrtDanfse(@oDanfse,oNfse, aXMLRet)

Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �PrtDanfse  � Autor �				        � Data �16.11.2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Impressao do formulario DANFSE grafico conforme laytout no   ���
���          �formato retrato                                             ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � PrtDanfse()                                                 ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto grafico de impressao                          ���
���          �ExpO2: Objeto da NFse -- XML Unico                          ���
���          �ExpC3: Array com informa��es referente ao metodo Retorna    ���
���          	aRetorno[x][1] = XML �nico    							  ���
���          	aRetorno[x][2] = XML do Lote    						  ��� 
���          	aRetorno[x][3] = ID do RPS    							  ���
���          	aRetorno[x][4] = XML convertido    						  ���
���          	aRetorno[x][5] = PDF gravado na tabela SPED059    		  ���
���          	aRetorno[x][6] = Numero da NFSe    						  ���
���          	aRetorno[x][7] = Data e Hora    						  ��� 
���          	aRetorno[x][8] = XML retorno TSS    					  ���
���          	aRetorno[x][9] = Protocolo    							  ���
																		  ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function PrtDanfse(oDanfse,oNFE,aXMLRet)


Local cLogo      := FisxLogo("1")
Local lMv_Logod	 := If( GetNewPar("MV_LOGOD", "N" ) == "S", .T., .F. )
Local cLogoD	 := ""
Local lNac			:= .F.

Local nLinea 		:= 0 
Local nLiCabec		:= 0
Local nLiDados		:= 0
Local nLiQuebr 		:= 0
Local nIniLin 		:= 0 
Local nFimLin 		:= 0
Local lTemTom	 	:= .T. // Tem Tomador
Local lTemInt	 	:= .T. // Tem Intermediario
Local nNumSer	 	:= 0  // Numero de servi�os prestados 
Local nX		 	:= 0
Local cInfNota 		:= ""
Local aInfNota		:= {}
Local nMax			:= 0
lOCAL nCont			:= 0
Local nMxCol11 := 65 // coluna 1 com a coluna 2 preenchida
Local nMxCol12 := 120 // coluna 1 com a coluna 2 vazia

Local nMxCol21 := 43 // coluna 2 com a coluna 3 preenchida

Local nMxCol31 := 38 // coluna 3 com a com a coluna 4 preenchida
Local nMxCol32 := 90 // coluna 3 com a com a coluna 4 vazia

Local nMxCol41 := 44 // coluna 4 

Local nMxTrib	:= 10

Local nValtot		:= 0
Local nValDesinc 	:= 0
Local nValDesCcond	:= 0
Local nValDedu 		:= 0
Local nValRedu 		:= 0	
Local nbasecalc 	:= 0
Local cCompetencia  := ""
Local cCpfcnpj		:= ""
Local cXmun 		:= ""
Local cCodBacen := ""
Local cPais 	:= ""
Local cDescTrib	:= ""
Local cRegesp 	:= ""
Local cSimpNac	:= ""
Local cMunicipio := ""



Default cDtHrRecCab := ""
Default dDtReceb    := CToD("")

Private aInfNf    := {}
Private nPrivate  := 0
Private nPrivate2 := 0
Private nXAux	  := 0
Private lArt488MG := .F.
Private lArt274SP := .F.
Private oNFSE		:= oNFE
Private aServicos	:= {}

lNac := iif(TYPE("oNFSE:_DPS") <> "U", .T. , .F.)


//������������������������������������������������������������������������Ŀ
//�Inicializacao do objeto grafico                                         �
//��������������������������������������������������������������������������
If oDanfse == Nil
	lPreview := .T.
	oDanfse 	:= FWMSPrinter():New("DANFE", IMP_SPOOL,/*lAdjustToLegacy*/ .F.)
	oDanfse:SetPortrait()
	oDanfse:SetMargin(00,00,00,00) 
	oDanfse:Setup()
EndIf

//������������������������������������������������������������������������Ŀ
//�Inicializacao da pagina do objeto grafico                               �
//��������������������������������������������������������������������������
oDanfse:StartPage()

//������������������������������������������������������������������������Ŀ
//�Definicao do Box - Recibo de entrega                                    �
//��������������������������������������������������������������������������

oDanfse:Box(000,000,870,610,) 

//������������������������������������������������������������������������Ŀ
//�Logotipo                                     �
//��������������������������������������������������������������������������
If lMv_Logod
	cGrpCompany	:= AllTrim(FWGrpCompany())
	cCodEmpGrp	:= AllTrim(FWCodEmp())
	cUnitGrp	:= AllTrim(FWUnitBusiness())
	cFilGrp		:= AllTrim(FWFilial())

	If !Empty(cUnitGrp)
		cDescLogo	:= cGrpCompany + cCodEmpGrp + cUnitGrp + cFilGrp
	Else
		cDescLogo	:= cEmpAnt + cFilAnt
	EndIf

	cLogoD := GetSrvProfString("Startpath","") + "DANFSE" + cDescLogo + ".BMP"
	If !File(cLogoD)
		cLogoD	:= GetSrvProfString("Startpath","") + "DANFSE" + cEmpAnt + ".BMP"
		If !File(cLogoD)
			lMv_Logod := .F.
		EndIf
	EndIf
EndIf


If lMv_Logod // oPrint:sayBitmap(linha, coluna, "C:\SUAPASTA\SUAIMAGEM.BMP", largura, altura)
	oDanfse:SayBitmap(001,001,cLogoD,070,030)
Else
	oDanfse:SayBitmap(001,001,cLogo,070,030)
EndIF

//DADOS DA NOTA
if lNac // Layout Impress�o DANFSE Nacional
	//CABE�ALHO
	//oDanfse:Say(010, 260, "DANFSe V1.0", oFont10N:oFont,,/*CLR_HRED*/)
	//oDanfse:Say(020, 230, "Documento Auxiliar da NFS-e", oFont09N:oFont,,/*CLR_HRED*/)
	//CABE�ALHO
	oDanfse:Say(010, 220, "DEMONSTRATIVO DA NOTA FISCAL DE SERVI�O", oFont10N:oFont,,/*CLR_HRED*/)
	oDanfse:Say(020, 240, "Emitida pelo sistena de Nfs-e Nacional", oFont09N:oFont,,/*CLR_HRED*/)
	oDanfse:Say(030, 230, "ESTE DOCUMENTO N�O TEM VALOR FISCAL", oFont10:oFont,,CLR_HRED)		

	//Linha 1
	oDanfse:Say(040, 002, "Chave de acesso da NFS-e", oFont07N:oFont)
	oDanfse:Say(048, 002, aXMLRet[9], oFont07:oFont)

	nLinea := 048
	nLiCabec := 10
	nLiDados := 8
	nLiQuebr := 4
	nIniLin  := 0003
	nFimLin	 := 0605

	cInfNota := IIF(Type("ONFSE:_DPS:_INFDPS:_SERV:_INFOCOMPL:_XINFCOMP") <> "U",ONFSE:_DPS:_INFDPS:_SERV:_INFOCOMPL:_XINFCOMP:TEXT," - ") 

	cInfNota := IIF(Len(cInfNota) > 2000,substr(cInfNota,1,2000) ,cInfNota)
	nMax	:= 220
	nCont := 0
	//criar uma variavel para manter a cInfNota com o conteudo original

	While Len(cInfNota) > 0
		aadd(aInfNota,substr(cInfNota,1,nMax))
		cInfNota:= STUFF(cInfNota,1,nMax,"") // Remo��o do trecho j� adicionado ao array.
		IF Len(cInfNota) < nMax
			nMax := Len(cInfNota)
		EndiF
	EndDo

	// -------------------------------------------------------------------------------------------

	//Linha 2
	nLinea := nLinea+nLiCabec 
	oDanfse:Say(nLinea, 002, "N�mero da NFS-e", oFont07N:oFont)
	oDanfse:Say(nLinea, 200, "Compet�ncia da NFS-e", oFont07N:oFont)
	oDanfse:Say(nLinea, 350, "Data e Hora da emiss�o da NFS-e", oFont07N:oFont)

	cCompetencia := IIF(Type("oNFSE:_DPS:_INFDPS:_DCOMPET")<> "U", oNFSE:_DPS:_INFDPS:_DCOMPET:TEXT,'')
	cCompetencia := IIF(!Empty(cCompetencia),Substr(cCompetencia,9,2)+"/"+Substr(cCompetencia,6,2)+"/"+Substr(cCompetencia,1,4),"-")


	nLinea := nLinea+nLiDados 
	oDanfse:Say(nLinea, 002, Substr(aXMLRet[6],1,nMxCol11), oFont07:oFont) //N�mero da NFS-e
	oDanfse:Say(nLinea, 200, Substr(IIF(!EMPTY(cCompetencia),cCompetencia," - "),1,nMxCol21), oFont07:oFont) //Compet�ncia da NFS-e
	oDanfse:Say(nLinea, 350, Substr(IIF(Type("oNFSE:_DPS:_INFDPS:_DHEMI") <> "U",oNFSE:_DPS:_INFDPS:_DHEMI:TEXT," - "),1,nMxCol31), oFont07:oFont) //Data e Hora da emiss�o da NFS-e


	//Linha 3

	nLinea := nLinea+nLiCabec 
	oDanfse:Say(nLinea, 002, "N�mero da DPS", oFont07N:oFont)
	oDanfse:Say(nLinea, 200, "S�rie da DPS", oFont07N:oFont)
	oDanfse:Say(nLinea, 350, "Data e Hora da emiss�o da DPS", oFont07N:oFont)
	nLinea := nLinea+nLiDados 
	oDanfse:Say(nLinea, 002, Substr(IIF(type("oNFSE:_DPS:_INFDPS:_NDPS") <> "U",oNFSE:_DPS:_INFDPS:_NDPS:TEXT," - "),1,nMxCol11), oFont07:oFont) //N�mero da DPS    
	oDanfse:Say(nLinea, 200, Substr(IIF(type("oNFSE:_DPS:_INFDPS:_SERIE") <> "U",oNFSE:_DPS:_INFDPS:_SERIE:TEXT," - "),1,nMxCol21), oFont07:oFont) //S�rie da DPS
	oDanfse:Say(nLinea, 350, Substr(IIF(type("oNFSE:_DPS:_INFDPS:_DHEMI") <> "U",oNFSE:_DPS:_INFDPS:_DHEMI:TEXT," - "),1,nMxCol31), oFont07:oFont) //Data e Hora da emiss�o da DPS

	//BLOCO DE AUTENTICIDADE
	oDanfse:Say(066, 480, "Para verificar a autoriza��o da nfs-e referente", oFont05N:oFont)
	oDanfse:Say(074, 480, "� nota mencionada e impress�o da DANFSE, acesse o" , oFont05N:oFont) 
	oDanfse:Say(082, 480, "sitio  https://www.nfse.gov.br/consultapublica", oFont05N:oFont,,CLR_HRED)



	// LINHA DE QUEBRA
	nLinea := nLinea+nLiQuebr 
	oDanfse:Line(nLinea, nIniLin,nLinea, nFimLin)	

	// DADOS EMITENTE
	//Linha 1
	if type("oNFSE:_DPS:_INFDPS:_PREST:_CNPJ") <> "U"
		cCpfcnpj := Alltrim(oNFSE:_DPS:_INFDPS:_PREST:_CNPJ:TEXT)
		cCpfcnpj := iif( len(cCpfcnpj)==14, Transform(cCpfcnpj,"@r 99.999.999/9999-99"),Transform(cCpfcnpj,"@r 999.999.999-99") )
	Endif 

	nLinea := nLinea+nLiCabec 
	oDanfse:Say(nLinea, 002, "EMITENTE DA NFS-e", oFont07N:oFont)
	oDanfse:Say(nLinea, 200, "CNPJ / CPF/ NIF", oFont07N:oFont)
	oDanfse:Say(nLinea, 350, "Inscri��o Municipal", oFont07N:oFont)
	oDanfse:Say(nLinea, 480, "Telefone", oFont07N:oFont)
	nLinea := nLinea+nLiDados 
	//oDanfse:Say(nLinea, 002, Substr(SM0->M0_FILIAL,1,nMxCol11), oFont07:oFont) //EMITENTE DA NFS-e
	oDanfse:Say(nLinea, 200, Substr(IIF(!Empty(cCpfcnpj),cCpfcnpj," - "),1,nMxCol21), oFont07:oFont) //CNPJ / CPF/ NIF
	oDanfse:Say(nLinea, 350, Substr(ALLTRIM(SM0->M0_INSCM),1,nMxCol31), oFont07:oFont) //Inscri��o Municipal
	oDanfse:Say(nLinea, 480, Substr(IIF(Type("oNFSE:_DPS:_INFDPS:_PREST:_FONE") <> "U",oNFSE:_DPS:_INFDPS:_PREST:_FONE:TEXT," - ") ,1,nMxCol41), oFont07:oFont) //Telefone



	//Linha 2
	nLinea := nLinea+nLiCabec 
	oDanfse:Say(nLinea, 002, "Nome / Raz�o Social", oFont07N:oFont)
	oDanfse:Say(nLinea, 350, "E-mail", oFont07N:oFont)
	nLinea := nLinea+nLiDados 
	oDanfse:Say(nLinea, 002, SUBSTR(SM0->M0_FILIAL,1,nMxCol12) , oFont07:oFont) //Nome / Raz�o Social
	oDanfse:Say(nLinea, 350, SUBSTR(IIF(Type("oNFSE:_DPS:_INFDPS:_PREST:_EMAIL") <> "U",oNFSE:_DPS:_INFDPS:_PREST:_EMAIL:TEXT," - "),1,nMxCol32), oFont07:oFont) //mail

	//Linha 3
	nLinea := nLinea+nLiCabec 
	oDanfse:Say(nLinea, 002, "Endere�o", oFont07N:oFont)
	oDanfse:Say(nLinea, 200, "Bairro", oFont07N:oFont)
	oDanfse:Say(nLinea, 350, "Municipo/UF", oFont07N:oFont)
	oDanfse:Say(nLinea, 480, "CEP", oFont07N:oFont)
	nLinea := nLinea+nLiDados 
	oDanfse:Say(nLinea, 002, SUBSTR(SM0->M0_ENDENT,1,nMxCol12), oFont07:oFont) //Endere�o
	oDanfse:Say(nLinea, 200, Substr(SM0->M0_BAIRENT,1,nMxCol31), oFont07:oFont) //Bairro
	oDanfse:Say(nLinea, 350, Substr(aLLTRIM(SM0->M0_CIDENT)+" - "+ aLLTRIM(SM0->M0_ESTENT) ,1,nMxCol31), oFont07:oFont) //Municipo
	oDanfse:Say(nLinea, 480, Substr(SM0->M0_CEPENT,1,nMxCol41), oFont07:oFont) //CEP

	//Linha 4
	nLinea := nLinea+nLiCabec 
	oDanfse:Say(nLinea, 002, "Simples Nacional na Data de compet�ncia", oFont07N:oFont)
	oDanfse:Say(nLinea, 350, "Regime de Apura��o Tibut�ria pelo SN", oFont07N:oFont)
	nLinea := nLinea+nLiDados 
	oDanfse:Say(nLinea, 002, SUBSTR(IIF(Type("oNFSE:_DPS:_INFDPS:_PREST:_REGTRIB:_OPSIMPNAC") <> "U",IIF(oNFSE:_DPS:_INFDPS:_PREST:_REGTRIB:_OPSIMPNAC:TEXT = "1","Sim","N�o" )," - "),1,nMxCol12), oFont07:oFont) //Simples Nacional na Data de compet�ncia
	oDanfse:Say(nLinea, 350, SUBSTR(IIF(Type("oNFSE:_DPS:_INFDPS:_PREST:_REGTRIB:_REGESPTRIB") <> "U",IIF(oNFSE:_DPS:_INFDPS:_PREST:_REGTRIB:_REGESPTRIB:TEXT = "0","Nenhum","-" )," - "),1,nMxCol32), oFont07:oFont) //Regime de Apura��o Tibut�ria pelo SN

	// LINHA DE QUEBRA
	nLinea := nLinea+nLiQuebr 
	oDanfse:Line(nLinea, nIniLin,nLinea, nFimLin)	

	// TOMADOR DO SERVI�O
	if type("oNFSE:_DPS:_INFDPS:_TOMA:_CNPJ") <> "U"
		cCpfcnpj := ""
		cCpfcnpj := Alltrim(oNFSE:_DPS:_INFDPS:_TOMA:_CNPJ:TEXT)
		cCpfcnpj := iif( len(cCpfcnpj)==14, Transform(cCpfcnpj,"@r 99.999.999/9999-99"),Transform(cCpfcnpj,"@r 999.999.999-99") )
	Endif 

	lTemTom	 := iIF(Type("oNFSE:_DPS:_INFDPS:_TOMA:_XNOME") <> "U",.T.,.F.) // Tem Tomador
	IF lTemTom
		//Linha 1
		nLinea := nLinea+nLiCabec 
		oDanfse:Say(nLinea, 002, "TOMADOR DO SERVI�O", oFont07N:oFont)
		oDanfse:Say(nLinea, 200, "CNPJ / CPF/ NIF", oFont07N:oFont)
		oDanfse:Say(nLinea, 350, "Inscri��o Municipal", oFont07N:oFont)
		oDanfse:Say(nLinea, 480, "Telefone", oFont07N:oFont)
		nLinea := nLinea+nLiDados 
		//oDanfse:Say(nLinea, 002, substr(IIF(Type("oNFSE:_DPS:_INFDPS:_TOMA:_XNOME") <> "U",oNFSE:_DPS:_INFDPS:_TOMA:_XNOME:TEXT," - "),1,nMxCol11), oFont07:oFont) //TOMADOR DO SERVI�O
		oDanfse:Say(nLinea, 200, Substr(IIF(!Empty(cCpfcnpj),cCpfcnpj," - "),1,nMxCol21), oFont07:oFont) //CNPJ / CPF/ NIF
		oDanfse:Say(nLinea, 350, Substr(IIF(Type("oNFSE:_DPS:_INFDPS:_TOMA:_IM") <> "U",oNFSE:_DPS:_INFDPS:_TOMA:_IM:TEXT," - "),1,nMxCol31), oFont07:oFont) //Inscri��o Municipal
		oDanfse:Say(nLinea, 480, Substr(IIF(Type("oNFSE:_DPS:_INFDPS:_TOMA:_FONE") <> "U",oNFSE:_DPS:_INFDPS:_TOMA:_FONE:TEXT," - "),1,nMxCol41), oFont07:oFont) //Telefone

		//Linha 2
		nLinea := nLinea+nLiCabec 
		oDanfse:Say(nLinea, 002, "Nome / Raz�o Social", oFont07N:oFont)
		oDanfse:Say(nLinea, 350, "E-mail", oFont07N:oFont)
		nLinea := nLinea+nLiDados 
		oDanfse:Say(nLinea, 002, SUBSTR(IIF(Type("oNFSE:_DPS:_INFDPS:_TOMA:_XNOME") <> "U",oNFSE:_DPS:_INFDPS:_TOMA:_XNOME:TEXT," - "),1,nMxCol12), oFont07:oFont) //Nome / Raz�o Social
		oDanfse:Say(nLinea, 350, SUBSTR(IIF(Type("oNFSE:_DPS:_INFDPS:_TOMA:_EMAIL") <> "U",oNFSE:_DPS:_INFDPS:_TOMA:_EMAIL:TEXT," - "),1,nMxCol32), oFont07:oFont) //mail

		//Linha 3
		iF Type("oNFSE:_DPS:_INFDPS:_TOMA:_CNPJ") <> "U"
			SA1->(dbSetOrder(3)) 
			SA1->(DbSeek(xFilial("SA1")+oNFSE:_DPS:_INFDPS:_TOMA:_CNPJ:TEXT))
			cXmun := aLLTRIM(SA1->A1_MUN) + " - " + aLLTRIM(SA1->A1_EST)
		ENDIF

		nLinea := nLinea+nLiCabec 
		oDanfse:Say(nLinea, 002, "Endere�o", oFont07N:oFont)
		oDanfse:Say(nLinea, 200, "Bairro", oFont07N:oFont)
		oDanfse:Say(nLinea, 350, "Municipo/UF", oFont07N:oFont)
		oDanfse:Say(nLinea, 480, "CEP", oFont07N:oFont)
		nLinea := nLinea+nLiDados 
		oDanfse:Say(nLinea, 002, SUBSTR(IIF(Type("oNFSE:_DPS:_INFDPS:_TOMA:_END:_XLGR") <> "U",oNFSE:_DPS:_INFDPS:_TOMA:_END:_XLGR:TEXT," - ") +","+IIF(Type("oNFSE:_DPS:_INFDPS:_TOMA:_END:_NRO") <> "U",oNFSE:_DPS:_INFDPS:_TOMA:_END:_NRO:TEXT," - "),1,nMxCol12), oFont07:oFont) //Endere�o
		oDanfse:Say(nLinea, 200, Substr(IIF(Type("oNFSE:_DPS:_INFDPS:_TOMA:_END:_xBairro") <> "U",oNFSE:_DPS:_INFDPS:_TOMA:_END:_xBairro:TEXT," - "),1,nMxCol31), oFont07:oFont) //Municipo
		oDanfse:Say(nLinea, 350, Substr(IIF(!EMPTY(cXmun),cXmun," - "),1,nMxCol31), oFont07:oFont) //Municipo
		oDanfse:Say(nLinea, 480, Substr(IIF(Type("oNFSE:_DPS:_INFDPS:_TOMA:_END:_ENDNAC:_CEP") <> "U",oNFSE:_DPS:_INFDPS:_TOMA:_END:_ENDNAC:_CEP:TEXT," - "),1,nMxCol41), oFont07:oFont) //CEP
	Else
		nLinea := nLinea+nLiCabec 
		oDanfse:Say(nLinea, 200, "TOMADOR DO SERVI�O N�O IDENTIFICADO NA NFSE-e", oFont07:oFont,,CLR_HRED)
	EndIF

	// LINHA DE QUEBRA
	nLinea := nLinea+nLiQuebr 
	oDanfse:Line(nLinea, nIniLin,nLinea, nFimLin)	

	// TOMADOR DO INTERMEDIARIO
	if type("oNFSE:_DPS:_INFDPS:_INTERM:_CNPJ") <> "U"
		cCpfcnpj := ""
		cCpfcnpj := Alltrim(oNFSE:_DPS:_INFDPS:_INTERM:_CNPJ:TEXT)
		cCpfcnpj := iif( len(cCpfcnpj)==14, Transform(cCpfcnpj,"@r 99.999.999/9999-99"),Transform(cCpfcnpj,"@r 999.999.999-99") )
	Endif 

	lTemInt := IIF(Type("oNFSE:_DPS:_INFDPS:_INTERM") <> "U",.T.,.F.)
	IF lTemInt
		//Linha 1
		nLinea := nLinea+nLiCabec 
		oDanfse:Say(nLinea, 002, "INTERMEDI�RIO DO SERVI�O", oFont07N:oFont,,CLR_HRED)
		oDanfse:Say(nLinea, 200, "CNPJ / CPF/ NIF", oFont07N:oFont)
		oDanfse:Say(nLinea, 350, "Inscri��o Municipal", oFont07N:oFont)
		oDanfse:Say(nLinea, 480, "Telefone", oFont07N:oFont)
		nLinea := nLinea+nLiDados //106
		//oDanfse:Say(nLinea, 002, Substr(IIF(Type("oNFSE:_DPS:_INFDPS:_INTERM:_XNOME") <> "U",oNFSE:_DPS:_INFDPS:_INTERM:_XNOME:TEXT," - "),1,nMxCol11), oFont07:oFont) //INTERMEDI�RIO DO SERVI�O
		oDanfse:Say(nLinea, 200, Substr(IIF(!Empty(cCpfcnpj),cCpfcnpj,"-"),1,nMxCol21), oFont07:oFont) //CNPJ / CPF/ NIF
		oDanfse:Say(nLinea, 350, Substr(IIF(Type("oNFSE:_DPS:_INFDPS:_INTERM:_IM") <> "U",oNFSE:_DPS:_INFDPS:_INTERM:_IM:TEXT," - "),1,nMxCol31), oFont07:oFont) //Inscri��o Municipal
		oDanfse:Say(nLinea, 480, Substr(" - ",1,nMxCol41), oFont07:oFont) //Telefone

		//Linha 2
		nLinea := nLinea+nLiCabec //116
		oDanfse:Say(nLinea, 002, "Nome / Raz�o Social", oFont07N:oFont)
		oDanfse:Say(nLinea, 350, "E-mail", oFont07N:oFont)
		nLinea := nLinea+nLiDados //124
		oDanfse:Say(nLinea, 002, SUBSTR(IIF(Type("oNFSE:_DPS:_INFDPS:_INTERM:_XNOME") <> "U",oNFSE:_DPS:_INFDPS:_INTERM:_XNOME:TEXT," - "),1,nMxCol12), oFont07:oFont) //Nome / Raz�o Social
		oDanfse:Say(nLinea, 350, SUBSTR(" - ",1,nMxCol32), oFont07:oFont) //mail

		//Linha 3
		nLinea := nLinea+nLiCabec //134
		oDanfse:Say(nLinea, 002, "Endere�o", oFont07N:oFont)
		oDanfse:Say(nLinea, 350, "Municipo", oFont07N:oFont)
		oDanfse:Say(nLinea, 480, "CEP", oFont07N:oFont)
		nLinea := nLinea+nLiDados //142
		oDanfse:Say(nLinea, 002, SUBSTR(IIF(Type("oNFSE:_DPS:_INFDPS:_INTERM:_END:_ENDNAC") <> "U",oNFSE:_DPS:_INFDPS:_INTERM:_END:_ENDNAC:TEXT," - "),1,nMxCol12), oFont07:oFont) //Endere�o
		oDanfse:Say(nLinea, 350, Substr(IIF(Type("oNFSE:_DPS:_INFDPS:_INTERM:_END:_ENDNAC:_CMUN") <> "U",oNFSE:_DPS:_INFDPS:_INTERM:_END:_ENDNAC:_CMUN:TEXT," - "),1,nMxCol31), oFont07:oFont) //Municipo
		oDanfse:Say(nLinea, 480, Substr(IIF(Type("oNFSE:_DPS:_INFDPS:_INTERM:_END:_ENDNAC:_CEP") <> "U",oNFSE:_DPS:_INFDPS:_INTERM:_END:_ENDNAC:_CEP:TEXT," - "),1,nMxCol41), oFont07:oFont) //CEP
	ELSE
		nLinea := nLinea+nLiCabec 
		oDanfse:Say(nLinea, 200, "INTERMEDI�RIO DO SERVI�O N�O IDENTIFICADO NA NFSE-e", oFont07:oFont)
	EndIF

	// LINHA DE QUEBRA
	nLinea := nLinea+nLiQuebr 
	oDanfse:Line(nLinea, nIniLin,nLinea, nFimLin)	

	//SERVI�O PRESTADO
	//Linha 1
	nLinea := nLinea+nLiCabec 
	oDanfse:Say(nLinea, 002, "SERVI�O PRESTADO", oFont07N:oFont)

	//Linha 2
	nLinea := nLinea+nLiCabec
	oDanfse:Say(nLinea, 002, "C�digo de Tributa��o Nacional", oFont07N:oFont)
	oDanfse:Say(nLinea, 200, "C�digo de Tributa��o Municipal", oFont07N:oFont)
	oDanfse:Say(nLinea, 350, "Local da Presta��o", oFont07N:oFont)
	oDanfse:Say(nLinea, 480, "Pa�s da Presta��o", oFont07N:oFont)
	nLinea := nLinea+nLiDados 
	oDanfse:Say(nLinea, 002, SUBSTR(IIF(Type("oNFSE:_DPS:_INFDPS:_SERV:_CSERV:_CTRIBNAC") <> "U",oNFSE:_DPS:_INFDPS:_SERV:_CSERV:_CTRIBNAC:TEXT," - "),1,nMxCol11), oFont07:oFont) //C�digo de Tributa��o Nacional
	oDanfse:Say(nLinea, 200, Substr(IIF(Type("oNFSE:_DPS:_INFDPS:_SERV:_CSERV:_CTRIBMUN") <> "U",oNFSE:_DPS:_INFDPS:_SERV:_CSERV:_CTRIBMUN:TEXT," - "),1,nMxCol21), oFont07:oFont) //C�digo de Tributa��o Municipal
	oDanfse:Say(nLinea, 350, Substr(IIF(Type("oNFSE:_DPS:_INFDPS:_SERV:_LOCPREST:_CLOCPRESTACAO") <> "U",oNFSE:_DPS:_INFDPS:_SERV:_LOCPREST:_CLOCPRESTACAO:TEXT," - ") + " - " +  IIF(Type("oNFSE:_RPS:_PRESTACAO:_UF") <> "U",oNFSE:_RPS:_PRESTACAO:_UF:TEXT," - ") ,1,nMxCol31), oFont07:oFont) //Local da Presta��o
	oDanfse:Say(nLinea, 480, Substr(IIF(Type("oNFSE:_DPS:_INFDPS:_SERV:_LOCPREST:_CPAISPRESTACAO") <> "U",oNFSE:_DPS:_INFDPS:_SERV:_LOCPREST:_CPAISPRESTACAO:TEXT," - "),1,nMxCol41), oFont07:oFont) //Pa�s da Presta��o

	//Linha 3
	nLinea := nLinea+nLiCabec 
	oDanfse:Say(nLinea, 002, "Descri��o do Servi�o", oFont07N:oFont)

	// NFSe Nacional aceita um codigo de servi�o aglutinado.
	nLinea := nLinea+nLiDados 
	oDanfse:Say(nLinea, 002, Substr(IIF(Type("oNFSE:_DPS:_INFDPS:_SERV:_CSERV:_XDESCSERV") <> "U",oNFSE:_DPS:_INFDPS:_SERV:_CSERV:_XDESCSERV:TEXT," - "),1,178), oFont07:oFont) //Descri��o do Servi�o

	// LINHA DE QUEBRA
	nLinea := nLinea+nLiQuebr 
	oDanfse:Line(nLinea, nIniLin,nLinea, nFimLin)

	// TRIBUTA��O MUNICIPAL
	//Linha 1
	nLinea := nLinea+nLiCabec 
	oDanfse:Say(nLinea, 002, "TRIBUTA��O MUNICIPAL", oFont07N:oFont)

	//Linha 2
	If Type("ONFSE:_DPS:_INFDPS:_VALORES:_TRIB:_TRIBMUN:_TRIBISSQN") <> "U
		cIssqn := fTrinisqn(Alltrim(ONFSE:_DPS:_INFDPS:_VALORES:_TRIB:_TRIBMUN:_TRIBISSQN:TEXT))
	Endif 
	nLinea := nLinea+nLiCabec 
	oDanfse:Say(nLinea, 002, "Tributa��o do ISSQN", oFont07N:oFont)
	oDanfse:Say(nLinea, 200, "Pa�s Resultado da Presta��o do Servi�o", oFont07N:oFont)
	oDanfse:Say(nLinea, 350, "Munic�pio de Incid�ncia do ISSQN", oFont07N:oFont)
	oDanfse:Say(nLinea, 480, "Regime Especial de Tributa��o", oFont07N:oFont)
	nLinea := nLinea+nLiDados 
	oDanfse:Say(nLinea, 002, SUBSTR(IIF(!Empty(cIssqn),cIssqn," - "),1,nMxCol11), oFont07:oFont) //Tributa��o do ISSQN
	oDanfse:Say(nLinea, 200, Substr(IIF(Type("ONFSE:_DPS:_INFDPS:_VALORES:_TRIB:_TRIBMUN:_CPAISRESULT") <> "U",ONFSE:_DPS:_INFDPS:_VALORES:_TRIB:_TRIBMUN:_CPAISRESULT:TEXT," - ") ,1,nMxCol21), oFont07:oFont) //Pa�s Resultado da PResta��o do Servi�o
	oDanfse:Say(nLinea, 350, Substr(IIF(Type("XXXXXXXXXX") <> "U" .and. !EMPTY("XXXXXXXXXX"),"XXXXXXXXXX" ,IIF(Type("XXXXXXXXXX") <> "U","XXXXXXXXXX"," - ")),1,nMxCol31), oFont07:oFont) //Munic�pio de Incid�ncia do ISSQN
	oDanfse:Say(nLinea, 480, Substr(IIF(Type("oNFSE:_DPS:_INFDPS:_PREST:_REGTRIB:_REGESPTRIB") <> "U",IIF(oNFSE:_DPS:_INFDPS:_PREST:_REGTRIB:_REGESPTRIB:TEXT = "0","Nenhum","-" )," - "),1,nMxCol41), oFont07:oFont) //Regime Especial de Tributa��o

	//Linha 3
	nLinea := nLinea+nLiCabec 
	oDanfse:Say(nLinea, 002, "Tipo de Imunidade", oFont07N:oFont)
	oDanfse:Say(nLinea, 200, "Suspens�o de Exigibilidade do ISSQN", oFont07N:oFont)
	oDanfse:Say(nLinea, 350, "N�mero Processo Suspens�o", oFont07N:oFont)
	oDanfse:Say(nLinea, 480, "Benef�cio Municipal", oFont07N:oFont)
	nLinea := nLinea+nLiDados 
	oDanfse:Say(nLinea, 002, SUBSTR(IIF(Type("ONFSE:_DPS:_INFDPS:_VALORES:_TRIB:_TRIBMUN:_TPIMUNIDADE") <> "U",ONFSE:_DPS:_INFDPS:_VALORES:_TRIB:_TRIBMUN:_TPIMUNIDADE:TEXT," - "),1,nMxCol11), oFont07:oFont) //Tipo de Imunidade
	oDanfse:Say(nLinea, 200, Substr(IIF(Type("ONFSE:_DPS:_INFDPS:_VALORES:_TRIB:_TRIBMUN:_EXIGSUSP:_TPSUSP") <> "U",ONFSE:_DPS:_INFDPS:_VALORES:_TRIB:_TRIBMUN:_EXIGSUSP:_TPSUSP:TEXT," - "),1,nMxCol21), oFont07:oFont) //Suspens�o de Exigibilidade do ISSQN
	oDanfse:Say(nLinea, 350, Substr(IIF(Type("ONFSE:_DPS:_INFDPS:_VALORES:_TRIB:_TRIBMUN:_EXIGSUSP:_NPROCESSO") <> "U",ONFSE:_DPS:_INFDPS:_VALORES:_TRIB:_TRIBMUN:_EXIGSUSP:_NPROCESSO:TEXT," - "),1,nMxCol31), oFont07:oFont) //N�mero Processo Suspens�o
	oDanfse:Say(nLinea, 480, Substr(IIF(Type("ONFSE:_DPS:_INFDPS:_VALORES:_TRIB:_TRIBMUN:_BM:_NBM") <> "U",ONFSE:_DPS:_INFDPS:_VALORES:_TRIB:_TRIBMUN:_BM:_NBM:TEXT," - "),1,nMxCol41), oFont07:oFont) //Benef�cio Municipal

	//Linha 4
	nLinea := nLinea+nLiCabec 
	oDanfse:Say(nLinea, 002, "Valor do Servi�o", oFont07N:oFont)
	oDanfse:Say(nLinea, 200, "Desconto Incondicionado", oFont07N:oFont)
	oDanfse:Say(nLinea, 350, "Total de Dedu��es/Redu��es", oFont07N:oFont)
	oDanfse:Say(nLinea, 480, "C�lculo do BM", oFont07N:oFont)
	nLinea := nLinea+nLiDados 
	oDanfse:Say(nLinea, 002, SUBSTR(IIF(Type("ONFSE:_DPS:_INFDPS:_VALORES:_VSERVPREST:_VSERV") <> "U",ONFSE:_DPS:_INFDPS:_VALORES:_VSERVPREST:_VSERV:TEXT," - "),1,nMxCol11), oFont07:oFont) //Valor do Servi�o
	oDanfse:Say(nLinea, 200, Substr(IIF(Type("oNFSE:_DPS:_INFDPS:_VALORES:_VDESCCONDINCOND:_VDESCINCOND") <> "U",oNFSE:_DPS:_INFDPS:_VALORES:_VDESCCONDINCOND:_VDESCINCOND:TEXT," - "),1,nMxCol21), oFont07:oFont) //Desconto Incondicionado
	oDanfse:Say(nLinea, 350, Substr(IIF(Type("ONFSE:_DPS:_INFDPS:_VALORES:_VDEDRED:_VDR") <> "U",ONFSE:_DPS:_INFDPS:_VALORES:_VDEDRED:_VDR:TEXT," - ") ,1,nMxCol31), oFont07:oFont) //Total de Dedu��es/Redu��es
	oDanfse:Say(nLinea, 480, Substr(IIF(Type("XXXXXXXXXX") <> "U","XXXXXXXXXX"," - "),1,nMxCol41), oFont07:oFont) //C�lculo do BM

	//Linha 5
	nLinea := nLinea+nLiCabec 
	oDanfse:Say(nLinea, 002, "BC ISSQN", oFont07N:oFont)
	oDanfse:Say(nLinea, 200, "Al�quota Aplicada", oFont07N:oFont)
	oDanfse:Say(nLinea, 350, "Reten��o do ISSQN", oFont07N:oFont)
	oDanfse:Say(nLinea, 480, "ISSQN Apurado", oFont07N:oFont)
	nLinea := nLinea+nLiDados 
	oDanfse:Say(nLinea, 002, SUBSTR(convType(SF2->F2_BASEISS,15,2),1,nMxCol11), oFont07:oFont) //BC ISSQN 
	oDanfse:Say(nLinea, 200, Substr(convType((SF2->F2_VALISS*100)/SF2->F2_BASEISS,3,2),1,nMxCol21), oFont07:oFont) //Al�quota Aplicada
	oDanfse:Say(nLinea, 350, Substr(IIF(Type("oNFSE:_DPS:_INFDPS:_VALORES:_TRIB:_TRIBMUN:_TPRETISSQN") <> "U",IIF(AllTrim(oNFSE:_DPS:_INFDPS:_VALORES:_TRIB:_TRIBMUN:_TPRETISSQN:TEXT)=="1", "N�o retido","Retido" )," - ") ,1,nMxCol31), oFont07:oFont) //Reten��o do ISSQN
	oDanfse:Say(nLinea, 480, Substr(convType(SF2->F2_VALISS,15,2),1,nMxCol41), oFont07:oFont) //ISSQN Apurado


	// LINHA DE QUEBRA
	nLinea := nLinea+nLiQuebr 
	oDanfse:Line(nLinea, nIniLin,nLinea, nFimLin)


	// TRIBUTA��O FEDERAL
	//Linha 1
	nLinea := nLinea+nLiCabec
	oDanfse:Say(nLinea, 002, "TRIBUTA��O FEDERAL", oFont07N:oFont)

	//Linha 2
	nLinea := nLinea+nLiCabec 
	oDanfse:Say(nLinea, 002, "IRRF", oFont07N:oFont)
	oDanfse:Say(nLinea, 200, "CP", oFont07N:oFont)
	oDanfse:Say(nLinea, 350, "CSLL", oFont07N:oFont)
	nLinea := nLinea+nLiDados 
	oDanfse:Say(nLinea, 002, SUBSTR(IIF(Type("oNFSE:_DPS:_INFDPS:_VALORES:_TRIB:_TRIBFED:_VRETIRRF") <> "U",oNFSE:_DPS:_INFDPS:_VALORES:_TRIB:_TRIBFED:_VRETIRRF:TEXT," - ") ,1,nMxCol11), oFont07:oFont) //IRRF
	oDanfse:Say(nLinea, 200, Substr(IIF(Type("oNFSE:_DPS:_INFDPS:_VALORES:_TRIB:_TRIBFED:_VRETCP") <> "U",oNFSE:_DPS:_INFDPS:_VALORES:_TRIB:_TRIBFED:_VRETCP:TEXT," - "),1,nMxCol21), oFont07:oFont) //CP
	oDanfse:Say(nLinea, 350, Substr(IIF(Type("oNFSE:_DPS:_INFDPS:_VALORES:_TRIB:_TRIBFED:_VRETCSLL") <> "U",oNFSE:_DPS:_INFDPS:_VALORES:_TRIB:_TRIBFED:_VRETCSLL:TEXT," - ") ,1,nMxCol31), oFont07:oFont) //CSLL


	//Linha 3
	nLinea := nLinea+nLiCabec 
	oDanfse:Say(nLinea, 002, "PIS", oFont07N:oFont)
	oDanfse:Say(nLinea, 200, "COFINS", oFont07N:oFont)
	oDanfse:Say(nLinea, 350, "Reten��o do PIS/COFINS", oFont07N:oFont)
	oDanfse:Say(nLinea, 480, "TOTAL TRIBUTA��O FEDERAL", oFont07N:oFont)
	nLinea := nLinea+nLiDados 
	oDanfse:Say(nLinea, 002, SUBSTR(IIF(Type("oNFSE:_DPS:_INFDPS:_VALORES:_TRIB:_TRIBFED:_PISCOFINS:_VPIS") <> "U",oNFSE:_DPS:_INFDPS:_VALORES:_TRIB:_TRIBFED:_PISCOFINS:_VPIS:TEXT," - "),1,nMxCol11), oFont07:oFont) //PIS
	oDanfse:Say(nLinea, 200, Substr(IIF(Type("oNFSE:_DPS:_INFDPS:_VALORES:_TRIB:_TRIBFED:_PISCOFINS:_VCOFINS") <> "U",oNFSE:_DPS:_INFDPS:_VALORES:_TRIB:_TRIBFED:_PISCOFINS:_VCOFINS:TEXT," - ") ,1,nMxCol21), oFont07:oFont) //COFINS
	oDanfse:Say(nLinea, 350, Substr(IIF(Type("oNFSE:_DPS:_INFDPS:_VALORES:_TRIB:_TRIBFED:_PISCOFINS:_TPRETPISCOFINS") <> "U",oNFSE:_DPS:_INFDPS:_VALORES:_TRIB:_TRIBFED:_PISCOFINS:_TPRETPISCOFINS:TEXT," - "),1,nMxCol31), oFont07:oFont) //Reten��o do PIS/COFINS
	oDanfse:Say(nLinea, 480, Substr(IIF(Type("oNFSE:_DPS:_INFDPS:_VALORES:_TRIB:_TOTTRIB:_PTOTTRIB:_PTOTTRIBFED") <> "U",oNFSE:_DPS:_INFDPS:_VALORES:_TRIB:_TOTTRIB:_PTOTTRIB:_PTOTTRIBFED:TEXT," - ") ,1,nMxCol41), oFont07:oFont) //TOTAL TRIBUTA��O FEDERAL


	// LINHA DE QUEBRA
	nLinea := nLinea+nLiQuebr 
	oDanfse:Line(nLinea, nIniLin,nLinea, nFimLin)


	// VALOR TOTAL DA NFS-E
	//Linha 1
	nLinea := nLinea+nLiCabec 
	oDanfse:Say(nLinea, 002, "VALOR TOTAL DA NFS-E", oFont07N:oFont)

	//Linha 2
	nLinea := nLinea+nLiCabec 
	oDanfse:Say(nLinea, 002, "Valor do Servi�o", oFont07N:oFont)
	oDanfse:Say(nLinea, 200, "Desconto Condicionado", oFont07N:oFont)
	oDanfse:Say(nLinea, 350, "Desconto Incondicionado", oFont07N:oFont)
	oDanfse:Say(nLinea, 480, "ISSQN Retido", oFont07N:oFont)
	nLinea := nLinea+nLiDados 
	oDanfse:Say(nLinea, 002, SUBSTR(IIF(Type("ONFSE:_DPS:_INFDPS:_VALORES:_VSERVPREST:_VSERV") <> "U",ONFSE:_DPS:_INFDPS:_VALORES:_VSERVPREST:_VSERV:TEXT," - ") ,1,nMxCol11), oFont07:oFont) //Valor do Servi�o
	oDanfse:Say(nLinea, 200, Substr(IIF(Type("oNFSE:_DPS:_INFDPS:_VALORES:_VDESCCONDINCOND:_VDESCCOND") <> "U",oNFSE:_DPS:_INFDPS:_VALORES:_VDESCCONDINCOND:_VDESCCOND:TEXT," - "),1,nMxCol21), oFont07:oFont) //Desconto Condicionado
	oDanfse:Say(nLinea, 350, Substr(IIF(Type("oNFSE:_DPS:_INFDPS:_VALORES:_VDESCCONDINCOND:_VDESCINCOND") <> "U",oNFSE:_DPS:_INFDPS:_VALORES:_VDESCCONDINCOND:_VDESCINCOND:TEXT," - "),1,nMxCol31), oFont07:oFont) //Desconto Incondicionado
	oDanfse:Say(nLinea, 480, Substr(IIF(Type("XXXXXXXXXX") <> "U","XXXXXXXXXX"," - "),1,nMxCol41), oFont07:oFont) //ISSQN Retido

	//Linha 3
	nLinea := nLinea+nLiCabec 
	oDanfse:Say(nLinea, 002, "IRRF, CP, CSLL - Retidos", oFont07N:oFont)
	oDanfse:Say(nLinea, 200, "PIS/COFINS Retidos", oFont07N:oFont)
	oDanfse:Say(nLinea, 480, "Valor L�quido da NFS-e", oFont07N:oFont)
	nLinea := nLinea+nLiDados 
	oDanfse:Say(nLinea, 002, Substr(cValToChar(IIF(Type("oNFSE:_DPS:_INFDPS:_VALORES:_TRIB:_TRIBFED:_VRETIRRF") <> "U",VAL(oNFSE:_DPS:_INFDPS:_VALORES:_TRIB:_TRIBFED:_VRETIRRF:TEXT),0)+IIF(Type("oNFSE:_RPS:_VALORES:_CP") <> "U",VAL(oNFSE:_RPS:_VALORES:CP:TEXT),0)+IIF(Type("oNFSE:_DPS:_INFDPS:_VALORES:_TRIB:_TRIBFED:_VRETCSLL") <> "U",VAL(oNFSE:_DPS:_INFDPS:_VALORES:_TRIB:_TRIBFED:_VRETCSLL:TEXT),0)),1,nMxCol11), oFont07:oFont) //IRRF, CP, CSLL - Retidos
	oDanfse:Say(nLinea, 200, Substr(cValToChar(IIF(Type("oNFSE:_DPS:_INFDPS:_VALORES:_TRIB:_TRIBFED:_PISCOFINS:_VPIS") <> "U",VAL(oNFSE:_DPS:_INFDPS:_VALORES:_TRIB:_TRIBFED:_PISCOFINS:_VPIS:TEXT),0)+IIF(Type("oNFSE:_DPS:_INFDPS:_VALORES:_TRIB:_TRIBFED:_PISCOFINS:_VCOFINS") <> "U",VAL(oNFSE:_DPS:_INFDPS:_VALORES:_TRIB:_TRIBFED:_PISCOFINS:_VCOFINS:TEXT),0)),1,nMxCol21), oFont07:oFont) //PIS/COFINS Retidos
	oDanfse:Say(nLinea, 480, Substr(IIF(Type("XXXXXXXXXX") <> "U","XXXXXXXXXX"," - "),1,nMxCol41), oFont07:oFont) //Valor L�quido da NFS-e

	// LINHA DE QUEBRA
	nLinea := nLinea+nLiQuebr 
	oDanfse:Line(nLinea, nIniLin,nLinea, nFimLin)

	// TOTAIS APROXIMADOS DOS TRIBUTOS
	//Linha 1
	nLinea := nLinea+nLiCabec 
	oDanfse:Say(nLinea, 002, "TOTAIS APROXIMADOS DOS TRIBUTOS", oFont07N:oFont)

	//Linha 2
	nLinea := nLinea+nLiCabec 
	oDanfse:Say(nLinea, 100, "Federais", oFont07N:oFont)
	oDanfse:Say(nLinea, 300, "Estaduais", oFont07N:oFont)
	oDanfse:Say(nLinea, 500, "Municipais", oFont07N:oFont)
	nLinea := nLinea+nLiDados 
	oDanfse:Say(nLinea, 100, Substr(IIF(Type("oNFSE:_DPS:_INFDPS:_VALORES:_TRIB:_TOTTRIB:_PTOTTRIB:_PTOTTRIBFED") <> "U",oNFSE:_DPS:_INFDPS:_VALORES:_TRIB:_TOTTRIB:_PTOTTRIB:_PTOTTRIBFED:TEXT," - "),1,nMxTrib) + "%", oFont07:oFont) //Federais
	oDanfse:Say(nLinea, 300, Substr(IIF(Type("oNFSE:_DPS:_INFDPS:_VALORES:_TRIB:_TOTTRIB:_PTOTTRIB:_PTOTTRIBEST") <> "U",oNFSE:_DPS:_INFDPS:_VALORES:_TRIB:_TOTTRIB:_PTOTTRIB:_PTOTTRIBEST:TEXT," - "),1,nMxTrib) + "%", oFont07:oFont) //Estaduais
	oDanfse:Say(nLinea, 500, Substr(IIF(Type("oNFSE:_DPS:_INFDPS:_VALORES:_TRIB:_TOTTRIB:_PTOTTRIB:_PTOTTRIBMUN") <> "U",oNFSE:_DPS:_INFDPS:_VALORES:_TRIB:_TOTTRIB:_PTOTTRIB:_PTOTTRIBMUN:TEXT," - "),1,nMxTrib) + "%", oFont07:oFont) //Municipais



	// LINHA DE QUEBRA
	nLinea := nLinea+nLiQuebr 
	oDanfse:Line(nLinea, nIniLin,nLinea, nFimLin)

	// INFORMA��ES COMPLEMENTARES
	//Linha 1
	nLinea := nLinea+nLiCabec 
	oDanfse:Say(nLinea, 002, "INFORMA��ES COMPLEMENTARES", oFont07N:oFont)
	//Linha 2
	For nX := 1 To len(aInfNota)
		nLinea := nLinea+nLiDados
		oDanfse:Say(nLinea, 002, aInfNota[nX], oFont07:oFont) //INFORMA��ES COMPLEMENTARES
	Next

	oDanfse:EndPage()

Else // Layout Impress�o Prefeitura / Municipio / Provedor

	//CABE�ALHO
    cMunicipio := IIF(Type("oNFSE:_RPS:_PRESTADOR:_CIDADE") <> "U",oNFSE:_RPS:_PRESTADOR:_CIDADE:TEXT,"-") + " - " +  IIF(Type("oNFSE:_RPS:_PRESTADOR:_UF") <> "U",oNFSE:_RPS:_PRESTADOR:_UF:TEXT,"-")
	oDanfse:Say(010, 220, "DEMONSTRATIVO DA NOTA FISCAL DE SERVI�O", oFont10N:oFont,,/*CLR_HRED*/)
	oDanfse:Say(020, 240, "Emitida em "+cMunicipio, oFont09N:oFont,,/*CLR_HRED*/)
	oDanfse:Say(030, 230, "ESTE DOCUMENTO N�O TEM VALOR FISCAL", oFont10:oFont,,CLR_HRED)		


	//Linha 1
	oDanfse:Say(040, 002, "Codigo de Verifica��o da NFS-e", oFont07N:oFont)
	oDanfse:Say(048, 002, aXMLRet[9] , oFont07:oFont)

	nLinea := 048
	nLiCabec := 10
	nLiDados := 8
	nLiQuebr := 4
	nIniLin  := 0003
	nFimLin	 := 0605
	// Testes
	lTemTom	 := .T. // Tem Tomador
	lTemInt	 := type("oNFSE:_RPS:_INTERMEDIARIO") <> "U"  // Tem Intermediario
	nNumSer	 := 28  // Numero de servi�os prestados 
	// -------------------------------------------------------------------------------------------

	//Linha 2
	nLinea := nLinea+nLiCabec 
	oDanfse:Say(nLinea, 002, "N�mero da NFS-e", oFont07N:oFont)
	oDanfse:Say(nLinea, 200, "Compet�ncia da NFS-e", oFont07N:oFont)
	oDanfse:Say(nLinea, 350, "Data e Hora da emiss�o da NFS-e", oFont07N:oFont)

	cCompetencia := IIF(Type("oNFSE:_RPS:_IDENTIFICACAO:_COMPETENCIARPS")<> "U", oNFSE:_RPS:_IDENTIFICACAO:_COMPETENCIARPS:TEXT,'')
	cCompetencia := IIF(!Empty(cCompetencia),Substr(cCompetencia,9,2)+"/"+Substr(cCompetencia,6,2)+"/"+Substr(cCompetencia,1,4),"-")

	nLinea := nLinea+nLiDados 
	oDanfse:Say(nLinea, 002, Substr(aXMLRet[6],1,nMxCol11), oFont07:oFont) //N�mero da NFS-e
	oDanfse:Say(nLinea, 200, Substr(cCompetencia,1,nMxCol21) , oFont07:oFont) //Compet�ncia da NFS-e
	oDanfse:Say(nLinea, 350, Substr(IIF(Type("oNFSE:_RPS:_IDENTIFICACAO:_DTHREMISSAO") <> "U",oNFSE:_RPS:_IDENTIFICACAO:_DTHREMISSAO:TEXT,"-"),1,nMxCol31), oFont07:oFont) //Data e Hora da emiss�o da NFS-e


	//Linha 3

	nLinea := nLinea+nLiCabec 
	oDanfse:Say(nLinea, 002, "N�mero da RPS", oFont07N:oFont)
	oDanfse:Say(nLinea, 200, "S�rie da RPS", oFont07N:oFont)
	oDanfse:Say(nLinea, 350, "Data e Hora da emiss�o da DPS", oFont07N:oFont)
	nLinea := nLinea+nLiDados 
	oDanfse:Say(nLinea, 002, Substr(IIF(type("oNFSE:_RPS:_IDENTIFICACAO:_NUMERORPS") <> "U",oNFSE:_RPS:_IDENTIFICACAO:_NUMERORPS:TEXT,"-"),1,nMxCol11), oFont07:oFont) //N�mero da DPS    
	oDanfse:Say(nLinea, 200, Substr(IIF(type("oNFSE:_RPS:_IDENTIFICACAO:_SERIERPS") <> "U",oNFSE:_RPS:_IDENTIFICACAO:_SERIERPS:TEXT,"-"),1,nMxCol21), oFont07:oFont) //S�rie da DPS
	oDanfse:Say(nLinea, 350, Substr(IIF(type("oNFSE:_RPS:_IDENTIFICACAO:_DTHREMISSAO") <> "U",oNFSE:_RPS:_IDENTIFICACAO:_DTHREMISSAO:TEXT,"-"),1,nMxCol31), oFont07:oFont) //Data e Hora da emiss�o da DPS

	//BLOCO DE AUTENTICIDADE
	oDanfse:Say(066, 480, "A autenticidade dessa NFS-e pode ser verificada", oFont05N:oFont)
	oDanfse:Say(074, 480, "atrav�s do portal da prefeitura utilizando o " , oFont05N:oFont) 
	oDanfse:Say(082, 480, "Codigo de Verifica��o ou o n�mero da nota", oFont05N:oFont)

	// LINHA DE QUEBRA
	nLinea := nLinea+nLiQuebr 
	oDanfse:Line(nLinea, nIniLin,nLinea, nFimLin)	

	// DADOS EMITENTE
	//Linha 1
	if type("oNFSE:_RPS:_PRESTADOR:_CPFCNPJ") <> "U"
		cCpfcnpj := Alltrim(oNFSE:_RPS:_PRESTADOR:_CPFCNPJ:TEXT)
		cCpfcnpj := iif( len(cCpfcnpj)==14, Transform(cCpfcnpj,"@r 99.999.999/9999-99"),Transform(cCpfcnpj,"@r 999.999.999-99") )
	Endif 

	nLinea := nLinea+nLiCabec 
	oDanfse:Say(nLinea, 002, "EMITENTE DA NFS-e", oFont07N:oFont)
	oDanfse:Say(nLinea, 200, "CNPJ / CPF/ NIF", oFont07N:oFont)
	oDanfse:Say(nLinea, 350, "Inscri��o Municipal", oFont07N:oFont)
	oDanfse:Say(nLinea, 480, "Telefone", oFont07N:oFont)
	nLinea := nLinea+nLiDados 
	//oDanfse:Say(nLinea, 002, Substr(IIF(Type("oNFSE:_RPS:_PRESTADOR:_RAZAO") <> "U",oNFSE:_RPS:_PRESTADOR:_RAZAO:TEXT,"-"),1,nMxCol11), oFont07:oFont) //EMITENTE DA NFS-e
	oDanfse:Say(nLinea, 200, Substr(IIF(Type("oNFSE:_RPS:_PRESTADOR:_CPFCNPJ") <> "U",cCpfcnpj,"-"),1,nMxCol21), oFont07:oFont) //CNPJ / CPF/ NIF
	oDanfse:Say(nLinea, 350, Substr(IIF(Type("oNFSE:_RPS:_PRESTADOR:_INSCMUN") <> "U",oNFSE:_RPS:_PRESTADOR:_INSCMUN:TEXT,"-"),1,nMxCol31), oFont07:oFont) //Inscri��o Municipal
	oDanfse:Say(nLinea, 480, Substr(IIF(Type("oNFSE:_RPS:_PRESTADOR:_DDD") <> "U",oNFSE:_RPS:_PRESTADOR:_DDD:TEXT,"-") + IIF(Type("oNFSE:_RPS:_PRESTADOR:_TELEFONE") <> "U",oNFSE:_RPS:_PRESTADOR:_TELEFONE:TEXT,"-"),1,nMxCol41), oFont07:oFont) //Telefone



	//Linha 2
	nLinea := nLinea+nLiCabec 
	oDanfse:Say(nLinea, 002, "Nome / Raz�o Social", oFont07N:oFont)
	oDanfse:Say(nLinea, 350, "E-mail", oFont07N:oFont)
	nLinea := nLinea+nLiDados 
	oDanfse:Say(nLinea, 002, SUBSTR(IIF(Type("oNFSE:_RPS:_PRESTADOR:_RAZAO") <> "U",oNFSE:_RPS:_PRESTADOR:_RAZAO:TEXT,"-"),1,nMxCol12) , oFont07:oFont) //Nome / Raz�o Social
	oDanfse:Say(nLinea, 350, SUBSTR(IIF(Type("oNFSE:_RPS:_PRESTADOR:_EMAIL") <> "U",oNFSE:_RPS:_PRESTADOR:_EMAIL:TEXT,"-"),1,nMxCol32), oFont07:oFont) //mail

	//Linha 3
	nLinea := nLinea+nLiCabec 
	oDanfse:Say(nLinea, 002, "Endere�o", oFont07N:oFont)
	oDanfse:Say(nLinea, 350, "Municipo", oFont07N:oFont)
	oDanfse:Say(nLinea, 480, "CEP", oFont07N:oFont)
	nLinea := nLinea+nLiDados 
	oDanfse:Say(nLinea, 002, SUBSTR(IIF(Type("oNFSE:_RPS:_PRESTADOR:_LOGRADOURO") <> "U",oNFSE:_RPS:_PRESTADOR:_LOGRADOURO:TEXT,"-") + "," + IIF(Type("oNFSE:_RPS:_PRESTADOR:_NUMEND") <> "U",oNFSE:_RPS:_PRESTADOR:_NUMEND:TEXT,"-"),1,nMxCol12), oFont07:oFont) //Endere�o
	oDanfse:Say(nLinea, 350, Substr(IIF(Type("oNFSE:_RPS:_PRESTADOR:_CIDADE") <> "U",oNFSE:_RPS:_PRESTADOR:_CIDADE:TEXT,"-"),1,nMxCol31), oFont07:oFont) //Municipo
	oDanfse:Say(nLinea, 480, Substr(IIF(Type("oNFSE:_RPS:_PRESTADOR:_CEP") <> "U",oNFSE:_RPS:_PRESTADOR:_CEP:TEXT,"-"),1,nMxCol41), oFont07:oFont) //CEP

	//Linha 4
	nLinea := nLinea+nLiCabec 
	oDanfse:Say(nLinea, 002, "Simples Nacional na Data de compet�ncia", oFont07N:oFont)
	oDanfse:Say(nLinea, 350, "Regime de Apura��o Tibut�ria pelo SN", oFont07N:oFont)

	cSimpNac 	:="2-N�o optante"
	IF Type("oNFSE:_RPS:_PRESTADOR:_SIMPNAC") <> "U" .and. oNFSE:_RPS:_PRESTADOR:_SIMPNAC:TEXT == "1"
		cSimpNac 	:= "1-Optante" 
	EndIF
	cRegesp	:= "-"
	IF Type("oNFSE:_RPS:_IDENTIFICACAO:_REGIMEESPTRIB") <> "U" .and. !Empty(cSimpNac) .and. oNFSE:_RPS:_PRESTADOR:_SIMPNAC:TEXT == "1" // Valido se � ou n�o simples nacional para preencher.
		cRegesp	:= 	fRegesp( oNFSE:_RPS:_IDENTIFICACAO:_REGIMEESPTRIB:TEXT )
	EndIF 

	nLinea := nLinea+nLiDados 
	oDanfse:Say(nLinea, 002, SUBSTR(cSimpNac,1,nMxCol12), oFont07:oFont) //Simples Nacional na Data de compet�ncia
	oDanfse:Say(nLinea, 350, SUBSTR(cRegesp,1,nMxCol32), oFont07:oFont) //Regime de Apura��o Tibut�ria pelo SN

	// LINHA DE QUEBRA
	nLinea := nLinea+nLiQuebr 
	oDanfse:Line(nLinea, nIniLin,nLinea, nFimLin)	

	// TOMADOR DO SERVI�O
	IF lTemTom

		if type("oNFSE:_RPS:_TOMADOR:_CPFCNPJ") <> "U"
			cCpfcnpj := Alltrim(oNFSE:_RPS:_TOMADOR:_CPFCNPJ:TEXT)
			cCpfcnpj := iif( len(cCpfcnpj)==14, Transform(cCpfcnpj,"@r 99.999.999/9999-99"),Transform(cCpfcnpj,"@r 999.999.999-99") )
		Endif 

		//Linha 1
		nLinea := nLinea+nLiCabec 
		oDanfse:Say(nLinea, 002, "TOMADOR DO SERVI�O", oFont07N:oFont)
		oDanfse:Say(nLinea, 200, "CNPJ / CPF/ NIF", oFont07N:oFont)
		oDanfse:Say(nLinea, 350, "Inscri��o Municipal", oFont07N:oFont)
		oDanfse:Say(nLinea, 480, "Telefone", oFont07N:oFont)
		nLinea := nLinea+nLiDados 
		//oDanfse:Say(nLinea, 002, substr(IIF(Type("oNFSE:_RPS:_TOMADOR:_RAZAO") <> "U",oNFSE:_RPS:_TOMADOR:_RAZAO:TEXT,"-"),1,nMxCol11), oFont07:oFont) //TOMADOR DO SERVI�O
		oDanfse:Say(nLinea, 200, Substr(IIF(Type("oNFSE:_RPS:_TOMADOR:_CPFCNPJ") <> "U",cCpfcnpj,"-"),1,nMxCol21), oFont07:oFont) //CNPJ / CPF/ NIF
		oDanfse:Say(nLinea, 350, Substr(IIF(Type("oNFSE:_RPS:_TOMADOR:_INSCMUN") <> "U",oNFSE:_RPS:_TOMADOR:_INSCMUN:TEXT,"-"),1,nMxCol31), oFont07:oFont) //Inscri��o Municipal
		oDanfse:Say(nLinea, 480, Substr(IIF(Type("oNFSE:_RPS:_TOMADOR:_DDD") <> "U",oNFSE:_RPS:_TOMADOR:_DDD:TEXT,"-") + "   " + IIF(Type("oNFSE:_RPS:_TOMADOR:_TELEFONE") <> "U",oNFSE:_RPS:_TOMADOR:_TELEFONE:TEXT,"-"),1,nMxCol41), oFont07:oFont) //Telefone

		//Linha 2
		nLinea := nLinea+nLiCabec 
		oDanfse:Say(nLinea, 002, "Nome / Raz�o Social", oFont07N:oFont)
		oDanfse:Say(nLinea, 350, "E-mail", oFont07N:oFont)
		nLinea := nLinea+nLiDados 
		oDanfse:Say(nLinea, 002, SUBSTR(IIF(Type("oNFSE:_RPS:_TOMADOR:_RAZAO") <> "U",oNFSE:_RPS:_TOMADOR:_RAZAO:TEXT,"-"),1,nMxCol12), oFont07:oFont) //Nome / Raz�o Social
		oDanfse:Say(nLinea, 350, SUBSTR(IIF(Type("oNFSE:_RPS:_TOMADOR:_EMAIL") <> "U",oNFSE:_RPS:_TOMADOR:_EMAIL:TEXT,"-"),1,nMxCol32), oFont07:oFont) //mail

		//Linha 3
		nLinea := nLinea+nLiCabec 
		oDanfse:Say(nLinea, 002, "Endere�o", oFont07N:oFont)
		oDanfse:Say(nLinea, 350, "Municipo", oFont07N:oFont)
		oDanfse:Say(nLinea, 480, "CEP", oFont07N:oFont)
		nLinea := nLinea+nLiDados 
		oDanfse:Say(nLinea, 002, SUBSTR(IIF(Type("oNFSE:_RPS:_TOMADOR:_LOGRADOURO") <> "U",oNFSE:_RPS:_TOMADOR:_LOGRADOURO:TEXT,"-") +","+IIF(Type("oNFSE:_RPS:_TOMADOR:_NUMEND") <> "U",oNFSE:_RPS:_TOMADOR:_NUMEND:TEXT,"-"),1,nMxCol12), oFont07:oFont) //Endere�o
		oDanfse:Say(nLinea, 350, Substr(IIF(Type("oNFSE:_RPS:_TOMADOR:_CIDADE") <> "U",oNFSE:_RPS:_TOMADOR:_CIDADE:TEXT,"-"),1,nMxCol31), oFont07:oFont) //Municipo
		oDanfse:Say(nLinea, 480, Substr(IIF(Type("oNFSE:_RPS:_TOMADOR:_CEP") <> "U",oNFSE:_RPS:_TOMADOR:_CEP:TEXT,"-"),1,nMxCol41), oFont07:oFont) //CEP
	Else
		nLinea := nLinea+nLiCabec 
		oDanfse:Say(nLinea, 200, "TOMADOR DO SERVI�O N�O IDENTIFICADO NA NFSE-e", oFont07:oFont,,CLR_HRED)
	EndIF

	// LINHA DE QUEBRA
	nLinea := nLinea+nLiQuebr 
	oDanfse:Line(nLinea, nIniLin,nLinea, nFimLin)	

	// TOMADOR DO INTERMEDIARIO
	IF lTemInt

		if type("oNFSE:_RPS:_INTERMEDIARIO:_CPFCNPJ") <> "U"
			cCpfcnpj := Alltrim(oNFSE:_RPS:_INTERMEDIARIO:_CPFCNPJ:TEXT)
			cCpfcnpj := iif( len(cCpfcnpj)==14, Transform(cCpfcnpj,"@r 99.999.999/9999-99"),Transform(cCpfcnpj,"@r 999.999.999-99") )
		Endif 
		//Linha 1
		nLinea := nLinea+nLiCabec 
		oDanfse:Say(nLinea, 002, "INTERMEDI�RIO DO SERVI�O", oFont07N:oFont,,CLR_HRED)
		oDanfse:Say(nLinea, 200, "CNPJ / CPF/ NIF", oFont07N:oFont)
		oDanfse:Say(nLinea, 350, "Inscri��o Municipal", oFont07N:oFont)
		oDanfse:Say(nLinea, 480, "Telefone", oFont07N:oFont)
		nLinea := nLinea+nLiDados //106
		//oDanfse:Say(nLinea, 002, Substr(IIF(type("oNFSE:_RPS:_INTERMEDIARIO:_RAZAO") <> "U",oNFSE:_RPS:_INTERMEDIARIO:_RAZAO:TEXT,"-"),1,nMxCol11), oFont07:oFont) //INTERMEDI�RIO DO SERVI�O
		oDanfse:Say(nLinea, 200, Substr(IIF(type("oNFSE:_RPS:_INTERMEDIARIO:_CPFCNPJ") <> "U",cCpfcnpj,"-"),1,nMxCol21), oFont07:oFont) //CNPJ / CPF/ NIF
		oDanfse:Say(nLinea, 350, Substr(IIF(Type("oNFSE:_RPS:_INTERMEDIARIO:_INSCMUN") <> "U",oNFSE:_RPS:_INTERMEDIARIO:_INSCMUN:TEXT,"-"),1,nMxCol31), oFont07:oFont) //Inscri��o Municipal
		oDanfse:Say(nLinea, 480, Substr(IIF(Type("XXXXXXXXXX") <> "U","XXXXXXXXXX","-"),1,nMxCol41), oFont07:oFont) //Telefone

		//Linha 2
		nLinea := nLinea+nLiCabec //116
		oDanfse:Say(nLinea, 002, "Nome / Raz�o Social", oFont07N:oFont)
		oDanfse:Say(nLinea, 350, "E-mail", oFont07N:oFont)
		nLinea := nLinea+nLiDados //124
		oDanfse:Say(nLinea, 002, Substr(IIF(type("oNFSE:_RPS:_INTERMEDIARIO:_RAZAO") <> "U",oNFSE:_RPS:_INTERMEDIARIO:_RAZAO:TEXT,"-"),1,nMxCol12), oFont07:oFont) //Nome / Raz�o Social
		oDanfse:Say(nLinea, 350, SUBSTR(IIF(Type("XXXXXXXXXX") <> "U","XXXXXXXXXX","-"),1,nMxCol32), oFont07:oFont) //mail

		//Linha 3
		nLinea := nLinea+nLiCabec //134
		oDanfse:Say(nLinea, 002, "Endere�o", oFont07N:oFont)
		oDanfse:Say(nLinea, 350, "Municipo", oFont07N:oFont)
		oDanfse:Say(nLinea, 480, "CEP", oFont07N:oFont)
		nLinea := nLinea+nLiDados //142
		oDanfse:Say(nLinea, 002, SUBSTR(IIF(Type("XXXXXXXXXX") <> "U","XXXXXXXXXX","-"),1,nMxCol12), oFont07:oFont) //Endere�o
		oDanfse:Say(nLinea, 350, Substr(IIF(Type("XXXXXXXXXX") <> "U","XXXXXXXXXX","-"),1,nMxCol31), oFont07:oFont) //Municipo
		oDanfse:Say(nLinea, 480, Substr(IIF(Type("XXXXXXXXXX") <> "U","XXXXXXXXXX","-"),1,nMxCol41), oFont07:oFont) //CEP
	ELSE
		nLinea := nLinea+nLiCabec 
		oDanfse:Say(nLinea, 200, "INTERMEDI�RIO DO SERVI�O N�O IDENTIFICADO NA NFSE-e", oFont07:oFont)
	EndIF

	// LINHA DE QUEBRA
	nLinea := nLinea+nLiQuebr 
	oDanfse:Line(nLinea, nIniLin,nLinea, nFimLin)	


	If ( ValType(oNFSE:_rps:_servicos:_servico) == "A" )
		aServicos := oNFSE:_rps:_servicos:_servico
	Else
		aServicos := {oNFSE:_rps:_servicos:_servico}
	EndIf


	//SERVI�O PRESTADO
	//Linha 1
	nLinea := nLinea+nLiCabec 
	oDanfse:Say(nLinea, 002, "SERVI�O PRESTADO", oFont07N:oFont)

	IF Type("oNFSE:_RPS:_TOMADOR:_CODPAIS") <> "U"
		cCodBacen 	:= Alltrim(oNFSE:_RPS:_TOMADOR:_CODPAIS:TEXT)
		cPais 		:= danfsepais(cCodBacen)
	Endif 

	//Linha 2
	nLinea := nLinea+nLiCabec
	oDanfse:Say(nLinea, 002, "C�digo de Tributa��o", oFont07N:oFont)
	oDanfse:Say(nLinea, 200, "C�digo de Tributa��o Municipal", oFont07N:oFont)
	oDanfse:Say(nLinea, 350, "Local da Presta��o", oFont07N:oFont)
	oDanfse:Say(nLinea, 480, "Pa�s da Presta��o", oFont07N:oFont)
	nLinea := nLinea+nLiDados 
	oDanfse:Say(nLinea, 002, SUBSTR(IIF(Type("aServicos[1]:_CODIGO") <> "U",aServicos[1]:_CODIGO:TEXT,"-"),1,nMxCol11), oFont07:oFont) //C�digo de Tributa��o Nacional
	oDanfse:Say(nLinea, 200, Substr(IIF(Type("aServicos[1]:_CODTRIB")<>"U",aServicos[1]:_CODTRIB:TEXT,"-"),1,nMxCol21), oFont07:oFont) //C�digo de Tributa��o Municipal
	oDanfse:Say(nLinea, 350, Substr(IIF(Type("oNFSE:_RPS:_PRESTACAO:_MUNICIPIO") <> "U",oNFSE:_RPS:_PRESTACAO:_MUNICIPIO:TEXT,"-") + " - " +  IIF(Type("oNFSE:_RPS:_PRESTACAO:_UF") <> "U",oNFSE:_RPS:_PRESTACAO:_UF:TEXT,"-") ,1,nMxCol31), oFont07:oFont) //Local da Presta��o
	oDanfse:Say(nLinea, 480, Substr(cPais,1,nMxCol41), oFont07:oFont) //Pa�s da Presta��o

	//Linha 3
	nLinea := nLinea+nLiCabec 
	oDanfse:Say(nLinea, 002, "Descri��o do Servi�o", oFont07N:oFont)

	// Array de servi�o n�o pode ser superior 28 
	// nNumSer := IIF(len(array de servi�o) >= 28, 28, len(array de servi�o) )
	nServ := Len(aServicos)
	// soma valores para totais 
	For nX := 1 To nServ
		nValtot		+= IIF(Type("aServicos["+Alltrim(Str(nX))+"]:_valtotal:TEXT")<>"U",Val(aServicos[nX]:_valtotal:TEXT),0)
		nValDesinc 	+= IIF(Type("aServicos["+Alltrim(Str(nX))+"]:_descinc:TEXT")<>"U",Val(aServicos[nX]:_descinc:TEXT),0)
		nValDesCcond+= IIF(Type("aServicos["+Alltrim(Str(nX))+"]:_desccond:TEXT")<>"U",Val(aServicos[nX]:_desccond:TEXT),0)
		nValDedu 	+= IIF(Type("aServicos["+Alltrim(Str(nX))+"]:_VALDEDU:TEXT")<>"U",Val(aServicos[nX]:_VALDEDU:TEXT),0)
		nValredu 	+= IIF(Type("aServicos["+Alltrim(Str(nX))+"]:_VALREDU:TEXT")<>"U",Val(aServicos[nX]:_VALREDU:TEXT),0)
		nbasecalc   += IIF(Type("aServicos["+Alltrim(Str(nX))+"]:_basecalc:TEXT")<>"U",Val(aServicos[nX]:_basecalc:TEXT),0)
	Next nX

	IiF(nServ>28,nServ := 28,'')
	For nX := 1 To nServ 
		nLinea := nLinea+nLiDados 
		oDanfse:Say(nLinea, 002, IIF(Type("aServicos["+Alltrim(Str(nX))+"]:_DISCR:TEXT")<>"U",Substr(aServicos[nX]:_DISCR:TEXT,1,178),"-"), oFont07:oFont) //Descri��o do Servi�o
	Next


	// LINHA DE QUEBRA
	nLinea := nLinea+nLiQuebr 
	oDanfse:Line(nLinea, nIniLin,nLinea, nFimLin)

	// TRIBUTA��O MUNICIPAL
	//Linha 1
	nLinea := nLinea+nLiCabec 
	oDanfse:Say(nLinea, 002, "TRIBUTA��O MUNICIPAL", oFont07N:oFont)


	cDescTrib 	:= IIF(Type("oNFSE:_RPS:_IDENTIFICACAO:_TIPOTRIB")<>"U",  fTptrib( oNFSE:_RPS:_IDENTIFICACAO:_TIPOTRIB:TEXT ), "")
	cRegesp		:= IIF(Type("oNFSE:_RPS:_IDENTIFICACAO:_REGIMEESPTRIB") <> "U" ,fRegesp( oNFSE:_RPS:_IDENTIFICACAO:_REGIMEESPTRIB:TEXT ) ,"-")
	//Linha 2
	nLinea := nLinea+nLiCabec 
	oDanfse:Say(nLinea, 002, "Tributa��o do ISSQN", oFont07N:oFont)
	oDanfse:Say(nLinea, 200, "Pa�s Resultado da Presta��o do Servi�o", oFont07N:oFont)
	oDanfse:Say(nLinea, 350, "Munic�pio de Incid�ncia do ISSQN", oFont07N:oFont)
	oDanfse:Say(nLinea, 480, "Regime Especial de Tributa��o", oFont07N:oFont)
	nLinea := nLinea+nLiDados 
	oDanfse:Say(nLinea, 002, SUBSTR(IIF(!Empty(cDescTrib),cDescTrib,"-"),1,nMxCol11), oFont07:oFont) //Tributa��o do ISSQN
	oDanfse:Say(nLinea, 200, Substr(IIF(!Empty(cPais),cPais,"-") ,1,nMxCol21), oFont07:oFont) //Pa�s Resultado da PResta��o do Servi�o
	oDanfse:Say(nLinea, 350, Substr(IIF(Type("oNFSE:_RPS:_PRESTACAO:_CODMUNIBGEINC") <> "U" .and. !EMPTY(oNFSE:_RPS:_PRESTACAO:_CODMUNIBGEINC:TEXT ),oNFSE:_RPS:_PRESTACAO:_CODMUNIBGEINC:TEXT ,IIF(Type("oNFSE:_RPS:_PRESTACAO:_CODMUNIBGE") <> "U",oNFSE:_RPS:_PRESTACAO:_CODMUNIBGE:TEXT,"-")),1,nMxCol31), oFont07:oFont) //Munic�pio de Incid�ncia do ISSQN
	oDanfse:Say(nLinea, 480, Substr(IIF(!Empty(cRegesp),cRegesp,"-"),1,nMxCol41), oFont07:oFont) //Regime Especial de Tributa��o

	//Linha 3
	nLinea := nLinea+nLiCabec 
	oDanfse:Say(nLinea, 002, "N�mero Processo Suspens�o da exigibilidade", oFont07N:oFont)
	//oDanfse:Say(nLinea, 200, "Suspens�o de Exigibilidade do ISSQN", oFont07N:oFont)
	//oDanfse:Say(nLinea, 350, "Tipo de Imunidade", oFont07N:oFont)
	//oDanfse:Say(nLinea, 480, "Benef�cio Municipal", oFont07N:oFont)
	nLinea := nLinea+nLiDados 
	oDanfse:Say(nLinea, 002, SUBSTR(IIF(Type("oNFSE:_RPS:_PRESTADOR:_numproc") <> "U",oNFSE:_RPS:_PRESTADOR:_numproc:text,"-"),1,nMxCol11), oFont07:oFont) //N�mero Processo Suspens�o
	//oDanfse:Say(nLinea, 200, Substr(IIF(Type("XXXXXXXXXX") <> "U","XXXXXXXXXX","-"),1,nMxCol21), oFont07:oFont) //Suspens�o de Exigibilidade do ISSQN
	//oDanfse:Say(nLinea, 350, Substr(IIF(Type("XXXXXXXXXX") <> "U","XXXXXXXXXX","-"),1,nMxCol31), oFont07:oFont) //Tipo de Imunidade
	//oDanfse:Say(nLinea, 480, Substr(IIF(Type("XXXXXXXXXX") <> "U","XXXXXXXXXX","-"),1,nMxCol41), oFont07:oFont) //Benef�cio Municipal

	//Linha 4

	nLinea := nLinea+nLiCabec 
	oDanfse:Say(nLinea, 002, "Valor do Servi�o", oFont07N:oFont)
	oDanfse:Say(nLinea, 200, "Desconto Incondicionado", oFont07N:oFont)
	oDanfse:Say(nLinea, 350, "Total de Dedu��es/Redu��es", oFont07N:oFont)
	//oDanfse:Say(nLinea, 480, "C�lculo do BM", oFont07N:oFont)
	nLinea := nLinea+nLiDados 
	oDanfse:Say(nLinea, 002, SUBSTR(convType(nValtot,15,2 ),1,nMxCol11), oFont07:oFont) //Valor do Servi�o
	oDanfse:Say(nLinea, 200, Substr(convType(nValDesinc,15,2 ),1,nMxCol21), oFont07:oFont) //Desconto Incondicionado
	oDanfse:Say(nLinea, 350, Substr(convType(nValDedu+nValRedu,15,2 ) ,1,nMxCol31), oFont07:oFont) //Total de Dedu��es/Redu��es
	//oDanfse:Say(nLinea, 480, Substr(IIF(Type("XXXXXXXXXX") <> "U","XXXXXXXXXX","-"),1,nMxCol41), oFont07:oFont) //C�lculo do BM

	//Linha 5
	nLinea := nLinea+nLiCabec 
	oDanfse:Say(nLinea, 002, "BC ISSQN", oFont07N:oFont)
	oDanfse:Say(nLinea, 200, "Al�quota Aplicada", oFont07N:oFont)
	oDanfse:Say(nLinea, 350, "ISSQN Apurado", oFont07N:oFont)
	oDanfse:Say(nLinea, 480, "Reten��o do ISSQN", oFont07N:oFont)

	nLinea := nLinea+nLiDados  
	oDanfse:Say(nLinea, 002, SUBSTR(convType(nbasecalc,15,2 ),1,nMxCol11), oFont07:oFont) //BC ISSQN
	oDanfse:Say(nLinea, 200, Substr(IIF(Type("oNFSE:_RPS:_VALORES:_ALIQISS") <> "U",convType(val(oNFSE:_RPS:_VALORES:_ALIQISS:TEXT),15,2) ,"-") ,1,nMxCol21), oFont07:oFont) //Al�quota Aplicada
	oDanfse:Say(nLinea, 350, Substr(IIF(Type("oNFSE:_RPS:_VALORES:_ISS") <> "U",convType(val(oNFSE:_RPS:_VALORES:_ISS:TEXT),15,2) ,"-") ,1,nMxCol31), oFont07:oFont) //Reten��o do ISSQN
	oDanfse:Say(nLinea, 480, Substr(IIF(Type("oNFSE:_RPS:_VALORES:_ISSRET") <> "U",convType(val(oNFSE:_RPS:_VALORES:_ISSRET:TEXT),15,2) ,"-"),1,nMxCol41), oFont07:oFont) //ISSQN Apurado


	// LINHA DE QUEBRA
	nLinea := nLinea+nLiQuebr 
	oDanfse:Line(nLinea, nIniLin,nLinea, nFimLin)


	// TRIBUTA��O FEDERAL
	//Linha 1
	nLinea := nLinea+nLiCabec 
	oDanfse:Say(nLinea, 002, "TRIBUTA��O FEDERAL", oFont07N:oFont)

	//Linha 2
	nLinea := nLinea+nLiCabec 
	oDanfse:Say(nLinea, 002, "IRRF", oFont07N:oFont)
	oDanfse:Say(nLinea, 200, "INSS", oFont07N:oFont)
	oDanfse:Say(nLinea, 350, "CSLL", oFont07N:oFont)
	nLinea := nLinea+nLiDados 
	oDanfse:Say(nLinea, 002, SUBSTR(IIF(Type("oNFSE:_RPS:_VALORES:_IR") <> "U",convType(val(oNFSE:_RPS:_VALORES:_IR:TEXT),15,2),"-") ,1,nMxCol11), oFont07:oFont) //IRRF
	oDanfse:Say(nLinea, 200, Substr(IIF(Type("oNFSE:_RPS:_VALORES:_INSS") <> "U",convType(val(oNFSE:_RPS:_VALORES:_INSS:TEXT),15,2),"-"),1,nMxCol21), oFont07:oFont) //CP
	oDanfse:Say(nLinea, 350, Substr(IIF(Type("oNFSE:_RPS:_VALORES:_CSLL") <> "U",convType(val(oNFSE:_RPS:_VALORES:_CSLL:TEXT),15,2),"-") ,1,nMxCol31), oFont07:oFont) //CSLL


	//Linha 3
	nLinea := nLinea+nLiCabec 
	oDanfse:Say(nLinea, 002, "PIS", oFont07N:oFont)
	oDanfse:Say(nLinea, 200, "COFINS", oFont07N:oFont)
	//oDanfse:Say(nLinea, 350, "Reten��o do PIS/COFINS", oFont07N:oFont)
	oDanfse:Say(nLinea, 480, "TOTAL TRIBUTA��O FEDERAL", oFont07N:oFont)
	nLinea := nLinea+nLiDados 
	oDanfse:Say(nLinea, 002, SUBSTR(IIF(Type("oNFSE:_RPS:_VALORES:_PIS") <> "U",convType(val(oNFSE:_RPS:_VALORES:_PIS:TEXT),15,2),"-"),1,nMxCol11), oFont07:oFont) //PIS
	oDanfse:Say(nLinea, 200, Substr(IIF(Type("oNFSE:_RPS:_VALORES:_COFINS") <> "U",convType(val(oNFSE:_RPS:_VALORES:_COFINS:TEXT),15,2),"-") ,1,nMxCol21), oFont07:oFont) //COFINS
	//oDanfse:Say(nLinea, 350, Substr(IIF(Type("XXXXXXXXXX") <> "U","XXXXXXXXXX","-"),1,nMxCol31), oFont07:oFont) //Reten��o do PIS/COFINS
	cTotFed := cValToChar(IIF(Type("oNFSE:_RPS:_VALORES:_IR") <> "U",VAL(oNFSE:_RPS:_VALORES:_IR:TEXT),0)+IIF(Type("oNFSE:_RPS:_VALORES:_CSLL") <> "U",VAL(oNFSE:_RPS:_VALORES:_CSLL:TEXT),0)+IIF(Type("oNFSE:_RPS:_VALORES:_PIS") <> "U",VAL(oNFSE:_RPS:_VALORES:_PIS:TEXT),0)+IIF(Type("oNFSE:_RPS:_VALORES:_COFINS") <> "U",VAL(oNFSE:_RPS:_VALORES:_COFINS:TEXT),0))
	oDanfse:Say(nLinea, 480, Substr(convType(val(cTotFed),15,2),1,nMxCol41), oFont07:oFont) //TOTAL TRIBUTA��O FEDERAL


	// LINHA DE QUEBRA
	nLinea := nLinea+nLiQuebr 
	oDanfse:Line(nLinea, nIniLin,nLinea, nFimLin)


	// VALOR TOTAL DA NFS-E
	//Linha 1
	nLinea := nLinea+nLiCabec 
	oDanfse:Say(nLinea, 002, "VALOR TOTAL DA NFS-E", oFont07N:oFont)

	//Linha 2
	nLinea := nLinea+nLiCabec 
	oDanfse:Say(nLinea, 002, "Valor do Servi�o", oFont07N:oFont)
	oDanfse:Say(nLinea, 200, "Desconto Condicionado", oFont07N:oFont)
	oDanfse:Say(nLinea, 350, "Desconto Incondicionado", oFont07N:oFont)
	oDanfse:Say(nLinea, 480, "ISSQN Retido", oFont07N:oFont)
	nLinea := nLinea+nLiDados 
	oDanfse:Say(nLinea, 002, SUBSTR(IIF(Type("oNFSE:_RPS:_VALORES:_VALTOTDOC") <> "U",convType(val(oNFSE:_RPS:_VALORES:_VALTOTDOC:TEXT),15,2),"-") ,1,nMxCol11), oFont07:oFont) //Valor do Servi�o
	oDanfse:Say(nLinea, 200, Substr(convType(nValDesCcond,15,2),1,nMxCol21), oFont07:oFont) //Desconto Condicionado
	oDanfse:Say(nLinea, 350, Substr(convType(nValDesinc,15,2),1,nMxCol31), oFont07:oFont) //Desconto Incondicionado
	oDanfse:Say(nLinea, 480, Substr(IIF(Type("oNFSE:_RPS:_VALORES:_ISSRET") <> "U",convType(val(oNFSE:_RPS:_VALORES:_ISSRET:TEXT),15,2),"-"),1,nMxCol41), oFont07:oFont) //ISSQN Retido

	//Linha 3
	nLinea := nLinea+nLiCabec 
	oDanfse:Say(nLinea, 002, "IRRF, CP, CSLL - Retidos", oFont07N:oFont)
	oDanfse:Say(nLinea, 200, "PIS/COFINS Retidos", oFont07N:oFont)
	//oDanfse:Say(nLinea, 480, "Valor L�quido da NFS-e", oFont07N:oFont)
	nLinea := nLinea+nLiDados 
	oDanfse:Say(nLinea, 002, Substr(cValToChar(IIF(Type("oNFSE:_RPS:_VALORES:_IR") <> "U",VAL(oNFSE:_RPS:_VALORES:_IR:TEXT),0)+IIF(Type("oNFSE:_RPS:_VALORES:_CP") <> "U",VAL(oNFSE:_RPS:_VALORES:CP:TEXT),0)+IIF(Type("oNFSE:_RPS:_VALORES:_CSLL") <> "U",VAL(oNFSE:_RPS:_VALORES:_CSLL:TEXT),0)),1,nMxCol11), oFont07:oFont) //IRRF, CP, CSLL - Retidos
	oDanfse:Say(nLinea, 200, Substr(cValToChar(IIF(Type("oNFSE:_RPS:_VALORES:_PIS") <> "U",VAL(oNFSE:_RPS:_VALORES:_PIS:TEXT),0)+IIF(Type("oNFSE:_RPS:_VALORES:_COFINS") <> "U",VAL(oNFSE:_RPS:_VALORES:_COFINS:TEXT),0)),1,nMxCol21), oFont07:oFont) //PIS/COFINS Retidos
	//oDanfse:Say(nLinea, 480, Substr(IIF(Type("XXXXXXXXXX") <> "U","XXXXXXXXXX","-"),1,nMxCol41), oFont07:oFont) //Valor L�quido da NFS-e

	/*// LINHA DE QUEBRA
	nLinea := nLinea+nLiQuebr 
	oDanfse:Line(nLinea, nIniLin,nLinea, nFimLin)

	// TOTAIS APROXIMADOS DOS TRIBUTOS
	//Linha 1
	nLinea := nLinea+nLiCabec 
	oDanfse:Say(nLinea, 002, "TOTAIS APROXIMADOS DOS TRIBUTOS", oFont07N:oFont)

	//Linha 2
	nLinea := nLinea+nLiCabec 
	oDanfse:Say(nLinea, 100, "Federais", oFont07N:oFont)
	oDanfse:Say(nLinea, 300, "Estaduais", oFont07N:oFont)
	oDanfse:Say(nLinea, 500, "Municipais", oFont07N:oFont)
	nLinea := nLinea+nLiDados 
	oDanfse:Say(nLinea, 100, Substr(IIF(Type("XXXXXXXXXX") <> "U","XXXXXXXXXX","-"),1,nMxTrib) + "%", oFont07:oFont) //Federais
	oDanfse:Say(nLinea, 300, Substr(IIF(Type("XXXXXXXXXX") <> "U","XXXXXXXXXX","-"),1,nMxTrib) + "%", oFont07:oFont) //Estaduais
	oDanfse:Say(nLinea, 500, Substr(IIF(Type("XXXXXXXXXX") <> "U","XXXXXXXXXX","-"),1,nMxTrib) + "%", oFont07:oFont) //Municipais

	*/

	// LINHA DE QUEBRA
	nLinea := nLinea+nLiQuebr 
	oDanfse:Line(nLinea, nIniLin,nLinea, nFimLin)

	// INFORMA��ES COMPLEMENTARES
	//Linha 1

	//------------ info complementares------------

	cInfNota := iif( Type("oNFSE:_RPS:_infcompl:_observacao")<>"U",oNFSE:_RPS:_infcompl:_observacao:TEXT,"-" )

	cInfNota := IIF(Len(cInfNota) > 2000,substr(cInfNota,1,2000) ,cInfNota)
	nMax	:= 144//LETRAS MAIUSCULAS S� CABE 144 se fosse tudo minusculo caberia 220 se mesclar tamanho varia 
	nCont 	:= 1
	//criar uma variavel para manter a cInfNota com o conteudo original

	While nCont < Len(cInfNota)
		aadd(aInfNota,substr(cInfNota,nCont,nMax))
		nCont += nMax
	EndDo


	nLinea := nLinea+nLiCabec 
	oDanfse:Say(nLinea, 002, "INFORMA��ES COMPLEMENTARES", oFont07N:oFont)
	//Linha 2
	For nX := 1 To len(aInfNota)
		nLinea := nLinea+nLiDados
		oDanfse:Say(nLinea, 002, aInfNota[nX], oFont07:oFont) //INFORMA��ES COMPLEMENTARES
	Next
	oDanfse:EndPage()
EndIf

Return

Static Function GetXML(cIdEnt,aIdNfse, lJob)

Local aRetorno		:= {}
Local aDados		:= {}
Local nZ			:= 0
Local nCount		:= 0


default lJob := .F.

For nZ := 1 To len(aIdNfse)

    nCount++

	aDados := executeRetorna( aIdNfse[nZ], cIdEnt , , lJob)

	if ( nCount == 10 )
		delClassIntF()
		nCount := 0
	endif

	aAdd(aRetorno,aDados)

Next nZ

Return(aRetorno)

Static Function ConvDate(cData)

Local dData
cData  := StrTran(cData,"-","")
dData  := Stod(cData)

Return PadR(StrZero(Day(dData),2)+ "/" + StrZero(Month(dData),2)+ "/" + StrZero(Year(dData),4),15)



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DANFE     �Autor  �Fabio Santana	     � Data �  04/10/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Converte caracteres espceiais						          ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/
STATIC FUNCTION NoChar(cString,lConverte)

Default lConverte := .F.

If lConverte
	cString := (StrTran(cString,"&lt;","<"))
	cString := (StrTran(cString,"&gt;",">"))
	cString := (StrTran(cString,"&amp;","&"))
	cString := (StrTran(cString,"&quot;",'"'))
	cString := (StrTran(cString,"&#39;","'"))
EndIf

Return(cString)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DANFEIII  �Autor  �Microsiga           � Data �  12/17/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � Tratamento para o c�digo do item                           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
STATIC FUNCTION MaxCod(cString,nTamanho)

//�������������������������������������������������������������Ŀ
//�Tratamento para saber quantos caracteres ir�o caber na linha �
//� visto que letras ocupam mais espa�o do que os n�meros.      �
//���������������������������������������������������������������

Local nMax	:= 0
Local nY   	:= 0
Default nTamanho := 45

For nMax := 1 to Len(cString)
	If IsAlpha(SubStr(cString,nMax,1)) .And. SubStr(cString,nMax,1) $ "MOQW"  // Caracteres que ocupam mais espa�o em pixels
		nY += 7
	Else
		nY += 5
	EndIf

	If nY > nTamanho   // � o m�ximo de espa�o para uma coluna
		nMax--
		Exit
	EndIf
Next

Return nMax

//-----------------------------------------------------------------------
/*/{Protheus.doc} executeRetorna
Executa o retorna de notas

@author Henrique Brugugnoli
@since 17/01/2013
@version 1.0

@param  cID ID da nota que sera retornado

@return aRetorno   Array com os dados da nota
/*/
//-----------------------------------------------------------------------
static function executeRetorna( aNfse, cIdEnt, lUsacolab, lJob)

Local aRetorno		:= {}
Local aIdNfse		:= {}
Local cURL			:= PadR(GetNewPar("MV_SPEDURL","http://localhost:8080/sped"),250)
Local nX			:= 0
Local nY			:= 0
Local nZ			:= 1
Local cXmlLote      := ""
Local cXMLTSS       := ""
Local cXmlErp       := ""  
Local cNumnfse      := ""  
Local cDataHor      := ""  
Local cXmlRet       := ""  
Local cProtoc		:= ""

Local oWS

Private oDHRecbto
Private oNFeRet
Private oDoc


default lJob		:= .F.

aAdd(aIdNfse,aNfse)


oWS := WsNFSE001():New()
oWS:cUSERTOKEN            := "TOTVS"
oWS:cID_ENT               := Alltrim( cIdEnt )
oWS:cCodMun               := IIf( type( "cCodMun") == "U", SM0->M0_CODMUN, cCodMun)
oWS:_URL                  := AllTrim(cURL)+"/NFSE001.apw"
oWS:nDIASPARAEXCLUSAO     := 0
oWS:OWSNFSEID:OWSNOTAS    := NFSe001_ARRAYOFNFSESID1():New()
	
aadd(oWS:OWSNFSEID:OWSNOTAS:OWSNFSESID1,NFSE001_NFSES1():New())
oWS:OWSNFSEID:OWSNOTAS:OWSNFSESID1[1]:CCODMUN  := IIf( type( "cCodMun") == "U", SM0->M0_CODMUN, cCodMun)
oWS:OWSNFSEID:OWSNOTAS:OWSNFSESID1[1]:cXML     := ""
oWS:OWSNFSEID:OWSNOTAS:OWSNFSESID1[1]:CNFSECANCELADA := ""               

aadd(aRetorno,{"","",aIdNfse[nZ][4]+aIdNfse[nZ][5],"","","","","",""})

oWS:OWSNFSEID:OWSNOTAS:OWSNFSESID1[1]:cID      := aIdNfse[nZ][4]+Alltrim( aIdNfse[nZ][5] )
If ExecWSRet(oWS,"RETORNANFSE")

	If Len(oWs:oWsRetornaNfseResult:OWSNOTAS:OWSNFSES5) > 0
		For nX := 1 To Len(oWs:oWsRetornaNfseResult:OWSNOTAS:OWSNFSES5)
			cXmlLote        := oWs:oWsRetornaNfseResult:OWSNOTAS:OWSNFSES5[nX]:oWSNFE:CXML
			cXMLTSS      	:= oWs:oWsRetornaNfseResult:OWSNOTAS:OWSNFSES5[nX]:XMLTSS
			cXmlErp  		:= oWs:oWsRetornaNfseResult:OWSNOTAS:OWSNFSES5[nX]:oWSNFE:CXMLERP
			cDanfse  		:= oWs:oWsRetornaNfseResult:OWSNOTAS:OWSNFSES5[nX]:DANFSE
			cNumnfse  		:= oWs:oWsRetornaNfseResult:OWSNOTAS:OWSNFSES5[nX]:CNUMNSE
			cDataHor  		:= oWs:oWsRetornaNfseResult:OWSNOTAS:OWSNFSES5[nX]:CDATAHORA
			cXmlRet  		:= oWs:oWsRetornaNfseResult:OWSNOTAS:OWSNFSES5[nX]:CXMLRETTSS
			cProtoc  		:= oWs:oWsRetornaNfseResult:OWSNOTAS:OWSNFSES5[nX]:oWSNFE:CPROTOCOLO
			

			nY := aScan(aIdNfse,{|x| x[4]+alltrim(x[5]) == SubStr(oWs:oWsRetornaNfseResult:OWSNOTAS:OWSNFSES5[nX]:CID,1,LEN(aIdNfse[nZ][4]+aIdNfse[nZ][5]))})

			oWS:cIdInicial    := aIdNfse[nZ][4]+aIdNfse[nZ][5]
			oWS:cIdFinal      := aIdNfse[nZ][4]+aIdNfse[nZ][5]

			If nY > 0
				aRetorno[nY][1] := cXMLTSS
				aRetorno[nY][2] := cXmlLote
				aRetorno[nY][4] := cXmlErp
				aRetorno[nY][5] := cDanfse
				aRetorno[nY][6] := cNumnfse
				aRetorno[nY][7] := cDataHor
				aRetorno[nY][8] := cXmlRet
				aRetorno[nY][9] := cProtoc
			EndIf

		Next nX
	EndIf
Elseif !lJob
	Aviso("DANFSE",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{"OK"},3)
EndIf

oWS       := Nil
oDHRecbto := Nil
oNFeRet   := Nil

return aRetorno[len(aRetorno)]

//-------------------------------------------------------------------
/*/{Protheus.doc} danfsepais 
Faz uma compara��o do cod bacen para pegar nome do pais 

@param		cCodBacen	Codigo bacen
 
@return	cRetorno	nome do pais  
						
						
@author	Fabio M Parra
@since		13/12/2023
/*/
//-------------------------------------------------------------------
static Function danfsepais( cCodBacen )


Local cRetorno	:= ""

Local nPosBacen	:= 0

Local aBacen		:= {} 

Default cCodMun	:= ""
Default cCodBacen	:= ""


aadd(aBacen,{"00132","AFEGANISTAO","AF"})
aadd(aBacen,{"00175","ALBANIA","AL"})
aadd(aBacen,{"00230","ALEMANHA","DE"})
aadd(aBacen,{"00310","BURKINA FASO","BF"})
aadd(aBacen,{"00370","ANDORRA","AD"})
aadd(aBacen,{"00400","ANGOLA","AO"})
aadd(aBacen,{"00418","ANGUILLA","AI"})
aadd(aBacen,{"00434","ANTIGUA E BARBUDA","AG"})
aadd(aBacen,{"00477","ANTILHAS HOLANDESAS","NA"})
aadd(aBacen,{"00531","ARABIA SAUDITA","AS "})
aadd(aBacen,{"00590","ARGELIA","DZ"})
aadd(aBacen,{"00639","ARGENTINA","AR"})
aadd(aBacen,{"00647","ARMENIA","AM"})
aadd(aBacen,{"00655","ARUBA","AW"})
aadd(aBacen,{"00698","AUSTRALIA","AU"})	
aadd(aBacen,{"00728","AUSTRIA","AT"})
aadd(aBacen,{"00736","AZERBAIJAO","AZ"})		
aadd(aBacen,{"00779","BAHAMAS","BS"})
aadd(aBacen,{"00809","BAHREIN","BH"})
aadd(aBacen,{"00817","BANGLADESH","BD"})
aadd(aBacen,{"00833","BARBADOS","BB"})
aadd(aBacen,{"00850","BELARUS","BY"})
aadd(aBacen,{"00876","BELGICA","BE"})
aadd(aBacen,{"00884","BELIZE","BZ"})
aadd(aBacen,{"00906","BERMUDAS","BM"})
aadd(aBacen,{"00930","MIANMAR",""})
aadd(aBacen,{"00973","BOLIVIA","BO"})
aadd(aBacen,{"00981","BOSNIA HERZEGOVINA","BA "})	
aadd(aBacen,{"01015","BOTSUANA","BW"}) 
aadd(aBacen,{"01058","BRASIL","BR"})
aadd(aBacen,{"01082","BRUNEI","BN"})
aadd(aBacen,{"01112","BULGARIA","BG"})
aadd(aBacen,{"01155","BURUNDI","BI"})
aadd(aBacen,{"01198","BUTAO","BT"})
aadd(aBacen,{"01279","CABO VERDE","CV"}) 	 
aadd(aBacen,{"01376","CAYMAN","KY"})
aadd(aBacen,{"01414","CAMBOJA","KH"})
aadd(aBacen,{"01457","CAMAROES","CM"})	
aadd(aBacen,{"01490","CANADA","CA"}) 
aadd(aBacen,{"01504","GUERNSEY",""})
aadd(aBacen,{"01508","JERSEY",""})
aadd(aBacen,{"01511","CANARIAS",""})	 
aadd(aBacen,{"01538","CAZAQUISTAO","KZ"})
aadd(aBacen,{"01546","CATAR","QA"})
aadd(aBacen,{"01589","CHILE","CL"})
aadd(aBacen,{"01600","CHINA","CN"})
aadd(aBacen,{"01619","FORMOSA","TW"})
aadd(aBacen,{"01635","CHIPRE","CY"})
aadd(aBacen,{"01651","COCOS","CC"})
aadd(aBacen,{"01694","COLOMBIA","CO"})
aadd(aBacen,{"01732","COMORES","KM"})
aadd(aBacen,{"01775","CONGO","CG"})
aadd(aBacen,{"01830","COOK","CK"})
aadd(aBacen,{"01872","COREIA","KP"})
aadd(aBacen,{"01902","COREIA DO SUL","KR"})
aadd(aBacen,{"01937","COSTA DO MARFIM","CI"})		
aadd(aBacen,{"01953","CROACIA","HR"})
aadd(aBacen,{"01961","COSTA RICA","CR"})
aadd(aBacen,{"01988","COVEITE",""})
aadd(aBacen,{"01996","CUBA","CU"})
aadd(aBacen,{"02291","BENIN","BJ"})
aadd(aBacen,{"02321","DINAMARCA","DK"})
aadd(aBacen,{"02356","DOMINICA","DM"})
aadd(aBacen,{"02399","EQUADOR","EC"})
aadd(aBacen,{"02402","EGITO","EG"})
aadd(aBacen,{"02437","ERITREIA","ER"})
aadd(aBacen,{"02445","EMIRADOS ARABES UNIDOS","AE"})	
aadd(aBacen,{"02453","ESPANHA","ES"})
aadd(aBacen,{"02461","ESLOVENIA","SI"})
aadd(aBacen,{"02470","ESLOVAQUIA","SK"})
aadd(aBacen,{"02496","ESTADOS UNIDOS","US"})
aadd(aBacen,{"02518","ESTONIA","EE"})
aadd(aBacen,{"02534","ETIOPIA","ET"})
aadd(aBacen,{"02550","FALKLAND","FK"})
aadd(aBacen,{"02593","FEROE",""})
aadd(aBacen,{"02674","FILIPINAS","PH"})
aadd(aBacen,{"02712","FINLANDIA","FI"})
aadd(aBacen,{"02755","FRANCA","FR"})
aadd(aBacen,{"02810","GABAO","GA"})
aadd(aBacen,{"02852","GAMBIA","GM"})
aadd(aBacen,{"02895","GANA","GH"})
aadd(aBacen,{"02917","GEORGIA","GE"})
aadd(aBacen,{"02933","GIBRALTAR","GI"})
aadd(aBacen,{"02976","GRANADA",""})
aadd(aBacen,{"03018","GRECIA","GR"})
aadd(aBacen,{"03050","GROENLANDIA","GL"})
aadd(aBacen,{"03093","GUADALUPE","GP"})
aadd(aBacen,{"03131","GUAM","GU"})
aadd(aBacen,{"03174","GUATEMALA","GT"})
aadd(aBacen,{"03255","GUIANA FRANCESA","GF"})
aadd(aBacen,{"03298","GUINE","GN"})
aadd(aBacen,{"03310","GUINE-EQUATORIAL","GQ"})
aadd(aBacen,{"03344","GUINE-BISSAU","GW"})
aadd(aBacen,{"03379","GUIANA","GY"})
aadd(aBacen,{"03417","HAITI","HT"})
aadd(aBacen,{"03450","HONDURAS","HN"})
aadd(aBacen,{"03514","HONG KONG","HK"})
aadd(aBacen,{"03557","HUNGRIA","HU"})
aadd(aBacen,{"03573","IEMEN","YE"})
aadd(aBacen,{"03595","MAN",""})
aadd(aBacen,{"03611","INDIA","IN"})
aadd(aBacen,{"03654","INDONESIA","ID"})
aadd(aBacen,{"03697","IRAQUE","IQ"})
aadd(aBacen,{"03727","IRA","IR"})
aadd(aBacen,{"03751","IRLANDA","IE"})
aadd(aBacen,{"03794","ISLANDIA","IS"})
aadd(aBacen,{"03832","ISRAEL","IL"})
aadd(aBacen,{"03867","ITALIA","IT"})
aadd(aBacen,{"03913","JAMAICA","JM"})
aadd(aBacen,{"03964","JOHNSTON",""})
aadd(aBacen,{"03999","JAPAO","JP"})
aadd(aBacen,{"04030","JORDANIA","JO"})
aadd(aBacen,{"04111","KIRIBATI","KI"})
aadd(aBacen,{"04200","LAOS","LA"})
aadd(aBacen,{"04235","LEBUAN",""})
aadd(aBacen,{"04260","LESOTO","LS"})
aadd(aBacen,{"04278","LETONIA","LV"})
aadd(aBacen,{"04316","LIBANO","LB"})
aadd(aBacen,{"04340","LIBERIA","LR"})
aadd(aBacen,{"04383","LIBIA","LY"})
aadd(aBacen,{"04405","LIECHTENSTEIN","LI"})		
aadd(aBacen,{"04421","LITUANIA","LT"})
aadd(aBacen,{"04456","LUXEMBURGO","LU"})
aadd(aBacen,{"04472","MACAU","MO"})
aadd(aBacen,{"04499","MACEDONIA","MK"})
aadd(aBacen,{"04502","MADAGASCAR","MG"})
aadd(aBacen,{"04525","MADEIRA",""})
aadd(aBacen,{"04553","MALASIA","MY"})
aadd(aBacen,{"04588","MALAVI",""})
aadd(aBacen,{"04618","MALDIVAS","MV"})
aadd(aBacen,{"04642","MALI","ML"})
aadd(aBacen,{"04677","MALTA","MT"})
aadd(aBacen,{"04723","MARIANAS DO NORTE","MP"})
aadd(aBacen,{"04740","MARROCOS","MA"})
aadd(aBacen,{"04766","MARSHALL","MH"})
aadd(aBacen,{"04774","MARTINICA","MQ"})	
aadd(aBacen,{"04855","MAURICIO","MU"})
aadd(aBacen,{"04880","MAURITANIA","MR"})
aadd(aBacen,{"04885","MAYOTTE","YT"})		
aadd(aBacen,{"04901","MIDWAY",""})
aadd(aBacen,{"04936","MEXICO","MX"})
aadd(aBacen,{"04944","MOLDAVIA","MD"})
aadd(aBacen,{"04952","MONACO","MC"})
aadd(aBacen,{"04979","MONGOLIA","MN"})
aadd(aBacen,{"04985","MONTENEGRO",""})
aadd(aBacen,{"04995","MICRONESIA","FM"})
aadd(aBacen,{"05010","MONTSERRAT","MS"})
aadd(aBacen,{"05053","MOCAMBIQUE","MZ"})
aadd(aBacen,{"05070","NAMIBIA","NA"})
aadd(aBacen,{"05088","NAURU","NR"})
aadd(aBacen,{"05118","CHRISTMAS","CX"})
aadd(aBacen,{"05177","NEPAL","NP"})
aadd(aBacen,{"05215","NICARAGUA","NI"})
aadd(aBacen,{"05258","NIGER","NE"})
aadd(aBacen,{"05282","NIGERIA","NG"})		 
aadd(aBacen,{"05312","NIUE","NU"})
aadd(aBacen,{"05355","NORFOLK","NF"})
aadd(aBacen,{"05380","NORUEGA","NO"})
aadd(aBacen,{"05428","NOVA CALEDONIA","NC"})
aadd(aBacen,{"05452","PAPUA NOVA GUINE","PG"})
aadd(aBacen,{"05487","NOVA ZELANDIA","NZ"})
aadd(aBacen,{"05517","VANUATU","VU"})
aadd(aBacen,{"05568","OMA","OM"})
aadd(aBacen,{"05665","PACIFICO",""})
aadd(aBacen,{"05738","PAISES BAIXOS",""})
aadd(aBacen,{"05754","PALAU","PW"})
aadd(aBacen,{"05762","PAQUISTAO","PK"})
aadd(aBacen,{"05780","PALESTINA",""})
aadd(aBacen,{"05800","PANAMA","PA"})
aadd(aBacen,{"05860","PARAGUAI","PY"})
aadd(aBacen,{"05894","PERU","PE"})
aadd(aBacen,{"05932","PITCAIRN","PN"})
aadd(aBacen,{"05991","POLINESIA FRANCESA","PF"})
aadd(aBacen,{"06033","POLONIA","PL"})
aadd(aBacen,{"06076","PORTUGAL","PT"})
aadd(aBacen,{"06114","PORTO RICO","PR"})
aadd(aBacen,{"06238","QUENIA","KE"})
aadd(aBacen,{"06254","QUIRGUIZ",""})
aadd(aBacen,{"06289","REINO UNIDO","UK"})
aadd(aBacen,{"06408","REPUBLICA CENTRO-AFRICANA","CF"})
aadd(aBacen,{"06475","REPUBLICA DOMINICANA","DO"})
aadd(aBacen,{"06602","REUNIAO","RE"})
aadd(aBacen,{"06653","ZIMBABUE","ZW"})
aadd(aBacen,{"06700","ROMENIA","RO"})	
aadd(aBacen,{"06750","RUANDA","RW"})
aadd(aBacen,{"06769","RUSSIA","RU"})
aadd(aBacen,{"06777","SALOMAO","SB"})
aadd(aBacen,{"06858","SAARA OCIDENTAL",""})
aadd(aBacen,{"06874","EL SALVADOR","SV"})
aadd(aBacen,{"06904","SAMOA","WS"})
aadd(aBacen,{"06912","SAMOA AMERICANA","AS"})
aadd(aBacen,{"06955","SAO CRISTOVAO E NEVES",""})
aadd(aBacen,{"06971","SAN MARINO","SM"})
aadd(aBacen,{"07005","SAO PEDRO E MIQUELON","PM"})
aadd(aBacen,{"07056","SAO VICENTE E GRANADINAS","VC"})
aadd(aBacen,{"07102","SANTA HELENA","SH"})
aadd(aBacen,{"07153","SANTA LUCIA","LC"})
aadd(aBacen,{"07200","SAO TOME E PRINCIPE","ST"})
aadd(aBacen,{"07285","SENEGAL","SN"})
aadd(aBacen,{"07315","SEYCHELLES","SC"})
aadd(aBacen,{"07358","SERRA LEOA","SL"})
aadd(aBacen,{"07370","SERVIA",""})
aadd(aBacen,{"07412","CINGAPURA","SG"})
aadd(aBacen,{"07447","SIRIA","SY"})
aadd(aBacen,{"07480","SOMALIA","SO"})
aadd(aBacen,{"07501","SRI LANKA","LK"})
aadd(aBacen,{"07544","SUAZILANDIA","SZ"})
aadd(aBacen,{"07560","AFRICA DO SUL","ZA"})
aadd(aBacen,{"07595","SUDAO","SD"})
aadd(aBacen,{"07600","SUDAO DO SUL","SD"})
aadd(aBacen,{"07641","SUECIA","SE"})
aadd(aBacen,{"07676","SUICA","CH"})
aadd(aBacen,{"07706","SURINAME","SR"})
aadd(aBacen,{"07722","TADJIQUISTAO",""})	
aadd(aBacen,{"07765","TAILANDIA","TH"})
aadd(aBacen,{"07803","TANZANIA","TZ"})
aadd(aBacen,{"07820","TERRITORIO","IO"})
aadd(aBacen,{"07838","DJIBUTI","DJ"})
aadd(aBacen,{"07889","CHADE","TD"})
aadd(aBacen,{"07919","TCHECA","CZ"})
aadd(aBacen,{"07951","TIMOR LESTE","TP"})
aadd(aBacen,{"08001","TOGO","TG"})
aadd(aBacen,{"08052","TOQUELAU",""})
aadd(aBacen,{"08109","TONGA","TO"})
aadd(aBacen,{"08150","TRINIDAD E TOBAGO","TT"})
aadd(aBacen,{"08206","TUNISIA","TN"})
aadd(aBacen,{"08230","TURCAS E CAICOS","TC"})
aadd(aBacen,{"08249","TURCOMENISTAO","TM"})
aadd(aBacen,{"08273","TURQUIA","TR"})
aadd(aBacen,{"08281","TUVALU",""})
aadd(aBacen,{"08311","UCRANIA","UA"})
aadd(aBacen,{"08338","UGANDA","UG"})
aadd(aBacen,{"08451","URUGUAI","UY"})
aadd(aBacen,{"08478","UZBEQUISTAO","UZ"})
aadd(aBacen,{"08486","VATICANO","VA"})
aadd(aBacen,{"08508","VENEZUELA","VE"})
aadd(aBacen,{"08583","VIETNA","VN"})
aadd(aBacen,{"08630","VIRGENS - BRITANICAS","VG"})
aadd(aBacen,{"08664","VIRGENS - EUA","VI"})
aadd(aBacen,{"08702","FIJI","FJ"})
aadd(aBacen,{"08737","WAKE",""})
aadd(aBacen,{"08885","CONGO","CG"})
aadd(aBacen,{"08907","ZAMBIA","ZM"})
aadd(aBacen,{"08958","ZONA DO CANAL DO PANAMA",""})
aadd(aBacen,{"09903","PROVISAO DE NAVIOS E AERONAVES",""})
aadd(aBacen,{"09946","A DESIGNAR",""})
aadd(aBacen,{"09950","BANCOS CENTRAIS",""})
aadd(aBacen,{"09970","ORGANIZACOES INTERNACIONAIS",""})

If !Empty(cCodBacen)
	
	// Verifica pelo c�digo do Pa�s
	If Len (cCodBacen) <= 5
		 cCodBacen := StrZero(Val(cCodBacen),5)
		 
			nPosBacen := aScan(aBacen,{|x| x[1] == cCodBacen})
			If nPosBacen > 0
				cRetorno := aBacen[nPosBacen][2]				
			EndIf			
	Else
		// Verifica pelo nome do Pa�s
			nPosBacen := aScan(aBacen,{|x| x[2] == cCodBacen})
			If nPosBacen > 0
				cRetorno := aBacen[nPosBacen][2]				
			EndIf			
	Endif	
	
Endif

Return(cRetorno) 
//-------------------------------------------------------------------
/*/{Protheus.doc} fTptrib 
Faz uma compara��o do codigo tributa��o para pegar a descri��o 

@param		cTipoTrib	
@return	cRetorno	descri��o da tributa��o
						
@author	Fabio M Parra
@since		14/12/2023
/*/
//-------------------------------------------------------------------
static Function fTptrib( cTipoTrib ) 

Local cRetorno	:= ""
Local ntptrib	:= 0
Local aTptrib	:= {} 

Default cTipoTrib	:= ""


aadd(aTptrib,{"1","Isenta de ISS"})
aadd(aTptrib,{"2","N�o incid�ncia no munic�pio"})
aadd(aTptrib,{"3","Imune"})
aadd(aTptrib,{"4","Exigibilidade Susp. Dec. J."})
aadd(aTptrib,{"5","N�o tribut�vel"})
aadd(aTptrib,{"6","Tribut�vel"})
aadd(aTptrib,{"7","Tribut�vel fixo"})
aadd(aTptrib,{"8","Tribut�vel S.N"})
aadd(aTptrib,{"9","Cancelado"})
aadd(aTptrib,{"10","Extraviado."})
aadd(aTptrib,{"11","Micro Empreendedor Individual (MEI)"})
aadd(aTptrib,{"12","Exigibilidade Susp. Proc. A."})
aadd(aTptrib,{"13"," Sem recolhimento"})
aadd(aTptrib,{"14"," Devido a outro munic�pio"})
aadd(aTptrib,{"15"," Isen��o Parcial"})
aadd(aTptrib,{"16"," Imunidade Objetiva"})

If !Empty(cTipoTrib)
	ntptrib := aScan(aTptrib,{|x| x[1] == cTipoTrib})
	If ntptrib > 0
		cRetorno := aTptrib[ntptrib][2]				
	EndIf			
Endif

Return(cRetorno) 


//-------------------------------------------------------------------
/*/{Protheus.doc} fRegesp 
Regime especial de tributa��o

@param		cRegesp	
 
@return	cRetorno	descri��o   
						
						
@author	Fabio M Parra
@since		14/12/2023
/*/
//-------------------------------------------------------------------
static Function fRegesp( cRegesp ) 

Local cRetorno	:= ""
Local nRegesp	:= 0
Local aRegesp	:= {} 

Default cRegesp	:= ""

aadd(aRegesp,{"0","Tributa��o Normal"})
aadd(aRegesp,{"1","Microempresa Municipal (ME)"})
aadd(aRegesp,{"2","Estimativa"})
aadd(aRegesp,{"3","Sociedade de Profissionais"})
aadd(aRegesp,{"4","Cooperativa"})
aadd(aRegesp,{"5","Microempres�rio Individual (MEI)"})
aadd(aRegesp,{"6","Microempres�rio e Empresa de Pequeno Porte (ME EPP)"})
aadd(aRegesp,{"7","Movimento Mensal/ISS/Fixo Aut�nomo"})
aadd(aRegesp,{"8","Sociedade Limitada/M�dia Empresa"})
aadd(aRegesp,{"9","Sociedade An�nima/Grande Empresa"})
aadd(aRegesp,{"11","Empresa Individual"})
aadd(aRegesp,{"10","Empresa Individual de Responsabilidade Limitada (EIRELI)"})
aadd(aRegesp,{"12","Empresa de Pequeno Porte (EPP)"})
aadd(aRegesp,{"13","Microempres�rio"})
aadd(aRegesp,{"14","Outros/Sem V�nculos"})
aadd(aRegesp,{"50","Nenhum"})
aadd(aRegesp,{"51","Nota Avulsa."})

If !Empty(cRegesp)
	nRegesp := aScan(aRegesp,{|x| x[1] == cRegesp})
	If nRegesp > 0
		cRetorno := aRegesp[nRegesp][2]				
	EndIf			
Endif

Return(cRetorno) 

//-----------------------------------------------------------------------
/*/{Protheus.doc} ConvType
Fun��o que converte de acordo com o tipo.

@author Marcos Taranta
@since 06/02/2012
@version 1.0 

@param	xValor		Valor
@param	nTam		Tamamho
@param	nDec		Decimal

@return	cNovo	Novo conteudo
/*/
//-----------------------------------------------------------------------
Static Function ConvType(xValor,nTam,nDec)

Local cNovo := ""

DEFAULT nDec := 0 

Do Case
	Case ValType(xValor)=="N"
		If xValor <> 0
			cNovo := AllTrim(Str(xValor,nTam+1,nDec))	
		Else
			cNovo := "0"
		EndIf
	Case ValType(xValor)=="D"
		cNovo := FsDateConv(xValor,"YYYYMMDD")
		cNovo := SubStr(cNovo,1,4)+"-"+SubStr(cNovo,5,2)+"-"+SubStr(cNovo,7)
	Case ValType(xValor)=="C"
		If nTam==Nil
			xValor := AllTrim(xValor)
		EndIf
		DEFAULT nTam := 60
		cNovo := AllTrim(EnCodeUtf8(NoAcento(SubStr(xValor,1,nTam))))
EndCase     

Return cNovo

//-------------------------------------------------------------------
/*/{Protheus.doc} fTrinisqn 
Faz uma compara��o para traduzir codigo de issQn

@param		cRegesp	
 
@return	cRetorno	descri��o   
						
						
@author	Fabio M Parra
@since		14/12/2023
/*/
//-------------------------------------------------------------------
static Function fTrinisqn( cRegesp ) 

Local cRetorno	:= "-"
Local nRegesp	:= 0
Local aRegesp	:= {} 

Default cRegesp	:= ""

aadd(aRegesp,{"1","Opera��o tribut�vel"})
aadd(aRegesp,{"2","Imunidade"})
aadd(aRegesp,{"3","Exporta��o de servi�o"})
aadd(aRegesp,{"4","N�o Incid�ncia"})

If !Empty(cRegesp)
	nRegesp := aScan(aRegesp,{|x| x[1] == cRegesp})
	If nRegesp > 0
		cRetorno := aRegesp[nRegesp][2]				
	EndIf			
Endif

Return(cRetorno) 
