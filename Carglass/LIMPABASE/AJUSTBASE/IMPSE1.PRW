#include "totvs.ch"
#include "protheus.ch"
#include "TOPCONN.CH"


/*/{Protheus.doc} ImpSE1
description Importação de titulos CONTAS A RECEBER
@type function
@version 1.0
@author Victor Ramon
@since 22/10/2025
@return variant, return_description
/*/
User Function ImpSE1()

	Private cCaminho     :=""

	cCaminho :=  cGetFile( 'Arquito CSV|*.csv| Arquivo TXT|*.txt| Arquivo XML|*.xml',; //[ cMascara],
	'Selecao de Arquivos - 1.0',;                  //[ cTitulo],
	0,;                                      //[ nMascpadrao],
	'C:\TITULOS\',;                            //[ cDirinicial],
	.F.,;                                    //[ lSalvar],
	GETF_LOCALHARD  + GETF_NETWORKDRIVE,;    //[ nOpcoes],
	.T.)

	Processa({||ImpDados(cCaminho)},"Aguarde importando titulos contas a receber.." )

Return

/*/{Protheus.doc} ImpDados
description Leitura do arquivo e 
inclusao titulos a receber
@type function
@version 1.0
@author Fabio Batista	
@since 22/10/2025
@return 
/*/
Static Function ImpDados()

	Local cLinha           := ""
	Local lPrimlin         := .f.
	Local aCampos          := {}
	Local aDados           := {} 
	Local i                := 1
	Local nLinha           := 0
	Local cFil             := ""
	Local cPrefixo         := ""
	Local cNunTit          := ""
	Local cParcela         := ""
	Local cTipo            := ""
	Local cNaturez         := ""
	Local cCodCli          := ""
	Local cLojaCli         := ""
	Local dDataEmi         := ""
	Local dDataVenc        := ""
	Local dDatReal         := ""
	Local nValorTit        := 0 
	Local cHist            := ""
	Local cItemCont        := ""
	Local cContctb         := ""
	Local cCentroC         := ""
	Local nX               := 0
	Local cRetor           := ""
	Local nCont            := 0  
	Local nContErro        := 0  
	Local nContDupl        := 0
	Local lDuplic		   := .T.
	
	Private aErro          := {}
	Private cMsgExec       := ''
    PRIVATE lMsErroAuto    := .F.
	Private lMsHelpAuto	   := .T. 
	Private lAutoErrNoFile := .T.

	FT_FUSE(cCaminho)
	ProcRegua(FT_FLASTREC())
	FT_FGOTOP()

	While !FT_FEOF()
		nLinha++
		cLinha := FT_FREADLN()
		If substr(cLinha,1,3) == 'E1_' .or. substr(cLinha,1,3) == 'Fil' .or. substr(cLinha,1,3) == 'C 2'
			lPrimlin := .t.
		EndIf 

		If lPrimlin
			aCampos := Separa(cLinha,";",.T.)
			lPrimlin := .F.
		Else
			AADD(aDados,Separa(cLinha,";",.T.))
		EndIf

		FT_FSKIP()
	EndDo

	ProcRegua(Len(aDados))
	For i:=1 to Len(aDados)

		cFil       := PadR(aDados[i,1],TamSX3("E1_FILIAL")[1])
		cPrefixo   := PadR(aDados[i,2],TamSX3("E1_PREFIXO")[1])
		cNunTit    := PadR(aDados[i,3],TamSX3("E1_NUM")[1])
		cParcela   := PadR(aDados[i,4],TamSX3("E1_PARCELA")[1])
		cTipo      := PadR(aDados[i,5],TamSX3("E1_TIPO")[1])
		cNaturez   := PadR(aDados[i,6],TamSX3("E1_NATUREZ")[1])
		cCodCli    := PadR(aDados[i,7],TamSX3("E1_CLIENTE")[1])
		cLojaCli   := PadR(aDados[i,8],TamSX3("E1_LOJA")[1])
		dDataEmi   := STOD("20251031")    						//STOD(aDados[i,9]) - AJUSTADO - SOLICITAÇÃO REUNIÃO - VICTOR - RENATA - LUCIANA - WELLINGTON
		dDataVenc  := STOD(aDados[i,10])
		dDatReal   := STOD(aDados[i,11])
		nValorTit  := Abs( Val(StrTran(aDados[i,12],",",".")) )
		cHist      := PadR(aDados[i,13],TamSX3("E1_HIST")[1])
		cContctb   := PadR(aDados[i,14],TamSX3("E1_CREDIT")[1])  //03/11/2025 - SOLICITADO VICTOR - AJUSTADO COM RICARDO/VICTOR E ANALISTA OCULTO
		cCentroC   := PadR(aDados[i,15],TamSX3("E1_CCUSTO")[1])
		// cItemCont  := PadR(aDados[i,14],TamSX3("E1_ITEMCTA")[1]) //02/11/2025 - RETIRADO - SOLICTADO VICTOR
		

		dbSelectArea("SE1")
		SE1->(dbSetOrder(1)) // E1_FILIAL+E1_PREFIXO+E1_NUM1
		SE1->(dbGoTop())

		If !SE1->(MsSeek(xFilial("SE1")+cPrefixo+cNunTit))

			lDuplic := .F.

			Begin Transaction

				aTitulo  := {{"E1_FILIAL"  , cFil       ,Nil},;
					{"E1_PREFIXO"           , cPrefixo       ,Nil},;
					{"E1_NUM"               , cNunTit        ,Nil},;
					{"E1_PARCELA"           , cParcela       ,Nil},;
					{"E1_TIPO"              , cTipo          ,Nil},;
					{"E1_CLIENTE"           , cCodCli        ,Nil},;
					{"E1_LOJA"              , cLojaCli       ,Nil},;
					{"E1_EMISSAO"           , dDataEmi       ,Nil},;
					{"E1_VENCTO"            , dDataVenc      ,Nil},;
					{"E1_VENCREA"           , dDataVenc      ,Nil},;
					{"E1_VALOR"             , nValorTit      ,Nil},;
					{"E1_HIST"              , cHist          ,NIL},;
					{"E1_NATUREZ"           , cNaturez       ,NIL},;
					{"E1_ITEMCTA"           , cItemCont      ,NIL},;
					{"E1_CREDIT"            , cContctb       ,NIL},;
					{"E1_CCUSTO"            , cCentroC       ,NIL}}

				MSExecAuto({|x,y| Fina040(x,y)},aTitulo,3) //Inclusao

				If lMsErroAuto
					nContErro +=1 
					
					aLog := GetAutoGRLog()
					For nX := 1 To Len( aLog )
						cRetor += aLog[nX] + "|" + CRLF
					Next nX
            		LogTitSE1(cRetor,cNunTit)
				Else
					nCont += 1 // Quantidade importado com sucesso
				EndIf

				lMsErroAuto := .F.

			End Transaction

		EndIf

		If lDuplic
			nContDupl += 1 //Quantidade de registros duplicados, tentiva de importar registro já existente na SE2
		EndIf

	Next i

	If nCont >0
		MSGINFO("Importação de " +StrZero(nCont,4) +" Titulos","Sucesso!")
	EndIf

	If  nContErro >0
		MSGALERT("Não importado " +StrZero(nContErro,4) +" Titulos","ERRO!")
	EndIf

	If nContDupl >0
		MSGALERT("Não importado " +StrZero(nContDupl,4) +" Titulos em Duplicidade","DUPLICIDADE!")
	EndIf

Return


/*/{Protheus.doc} LogTitSE1
description escreve no arquivo txt 
com problemas nos titulos a pagar
@type function
@version 1.0
@author Fabio Batista	
@since 22/10/2025
@return 
/*/
Static function LogTitSE1(cRetor,cNunTit)

	Local aArea    := FWGetArea()
	Local cArquivo := 'c:\Titulos\' + cNunTit + '_log_SE1.txt'
	Local oFWrite  := nil
	
	If File(cArquivo)
		FErase(cArquivo)
	EndIf 

	oFWriter := FWFileWriter():New(cArquivo,.t.)

	If ! oFWriter:Create()
		Alert("Houve um erro ao criar o arquivo - " + oFWrite:Error():Message)
	Else
		oFWriter:Write(cRetor)
	EndIf 

	oFWriter:Close()

	FWRestArea(aArea)

Return
