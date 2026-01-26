#INCLUDE "Totvs.ch"
#Include "Protheus.Ch"
#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "tbiconn.CH"

User Function RELGCP()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaracao de Variaveis                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Local cDesc1  := "Este relatorio ira imprimir dados  gerencial de "
	Local cDesc2  := "Médias de Estoque"
	Local cDesc3  := ""
	Local cPict   := ""
	Local titulo  := "Gerencial Média Estoque"
	Local nLin    := 80

	Local Cabec1  := "Produto                                 Saldo Estoque   Estoque Empenhado   Media Compras   Sc em Aberto  "
	Local Cabec2  := "             "
	Local imprime := .T.
	Local aOrd    := {}
	Local cPerg   := "RELMDE01"

	Private oDlg       := Nil
	Private cArq       := 'RELMDE_'+strtran(TIME(),':',''), cRel:="Relatorio GERENCIAL MEDIA ESTOQUE - Excel"
	Private cDir       := 'C:\TEMP\'

	Private lEnd        := .F.
	Private lAbortPrint := .F.
	Private CbTxt       := ""
	Private limite      := 220 //150//132
	Private tamanho     := "G"
	Private nomeprog    := funname() // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo       := 15
	Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey    := 0
	Private cbcont      := 00
	Private CONTFL      := 01
	Private m_pag       := 01
	Private wnrel       := FUNNAME() // Coloque aqui o nome do arquivo usado para impressao em disco

	VALPERG(cPerg)

	IF !PERGUNTE(cPerg,.t.)
		RETURN()
	ENDIF

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta a interface padrao com o usuario...                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	wnrel := SetPrint('SA2',NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,'SA2')

	If nLastKey == 27
		Return
	Endif

	nTipo := If(aReturn[4]==1,15,18)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
	Local oExcel    := FWMSEXCELEX():New() //Cria o Objeto que ira gerar o Arquivo
	Local cArqv     := alltrim(cArq) + '.xml'
	Local cPath     := cDir
	Local cPlanilha1 := "Por Fornecedor"
	Local cTabela1   := "Relatorio Gerencial financeiro " + CFILANT

	Private _Entrada := ""
	Private _nValor  := 0
	Private cAlias  := "TRB1"

	aTabr := FQuery(cAlias)

	ProcRegua(RecCount())
	oExcel:AddworkSheet(cPlanilha1) //Cria Planilha(Pasta) Dentro do Arquivo

	oExcel:AddTable (cPlanilha1,cTabela1) //Cria uma Tabela
	oExcel:AddColumn(cPlanilha1,cTabela1,"Produto"            ,1,1) // 01
	oExcel:AddColumn(cPlanilha1,cTabela1,"Saldo Estoque"      ,1,2) // 02
	oExcel:AddColumn(cPlanilha1,cTabela1,"Estoque Empenhado"  ,1,2) // 03
	oExcel:AddColumn(cPlanilha1,cTabela1,"Medias Compras"     ,1,2) // 02
	oExcel:AddColumn(cPlanilha1,cTabela1,"SC em Aberto"       ,1,2)
	oExcel:AddColumn(cPlanilha1,cTabela1,"PC em Aberto"       ,1,2)
	oExcel:AddColumn(cPlanilha1,cTabela1," "                  ,1,1)

	cCel := {"","","","","","","",""}
	oExcel:SetLineBgColor('"#4F81BD"')
	oExcel:SetLineBgColor('#FFFFFF')

	oExcel:AddRow(cPlanilha1,cTabela1,cCel) //Insere uma linha na Tabela
	oExcel:SetLineBgColor('#000000')

	oExcel:SetLineBgColor('#AAAAAA') //Cor de Preenchimento da Linha Impar
	oExcel:Set2LineBgColor('#FFFFFF')//Cor de Preenchimento da Linha Par

	nTotal := 0

	While (cAlias)->(!EOF())
		//GRAVO INICIALMENTE O CABEÇALHO
		cCel := { (cAlias)->PRODUTO+'-'+(cAlias)->DESCPRODUTO,;
			(cAlias)->QTDATUAL,;
			(cAlias)->QTDEMPENHADA,;
			(cAlias)->MEDIACOMPRAS,;
			(cAlias)->SOLICITACAOEMABERTO,;
			(cAlias)->PEDIDOABERTO,;
			'' }
		oExcel:AddRow(cPlanilha1,cTabela1,cCel) //Insere uma linha na Tabela

		(cAlias)->(dbskip())
	Enddo

	oExcel:Activate() //Ativa a Planilha
	oExcel:GetXMLFile(cArqv) //Salva o Arquivo

	IncProc("Montando Arquivo")

	if !ExistDir(cPath)//verifica se a pasta existe
		MakeDir(cPath) //Cria a Pasta
	endif

	if __CopyFile(cArqv,cPath+'\'+cArqv)//Copia o arquivo do servidor para a pasta definida na estação do SmartClient

		IF !( ApOleClient("MsExcel") )//Verifica se existe o Excel instalado. Obs: No Windows 8 e 8.1 só com a Build: 7.00.121227P-20131106
			MsgAlert('Não foi possivel localizar o excel' + chr(13) + chr(10) + 'Relatório foi gerado na Pasta: ' + cPath  + cArqv)
		else
			oExcelApp := MsExcel():New()
			oExcelApp:WorkBooks:Open()
			oExcelApp:WorkBooks:Open(cPath + cArq+'.XML') // Abre uma planilha
			oExcelApp:SetVisible(.T.)
		EndIF
	else
		MsgAlert('Não foi possivel gerar o Relatório')
	endif

Return

STATIC FUNCTION FQUERY(cAlias)
	LOCAL cQuery  := ""
	Local lRet    := .T.

	CQUERY := " SELECT B1_COD AS PRODUTO, B1_DESC AS DESCPRODUTO, B2_QATU AS QTDATUAL, B2_QEMP QTDEMPENHADA 
	CQUERY += " , MEDIACOMPRAS=(SELECT AVG(D1_QUANT) FROM " + retsqlname('SD1')+ " WHERE D1_FORNECE+D1_LOJA = A2_COD+A2_LOJA AND D_E_L_E_T_ <>'*' AND  "
	CQUERY += " D1_EMISSAO  BETWEEN '" +  DTOS(MV_PAR01) +  "'  AND  '" + DTOS(MV_PAR02) +  "')"
	CQUERY += " AND  D1_FORNECE  BETWEEN '" +  MV_PAR03 +  "'  AND  '" +  MV_PAR05 +  "'
	CQUERY += " AND  D1_LOJA  BETWEEN '" +  MV_PAR04 +  "'  AND  '" +  MV_PAR06 +  "'
	CQUERY += " AND  D1_COD  BETWEEN '" +  MV_PAR07 +  "'  AND  '" +  MV_PAR08 +  "'

	CQUERY += " , SOLICITACAOEMABERTO=(SELECT SUM(C1_QUANT) FROM " + retsqlname('SC1')+ " WHERE D1_FORNECE+D1_LOJA = A2_COD+A2_LOJA AND D_E_L_E_T_ <>'*' AND  "
	CQUERY += " C1_EMISSAO  BETWEEN '" +  DTOS(MV_PAR01) +  "'  AND  '" + DTOS(MV_PAR02) +  "')"
	CQUERY += " AND  C1_FORNECE  BETWEEN '" +  MV_PAR03 +  "'  AND  '" +  MV_PAR05 +  "'
	CQUERY += " AND  C1_LOJA  BETWEEN '" +  MV_PAR04 +  "'  AND  '" +  MV_PAR06 +  "'
	CQUERY += " AND  C1_PRODUTO  BETWEEN '" +  MV_PAR07 +  "'  AND  '" +  MV_PAR08 +  "'

	CQUERY += " , PEDIDOABERTO=(SELECT SUM(C7_QUANT) FROM " + retsqlname('SC7')+ " WHERE C7_FORNECE+C7_LOJA = A2_COD+A2_LOJA AND D_E_L_E_T_ <>'*' AND  "
	CQUERY += " C7_EMISSAO  BETWEEN '" +  DTOS(MV_PAR01) +  "'  AND  '" + DTOS(MV_PAR02) +  "')"
	CQUERY += " AND  C7_FORNECE  BETWEEN '" +  MV_PAR03 +  "'  AND  '" +  MV_PAR05 +  "'
	CQUERY += " AND  C7_LOJA  BETWEEN '" +  MV_PAR04 +  "'  AND  '" +  MV_PAR06 +  "'
	CQUERY += " AND  C7_PRODUTO  BETWEEN '" +  MV_PAR07 +  "'  AND  '" +  MV_PAR08 +  "'

	CQUERY += " FROM " + retsqlname('SB1') + " SB1 "
	CQUERY += " INNER JOIN " + retsqlname('SD1') + " D1 ON D1_COD  = B1_COD
	CQUERY += " INNER JOIN " + retsqlname('SB2') + " B2 ON B2_FILIAL = D1_FILIAL AND B2_COD = D1_COD
	CQUERY += " INNER JOIN " + retsqlname('SC7') + " C7 ON C7_FILIAL = D1_FILIAL AND C7_FORNECE = D1_FORNECE AND C7_LOJA = D1_LOJA AND C7_PRODUTO = D1_COD
	CQUERY += " INNER JOIN " + retsqlname('SC1') + " C1 ON C1_FILIAL = C7_FILIAL AND C1_PRODUTO = C7_PRODUTO
	
	CQUERY += " WHERE D1.D_E_L_E_T_ = '' AND C7.D_E_L_E_T_ = '' AND B1.D_E_L_E_T_ = '' AND B2.D_E_L_E_T_ = '' AND C1.D_E_L_E_T_ = ''
	CQUERY += " AND  D1_FORNECE  BETWEEN '" +  MV_PAR03 +  "'  AND  '" +  MV_PAR05 +  "'
	CQUERY += " AND  D1_LOJA  BETWEEN '" +  MV_PAR04 +  "'  AND  '" +  MV_PAR06 +  "'
	CQUERY += " AND  D1_COD  BETWEEN '" +  MV_PAR07 +  "'  AND  '" +  MV_PAR08 +  "'

	CQUERY += " GROUP BY B1_COD, B1_DESC, B2_QATU, B2_QEMP "
	
	MemoWrite("gerfinCP.sql",CQUERY)

	IF SELECT(cAlias) > 0
		DBSELECTAREA(cAlias)
		(cAlias)->(DbCloseArea())
	ENDIF

	dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), cAlias, .F., .T. )
	dbselectarea(cAlias)
	lRet :=  .T.

RETURN lRet

Static Function VALPERG(cPerg)
	Local I, J
	cPerg := PADR(cPerg,10)
	aRegs := {}
	dbSelectArea("SX1")
	dbSetOrder(1)

	if !dbSeek(cPerg)
		AADD(aRegs,{cPerg,"01","Da Emissao"   	,"","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
		AADD(aRegs,{cPerg,"02","Ate Emissao"  	,"","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
		AADD(aRegs,{cPerg,"03","Do Fornecedor"  ,"","","mv_ch3","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SA2",""})
		AADD(aRegs,{cPerg,"04","Da Loja"        ,"","","mv_ch4","C",02,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
		AADD(aRegs,{cPerg,"05","Ate Fornecedor" ,"","","mv_ch5","C",06,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SA2",""})
		AADD(aRegs,{cPerg,"06","Até Loja"       ,"","","mv_ch6","C",02,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})
		AADD(aRegs,{cPerg,"07","Do Produto" 	,"","","mv_ch7","C",15,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","SA2",""})
		AADD(aRegs,{cPerg,"08","Até o Produto"  ,"","","mv_ch8","C",15,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Endif

	For i := 1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j := 1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		Endif
	Next
Return
