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
    method pedCompra(aDados, nOpc)
    method SCCompras(_fili, aCab, aItens, nOpc, cDoc)

    METHOD CLieEst(_estad)
    METHOD CLieTipo(_Tipo)
    METHOD CLieDatas( dtIni, DtFin)

    METHOD FornEst(_estad)   //criar
    METHOD FornTipo(_Tipo)  //criar
    METHOD FornDatas( dtIni, DtFin) //criar
    
    method TemEstado(_estad)

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
    //Local nTmbObs   := TamSX3("Z1_JSON")[1]

    Begin transaction
        RecLock("SZ1",.T.)
        SZ1->Z1_FILIAL      := xFilial("SZ1")
        SZ1->Z1_ID          := Dtos(dDatabase) + Substr(time(),1,2) + Substr(time(),4,2) + Substr(time(),7,2)
        SZ1->Z1_ROTINA      := cCodRotin
        SZ1->Z1_NOMROTI     := cNomRti
        SZ1->Z1_DATAINC     := dDatabase
        SZ1->Z1_HORAINC     := Substr(time(),1,5)
        SZ1->Z1_JSON        := cJson
        //MSMM(, nTmbObs, , cJson, 1, , , "SZ1", "Z1_JSON") //cJson
        SZ1->Z1_USUARIO     := cNomUsr
        SZ1->Z1_COMPUTA     := GetComputerName()
        SZ1->Z1_STATUS      := "1"
        SZ1->Z1_MESERRO     := cMensRet
        //MSMM(, nTmbObs, , cMensRet, 1, , , "SZ1", "Z1_MESERRO") //SZ1->Z1_MESERRO     := cMensRet
        SZ1->( DbCommit() )
        SZ1->( MsUnlock() )

        //MSMM(SZ1->Z1_JSON   ,,, cJson,1,,,"SZ1","Z1_JSON")  //Grava o campo MEMO
        //MSMM(SZ1->Z1_MESERRO,,, cMensRet,1,,,"SZ1","Z1_MESERRO")  //Grava o campo MEMO

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

method pedCompra(aCab, aItem, nOpc) class LIBGLASS
    Local nCount
    Local cLogErro  := ""
    Local aRet      := {}

    MSExecAuto({|v,x,y,z| MATA120(v,x,y,z)},1, aCab, aItem, nOpc)
    
    If !lMsErroAuto
        ConOut("Incluido com sucesso! " )
        aAdd(aRet, {"Incluido com sucesso! " , .T.})
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

method TemEstado(_estad) class LIBGLASS
    Local lRet := .F.
    
    aEstd := {'AC', 'AL', 'AP', 'AM', 'BA', 'CE', 'DF', 'ES', 'GO', 'MA', 'MT', 'MS', 'MG', 'PA', 'PB', 'PR', 'PE', 'PI', 'RJ', 'RN', 'RS', 'RO', 'RR', 'SC', 'SP', 'SE', 'TO' }
    If ASCAN(aEstd, _estad) == 0
        lRet := .T.
    EndIF

Return lRet

method CLieEst(_estad) class LIBGLASS
    Local aCliTmp := {}

    cQuery := " SELECT * "
	cQuery += " FROM "+RetSQLName("SA1") + " AS SA1 WITH (NOLOCK) "
	cQuery += " WHERE SA1.A1_EST = '"+_estad+"' "
	cQuery += " AND SA1.D_E_L_E_T_ = '' "
	cAlSA1 := CriaTrab(Nil,.F.)
	DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSA1, .F., .T.)    

    nItem := 0
	DO WHILE !(cAlSA1)->(Eof())
        aAdd( aCliTmp , JsonObject():New() )
        nItem++
        aCliTmp[nItem]['FILIAL'] 		:= (cAlSA1)->A1_FILIAL
        aCliTmp[nItem]['CODIGO']		:= (cAlSA1)->A1_COD
        aCliTmp[nItem]['LOJA'] 			:= (cAlSA1)->A1_LOJA
        aCliTmp[nItem]['NOME'] 			:= Rtrim( (cAlSA1)->A1_NOME)
        aCliTmp[nItem]['NREDUZ'] 		:= Rtrim( (cAlSA1)->A1_NREDUZ )
        aCliTmp[nItem]['BAIRRO'] 		:= Rtrim( (cAlSA1)->A1_BAIRRO )
        aCliTmp[nItem]['EMAIL'] 		:= Rtrim( (cAlSA1)->A1_EMAIL  )
        aCliTmp[nItem]['CEP']			:= Rtrim( (cAlSA1)->A1_CEP    )
        aCliTmp[nItem]['CNPJ'] 			:= Rtrim( (cAlSA1)->A1_CGC    )
        aCliTmp[nItem]['ESTADO']		:= Rtrim( (cAlSA1)->A1_ESTADO )
        aCliTmp[nItem]['COD_MUN']		:= Rtrim( (cAlSA1)->A1_COD_MUN)
        aCliTmp[nItem]['COND'] 			:= Rtrim( (cAlSA1)->A1_COND   )
        aCliTmp[nItem]['DDD'] 			:= Rtrim( (cAlSA1)->A1_DDD    )
        aCliTmp[nItem]['DTCAD'] 		:= (cAlSA1)->A1_DTCAD
        aCliTmp[nItem]['END']			:= Rtrim( (cAlSA1)->A1_END    )
        aCliTmp[nItem]['INSCR'] 		:= Rtrim( (cAlSA1)->A1_INSCR  )
        aCliTmp[nItem]['MUNCIPIO'] 		:= Rtrim( (cAlSA1)->A1_MUN    )
        aCliTmp[nItem]['NATUREZ']		:= Rtrim( (cAlSA1)->A1_NATUREZ)
        aCliTmp[nItem]['PESSOA'] 		:= Rtrim( (cAlSA1)->A1_TPESSOA)
        aCliTmp[nItem]['TIPCLIFOR'] 	:= Rtrim( (cAlSA1)->A1_TIPCLI )
        aCliTmp[nItem]['FONE'] 			:= Rtrim( (cAlSA1)->A1_TEL    )
        aCliTmp[nItem]['TRANSP'] 		:= Rtrim( (cAlSA1)->A1_TRANSP )
        aCliTmp[nItem]['PAIS'] 			:= Rtrim( (cAlSA1)->A1_PAIS   )
        aCliTmp[nItem]['BLOQUEADO']		:= IF((cAlSA1)->A1_MSBLQL == "2", "NAO", "SIM")
        aCliTmp[nItem]['MOVEL']			:= (cAlSA1)->A1_ZMOBILE
        aCliTmp[nItem]['TIPOVEICULO']	:= (cAlSA1)->A1_ZTPVEIC
        aCliTmp[nItem]['DTCRIACAO']		:= (cAlSA1)->A1_ZDTCRIA
        aCliTmp[nItem]['ATIVO']			:= (cAlSA1)->A1_ZATIVO
        aCliTmp[nItem]['PAGAMENTOADT']	:= (cAlSA1)->A1_ZPGTADT
        aCliTmp[nItem]['REVENDEAFIAL']	:= (cAlSA1)->A1_ZREVAFI
        aCliTmp[nItem]['AFILIADOCONV']	:= (cAlSA1)->A1_ZAFICON
        aCliTmp[nItem]['TIPOAFILIADO']	:= (cAlSA1)->A1_ZTPAFIL
        (cAlSA1)->(DBSKIP())
        LOOP
	ENDDO
    (cAlSA1)->(dbclosearea())

Return aCliTmp

method CLieTipo(_Tipo) class LIBGLASS
    Local aCliTmp   := {}

    cQuery := " SELECT * "
    cQuery += " FROM "+RetSQLName("SA1") + " AS SA1 WITH (NOLOCK) "
    cQuery += " WHERE SA1.A1_ZTPAFIL = '"+_Tipo+"' "
	cQuery += " AND SA1.D_E_L_E_T_ = '' "
	cAlSA1:= CriaTrab(Nil,.F.)
	DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSA1, .F., .T.)    

    nItem := 0
	DO WHILE !(cAlSA1)->(Eof())
        aAdd( aCliTmp , JsonObject():New() )
        nItem++
        aCliTmp[nItem]['FILIAL'] 		:= (cAlSA1)->A1_FILIAL
        aCliTmp[nItem]['CODIGO']		:= (cAlSA1)->A1_COD
        aCliTmp[nItem]['LOJA'] 			:= (cAlSA1)->A1_LOJA
        aCliTmp[nItem]['NOME'] 			:= Rtrim( (cAlSA1)->A1_NOME)
        aCliTmp[nItem]['NREDUZ'] 		:= Rtrim( (cAlSA1)->A1_NREDUZ )
        aCliTmp[nItem]['BAIRRO'] 		:= Rtrim( (cAlSA1)->A1_BAIRRO )
        aCliTmp[nItem]['EMAIL'] 		:= Rtrim( (cAlSA1)->A1_EMAIL  )
        aCliTmp[nItem]['CEP']			:= Rtrim( (cAlSA1)->A1_CEP    )
        aCliTmp[nItem]['CNPJ'] 			:= Rtrim( (cAlSA1)->A1_CGC    )
        aCliTmp[nItem]['ESTADO']		:= Rtrim( (cAlSA1)->A1_ESTADO )
        aCliTmp[nItem]['COD_MUN']		:= Rtrim( (cAlSA1)->A1_COD_MUN)
        aCliTmp[nItem]['COND'] 			:= Rtrim( (cAlSA1)->A1_COND   )
        aCliTmp[nItem]['DDD'] 			:= Rtrim( (cAlSA1)->A1_DDD    )
        aCliTmp[nItem]['DTCAD'] 		:= (cAlSA1)->A1_DTCAD
        aCliTmp[nItem]['END']			:= Rtrim( (cAlSA1)->A1_END    )
        aCliTmp[nItem]['INSCR'] 		:= Rtrim( (cAlSA1)->A1_INSCR  )
        aCliTmp[nItem]['MUNCIPIO'] 		:= Rtrim( (cAlSA1)->A1_MUN    )
        aCliTmp[nItem]['NATUREZ']		:= Rtrim( (cAlSA1)->A1_NATUREZ)
        aCliTmp[nItem]['PESSOA'] 		:= Rtrim( (cAlSA1)->A1_TPESSOA)
        aCliTmp[nItem]['TIPCLIFOR'] 	:= Rtrim( (cAlSA1)->A1_TIPCLI )
        aCliTmp[nItem]['FONE'] 			:= Rtrim( (cAlSA1)->A1_TEL    )
        aCliTmp[nItem]['TRANSP'] 		:= Rtrim( (cAlSA1)->A1_TRANSP )
        aCliTmp[nItem]['PAIS'] 			:= Rtrim( (cAlSA1)->A1_PAIS   )
        aCliTmp[nItem]['BLOQUEADO']		:= IF((cAlSA1)->A1_MSBLQL == "2", "NAO", "SIM")
        aCliTmp[nItem]['MOVEL']			:= (cAlSA1)->A1_ZMOBILE
        aCliTmp[nItem]['TIPOVEICULO']	:= (cAlSA1)->A1_ZTPVEIC
        aCliTmp[nItem]['DTCRIACAO']		:= (cAlSA1)->A1_ZDTCRIA
        aCliTmp[nItem]['ATIVO']			:= (cAlSA1)->A1_ZATIVO
        aCliTmp[nItem]['PAGAMENTOADT']	:= (cAlSA1)->A1_ZPGTADT
        aCliTmp[nItem]['REVENDEAFIAL']	:= (cAlSA1)->A1_ZREVAFI
        aCliTmp[nItem]['AFILIADOCONV']	:= (cAlSA1)->A1_ZAFICON
        aCliTmp[nItem]['TIPOAFILIADO']	:= (cAlSA1)->A1_ZTPAFIL
        (cAlSA1)->(DBSKIP())
        LOOP
	EndDo
    (cAlSA1)->(dbclosearea())

Return aCliTmp

method CLieDatas( dtIni, DtFin) class LIBGLASS
    Local aCliTmp := {}

    cQuery := " SELECT * "
	cQuery += " FROM "+RetSQLName("SA1") + " AS SA1 WITH (NOLOCK) "
	cQuery += " WHERE SA1.A1_ZDTCRIA BETWEEN '"+dtIni+"' AND '"+DtFin+"' "
	cQuery += " AND SA1.D_E_L_E_T_ = '' "
	cAlSA1:= CriaTrab(Nil,.F.)
	DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSA1, .F., .T.)    

    nItem := 0
	DO WHILE !(cAlSA1)->(Eof())
        aAdd( aCliTmp , JsonObject():New() )
        nItem++
        aCliTmp[nItem]['FILIAL'] 		:= (cAlSA1)->A1_FILIAL
        aCliTmp[nItem]['CODIGO']		:= (cAlSA1)->A1_COD
        aCliTmp[nItem]['LOJA'] 			:= (cAlSA1)->A1_LOJA
        aCliTmp[nItem]['NOME'] 			:= Rtrim( (cAlSA1)->A1_NOME)
        aCliTmp[nItem]['NREDUZ'] 		:= Rtrim( (cAlSA1)->A1_NREDUZ )
        aCliTmp[nItem]['BAIRRO'] 		:= Rtrim( (cAlSA1)->A1_BAIRRO )
        aCliTmp[nItem]['EMAIL'] 		:= Rtrim( (cAlSA1)->A1_EMAIL  )
        aCliTmp[nItem]['CEP']			:= Rtrim( (cAlSA1)->A1_CEP    )
        aCliTmp[nItem]['CNPJ'] 			:= Rtrim( (cAlSA1)->A1_CGC    )
        aCliTmp[nItem]['ESTADO']		:= Rtrim( (cAlSA1)->A1_ESTADO )
        aCliTmp[nItem]['COD_MUN']		:= Rtrim( (cAlSA1)->A1_COD_MUN)
        aCliTmp[nItem]['COND'] 			:= Rtrim( (cAlSA1)->A1_COND   )
        aCliTmp[nItem]['DDD'] 			:= Rtrim( (cAlSA1)->A1_DDD    )
        aCliTmp[nItem]['DTCAD'] 		:= (cAlSA1)->A1_DTCAD
        aCliTmp[nItem]['END']			:= Rtrim( (cAlSA1)->A1_END    )
        aCliTmp[nItem]['INSCR'] 		:= Rtrim( (cAlSA1)->A1_INSCR  )
        aCliTmp[nItem]['MUNCIPIO'] 		:= Rtrim( (cAlSA1)->A1_MUN    )
        aCliTmp[nItem]['NATUREZ']		:= Rtrim( (cAlSA1)->A1_NATUREZ)
        aCliTmp[nItem]['PESSOA'] 		:= Rtrim( (cAlSA1)->A1_TPESSOA)
        aCliTmp[nItem]['TIPCLIFOR'] 	:= Rtrim( (cAlSA1)->A1_TIPCLI )
        aCliTmp[nItem]['FONE'] 			:= Rtrim( (cAlSA1)->A1_TEL    )
        aCliTmp[nItem]['TRANSP'] 		:= Rtrim( (cAlSA1)->A1_TRANSP )
        aCliTmp[nItem]['PAIS'] 			:= Rtrim( (cAlSA1)->A1_PAIS   )
        aCliTmp[nItem]['BLOQUEADO']		:= IF((cAlSA1)->A1_MSBLQL == "2", "NAO", "SIM")
        aCliTmp[nItem]['MOVEL']			:= (cAlSA1)->A1_ZMOBILE
        aCliTmp[nItem]['TIPOVEICULO']	:= (cAlSA1)->A1_ZTPVEIC
        aCliTmp[nItem]['DTCRIACAO']		:= (cAlSA1)->A1_ZDTCRIA
        aCliTmp[nItem]['ATIVO']			:= (cAlSA1)->A1_ZATIVO
        aCliTmp[nItem]['PAGAMENTOADT']	:= (cAlSA1)->A1_ZPGTADT
        aCliTmp[nItem]['REVENDEAFIAL']	:= (cAlSA1)->A1_ZREVAFI
        aCliTmp[nItem]['AFILIADOCONV']	:= (cAlSA1)->A1_ZAFICON
        aCliTmp[nItem]['TIPOAFILIADO']	:= (cAlSA1)->A1_ZTPAFIL
        (cAlSA1)->(DBSKIP())
        LOOP
	ENDDO
    (cAlSA1)->(dbclosearea())

Return aCliTmp

method FornEst(_estad) class LIBGLASS
    Local aFornTmp := {}

    cQuery := " SELECT * "
	cQuery += " FROM "+RetSQLName("SA2") + " AS SA2 WITH (NOLOCK) "
	cQuery += " WHERE SA2.A2_EST = '"+_estad+"' "
	cQuery += " AND SA2.D_E_L_E_T_ = '' "
	cAlSA2 := CriaTrab(Nil,.F.)
	DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSA2, .F., .T.)    

    nItem := 0
	DO WHILE !(cAlSA2)->(Eof())
        aAdd( aFornTmp , JsonObject():New() )
        nItem++
        aFornTmp[nItem]['FILIAL'] 		:= (cAlSA2)->A2_FILIAL
        aFornTmp[nItem]['CODIGO']		:= (cAlSA2)->A2_COD
        aFornTmp[nItem]['LOJA'] 		:= (cAlSA2)->A2_LOJA
        aFornTmp[nItem]['NOME'] 		:= Rtrim( (cAlSA2)->A2_NOME)
        aFornTmp[nItem]['NREDUZ'] 		:= Rtrim( (cAlSA2)->A2_NREDUZ )
        aFornTmp[nItem]['BAIRRO'] 		:= Rtrim( (cAlSA2)->A2_BAIRRO )
        aFornTmp[nItem]['EMAIL'] 		:= Rtrim( (cAlSA2)->A2_EMAIL  )
        aFornTmp[nItem]['CEP']			:= Rtrim( (cAlSA2)->A2_CEP    )
        aFornTmp[nItem]['CNPJ'] 		:= Rtrim( (cAlSA2)->A2_CGC    )
        aFornTmp[nItem]['ESTADO']		:= Rtrim( (cAlSA2)->A2_ESTADO )
        aFornTmp[nItem]['COD_MUN']		:= Rtrim( (cAlSA2)->A2_COD_MUN)
        aFornTmp[nItem]['COND'] 		:= Rtrim( (cAlSA2)->A2_COND   )
        aFornTmp[nItem]['DDD'] 			:= Rtrim( (cAlSA2)->A2_DDD    )
        aFornTmp[nItem]['END']			:= Rtrim( (cAlSA2)->A2_END    )
        aFornTmp[nItem]['INSCR'] 		:= Rtrim( (cAlSA2)->A2_INSCR  )
        aFornTmp[nItem]['MUNCIPIO'] 	:= Rtrim( (cAlSA2)->A2_MUN    )
        aFornTmp[nItem]['NATUREZ']		:= Rtrim( (cAlSA2)->A2_NATUREZ)
        aFornTmp[nItem]['TIPCLIFOR'] 	:= Rtrim( (cAlSA2)->A2_TIPO )
        aFornTmp[nItem]['FONE'] 		:= Rtrim( (cAlSA2)->A2_TEL    )
        aFornTmp[nItem]['TRANSP'] 		:= Rtrim( (cAlSA2)->A2_TRANSP )
        aFornTmp[nItem]['PAIS'] 		:= Rtrim( (cAlSA2)->A2_PAIS   )
        aFornTmp[nItem]['BLOQUEADO']	:= IF((cAlSA2)->A2_MSBLQL == "2", "NAO", "SIM")
        aFornTmp[nItem]['MOVEL']		:= (cAlSA2)->A2_ZMOBILE
        aFornTmp[nItem]['TIPOVEICULO']	:= (cAlSA2)->A2_ZTPVEIC
        aFornTmp[nItem]['DTCRIACAO']	:= (cAlSA2)->A2_ZDTCRIA
        aFornTmp[nItem]['ATIVO']		:= (cAlSA2)->A2_ZATIVO
        aFornTmp[nItem]['PAGAMENTOADT']	:= (cAlSA2)->A2_ZPGTADT
        aFornTmp[nItem]['REVENDEAFIAL']	:= (cAlSA2)->A2_ZREVAFI
        aFornTmp[nItem]['AFILIADOCONV']	:= (cAlSA2)->A2_ZAFICON
        aFornTmp[nItem]['TIPOAFILIADO']	:= (cAlSA2)->A2_ZTPAFIL
        (cAlSA2)->(DBSKIP())
        LOOP
	ENDDO
    (cAlSA2)->(Dbclosearea())

Return aFornTmp

method FornTipo(_Tipo) class LIBGLASS
    Local aFornTmp   := {}

    cQuery := " SELECT * "
    cQuery += " FROM "+RetSQLName("SA2") + " AS SA2 WITH (NOLOCK) "
    cQuery += " WHERE SA2.A2_ZTPAFIL = '"+_Tipo+"' "
	cQuery += " AND SA2.D_E_L_E_T_ = '' "
	cAlSA2:= CriaTrab(Nil,.F.)
	DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSA2, .F., .T.)    

    nItem := 0
	DO WHILE !(cAlSA2)->(Eof())
        aAdd( aFornTmp , JsonObject():New() )
        nItem++
        aFornTmp[nItem]['FILIAL'] 		:= (cAlSA2)->A2_FILIAL
        aFornTmp[nItem]['CODIGO']		:= (cAlSA2)->A2_COD
        aFornTmp[nItem]['LOJA'] 		:= (cAlSA2)->A2_LOJA
        aFornTmp[nItem]['NOME'] 		:= Rtrim( (cAlSA2)->A2_NOME)
        aFornTmp[nItem]['NREDUZ'] 		:= Rtrim( (cAlSA2)->A2_NREDUZ )
        aFornTmp[nItem]['BAIRRO'] 		:= Rtrim( (cAlSA2)->A2_BAIRRO )
        aFornTmp[nItem]['EMAIL'] 		:= Rtrim( (cAlSA2)->A2_EMAIL  )
        aFornTmp[nItem]['CEP']			:= Rtrim( (cAlSA2)->A2_CEP    )
        aFornTmp[nItem]['CNPJ'] 		:= Rtrim( (cAlSA2)->A2_CGC    )
        aFornTmp[nItem]['ESTADO']		:= Rtrim( (cAlSA2)->A2_ESTADO )
        aFornTmp[nItem]['COD_MUN']		:= Rtrim( (cAlSA2)->A2_COD_MUN)
        aFornTmp[nItem]['COND'] 		:= Rtrim( (cAlSA2)->A2_COND   )
        aFornTmp[nItem]['DDD'] 			:= Rtrim( (cAlSA2)->A2_DDD    )
        aFornTmp[nItem]['END']			:= Rtrim( (cAlSA2)->A2_END    )
        aFornTmp[nItem]['INSCR'] 		:= Rtrim( (cAlSA2)->A2_INSCR  )
        aFornTmp[nItem]['MUNCIPIO'] 	:= Rtrim( (cAlSA2)->A2_MUN    )
        aFornTmp[nItem]['NATUREZ']		:= Rtrim( (cAlSA2)->A2_NATUREZ)
        aFornTmp[nItem]['TIPCLIFOR'] 	:= Rtrim( (cAlSA2)->A2_TIPO )
        aFornTmp[nItem]['FONE'] 		:= Rtrim( (cAlSA2)->A2_TEL    )
        aFornTmp[nItem]['TRANSP'] 		:= Rtrim( (cAlSA2)->A2_TRANSP )
        aFornTmp[nItem]['PAIS'] 		:= Rtrim( (cAlSA2)->A2_PAIS   )
        aFornTmp[nItem]['BLOQUEADO']	:= IF((cAlSA2)->A2_MSBLQL == "2", "NAO", "SIM")
        aFornTmp[nItem]['MOVEL']		:= (cAlSA2)->A2_ZMOBILE
        aFornTmp[nItem]['TIPOVEICULO']	:= (cAlSA2)->A2_ZTPVEIC
        aFornTmp[nItem]['DTCRIACAO']	:= (cAlSA2)->A2_ZDTCRIA
        aFornTmp[nItem]['ATIVO']		:= (cAlSA2)->A2_ZATIVO
        aFornTmp[nItem]['PAGAMENTOADT']	:= (cAlSA2)->A2_ZPGTADT
        aFornTmp[nItem]['REVENDEAFIAL']	:= (cAlSA2)->A2_ZREVAFI
        aFornTmp[nItem]['AFILIADOCONV']	:= (cAlSA2)->A2_ZAFICON
        aFornTmp[nItem]['TIPOAFILIADO']	:= (cAlSA2)->A2_ZTPAFIL
        (cAlSA2)->(DBSKIP())
        LOOP
	EndDo
    (cAlSA2)->(dbclosearea())

Return aFornTmp

method FornDatas( dtIni, DtFin) class LIBGLASS
    Local aFornTmp := {}

    cQuery := " SELECT * "
	cQuery += " FROM "+RetSQLName("SA2") + " AS SA2 WITH (NOLOCK) "
	cQuery += " WHERE SA2.A2_ZDTCRIA BETWEEN '"+dtIni+"' AND '"+DtFin+"' "
	cQuery += " AND SA2.D_E_L_E_T_ = '' "
	cAlSA2:= CriaTrab(Nil,.F.)
	DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSA2, .F., .T.)    

    nItem := 0
	DO WHILE !(cAlSA2)->(Eof())
        aAdd( aFornTmp , JsonObject():New() )
        nItem++
        aFornTmp[nItem]['FILIAL'] 		:= (cAlSA2)->A2_FILIAL
        aFornTmp[nItem]['CODIGO']		:= (cAlSA2)->A2_COD
        aFornTmp[nItem]['LOJA'] 		:= (cAlSA2)->A2_LOJA
        aFornTmp[nItem]['NOME'] 		:= Rtrim( (cAlSA2)->A2_NOME)
        aFornTmp[nItem]['NREDUZ'] 		:= Rtrim( (cAlSA2)->A2_NREDUZ )
        aFornTmp[nItem]['BAIRRO'] 		:= Rtrim( (cAlSA2)->A2_BAIRRO )
        aFornTmp[nItem]['EMAIL'] 		:= Rtrim( (cAlSA2)->A2_EMAIL  )
        aFornTmp[nItem]['CEP']			:= Rtrim( (cAlSA2)->A2_CEP    )
        aFornTmp[nItem]['CNPJ'] 		:= Rtrim( (cAlSA2)->A2_CGC    )
        aFornTmp[nItem]['ESTADO']		:= Rtrim( (cAlSA2)->A2_ESTADO )
        aFornTmp[nItem]['COD_MUN']		:= Rtrim( (cAlSA2)->A2_COD_MUN)
        aFornTmp[nItem]['COND'] 		:= Rtrim( (cAlSA2)->A2_COND   )
        aFornTmp[nItem]['DDD'] 			:= Rtrim( (cAlSA2)->A2_DDD    )
        aFornTmp[nItem]['END']			:= Rtrim( (cAlSA2)->A2_END    )
        aFornTmp[nItem]['INSCR'] 		:= Rtrim( (cAlSA2)->A2_INSCR  )
        aFornTmp[nItem]['MUNCIPIO'] 	:= Rtrim( (cAlSA2)->A2_MUN    )
        aFornTmp[nItem]['NATUREZ']		:= Rtrim( (cAlSA2)->A2_NATUREZ)
        aFornTmp[nItem]['TIPCLIFOR'] 	:= Rtrim( (cAlSA2)->A2_TIPO )
        aFornTmp[nItem]['FONE'] 		:= Rtrim( (cAlSA2)->A2_TEL    )
        aFornTmp[nItem]['TRANSP'] 		:= Rtrim( (cAlSA2)->A2_TRANSP )
        aFornTmp[nItem]['PAIS'] 		:= Rtrim( (cAlSA2)->A2_PAIS   )
        aFornTmp[nItem]['BLOQUEADO']	:= IF((cAlSA2)->A2_MSBLQL == "2", "NAO", "SIM")
        aFornTmp[nItem]['MOVEL']		:= (cAlSA2)->A2_ZMOBILE
        aFornTmp[nItem]['TIPOVEICULO']	:= (cAlSA2)->A2_ZTPVEIC
        aFornTmp[nItem]['DTCRIACAO']	:= (cAlSA2)->A2_ZDTCRIA
        aFornTmp[nItem]['ATIVO']		:= (cAlSA2)->A2_ZATIVO
        aFornTmp[nItem]['PAGAMENTOADT']	:= (cAlSA2)->A2_ZPGTADT
        aFornTmp[nItem]['REVENDEAFIAL']	:= (cAlSA2)->A2_ZREVAFI
        aFornTmp[nItem]['AFILIADOCONV']	:= (cAlSA2)->A2_ZAFICON
        aFornTmp[nItem]['TIPOAFILIADO']	:= (cAlSA2)->A2_ZTPAFIL
        (cAlSA2)->(DBSKIP())
        LOOP
	ENDDO
    (cAlSA2)->(dbclosearea())

Return aFornTmp
