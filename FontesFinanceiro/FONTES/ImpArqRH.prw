#include 'protheus.ch'
#include "rwmake.ch"
#Include 'Totvs.ch'
#Include "TopConn.ch"
#INCLUDE "TBICONN.CH"
#Include "FWMVCDef.ch"
#INCLUDE "RPTDEF.CH"

/*---------------------------------------------------------------------*
 | Func:  LerArquivo                                                   |
 | Autor: Fabio José Batista                                           |
 | Data:  08/10/2025                                                   |
 | Desc:  Chamada função para chamada processa                         |
 *---------------------------------------------------------------------*/
User Function LerArquivo()
    
    If MsgYesNo("Deseja importar titulos RH", "Confirma?")
        Processa({|| LerArquivos() }, "Lendo Arquivo...")
    EndIf     

Return

/*---------------------------------------------------------------------*
 | Func:  LerArquivos                                                  |
 | Autor: Fabio José Batista                                           |
 | Data:  08/10/2025                                                   |
 | Desc:  Chamada função para leitura de arquivos                      |
 *---------------------------------------------------------------------*/
Static Function LerArquivos()
    
    Local cPasta     := "\envio\processar\"            
    Local aArquivos  := Directory(cPasta + "*.TXT")
    Local aDados     := {}                      
    Local aArea      := GetArea()
    Local nI, cArq, oArq, cLinha, aCampos
    
    For nI := 1 To Len(aArquivos)
        cArq := cPasta + aArquivos[nI][1]
        ConOut("Lendo arquivo: " + cArq)
        oArq := FWFileReader():New(cArq)

        If oArq:Open()
            While oArq:HasLine()
                cLinha := AllTrim(oArq:GetLine())

                If !Empty(cLinha)
                    aCampos := StrTokArr(cLinha, ";")
                    AAdd(aCampos, cArq)
                    AAdd(aDados, aCampos)
                EndIf
            EndDo
                       
            oArq:Close()
        Else
            Alert("Erro ao abrir o arquivo: " + cArq)
        EndIf
    Next nI

    If Len(aDados) > 0
        Processa({|| GeraSE2(aDados) }, " ")
    EndIf

RestArea(aArea)

Return
/*---------------------------------------------------------------------*
 | Func:  GeraSE2                                                      |
 | Autor: Fabio José Batista                                           |
 | Data:  08/10/2025                                                   |
 | Desc:  Gera titulo conforme arquivo disponibilizado                 |
 *---------------------------------------------------------------------*/
Static Function GeraSE2(aDados)

    Local aArea            := GetArea()
    Local nY               := 0
    Local cPastaFin        := "\envio\processados\" 
    Local cErro            := "\envio\erro\" 
    Local nPos             := 0
    Local cResult          := ''  
    Local lError           := .F. 
    Private cMsgExec       := ''
    PRIVATE lMsErroAuto    := .F.
	Private lMsHelpAuto	   := .T. 
	Private lAutoErrNoFile := .T.

    ProcRegua(len(aDados))
    For nY := 1 to len(aDados)
        IncProc()
        //cNum     := GetSXENum("SE2", "E2_NUM")
        cNum     := NumSE2()
        cNum     := Soma1(cNum)
        dEmissa  := ctod(SubStr(aDados[nY][7],1,2) + "/" + SubStr(aDados[nY][7],3,2) + "/" + SubStr(aDados[nY][7],5,4))
        dVencto  := ctod(SubStr(aDados[nY][8],1,2) + "/" + SubStr(aDados[nY][8],3,2) + "/" + SubStr(aDados[nY][8],5,4))
        dVenctoR := ctod(SubStr(aDados[nY][9],1,2) + "/" + SubStr(aDados[nY][9],3,2) + "/" + SubStr(aDados[nY][9],5,4))
    
        aArray := { { "E2_FILIAL"   , FWxFilial("SE2")           , NIL },;
                    { "E2_PREFIXO"  , aDados[nY][1]              , NIL },;
                    { "E2_NUM"      , cNum                       , NIL },;
                    { "E2_TIPO"     , aDados[nY][3]              , NIL },;
                    { "E2_NATUREZ"  , aDados[nY][4]              , NIL },;
                    { "E2_FORNECE"  , aDados[nY][5]              , NIL },;
                    { "E2_LOJA"     , aDados[nY][6]              , NIL },;
                    { "E2_EMISSAO"  , dEmissa                    , NIL },;
                    { "E2_VENCTO"   , dVencto                    , NIL },;
                    { "E2_VENCREA"  , dVenctoR                   , NIL },;
                    { "E2_VALOR"    , Val(aDados[nY][10])        , NIL },;
                    { "E2_MOEDA"    , Val(aDados[nY][12])        , NIL },;
                    { "E2_CONTAD"   , aDados[nY][13]             , NIL },;
                    { "E2_CCUSTO"   , aDados[nY][14]             , NIL },;                    
                    { "E2_HIST   "  , alltrim(aDados[nY][11])    , NIL }}
   
        MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aArray,, 3)  // 3 - Inclusao, 4 - Alteracao, 5 - Exclusao
        
        If lMsErroAuto
            //aLog := GetAutoGRLog()
		    //Aeval(aLog,{|c|cMsgExec+=c+CRLF})
            lError := .T.
        Else
            nPos := At("processar\", aDados[nY][15])
            If nPos > 0
                cResult := SubStr(aDados[nY][15], nPos + Len("processar\"))
            EndIf     
            If __CopyFile(aDados[nY][15], cPastaFin+cResult)
                If FErase(aDados[nY][15]) == 0
                    //FWAlertSuccess("Arquivo: "+aDados[nY][15], "Atenção")
                    ConOut("Arquivo: "+aDados[nY][15], "Atenção")
                Else
                    //FWAlertError("Houve uma falha na exclusão do arquivo, erro #" + cValToChar(FError()) + ' - ' + cArq, "Teste FErase")
                    ConOut("Houve uma falha na exclusão do arquivo, erro #" + cValToChar(FError()) + ' - ' + cArq, "Teste FErase")
                EndIf
            Else
                //Alert('Não foi possivel copiar o arquivo' + aDados[nY][15])
                ConOut('Não foi possivel copiar o arquivo' + aDados[nY][15])
            EndIf     
        Endif

        If lError
            nPos := At("processar\", aDados[nY][15])
            If nPos > 0
                cResult := SubStr(aDados[nY][15], nPos + Len("processar\"))
            EndIf     
            If __CopyFile(aDados[nY][15], cErro+cResult)
                FErase(aDados[nY][15])
                lError := .f.
            EndIf 
        EndIf 

    Next nY
   
	
  RestArea(aArea)

Return



/*/{Protheus.doc} NumSE2
Valida o proximo numero sequencial na tabela SE2
@since 
@version 1.0
@type function
@Return cNum
*/
Static Function NumSE2()
	Local cQry   := ''
	Local cNum   := ''
	Local aArea  := GetArea()
	
	cQry := "SELECT MAX(E2_NUM) AS E2_NUM "
	cQry += "from "+RetSqlName('SE2') + " SE2 " "
	cQry += "where E2_TIPO = 'NF' and E2_PREFIXO = 'RH' "
 	cQry += "and E2_FILIAL =  '"+ xFilial('SE2') +"' " '
    cQry += "and D_E_L_E_T_ =  ' ' "
	
	cQry := ChangeQuery(cQry)
    TCQuery cQry New Alias "cQry"
  
    cQry->(DbGoTop())
    While !cQry->(Eof())
    	cNum := cQry->(E2_NUM)
        cQry->(DbSkip())
    EndDo
    
    cQry->(DbCloseArea())

    RestArea(aArea)

Return cNum
