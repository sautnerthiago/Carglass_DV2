#include 'protheus.ch'
#include "rwmake.ch"
#Include 'Totvs.ch'
#Include "TopConn.ch"
#INCLUDE "TBICONN.CH"
#Include "FWMVCDef.ch"

Static aTitArq    := {}
Static nRecnoE1   := 0
Static cFil       := '' 
Static MV_xPA1    := ''
Static MV_xPA2    := ''
Static MV_xPA3    := ''
Static MV_xPA4    := ''
Static MV_xPA5    := ''
Static MV_xPA6    := ''

//Static cSaySOM := 'Saldo Total :'
//Static nValRA  := 0

Static cClient    := space(06)
Static cLoja      := space(02)
Static cPrefi     := space(03)
Static cNumRA     := space(09)
Static cParce     := space(02)
Static cTipoB     := space(03)   

/*/{Protheus.doc} ImportTit
Abertura dos perguntes e 
processa os dados
@author Fabio José Batista
@since 03/12/2024
@version 1.0
@type function
/*/
User Function ImportTit()
    Local nSaldo := 0
    Local lRetParame  := GETMV('MV_CMP330')
	Private cArquivo  := ''
	Private _oDlg
	Private oEdit
	Private nCombo2
	Private ODLG1
	
	Private dDTF     := CtoD(" ")
    Private dDTI     := CtoD(" ")
	Private cBanco   := space(03)
    Private cAgencia := space(05)  
    Private cConta   := space(10)
 
    If !lRetParame
        Alert('O parametro MV_CMP330 deverá conter o conteúdo igual a .T.')
        Return
    EndIf  
    PERGUNTE("IMPTITRECE",.T.)

    MV_xPA1    := MV_PAR01
    MV_xPA2    := MV_PAR02
    MV_xPA3    := MV_PAR03
    MV_xPA4    := MV_PAR04
    MV_xPA5    := MV_PAR05
    MV_xPA6    := MV_PAR06
    cArquivo   := alltrim(MV_PAR07)
    
    nSaldo := ValSalRA(MV_xPA1,MV_xPA2,MV_xPA3,MV_xPA4)
    If nSaldo > 0
        If ! Empty(cArquivo)
            If File(cArquivo) .And. Upper(SubStr(cArquivo, RAt('.', cArquivo) + 1, 3)) == 'CSV'
                Processa({|| ProcArq(cArquivo) }, "Importando...")
            Else
                MsgStop("Arquivo e/ou extensão inválida!", "Atenção")
            EndIf
        EndIf
    Else 
        Alert('Titulo RA sem saldo...')
    EndIf 
Return

/*/{Protheus.doc} Arquiv
Busca o arquivo CSV
@author Fabio José Batista
@since 03/12/2024
@version 1.0
@type function
/*/
Static function Arquiv(cArquivo)

    Local aArea     := GetArea()
    Default cArquivo := ''

    If ExistDir('c:\titulos')
        cArquivo := cGetFile( 'Arquivo CSV|*.csv',;                   //[ cMascara], 
                            'Selecao de Arquivos',;                  //[ cTitulo], 
                            0,;                                      //[ nMascpadrao], 
                            'C:\Titulos\',;                            //[ cDirinicial], 
                            .F.,;                                    //[ lSalvar], 
                            GETF_LOCALHARD  + GETF_NETWORKDRIVE,;    //[ nOpcoes], 
                            .T.) 
    Else
        Alert('Deverá ser criado uma pasta com seguinte caminho c:\titulos', 'Atenção')
    EndIf 

    If ! Empty(cArquivo)
        If File(cArquivo) .And. Upper(SubStr(cArquivo, RAt('.', cArquivo) + 1, 3)) == 'CSV'
            Processa({|| ProcArq(cArquivo) }, "Importando...")
        Else
            MsgStop("Arquivo e/ou extensão inválida!", "Atenção")
        EndIf
    EndIf
    RestArea(aArea)


Return

/*/{Protheus.doc} ProcArq
Cahamada da função fimporta
@author Fabio José Batista
@since 03/12/2024
@version 1.0
@type function
/*/
Static Function ProcArq(cArquivo)

    fImporta(cArquivo)     

Return

/*/{Protheus.doc} fImporta
Abertura e leitura do arquivo
@author Fabio José Batista
@since 03/12/2024
@version 1.0
@type function
/*/
Static Function fImporta(cArquivo)
    
    Local aArea      := GetArea()
    Local nTotLinhas := 0
    Local cLinAtu    := ""
    Local nLinhaAtu  := 0
    Local aLinha     := {}
    Local oArquivo
    Local aLinhas    := {}
    Local aTitulos   := {}
    Private cDirLog  := GetTempPath() + "x_importacao\"
    Private cLog     := ""
    
    If ! ExistDir(cDirLog)
        MakeDir(cDirLog)
    EndIf
  
    oArquivo := FWFileReader():New(cArquivo)
      
    If (oArquivo:Open())
  
        If ! (oArquivo:EoF())
  
            aLinhas := oArquivo:GetAllLines()
            nTotLinhas := Len(aLinhas)
            ProcRegua(nTotLinhas)
              
            oArquivo:Close()
            oArquivo := FWFileReader():New(cArquivo)
            oArquivo:Open()
  
            While (oArquivo:HasLine())
  
                nLinhaAtu++
                IncProc("Analisando linha " + cValToChar(nLinhaAtu) + " de " + cValToChar(nTotLinhas) + "...")
                  
                cLinAtu := oArquivo:GetLine()
                aLinha  := StrTokArr(cLinAtu, ";")
                If Len(aLinha) > 0
                    AAdd(aTitulos, {aLinha[1],aLinha[2]})
                EndIf  
                
            EndDo
            If len(aTitulos) > 0 
                fMontaTela(aTitulos)
            EndIf 
          
        Else
            MsgStop("Arquivo não tem conteúdo!", "Atenção")
        EndIf
  
        //Fecha o arquivo
        oArquivo:Close()
    Else
        MsgStop("Arquivo não pode ser aberto!", "Atenção")
    EndIf
  
    RestArea(aArea)
Return

  
/*/{Protheus.doc} fMontaTela
Monta a tela com a marcação de dados
@author Fabio José Batista
@since 03/12/2024
@version 1.0
@type function
/*/
Static Function fMontaTela(aTitulos)
    Local aArea         := GetArea()
    Local aCampos := {}
    Local oTempTable := Nil
    Local aColunas := {}
    Local cFontPad    := 'Tahoma'
    Local oFontGrid   := TFont():New(cFontPad,,-14)
    
    Local cFontTot    := 'Tahoma, -12, Negrito' 
    Local oFontLog    := TFont():New(cFontTot, , -18,,.T.)
    //Janela e componentes
    Private oDlgMark
    Private oPanGrid
    Private oMarkBrowse
    Private cAliasTmp := GetNextAlias()
    Private aRotina   := MenuDef()
    //Tamanho da janela
    Private aTamanho := MsAdvSize()
    Private nJanLarg := aTamanho[5]
    Private nJanAltu := aTamanho[6]
    Private cSaySOM := 'Saldo Total :'
    Private cSayLog := "Total Selecionado : 0,00"
    Private cSayRA  := "Valor RA : "
    Private nValRA  := 0
    
    If !select('SE1') > 0
        dbSelectArea("SE1")
    EndIf 
    SE1->(dbSetOrder(1))//E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO                                                                                               
    SE1->(DbGoTop())
    //titulo RA
    If SE1->(dbseek(xFilial('SE1')+MV_XPA1+MV_XPA2+MV_XPA3+MV_XPA4))
        nRecnoRA := SE1->(RECNO())
    EndIf  
    cSayRA += alltrim(Transform(SE1->(E1_SALDO), "@E 9,999,999,999,999.99"))
    cSaySOM += alltrim(Transform(SE1->(E1_SALDO), "@E 9,999,999,999,999.99"))
    nValRA := SE1->(E1_SALDO)
    SE1->(DbCloseArea())

    //Adiciona as colunas que serão criadas na temporária
    aAdd(aCampos, { 'OK'          , 'C', 2 , 0})
    aAdd(aCampos, { 'E1_FILIAL'   , 'C', TamSX3('E1_FILIAL' )[1]  , 0                      })
    aAdd(aCampos, { 'E1_PREFIXO'  , 'C', TamSX3('E1_PREFIXO')[1]  , 0                      })
    aAdd(aCampos, { 'E1_NUM'      , 'C', TamSX3('E1_NUM'    )[1]  , 0                      })
    aAdd(aCampos, { 'E1_PARCELA'  , 'C', TamSX3('E1_PARCELA')[1]  , 0                      })
    aAdd(aCampos, { 'E1_TIPO'     , 'C', TamSX3('E1_TIPO'   )[1]  , 0                      })
    aAdd(aCampos, { 'E1_NATUREZ'  , 'C', TamSX3('E1_NATUREZ')[1]  , 0                      })
    aAdd(aCampos, { 'E1_PORTADO'  , 'C', TamSX3('E1_PORTADO')[1]  , 0                      })
    aAdd(aCampos, { 'E1_CLIENTE'  , 'C', TamSX3('E1_CLIENTE')[1]  , 0                      })
    aAdd(aCampos, { 'E1_LOJA'     , 'C', TamSX3('E1_LOJA'   )[1]  , 0                      })
    aAdd(aCampos, { 'E1_EMISSAO'  , 'D', TamSX3('E1_EMISSAO')[1]  , 0                      })
    aAdd(aCampos, { 'E1_VENCTO'   , 'D', TamSX3('E1_VENCTO' )[1]  , 0                      })
    aAdd(aCampos, { 'E1_VENCREA'  , 'D', TamSX3('E1_VENCREA')[1]  , 0                      })
    aAdd(aCampos, { 'E1_VALOR'    , 'N', TamSX3('E1_VALOR'  )[1]  , TamSX3('E1_VALOR'  )[2]})
   // aAdd(aCampos, { 'CONTRATO' , 'C', 4 , 0})
   

    //Cria a tabela temporária
    oTempTable:= FWTemporaryTable():New(cAliasTmp)
    oTempTable:SetFields( aCampos )
    oTempTable:AddIndex("1", {"E1_FILIAL","E1_NUM"} )
    oTempTable:Create()  
  
    //Popula a tabela temporária
    Processa({|| fPopula(aTitulos)}, 'Processando...')
  
    //Adiciona as colunas que serão exibidas no FWMarkBrowse
    aColunas := fCriaCols(aTitulos)
    
    //filtro na pesquisa
    aSeek := {}
    cCampoAux := "E1_NUM"
    aAdd(aSeek,{GetSX3Cache(cCampoAux, "X3_TITULO"), {{"", GetSX3Cache(cCampoAux, "X3_TIPO"), GetSX3Cache(cCampoAux, "X3_TAMANHO"), GetSX3Cache(cCampoAux, "X3_DECIMAL"), AllTrim(GetSX3Cache(cCampoAux, "X3_TITULO")), AllTrim(GetSX3Cache(cCampoAux, "X3_PICTURE"))}} } )

    //Criando a janela
    DEFINE MSDIALOG oDlgMark TITLE 'Baixa de titulos' FROM 000, 000  TO nJanAltu, nJanLarg COLORS 0, 16777215 PIXEL
        //Dados
        oPanGrid := tPanel():New(001, 001, '', oDlgMark, , , , RGB(000,000,000), RGB(254,254,254), (nJanLarg/2)-1,     (nJanAltu/2 - 1))
        oMarkBrowse:= FWMarkBrowse():New()
        oMarkBrowse:SetDescription("Titulos") //Titulo da Janela
        oMarkBrowse:SetAlias(cAliasTmp)
        oMarkBrowse:oBrowse:SetDBFFilter(.T.)
        oMarkBrowse:oBrowse:SetUseFilter(.F.) //Habilita a utilização do filtro no Browse
        oMarkBrowse:oBrowse:SetFixedBrowse(.T.)
        oMarkBrowse:SetWalkThru(.F.) //Habilita a utilização da funcionalidade Walk-Thru no Browse
        oMarkBrowse:SetAmbiente(.T.) //Habilita a utilização da funcionalidade Ambiente no Browse
        oMarkBrowse:SetTemporary(.T.) //Indica que o Browse utiliza tabela temporária
        oMarkBrowse:oBrowse:SetSeek(.T.,aSeek) //Habilita a utilização da pesquisa de registros no Browse
        oMarkBrowse:oBrowse:SetFilterDefault("") //Indica o filtro padrão do Browse
        oMarkBrowse:SetFieldMark('OK')
        oMarkBrowse:SetFontBrowse(oFontGrid)
        oMarkBrowse:SetOwner(oPanGrid)
        oMarkBrowse:SetColumns(aColunas)
        
        //Funcao para totalizador
        oMarkBrowse:SetAfterMark({|| fAposMarcar()})
        
        oMarkBrowse:Activate()
        //escreve no cabeçalho da tela 
        nLinObj := (nJanAltu/2) - 15
        oSayLog := TSay():New(017, 165, {|| cSayRA} , oDlgMark, "", oFontLog, , , , .T., , , (nJanLarg/2) - 6, 10, , , , , , .F., , )
        //oSayLog := TSay():New(017, 305, {|| cSaySOM}, oDlgMark, "", oFontLog, , , , .T., , , (nJanLarg/2) - 6, 10, , , , , , .F., , )
        oSayLog := TSay():New(017, 470, {|| cSayLog}, oDlgMark, "", oFontLog, , , , .T., , , (nJanLarg/2) - 6, 10, , , , , , .F., , )
        
        oSaySOM := TSay():New(017, 305, {|| cSaySOM}, oDlgMark, "", oFontLog, , , , .T., , , (nJanLarg/2) - 6, 10, , , , , , .F., , )
        If ValType(oSaySOM) == "O"
            oSaySOM:Refresh()
        EndIf
    ACTIVATE MsDialog oDlgMark CENTERED       
    
    //Deleta a temporária e desativa a tela de marcação
    oTempTable:Delete()
    oMarkBrowse:DeActivate()
      
    RestArea(aArea)
Return
  
/*/{Protheus.doc} MenuDef
Botões usados no Browse
@author Fabio José Batista
@since 03/12/2024
@version 1.0
@type function
/*/
Static Function MenuDef()
    Local aRotina := {}
       
    //Criação das opções
    ADD OPTION aRotina TITLE 'Compensar'  ACTION 'u_Concilia'     OPERATION 2 ACCESS 0
    
Return aRotina
  
/*/{Protheus.doc} fPopula
Executa a query SQL e popula essa informação na tabela temporária usada no browse
@author Fabio José Batista
@since 04/12/2024
@version 1.0
@type function
/*/ 
Static Function fPopula(aTitulos)
    Local nTotal    := 0
    Local nAtual    := 0
    Local cQry      := ''
	Local cNumero   := ''
	Local nY        := 0 
    Local cCliRa    := ''
    Local cLojRA    := ''
    
    aTitArq := aTitulos
    MV_xPA1 := PadR(MV_xPA1,TamSX3("E1_PREFIXO")[1])
    MV_xPA2 := PadR(MV_xPA2,TamSX3("E1_NUM")[1]) 
    MV_xPA3 := PadR(MV_xPA3,TamSX3("E1_PARCELA")[1]) 
    MV_xPA4 := PadR(MV_xPA4,TamSX3("E1_TIPO")[1])

    If len(aTitulos) > 0
        For nY := 1 to len(aTitulos)
            cNumero += "'"+aTitulos[nY][1]+ "'"
            If nY < Len(aTitulos)
                cNumero += ","
            EndIf
        Next nY
    EndIf 
    
    If !Select('SE1') > 0
        dbSelectArea('SE1')
    EndIf 
    SE1->(dbSetOrder(1)) //E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO                                                                                                                  
    SE1->(DbGoTop())
    If SE1->(dbseek(xFilial('SE1')+MV_xPA1+MV_xPA2+MV_xPA3+MV_xPA4))
        cCliRa := SE1->E1_CLIENTE
        cLojRA  := SE1->E1_LOJA
    EndIf   
    SE1->(DbCloseArea())
    
    LogsResult(cNumero,cCliRa,cLojRA,Dtos(MV_xPA5),Dtos(MV_xPA6),aTitulos)

    nExist := 0  
    cQry := "select E1_FILIAL,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO,E1_NATUREZ,E1_PORTADO,E1_CLIENTE,E1_LOJA "
    cQry += ",E1_EMISSAO,E1_VENCTO,E1_VENCREA,E1_VALOR,'CONTRATO' "
	cQry += "from "+RetSqlName('SE1') + " SE1 " 
	cQry += "where E1_SALDO > 0 "
    cQry += "and E1_FILIAL  =  '"+ xFilial('SE1') +"' " 
	//cQry += "and E1_CLIENTE = '" + cCliRa + "'  "
    //cQry += "and E1_LOJA = '" + cLojRA + "'  "
	cQry += "and E1_EMISSAO >= '" + Dtos(MV_xPA5) + "' and E1_EMISSAO <= '" + Dtos(MV_xPA6) + "'
	//cQry += "and E1_NUM in (" + cNumero + ") "
    cQry += "and E1_NRDOC in (" + cNumero + ") "
    cQry += "and D_E_L_E_T_ =  ' ' "
    cQry += "order by E1_NUM "

    PLSQuery(cQry, 'QRYDADTMP')
  
    //Definindo o tamanho da régua
    DbSelectArea('QRYDADTMP')
    Count to nTotal
    ProcRegua(nTotal)
    QRYDADTMP->(DbGoTop())
  
    //Enquanto houver registros, adiciona na temporária
    While ! QRYDADTMP->(EoF())
        nAtual++
        IncProc('Analisando registro ' + cValToChar(nAtual) + ' de ' + cValToChar(nTotal) + '...')
        nExist++
        RecLock(cAliasTmp, .T.)
            (cAliasTmp)->OK          := Space(2)
            (cAliasTmp)->E1_FILIAL   := QRYDADTMP->E1_FILIAL
            (cAliasTmp)->E1_PREFIXO  := QRYDADTMP->E1_PREFIXO
            (cAliasTmp)->E1_NUM      := QRYDADTMP->E1_NUM
            (cAliasTmp)->E1_PARCELA  := QRYDADTMP->E1_PARCELA
            (cAliasTmp)->E1_TIPO     := QRYDADTMP->E1_TIPO
            (cAliasTmp)->E1_NATUREZ  := QRYDADTMP->E1_NATUREZ
            (cAliasTmp)->E1_PORTADO  := QRYDADTMP->E1_PORTADO
            (cAliasTmp)->E1_CLIENTE  := QRYDADTMP->E1_CLIENTE
            (cAliasTmp)->E1_LOJA     := QRYDADTMP->E1_LOJA
            (cAliasTmp)->E1_EMISSAO  := QRYDADTMP->E1_EMISSAO
            (cAliasTmp)->E1_VENCTO   := QRYDADTMP->E1_VENCTO
            (cAliasTmp)->E1_VENCREA  := QRYDADTMP->E1_VENCREA
            (cAliasTmp)->E1_VALOR    := QRYDADTMP->E1_VALOR
           
            (cAliasTmp)->(MsUnlock())
  
        QRYDADTMP->(DbSkip())
    EndDo
    QRYDADTMP->(DbCloseArea())
    (cAliasTmp)->(DbGoTop())
Return
  
/*/{Protheus.doc} fCriaCols
Função que gera as colunas usadas no browse (similar ao antigo aHeader)
@author Fabio José Batista
@since 04/12/2024
@version 1.0
@type function
/*/
Static Function fCriaCols(aTitulos,dDTF,dDTI,cClient,cLoja,cBanco,cAgencia,cConta)
    Local nAtual       := 0 
    Local aColunas := {}
    Local aEstrut  := {}
    Local oColumn
      
    //Adicionando campos que serão mostrados na tela
    //[1] - Campo da Temporaria
    //[2] - Titulo
    //[3] - Tipo
    //[4] - Tamanho
    //[5] - Decimais
    //[6] - Máscara

    AADD(aEstrut,{"E1_FILIAL "  ,'Filial'              ,"C",      2,0,''})
    AADD(aEstrut,{"E1_PREFIXO"  ,'Prefixo'             ,"C",      3,0,''})
    AADD(aEstrut,{"E1_NUM"      ,'No.Titulo'           ,"C",      9,0,''})
    AADD(aEstrut,{"E1_PARCELA"  ,'Parcela'             ,"C",      2,0,''})
    AADD(aEstrut,{"E1_TIPO"     ,'Tipo'                ,"C",      3,0,''})
    AADD(aEstrut,{"E1_NATUREZ"  ,'Natureza'            ,"C",      10,0,''})
    AADD(aEstrut,{"E1_PORTADO"  ,'Portador'            ,"C",      3,0,''})
    AADD(aEstrut,{"E1_CLIENTE"  ,'Cliente'             ,"C",      6,0,''})
    AADD(aEstrut,{"E1_LOJA "    ,'Loja'                ,"C",      2,0,''})
    AADD(aEstrut,{"E1_EMISSAO " ,'Dt.Emissão'          ,"D",      8,0,''})
    AADD(aEstrut,{"E1_VENCTO "  ,'Dt.Vencto'           ,"D",      8,0,''})
    AADD(aEstrut,{"E1_VENCREA " ,'Venc.Real'           ,"D",      8,0,''})
    AADD(aEstrut,{"E1_VALOR "    ,'Valor'              ,"N",     16,2,'@E 9,999,999,999,999.99'})


    For nAtual := 1 To Len(aEstrut)
        //Cria a coluna
        oColumn := FWBrwColumn():New()
        oColumn:SetData(&('{|| ' + cAliasTmp + '->' + aEstrut[nAtual][1] +'}'))
        oColumn:SetTitle(aEstrut[nAtual][2])
        oColumn:SetType(aEstrut[nAtual][3])
        oColumn:SetSize(aEstrut[nAtual][4])
        oColumn:SetDecimal(aEstrut[nAtual][5])
        oColumn:SetPicture(aEstrut[nAtual][6])
  
        //Adiciona a coluna
        aAdd(aColunas, oColumn)
    Next
Return aColunas
  
/*/{Protheus.doc} User Function Concilia
Função acionada pelo botão continuar da rotina
@author Fabio José Batista
@since 03/12/2024
@version 1.0
@type function
/*/
User Function Concilia()
    Processa({|| fProcessa()}, 'Processando...')
Return
  
/*/{Protheus.doc} fProcessa
Função que percorre os registros da tela
@author Fabio José Batista
@since 04/12/2024
@version 1.0
@type function
/*/
Static Function fProcessa()
    Local aArea     := FWGetArea()
    Local cMarca    := oMarkBrowse:Mark()
    Local nAtual    := 0
    Local nTotal    := 0
         
    DbSelectArea(cAliasTmp)
    (cAliasTmp)->(DbGoTop())
    Count To nTotal
    ProcRegua(nTotal)
      
    //Percorrendo os registros
    (cAliasTmp)->(DbGoTop())
    While ! (cAliasTmp)->(EoF())
        nAtual++
        IncProc('Analisando registro ' + cValToChar(nAtual) + ' de ' + cValToChar(nTotal) + '...')
      
        If oMarkBrowse:IsMark(cMarca)
            CmpAutCR((cAliasTmp)->E1_NUM,(cAliasTmp)->E1_VALOR,(cAliasTmp)->E1_FILIAL,(cAliasTmp)->E1_CLIENTE,(cAliasTmp)->E1_LOJA,(cAliasTmp)->E1_PREFIXO,(cAliasTmp)->E1_PARCELA,(cAliasTmp)->E1_TIPO)
        EndIf
           
        (cAliasTmp)->(DbSkip())
    EndDo
      
    //Mostra a mensagem de término e caso queria fechar a dialog, basta usar o método End()
    FWAlertInfo('Finalizado a Compensação!', 'Atenção')
    //oDlgMark:Refresh()
    oDlgMark:End()
  
    FWRestArea(aArea)
Return

Static Function Sair()
    oDlgMark:End()
Return




/*/{Protheus.doc} CmpAutCR
Compensar titulos em aberto com RA selecionada
@author Fabio José Batista
@since 09/10/2025
@version 1.0
@type function
/*/
Static Function CmpAutCR(cNum,cValor,cFILSE1,cCliSE1,cLOJA,cPREFIXO,cPARCELA,cTipo)
 
    Local aArea      := GetArea()
    Local nTaxaCM    := 0
    Local aTxMoeda   := {}
    Local nSaldoComp := 0
    Local dDtComp    := CTOD("  /  /    ")
    Local cFil       := PadR(cFILSE1,TamSX3("E1_FILIAL")[1])  
    Local cPrefi     := PadR(cPrefi,TamSX3("E1_PREFIXO")[1])
    Local cNumRA     := PadR(cNumRA,TamSX3("E1_NUM")[1])
    Local cParce     := PadR(cParce,TamSX3("E1_PARCELA")[1])
    Local cTipoB     := PadR(cTipoB,TamSX3("E1_TIPO")[1])
    Local lRet       := .t.
    Local cSeq       := ''
    Local cPREFIXO   := PadR(cPREFIXO,len(cPrefi))
    Local cNum       := PadR(cNum,len(cNumRA))
    Local cPARCELA   := PadR(cPARCELA,len(cParce))
    Local cTipo      := PadR(cTipo,len(cTipo))
    Local cNrDoc     := ''    
    Local cSeqSE5    := ''
    Local aClieLoj   := {}
    Local cClieRA    := ''
    Local cLojaRA    := ''
              
    Private nRecnoNDF
    //Private nRecnoE1
    //Begin Transaction 
        If Valtype(cValor) == 'C'
            nSaldoComp := Val(cValor)
        Else
            nSaldoComp := cValor   
        EndIf 

        If !select('SE1') > 0
            dbSelectArea("SE1")
        EndIf 
        SE1->(dbSetOrder(2))//E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO                                                                                               
        SE1->(DbGoTop())
        aClieLoj := BuscaRA()
        If len(aClieLoj) > 0 
            cClieRA := aClieLoj[1][1]
            cLojaRA :=   aClieLoj[1][2]
        EndIf 
        //titulo RA
        If SE1->(dbseek(cFil+cClieRA+cLojaRA+MV_XPA1+MV_XPA2+MV_XPA3+MV_XPA4))
            nRecnoRA := SE1->(RECNO())
            dDtComp  := ddatabase//SE1->E1_EMISSAO
            //TITULO NF
            
            If SE1->(dbSeek(cFil+(cAliasTmp)->E1_CLIENTE+(cAliasTmp)->E1_LOJA+cPREFIXO+cNum+cPARCELA+cTipo))
                nRecnoE1 := SE1->(RECNO())
    
                PERGUNTE("FIN330",.F.)
                lContabiliza    := (MV_PAR09 == 1) // Contabiliza On Line ?
                lDigita         := (MV_PAR07 == 1) // Mostra Lanc Contab ?
                lAglutina       := .F.
    
                SE1->(dbSetOrder(1)) //E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_FORNECE+E1_LOJA
    
                aRecRA := { nRecnoRA }
                aRecSE1 := { nRecnoE1 }
            
                //Data a ser considerada na compensação
                dDataBase := dDtComp

                If !MaIntBxCR(3, aRecSE1,,aRecRA,,{lContabiliza,lAglutina,lDigita,.F.,.F.,.F.},,,,,nSaldoComp,,,, nTaxaCM, aTxMoeda)
                    lRet := .F.
                    cNrDoc := SE1->E1_NRDOC
                EndIf 
            EndIf

        EndIf
    //End Transaction

    cSeqSE5 := BUSCASEQ(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_CLIENTE,SE1->E1_LOJA,SE1->E1_BAIXA)
    cSeq := cSeqSE5
   
    If !nRecnoE1 == 0
        SE1->(DbGoTo(nRecnoE1))
        RecLock('SE1',.F.)
            SE1->E1_SEQSE5 := cSeq
        SE1->(MsUnlock())
    EndIf
    
    RestArea(aArea)
    If Select('SE1') > 0
        SE1->(DbCloseArea())
    EndIf  
        
    If !lRet // inclui titulos compensados na tabela de logs
        If !select('P21') > 0
            dbSelectArea("P21")
        EndIf 
            RecLock('P21',.T.)
            P21->P21_FILIAL := FwxFilial("P21")
			P21->P21_COD    := GetSxeNum("P21","P21_COD")
            P21->P21_ALIAS  := "SE1" 		   
			P21->P21_DTINCL := Date()		   
			P21->P21_HRINCL := Time()		   
			P21->P21_CODUSU := RetCodUsr() 	   
			P21->P21_MSEXEC := "Compensação realizada com sucesso. - Filial:"+cFil+' / Cliente:'+(cAliasTmp)->E1_CLIENTE+' - Loja:'+(cAliasTmp)->E1_LOJA+' / Prefixo:'+cPREFIXO+' / Titulo:'+cNum+' / Parcela:'+cPARCELA+' / Tipo:'+cTipo		   
			P21->P21_ARQUIV := cArquivo 		   
					   
            P21->(MsUnlock())
    EndIf 

Return lRet


/*/{Protheus.doc} fAposMarcar
Totalizador 
@author Fabio José Batista
@since 09/10/2025
@version 1.0
@type function
/*/
Static Function fAposMarcar()
    Local aArea     := FWGetArea()
    Local cMarca    := oMarkBrowse:Mark()
    Local nTotal    := 0
    Local nTotMarc  := 0
    Local nTotSaldo := 0
     
    //Define o tamanho da régua
    DbSelectArea(cAliasTmp)
    (cAliasTmp)->(DbGoTop())
    Count To nTotal
     
    //Percorrendo os registros
    (cAliasTmp)->(DbGoTop())
    While ! (cAliasTmp)->(EoF())
     
        //Caso esteja marcado
        If oMarkBrowse:IsMark(cMarca)
            nTotMarc++
            nTotSaldo += (cAliasTmp)->E1_VALOR
        EndIf
          
        (cAliasTmp)->(DbSkip())
    EndDo
 
    cSayLog := ""
    cSaySOM := ""
    cSayLog += "Valor Total : " + alltrim(Transform(nTotSaldo, "@E 9,999,999,999,999.99"))
    cSaySOM := "Saldo Total : " + alltrim(Transform(nValRA-nTotSaldo, "@E 9,999,999,999,999.99"))
    oSayLog:Refresh()
    oSaySOM:Refresh()
 
    FWRestArea(aArea)
Return

/*/{Protheus.doc} ValSalRA
valida saldo da RA 
@author Fabio José Batista
@since 16/10/2025
@version 1.0
@type function
/*/
Static Function ValSalRA(MV_xPA1,MV_xPA2,MV_xPA3,MV_xPA4)
	Local cQry   := ''
	Local nSaldo := 0
	Local aArea  := GetArea()
	
	cQry := "SELECT E1_SALDO "
	cQry += "from "+RetSqlName('SE1') + " SE1 " "
	cQry += "where E1_FILIAL = '"+ xFilial('SE1') +"' " '
    cQry += "and E1_PREFIXO = '"+ MV_xPA1+"' " '
    cQry += "and E1_NUM = '"+ MV_xPA2 +"' " '
 	cQry += "and E1_PARCELA = '"+ MV_xPA3 +"' " '
    cQry += "and E1_TIPO = '"+ MV_xPA4 +"' " '
    cQry += "and D_E_L_E_T_ =  ' ' "
	
	cQry := ChangeQuery(cQry)
    TCQuery cQry New Alias "cQry"
  
    cQry->(DbGoTop())
    While !cQry->(Eof())
    	nSaldo := cQry->(E1_SALDO)
        cQry->(DbSkip())
    EndDo
    
    cQry->(DbCloseArea())

    RestArea(aArea)

Return nSaldo


/*/{Protheus.doc} BUSCASEQ
Captura o campo E5_SEQ nas movimentações 
@author Fabio José Batista
@since 16/10/2025
@version 1.0
@type function
/*/
Static Function BUSCASEQ(cPREFIXO,cNUM,cPARCELA,cTIPO,cCLIENTE,cLOJA,dEMISSAO)
    
    Local cQry   := ''
	Local cSeq   := ''
	Local aArea  := GetArea()
	
	cQry := "select E5_SEQ "
    cQry += "from "+RetSqlName('SE5') + " SE5 " "
    cQry += "where E5_FILIAL = '"+ xFilial('SE5') +"' " '
    cQry += "and E5_NUMERO = '"+ cNUM+"' " '
    cQry += "and E5_PREFIXO = '"+ cPREFIXO+"' " '
    cQry += "and E5_DATA = '"+ dtos(dEMISSAO)+"' " '
    cQry += "and E5_TIPO = '"+ cTIPO+"' " '
    cQry += "and E5_PARCELA = '"+ cPARCELA+"' " '
    cQry += "and E5_CLIFOR = '"+ cCLIENTE+"' " '
    cQry += "and E5_LOJA = '"+ cLOJA+"' " '
    cQry += "and D_E_L_E_T_ = ' '

    cQry := ChangeQuery(cQry)
    TCQuery cQry New Alias "cQry"
  
    cQry->(DbGoTop())
    While !cQry->(Eof())
    	cSeq := cQry->(E5_SEQ)
        cQry->(DbSkip())
    EndDo
    
    cQry->(DbCloseArea())

    RestArea(aArea)

Return cSeq

/*/{Protheus.doc} LogsResult
Gera log caso não encontre o external Id
@author Fabio José Batista
@since 21/10/2025
@version 1.0
@type function
/*/
Static Function LogsResult(cNumero,cCliRa,cLojRA,DtIni,DtFin,aTitulos)

    Local cQuery := ''
	Local aArea  := GetArea()
    Local nY     := 0
    Local cTit   := ''
	
    For nY := 1 to len(aTitulos)
        cTit :=  ''
        cQuery := "select E1_FILIAL,E1_NRDOC,E1_CLIENTE,E1_LOJA,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO "
        cQuery += "from "+RetSqlName('SE1') + " SE1 " 
        cQuery += "where E1_SALDO > 0 "
        cQuery += "and E1_FILIAL  =  '"+ xFilial('SE1') +"' " 
        cQuery += "and E1_CLIENTE = '" + cCliRa + "'  "
        cQuery += "and E1_LOJA = '" + cLojRA + "'  "
        cQuery += "and E1_EMISSAO >= '" + DtIni + "' and E1_EMISSAO <= '" + DtFin +"' "
        cQuery += "and E1_NRDOC = '" + aTitulos[nY][1] + "'  "
        cQuery += "and D_E_L_E_T_ =  ' ' "
        cQuery += "order by E1_NUM "
        
        cQuery := ChangeQuery(cQuery)
        TCQuery cQuery New Alias "cQuery"
        cQuery->(DbGoTop())
        
        While !cQuery->(Eof())
            cTit := cQuery->(E1_NRDOC)
            cQuery->(DbSkip())
        EndDo
        
        If Empty(cTit)
            If !select('P21') > 0
                dbSelectArea("P21")
            EndIf  
                
            RecLock('P21',.T.)
            P21->P21_FILIAL := FwxFilial("P21")
            P21->P21_COD    := GetSxeNum("P21","P21_COD")
            P21->P21_ALIAS  := "SE1" 		                                               
            P21->P21_DTINCL := Date()		   
            P21->P21_HRINCL := Time()		   
            P21->P21_CODUSU := RetCodUsr() 	   
            P21->P21_MSEXEC := "O External Id não encontrado nos titulos a receber: " +alltrim(aTitulos[nY][1])//"Não existe o Titulo na base - Filial:"+cQuery->(E1_FILIAL)+' / Cliente:'+cQuery->(E1_CLIENTE)+' - Loja:'+cQuery->(E1_LOJA)+' / Prefixo:'+cQuery->(E1_PREFIXO)+' / Titulo:'+cQuery->(E1_NUM)+' / Parcela:'+cQuery->(E1_PARCELA)+' / Tipo:'+cQuery->(E1_TIPO)
            P21->P21_ARQUIV := cArquivo  		   
                        
            P21->(MsUnlock())
            cTit :=  ''
        EndIf   
        
        cQuery->(DbCloseArea())    
        RestArea(aArea)  
    
    Next nY  

Return

Static function BuscaRA()

    Local cQuery := ''
	Local aArea  := GetArea()
    Local aDados := {}
    	
    cQuery := "select E1_FILIAL,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO,E1_CLIENTE,E1_LOJA "
    cQuery += "from "+RetSqlName('SE1') + " SE1 " 
    cQuery += "where E1_FILIAL  =  '"+ xFilial('SE1') +"' "  
    cQuery += "and E1_PREFIXO = '" + MV_xPA1 + "'  "
    cQuery += "and E1_NUM = '" + MV_xPA2 + "'  "
    cQuery += "and E1_PARCELA = '" + MV_xPA3 + "'  "
    cQuery += "and E1_TIPO = '" + MV_xPA4 + "'  "
    cQuery += "and E1_EMISSAO >= '" + dtos(MV_xPA5) + "' and E1_EMISSAO <= '" + dtos(MV_xPA6) +"' "
    cQuery += "and D_E_L_E_T_ =  ' ' "
    
    cQuery := ChangeQuery(cQuery)
    TCQuery cQuery New Alias "cQuery"
    cQuery->(DbGoTop())
    
    While !cQuery->(Eof())
        aAdd(aDados,{cQuery->(E1_CLIENTE),cQuery->(E1_LOJA)})
        cQuery->(DbSkip())
    EndDo
    
    cQuery->(DbCloseArea())    
    RestArea(aArea)  

Return aDados
