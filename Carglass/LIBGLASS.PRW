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
    method temCliCod(_fili, cod, loja)    
    method temFornec(_fili, _cnpj)
    method temForCod(_fili, cod, loja)    

    method temProd(_fili, _cod)
    method temTES(_fili, _cod)
    method temCndpg(_fili, _cod)
    
    method pedVendas(aCab, aItens, nOpc, cDoc)
    method pedCompra(aDados, nOpc)
    method SCCompras(_fili, aCab, aItens, nOpc, cDoc)

    METHOD CLieEst(_estad)
    METHOD CLieTipo(_Tipo)
    METHOD CLieDatas( dtIni, DtFin)

    METHOD FornEst(_estad)   //criar
    METHOD FornTipo(_Tipo)  //criar
    METHOD FornDatas( dtIni, DtFin) //criar
    
    method TemEstado(_estad)

    method ITENSPV(_FILIAL, _NUM, _CLIENTE, _LOJACLI)
    Method ItensPC(_FILIAL, _NUM, _FORNECE, _LOJAFOR)

    method Integrado(_Tabela, ctpFild)    //verifica se na tabela selecionada ha registros não integrados

    method GerarNota(cPdv, cFilpv)       //Geração da Nota - de Saida
    method TrsMitNot(aDados)        //Transmissão da Nota Gerada
    METHOD MonitNf(aDocGer)  //Temporizador - para geração etransmissão da nota - versão 02

    METHOD pgClient(_cnpj)
    METHOD pgFornec(_cnpj)

    METHOD TesPDV( _prod, _client, _loja, _operac )

    METHOD GerCdFor()

    METHOD GerCdCli()

    METHOD GrPedCom(cFilAt)
    
    METHOD PGExtrt(_EXTERNID)

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
	cQuery += " WHERE A1_FILIAL = '" + _fili + "' "
    cQuery += " AND SA1.A1_CGC = '"+_cnpj+"' "
	cQuery += " AND SA1.D_E_L_E_T_ = '' "
	cAlSA1:= CriaTrab(Nil,.F.)
	DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSA1, .F., .T.)    

	If (cAlSA1)->(Eof())
        lRet := .F. 
	Endif
    (cAlSA1)->(dbclosearea())

Return lRet

method temCliCod(_fili, cod, loja) class LIBGLASS
    Local lRet := .T.

    cQuery := " SELECT A1_FILIAL, A1_COD, A1_LOJA, A1_NOME, A1_NREDUZ, A1_CGC, A1_END "
	cQuery += " FROM "+RetSQLName("SA1") + " AS SA1 WITH (NOLOCK) "
	cQuery += " WHERE A1_FILIAL = '" + _fili + "' "
    cQuery += " AND SA1.A1_COD = '"+cod+"' AND A1_LOJA = '"+loja+"' "
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

method temForCod(_fili, cod, loja) class LIBGLASS
    Local lRet := .T.

    cQuery := " SELECT A2_FILIAL, A2_COD, A2_LOJA, A2_NOME, A2_NREDUZ, A2_CGC, A2_END "
	cQuery += " FROM "+RetSQLName("SA2") + " AS SA2 WITH (NOLOCK) "
	cQuery += " WHERE A2_FILIAL = '" + _fili + "' "
    cQuery += " AND SA2.A2_COD = '"+cod+"' AND A2_LOJA = '"+loja+"' "
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

method pedVendas(aCab, aItens, nOpc, cDoc) class LIBGLASS
    Local nCount
    Local aRet := {}
    Local cLogErro := ""

    MSExecAuto({|a, b, c, d| MATA410(a, b, c, d)}, aCab, aItens, nOpc, .F.)
    
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
        aCliTmp[nItem]['TIPO'] 	        := Rtrim( (cAlSA1)->A1_TIPCLI )
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
        aCliTmp[nItem]['INTEGRADO']		:= (cAlSA1)->A1_ZINTEGR
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
        aCliTmp[nItem]['TIPO'] 	        := Rtrim( (cAlSA1)->A1_TIPCLI )
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
        aCliTmp[nItem]['INTEGRADO']		:= (cAlSA1)->A1_ZINTEGR
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
        aCliTmp[nItem]['TIPO'] 	        := Rtrim( (cAlSA1)->A1_TIPCLI )
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
        aCliTmp[nItem]['INTEGRADO']		:= (cAlSA1)->A1_ZINTEGR
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
        aFornTmp[nItem]['TIPO'] 	    := Rtrim( (cAlSA2)->A2_TIPO )
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
        aFornTmp[nItem]['INTEGRADO']	:= (cAlSA2)->A2_ZINTEGR
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
        aFornTmp[nItem]['TIPO'] 	    := Rtrim( (cAlSA2)->A2_TIPO )
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
        aFornTmp[nItem]['INTEGRADO']	:= (cAlSA2)->A2_ZINTEGR
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
        aFornTmp[nItem]['TIPO'] 	    := Rtrim( (cAlSA2)->A2_TIPO )
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
        aFornTmp[nItem]['INTEGRADO']	:= (cAlSA2)->A2_ZINTEGR
        (cAlSA2)->(DBSKIP())
        LOOP
	ENDDO
    (cAlSA2)->(dbclosearea())

Return aFornTmp


method ITENSPV(_FILIAL, _NUM, _CLIENTE, _LOJACLI) class LIBGLASS
    Local aRet := {}

    cQuery := " SELECT * "
    cQuery += " FROM "+RetSQLName("SC6") + " AS SC6 WITH (NOLOCK) "
    cQuery += " WHERE C6_FILIAL = '" + _FILIAL + "' AND SC6.C6_NUM = '"+_NUM+"' "
    cQuery += " AND C6_CLI = '" + _CLIENTE + "' AND SC6.C6_LOJA = '"+_LOJACLI+"' "
    cQuery += " AND SC6.D_E_L_E_T_ = '' "
    cAlSC6:= CriaTrab(Nil,.F.)
    DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSC6, .F., .T.)    
               
    nItem := 0        
    DO WHILE !((cAlSC6)->(EOF())) .AND. (cAlSC6)->C6_NUM == _NUM
        aAdd( aRet , JsonObject():New() )
        nItem++
        aRet[nItem]['ITEM']        := Strzero(nItem,4)
        aRet[nItem]['TES']         := Rtrim( (cAlSC6)->C6_TES )
        aRet[nItem]['PRODUTO']     := Rtrim( (cAlSC6)->C6_PRODUTO )
        aRet[nItem]['DESCRICAO']   := Rtrim(POSICIONE("SB1",1,FWxFilial("SB1")+(cAlSC6)->C6_PRODUTO,"B1_DESC"))
        aRet[nItem]['UM']          := (cAlSC6)->C6_UM
        aRet[nItem]['QUANT']       := (cAlSC6)->C6_QTDVEN
        aRet[nItem]['PRECO']       := (cAlSC6)->C6_PRCVEN
        aRet[nItem]['TOTAL']       := (cAlSC6)->C6_VALOR
        (cAlSC6)->(DBSKIP())
        LOOP
    ENDDO
    (cAlSC6)->(DBCLOSEAREA())

Return aRet


method ITENSPC(_FILIAL, _NUM, _FORNECE, _LOJAFOR ) class LIBGLASS
    Local aRet := {}

    cQuery := " SELECT * "
    cQuery += " FROM "+RetSQLName("SC7") + " AS SC7 "
    cQuery += " WHERE C7_FILIAL = '" + _FILIAL + "' AND SC7.C7_NUM = '"+_NUM+"' "
    cQuery += " AND C7_FORNECE = '" + _FORNECE + "' AND C7_LOJA = '"+_LOJAFOR+"' "
    cQuery += " AND SC7.D_E_L_E_T_ = '' "
    cAliSC7:= CriaTrab(Nil,.F.)
    DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAliSC7, .F., .T.)    
               
    nItem := 0        
    DO WHILE !((cAliSC7)->(EOF())) .AND. (cAliSC7)->C7_NUM == _NUM
        aAdd( aRet , JsonObject():New() )
        nItem++
        aRet[nItem]['ITEM']        := Strzero(nItem,4)
        aRet[nItem]['TES']         := Rtrim( (cAliSC7)->C7_TES )
        aRet[nItem]['PRODUTO']     := Rtrim( (cAliSC7)->C7_PRODUTO )
        aRet[nItem]['DESCRICAO']   := Rtrim(POSICIONE("SB1",1,FWxFilial("SB1")+(cAliSC7)->C7_PRODUTO,"B1_DESC"))
        aRet[nItem]['UM']          := (cAliSC7)->C7_UM
        aRet[nItem]['QUANT']       := (cAliSC7)->C7_QUANT
        aRet[nItem]['PRECO']       := (cAliSC7)->C7_PRECO
        aRet[nItem]['TOTAL']       := (cAliSC7)->C7_TOTAL
        (cAliSC7)->(DBSKIP())
        LOOP
    ENDDO
    (cAliSC7)->(DBCLOSEAREA())

Return aRet


method Integrado( tabela, ctpFild ) class LIBGLASS
    Local aTmp := {}
    oWS := LIBGLASS():new()

    if tabela == "SA2"
        cQuery := " SELECT * "
        cQuery += " FROM "+RetSQLName("SA2") + " AS SA2 "
        cQuery += " WHERE SA2.A2_ZINTEGR <> 'S' "
        IF !EMPTY(ctpFild) 
            if ctpFild == "S"
                cQuery += " AND A2_ZTPAFIL = 'S' "
            else
                cQuery += " AND A2_ZTPAFIL <> 'S' "
            endif
        Endif       
        cQuery += " AND SA2.D_E_L_E_T_ <> '*' "
        cAlS:= CriaTrab(Nil,.F.)
        DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlS, .F., .T.)    

        nItem := 0
        DO WHILE !(cAlS)->(Eof())
            aAdd( aTmp , JsonObject():New() )
            nItem++
            aTmp[nItem]['FILIAL'] 		:= (cAlS)->A2_FILIAL
            aTmp[nItem]['CODIGO']		:= (cAlS)->A2_COD
            aTmp[nItem]['LOJA'] 		:= (cAlS)->A2_LOJA
            aTmp[nItem]['NOME'] 		:= Rtrim( (cAlS)->A2_NOME)
            aTmp[nItem]['NREDUZ'] 		:= Rtrim( (cAlS)->A2_NREDUZ )
            aTmp[nItem]['BAIRRO'] 		:= Rtrim( (cAlS)->A2_BAIRRO )
            aTmp[nItem]['EMAIL'] 		:= Rtrim( (cAlS)->A2_EMAIL  )
            aTmp[nItem]['CEP']			:= Rtrim( (cAlS)->A2_CEP    )
            aTmp[nItem]['CNPJ'] 		:= Rtrim( (cAlS)->A2_CGC    )
            aTmp[nItem]['ESTADO']		:= Rtrim( (cAlS)->A2_ESTADO )
            aTmp[nItem]['COD_MUN']		:= Rtrim( (cAlS)->A2_COD_MUN)
            aTmp[nItem]['COND'] 		:= Rtrim( (cAlS)->A2_COND   )
            aTmp[nItem]['DDD'] 			:= Rtrim( (cAlS)->A2_DDD    )
            aTmp[nItem]['END']			:= Rtrim( (cAlS)->A2_END    )
            aTmp[nItem]['INSCR'] 		:= Rtrim( (cAlS)->A2_INSCR  )
            aTmp[nItem]['MUNCIPIO'] 	:= Rtrim( (cAlS)->A2_MUN    )
            aTmp[nItem]['NATUREZ']		:= Rtrim( (cAlS)->A2_NATUREZ)
            aTmp[nItem]['TIPO'] 	    := Rtrim( (cAlS)->A2_TIPO )
            aTmp[nItem]['FONE'] 		:= Rtrim( (cAlS)->A2_TEL    )
            aTmp[nItem]['TRANSP'] 		:= Rtrim( (cAlS)->A2_TRANSP )
            aTmp[nItem]['PAIS'] 		:= Rtrim( (cAlS)->A2_PAIS   )
            aTmp[nItem]['BLOQUEADO']	:= IF((cAlS)->A2_MSBLQL == "2", "NAO", "SIM")
            aTmp[nItem]['MOVEL']		:= (cAlS)->A2_ZMOBILE
            aTmp[nItem]['TIPOVEICULO']	:= (cAlS)->A2_ZTPVEIC
            aTmp[nItem]['DTCRIACAO']	:= (cAlS)->A2_ZDTCRIA
            aTmp[nItem]['ATIVO']		:= (cAlS)->A2_ZATIVO
            aTmp[nItem]['PAGAMENTOADT']	:= (cAlS)->A2_ZPGTADT
            aTmp[nItem]['REVENDEAFIAL']	:= (cAlS)->A2_ZREVAFI
            aTmp[nItem]['AFILIADOCONV']	:= (cAlS)->A2_ZAFICON
            aTmp[nItem]['TIPOAFILIADO']	:= (cAlS)->A2_ZTPAFIL
            aTmp[nItem]['INTEGRADO']	:= (cAlS)->A2_ZINTEGR
            (cAlS)->(DBSKIP())
            LOOP
        ENDDO
        (cAlS)->(dbclosearea())

    elseif tabela == "SA1"
        cQuery := " SELECT * "
        cQuery += " FROM "+RetSQLName("SA1") + " AS SA1 WITH (NOLOCK) "
        cQuery += " WHERE SA1.A1_ZINTEGR <> 'S' "
        IF !EMPTY(ctpFild) 
            if ctpFild == "S"
                cQuery += " AND A1_ZTPAFIL = 'S' "
            else
                cQuery += " AND A1_ZTPAFIL <> 'S' "
            endif
        Endif       
        cQuery += " AND SA1.D_E_L_E_T_ <> '*' "
        cAlSA1 := CriaTrab(Nil,.F.)
        DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSA1, .F., .T.)    

        nItem := 0
        DO WHILE !(cAlSA1)->(Eof())
            aAdd( aTmp , JsonObject():New() )
            nItem++
            aTmp[nItem]['FILIAL'] 		:= (cAlSA1)->A1_FILIAL
            aTmp[nItem]['CODIGO']		:= (cAlSA1)->A1_COD
            aTmp[nItem]['LOJA'] 		:= (cAlSA1)->A1_LOJA
            aTmp[nItem]['NOME'] 		:= Rtrim( (cAlSA1)->A1_NOME)
            aTmp[nItem]['NREDUZ'] 		:= Rtrim( (cAlSA1)->A1_NREDUZ )
            aTmp[nItem]['BAIRRO'] 		:= Rtrim( (cAlSA1)->A1_BAIRRO )
            aTmp[nItem]['EMAIL'] 		:= Rtrim( (cAlSA1)->A1_EMAIL  )
            aTmp[nItem]['CEP']			:= Rtrim( (cAlSA1)->A1_CEP    )
            aTmp[nItem]['CNPJ'] 		:= Rtrim( (cAlSA1)->A1_CGC    )
            aTmp[nItem]['ESTADO']		:= Rtrim( (cAlSA1)->A1_ESTADO )
            aTmp[nItem]['COD_MUN']		:= Rtrim( (cAlSA1)->A1_COD_MUN)
            aTmp[nItem]['COND'] 		:= Rtrim( (cAlSA1)->A1_COND   )
            aTmp[nItem]['DDD'] 			:= Rtrim( (cAlSA1)->A1_DDD    )
            aTmp[nItem]['DTCAD'] 		:= (cAlSA1)->A1_DTCAD
            aTmp[nItem]['END']			:= Rtrim( (cAlSA1)->A1_END    )
            aTmp[nItem]['INSCR'] 		:= Rtrim( (cAlSA1)->A1_INSCR  )
            aTmp[nItem]['MUNCIPIO'] 	:= Rtrim( (cAlSA1)->A1_MUN    )
            aTmp[nItem]['NATUREZ']		:= Rtrim( (cAlSA1)->A1_NATUREZ)
            aTmp[nItem]['PESSOA'] 		:= Rtrim( (cAlSA1)->A1_TPESSOA)
            aTmp[nItem]['TIPO'] 	    := Rtrim( (cAlSA1)->A1_TIPCLI )
            aTmp[nItem]['FONE'] 		:= Rtrim( (cAlSA1)->A1_TEL    )
            aTmp[nItem]['TRANSP'] 		:= Rtrim( (cAlSA1)->A1_TRANSP )
            aTmp[nItem]['PAIS'] 		:= Rtrim( (cAlSA1)->A1_PAIS   )
            aTmp[nItem]['BLOQUEADO']	:= IF((cAlSA1)->A1_MSBLQL == "2", "NAO", "SIM")
            aTmp[nItem]['MOVEL']		:= (cAlSA1)->A1_ZMOBILE
            aTmp[nItem]['TIPOVEICULO']	:= (cAlSA1)->A1_ZTPVEIC
            aTmp[nItem]['DTCRIACAO']	:= (cAlSA1)->A1_ZDTCRIA
            aTmp[nItem]['ATIVO']		:= (cAlSA1)->A1_ZATIVO
            aTmp[nItem]['PAGAMENTOADT']	:= (cAlSA1)->A1_ZPGTADT
            aTmp[nItem]['REVENDEAFIAL']	:= (cAlSA1)->A1_ZREVAFI
            aTmp[nItem]['AFILIADOCONV']	:= (cAlSA1)->A1_ZAFICON
            aTmp[nItem]['TIPOAFILIADO']	:= (cAlSA1)->A1_ZTPAFIL
            aTmp[nItem]['INTEGRADO']	:= (cAlSA1)->A1_ZINTEGR

            (cAlSA1)->(DBSKIP())
            LOOP
        ENDDO
        (cAlSA1)->(dbclosearea())

    elseif tabela == "SC5"
        cQuery := " SELECT * "
        cQuery += " FROM "+RetSQLName("SC5") + " AS SC5 "
        cQuery += " WHERE C5_ZINTEGR <> 'S' "
        cQuery += " AND SC5.D_E_L_E_T_ <> '*' "
        cAlSC5:= CriaTrab(Nil,.F.)
        DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSC5, .F., .T.)                

        nIt := 0                
        DO WHILE !((cAlSC5)->(EOF()))
            aAdd( aTmp , JsonObject():New() )
            nIt++
            aTmp[nIt]['NUMPV']          := (cAlSC5)->C5_NUM
            aTmp[nIt]['EMISSAO']        := (cAlSC5)->C5_EMISSAO
            aTmp[nIt]['CLIENTE']        := (cAlSC5)->C5_CLIENTE
            aTmp[nIt]['LOJA']           := (cAlSC5)->C5_LOJACLI
            aTmp[nIt]['LOJAENTREGA']    := (cAlSC5)->C5_LOJAENT
            aTmp[nIt]['COND']           := (cAlSC5)->C5_CONDPAG
            aTmp[nIt]['INTEGRADO']	  := (cAlSC5)->C5_ZINTEGR
            aTmp[nIt]['NATUREZA']  	  := Rtrim((cAlSC5)->C5_NATUREZ)
            aTmp[nIt]['NOTA']  	      := Rtrim((cAlSC5)->C5_NOTA)
            aTmp[nIt]['SERIE'] 	      := Rtrim((cAlSC5)->C5_SERIE)
            aTmp[nIt]['ITENS']          := oWS:ITENSPV((cAlSC5)->C5_FILIAL, (cAlSC5)->C5_NUM, (cAlSC5)->C5_CLIENTE, (cAlSC5)->C5_LOJACLI )
            (cAlSC5)->(DBSKIP())
            LOOP
        ENDDO
        (cAlSC5)->(DBCLOSEAREA())     

    elseif tabela == "SC7"
        cQuery := " SELECT * "
        cQuery += " FROM "+RetSQLName("SC7") + " AS SC7 "
        cQuery += " WHERE C7_ZINTEGR <> 'S' "
        cQuery += " AND SC7.D_E_L_E_T_ <> '*' "
        cAlSC7:= CriaTrab(Nil,.F.)
        DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSC7, .F., .T.)                

        nIt := 0                
        DO WHILE !((cAlSC7)->(EOF()))
            aAdd( aTmp , JsonObject():New() )
            nIt++
            aTmp[nIt]['NUMPC']     := (cAlSC7)->C7_NUM
            aTmp[nIt]['EMISSAO']   := (cAlSC7)->C7_EMISSAO
            aTmp[nIt]['FORNECE']   := (cAlSC7)->C7_FORNECE
            aTmp[nIt]['LOJA']      := (cAlSC7)->C7_LOJA
            aTmp[nIt]['COND']      := (cAlSC7)->C7_COND
            aTmp[nIt]['CONTATO']   := (cAlSC7)->C7_CONTATO
            aTmp[nIt]['FILENT']    := (cAlSC7)->C7_FILENT
            aTmp[nIt]['TPFRETE']   := (cAlSC7)->C7_TPFRETE
            aTmp[nIt]['FRETE']     := (cAlSC7)->C7_FRETE
            aTmp[nIt]['INTEGRADO'] := (cAlSC7)->C7_ZINTEGR
            aTmp[nIt]['ITENS']     := oWS:ITENSPC((cAlSC7)->C7_FILIAL, (cAlSC7)->C7_NUM, (cAlSC7)->C7_FORNECE, (cAlSC7)->C7_LOJA )
            (cAlSC7)->(DBSKIP())
            LOOP
        ENDDO
        (cAlSC7)->(DBCLOSEAREA())
    elseif tabela == 'SC1'
        cQuery := " SELECT * "
        cQuery += " FROM "+RetSQLName("SC1") + " AS SC1 "
        cQuery += " WHERE C1_ZINTEGR <> 'S' "
        cQuery += " AND SC1.D_E_L_E_T_ <> '*' "
        cAlSC1:= CriaTrab(Nil,.F.)
        DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSC1, .F., .T.)                

        nItem := 0                
        DO WHILE !((cAlSC1)->(EOF()))
            aAdd( aTmp , JsonObject():New() )
            nItem++
            aTmp[nItem]['filial'] 	    := (cAlSC1)->C1_FILIAL 
            aTmp[nItem]['numSC']    	:= (cAlSC1)->C1_NUM 
            aTmp[nItem]['solicitante'] 	:= (cAlSC1)->C1_SOLICIT 
            aTmp[nItem]['emissao'] 		:= DtoC((cAlSC1)->C1_EMISSAO)
            aTmp[nItem]['integrado']  	:= (cAlSC1)->C1_ZINTEGR
            (cAlSC1)->(DBSKIP())
            LOOP
        ENDDO
        (cAlSC1)->(DBCLOSEAREA())
        cQuery := " SELECT * "
        cQuery += " FROM "+RetSQLName("SA1") + " AS SA1 WITH (NOLOCK) "
        cQuery += " WHERE SA1.A1_ZINTEGR <> 'S' "
        cQuery += " AND SA1.D_E_L_E_T_ <> '*' "
        cAlSA1 := CriaTrab(Nil,.F.)
        DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSA1, .F., .T.)    

        nItem := 0
        DO WHILE !(cAlSA1)->(Eof())
            aAdd( aTmp , JsonObject():New() )
            nItem++
            aTmp[nItem]['FILIAL'] 		:= (cAlSA1)->A1_FILIAL
            aTmp[nItem]['CODIGO']		:= (cAlSA1)->A1_COD
            aTmp[nItem]['LOJA'] 		:= (cAlSA1)->A1_LOJA
            aTmp[nItem]['NOME'] 		:= Rtrim( (cAlSA1)->A1_NOME)
            aTmp[nItem]['NREDUZ'] 		:= Rtrim( (cAlSA1)->A1_NREDUZ )
            aTmp[nItem]['BAIRRO'] 		:= Rtrim( (cAlSA1)->A1_BAIRRO )
            aTmp[nItem]['EMAIL'] 		:= Rtrim( (cAlSA1)->A1_EMAIL  )
            aTmp[nItem]['CEP']			:= Rtrim( (cAlSA1)->A1_CEP    )
            aTmp[nItem]['CNPJ'] 		:= Rtrim( (cAlSA1)->A1_CGC    )
            aTmp[nItem]['ESTADO']		:= Rtrim( (cAlSA1)->A1_ESTADO )
            aTmp[nItem]['COD_MUN']		:= Rtrim( (cAlSA1)->A1_COD_MUN)
            aTmp[nItem]['COND'] 		:= Rtrim( (cAlSA1)->A1_COND   )
            aTmp[nItem]['DDD'] 			:= Rtrim( (cAlSA1)->A1_DDD    )
            aTmp[nItem]['DTCAD'] 		:= (cAlSA1)->A1_DTCAD
            aTmp[nItem]['END']			:= Rtrim( (cAlSA1)->A1_END    )
            aTmp[nItem]['INSCR'] 		:= Rtrim( (cAlSA1)->A1_INSCR  )
            aTmp[nItem]['MUNCIPIO'] 	:= Rtrim( (cAlSA1)->A1_MUN    )
            aTmp[nItem]['NATUREZ']		:= Rtrim( (cAlSA1)->A1_NATUREZ)
            aTmp[nItem]['PESSOA'] 		:= Rtrim( (cAlSA1)->A1_TPESSOA)
            aTmp[nItem]['TIPO'] 	    := Rtrim( (cAlSA1)->A1_TIPCLI )
            aTmp[nItem]['FONE'] 		:= Rtrim( (cAlSA1)->A1_TEL    )
            aTmp[nItem]['TRANSP'] 		:= Rtrim( (cAlSA1)->A1_TRANSP )
            aTmp[nItem]['PAIS'] 		:= Rtrim( (cAlSA1)->A1_PAIS   )
            aTmp[nItem]['BLOQUEADO']	:= IF((cAlSA1)->A1_MSBLQL == "2", "NAO", "SIM")
            aTmp[nItem]['MOVEL']		:= (cAlSA1)->A1_ZMOBILE
            aTmp[nItem]['TIPOVEICULO']	:= (cAlSA1)->A1_ZTPVEIC
            aTmp[nItem]['DTCRIACAO']	:= (cAlSA1)->A1_ZDTCRIA
            aTmp[nItem]['ATIVO']		:= (cAlSA1)->A1_ZATIVO
            aTmp[nItem]['PAGAMENTOADT']	:= (cAlSA1)->A1_ZPGTADT
            aTmp[nItem]['REVENDEAFIAL']	:= (cAlSA1)->A1_ZREVAFI
            aTmp[nItem]['AFILIADOCONV']	:= (cAlSA1)->A1_ZAFICON
            aTmp[nItem]['TIPOAFILIADO']	:= (cAlSA1)->A1_ZTPAFIL
            aTmp[nItem]['INTEGRADO']	:= (cAlSA1)->A1_ZINTEGR
            (cAlSA1)->(DBSKIP())
            LOOP
        ENDDO
        (cAlSA1)->(dbclosearea())

    elseif tabela == "SB1"
        cQuery := " SELECT * "
        cQuery += " FROM "+RetSQLName("SB1") + " AS SB1 WITH (NOLOCK) "
        cQuery += " WHERE SB1.B1_ZINTEGR <> 'S' "
        cQuery += " AND SB1.D_E_L_E_T_ = '' "
        cAlSB1 := CriaTrab(Nil,.F.)
        DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSB1, .F., .T.)    

        nItem := 0
        DO WHILE !(cAlSB1)->(Eof())
            aAdd( aTmp , JsonObject():New() )
            nItem++
            aTmp[nItem]['CODIGO']         := Rtrim((cAlSB1)->B1_COD)
            aTmp[nItem]['DESCRICAO']      := Rtrim((cAlSB1)->B1_DESC)
            aTmp[nItem]['TIPO']           := (cAlSB1)->B1_TIPO 
            aTmp[nItem]['UM']             := (cAlSB1)->B1_UM 
            aTmp[nItem]['ALMOXARIF']      := (cAlSB1)->B1_LOCPAD 
            aTmp[nItem]['PERICMS']        := (cAlSB1)->B1_PICM 
            aTmp[nItem]['PERIPI']         := (cAlSB1)->B1_IPI 
            aTmp[nItem]['LOCALIZACAO']    := (cAlSB1)->B1_LOCALIZ 
            aTmp[nItem]['INTEGRADO']	  := (cAlSB1)->B1_ZINTEGR
        	aTmp[nItem]['BLOQUEADO']  	  := IF((cAliasWS)->B1_MSBLQL == "2", "NAO", "SIM")
            (cAlSB1)->(DBSKIP())
            LOOP
        ENDDO
        (cAlSB1)->(dbclosearea())
    EndIF
Return aTmp

METHOD GerarNota(cPdv, cFilpv) class LIBGLASS
 
    Local aPvlDocS := {}
    Local nPrcVen  := 0
    Local cSerie   := "1"
    Local cEmbExp  := ""
    Local cDoc     := ""
    Local aRet     := {}
    Local aNota    := {}
    //Local aMonit   := {}

    cC5Num := cPdv
    cFili  := cFilpv

    SC5->(DbSetOrder(1))
    SC5->(MsSeek(cFili+cC5Num))

    SC6->(dbSetOrder(1))
    SC6->(MsSeek(cFili+SC5->C5_NUM))

    While SC6->(!Eof() .And. SC6->C6_FILIAL == cFili) .And. SC6->C6_NUM == SC5->C5_NUM

        SC9->(DbSetOrder(1))
        SC9->(MsSeek(cFili+SC6->(C6_NUM+C6_ITEM))) //FILIAL+NUMERO+ITEM

        SE4->(DbSetOrder(1))
        SE4->(MsSeek(cFili+SC5->C5_CONDPAG) )  //FILIAL+CONDICAO PAGTO

        SB1->(DbSetOrder(1))
        SB1->(MsSeek(cFili+SC6->C6_PRODUTO))    //FILIAL+PRODUTO

        SB2->(DbSetOrder(1))
        SB2->(MsSeek(cFili+SC6->(C6_PRODUTO+C6_LOCAL))) //FILIAL+PRODUTO+LOCAL

        SF4->(DbSetOrder(1))
        SF4->(MsSeek(cFili+SC6->C6_TES))   //FILIAL+TES

        nPrcVen := SC9->C9_PRCVEN
        If ( SC5->C5_MOEDA <> 1 )
            nPrcVen := xMoeda(nPrcVen,SC5->C5_MOEDA,1,dDataBase)
        EndIf

        If ( AllTrim(SC9->C9_BLEST)  == "" .OR. AllTrim(SC9->C9_BLEST)  == "01" .OR. AllTrim(SC9->C9_BLEST)  == "02" .OR. AllTrim(SC9->C9_BLEST)  == "10") .And. ;
        ( AllTrim(SC9->C9_BLCRED) == "" .OR. AllTrim(SC9->C9_BLCRED) == "01" .OR. AllTrim(SC9->C9_BLCRED) == "02" .OR. AllTrim(SC9->C9_BLCRED) == "10")
            AAdd(aPvlDocS,{ SC9->C9_PEDIDO,;
                            SC9->C9_ITEM,;
                            SC9->C9_SEQUEN,;
                            SC9->C9_QTDLIB,;
                            nPrcVen,;
                            SC9->C9_PRODUTO,;
                            .F.,;
                            SC9->(RecNo()),;
                            SC5->(RecNo()),;
                            SC6->(RecNo()),;
                            SE4->(RecNo()),;
                            SB1->(RecNo()),;
                            SB2->(RecNo()),;
                            SF4->(RecNo())})
        EndIf

        SC6->(DbSkip())
    EndDo

    SetFunName("MATA461")
    cDoc := MaPvlNfs(  /*aPvlNfs*/      aPvlDocS,;  // 01 - Array com os itens a serem gerados
                    /*cSerieNFS*/       cSerie,;    // 02 - Serie da Nota Fiscal
                    /*lMostraCtb*/      .F.,;       // 03 - Mostra Lançamento Contábil
                    /*lAglutCtb*/       .F.,;       // 04 - Aglutina Lançamento Contábil
                    /*lCtbOnLine*/      .F.,;       // 05 - Contabiliza On-Line
                    /*lCtbCusto*/       .T.,;       // 06 - Contabiliza Custo On-Line
                    /*lReajuste*/       .F.,;       // 07 - Reajuste de preço na Nota Fiscal
                    /*nCalAcrs*/        0,;         // 08 - Tipo de Acréscimo Financeiro
                    /*nArredPrcLis*/    0,;         // 09 - Tipo de Arredondamento
                    /*lAtuSA7*/         .T.,;       // 10 - Atualiza Amarração Cliente x Produto
                    /*lECF*/            .F.,;       // 11 - Cupom Fiscal
                    /*cEmbExp*/         cEmbExp,;   // 12 - Número do Embarque de Exportação
                    /*bAtuFin*/         {||},;      // 13 - Bloco de Código para complemento de atualização dos títulos financeiros
                    /*bAtuPGerNF*/      {||},;      // 14 - Bloco de Código para complemento de atualização dos dados após a geração da Nota Fiscal
                    /*bAtuPvl*/         {||},;      // 15 - Bloco de Código de atualização do Pedido de Venda antes da geração da Nota Fiscal
                    /*bFatSE1*/         {|| .T. },; // 16 - Bloco de Código para indicar se o valor do Titulo a Receber será gravado no campo F2_VALFAT quando o parâmetro MV_TMSMFAT estiver com o valor igual a "2".
                    /*dDataMoe*/        dDatabase,; // 17 - Data da cotação para conversão dos valores da Moeda do Pedido de Venda para a Moeda Forte
                    /*lJunta*/          .F.)        // 18 - Aglutina Pedido Iguais
    
    If !Empty(cDoc)
        Conout("Documento de Saída: " + cSerie + "-" + cDoc + ", gerado com sucesso!!!")
        AADD(aRet,  { PadR(Alltrim(cDoc), TamSx3('F2_DOC')[1]), PadR(Alltrim(cSerie), TamSx3('F2_SERIE')[1]) })
        AADD(aNota, { PadR(Alltrim(cDoc), TamSx3('F2_DOC')[1]), PadR(Alltrim(cSerie), TamSx3('F2_SERIE')[1]) })
        
        //cFilNF  := Xfilial("SF2")
        //cMensa  := oWMS:TrsMitNot( aNota )
        //Conout("Transmissao da nota: " + cDoc + " - " + cMensa + "  , gerado com sucesso!!!")

        //aMonit  := oWMS:MonitNf(aNota)

        aNota    := {}
        aPvlDocS := {}
    EndIf

Return aRet

METHOD TrsMitNot(aDados) class LIBGLASS
    Local cRetorno      := ''
    Local cIDEnt        := ''
    Local cAmbiente     := ''
    Local cModalidade   := ''
    Local cVersao       := ''
    Local lCte          := .F.
    Local cURL          := PadR(GetNewPar("MV_SPEDURL","http://"),250)
    Local x

    Private lEnd		:= .F.
    Private bFiltraBrw	:= {||}
    
    cIdEnt := GetIdEnt()

    oWS := WsSpedCfgNFe():New()
    oWS:cUSERTOKEN := "TOTVS"
    oWS:cID_ENT    := cIdEnt
    oWS:nAmbiente  := 0
    oWS:_URL       := AllTrim(cURL)+"/SPEDCFGNFe.apw"
    lOk			   := execWSRet( oWS, "CFGAMBIENTE")
    If lOk
        cAmbiente := oWS:cCfgAmbienteResult
    Else
        Conout(IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)))
    EndIf    
 
    If lOk
        // oWS:cUSERTOKEN := "TOTVS"
        // oWS:cID_ENT    := cIdEnt
        // oWS:_URL       := AllTrim(cURL)+"/SPEDCFGNFe.apw"
        oWS:nModalidade:= 0
        oWs:cModelo	   := "55"
        lOk 		   := execWSRet( oWS, "CFGModalidade" )
        If lOk
            cModalidade:= oWS:cCfgModalidadeResult
        Else
            Conout(IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)))
        EndIf
    EndIf
    If lOk
        // oWS:cUSERTOKEN := "TOTVS"
        // oWS:cID_ENT    := cIdEnt
        // oWS:_URL       := AllTrim(cURL)+"/SPEDCFGNFe.apw"
        oWS:cVersao    := "0.00"
        lOk			   := execWSRet( oWs, "CFGVersao" )
        If lOk
            cVersao    := oWS:cCfgVersaoResult
        Else
            Conout(IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)))
        EndIf
    EndIf

    for X:=1 TO LEN(aDados)
        cNotaIni := aDados[X,1] //aProcessa[1][3]
        cNotaFim := aDados[X,1] //aProcessa[Len(aProcessa)][3]
        cSerie   := aDados[X,2]   
        cRetorno := SpedNFeTrf("SF2",cSerie,cNotaIni,cNotaFim,cIdEnt,cAmbiente,cModalidade,cVersao,@lEnd,lCte,.F.)
        CONOUT("LIBGLASS TRNASMITIU " + cRetorno +" "+ STR(X) )
                    // SpedNFeTrf("SF2",cSerie,cNota,cNota,cIDEnt,cAmbiente,cModalidade,cVersao,.F.,.F., .F.)
    Next
     CONOUT("SAIU DA TRANSMISSÃO " )

RETURN cRetorno

Method MonitNf(aNotas) class LIBGLASS
    Local lOk := {.F., ''}
    Local cLockFile   as character
    Local cProcesso   as character
    Local aNFDeAte    as array
    Local aMonDocs    as array
    Local aInfMonNFe  as array
    Local cCodEmp     as character
    Local cCodFil     as character
    Local cIDEnt      as character
    Local cURL        as character
    Local cModelo     as character
    Local cSerie      as character
    Local cAviso      as character
    Local nI          as numeric
    Local nTentantiva as numeric
 
    cLockFile   := ""
    cProcesso   := "Transmissão"
    aNFDeAte    := {}
    aadd(aNFDeAte, {"", "", aNotas[1,1]}) // nota inicial
    aadd(aNFDeAte, {"", "", aNotas[1,1]}) // nota final
    aMonDocs    := {aNotas[1,2], aNotas[1,1], aNotas[1,1]} // serie, nota inicial, nota final
    aInfMonNFe  := {}
    cCodEmp     := cEmpAnt
    cCodFil     := cFilAnt
    cIDEnt      := RetIdEnti()
    cURL        := SuperGetMV("MV_SPEDURL",.F.,"") // precisa existir
    cModelo     := "55" // NFe
    cSerie      := aNotas[1,2]
    cAviso      := ""
    nTentantiva := SuperGetMv("MV_XOFIMON",,5)
 
    transmiteAutoNFE(;
        cLockFile,; // lock de registros
        cProcesso,;     // descrição do processo
        aNFDeAte,;      // array com a nota inicial e nota final
        cCodEmp,;       // código da empresa que esta fazendo a transmissão
        cCodFil,;       // código da filial que esta fazendo a transmissão
        cIDEnt,;        // identificador da entidade que está transmitindo
        cURL,;          // URL da NFE SEFAZ
        cModelo,;       // modelo dos documentos
        cSerie;         // série dos documentos
    )
 
    Sleep(1000)
    CONOUT("Monitorando Notas Transmitidas...")
 
    For nI := 1 To nTentantiva
 
        CONOUT("Monitorando... Tentativa: " + cValToChar(nI) + " de " + cValToChar(nTentantiva))
 
        aInfMonNFe := procMonitorDoc(;
            cIdEnt,;      // identificador da entidade que está transmitindo
            cUrl,;        // URL da NFE SEFAZ
            aMonDocs,;    // array com a nota a ser monitorada
            1,;           // tipo de monitoramento - usar por faixa de notas
            cModelo,;     // modelo dos documentos
            .F.,;         // usado para CTE
            @cAviso)      // mensagem de retorno quando tiver erro no WS
 
        If !Empty(cAviso)
            CONOUT(cAviso,"TOTVS")
            Exit
        ElseIf !Empty(aInfMonNFe) .And. !(SubStr(aInfMonNFe[1][9],1,3) $ "003-004-009-025")
            CONOUT("Nota trasmitada com sucesso!","TOTVS")
            RETURN lOk := {.T., "serie e Nota: "+aInfMonNFe[1,1] + " trasmitada com sucesso!"}
        ElseIf nI == nTentantiva
            CONOUT("Não foi possível obter informações da nota fiscal transmitida!","TOTVS")
        EndIf
        Sleep(1000)
 
    Next

Return lOk

Method pgClient(_cnpj) class LIBGLASS
    Local aRet := {}

    cQuery := " SELECT A1_FILIAL, A1_COD, A1_LOJA, A1_NOME, A1_NREDUZ, A1_CGC, A1_END "
	cQuery += " FROM "+RetSQLName("SA1") + " AS SA1 WITH (NOLOCK) "
	cQuery += " WHERE A1_FILIAL = '" + FWxFilial("SA1") + "' "
    cQuery += " AND SA1.A1_CGC = '"+_cnpj+"' "
	cQuery += " AND SA1.D_E_L_E_T_ = '' AND SA1.A1_MSBLQL <> '1' "
	cAlSA1:= CriaTrab(Nil,.F.)
	DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSA1, .F., .T.)    

    aadd(aRet, {(cAlSA1)->A1_COD, (cAlSA1)->A1_LOJA})

    (cAlSA1)->(dbclosearea())

Return aRet

Method pgFornec(_cnpj) class LIBGLASS
    Local aRet := {}
    cQuery := " SELECT A2_FILIAL, A2_COD, A2_LOJA, A2_NOME, A2_NREDUZ, A2_CGC, A2_END "
	cQuery += " FROM "+RetSQLName("SA2") + " AS SA2 WITH (NOLOCK) "
	cQuery += " WHERE A2_FILIAL = '" + FWxFilial("SA1") + "' AND SA2.A2_CGC = '"+_cnpj+"' "
	cQuery += " AND SA2.D_E_L_E_T_ = '' AND SA2.A2_MSBLQL <> '1' "
	cAlSA2:= CriaTrab(Nil,.F.)
	DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSA2, .F., .T.)    

    aadd(aRet, {(cAlSA2)->A2_COD, (cAlSA2)->A2_LOJA})

    (cAlSA2)->(dbclosearea())

Return aRet


Method TesPDV(_prod, _client, _loja, _operac) CLASS LIBGLASS
	Local cTesIntel := ""

    cQuery := " SELECT * "
	cQuery += " FROM "+RetSQLName("SFM") + " WITH (NOLOCK) "
	cQuery += " WHERE FM_FILIAL = '" + FWxFilial("SFM") + "' AND  FM_TIPO = '"+_operac+"' "
	cQuery += " AND D_E_L_E_T_ = '' "
	cAlSFM:= CriaTrab(Nil,.F.)
	DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSFM, .F., .T.)    

    cEstCli := Posicione("SA1", 1, xFilial("SA1")+_client+_loja,"A1_EST")

    DO WHILE !((cAlSFM)->(EOF()))
        IF (cAlSFM)->FM_CLIENTE == _client .AND. (cAlSFM)->FM_LOJACLI == _loja .AND. (cAlSFM)->FM_PRODUTO == _prod .AND. (cAlSFM)->FM_EST == cEstCli
            cTesIntel := (cAlSFM)->FM_TS
        Else
            cTesIntel := (cAlSFM)->FM_TS
        ENDIF    
        (cAlSFM)->(DBSKIP())
        LOOP
    ENDDO
    (cAlSFM)->(dbclosearea())

Return (cTesIntel)


METHOD GerCdFor() class LIBGLASS
    Local cCod  := ""
    Local lTest := .T.

    DO WHILE lTest
        _COD := GetSXENum("SA2","A2_COD")

        cQuery := " SELECT COUNT(*) AS NUM "
        cQuery += " FROM "+RetSQLName("SA2") + " AS SA2 WITH (NOLOCK) "
        cQuery += " WHERE A2_FILIAL = '" + FWxFilial("SA2") + "' AND A2_COD = '"+_COD+"' "
        cAlSA2:= CriaTrab(Nil,.F.)
        DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSA2, .F., .T.)    

        IF (cAlSA2)->NUM > 0
            (cAlSA2)->(dbclosearea())
            CONFIRMSX8()
        ELSE
            cCod  := _COD
            lTest := .F.
        ENDIF
    ENDDO

Return cCod


METHOD GerCdCli() class LIBGLASS
    Local lTest := .T.

    DO WHILE lTest
        _COD := GetSXENum("SA1","A1_COD")

        cQuery := " SELECT COUNT(*) AS NUM "
        cQuery += " FROM "+RetSQLName("SA1") + " AS SA1 WITH (NOLOCK) "
        cQuery += " WHERE A1_FILIAL = '" + FWxFilial("SA1") + "' AND A1_COD = '"+_COD+"' "
        cAlSA1:= CriaTrab(Nil,.F.)
        DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSA1, .F., .T.)    

        IF (cAlSA1)->NUM > 0
            (cAlSA1)->(dbclosearea())
            CONFIRMSX8()
        ELSE
            cCod  := _COD
            lTest := .F.
        ENDIF
    ENDDO

Return cCod

METHOD GrPedCom(cFilAt) class LIBGLASS
    Local lTest := .T.

    DO WHILE lTest
        _CODPED := GetSXENum("SC7","C7_NUM")

        cQuery := " SELECT COUNT(*) AS NUM "
        cQuery += " FROM "+RetSQLName("SC7") + " AS C7 WITH (NOLOCK) "
        cQuery += " WHERE C7_NUM = '"+_CODPED+"' "
        cAlSC7:= CriaTrab(Nil,.F.)
        DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSC7, .F., .T.)    

        IF (cAlSC7)->NUM > 0
            (cAlSC7)->(dbclosearea())
            CONFIRMSX8()
        ELSE
            cCod  := _CODPED
            lTest := .F.
        ENDIF
    ENDDO
    (cAlSC7)->(dbclosearea())

Return cCod

METHOD PGExtrt(_EXTERNID) class LIBGLASS
    Local cPed := ""
    cQuery := " SELECT C7_NUM AS NUM "
    cQuery += " FROM "+RetSQLName("SC7") + " AS C7 WITH (NOLOCK) "
    cQuery += " WHERE C7_ZEXTID = '"+_EXTERNID+"' "
    cAlSC7:= CriaTrab(Nil,.F.)
    DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSC7, .F., .T.)    

    cPed := (cAlSC7)->NUM 
    (cAlSC7)->(dbclosearea())

Return cPed
