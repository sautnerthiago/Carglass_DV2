#include 'parmtype.ch'
#Include "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#include 'tbiconn.ch'
#INCLUDE "TOTVS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "RESTFUL.CH"
#INCLUDE "FWAdapterEAI.ch"


class LIBGLASS

	//cria objeto
    method new() constructor 	

    //method consultaINCEst(cToken, cIncEst)
	method GRAVALOGMURO(cJson, cMensRet, cCodRotin, cNomRti)
    method ATUSA1(aDads, _fili, _cnpj)
    method ATUSA2(aDads, _fili, _cnpj)
    method temClient(_fili, _cnpj)
    method temFornec(_fili, _cnpj)

    method temProd(_fili, _cod)
    method temTES(_fili, _cod)
    method temCndpg(_fili, _cod)
    
    method pedVendas(_fili, aCab, aItens, nOpc, cDoc)
    method pedCompra(_fili, aCab, aItens, nOpc, cDoc)
    method SCCompras(_fili, aCab, aItens, nOpc, cDoc)

endclass

method new() class LIBGLASS
   //::cToken := ""
return

/*
METHOD consultaINCEst(cToken, cIncEst) CLASS LIBGLASS
    Local cRet := ""
    Local cUrl := "https://www.sintegraws.com.br/api/v1/execute-api.php?token="+cToken+"&cnpj="+cIncEst+"&plugin=ST"
    Local aGetTok := {}
    Local cHtmlPage
     
    //Executa uma requisição através do HttpGet
    cHtmlPage := HttpGet(cUrl)
     
    //Quebrando a string em um array e pegando a primeira posição
    aGetTok := StrTokArr( cHtmlPage, ";" )

Return cRet
*/

Method GRAVALOGMURO( cJson, cMensRet, cCodRotin, cNomRti ) class LIBGLASS
    Local lRet      := .T.
    Local cCodUsr   := RetCodUsr()
    Local cNomUsr   := UsrRetName(cCodUsr)
    Local nTmbObs   := 250 //TamSX3("Z1_JSON")[1]

    Begin transaction
        RecLock("SZ1",.T.)
        SZ1->Z1_FILIAL      := xFilial("SZ1")
        SZ1->Z1_ID          := Dtos(dDatabase) + Substr(time(),1,2) + Substr(time(),4,2) + Substr(time(),7,2)
        SZ1->Z1_ROTINA      := cCodRotin
        SZ1->Z1_NOMROTI     := cNomRti
        SZ1->Z1_DATAINC     := dDatabase
        SZ1->Z1_HORAINC     := Substr(time(),1,5)
        MSMM(, nTmbObs, , cJson, 1, , , "SZ1", "Z1_JSON") //cJson
        SZ1->Z1_USUARIO     := cNomUsr
        SZ1->Z1_COMPUTA     := GetComputerName()
        SZ1->Z1_STATUS      := "1"
        MSMM(, nTmbObs, , cMensRet, 1, , , "SZ1", "Z1_MESERRO") //SZ1->Z1_MESERRO     := cMensRet
        SZ1->( MsUnlock() )
    END transaction

Return lRet


method temClient(_fili, _cnpj) class LIBGLASS
    Local lRet := .T.

    cQuery := " SELECT A1_FILIAL, A1_COD, A1_LOJA, A1_NOME, A1_NREDUZ, A1_CGC, A1_END "
	cQuery += " FROM "+RetSQLName("SA1") + " AS SA1 WITH (NOLOCK) "
	cQuery += " WHERE A1_FILIAL = '" + _fili + "' AND SA1.A1_CGC = '"+_cnpj+"' "
	cQuery += " AND SA1.D_E_L_E_T_ = '' "
	cAlSA1:= CriaTrab(Nil,.F.)
	DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSA1, .F., .T.)    

	If (cAlSA1)->(Eof())
        lRet := .F. 
	Endif
    (cAlSA1)->(dbclosearea())

Return lRet

method temFornec(_fili, _cnpj) class LIBGLASS
    Local lRet := .T.

    cQuery := " SELECT A2_FILIAL, A2_COD, A2_LOJA, A2_NOME, A2_NREDUZ, A2_CGC, A2_END "
	cQuery += " FROM "+RetSQLName("SA2") + " AS SA2 WITH (NOLOCK) "
	cQuery += " WHERE A2_FILIAL = '" + _fili + "' AND SA2.A2_CGC = '"+_cnpj+"' "
	cQuery += " AND SA2.D_E_L_E_T_ = '' AND SA2.A2_MSBLQL <> '1' "
	cAlSA2:= CriaTrab(Nil,.F.)
	DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSA2, .F., .T.)    

    (cAlSA2)->(DbGoTop())
	If (cAlSA2)->(Eof())
        lRet := .F. 
	Endif
    (cAlSA2)->(dbclosearea())

Return lRet


method ATUSA1(aDads, _fili, _cnpj) class LIBGLASS
    Local lRet := .F.
    Local X

    cQuery := "UPDATE "+ RetSQLName("SA1")+" SET "
        For X := 1 to Len(aDads)
            cQuery += aDads[X,1] + " = '"+aDads[X,2]+"' "
            if X < Len(aDads)
                cQuery += ','
            Endif
        Next
    cQuery += " WHERE A1_FILIAL = '"+_fili+"' AND "
    cQuery += " A1_CGC = '"+_cnpj+"'  "
    if TCSqlExec(cQuery) < 0
        lRet := .T.
        ConOut("Erro na gravação do Cliente: " + TCSQLError())
        //MsgStop("Erro na atualizacao do COD.BARRAS e/ou Linha Digitavel", "Atenção")
    else
        TcSqlExec("COMMIT")
    endif

Return lRet

method ATUSA2(aDads, _fili, _cnpj) class LIBGLASS
    Local lRet := .F.
    Local X

    cQuery := "UPDATE "+ RetSQLName("SA2")+" SET "
        For X := 1 to Len(aDads)
            cQuery += aDads[X,1] + " = '"+aDads[X,2]+"' "
            if X < Len(aDads)
                cQuery += ','
            Endif
        Next
    cQuery += " WHERE A2_FILIAL = '"+_fili+"' AND "
    cQuery += " A2_CGC = '"+_cnpj+"'  "
    if TCSqlExec(cQuery) < 0
        lRet := .T.
        ConOut("Erro na gravação do Fornecedor: " + TCSQLError())
        //MsgStop("Erro na atualizacao do COD.BARRAS e/ou Linha Digitavel", "Atenção")
    else
        TcSqlExec("COMMIT")
    endif

Return lRet


method temProd(_fili, _cod) class LIBGLASS
    Local lRet := .T.

    cQuery := " SELECT * "
	cQuery += " FROM "+RetSQLName("SB1") + " AS SB1 WITH (NOLOCK) "
	cQuery += " WHERE B1_FILIAL = '" + _fili + "' AND SB1.B1_COD = '"+_cod+"' "
	cQuery += " AND SB1.D_E_L_E_T_ = '' "
	cAlSB1:= CriaTrab(Nil,.F.)
	DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSB1, .F., .T.)    

	If (cAlSB1)->(Eof())
        lRet := .F. 
	Endif
    (cAlSB1)->(dbclosearea())

Return lRet

method temTES(_fili, _cod) class LIBGLASS
    Local lRet := .T.

    cQuery := " SELECT * "
	cQuery += " FROM "+RetSQLName("SF4") + " AS SF4 WITH (NOLOCK) "
	cQuery += " WHERE B1_FILIAL = '" + _fili + "' AND SF4.F4_CODIGO = '"+_cod+"' "
	cQuery += " AND SF4.D_E_L_E_T_ = '' "
	cAlSF4:= CriaTrab(Nil,.F.)
	DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSF4, .F., .T.)    

	If (cAlSF4)->(Eof())
        lRet := .F. 
	Endif
    (cAlSF4)->(dbclosearea())

Return lRet


method temCndpg(_fili, _cod) class LIBGLASS
    Local lRet := .T.

    cQuery := " SELECT * "
	cQuery += " FROM "+RetSQLName("SE4") + " AS SE4 WITH (NOLOCK) "
	cQuery += " WHERE B1_FILIAL = '" + _fili + "' AND SE4.E4_CODIGO = '"+_cod+"' "
	cQuery += " AND SE4.D_E_L_E_T_ = '' "
	cAlSE4:= CriaTrab(Nil,.F.)
	DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSE4, .F., .T.)    

	If (cAlSE4)->(Eof())
        lRet := .F. 
	Endif
    (cAlSE4)->(dbclosearea())

Return lRet


method pedVendas(_fili, aCab, aItens, nOpc, cDoc) class LIBGLASS
    Local nCount
    Local aRet := {}
    Local cLogErro := ""

    MSExecAuto({|a, b, c, d| MATA410(a, b, c, d)}, aCabec, aItens, nOpcX, .F.)
    
    If !lMsErroAuto
        ConOut("Incluido com sucesso! " + cDoc)
        aAdd(aRet, {"Incluido com sucesso! " + cDoc, .T.})
    Else
        ConOut("Erro na inclusao!")
        aErroAuto := GetAutoGRLog()
        For nCount := 1 To Len(aErroAuto)
            cLogErro += StrTran(StrTran(aErroAuto[nCount], "<", ""), "-", "") + " "
            ConOut(cLogErro)
        Next nCount
        aAdd(aRet, {cLogErro, .F.})
    EndIf

Return aRet

method pedCompra(_fili, aCab, aItens, nOpc, cDoc) class LIBGLASS
    Local nCount
    Local aRet := {}
    Local cLogErro := ""

    MsExecAuto({|x, y, z, d| MATA120(x, y, z, d)}, aCabPC, aItensPC, nOpcX, 1  )
    
    If !lMsErroAuto
        ConOut("Incluido com sucesso! " + cDoc)
        aAdd(aRet, {"Incluido com sucesso! " + cDoc, .T.})
    Else
        ConOut("Erro na inclusao!")
        aErroAuto := GetAutoGRLog()
        For nCount := 1 To Len(aErroAuto)
            cLogErro += StrTran(StrTran(aErroAuto[nCount], "<", ""), "-", "") + " "
            ConOut(cLogErro)
        Next nCount
        aAdd(aRet, {cLogErro, .F.})
    EndIf

Return aRet

method SCCompras(_fili, aCab, aItens, nOpc, cDoc) class LIBGLASS
    Local nCount
    Local aRet     := {}
    Local cLogErro := ""
    MSExecAuto({|x,y| mata110(x,y,nOpc)},aCab,aItens)
    
    If !lMsErroAuto
        ConOut("Incluido com sucesso! " + cDoc)
        aAdd(aRet, {"Incluido com sucesso! " + cDoc, .T.})
    Else
        ConOut("Erro na inclusao!")
        aErroAuto := GetAutoGRLog()
        For nCount := 1 To Len(aErroAuto)
            cLogErro += StrTran(StrTran(aErroAuto[nCount], "<", ""), "-", "") + " "
            ConOut(cLogErro)
        Next nCount
        aAdd(aRet, {cLogErro, .F.})
    EndIf

Return aRet
