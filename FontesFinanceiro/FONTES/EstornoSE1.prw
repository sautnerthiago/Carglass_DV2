#include 'protheus.ch'
#include "rwmake.ch"
#Include 'Totvs.ch'
#Include "TopConn.ch"
#INCLUDE "TBICONN.CH"
#Include "FWMVCDef.ch"

Static aTitArq    := {}
Static nRecnoE1   := 0
Static cFil       := '' 
Static MV_PA1    := ''
Static MV_PA2    := ''
Static MV_PA3    := ''
Static MV_PA4    := ''
Static MV_PA5    := ''
Static MV_PA6    := ''
  

User Function EstornoSE1()
    
	Local aArea       := FWGetArea()
    Local cCampo      := ''
    Local cUsado      := ''
    Local lCampo      := .f.
    Private cArquivo  := ''
	
    cCampo := 'E1_NRDOC'  
    cUsado := GetSX3Cache('E1_NRDOC','X3_USADO')

    If !X3USO(cUsado)
        Alert('O campo E1_NRDOC deve estar configurado como (Usado) no dicionario de dados.')
        lCampo := .t.
    EndIf 
	
    FWRestArea(aArea)
    If lCampo
        Return
    EndIf 

    PERGUNTE("IMPTITRECE",.T.)

    MV_PA1    := MV_PAR01
    MV_PA2    := MV_PAR02
    MV_PA3    := MV_PAR03
    MV_PA4    := MV_PAR04
    MV_PA5    := MV_PAR05
    MV_PA6    := MV_PAR06
    cArquivo   := alltrim(MV_PAR07)
    
    If ! Empty(cArquivo)
        If File(cArquivo) .And. Upper(SubStr(cArquivo, RAt('.', cArquivo) + 1, 3)) == 'CSV'
            Processa({|| ProcArq(cArquivo) }, "Importando...")
        Else
            MsgStop("Arquivo e/ou extensão inválida!", "Atenção")
        EndIf
    EndIf
    
Return


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

Static Function ProcArq(cArquivo)

    fImporta(cArquivo)     

Return

Static Function fImporta(cArquivo)
    
    Local aArea      := GetArea()
    Local nTotLinhas := 0
    Local cLinAtu    := ""
    Local nLinhaAtu  := 0
    Local aLinha     := {}
    Local oArquivo
    Local aLinhas
    Local aTitulos   := {}
    Private cDirLog    := GetTempPath() + "x_importacao\"
    Private cLog       := ""
    
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

        Else
            MsgStop("Arquivo não tem conteúdo!", "Atenção")
        EndIf

        oArquivo:Close()
    Else
        MsgStop("Arquivo não pode ser aberto!", "Atenção")
    EndIf
    
    RestArea(aArea)

    If len(aTitulos) > 0 
        fPopula(aTitulos)
    EndIf
    
Return


Static Function fPopula(aTitulos)
    Local nTotal    := 0
    Local nAtual    := 0
    Local cQry      := ''
	Local cNumero   := ''
	Local nY        := 0 
    Local cCliRa    := ''
    Local cLojRA    := ''
    
    aTitArq := aTitulos
    MV_PA1 := PadR(MV_PA1,TamSX3("E1_PREFIXO")[1])
    MV_PA2 := PadR(MV_PA2,TamSX3("E1_NUM")[1]) 
    MV_PA3 := PadR(MV_PA3,TamSX3("E1_PARCELA")[1]) 
    MV_PA4 := PadR(MV_PA4,TamSX3("E1_TIPO")[1])

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
    If SE1->(dbseek(xFilial('SE1')+MV_PA1+MV_PA2+MV_PA3+MV_PA4))
        cCliRa := SE1->E1_CLIENTE
        cLojRA  := SE1->E1_LOJA
    EndIf   
    SE1->(DbCloseArea())
    nExist := 0  
    cQry := "select E1_FILIAL,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO,E1_NATUREZ,E1_PORTADO,E1_CLIENTE,E1_LOJA "
    cQry += ",E1_EMISSAO,E1_VENCTO,E1_VENCREA,E1_VALOR,'CONTRATO' "
	cQry += "from "+RetSqlName('SE1') + " SE1 " 
	cQry += "where E1_FILIAL  =  '"+ xFilial('SE1') +"' " 
	//cQry += "and E1_CLIENTE = '" + cCliRa + "'  "
    //cQry += "and E1_LOJA = '" + cLojRA + "'  "
	cQry += "and E1_EMISSAO >= '" + Dtos(MV_PA5) + "' and E1_EMISSAO <= '" + Dtos(MV_PA6) + "'
	//cQry += "and E1_NUM in (" + cNumero + ") "
    cQry += "and E1_NRDOC in (" + cNumero + ") "
    cQry += "and D_E_L_E_T_ =  ' ' "
    cQry += "order by E1_NUM "

    cQry := ChangeQuery(cQry)
    TCQuery cQry New Alias "cQry"
  
    cQry->(DbGoTop())
    While !cQry->(Eof())
        nAtual++
        IncProc('Analisando registro ' + cValToChar(nAtual) + ' de ' + cValToChar(nTotal) + '...')
        nExist++
        ESTORCMP(cQry->E1_NUM,cQry->E1_VALOR,cQry->E1_FILIAL,cQry->E1_CLIENTE,cQry->E1_LOJA,cQry->E1_PREFIXO,cQry->E1_PARCELA,cQry->E1_TIPO)

    cQry->(DbSkip())
    EndDo
    cQry->(DbCloseArea())
    
Return    



Static Function ESTORCMP(cNUM,cVALOR,cFILIAL,cCLIENTE,cLOJA,cPREFIXO,cPARCELA,cTIPO)
 
    Local cChaveTit := ""
    Local cChaveSE5 := ""
    Local cXPrefixo  := PadR(cPrefixo,TamSX3("E1_PREFIXO")[1])
    Local cXNUM      := PadR(cNUM,TamSX3("E1_NUM")[1])
    Local cXParcela  := PadR(cParcela,TamSX3("E1_PARCELA")[1]) 
    Local cXTipo     := PadR(cTipo,TamSX3("E1_TIPO")[1])
    Local cXCliente  := PadR(cCLIENTE,TamSX3("E1_CLIENTE")[1])
    Local cXLoja     := PadR(cLOJA,TamSX3("E1_LOJA")[1])
    Local aSE1      := {}
    Local cData     := dtos(ddatabase)
    Local cE5TpDoc  := 'CP'
    Local aEstorno  := {}
    Local cSeq      := ""
    Local cIdComp   := ""
    Local oMovements := Nil
 
    Begin Transaction
 
    cChaveTit := FWxFilial("SE1") + cXCLIENTE + cXLOJA + cXPREFIXO + cXNUM + cXPARCELA + cXTIPO
    SE1->( DbSetOrder( 2 ) ) //E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
    If SE1->( MsSeek( cChaveTit ) )
 
        aSE1 := { SE1->( Recno() ) }
        cChaveSE5 := FWxFilial("SE5") + cE5TpDoc + cXPREFIXO + cXNUM + cXPARCELA + cXTIPO + cData + cCliente + cLoja + SE1->E1_SEQSE5
        SE5->( DbSetOrder( 2 ) ) //E5_FILIAL+E5_TIPODOC+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+DtoS(E5_DATA)+E5_CLIFOR+E5_LOJA+E5_SEQ
        If SE5->( MsSeek( cChaveSE5 ) )
 
            If SE5->E5_MOTBX == "CMP"
 
                //ESTORNO
                If FindClass('totvs.protheus.backoffice.fin.movements.Movements') .And. Len(aSE1) > 0
                    oMovements  := totvs.protheus.backoffice.fin.movements.Movements():New()
                    cIdComp := oMovements:getIdComp(aSE1[1], "R", SE5->E5_SEQ)
                    oMovements:clear()
                EndIf
                If !Empty(cIdComp)
                    //Modelo recomendado para o estorno (via FK1_IDCOMP)
                    aAdd(aEstorno, {"", cSeq, cIdComp})
                Else
                    //Modelo antigo de estorno (via E5_DOCUMEN)
                    aAdd(aEstorno, {{SE5->E5_DOCUMEN},SE5->E5_SEQ})// VALIDAR SE O CAMPO ESTÁ SENDO PREENCHIDO CARGLASS
                EndIf
 
                //Cancela a compensacao
                If MaIntBxCR( 3 , aSE1,,,, {.T.,.F.,.F.,.F.,.F.,.F.},, aEstorno )
                    //MsgInfo( "A compensação foi estornada com sucesso." )
                Else
                   // Help("XAFCMPAD",1,"HELP","XAFCMPAD","Não foi possível realizar o estorno da compensacao",1,0)
                    DisarmTransaction()
                EndIf
            EndIf
 
        //Else
        //    MsgAlert( "Não foi possível encontrar o registro de SE5 a ser estornado." )
        Endif
    EndIf
 
    End Transaction
 
    aSize ( aSE1, 0 )
    aSE1 := Nil
    aSize ( aEstorno, 0 )
    aEstorno := Nil
 
Return Nil
