#include 'protheus.ch'
#include 'parmtype.ch'
#include 'topconn.ch'
#include "rwmake.ch"

//********************************************************************************
//** Programa : RULTCOM7 **         							** Data : 30/07/13
//********************************************************************************
//** Descricao: RELAÇÃO DAS ULTIMAS COMPRAS
//** Rotinas desenvolvida para imprimir no lay-out solicitado pelo cliente os ultimos pedidos
//** de compras entregues, com quebra por centro de custo e totalização
//********************************************************************************
User Function RULTCOM7()
    //************************************************************************************

	SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,AORD")
	SetPrvt("WNREL,ARETURN,NLASTKEY,_CPERG,_APERGUNTAS,_NLACO")
	SetPrvt("TAMANHO,CABEC1,CABEC2,_CTEXTO,NTIPO,CRODATXT")
	SetPrvt("NCNTIMPR,LI,M_PAG,Z,I,")

    //********************************************************************************
    //** Variaveis obrigatorias dos programas de relatorio
    //********************************************************************************
	titulo	 := "Relação de Compras"
	cDesc1	 := "Emite relação das últimas compras."
	cDesc2	 := "*** Especifico ***"
	cDesc3	 := ""
	cString  := "SC7"
	aOrd     := {}
	wnrel	 := "RULTCOM7"

    //********************************************************************************
    //** Variaveis padrao de todos os relatorios 	
    //********************************************************************************
	aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
	nLastKey := 0
	_cPerg	 := "RUCOMP7"

	pergunte(_cPerg,.F.)

    //********************************************************************************
    //** Envia controle para a funcao SETPRINT		
    //********************************************************************************
	wnrel:=SetPrint(cString,wnrel,_cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd)

	nLastKey:=IIf(LastKey()==27,27,nLastKey)
	If nLastKey == 27
		Return
	Endif
	SetDefault(aReturn,cString)
	nLastKey:=IIf(LastKey()==27,27,nLastKey)
	If nLastKey == 27
		Return
	Endif

    //**************************************************
	RptStatus({|| Cria_TRB()})
    //**************************************************
	RptStatus({|| PROCREL()})
    //**************************************************                   
	dbSelectarea("TRB")
	dbCloseArea()
	Ferase(_cArqTrb+".DBF")
	Ferase(_cArqTrb+OrdBagExt())
    //*************************************************

Return


//************************************************************************************
//** PROCESSA O RELATORIO
//************************************************************************************
Static FUNCTION PROCREL()
    //************************************************************************************
	Tamanho  := "G"
	cabec1   := ""
	cabec2   := ""

	nTipo    := 0
	cRodaTxt := "REGISTRO(S)"
	nCntImpr := 0

	aItens   := {}

    //********************************************************************************
    //** Inicializa os codigos de caracter Comprimido/Normal da impressora
    //********************************************************************************
	nTipo  := IIF(aReturn[4]==1,15,18)

    //********************************************************************************
    //** Contadores de linha e pagina		
    //********************************************************************************
	li    	:= 80
	m_pag 	:= 1
	NVALTOT	:= 0
	NCUSTOT	:= 0
	NVALSUB	:= 0
	NCUSSUB	:= 0

	nOrdem 	:= aReturn[8]
	_cQuebr := ""
	_nSoma  := 0
	_nTotal := 0
	_cQbr   := ""

	// CABEC1 := "Data      Pedido  Nota      Ser   Fornecedor                                Centro de Custo                                   Valor"
    CABEC1 := "Data	        Pedido	NF	      Serie	Cod Fornec	Loja	Nome Fornecedor	               Descrição	Matriz/Filial	       Centro de Custo	Descrição Centro de Custo	   Valor Total"
	CABEC2 := ""
    //         xx/xx/xx     xxxxxx xxxxxxxxx xxx    xxxxxx      xx     xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  xxxxxxxxx    xxxxxxxxxxxxxxxxxxxx   XXXXXXXXX        XXXXXXXXXXXXXXXXXXX         999.999.999,99
    //         01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123
    //         0         1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17
	Titulo := "Relação de Compras "

    //********************************************************************************
    //** Inicializa variaveis para controlar cursor de progressao 
    //********************************************************************************
	dbSelectArea("TRB")
	dbGoTop()
	SetRegua(RECCOUNT())
	Do While !Eof()
		IncRegua()

        //********************************************************************************
        //** Verifica se o usuario interrompeu o relatorio		  
        //********************************************************************************
		If lAbortPrint
			@ PROW(),001 PSAY "CANCELADO PELO OPERADOR"
			Exit
		Endif

		If (li > 56)
			cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
		EndIf

		//*********************************************************************************
		_cRazao := ""
		_cFone 	:= ""
		_cCont 	:= ""
		//*********************************************************************************
		If  TRB->T_CC <> _cQbr
			If _nTotal > 0
				@ li,000 PSAY REPLICATE("-",220)
				li:=li+1
			EndIF
		EndIf
		//*********************************************************************************
		_nValor := TRB->T_VALOR
		//*********************************************************************************

			@ li,000 PSAY DTOC(STOD(TRB->T_DTDIGIT))
			@ li,010 PSAY TRB->T_PEDIDO
			@ li,018 PSAY TRB->T_DOC + " " + TRB->T_SERIE
			@ li,033 PSAY TRB->T_FORNECE + "-" + TRB->T_LOJA + " " + TRB->T_NOMEFOR
			@ li,075 PSAY AllTrim(TRB->T_CC) + "-" + TRB->T_DESCCC
			@ li,116 PSAY _nValor		 	Picture "@E 999,999,999.99"
			li:=li+1

			AADD(aItens,;
				{DTOC(STOD(TRB->T_DTDIGIT)),;          
				TRB->T_PEDIDO,;
				TRB->T_DOC,;			         
				TRB->T_SERIE,;
				TRB->T_FORNECE,;
				TRB->T_LOJA,;
				TRB->T_NOMEFOR,;
				TRB->T_PRODUTO,; 			     
				TRB->T_FILIAL,;
				AllTrim(TRB->T_CC),;
				TRB->T_DESCCC,;
				Transform(_nValor,"@E 999,999,999.99")})

		// Endif


		//*********************************************************************************
		_nSoma 		+= _nValor
		_nTotal 	+= _nValor
		//*********************************************************************************
		dbSelectArea("TRB")
		_cQbr := TRB->T_CC
		dbSkip()
		//*********************************************************************************
		If Eof() .or. TRB->T_CC <> _cQbr
			If (li > 56)
				cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
			EndIf
			@ li,075 PSAY "-------------------------------------------------------"
			li += 1
			If (li > 56)
				cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
			EndIf
			@ li,075 PSAY "Total do Centro de Custo :"
			@ li,116 PSAY _nSoma	Picture "@E 999,999,999.99"
			_nSoma := 0
			li:=li+2
		EndIf

	EndDo
    //*********************************************************************************
	IF li != 80
		li:=li+1
		If (li > 56)
			cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
		EndIf
		@ li,000 PSAY REPLICATE("-",220)
		li:=li+1
		@ li,075 PSAY "TOTAL DOS PEDIDOS ENTREGUES : "
		@ li,116 PSAY _nTotal	Picture "@E 999,999,999.99"
		Roda(nCntImpr,cRodaTxt,Tamanho)
	EndIF

    //********************************************************************************
    //** Apresenta relatorio na tela 
    //********************************************************************************
	Set Device To Screen
	If aReturn[5] == 1
		Set Printer TO
		dbcommitAll()
		ourspool(wnRel)
	EndIf
	MS_FLUSH()

	IF ApMsgYesNO('Gera Planilha Agora?!')                            "
		MsAguarde({||GeraExcell(aItens)},"Aguarde","Gerando dados para a Planilha...")
	ENDIF	

RETURN

//************************************************************************************
Static Function CriaSQL(_cTp)
    //************************************************************************************                       
	cQuery := ''
	aStrucSF1 := SF1->(dbStruct())
	aStrucSD1 := SD1->(dbStruct())
	aStrucSA1 := SA1->(dbStruct())
	aStrucSA2 := SA2->(dbStruct())
	aStrucSF4 := SF4->(dbStruct())
	cALiasSF1 := "QRYSD1"
	cAliasSD1 := "QRYSD1"
	cALiasSA1 := "QRYSD1"
	cALiasSA2 := "QRYSD1"
	cALiasSF4 := "QRYSD1"
	If _cTp = 1
		cQuery :=          "  Select COUNT(*) AS NREGS "
	Else
		cQuery := "SELECT D1_FILIAL"
		cQuery += ", D1_DOC"
		cQuery += ", D1_SERIE"
		cQuery += ", D1_FORNECE"
		cQuery += ", D1_LOJA"
		cQuery += ", D1_DTDIGIT"
		cQuery += ", SUM(D1_TOTAL) AS TOTAL"
		cQuery += ", D1_CC"
		cQuery += ", D1_PEDIDO"
		cQuery += ", D1_COD"
		cQuery += ", F4_AGREG"
		cQuery += ", A2_NOME"
	EndIf
	cQuery += " FROM " + RetSqlName("SF1") + " SF1"
	cQuery += ", " + RetSqlName("SD1") + " SD1"
	cQuery += ", " + RetSqlName("SA2") + " SA2"
	cQuery += ", " + RetSqlName("SF4") + " SF4"
	cQuery += " WHERE"
	cQuery += " SF1.F1_FILIAL='" + xFilial("SF1") + "'"
	cQuery += " AND SF1.D_E_L_E_T_ <> '*'"
	cQuery += " AND SD1.D1_FILIAL = '" + xFilial("SD1") + "'"
	cQuery += " AND SD1.D1_DOC = SF1.F1_DOC"
	cQuery += " AND SD1.D1_SERIE = SF1.F1_SERIE"
	cQuery += " AND SD1.D1_FORNECE = SF1.F1_FORNECE"
	cQuery += " AND SD1.D1_LOJA = SF1.F1_LOJA"
	cQuery += " AND SD1.D1_TIPO NOT IN ('D','B')"
	cQuery += " AND NOT (" + IsRemito(3,'SD1.D1_TIPODOC') + ")"
	cQuery += " AND SD1.D_E_L_E_T_ <> '*'"
	cQuery += " AND SF4.F4_FILIAL ='" + xFilial("SF4") + "'"
	cQuery += " AND SF4.F4_CODIGO = SD1.D1_TES"
	cQuery += " AND SF4.D_E_L_E_T_ <> '*'"
	cQuery += " AND SA2.A2_FILIAL ='" + xFilial("SA2") + "'"
	cQuery += " AND SA2.A2_COD = SD1.D1_FORNECE"
	cQuery += " AND SA2.A2_LOJA = SD1.D1_LOJA"
	cQuery += " AND SA2.D_E_L_E_T_ <> '*'"
	cQuery += " AND SD1.D1_DTDIGIT >= '20240101' "
	cQuery += " AND SD1.D1_DTDIGIT <= '20241231' "
	cQuery += " AND SD1.D1_CC >= ' '"
	cQuery += " AND SD1.D1_CC <= 'ZZZZZZZZZ' "
	cQuery += " AND SD1.D1_FORNECE >= ' '"
	cQuery += " AND SD1.D1_FORNECE <= 'ZZZZZZ' "
	cQuery += " AND SF4.F4_AGREG <> 'N' "
	If _cTp <> 1
		cQuery += " GROUP BY SD1.D1_FILIAL,SD1.D1_CC,SD1.D1_PEDIDO,SD1.D1_COD,SD1.D1_DOC,SD1.D1_SERIE,SD1.D1_FORNECE,SD1.D1_LOJA,SD1.D1_DTDIGIT,SF4.F4_AGREG,SA2.A2_NOME"
		cQuery += " ORDER BY SD1.D1_FILIAL,SD1.D1_CC,SD1.D1_DOC,SD1.D1_SERIE"

	EndIf

	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),"SQL",.T.,.T.) //"Seleccionado registros"
	If _cTp = 1
		_nRegs := 0
		dbSelectArea("SQL")
		dbGoTop()
		Do While !Eof()
			_nRegs := SQL->NREGS
			dbSkip()
		EndDo
		dbCloseArea("SQL")
		dbSelectArea("SD1")
		Return(_nRegs)
	EndIf

Return

//************************************************************************************
//** Funcao:  CriaTrb
//************************************************************************************
Static Function Cria_Trb()
    //************************************************************************************
	Public _cArqTrb
	Public _aCamp
	_aTmpSql:= {}
	AADD(_aTmpSql,{"T_FILIAL"   	  	,"C",02,0})
	AADD(_aTmpSql,{"T_DOC"      	  	,"C",09,0})
	AADD(_aTmpSql,{"T_SERIE"      	  	,"C",03,0})
	AADD(_aTmpSql,{"T_PEDIDO"      	  	,"C",06,0})
	AADD(_aTmpSql,{"T_FORNECE"   		,"C",06,0})
	AADD(_aTmpSql,{"T_LOJA"   			,"C",02,0})
	AADD(_aTmpSql,{"T_NOMEFOR"   		,"C",30,0})
	AADD(_aTmpSql,{"T_CC"   	  		,"C",09,0})
	AADD(_aTmpSql,{"T_DESCCC"  	  		,"C",30,0})
	AADD(_aTmpSql,{"T_DTDIGIT" 	  		,"C",08,0})
	AADD(_aTmpSql,{"T_VALOR"   	  		,"N",14,2})
	AADD(_aTmpSql,{"T_PRODUTO"	  		,"C",15,0})
	_cArqTrb := CriaTrab(_aTmpSql,.T.)
	dbUseArea(.T.,,_cArqTrb,"TRB")
	_cOrdem := "T_FILIAL + T_CC + T_DTDIGIT + T_NOMEFOR"
	IndRegua ( "TRB",_cArqTrb,_cOrdem,,,"Selecionando Registros...")
	dbSelectArea("TRB")

	_nRegs := CriaSQL(1)
	CriaSQL(2)
	dbSelectArea("SQL")
	dbGoTop()
	SetRegua(_nRegs)
	Do While !Eof()
		IncRegua()
		_cDescCC 	:= ""
		dbSelectArea("CTT")
		dbSetOrder(1)
		If dbSeek(xFilial("CTT")+SQL->D1_CC)
			_cDescCC := CTT->CTT_DESC01
		EndIf
		dbSelectArea("TRB")
		RecLock("TRB",.T.)
		TRB->T_FILIAL	:= SQL->D1_FILIAL
		TRB->T_DOC		:= SQL->D1_DOC
		TRB->T_SERIE	:= SQL->D1_SERIE
		TRB->T_PEDIDO	:= SQL->D1_PEDIDO
		TRB->T_FORNECE	:= SQL->D1_FORNECE
		TRB->T_LOJA		:= SQL->D1_LOJA
		TRB->T_NOMEFOR	:= SQL->A2_NOME
		TRB->T_VALOR	:= SQL->TOTAL
		TRB->T_CC	    := SQL->D1_CC
		TRB->T_DESCCC	:= _cDescCC
		TRB->T_DTDIGIT  := SQL->D1_DTDIGIT
		TRB->T_PRODUTO  := Posicione("SB1",1,xFilial("SB1")+SQL->D1_COD,"B1_DESC")
		MsUnLock()
		dbSelectArea("SQL")
		dbSkip()
	EndDo
	dbSelectArea("SQL")
	dbCloseArea("SQL")
	dbSelectArea("TRB")
Return


Static Function DlgToExcel()

    Local oExcel    := FWMSEXCEL():New() //Cria o Objeto que ira gerar o Arquivo
    Local cArqv     := 'REL_AnaliticoSOL.XML'
    Local cPath     := 'C:\temp\'
    Local cPlanilha := 'Analitico'
    Local cTabela   := "CONTOLE_CENTRO_CUSTO"
    ProcRegua(RecCount())
    oExcel:AddworkSheet(cPlanilha) //Cria Planilha(Pasta) Dentro do Arquivo
    oExcel:AddTable (cPlanilha,cTabela) //Cria uma Tabela
    oExcel:AddColumn(cPlanilha,cTabela,"Data"       	,1,1) 	
    oExcel:AddColumn(cPlanilha,cTabela,"Pedido"       	,1,1) 
    oExcel:AddColumn(cPlanilha,cTabela,"NF"       		,1,1) 
    oExcel:AddColumn(cPlanilha,cTabela,"Serie"       	,1,1) 
    oExcel:AddColumn(cPlanilha,cTabela,"Cod Fornec"     ,1,1) 
    oExcel:AddColumn(cPlanilha,cTabela,"Loja"       	,1,1) 
    oExcel:AddColumn(cPlanilha,cTabela,"Nome Fornecedor",1,1) 
    oExcel:AddColumn(cPlanilha,cTabela,"Descrição"      ,1,1) 
    oExcel:AddColumn(cPlanilha,cTabela,"Matriz/Filial"  ,1,1) 
    oExcel:AddColumn(cPlanilha,cTabela,"Centro de Custo",1,1) 
    oExcel:AddColumn(cPlanilha,cTabela,"Descrição Centro de Custo",1,1) 
    oExcel:AddColumn(cPlanilha,cTabela,"Valor Total"    ,1,1) 

    oExcel:SetLineBgColor('"#4F81BD"')
    oExcel:SetLineBgColor('#FFFFFF')

    oExcel:SetLineBgColor('#000000')

    oExcel:SetLineBgColor('#AAAAAA') //Cor de Preenchimento da Linha Impar
    oExcel:Set2LineBgColor('#FFFFFF')//Cor de Preenchimento da Linha Par

    nX := 1        
    dbselectarea("TRB")
    dbgotop()
    _DATA   := ''
    _FUNCX  :=  ''
    _TOTALX := 0
    _TOTALGX:= 0
    _PRODUTOX:=''	
    
    TRB->(DbGoTop())   
    While TRB->(!eof())

        // aSM0Data2 := FWSM0Util():GetSM0Data(, TRB->T_FILIAL, aFieldSM0)
        // If Len(aSM0Data2) > 0
        //     cFil := (aSM0Data2[3][2]) //M0_NOMECOM
        // EndIf

        IncProc("Selecionando os Registro")                          
        cCel := {DTOC(STOD(TRB->T_DTDIGIT)),;          
                TRB->T_PEDIDO,;
                TRB->T_DOC,;			         
                TRB->T_SERIE,;
                TRB->T_FORNECE,;
                TRB->T_LOJA,;
                TRB->T_NOMEFOR,;
                TRB->T_PRODUTO,; 			     
                TRB->T_FILIAL,;
                AllTrim(TRB->T_CC),;
                TRB->T_DESCCC,;
                _nValor} 
            oExcel:AddRow(cPlanilha,cTabela,cCel) //Insere uma linha na Tabela
            TRB->(DBSKIP())
    enddo

    oExcel:Activate() //Ativa a Planilha
    oExcel:GetXMLFile(cArqv) //Salva o Arquivo

    IncProc("Montando Arquivo")

    if !ExistDir(cPath)//verifica se a pasta existe
        MakeDir(cPath) //Cria a Pasta
    endif

    if __CopyFile(cArqv,cPath +cArqv)//Copia o arquivo do servidor para a pasta definida na estação do SmartClient
        
        IF !( ApOleClient("MsExcel") )//Verifica se existe o Excel instalado. Obs: No Windows 8 e 8.1 só com a Build: 7.00.121227P-20131106
            MsgAlert('Não foi possivel localizar o excel' + chr(13) + chr(10) + 'Relatório foi gerado na Pasta: ' + cPath + cArqv, "Aviso")
        else
            oExcelApp := MsExcel():New()
            oExcelApp:WorkBooks:Open()
            oExcelApp:WorkBooks:Open(cPath + cArqv+'.XML') // Abre uma planilha		
            oExcelApp:SetVisible(.T.)
        EndIF
    else
        MsgAlert('Não foi possivel gerar o Relatório', "Aviso")
    endif

Return

STATIC Function GeraExcell(aItens)
    Local oFWMsExcel
    Local oExcel
    Local cArquivo   := GetTempPath() + "RULTCOM7.xml"
    Local cWorkSheet := "Relação Produtos CC"
    Local cTitulo    := "Listagem de Produtos por CC"
	Local X
	
	//Cria a planilha do excel
	oFWMsExcel := FWMSExcel():New()
     
    //Criando a aba da planilha
    oFWMsExcel:AddworkSheet(cWorkSheet)

	
    //Criando a Tabela e as colunas
    oFWMsExcel:AddTable( cWorkSheet, cTitulo)
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo,"Data"				, 1, 1, .F.)
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo,"Pedido"			, 1, 1, .F.)
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo,"NF"				, 1, 1, .F.)
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo,"Serie"			, 1, 1, .F.)
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo,"Cod Fornec"		, 1, 1, .F.)
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo,"Loja"				, 1, 1, .F.)
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo,"Nome Fornecedor"  , 1, 1, .F.)
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo,"Descrição"		, 1, 1, .F.)
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo,"Matriz/Filial"	, 1, 1, .F.)
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo,"Centro de Custo"	, 1, 1, .F.)
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo,"Desc. Centr Custo", 1, 1, .F.)
	oFWMsExcel:AddColumn(cWorkSheet, cTitulo,"Valor Total"		, 1, 1, .F.)

    //Percorrendo os dados da query
    FOR X := 1 TO LEN(aItens)
        oFWMsExcel:AddRow(cWorkSheet, cTitulo, {;
            aItens[X,01],;
            aItens[X,02],;
            aItens[X,03],;
            aItens[X,04],;
            aItens[X,05],;
            aItens[X,06],;
            aItens[X,07],;
            aItens[X,08],;
            aItens[X,09],;
            aItens[X,10],;
            aItens[X,11],;
            aItens[X,12];
        })
    next
     
    //Ativando o arquivo e gerando o xml
    oFWMsExcel:Activate()
    oFWMsExcel:GetXMLFile(cArquivo)
     
    //Abrindo o excel e abrindo o arquivo xml
    oExcel := MsExcel():New()
    oExcel:WorkBooks:Open(cArquivo)
    oExcel:SetVisible(.T.)
    oExcel:Destroy()
Return
