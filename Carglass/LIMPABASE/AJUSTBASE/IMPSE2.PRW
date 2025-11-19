#include "totvs.ch"
#include "protheus.ch"
#include "TOPCONN.CH"


/*/{Protheus.doc} ImportSe2
description Importação de titulos em massa CONTAS A PAGAR
@type function
@version 1.0
@author Fabio Batista
@since 22/10/2025
@return variant, return_description
/*/
User Function IMPSE2()

	Private cCaminho     :=""

	cCaminho :=  cGetFile( 'Arquito CSV|*.csv| Arquivo TXT|*.txt| Arquivo XML|*.xml',; //[ cMascara],
	'Selecao de Arquivos 1.0',;                  //[ cTitulo],
	0,;                                      //[ nMascpadrao],
	'C:\TITULOS\',;                            //[ cDirinicial],
	.F.,;                                    //[ lSalvar],
	GETF_LOCALHARD  + GETF_NETWORKDRIVE,;    //[ nOpcoes],
	.T.)

	Processa({||ImpDados(cCaminho)},"Aguarde importando titulos contas a Pagar.." )

Return

/*/{Protheus.doc} ImpDados
description Leitura do arquivo e 
inclusao titulos a pagar
@type function
@version 1.0
@author Fabio Batista	
@since 22/10/2025
@return 
/*/
Static Function ImpDados()

	Local cLinha           := ""
	Local lPrimlin         := .T.
	Local aCampos          := {}
	Local aDados           := {} 
	Local i                := 1
	Local cFil       	   := ""
	Local cPrefixo   	   := ""
	Local cNunTit    	   := ""
	Local cParcela   	   := ""
	Local cTipo      	   := ""
	Local cNaturez   	   := ""
	Local cCodFor    	   := ""
	Local dDataEmi   	   := ""
	Local dDataVenc  	   := ""
	Local dDatReal   	   := ""
	Local nValorTit  	   := 0
	Local cHist      	   := ""
	Local cItemCont  	   := ""
	Local cContctb		   := ""
	Local cCentroC   	   := ""
	Local nCont            := 0 
	Local nContErro        := 0 
	Local nContDupl        := 0 
	Local lDuplic          := .T.
	Local cRetor           := ""
	Local nX               := 0

	Private aErro          := {}
	Private cMsgExec       := ''
    PRIVATE lMsErroAuto    := .F.
	Private lMsHelpAuto	   := .T. 
	Private lAutoErrNoFile := .T.

	FT_FUSE(cCaminho)
	ProcRegua(FT_FLASTREC())
	FT_FGOTOP()

	While !FT_FEOF()

		cLinha := FT_FREADLN()
		If substr(cLinha,1,3) == 'E2_' .or. substr(cLinha,1,3) == 'Fil' .or. substr(cLinha,1,3) == 'C 2'
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
		cCodFor    := PadR(aDados[i,7],TamSX3("E1_CLIENTE")[1])
		cLojaCli   := PadR(aDados[i,8],TamSX3("E1_LOJA")[1])
		dDataEmi   := STOD("20251031") //STOD(aDados[i,9])
		dDataVenc  := STOD(aDados[i,10])
		dDatReal   := STOD(aDados[i,11])
		nValorTit  := Abs( Val(StrTran(aDados[i,12],",",".")) )
		cHist      := PadR(aDados[i,13],TamSX3("E1_HIST")[1])
		cContctb   := PadR(aDados[i,14],TamSX3("E1_CREDIT")[1])  //03/11/2025 - SOLICITADO VICTOR - AJUSTADO COM RICARDO/VICTOR E ANALISTA OCULTO //02/11/2025 - SOLICITADO VICTOR
		cCentroC   := PadR(aDados[i,15],TamSX3("E1_CCUSTO")[1])
		// cItemCont  := PadR(aDados[i,14],TamSX3("E1_ITEMCTA")[1]) //02/11/2025 - RETIRADO - SOLICTADO VICTOR
		

		dbSelectArea("SE2")
		SE2->(dbSetOrder(1)) // E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
		SE2->(dbGoTop())

		If !MsSeek(xFilial("SE2")+cPrefixo+cNunTit+cParcela)

			lDuplic := .F.

			Begin Transaction

				aTitulo  := {{"E2_FILIAL"  , cFil       ,Nil},;
					{"E2_PREFIXO"           , cPrefixo       ,Nil},;
					{"E2_NUM"               , cNunTit        ,Nil},;
					{"E2_PARCELA"           , cParcela       ,Nil},;
					{"E2_TIPO"              , cTipo          ,Nil},;
					{"E2_NATUREZ"           , cNaturez       ,Nil},;
					{"E2_FORNECE"           , cCodFor        ,Nil},;
					{"E2_LOJA"              , cLojaCli       ,Nil},;
					{"E2_EMISSAO"           , dDataEmi       ,Nil},;
					{"E2_VENCTO"            , dDataVenc      ,Nil},;
					{"E2_VENCREA"           , dDataVenc      ,Nil},;
					{"E2_VALOR"             , nValorTit      ,Nil},;
					{"E2_HIST"              , cHist          ,NIL},;
					{"E2_CONTAD"            , cContctb       ,NIL},;
					{"E2_CCUSTO"            , cCentroC       ,NIL}}
					

				MsExecAuto( { |x,y| FINA050( x, y ) } , aTitulo, 3 )

				If lMsErroAuto
					//Mostraerro()
					nContErro +=1 //Quantidade com erro de importação
					aLog := GetAutoGRLog()
					For nX := 1 To Len( aLog )
						cRetor += aLog[nX] + "|" + CRLF
					Next nX
            		LogTitSE2(cRetor,cNunTit)
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

/*/{Protheus.doc} LogTitSE2
description escreve no arquivo txt 
com problemas nos titulos a pagar
@type function
@version 1.0
@author Fabio Batista	
@since 22/10/2025
@return 
/*/
Static function LogTitSE2(cRetor,cNunTit)

	Local aArea    := FWGetArea()
	Local cArquivo := 'c:\Titulos\' + cNunTit + '_log_SE2.txt'
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
