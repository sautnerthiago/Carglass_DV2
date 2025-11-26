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

    METHOD GrPedVd(cFilAt)
    METHOD PGExtrtV(_EXTERNID)

    METHOD PGExtDad(_EXTERNID)
    METHOD PGExtPDV(_EXTERNID)

    METHOD PGDSCPRD(cProdut)
    //METHOD PGTIPPRD(_EXTERNID, cFili) //descontinuado

    METHOD pgNat(cProdut)

    Method atuPEdC(_cNumPed, _cAprov, _ZEXTID )

    METHOD temPDV( _EXTIDPDV )  //15/10/2025 - MONTAGEM DE VERIFICAÇÃO DE EXISTENCIA DO PDV

    method GerNFE(_EXTERNID, _CHVNFE, cOpc, dTalvc, cDoc, cSeri, _GRPNUM, _IDGRPNUM)  //14/10/2025 - gera nota fiscal de entrada

    METHOD PGtIPcLI(_cLI, _lOJ)

    METHOD temCC( _cCusto ) //11/11/2025 - VALIDAÇÃO DO CC, ROTINA PADÃO NÃO ESTA VALIDANDO NA INCLISÃO

    METHOD TemCont( _Prod ) //18/11/2025 - VALIDAÇÃO Da CONTA CONTABIL

    Method GRAVALOGZZE( nRecn, cExter, cMensRet, cCodRotin, cNomRti )
    Method mudaSts( nRecn, cExter, _status )
    Method ajustCC(cExter, cCC)
    
    Method GRVALGZZF( nRecn, cExter, cMensRet, cCodRotin, cNomRti )
    Method mudaStsf(nRecn, cExter, _status )
    METHOD PGExtest(_EXTERNID)
    method EXCNFE()
    METHOD VLDPRD(_EXTERNID)
    METHOD TransNfe(cDocumento, cSerie)    
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
    /*
    Local cCodUsr   := RetCodUsr()
    Local cNomUsr   := UsrRetName(cCodUsr)
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
    */
Return lRet

method temClient(_fili, _cnpj) class LIBGLASS
    Local lRet := .T.
    Local cAlSA1 := GetNextAlias()

    cQuery := " SELECT A1_FILIAL, A1_COD, A1_LOJA, A1_NOME, A1_NREDUZ, A1_CGC, A1_END "
	cQuery += " FROM "+RetSQLName("SA1") + " AS SA1 WITH (NOLOCK) "
	cQuery += " WHERE A1_FILIAL = '" + _fili + "' "
    cQuery += " AND SA1.A1_CGC = '"+_cnpj+"' "
	cQuery += " AND SA1.D_E_L_E_T_ = '' "
	//cAlSA1:= CriaTrab(Nil,.F.)
    //cQuery := ChangeQuery( cQuery )
	DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSA1, .F., .T.)    

	If (cAlSA1)->(Eof())
        lRet := .F. 
	Endif
    (cAlSA1)->(dbclosearea())

Return lRet

method temCliCod(_fili, cod, loja) class LIBGLASS
    Local lRet := .T.
    Local cAlSA1 := GetNextAlias()

    cQuery := " SELECT A1_FILIAL, A1_COD, A1_LOJA, A1_NOME, A1_NREDUZ, A1_CGC, A1_END "
	cQuery += " FROM "+RetSQLName("SA1") + " AS SA1 WITH (NOLOCK) "
	cQuery += " WHERE A1_FILIAL = '" + _fili + "' "
    cQuery += " AND SA1.A1_COD = '"+cod+"' AND A1_LOJA = '"+loja+"' "
	cQuery += " AND SA1.D_E_L_E_T_ = '' "
	//cAlSA1:= CriaTrab(Nil,.F.)
    //cQuery := ChangeQuery( cQuery )
	DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSA1, .F., .T.)    

	If (cAlSA1)->(Eof())
        lRet := .F. 
	Endif
    (cAlSA1)->(dbclosearea())

Return lRet

method temFornec(_fili, _cnpj) class LIBGLASS
    Local lRet   := .T.
    Local cAlSA2 := GetNextAlias()

    cQuery := " SELECT A2_FILIAL, A2_COD, A2_LOJA, A2_NOME, A2_NREDUZ, A2_CGC, A2_END "
	cQuery += " FROM "+RetSQLName("SA2") + " AS SA2 WITH (NOLOCK) "
	cQuery += " WHERE A2_FILIAL = '" + _fili + "' AND SA2.A2_CGC = '"+_cnpj+"' "
	cQuery += " AND SA2.D_E_L_E_T_ = '' "
	//cAlSA2:= CriaTrab(Nil,.F.)
    //cQuery := ChangeQuery( cQuery )
	DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSA2, .F., .T.)    

    (cAlSA2)->(DbGoTop())
	If (cAlSA2)->(Eof())
        lRet := .F. 
	Endif
    (cAlSA2)->(dbclosearea())

Return lRet

method temForCod(_fili, cod, loja) class LIBGLASS
    Local lRet   := .T.
    Local cAlSA2 := GetNextAlias()

    cQuery := " SELECT A2_FILIAL, A2_COD, A2_LOJA, A2_NOME, A2_NREDUZ, A2_CGC, A2_END "
	cQuery += " FROM "+RetSQLName("SA2") + " AS SA2 WITH (NOLOCK) "
	cQuery += " WHERE A2_FILIAL = '" + _fili + "' "
    cQuery += " AND SA2.A2_COD = '"+cod+"' AND A2_LOJA = '"+loja+"' "
	cQuery += " AND SA2.D_E_L_E_T_ = '' AND SA2.A2_MSBLQL <> '1' "
	//cAlSA2:= CriaTrab(Nil,.F.)
    //cQuery := ChangeQuery( cQuery )
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
    Local lRet   := .T.
    Local cAlSB1 := GetNextAlias()

    cQuery := " SELECT * "
	cQuery += " FROM "+RetSQLName("SB1") + " AS SB1 WITH (NOLOCK) "
	cQuery += " WHERE B1_FILIAL = '" + _fili + "' AND SB1.B1_COD = '"+_cod+"' "
	cQuery += " AND SB1.D_E_L_E_T_ = '' "
	//cAlSB1:= CriaTrab(Nil,.F.)
    //cQuery := ChangeQuery( cQuery )
	DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSB1, .F., .T.)    

	If (cAlSB1)->(Eof())
        lRet := .F. 
	Endif
    (cAlSB1)->(dbclosearea())

Return lRet

method temTES(_fili, _cod) class LIBGLASS
    Local lRet   := .T.
    Local cAlSF4 := GetNextAlias()

    cQuery := " SELECT * "
	cQuery += " FROM "+RetSQLName("SF4") + " AS SF4 WITH (NOLOCK) "
	cQuery += " WHERE B1_FILIAL = '" + _fili + "' AND SF4.F4_CODIGO = '"+_cod+"' "
	cQuery += " AND SF4.D_E_L_E_T_ = '' "
	//cAlSF4:= CriaTrab(Nil,.F.)
    //cQuery := ChangeQuery( cQuery )
	DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSF4, .F., .T.)    

	If (cAlSF4)->(Eof())
        lRet := .F. 
	Endif
    (cAlSF4)->(dbclosearea())

Return lRet

method temCndpg(_fili, _cod) class LIBGLASS
    Local lRet   := .T.
    Local cAlSE4 := GetNextAlias()

    cQuery := " SELECT * "
	cQuery += " FROM "+RetSQLName("SE4") + " AS SE4 WITH (NOLOCK) "
	cQuery += " WHERE B1_FILIAL = '" + _fili + "' AND SE4.E4_CODIGO = '"+_cod+"' "
	cQuery += " AND SE4.D_E_L_E_T_ = '' "
	//cAlSE4:= CriaTrab(Nil,.F.)
    //cQuery := ChangeQuery( cQuery )
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
        ConOut("Erro na inclusao! -Pedido de Vendas")
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
        ConOut("Incluido com sucesso! - pedido de compras " )
        aAdd(aRet, {"Incluido com sucesso! " , .T.})
    Else
        ConOut("Erro na inclusao! - pedido de Compras")
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
    Local cAlSA1  := GetNextAlias()

    cQuery := " SELECT * "
	cQuery += " FROM "+RetSQLName("SA1") + " AS SA1 WITH (NOLOCK) "
	cQuery += " WHERE SA1.A1_EST = '"+_estad+"' "
	cQuery += " AND SA1.D_E_L_E_T_ = '' "
	//cAlSA1 := CriaTrab(Nil,.F.)
    //cQuery := ChangeQuery( cQuery )
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
    Local cAlSA1 := GetNextAlias()

    cQuery := " SELECT * "
    cQuery += " FROM "+RetSQLName("SA1") + " AS SA1 WITH (NOLOCK) "
    cQuery += " WHERE SA1.A1_ZTPAFIL = '"+_Tipo+"' "
	cQuery += " AND SA1.D_E_L_E_T_ = '' "
	//cAlSA1:= CriaTrab(Nil,.F.)
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
    Local cAlSA1 := GetNextAlias()

    cQuery := " SELECT * "
	cQuery += " FROM "+RetSQLName("SA1") + " AS SA1 WITH (NOLOCK) "
	cQuery += " WHERE SA1.A1_ZDTCRIA BETWEEN '"+dtIni+"' AND '"+DtFin+"' "
	cQuery += " AND SA1.D_E_L_E_T_ = '' "
	//cAlSA1:= CriaTrab(Nil,.F.)
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
    Local cAlSA2 := GetNextAlias()

    cQuery := " SELECT * "
	cQuery += " FROM "+RetSQLName("SA2") + " AS SA2 WITH (NOLOCK) "
	cQuery += " WHERE SA2.A2_EST = '"+_estad+"' "
	cQuery += " AND SA2.D_E_L_E_T_ = '' "
	//cAlSA2 := CriaTrab(Nil,.F.)
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
    Local cAlSA2 := GetNextAlias()

    cQuery := " SELECT * "
    cQuery += " FROM "+RetSQLName("SA2") + " AS SA2 WITH (NOLOCK) "
    cQuery += " WHERE SA2.A2_ZTPAFIL = '"+_Tipo+"' "
	cQuery += " AND SA2.D_E_L_E_T_ = '' "
	//cAlSA2:= CriaTrab(Nil,.F.)
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
    Local cAlSA2   := GetNextAlias()

    cQuery := " SELECT * "
	cQuery += " FROM "+RetSQLName("SA2") + " AS SA2 WITH (NOLOCK) "
	cQuery += " WHERE "
	cQuery += " D_E_L_E_T_ = '' "
	//cQuery += " WHERE SA2.A2_ZDTCRIA BETWEEN '"+dtIni+"' AND '"+DtFin+"' "
	//cQuery += " AND SA2.D_E_L_E_T_ = '' "
	//cAlSA2:= CriaTrab(Nil,.F.)
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
    Local aRet   := {}
    Local cAlSC6 := GetNextAlias()

    cQuery := " SELECT * "
    cQuery += " FROM "+RetSQLName("SC6") + " AS SC6 WITH (NOLOCK) "
    cQuery += " WHERE C6_FILIAL = '" + _FILIAL + "' AND SC6.C6_NUM = '"+_NUM+"' "
    cQuery += " AND C6_CLI = '" + _CLIENTE + "' AND SC6.C6_LOJA = '"+_LOJACLI+"' "
    cQuery += " AND SC6.D_E_L_E_T_ = '' "
    //cAlSC6:= CriaTrab(Nil,.F.)
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
    Local cAliSC7 := GetNextAlias()

    cQuery := " SELECT * "
    cQuery += " FROM "+RetSQLName("SC7") + " AS SC7 "
    cQuery += " WHERE C7_FILIAL = '" + _FILIAL + "' AND SC7.C7_NUM = '"+_NUM+"' "
    cQuery += " AND C7_FORNECE = '" + _FORNECE + "' AND C7_LOJA = '"+_LOJAFOR+"' "
    cQuery += " AND SC7.D_E_L_E_T_ = '' "
    //cAliSC7:= CriaTrab(Nil,.F.)
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
    Local cAlS   := GetNextAlias()
    Local cAlSA1 := GetNextAlias()
    Local cAlSC5 := GetNextAlias()
    Local cAlSB1 := GetNextAlias()
    Local cAlSC7 := GetNextAlias()
    Local cAlSC1 := GetNextAlias()

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
        //cAlS:= CriaTrab(Nil,.F.)
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
        //cAlSA1 := CriaTrab(Nil,.F.)
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
        //cAlSC5:= CriaTrab(Nil,.F.)
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
        //cAlSC7:= CriaTrab(Nil,.F.)
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
        //cAlSC1:= CriaTrab(Nil,.F.)
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
        //cAlSA1 := CriaTrab(Nil,.F.)
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
        //cAlSB1 := CriaTrab(Nil,.F.)
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
    Local cSerie   := "001"
    Local cEmbExp  := ""
    Local cDoc     := ""
    Local aRet     := {}
    Local aNota    := {}
    Local lServic  := .F.
    //Local aMonit   := {}

    Local oWSNfs   := LIBGLASS():new()	

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

        lServic := (SB1->B1_TIPO == "SV")  //07/11/2025 - VERIFICA SE O TIPO DEO PRODUTO É SERVIÇO

        SB2->(DbSetOrder(1))
        SB2->(MsSeek(cFili+SC6->(C6_PRODUTO+C6_LOCAL))) //FILIAL+PRODUTO+LOCAL

        SF4->(DbSetOrder(1))
        SF4->(MsSeek(cFili+SC6->C6_TES))   //FILIAL+TES

        nPrcVen := SC9->C9_PRCVEN
        If ( SC5->C5_MOEDA <> 1 )
            nPrcVen := xMoeda(nPrcVen,SC5->C5_MOEDA,1,dDataBase)
        EndIf

        if EMPTY(SC9->C9_PEDIDO)
            EXIT
        EndIF

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
        SC6->(DbSkip())
    EndDo

    IF LEN(aPvlDocS) > 0
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
            cMensa := " "
            
            IF lServic
                    cRetorno := SpedNFeTrf("SF2",;
                    	SF2->F2_SERIE/*cSerie*/,;
                    	SF2->F2_DOC/*cNotaIni*/,;
                    	SF2->F2_DOC/*cNotaFim*/,;
                    	cIdEnt,;
                    	cAmbiente,;
                    	cModalidade,;
                    	cVersao,;
                    	@lEnd,;
                    	.F./*lCte*/,;
                    	.T.)      
                    // Sleep(8000)
                    Conout("Transmissao da nota: " + cDoc + " - " + cMensa + "  , gerado com sucesso!!!")
                    SpedNFe6Mnt( SF2->F2_SERIE/*cSerie*/,SF2->F2_DOC/*cNotaIni*/,SF2->F2_DOC/*cNotaFim*/,.T. /*lCTe*/) //não transmitir de primeiro
                    Conout("Transmissao da nota: " + cDoc + " - " + cMensa + "  , gerado com sucesso!!!")
            ELSE
                cFilNF  := Xfilial("SF2")
                cMensa  := oWSNfs:TransNfe(cDoc, cSerie)
                //cMensa  := oWSNfs:TrsMitNot( aNota ) //não transmitir de primeiro
                Conout("Transmissao da nota: " + cDoc + " - " + cMensa + "  , gerado com sucesso!!!")
                aMonit  := oWSNfs:MonitNf(aNota) //não transmitir de primeiro
            ENDIF

            aNota    := {}
            aPvlDocS := {}
        EndIf
    ENDIF
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
    Local cAlSA1 := GetNextAlias()

    cQuery := " SELECT A1_FILIAL, A1_COD, A1_LOJA, A1_NOME, A1_NREDUZ, A1_CGC, A1_END "
	cQuery += " FROM "+RetSQLName("SA1") + " AS SA1 WITH (NOLOCK) "
	cQuery += " WHERE A1_FILIAL = '" + FWxFilial("SA1") + "' "
    cQuery += " AND SA1.A1_CGC = '"+_cnpj+"' "
	cQuery += " AND SA1.D_E_L_E_T_ = '' AND SA1.A1_MSBLQL <> '1' "
	//cAlSA1:= CriaTrab(Nil,.F.)
	DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSA1, .F., .T.)    

    aadd(aRet, {(cAlSA1)->A1_COD, (cAlSA1)->A1_LOJA})

    (cAlSA1)->(dbclosearea())

Return aRet

Method pgFornec(_cnpj) class LIBGLASS
    Local aRet := {}
    Local cAlSA2 := GetNextAlias()

    cQuery := " SELECT A2_FILIAL, A2_COD, A2_LOJA, A2_NOME, A2_NREDUZ, A2_CGC, A2_END "
	cQuery += " FROM "+RetSQLName("SA2") + " AS SA2 WITH (NOLOCK) "
	cQuery += " WHERE A2_FILIAL = '" + FWxFilial("SA1") + "' AND SA2.A2_CGC = '"+_cnpj+"' "
	cQuery += " AND SA2.D_E_L_E_T_ = '' AND SA2.A2_MSBLQL <> '1' "
	//cAlSA2:= CriaTrab(Nil,.F.)
	DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSA2, .F., .T.)    

    aadd(aRet, {(cAlSA2)->A2_COD, (cAlSA2)->A2_LOJA})

    (cAlSA2)->(dbclosearea())

Return aRet

Method TesPDV(_prod, _client, _loja, _operac) CLASS LIBGLASS
	Local cTesIntel := ""
    Local cAlSFM := GetNextAlias()

    cQuery := " SELECT * "
	cQuery += " FROM "+RetSQLName("SFM") + " WITH (NOLOCK) "
	cQuery += " WHERE FM_FILIAL = '" + FWxFilial("SFM") + "' AND  FM_TIPO = '"+_operac+"' "
	cQuery += " AND D_E_L_E_T_ = '' "
	//cAlSFM:= CriaTrab(Nil,.F.)
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
    Local cAlSA2 := GetNextAlias()

    DO WHILE lTest
        _COD := GetSXENum("SA2","A2_COD")

        cQuery := " SELECT COUNT(*) AS NUM "
        cQuery += " FROM "+RetSQLName("SA2") + " AS SA2 WITH (NOLOCK) "
        cQuery += " WHERE A2_FILIAL = '" + FWxFilial("SA2") + "' AND A2_COD = '"+_COD+"' "
        //cAlSA2:= CriaTrab(Nil,.F.)
        DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSA2, .F., .T.)    

        IF (cAlSA2)->NUM > 0
            (cAlSA2)->(dbclosearea())
            CONFIRMSX8()
        ELSE
            cCod  := _COD
            lTest := .F.
            (cAlSA2)->(dbclosearea())
        ENDIF
    ENDDO

Return cCod

METHOD GerCdCli() class LIBGLASS
    Local lTest := .T.
    Local cAlSA1 := GetNextAlias()

    DO WHILE lTest
        _COD := GetSXENum("SA1","A1_COD")

        cQuery := " SELECT COUNT(*) AS NUM "
        cQuery += " FROM "+RetSQLName("SA1") + " AS SA1 WITH (NOLOCK) "
        cQuery += " WHERE A1_FILIAL = '" + FWxFilial("SA1") + "' AND A1_COD = '"+_COD+"' "
        //cAlSA1:= CriaTrab(Nil,.F.)
        DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSA1, .F., .T.)    

        IF (cAlSA1)->NUM > 0
            (cAlSA1)->(dbclosearea())
            CONFIRMSX8()
        ELSE
            cCod  := _COD
            lTest := .F.
            (cAlSA1)->(dbclosearea())
        ENDIF
    ENDDO

Return cCod

METHOD GrPedCom(cFilAt) class LIBGLASS
    Local lTest := .T.
    Local cAlSC7 := GetNextAlias()

    DO WHILE lTest
        _CODPED := GetSXENum("SC7","C7_NUM")

        cQuery := " SELECT COUNT(*) AS NUM "
        cQuery += " FROM "+RetSQLName("SC7") + " AS C7 WITH (NOLOCK) "
        cQuery += " WHERE C7_NUM = '"+_CODPED+"' "
        //cAlSC7:= CriaTrab(Nil,.F.)
        DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSC7, .F., .T.)    

        IF (cAlSC7)->NUM > 0
            (cAlSC7)->(dbclosearea())
            CONFIRMSX8()
        ELSE
            cCod  := _CODPED
            lTest := .F.
            (cAlSC7)->(dbclosearea())
        ENDIF
    ENDDO

Return cCod

METHOD PGExtrt(_EXTERNID) class LIBGLASS
    Local cPed := ""
    Local cAlSC7 := GetNextAlias()

    cQuery := " SELECT C7_NUM AS NUM "
    cQuery += " FROM "+RetSQLName("SC7") + " AS C7 WITH (NOLOCK) "
    cQuery += " WHERE C7.D_E_L_E_T_ <> '*' AND C7_ZIDPDCI = '"+_EXTERNID+"' "
    //cQuery += " WHERE C7.D_E_L_E_T_ <> '*' AND C7_ZEXTID = '"+_EXTERNID+"' "
    //cAlSC7:= CriaTrab(Nil,.F.)
    DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSC7, .F., .T.)    

    cPed := (cAlSC7)->NUM 
    (cAlSC7)->(dbclosearea())

Return cPed

METHOD GrPedVd(cFilAt) class LIBGLASS
    Local lTest := .T.
    Local cAlSC5 := GetNextAlias()

    DO WHILE lTest
        _CODPED := GetSXENum("SC5","C5_NUM")

        cQuery := " SELECT COUNT(*) AS NUM "
        cQuery += " FROM "+RetSQLName("SC5") + " AS C5 WITH (NOLOCK) "
        cQuery += " WHERE C5_NUM = '"+_CODPED+"' "
        //cAlSC5:= CriaTrab(Nil,.F.)
        DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSC5, .F., .T.)    

        IF (cAlSC5)->NUM > 0
            (cAlSC5)->(dbclosearea())
            CONFIRMSX8()
        ELSE
            cCod  := _CODPED
            lTest := .F.
            (cAlSC5)->(dbclosearea())
        ENDIF
    ENDDO

Return cCod

METHOD PGExtrtV(_EXTERNID) class LIBGLASS
    Local cPed := ""
    Local cAlSC5 := GetNextAlias()

    cQuery := " SELECT C5_NUM AS NUM "
    cQuery += " FROM "+RetSQLName("SC5") + " AS C5 WITH (NOLOCK) "
    cQuery += " WHERE C5.D_E_L_E_T_ <> '*' AND C5_ZIDPDVI = '"+_EXTERNID+"' "
    //cQuery += " WHERE C5.D_E_L_E_T_ <> '*' AND C5_ZEXTID = '"+_EXTERNID+"' "
    //cAlSC5:= CriaTrab(Nil,.F.)
    DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSC5, .F., .T.)    

    cPed := (cAlSC5)->NUM 
    (cAlSC5)->(dbclosearea())

Return cPed

METHOD PGExtDad(_EXTERNID) class LIBGLASS
    Local cSC7aL   := GetNextAlias()
    Local aRet     := {}

    cQuery := " SELECT * "
    cQuery += " FROM "+RetSQLName("SC7") + " AS C7 WITH (NOLOCK) "
    cQuery += " WHERE C7.D_E_L_E_T_ <> '*' AND C7_ZIDPDCI = '"+_EXTERNID+"' "
    //cQuery += " WHERE C7.D_E_L_E_T_ <> '*' AND C7_ZEXTID = '"+_EXTERNID+"' "
    //cAlSC7:= CriaTrab(Nil,.F.)
    DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cSC7aL, .F., .T.)    

    WHILE !(cSC7aL)->(EOF())
        aadd(aRet, {(cSC7aL)->C7_NUM,;
                    (cSC7aL)->C7_EMISSAO,;
                    (cSC7aL)->C7_MOEDA,;
                    (cSC7aL)->C7_TXMOEDA,;
                    (cSC7aL)->C7_FORNECE,;
                    (cSC7aL)->C7_LOJA,;
                    (cSC7aL)->C7_COND,;
                    (cSC7aL)->C7_CONTATO,;
                    (cSC7aL)->C7_FILENT,;
                    (cSC7aL)->C7_ZINTEGR,;
                    (cSC7aL)->C7_PRODUTO,;
                    (cSC7aL)->C7_QUANT,;
                    (cSC7aL)->C7_PRECO,;
                    (cSC7aL)->C7_DESC1,;
                    (cSC7aL)->C7_TOTAL,;
                    (cSC7aL)->C7_ITEM,;
                    (cSC7aL)->C7_UM,;
                    (cSC7aL)->C7_DESCRI,;
                    (cSC7aL)->C7_LOCAL,;
                    (cSC7aL)->C7_IPI,;
                    (cSC7aL)->C7_CC,;
                    (cSC7aL)->C7_OBS,;
                    (cSC7aL)->C7_CONTATO,;
                    (cSC7aL)->C7_DATPRF,;
                    (cSC7aL)->C7_EMISSAO,;
                    (cSC7aL)->C7_PICM,;
                    (cSC7aL)->C7_SEGURO,;
                    (cSC7aL)->C7_DESPESA,;
                    (cSC7aL)->C7_TXMOEDA,;
                    (cSC7aL)->C7_VALFRE,;
                    (cSC7aL)->C7_TES,;
                    (cSC7aL)->C7_BASESOL})
        (cSC7aL)->(DBSKIP())
        LOOP
    ENDDO
    (cSC7aL)->(dbclosearea())

Return aRet

METHOD PGExtPDV(_EXTERNID) class LIBGLASS
    Local cAlPDV    := GetNextAlias()
    Local aRet      := {}

    cQuery := " SELECT * "
    cQuery += " FROM "+RetSQLName("SC5") + " AS C5 "
    cQuery += " INNER JOIN "+RetSQLName("SC6") + " AS C6 "
    cQuery += " ON C5_NUM = C6_NUM AND C5_FILIAL = C6_FILIAL AND C5_CLIENTE = C6_CLI "
    cQuery += " AND C5_LOJACLI = C6_LOJA "
    cQuery += " WHERE C5.D_E_L_E_T_ <> '*' AND C5_ZIDPDVI = '"+_EXTERNID+"' "
    DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlPDV, .F., .T.)    

    WHILE !(cAlPDV)->(EOF())
        aadd(aRet, {(cAlPDV)->C5_NUM,;
                    (cAlPDV)->C5_EMISSAO,;
                    (cAlPDV)->C5_CLIENTE,;
                    (cAlPDV)->C5_LOJACLI,;
                    (cAlPDV)->C5_LOJAENT,;
                    (cAlPDV)->C5_CONDPAG,;
                    (cAlPDV)->C6_ITEM,;
                    (cAlPDV)->C6_PRODUTO,;
                    (cAlPDV)->C6_QTDVEN,;
                    (cAlPDV)->C6_PRCVEN,;
                    (cAlPDV)->C6_VALDESC,;
                    (cAlPDV)->C6_VALOR,;
                    (cAlPDV)->C6_OPER})

        SC9->(DBGoTop())
        SC9->(MsSeek(FWxFilial('SC9') + (cAlPDV)->C6_NUM + (cAlPDV)->C6_ITEM))
        While  !SC9->(EoF()) .And. SC9->(C9_FILIAL + C9_PEDIDO + C9_ITEM) == FWxFilial('SC9') + (cAlPDV)->(C6_NUM + C6_ITEM)
            SC9->(a460Estorna(.T.))
            SC9->(DbSkip())
        EndDo

        SC6->(DbGoTop())
        SC6->( MsSeek( FWxFilial("SC5") + (cAlPDV)->C5_NUM ) )
        While !SC6->(Eof()) .And. (cAlPDV)->C5_NUM == SC6->C6_NUM
            MaLibDoFat(;
                SC6->(RecNo()),; //nRegSC6
                SC6->C6_QTDVEN,; //nQtdaLib
                ,;               //lCredito
                ,;               //lEstoque
                .T.,;            //lAvCred
                .T.,;            //lAvEst
                .F.,;            //lLibPar
                .F.;             //lTrfLocal
            )
            SC6->(DbSkip())   
        EndDo        
    
        (cAlPDV)->(DBSKIP())
        LOOP
    ENDDO

    (cAlPDV)->(dbclosearea())

Return aRet


METHOD PGDSCPRD(cProdut) class LIBGLASS
    Local cRet := ""
    Local cAlSB1  := GetNextAlias()

    cQuery := " SELECT B1_DESC "
    cQuery += " FROM "+RetSQLName("SB1") + " AS B1 "
    cQuery += " WHERE B1.D_E_L_E_T_ <> '*' AND B1_COD = '"+cProdut+"' "
    cQuery += " AND B1_FILIAL = '"+ xFilial("SB1") +"' "
    DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSB1, .F., .T.)    

    cRet := (cAlSB1)->B1_DESC

    (cAlSB1)->(dbclosearea())

Return cRet

/*
METHOD PGTIPPRD(_EXTERNID, cFili) class LIBGLASS
    Local cRet   := ""
    Local cQuery := ""
    Local cAlPDV := GetNextAlias()

    cQuery := " SELECT * "
    cQuery += " FROM "+RetSQLName("SC5") + " AS C5 "
    cQuery += " INNER JOIN "+RetSQLName("SC6") + " AS C6 "
    cQuery += " ON C5_NUM = C6_NUM AND C5_FILIAL = C6_FILIAL AND C5_CLIENTE = C6_CLI "
    cQuery += " AND C5_LOJACLI = C6_LOJA "
    cQuery += " WHERE C5.D_E_L_E_T_ <> '*' AND C5_ZEXTID = '"+_EXTERNID+"' "
    DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlPDV, .F., .T.)    

    WHILE !(cAlPDV)->(EOF())
        
        cProdut := (cAlPDV)->C6_PRODUTO
        cDscPrd := (cAlPDV)->C6_DESCRI

        cQuery := " SELECT B1_TIPO "
        cQuery += " FROM "+RetSQLName("SB1") + " AS B1 "
        cQuery += " AND B1_FILIAL = '"+ cFili +"' "
        cQuery += " WHERE B1.D_E_L_E_T_ <> '*' AND B1_COD = '"+cProdut+"' "
        DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSB1, .F., .T.)    

        IF (cAlSB1)->B1_TIPO == "SV"
            // - DESCONTINUADO - NÃO DA CERTO
            //    cQuery := "UPDATE "+ RetSQLName("SC5")+" SET "
            //    cQuery += " C5_XMEMO = CONVERT(VARBINARY(MAX), "+_EXTERNID+" - "+ cDscPrd +" )  "
            //    cQuery += " WHERE C5_FILIAL = '"+cFili+"' AND "
            //    cQuery += " C5_NUM = '"+cC5Num+"'  "
            //    if TCSqlExec(cQuery) < 0
            //        ConOut("Erro na gravação do memo C5_XMEMO: " + TCSQLError())
            //        (cAlSB1)->(dbclosearea())
            //    else
            //        (cAlSB1)->(dbclosearea())
            //        TcSqlExec("COMMIT")
            //        Exit
            //    endif
            
            cRet := cDscPrd + " - " + _EXTERNID
            (cAlSB1)->(dbclosearea())
        ELSE
            (cAlSB1)->(dbclosearea())
        ENDIF
   
        (cAlPDV)->(DBSKIP())
        LOOP
    ENDDO

    (cAlPDV)->(dbclosearea())

Return cRet
*/

METHOD pgNat(cProdut) class LIBGLASS
    Local cRet := ""
    Local cAlSB1  := GetNextAlias()

    cQuery := " SELECT B1_XNATURE "
    cQuery += " FROM "+RetSQLName("SB1") + " AS B1 "
    cQuery += " WHERE B1.D_E_L_E_T_ <> '*' AND B1_COD = '"+cProdut+"' "
    cQuery += " AND B1_FILIAL = '"+ xFilial("SB1") +"' "
    DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSB1, .F., .T.)    

    if empty( (cAlSB1)->B1_XNATURE)
       cRet := "02.01.01"
    else
       cRet := (cAlSB1)->B1_XNATURE
    endif

    (cAlSB1)->(dbclosearea())

Return cRet

Method atuPEdC(_cNumPed, _cAprov, _ZEXTID ) class LIBGLASS
    Local cQuery := ""

    cQuery := "UPDATE "+ RetSQLName("SC7")+" SET "
    cQuery += " C7_APROV = '"+_cAprov+"' "
    cQuery += " WHERE C7_ZIDPDCI = '"+_ZEXTID+"' AND "
    //cQuery += " WHERE C7_ZEXTID = '"+_ZEXTID+"' AND "
    cQuery += " C7_NUM = '"+_cNumPed+"'  "
    if TCSqlExec(cQuery) < 0
        ConOut("Erro na gravação do memo C7_APROV: " + TCSQLError())
    else
        TcSqlExec("COMMIT")
    endif

Return 

method GerNFE(_EXTERNID, _CHVNFE, cOpc, dTalvc, cDoc, cSeri, _GRPNUM, _IDGRPNUM) class LIBGLASS
    Local X
    Local cAlSC7    := "SC724112025"//GetNextAlias()
    Local aRet      := {}
    Local aItemPC   := {}
    Local aMod      := {}
    Local aEnder    := {}
    Local aParamAux := {}
    Local aCab      := {}
    Local aItem     := {}

    Local nCount    := 0
    Local cBackFunName	:= FUNNAME()
    Local cLogErro  := ""
    //Local cDirLog   := '\x_logs\'

    cQuery := " SELECT * "
    cQuery += " FROM "+RetSQLName("SC7") + " AS C7 WITH (NOLOCK) "
    cQuery += " WHERE C7.D_E_L_E_T_ <> '*' AND C7_ZIDPDCI = '"+_IDGRPNUM+"' "
    DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSC7, .F., .T.)    

    nIt := 1
    WHILE !(cAlSC7)->(EOF())

        IF nIt == 1
            _FILIAL  := cFilAnt //FWxFilial("SC7")
            _FORNECE := (cAlSC7)->C7_FORNECE
            _LOJA    := (cAlSC7)->C7_LOJA
            _ID      := _EXTERNID
            _SERIE	 := IIF(EMPTY(cSeri), Substr(_CHVNFE,23,3), cSeri)
            _DOC     := IIF(EMPTY(cDoc), Substr(_CHVNFE,26,9), cDoc )  
            _EMISSAO := (cAlSC7)->C7_EMISSAO     
            _TIPO    := "N"  
            _PEDIDO  := (cAlSC7)->C7_NUM
            _COD     := (cAlSC7)->C7_PRODUTO
            _Natur   := PgNat( Substr( POSICIONE('SB1',1,Xfilial('SB1')+_COD, 'B1_CSUBG'),1,4) ) //'B1_XNATURE') 
            _TES     := (cAlSC7)->C7_TES

            Do Case
                Case _TES = "004"
                    _Specie	:= "NFS"
                Case _TES = "006"
                    _Specie	:= "ND"
                OtherWise
                    _Specie	:= "SPED"
            EndCase
            
            // _Specie  := IIF( (LEN(_CHVNFE) < 44), "NFS", "SPED") 

            aCab := {   {"F1_FILIAL"    ,_FILIAL                ,NIL,Nil},;
                        {"F1_TIPO" 	    ,_TIPO                  ,NIL,Nil},;
                        {"F1_FORMUL"	,"N"                    ,Nil,Nil},;
                        {"F1_DOC"       ,_DOC                   ,Nil,Nil},;
                        {"F1_SERIE"     ,_SERIE                 ,Nil,Nil},;
                        {"F1_EMISSAO"   ,ddatabase              ,Nil,Nil},;
                        {"F1_DTDIGIT"   ,ddatabase              ,Nil,Nil},;
                        {"F1_FORNECE"   ,_FORNECE               ,Nil,Nil},;
                        {"F1_LOJA"      ,"01"                   ,Nil,Nil},;
                        {"F1_CHVNFE"    ,_CHVNFE                ,Nil,Nil},;
                        {"F1_MOEDA"     ,1                      ,Nil,Nil},;
                        {"F1_TXMOEDA"   ,1                      ,Nil,NIL},;
			            {"F1_STATUS"    ,"A"                    ,Nil,NIL},;
                        {"F1_COND"      ,(cAlSC7)->C7_COND      ,Nil,Nil},;
                        {"E2_NATUREZ"   ,_Natur                 ,Nil,Nil},;                        
                        {"F1_ESPECIE"   ,_Specie                ,Nil,Nil} }
            nIt++
        Endif
    	aItemPC    := {}

        _COD       := (cAlSC7)->C7_PRODUTO
        _UM        := POSICIONE('SB1',1,Xfilial('SB1')+_COD,'B1_UM') 
        _ITEM      := (cAlSC7)->C7_ITEM
        _QUANT     := (cAlSC7)->C7_QUANT
        _VUNIT     := (cAlSC7)->C7_PRECO
        _TOTAL     := (cAlSC7)->C7_TOTAL
        _PICM      := (cAlSC7)->C7_PICM
        _TES       := (cAlSC7)->C7_TES
        _CC        := (cAlSC7)->C7_CC

        AADD(aEnder, {_COD, _QUANT} )

        AADD(aItemPC,{"D1_FILIAL"   ,_FILIAL            ,NIL} )
        AADD(aItemPC,{"D1_COD"      ,_COD               ,NIL} )
        AADD(aItemPC,{"D1_UM"       ,_UM                ,NIL} )
        AADD(aItemPC,{"D1_ITEM"     ,PADL(_ITEM,TAMSX3('D1_ITEM')[1],'0'),NIL} )
        AADD(aItemPC,{"D1_QUANT"    ,_QUANT      		,NIL} )
        AADD(aItemPC,{"D1_VUNIT"    ,_VUNIT             ,NIL} ) 
        AADD(aItemPC,{"D1_TOTAL"    ,_TOTAL 	        ,NIL} ) 
        AADD(aItemPC,{"D1_DOC"      ,_DOC               ,NIL} )
        AADD(aItemPC,{"D1_EMISSAO"  ,_EMISSAO		    ,NIL} )
        AADD(aItemPC,{"D1_TIPO"     ,_TIPO            	,NIL} )
        AADD(aItemPC,{"D1_SERIE"    ,_SERIE             ,NIL} )
        AADD(aItemPC,{"D1_FORNEC"   ,_FORNECE         	,NIL} )
        AADD(aItemPC,{"D1_LOJA"     ,_LOJA           	,NIL} )
        aAdd(aItemPC,{'D1_PICM'		,_PICM				,NIL} )
        aAdd(aItemPC,{'D1_LOCAL'	,'01'   			,NIL} )
        aAdd(aItemPC,{'D1_PEDIDO'	,_PEDIDO   			,NIL} )
        aAdd(aItemPC,{'D1_TES'	    ,_TES   			,NIL} )
        aAdd(aItemPC,{'D1_ITEMPC'   ,PADL(_ITEM,TAMSX3('D1_ITEMPC')[1],'0'),NIL} )        
        aAdd(aItemPC,{'D1_CC'	    ,_CC   			    ,NIL} )        
        aAdd(aItemPC,{'D1_LOTECTL'  ,""   			    ,NIL} )        
        aAdd(aItemPC,{"D1_IPI"		,0 				    ,Nil} )
        aAdd(aItemPC,{"D1_VALICM"	,0 				    ,Nil} )
        aAdd(aItemPC,{"D1_BASEICM"	,0 				    ,Nil} )
        aAdd(aItemPC,{"D1_VALIPI"	,0 				    ,Nil} )
        aAdd(aItemPC,{"D1_ICMSRET"	,0 				    ,Nil} ) 
        aAdd(aItemPC,{"D1_BRICMS"	,0				    ,Nil} )			  
        aAdd(aItemPC,{"D1_DESPESA"	,0                  ,Nil} )
        AADD(aItem,aItemPC)

        (cAlSC7)->(DBSKIP())
        LOOP
    ENDDO
    (cAlSC7)->(DBCLOSEAREA())

    if len(aCab) > 0
        lMsErroAuto := .F.

        aAdd(aParamAux, {"MV_PAR01", 2}) //-- Mostra Lanc. Contabil? 1 = Sim, 2 = NÃ£o
        aAdd(aParamAux, {"MV_PAR06", 2}) //-- Contabilizacao Online? 1 = Sim, 2 = NÃ£o

        aMod := SetModulo("SIGAEST", "EST")
        SETFUNNAME("MATA103")

        MSExecAuto({|x,y,z,k| MATA103(x,y,z,,,,k)},aCab,aItem, 3, aParamAux) //OPC 4 = CLASSIFICAÇÃO DOC. ENTRADA, 5-exclusao
        // MSExecAuto({|x,y,z,k| MATA103(x,y,z)},aCab,aItem, 3, aParamAux) //OPC 4 = CLASSIFICAÇÃO DOC. ENTRADA, 5-exclusao
        // MSExecAuto({|x,y,z,k,a,b| MATA103(x,y,z,,,,k,a,,,b)},aCab,aItens,nOpc,aParamAux,aItensRat,aCodRet)
        
        SETFUNNAME(cBackFunName)

        If lMsErroAuto
            ConOut("erro geracao NOTA ENTRADA")
            aAdd(aRet, {"erro geracao NOTA ENTRADA", .F.})
            aErroAuto  := GetAutoGRLog()
            For nCount := 1 To Len(aErroAuto)
                if nCount > 1
                    cLogErro += StrTran(StrTran(aErroAuto[nCount], "<", ""), "-", "") + " "
                endif
            Next nCount
            ConOut(cLogErro)
            //cArqLog := 'WSPEDVEND_New_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
            //MemoWrite(cDirLog + cArqLog, cLogErro)
            aAdd(aRet, aErroAuto)
        ELSE
            ConOut("Geracao NOTA ENTRADA - com SUCESSO")
            //ENDEREÇO
            For X := 1 TO LEN(aEnder)
                _COD       := aEnder[X,1]
                _QUANT     := aEnder[X,2]
                _LOCALIZ   := POSICIONE('SB1',1,Xfilial('SB1')+_COD,'B1_LOCALIZ') 
                _LOCAL     := POSICIONE('SB1',1,Xfilial('SB1')+_COD,'B1_LOCPAD') 
                IF _LOCALIZ == "S"
                    TMATA265(_COD, _QUANT, _LOCAL, _DOC, _SERIE, _FORNECE, _LOJA)
                ENDIF
            Next
            if !empty(dTalvc)
                AltVct(dTalvc, _EXTERNID, _GRPNUM, _IDGRPNUM)
            ENDIF
            //17/11/2025 - inclusão de alteração da dat de vencimento
                // if !empty(dTalvc)
                //     cQuery:="SELECT COUNT(*) QTD FROM "+RetSqlName("SE2")+" SE2 "
                //     cQSe2 :="WHERE SE2.D_E_L_E_T_=' ' AND "
                //     cQSe2 +="E2_FILIAL = '"+xFilial("SE2")+"' AND "
                //     cQSe2 +="E2_NUM = '"+_DOC+"' AND "
                //     cQSe2 +="E2_PREFIXO = '"+_SERIE+"' AND "
                //     cQSe2 +="E2_FORNECE = '"+_FORNECE+"' AND "
                //     cQSe2 +="E2_LOJA = '"+_LOJA+"' "
                //     QSE2 := mpSysOpenQuery(cQuery+cQSe2,"QSE2")
                //     If QSE2->QTD > 0 
                //         QATUE2 := mpSysOpenQuery("SELECT R_E_C_N_O_ RECNO FROM "+RetSqlName("SE2")+" SE2 "+cQSe2,"QATUE2")
                //         while (QATUE2)->(!eof())
                //             SE2->(dbGoto((QATUE2)->RECNO))
                //             RecLock("SE2",.F.)
                //                 SE2->E2_VENCTO  := StoD(dTalvc)
                //                 SE2->E2_VENCREA := StoD(dTalvc)
                //                 SE2->E2_ORDERID := _EXTERNID
                //                 SE2->E2_ZGRPNUM := _GRPNUM
                //                 SE2->E2_ZIDPDC  := _IDGRPNUM
                //             SE2->(MsUnlock())
                //             (QATUE2)->(dbSkip())
                //         enddo
                //         (QATUE2)->(dbCloseArea())
                //     Endif
                //     (QSE2)->(dbCloseArea())            
                // endif
            //17/11/2025
        endif
    endif

Return aRet

METHOD temPDV( _EXTIDPDV ) CLASS LIBGLASS
Return 

METHOD PGtIPcLI(_cLI, _lOJ) CLASS LIBGLASS
    cRet := ""
    Local cAlSA1  := GetNextAlias()

    cQuery := " SELECT * "
	cQuery += " FROM "+RetSQLName("SA1") + " AS SA1 WITH (NOLOCK) "
	cQuery += " WHERE SA1.A1_COD = '"+_cLI+"' AND SA1.A1_LOJA = '"+_lOJ+"' "
	cQuery += " AND SA1.D_E_L_E_T_ = '' "
	DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSA1, .F., .T.)    
    cRet := (cAlSA1)->A1_TIPO
    (cAlSA1)->(dbclosearea())

RETURN cRet

METHOD temCC( _cCusto ) CLASS LIBGLASS
    Local lRet   := .T.
    Local cDesCC := ""
    cDesCC := POSICIONE("CTT",1,xFilial("CTT")+Alltrim(_cCusto),"CTT_DESC01")

    IF EMPTY(_cCusto) .or. EMPTY(cDesCC)
        lRet := .F.
    ENDIF

Return lRet

METHOD TemCont( _Prod ) CLASS LIBGLASS
    Local cRet    := ""
    Local cContaC := ""
    cContaC := POSICIONE("SB1",1,xFilial("SB1")+Alltrim(_Prod),"B1_CONTA")

    IF !EMPTY(cContaC)
        cRet := cContaC
    ENDIF

Return cRet

Static Function PgNat(_Natur)
    Local cRet   := ""
    Local X      := 0
    Local aNtGrp := {   {'0102', '02.01.01'},;
                        {'0103', '02.01.01'},;
                        {'0101', '02.01.01'},;
                        {'0104', '02.01.01'},;
                        {'0404', '02.01.01'},;
                        {'0424', '02.01.01'},;
                        {'0428', '02.01.01'},;
                        {'0430', '02.01.01'},;
                        {'0431', '02.01.01'},;
                        {'0432', '02.01.01'},;
                        {'0426', '02.01.01'},;
                        {'0434', '02.01.01'},;
                        {'0435', '02.01.01'},;
                        {'0436', '02.01.01'},;
                        {'0429', '02.01.01'},;
                        {'0437', '02.01.01'},;
                        {'0438', '02.01.01'},;
                        {'0433', '02.01.01'},;
                        {'0439', '02.01.01'},;
                        {'0440', '02.01.01'},;
                        {'0441', '02.01.01'},;
                        {'0442', '02.01.01'},;
                        {'0427', '02.01.01'},;
                        {'0707', '02.01.01'},;
                        {'0808', '02.01.01'},;
                        {'0832', '02.01.01'},;
                        {'0838', '02.01.01'},;
                        {'0840', '02.01.01'},;
                        {'0809', '02.01.01'},;
                        {'1010', '02.01.01'},;  //19/11/2025 - INCLUIDO COMO PADRÃO - RENATA
                        {'1302', '02.01.02'},;
                        {'1301', '02.01.02'},;
                        {'1303', '02.01.02'},;
                        {'1304', '02.01.02'},;
                        {'1305', '02.01.02'},;
                        {'1306', '02.01.02'},;
                        {'1307', '02.01.02'},;
                        {'1309', '02.01.02'},;
                        {'1310', '02.01.02'},;
                        {'1401', '02.01.02'},;
                        {'1402', '02.01.02'},;
                        {'1500', '02.01.02'},;
                        {'1601', '02.01.02'} }

    FOR X := 1 TO LEN(aNtGrp)
        If aNtGrp[X,1] == _Natur
            cRet := aNtGrp[X,2]
        EndiF
    Next

Return cRet

// Static Function TMATA265a(cProd, _QUANT, _LOCAL, _DOC, _SERIE, _CLIFOR, _LOJA)
//     Local aCabSDA       := {}
//     Local aItSDB        := {}
//     Local _aItensSDB    := {}
//     Local _NUMSEQ       := ProxNum()    //GetSx8Num("SDA","DA_NUMSEQ")

//     Local cLocli        := "AFILIADO"

//     Private lMsErroAuto := .F.

//     //Cabecalho com a informação do item e NumSeq que sera endereçado.
//     aAdd(aCabSDA,{"DA_PRODUTO"	,cProd      ,Nil})
//     aAdd(aCabSDA,{"DA_DATA"	    ,dDataBase  ,Nil})
//     aAdd(aCabSDA,{"DA_LOCAL"	,_LOCAL     ,Nil})
//     aAdd(aCabSDA,{"DA_DOC"		,_DOC       ,Nil})
//     aAdd(aCabSDA,{"DA_SERIE"	,_SERIE     ,Nil})
//     aAdd(aCabSDA,{"DA_CLIFOR"	,_CLIFOR    ,Nil})
//     aAdd(aCabSDA,{"DA_LOJA"	    ,_LOJA      ,Nil})
//     aAdd(aCabSDA,{"DA_ORIGEM"	,"SD1"      ,Nil})    
//     aAdd(aCabSDA,{"DA_NUMSEQ"	,_NUMSEQ    ,Nil})
 
//     //Dados do item que será endereçado
//     aAdd(aitSDB, {"DB_ITEM"    ,"0001"         ,Nil} )
//     aAdd(aitSDB, {'DB_PRODUTO' ,cProd          ,NIL} )
//     aAdd(aitSDB, {"DB_ESTORNO" ," "            ,Nil} )
//     aAdd(aitSDB, {"DB_LOCALIZ" ,cLocli         ,Nil} )
//     aAdd(aitSDB, {"DB_LOCAL"   ,_LOCAL         ,Nil} )
//     aAdd(aitSDB, {"DB_QUANT"   ,_QUANT         ,Nil} )
//     aAdd(aitSDB, {"DB_DATA"    ,dDataBase      ,Nil} )
//     aadd(_aItensSDB,aitSDB)
 
//     //MATA265( aCabSDA, _aItensSDB, 3)
//     DbSelectArea("SDA")
//     dbSetOrder(1)
//     SDA->( dbSeek( xFilial("SDA")+ cProd + _LOCAL + _NUMSEQ + _DOC + _SERIE) )
		
//     DbSelectArea("SDB")
//     msExecAuto({|x,y,z| mata265(x,y,z)},aCabSDA,_aItensSDB,3)
//     If lMsErroAuto
//         aErroAuto  := GetAutoGRLog()
//         ConOut("erro Enderecamento DA NOTA ENTRADA")
//     Else
//         ConOut("Enderecamento realizado com sucesso - Nota de entrada")
//     Endif

//     ConfirmSX8() 

// Return

#Include "RwMake.CH"
#include "tbiconn.ch"
 
Static Function TMATA265(cProd, _QUANT, _LOCAL, _DOC, _SERIE, _CLIFOR, _LOJA)
    Local aCab      := {}
	Local aItens    := {}
    Local aItem     := {}
    Local cAltb     := "TBL24112025"//GetNextAlias()

    cQuery := " SELECT DA_FILIAL AS 'Filial',
    cQuery += " 	DA_PRODUTO AS 'Codigo',
    cQuery += " 	B1_DESC AS 'Descricao',
    cQuery += " 	DA_QTDORI,
    cQuery += " 	DA_SALDO,DA_DATA AS 'Data Entrada',
    cQuery += " 	DA_NUMSEQ AS 'NUMSEQ',
    cQuery += " 	DA_DOC,DA_SERIE ,DA_CLIFOR ,DA_LOJA ,DA_TIPONF as 'Tipo NF',
    cQuery += " 	DA_LOCAL,
    cQuery += " 	DA_CLIFOR,
    cQuery += " 	DA_LOJA,
    cQuery += " 	DA_DATA,
    cQuery += " 	DA_ORIGEM
    cQuery += " FROM "+RetSqlName("SDA")+","+RetSqlName("SB1") "
    cQuery += " WHERE SDA010.D_E_L_E_T_ = ' '
    cQuery += " 	AND SB1010.D_E_L_E_T_ = ' '
    cQuery += " 	AND DA_SALDO > 0
    cQuery += " 	AND B1_COD = DA_PRODUTO
    cQuery += " 	AND DA_DATA = '"+dToS( ddatabase )+"' "
    cQuery += " 	AND DA_CLIFOR = '"+_CLIFOR+"' "
    cQuery += " 	AND DA_LOJA = '"+_LOJA+"' "
    cQuery += " 	AND DA_DOC = '"+_DOC+"' "
    cQuery += " 	AND DA_PRODUTO = '"+cProd+"' "
    cQuery += " 	AND DA_LOCAL = '"+_LOCAL+"'
    DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAltb, .F., .T.)    
    //dbUseArea(.t.,"TOPCONN",tcGenQry(,,cQuery),"T01",.t.)

    cItem 	:= "0001"

    aAdd(aCab,{"DA_PRODUTO"	,(cAltb)->Codigo,Nil})
    aAdd(aCab,{"DA_DATA"	,(cAltb)->DA_DATA,Nil})
    aAdd(aCab,{"DA_LOCAL"	,(cAltb)->DA_LOCAL,Nil})
    aAdd(aCab,{"DA_DOC"		,(cAltb)->DA_DOC,Nil})
    aAdd(aCab,{"DA_SERIE"	,(cAltb)->DA_SERIE,Nil})
    aAdd(aCab,{"DA_CLIFOR"	,(cAltb)->DA_CLIFOR,Nil})
    aAdd(aCab,{"DA_LOJA"	,(cAltb)->DA_LOJA,Nil})
    aAdd(aCab,{"DA_ORIGEM"	,(cAltb)->DA_ORIGEM,Nil})
    aAdd(aCab,{"DA_NUMSEQ"	,(cAltb)->NUMSEQ,Nil})

    aAdd(aItem,{"DB_ITEM"	,cItem,Nil})
    aAdd(aItem,{"DB_PRODUTO",(cAltb)->Codigo,Nil})
    aAdd(aItem,{"DB_ESTORNO"," ",Nil})
    aAdd(aItem,{"DB_LOCALIZ","AFILIADO",Nil})
    aAdd(aItem,{"DB_LOCAL"	,(cAltb)->DA_LOCAL,Nil})
    aAdd(aItem,{"DB_QUANT"	,(cAltb)->DA_SALDO,Nil})
    aAdd(aItem,{"DB_DATA"	,dDataBase,Nil})
    aAdd(aItens,aItem)			
    
    lMsErroAuto	:= .F.
    IF !EMPTY((cAltb)->NUMSEQ)
        MSExecAuto({|x,y,z| MATA265(x,y,z)},aCab,aItens,3) 
        If lMsErroAuto
            ConOut("Erro na distribuicao")
            //aAdd(aRet, {"erro Distribuicao da NOTA ENTRADA", .F.})
            //MostraErro()
        EndIF
    ENDIF
    (cAltb)->(dbCloseArea())

Return

Method GRAVALOGZZE( nRecn, cExter, cMensRet, cCodRotin, cNomRti ) class LIBGLASS
    Local lRet := .T.

    ZZE->(dbGoto(nRecn))
    RecLock("ZZE",.F.)
        ZZE->ZZE_STATUS := "2"
        ZZE->ZZE_ERRO   := cMensRet
    ZZE->(MsUnlock())

Return lRet

Method mudaSts(nRecn, cExter, _status ) class LIBGLASS
    Local lRet := .T.
    ZZE->(dbGoto(nRecn))
    RecLock("ZZE",.F.)
        ZZE->ZZE_STATUS := _status
    ZZE->(MsUnlock())

Return lRet

Method ajustCC(cExter, cCC) class LIBGLASS
    Local cQuery := ""
    cQuery := "UPDATE "+RETSQLNAME("SC7")
    cQuery += "   SET C7_CC  =  '"+cCC+"' "
    cQuery += " WHERE D_E_L_E_T_ <> '*' "
    cQuery += "   AND C7_ZEXTID  =  '"+cExter+"' "
    TCSQLExec(cQuery)

Return 

Method GRVALGZZF( nRecn, cExter, cMensRet, cCodRotin, cNomRti ) class LIBGLASS
    UPD:= "UPDATE "+RETSQLNAME("ZZF")+" SET ZZF_STATUS = '2', ZZF_ERRO = CONVERT(VARBINARY(MAX), '"+cMensRet+"')"
    UPD+= "WHERE D_E_L_E_T_ <> '*'  "
    UPD+= "AND R_E_C_N_O_  = " + Alltrim(Str(nRecn)) + " "
    TCSQLEXEC(UPD)
Return 

Method mudaStsf(nRecn, cExter, _status ) class LIBGLASS
    UPD:= "UPDATE "+RETSQLNAME("ZZF")+" SET ZZF_STATUS = '"+_status+"' "
    UPD+= "WHERE D_E_L_E_T_ <> '*'  "
    UPD+= "AND R_E_C_N_O_  = " + Alltrim(Str(nRecn)) + " "
    TCSQLEXEC(UPD)
Return 

METHOD PGExtest(_EXTERNID) class LIBGLASS
    Local cAlSC7    := GetNextAlias()
    Local cAlSF4    := GetNextAlias()
    Local lRet      := .F.

    cQuery := " SELECT C7_TES "
    cQuery += " FROM "+RetSQLName("SC7") + " AS C7 WITH (NOLOCK) "
    cQuery += " WHERE C7.D_E_L_E_T_ <> '*' AND C7_ZIDPDCI = '"+_EXTERNID+"' "
    DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSC7, .F., .T.)    

    cTES := (cAlSC7)->C7_TES
    (cAlSC7)->(dbclosearea())

    cQuery := " SELECT F4_CODIGO "
    cQuery += " FROM "+RetSQLName("SF4") + " AS F4 WITH (NOLOCK) "
    cQuery += " WHERE F4.D_E_L_E_T_ <> '*' AND F4_FILIAL = '"+cFilAnt+"' AND  F4_ESTOQUE = 'S' AND F4_CODIGO = '"+cTES+"' "
    DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSF4, .F., .T.)    

    IF !EMPTY((cAlSF4)->F4_CODIGO)
        lRet := .T.
    ENDIF

    (cAlSF4)->(dbclosearea())

Return lRet

Static Function AltVct(dTalvc, _EXTERNID, _GRPNUM, _IDGRPNUM)
    Local cAlSE2  := "SE224112025"//GetNextAlias()

    cQuery :="SELECT R_E_C_N_O_ RECNO FROM "+RetSqlName("SE2")+" SE2 "
    cQuery +="WHERE SE2.D_E_L_E_T_=' ' AND "
    cQuery +="E2_FILIAL = '"+xFilial("SE2")+"' AND "
    cQuery +="E2_NUM = '"+_DOC+"' AND "
    cQuery +="E2_PREFIXO = '"+_SERIE+"' AND "
    cQuery +="E2_FORNECE = '"+_FORNECE+"' AND "
    cQuery +="E2_LOJA = '"+_LOJA+"' "
    DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSE2, .F., .T.)    
    while (cAlSE2)->(!eof())
        SE2->(dbGoto((cAlSE2)->RECNO))
        RecLock("SE2",.F.)
            SE2->E2_VENCTO  := StoD(dTalvc)
            SE2->E2_VENCREA := StoD(dTalvc)
            SE2->E2_ORDERID := _EXTERNID
            SE2->E2_ZGRPNUM := _GRPNUM
            SE2->E2_ZIDPDC  := _IDGRPNUM
        SE2->(MsUnlock())
        (cAlSE2)->(dbSkip())
    enddo
    (cAlSE2)->(DBCLOSEAREA())

Return


method EXCNFE() class LIBGLASS

    Local X
    Local aRet      := {}
    Local aMod      := {}
    Local aEnder    := {}
    Local aParamAux := {}
    Local aCab      := {}
    Local aItem     := {}
    Local aRexId    := {}

    nConte := 0
    aRexId := aOrId()
    FOR X := 1 TO LEN(aRexId)
        cQuery := " SELECT * "
        cQuery += " FROM "+RetSQLName("ZZE") + " 
        cQuery += " WHERE D_E_L_E_T_ <> '*' AND ZZE_ZEXTID = '"+aRexId[X]+"' "
        DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),"TZZE", .F., .T.)    

        _FILIAL := TZZE->ZZE_FILIAL
        _ZEXTID := TZZE->ZZE_ZEXTID

        TZZE->(DBCLOSEAREA())

        ZZE->(DBGoTop())
        ZZE->(DbSetOrder(2))
        ZZE->(dbSeek(_FILIAL+_ZEXTID))
        WHILE !ZZE->(EOF()) .AND. ZZE->ZZE_FILIAL == _FILIAL .AND. ZZE->ZZE_ZEXTID == _ZEXTID
            IF ZZE->ZZE_STATUS <> '1'
                ZZE->(DBSKIP())
                LOOP
            ENDIF

            nConte++
            _IDGRPNUM := ALLTRIM(ZZE->ZZE_ZGRPEN) + ALLTRIM(ZZE->ZZE_ZEXTID)

            IncProc("2 - Qtd: " + Alltrim(Str(nConte)) )
            CONOUT("Qtd: " + Alltrim(Str(nConte)))
            
            cEmpAt1 := cEmpAnt
            cFilAt1 := cFilAnt

            cEmpAt   := Iif(EMPTY(ZZE->ZZE_GRUPO),  "01", ZZE->ZZE_GRUPO)
            cFilAt   := Iif(EMPTY(ZZE->ZZE_FILIAL), "01", ZZE->ZZE_FILIAL)

            cEmpAnt  := cEmpAt
            cFilAnt  := cFilAt

            cEnum    := ZZE->ZZE_ZGRPEN
            cExter   := ZZE->ZZE_ZEXTID
            cDoc     := ZZE->ZZE_NUMNF
            cSeri    := ZZE->ZZE_SERNFE
            dAltVct  := ZZE->ZZE_DTALTE
            cChavNfe := ZZE->ZZE_CHVNF
            cCentCus := ZZE->ZZE_CC

            aEnder := EstPdg(_IDGRPNUM, cDoc, cSeri, cChavNfe)

            For X := 1 TO LEN(aEnder)
                _COD       := aEnder[X,1]
                _QUANT     := aEnder[X,2]

                aCab       := aEnder[X,3]
                aItem      := aEnder[X,4]
                aParamAux  := aEnder[X,5]

                _FORNECE   := aEnder[X,6]
                _LOJA      := aEnder[X,7]

                _LOCALIZ   := POSICIONE('SB1',1,Xfilial('SB1')+_COD,'B1_LOCALIZ') 
                _LOCAL     := POSICIONE('SB1',1,Xfilial('SB1')+_COD,'B1_LOCPAD') 
                IF _LOCALIZ == "S"
                    EXCL265(_COD, _QUANT, _LOCAL, cDoc, cSeri, _FORNECE, _LOJA)
                    lMsErroAuto := .F.
                    aMod := SetModulo("SIGAEST", "EST")
                    SETFUNNAME("MATA103")
                    if len(aCab) > 0
                        MSExecAuto({|x,y,z,k| MATA103(x,y,z,,,,k)},aCab,aItem, 5, aParamAux) //OPC 4 = CLASSIFICAÇÃO DOC. ENTRADA, 5-exclusao
                        If lMsErroAuto
                            ConOut("erro EXCLUSAO NOTA ENTRADA")
                        ELSE
                            RecLock("ZZE",.F.)
                                ZZE->ZZE_STATUS := "9"
                            ZZE->(MsUnlock())
                        endif
                    endif
                ELSE
                    lMsErroAuto := .F.
                    aMod := SetModulo("SIGAEST", "EST")
                    SETFUNNAME("MATA103")
                    if len(aCab) > 0
                        MSExecAuto({|x,y,z,k| MATA103(x,y,z,,,,k)},aCab,aItem, 5, aParamAux) //OPC 4 = CLASSIFICAÇÃO DOC. ENTRADA, 5-exclusao
                        If lMsErroAuto
                            ConOut("erro EXCLUSAO NOTA ENTRADA")
                        endif
                        RecLock("ZZE",.F.)
                            ZZE->ZZE_STATUS := "9"
                        ZZE->(MsUnlock())

                    endif
                ENDIF
            Next
            ZZE->(DBSKIP())
            LOOP
        ENDDO

    Next
Return aRet

Static Function EXCL265(cProd, _QUANT, _LOCAL, _DOC, _SERIE, _CLIFOR, _LOJA)
    Local aCab      := {}
	Local aItens    := {}
    Local aItem     := {}
    Local cAltb     := "TBL24112025"   //GetNextAlias()
    Local lRet      := .F.

    cQuery := " SELECT DA_FILIAL AS 'Filial',
    cQuery += " 	DA_PRODUTO AS 'Codigo',
    cQuery += " 	B1_DESC AS 'Descricao',
    cQuery += " 	DA_QTDORI,
    cQuery += " 	DA_SALDO,DA_DATA AS 'Data Entrada',
    cQuery += " 	DA_NUMSEQ AS 'NUMSEQ',
    cQuery += " 	DA_DOC,DA_SERIE ,DA_CLIFOR ,DA_LOJA ,DA_TIPONF as 'Tipo NF',
    cQuery += " 	DA_LOCAL,
    cQuery += " 	DA_CLIFOR,
    cQuery += " 	DA_LOJA,
    cQuery += " 	DA_DATA,
    cQuery += " 	DA_ORIGEM
    cQuery += " FROM "+RetSqlName("SDA")+","+RetSqlName("SB1") "
    cQuery += " WHERE SDA010.D_E_L_E_T_ = ' '
    cQuery += " 	AND SB1010.D_E_L_E_T_ = ' '
    cQuery += " 	AND DA_SALDO > 0
    cQuery += " 	AND B1_COD = DA_PRODUTO
    cQuery += " 	AND DA_DATA = '"+dToS( ddatabase )+"' "
    cQuery += " 	AND DA_CLIFOR = '"+_CLIFOR+"' "
    cQuery += " 	AND DA_LOJA = '"+_LOJA+"' "
    cQuery += " 	AND DA_DOC = '"+_DOC+"' "
    cQuery += " 	AND DA_PRODUTO = '"+cProd+"' "
    cQuery += " 	AND DA_LOCAL = '"+_LOCAL+"'
    DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAltb, .F., .T.)    

    cItem 	:= "0001"

    aAdd(aCab,{"DA_PRODUTO"	,(cAltb)->Codigo,Nil})
    aAdd(aCab,{"DA_DATA"	,(cAltb)->DA_DATA,Nil})
    aAdd(aCab,{"DA_LOCAL"	,(cAltb)->DA_LOCAL,Nil})
    aAdd(aCab,{"DA_DOC"		,(cAltb)->DA_DOC,Nil})
    aAdd(aCab,{"DA_SERIE"	,(cAltb)->DA_SERIE,Nil})
    aAdd(aCab,{"DA_CLIFOR"	,(cAltb)->DA_CLIFOR,Nil})
    aAdd(aCab,{"DA_LOJA"	,(cAltb)->DA_LOJA,Nil})
    aAdd(aCab,{"DA_ORIGEM"	,(cAltb)->DA_ORIGEM,Nil})
    aAdd(aCab,{"DA_NUMSEQ"	,(cAltb)->NUMSEQ,Nil})

    aAdd(aItem,{"DB_ITEM"	,cItem,Nil})
    aAdd(aItem,{"DB_PRODUTO",(cAltb)->Codigo,Nil})
    aAdd(aItem,{"DB_ESTORNO"," ",Nil})
    aAdd(aItem,{"DB_LOCALIZ","AFILIADO",Nil})
    aAdd(aItem,{"DB_LOCAL"	,(cAltb)->DA_LOCAL,Nil})
    aAdd(aItem,{"DB_QUANT"	,(cAltb)->DA_SALDO,Nil})
    aAdd(aItem,{"DB_DATA"	,dDataBase,Nil})
    aAdd(aItens,aItem)			
    
    lMsErroAuto	:= .F.
    IF !EMPTY((cAltb)->NUMSEQ)
        MSExecAuto({|x,y,z| MATA265(x,y,z)},aCab,aItens,4)  //4-ESTORNO
        If lMsErroAuto
            lRet := .T.
            ConOut("Erro Estorno da distribuicao")
        EndIF
    ENDIF
    (cAltb)->(dbCloseArea())

Return lRet

Static Function EstPdg(_IDGRPNUM, cDoc, cSeri, _CHVNFE)
    Local aRet   := {}
    Local cAlSC7 := "cAlSC7010101"
    Local aItem  := {}
    Local aCab   := {}
    Local aParamAux := {}

    cQuery := " SELECT * "
    cQuery += " FROM "+RetSQLName("SC7") + " AS C7 WITH (NOLOCK) "
    cQuery += " WHERE C7.D_E_L_E_T_ <> '*' AND C7_ZIDPDCI = '"+_IDGRPNUM+"' "
    DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSC7, .F., .T.)    
    nIt := 1
    WHILE !(cAlSC7)->(EOF())

        IF nIt == 1
            _FILIAL  := cFilAnt //FWxFilial("SC7")
            _FORNECE := (cAlSC7)->C7_FORNECE
            _LOJA    := (cAlSC7)->C7_LOJA
            _SERIE	 := IIF(EMPTY(cSeri), Substr(_CHVNFE,23,3), cSeri)
            _DOC     := IIF(EMPTY(cDoc), Substr(_CHVNFE,26,9), cDoc )  
            _EMISSAO := (cAlSC7)->C7_EMISSAO     
            _TIPO    := "N"  
            _PEDIDO  := (cAlSC7)->C7_NUM
            _COD     := (cAlSC7)->C7_PRODUTO
            _Natur   := PgNat( Substr( POSICIONE('SB1',1,Xfilial('SB1')+_COD, 'B1_CSUBG'),1,4) ) //'B1_XNATURE') 
            _TES     := (cAlSC7)->C7_TES

            Do Case
                Case _TES = "004"
                    _Specie	:= "NFS"
                Case _TES = "006"
                    _Specie	:= "ND"
                OtherWise
                    _Specie	:= "SPED"
            EndCase
            
            aCab := {   {"F1_FILIAL"    ,_FILIAL                ,NIL,Nil},;
                        {"F1_TIPO" 	    ,_TIPO                  ,NIL,Nil},;
                        {"F1_FORMUL"	,"N"                    ,Nil,Nil},;
                        {"F1_DOC"       ,_DOC                   ,Nil,Nil},;
                        {"F1_SERIE"     ,_SERIE                 ,Nil,Nil},;
                        {"F1_EMISSAO"   ,ddatabase              ,Nil,Nil},;
                        {"F1_DTDIGIT"   ,ddatabase              ,Nil,Nil},;
                        {"F1_FORNECE"   ,_FORNECE               ,Nil,Nil},;
                        {"F1_LOJA"      ,"01"                   ,Nil,Nil},;
                        {"F1_CHVNFE"    ,_CHVNFE                ,Nil,Nil},;
                        {"F1_MOEDA"     ,1                      ,Nil,Nil},;
                        {"F1_TXMOEDA"   ,1                      ,Nil,NIL},;
			            {"F1_STATUS"    ,"A"                    ,Nil,NIL},;
                        {"F1_COND"      ,(cAlSC7)->C7_COND      ,Nil,Nil},;
                        {"E2_NATUREZ"   ,_Natur                 ,Nil,Nil},;                        
                        {"F1_ESPECIE"   ,_Specie                ,Nil,Nil} }
            nIt++
        Endif
    	aItemPC    := {}

        _COD       := (cAlSC7)->C7_PRODUTO
        _UM        := POSICIONE('SB1',1,Xfilial('SB1')+_COD,'B1_UM') 
        _ITEM      := (cAlSC7)->C7_ITEM
        _QUANT     := (cAlSC7)->C7_QUANT
        _VUNIT     := (cAlSC7)->C7_PRECO
        _TOTAL     := (cAlSC7)->C7_TOTAL
        _PICM      := (cAlSC7)->C7_PICM
        _TES       := (cAlSC7)->C7_TES
        _CC        := (cAlSC7)->C7_CC

        AADD(aItemPC,{"D1_FILIAL"   ,_FILIAL            ,NIL} )
        AADD(aItemPC,{"D1_COD"      ,_COD               ,NIL} )
        AADD(aItemPC,{"D1_UM"       ,_UM                ,NIL} )
        AADD(aItemPC,{"D1_ITEM"     ,PADL(_ITEM,TAMSX3('D1_ITEM')[1],'0'),NIL} )
        AADD(aItemPC,{"D1_QUANT"    ,_QUANT      		,NIL} )
        AADD(aItemPC,{"D1_VUNIT"    ,_VUNIT             ,NIL} ) 
        AADD(aItemPC,{"D1_TOTAL"    ,_TOTAL 	        ,NIL} ) 
        AADD(aItemPC,{"D1_DOC"      ,_DOC               ,NIL} )
        AADD(aItemPC,{"D1_EMISSAO"  ,_EMISSAO		    ,NIL} )
        AADD(aItemPC,{"D1_TIPO"     ,_TIPO            	,NIL} )
        AADD(aItemPC,{"D1_SERIE"    ,_SERIE             ,NIL} )
        AADD(aItemPC,{"D1_FORNEC"   ,_FORNECE         	,NIL} )
        AADD(aItemPC,{"D1_LOJA"     ,_LOJA           	,NIL} )
        aAdd(aItemPC,{'D1_PICM'		,_PICM				,NIL} )
        aAdd(aItemPC,{'D1_LOCAL'	,'01'   			,NIL} )
        aAdd(aItemPC,{'D1_PEDIDO'	,_PEDIDO   			,NIL} )
        aAdd(aItemPC,{'D1_TES'	    ,_TES   			,NIL} )
        aAdd(aItemPC,{'D1_ITEMPC'   ,PADL(_ITEM,TAMSX3('D1_ITEMPC')[1],'0'),NIL} )        
        aAdd(aItemPC,{'D1_CC'	    ,_CC   			    ,NIL} )        
        aAdd(aItemPC,{'D1_LOTECTL'  ,""   			    ,NIL} )        
        aAdd(aItemPC,{"D1_IPI"		,0 				    ,Nil} )
        aAdd(aItemPC,{"D1_VALICM"	,0 				    ,Nil} )
        aAdd(aItemPC,{"D1_BASEICM"	,0 				    ,Nil} )
        aAdd(aItemPC,{"D1_VALIPI"	,0 				    ,Nil} )
        aAdd(aItemPC,{"D1_ICMSRET"	,0 				    ,Nil} ) 
        aAdd(aItemPC,{"D1_BRICMS"	,0				    ,Nil} )			  
        aAdd(aItemPC,{"D1_DESPESA"	,0                  ,Nil} )
        AADD(aItem,aItemPC)

        (cAlSC7)->(DBSKIP())
        LOOP
    ENDDO
    (cAlSC7)->(DBCLOSEAREA())

    aAdd(aParamAux, {"MV_PAR01", 2}) //-- Mostra Lanc. Contabil? 1 = Sim, 2 = NÃ£o
    aAdd(aParamAux, {"MV_PAR06", 2}) //-- Contabilizacao Online? 1 = Sim, 2 = NÃ£o
    
    AAdd(aRet,{_COD, _QUANT, aCab, aItem, aParamAux, _FORNECE, _LOJA })

Return aRet

//feito - descontinuado - ficar como historico
    // Static Function aOrIddescontinuada()
    //     Local aIdExt := {}

    //     AADD(aIdExt, '2862406')
    //     AADD(aIdExt, '2862421')
    //     AADD(aIdExt, '2862445')
    //     AADD(aIdExt, '2862448')
    //     AADD(aIdExt, '2862462')
    //     AADD(aIdExt, '2862477')
    //     AADD(aIdExt, '2862478')
    //     AADD(aIdExt, '2862533')
    //     AADD(aIdExt, '2862537')
    //     AADD(aIdExt, '2862553')
    //     AADD(aIdExt, '2834369')
    //     AADD(aIdExt, '2834374')
    //     AADD(aIdExt, '2834387')
    //     AADD(aIdExt, '2834387')
    //     AADD(aIdExt, '2834387')
    //     AADD(aIdExt, '2834389')
    //     AADD(aIdExt, '2834397')
    //     AADD(aIdExt, '2834407')
    //     AADD(aIdExt, '2834409')
    //     AADD(aIdExt, '2834409')
    //     AADD(aIdExt, '2834416')
    //     AADD(aIdExt, '2834420')
    //     AADD(aIdExt, '2834422')
    //     AADD(aIdExt, '2834434')
    //     AADD(aIdExt, '2834436')
    //     AADD(aIdExt, '2834438')
    //     AADD(aIdExt, '2834452')
    //     AADD(aIdExt, '2834454')
    //     AADD(aIdExt, '2834455')
    //     AADD(aIdExt, '2834481')
    //     AADD(aIdExt, '2834489')
    //     AADD(aIdExt, '2834525')
    //     AADD(aIdExt, '2834531')
    //     AADD(aIdExt, '2834547')
    //     AADD(aIdExt, '2834555')
    //     AADD(aIdExt, '2834574')
    //     AADD(aIdExt, '2834593')
    //     AADD(aIdExt, '2834596')
    //     AADD(aIdExt, '2834596')
    //     AADD(aIdExt, '2834626')
    //     AADD(aIdExt, '2834632')
    //     AADD(aIdExt, '2834634')
    //     AADD(aIdExt, '2834646')
    //     AADD(aIdExt, '2834660')
    //     AADD(aIdExt, '2834687')
    //     AADD(aIdExt, '2834690')
    //     AADD(aIdExt, '2834690')
    //     AADD(aIdExt, '2834695')
    //     AADD(aIdExt, '2834709')
    //     AADD(aIdExt, '2834715')
    //     AADD(aIdExt, '2834739')
    //     AADD(aIdExt, '2834741')
    //     AADD(aIdExt, '2834742')
    //     AADD(aIdExt, '2834754')
    //     AADD(aIdExt, '2834760')
    //     AADD(aIdExt, '2834779')
    //     AADD(aIdExt, '2834780')
    //     AADD(aIdExt, '2834781')
    //     AADD(aIdExt, '2834782')
    //     AADD(aIdExt, '2834782')
    //     AADD(aIdExt, '2834803')
    //     AADD(aIdExt, '2834811')
    //     AADD(aIdExt, '2834830')
    //     AADD(aIdExt, '2834833')
    //     AADD(aIdExt, '2834876')
    //     AADD(aIdExt, '2834895')
    //     AADD(aIdExt, '2834907')
    //     AADD(aIdExt, '2834916')
    //     AADD(aIdExt, '2834970')
    //     AADD(aIdExt, '2834972')
    //     AADD(aIdExt, '2834986')
    //     AADD(aIdExt, '2834997')
    //     AADD(aIdExt, '2835022')
    //     AADD(aIdExt, '2835029')
    //     AADD(aIdExt, '2835042')
    //     AADD(aIdExt, '2835042')
    //     AADD(aIdExt, '2835070')
    //     AADD(aIdExt, '2835081')
    //     AADD(aIdExt, '2835095')
    //     AADD(aIdExt, '2835109')
    //     AADD(aIdExt, '2835122')
    //     AADD(aIdExt, '2835136')
    //     AADD(aIdExt, '2835153')
    //     AADD(aIdExt, '2835159')
    //     AADD(aIdExt, '2835165')
    //     AADD(aIdExt, '2835167')
    //     AADD(aIdExt, '2835181')
    //     AADD(aIdExt, '2835182')
    //     AADD(aIdExt, '2835192')
    //     AADD(aIdExt, '2835199')
    //     AADD(aIdExt, '2835199')
    //     AADD(aIdExt, '2835222')
    //     AADD(aIdExt, '2835232')
    //     AADD(aIdExt, '2835241')
    //     AADD(aIdExt, '2835245')
    //     AADD(aIdExt, '2835247')
    //     AADD(aIdExt, '2835251')
    //     AADD(aIdExt, '2835252')
    //     AADD(aIdExt, '2862576')
    //     AADD(aIdExt, '2862632')
    //     AADD(aIdExt, '2862665')
    //     AADD(aIdExt, '2862667')
    //     AADD(aIdExt, '2862675')
    //     AADD(aIdExt, '2862684')
    //     AADD(aIdExt, '2862705')
    //     AADD(aIdExt, '2862744')
    //     AADD(aIdExt, '2862757')
    //     AADD(aIdExt, '2862798')
    //     AADD(aIdExt, '2862822')
    //     AADD(aIdExt, '2862836')
    //     AADD(aIdExt, '2862838')
    //     AADD(aIdExt, '2862842')
    //     AADD(aIdExt, '2862842')
    //     AADD(aIdExt, '2862884')
    //     AADD(aIdExt, '2862904')
    //     AADD(aIdExt, '2862913')
    //     AADD(aIdExt, '2862951')
    //     AADD(aIdExt, '2862951')
    //     AADD(aIdExt, '2863001')
    //     AADD(aIdExt, '2863042')
    //     AADD(aIdExt, '2863050')
    //     AADD(aIdExt, '2863059')
    //     AADD(aIdExt, '2863078')
    //     AADD(aIdExt, '2863078')
    //     AADD(aIdExt, '2863102')
    //     AADD(aIdExt, '2863147')
    //     AADD(aIdExt, '2863166')
    //     AADD(aIdExt, '2863206')
    //     AADD(aIdExt, '2863206')
    //     AADD(aIdExt, '2863236')
    //     AADD(aIdExt, '2863241')
    //     AADD(aIdExt, '2863249')
    //     AADD(aIdExt, '2863273')
    //     AADD(aIdExt, '2863297')
    //     AADD(aIdExt, '2863304')
    //     AADD(aIdExt, '2863318')
    //     AADD(aIdExt, '2863343')
    //     AADD(aIdExt, '2863357')
    //     AADD(aIdExt, '2863372')
    //     AADD(aIdExt, '2863381')
    //     AADD(aIdExt, '2863389')
    //     AADD(aIdExt, '2863403')
    //     AADD(aIdExt, '2863404')
    //     AADD(aIdExt, '2863411')
    //     AADD(aIdExt, '2863411')
    //     AADD(aIdExt, '2863414')
    //     AADD(aIdExt, '2863415')
    //     AADD(aIdExt, '2863427')
    //     AADD(aIdExt, '2863469')
    //     AADD(aIdExt, '2863477')
    //     AADD(aIdExt, '2863550')
    //     AADD(aIdExt, '2863566')
    //     AADD(aIdExt, '2863656')
    //     AADD(aIdExt, '2863678')
    //     AADD(aIdExt, '2863720')
    //     AADD(aIdExt, '2863720')
    //     AADD(aIdExt, '2863745')
    //     AADD(aIdExt, '2863748')
    //     AADD(aIdExt, '2863759')
    //     AADD(aIdExt, '2863792')
    //     AADD(aIdExt, '2863792')
    //     AADD(aIdExt, '2863801')
    //     AADD(aIdExt, '2863875')
    //     AADD(aIdExt, '2863878')
    //     AADD(aIdExt, '2863882')
    //     AADD(aIdExt, '2863920')
    //     AADD(aIdExt, '2863956')
    //     AADD(aIdExt, '2863963')
    //     AADD(aIdExt, '2864003')
    //     AADD(aIdExt, '2864007')
    //     AADD(aIdExt, '2864007')
    //     AADD(aIdExt, '2864021')
    //     AADD(aIdExt, '2864043')
    //     AADD(aIdExt, '2864052')
    //     AADD(aIdExt, '2864090')
    //     AADD(aIdExt, '2864100')
    //     AADD(aIdExt, '2864103')
    //     AADD(aIdExt, '2864135')
    //     AADD(aIdExt, '2835277')
    //     AADD(aIdExt, '2835277')
    //     AADD(aIdExt, '2835284')
    //     AADD(aIdExt, '2835300')
    //     AADD(aIdExt, '2835317')
    //     AADD(aIdExt, '2835317')
    //     AADD(aIdExt, '2835324')
    //     AADD(aIdExt, '2835324')
    //     AADD(aIdExt, '2835324')
    //     AADD(aIdExt, '2835329')
    //     AADD(aIdExt, '2835334')
    //     AADD(aIdExt, '2835335')
    //     AADD(aIdExt, '2835338')
    //     AADD(aIdExt, '2835360')
    //     AADD(aIdExt, '2835360')
    //     AADD(aIdExt, '2864185')
    //     AADD(aIdExt, '2864197')
    //     AADD(aIdExt, '2864210')
    //     AADD(aIdExt, '2864282')
    //     AADD(aIdExt, '2864292')
    //     AADD(aIdExt, '2864318')
    //     AADD(aIdExt, '2864386')
    //     AADD(aIdExt, '2864386')
    //     AADD(aIdExt, '2864399')
    //     AADD(aIdExt, '2864416')
    //     AADD(aIdExt, '2864418')
    //     AADD(aIdExt, '2864455')
    //     AADD(aIdExt, '2864489')
    //     AADD(aIdExt, '2864492')
    //     AADD(aIdExt, '2864499')
    //     AADD(aIdExt, '2864531')
    //     AADD(aIdExt, '2864563')
    //     AADD(aIdExt, '2864577')
    //     AADD(aIdExt, '2864587')
    //     AADD(aIdExt, '2864618')
    //     AADD(aIdExt, '2864629')
    //     AADD(aIdExt, '2864630')
    //     AADD(aIdExt, '2864691')
    //     AADD(aIdExt, '2864697')
    //     AADD(aIdExt, '2864704')
    //     AADD(aIdExt, '2864704')
    //     AADD(aIdExt, '2864750')
    //     AADD(aIdExt, '2864751')
    //     AADD(aIdExt, '2864753')
    //     AADD(aIdExt, '2864784')
    //     AADD(aIdExt, '2864789')
    //     AADD(aIdExt, '2864792')
    //     AADD(aIdExt, '2864796')
    //     AADD(aIdExt, '2864862')
    //     AADD(aIdExt, '2864862')
    //     AADD(aIdExt, '2864865')
    //     AADD(aIdExt, '2864887')
    //     AADD(aIdExt, '2864891')
    //     AADD(aIdExt, '2864892')
    //     AADD(aIdExt, '2864914')
    //     AADD(aIdExt, '2864934')
    //     AADD(aIdExt, '2864937')
    //     AADD(aIdExt, '2864945')
    //     AADD(aIdExt, '2864961')
    //     AADD(aIdExt, '2865003')
    //     AADD(aIdExt, '2865011')
    //     AADD(aIdExt, '2865011')
    //     AADD(aIdExt, '2865011')
    //     AADD(aIdExt, '2865037')
    //     AADD(aIdExt, '2865046')
    //     AADD(aIdExt, '2865046')
    //     AADD(aIdExt, '2865047')
    //     AADD(aIdExt, '2865061')
    //     AADD(aIdExt, '2865076')
    //     AADD(aIdExt, '2865085')
    //     AADD(aIdExt, '2865125')
    //     AADD(aIdExt, '2865145')
    //     AADD(aIdExt, '2865147')
    //     AADD(aIdExt, '2865147')
    //     AADD(aIdExt, '2865152')
    //     AADD(aIdExt, '2865170')
    //     AADD(aIdExt, '2865170')
    //     AADD(aIdExt, '2865196')
    //     AADD(aIdExt, '2865196')
    //     AADD(aIdExt, '2865211')
    //     AADD(aIdExt, '2865247')
    //     AADD(aIdExt, '2865283')
    //     AADD(aIdExt, '2865318')
    //     AADD(aIdExt, '2865320')
    //     AADD(aIdExt, '2865338')
    //     AADD(aIdExt, '2865364')
    //     AADD(aIdExt, '2865374')
    //     AADD(aIdExt, '2865389')
    //     AADD(aIdExt, '2865389')
    //     AADD(aIdExt, '2865416')
    //     AADD(aIdExt, '2865520')
    //     AADD(aIdExt, '2865530')
    //     AADD(aIdExt, '2865556')
    //     AADD(aIdExt, '2865558')
    //     AADD(aIdExt, '2865566')
    //     AADD(aIdExt, '2835383')
    //     AADD(aIdExt, '2835401')
    //     AADD(aIdExt, '2835410')
    //     AADD(aIdExt, '2865643')
    //     AADD(aIdExt, '2865649')
    //     AADD(aIdExt, '2865673')
    //     AADD(aIdExt, '2865673')
    //     AADD(aIdExt, '2865685')
    //     AADD(aIdExt, '2865697')
    //     AADD(aIdExt, '2865725')
    //     AADD(aIdExt, '2865766')
    //     AADD(aIdExt, '2865766')
    //     AADD(aIdExt, '2865791')
    //     AADD(aIdExt, '2865814')
    //     AADD(aIdExt, '2865819')
    //     AADD(aIdExt, '2865836')
    //     AADD(aIdExt, '2865839')
    //     AADD(aIdExt, '2865846')
    //     AADD(aIdExt, '2865846')
    //     AADD(aIdExt, '2865850')
    //     AADD(aIdExt, '2865867')
    //     AADD(aIdExt, '2865869')
    //     AADD(aIdExt, '2865879')
    //     AADD(aIdExt, '2865879')
    //     AADD(aIdExt, '2865882')
    //     AADD(aIdExt, '2865901')
    //     AADD(aIdExt, '2865921')
    //     AADD(aIdExt, '2865921')
    //     AADD(aIdExt, '2865988')
    //     AADD(aIdExt, '2865997')
    //     AADD(aIdExt, '2865999')
    //     AADD(aIdExt, '2866017')
    //     AADD(aIdExt, '2866024')
    //     AADD(aIdExt, '2866042')
    //     AADD(aIdExt, '2866049')
    //     AADD(aIdExt, '2866079')
    //     AADD(aIdExt, '2866081')
    //     AADD(aIdExt, '2866082')
    //     AADD(aIdExt, '2866090')
    //     AADD(aIdExt, '2866109')
    //     AADD(aIdExt, '2866124')
    //     AADD(aIdExt, '2866132')
    //     AADD(aIdExt, '2866134')
    //     AADD(aIdExt, '2866134')
    //     AADD(aIdExt, '2866136')
    //     AADD(aIdExt, '2866146')
    //     AADD(aIdExt, '2866264')
    //     AADD(aIdExt, '2866297')
    //     AADD(aIdExt, '2866298')
    //     AADD(aIdExt, '2866327')
    //     AADD(aIdExt, '2866349')
    //     AADD(aIdExt, '2866408')
    //     AADD(aIdExt, '2866408')
    //     AADD(aIdExt, '2866454')
    //     AADD(aIdExt, '2866458')
    //     AADD(aIdExt, '2866469')
    //     AADD(aIdExt, '2866582')
    //     AADD(aIdExt, '2866623')
    //     AADD(aIdExt, '2866648')
    //     AADD(aIdExt, '2866649')
    //     AADD(aIdExt, '2866686')
    //     AADD(aIdExt, '2866706')
    //     AADD(aIdExt, '2866706')
    //     AADD(aIdExt, '2866720')
    //     AADD(aIdExt, '2866762')
    //     AADD(aIdExt, '2866792')
    //     AADD(aIdExt, '2866830')
    //     AADD(aIdExt, '2866847')
    //     AADD(aIdExt, '2835429')
    //     AADD(aIdExt, '2835429')
    //     AADD(aIdExt, '2835430')
    //     AADD(aIdExt, '2835449')
    //     AADD(aIdExt, '2835461')
    //     AADD(aIdExt, '2835488')
    //     AADD(aIdExt, '2835496')
    //     AADD(aIdExt, '2835551')
    //     AADD(aIdExt, '2835552')
    //     AADD(aIdExt, '2835561')
    //     AADD(aIdExt, '2835572')
    //     AADD(aIdExt, '2835597')
    //     AADD(aIdExt, '2835607')
    //     AADD(aIdExt, '2835635')
    //     AADD(aIdExt, '2835635')
    //     AADD(aIdExt, '2835640')
    //     AADD(aIdExt, '2835641')
    //     AADD(aIdExt, '2835696')
    //     AADD(aIdExt, '2835698')
    //     AADD(aIdExt, '2835700')
    //     AADD(aIdExt, '2835701')
    //     AADD(aIdExt, '2835708')
    //     AADD(aIdExt, '2835709')
    //     AADD(aIdExt, '2835714')
    //     AADD(aIdExt, '2835722')
    //     AADD(aIdExt, '2835735')
    //     AADD(aIdExt, '2835735')
    //     AADD(aIdExt, '2835760')
    //     AADD(aIdExt, '2835766')
    //     AADD(aIdExt, '2835779')
    //     AADD(aIdExt, '2835780')
    //     AADD(aIdExt, '2835797')
    //     AADD(aIdExt, '2835798')
    //     AADD(aIdExt, '2835803')
    //     AADD(aIdExt, '2835844')
    //     AADD(aIdExt, '2835847')
    //     AADD(aIdExt, '2835852')
    //     AADD(aIdExt, '2835869')
    //     AADD(aIdExt, '2835885')
    //     AADD(aIdExt, '2835896')
    //     AADD(aIdExt, '2835896')
    //     AADD(aIdExt, '2835900')
    //     AADD(aIdExt, '2835907')
    //     AADD(aIdExt, '2835911')
    //     AADD(aIdExt, '2835914')
    //     AADD(aIdExt, '2835927')
    //     AADD(aIdExt, '2835928')
    //     AADD(aIdExt, '2835934')
    //     AADD(aIdExt, '2835940')
    //     AADD(aIdExt, '2835940')
    //     AADD(aIdExt, '2835941')
    //     AADD(aIdExt, '2835944')
    //     AADD(aIdExt, '2835944')
    //     AADD(aIdExt, '2835957')
    //     AADD(aIdExt, '2835967')
    //     AADD(aIdExt, '2836017')
    //     AADD(aIdExt, '2836024')
    //     AADD(aIdExt, '2836027')
    //     AADD(aIdExt, '2836033')
    //     AADD(aIdExt, '2836035')
    //     AADD(aIdExt, '2836045')
    //     AADD(aIdExt, '2836069')
    //     AADD(aIdExt, '2836080')
    //     AADD(aIdExt, '2836080')
    //     AADD(aIdExt, '2836081')
    //     AADD(aIdExt, '2836083')
    //     AADD(aIdExt, '2836090')
    //     AADD(aIdExt, '2836090')
    //     AADD(aIdExt, '2836094')
    //     AADD(aIdExt, '2836131')
    //     AADD(aIdExt, '2836139')
    //     AADD(aIdExt, '2836142')
    //     AADD(aIdExt, '2836142')
    //     AADD(aIdExt, '2836149')
    //     AADD(aIdExt, '2836154')
    //     AADD(aIdExt, '2836166')
    //     AADD(aIdExt, '2836168')
    //     AADD(aIdExt, '2836172')
    //     AADD(aIdExt, '2836189')
    //     AADD(aIdExt, '2836192')
    //     AADD(aIdExt, '2836198')
    //     AADD(aIdExt, '2836200')
    //     AADD(aIdExt, '2836211')
    //     AADD(aIdExt, '2836215')
    //     AADD(aIdExt, '2836227')
    //     AADD(aIdExt, '2836230')
    //     AADD(aIdExt, '2836231')
    //     AADD(aIdExt, '2836231')
    //     AADD(aIdExt, '2836246')
    //     AADD(aIdExt, '2836253')
    //     AADD(aIdExt, '2836266')
    //     AADD(aIdExt, '2836283')
    //     AADD(aIdExt, '2836291')
    //     AADD(aIdExt, '2836297')
    //     AADD(aIdExt, '2836314')
    //     AADD(aIdExt, '2836321')
    //     AADD(aIdExt, '2836329')
    //     AADD(aIdExt, '2836332')
    //     AADD(aIdExt, '2836352')
    //     AADD(aIdExt, '2836376')
    //     AADD(aIdExt, '2836382')
    //     AADD(aIdExt, '2836396')
    //     AADD(aIdExt, '2836400')
    //     AADD(aIdExt, '2836402')
    //     AADD(aIdExt, '2836412')
    //     AADD(aIdExt, '2836416')
    //     AADD(aIdExt, '2836421')
    //     AADD(aIdExt, '2836428')
    //     AADD(aIdExt, '2836441')
    //     AADD(aIdExt, '2836466')
    //     AADD(aIdExt, '2836484')
    //     AADD(aIdExt, '2836497')
    //     AADD(aIdExt, '2836506')
    //     AADD(aIdExt, '2836518')
    //     AADD(aIdExt, '2836520')
    //     AADD(aIdExt, '2836521')
    //     AADD(aIdExt, '2836533')
    //     AADD(aIdExt, '2836536')
    //     AADD(aIdExt, '2836542')
    //     AADD(aIdExt, '2836545')
    //     AADD(aIdExt, '2836558')
    //     AADD(aIdExt, '2836558')
    //     AADD(aIdExt, '2836579')
    //     AADD(aIdExt, '2836583')
    //     AADD(aIdExt, '2836583')
    //     AADD(aIdExt, '2836589')
    //     AADD(aIdExt, '2836597')
    //     AADD(aIdExt, '2836597')
    //     AADD(aIdExt, '2836600')
    //     AADD(aIdExt, '2836626')
    //     AADD(aIdExt, '2836626')
    //     AADD(aIdExt, '2836629')
    //     AADD(aIdExt, '2836674')
    //     AADD(aIdExt, '2836675')
    //     AADD(aIdExt, '2836689')
    //     AADD(aIdExt, '2836692')
    //     AADD(aIdExt, '2836709')
    //     AADD(aIdExt, '2836720')
    //     AADD(aIdExt, '2836720')
    //     AADD(aIdExt, '2836734')
    //     AADD(aIdExt, '2836741')
    //     AADD(aIdExt, '2836747')
    //     AADD(aIdExt, '2836750')
    //     AADD(aIdExt, '2836751')
    //     AADD(aIdExt, '2836758')
    //     AADD(aIdExt, '2836761')
    //     AADD(aIdExt, '2836798')
    //     AADD(aIdExt, '2836815')
    //     AADD(aIdExt, '2836833')
    //     AADD(aIdExt, '2836838')
    //     AADD(aIdExt, '2836862')
    //     AADD(aIdExt, '2836863')
    //     AADD(aIdExt, '2836876')
    //     AADD(aIdExt, '2836883')
    //     AADD(aIdExt, '2836885')
    //     AADD(aIdExt, '2836885')
    //     AADD(aIdExt, '2836907')
    //     AADD(aIdExt, '2836914')
    //     AADD(aIdExt, '2836916')
    //     AADD(aIdExt, '2836916')
    //     AADD(aIdExt, '2836919')
    //     AADD(aIdExt, '2836939')
    //     AADD(aIdExt, '2836952')
    //     AADD(aIdExt, '2836961')
    //     AADD(aIdExt, '2836983')
    //     AADD(aIdExt, '2836996')
    //     AADD(aIdExt, '2837003')
    //     AADD(aIdExt, '2837005')
    //     AADD(aIdExt, '2837011')
    //     AADD(aIdExt, '2837020')
    //     AADD(aIdExt, '2837028')
    //     AADD(aIdExt, '2837036')
    //     AADD(aIdExt, '2866876')
    //     AADD(aIdExt, '2866893')
    //     AADD(aIdExt, '2866954')
    //     AADD(aIdExt, '2866984')
    //     AADD(aIdExt, '2866996')
    //     AADD(aIdExt, '2867057')
    //     AADD(aIdExt, '2867064')
    //     AADD(aIdExt, '2867064')
    //     AADD(aIdExt, '2867112')
    //     AADD(aIdExt, '2867122')
    //     AADD(aIdExt, '2867129')
    //     AADD(aIdExt, '2867138')
    //     AADD(aIdExt, '2867200')
    //     AADD(aIdExt, '2867305')
    //     AADD(aIdExt, '2867352')
    //     AADD(aIdExt, '2867407')
    //     AADD(aIdExt, '2867461')
    //     AADD(aIdExt, '2867470')
    //     AADD(aIdExt, '2867542')
    //     AADD(aIdExt, '2867568')
    //     AADD(aIdExt, '2867610')
    //     AADD(aIdExt, '2867619')
    //     AADD(aIdExt, '2867636')
    //     AADD(aIdExt, '2867660')
    //     AADD(aIdExt, '2867724')
    //     AADD(aIdExt, '2867724')
    //     AADD(aIdExt, '2867742')
    //     AADD(aIdExt, '2867742')
    //     AADD(aIdExt, '2867748')
    //     AADD(aIdExt, '2867792')
    //     AADD(aIdExt, '2867935')
    //     AADD(aIdExt, '2867935')
    //     AADD(aIdExt, '2867981')
    //     AADD(aIdExt, '2868013')
    //     AADD(aIdExt, '2868017')
    //     AADD(aIdExt, '2868022')
    //     AADD(aIdExt, '2868022')
    //     AADD(aIdExt, '2868031')
    //     AADD(aIdExt, '2868053')
    //     AADD(aIdExt, '2837063')
    //     AADD(aIdExt, '2837067')
    //     AADD(aIdExt, '2837068')
    //     AADD(aIdExt, '2837068')
    //     AADD(aIdExt, '2837095')
    //     AADD(aIdExt, '2837095')
    //     AADD(aIdExt, '2837107')
    //     AADD(aIdExt, '2837110')
    //     AADD(aIdExt, '2837127')
    //     AADD(aIdExt, '2837138')
    //     AADD(aIdExt, '2837143')
    //     AADD(aIdExt, '2837148')
    //     AADD(aIdExt, '2837149')
    //     AADD(aIdExt, '2837168')
    //     AADD(aIdExt, '2837178')
    //     AADD(aIdExt, '2837179')
    //     AADD(aIdExt, '2837180')
    //     AADD(aIdExt, '2837194')
    //     AADD(aIdExt, '2837206')
    //     AADD(aIdExt, '2837206')
    //     AADD(aIdExt, '2837214')
    //     AADD(aIdExt, '2837263')
    //     AADD(aIdExt, '2837265')
    //     AADD(aIdExt, '2837276')
    //     AADD(aIdExt, '2837288')
    //     AADD(aIdExt, '2837340')
    //     AADD(aIdExt, '2837346')
    //     AADD(aIdExt, '2837353')
    //     AADD(aIdExt, '2837385')
    //     AADD(aIdExt, '2837385')
    //     AADD(aIdExt, '2837391')
    //     AADD(aIdExt, '2837394')
    //     AADD(aIdExt, '2837395')
    //     AADD(aIdExt, '2837399')
    //     AADD(aIdExt, '2837411')
    //     AADD(aIdExt, '2837414')
    //     AADD(aIdExt, '2837416')
    //     AADD(aIdExt, '2837416')
    //     AADD(aIdExt, '2837418')
    //     AADD(aIdExt, '2837434')
    //     AADD(aIdExt, '2837434')
    //     AADD(aIdExt, '2837437')
    //     AADD(aIdExt, '2837444')
    //     AADD(aIdExt, '2837455')
    //     AADD(aIdExt, '2837464')
    //     AADD(aIdExt, '2837479')
    //     AADD(aIdExt, '2837494')
    //     AADD(aIdExt, '2837510')
    //     AADD(aIdExt, '2837511')
    //     AADD(aIdExt, '2837511')
    //     AADD(aIdExt, '2837522')
    //     AADD(aIdExt, '2837529')
    //     AADD(aIdExt, '2837529')
    //     AADD(aIdExt, '2837540')
    //     AADD(aIdExt, '2837540')
    //     AADD(aIdExt, '2837547')
    //     AADD(aIdExt, '2837574')
    //     AADD(aIdExt, '2837576')
    //     AADD(aIdExt, '2837576')
    //     AADD(aIdExt, '2837580')
    //     AADD(aIdExt, '2837597')
    //     AADD(aIdExt, '2837597')
    //     AADD(aIdExt, '2837599')
    //     AADD(aIdExt, '2837622')
    //     AADD(aIdExt, '2837639')
    //     AADD(aIdExt, '2837656')
    //     AADD(aIdExt, '2837662')
    //     AADD(aIdExt, '2837678')
    //     AADD(aIdExt, '2837688')
    //     AADD(aIdExt, '2837700')
    //     AADD(aIdExt, '2837727')
    //     AADD(aIdExt, '2837740')
    //     AADD(aIdExt, '2837773')
    //     AADD(aIdExt, '2837774')
    //     AADD(aIdExt, '2837781')
    //     AADD(aIdExt, '2837784')
    //     AADD(aIdExt, '2837788')
    //     AADD(aIdExt, '2837811')
    //     AADD(aIdExt, '2837815')
    //     AADD(aIdExt, '2837833')
    //     AADD(aIdExt, '2837844')
    //     AADD(aIdExt, '2837844')
    //     AADD(aIdExt, '2837845')
    //     AADD(aIdExt, '2837846')
    //     AADD(aIdExt, '2837853')
    //     AADD(aIdExt, '2837855')
    //     AADD(aIdExt, '2837860')
    //     AADD(aIdExt, '2837862')
    //     AADD(aIdExt, '2837882')
    //     AADD(aIdExt, '2837885')
    //     AADD(aIdExt, '2837885')
    //     AADD(aIdExt, '2837889')
    //     AADD(aIdExt, '2837896')
    //     AADD(aIdExt, '2837899')
    //     AADD(aIdExt, '2837909')
    //     AADD(aIdExt, '2837926')
    //     AADD(aIdExt, '2837929')
    //     AADD(aIdExt, '2837930')
    //     AADD(aIdExt, '2837943')
    //     AADD(aIdExt, '2837944')
    //     AADD(aIdExt, '2837945')
    //     AADD(aIdExt, '2837947')
    //     AADD(aIdExt, '2837957')
    //     AADD(aIdExt, '2837958')
    //     AADD(aIdExt, '2837962')
    //     AADD(aIdExt, '2837974')
    //     AADD(aIdExt, '2837978')
    //     AADD(aIdExt, '2837986')
    //     AADD(aIdExt, '2837990')
    //     AADD(aIdExt, '2837993')
    //     AADD(aIdExt, '2837999')
    //     AADD(aIdExt, '2837999')
    //     AADD(aIdExt, '2838008')
    //     AADD(aIdExt, '2838011')
    //     AADD(aIdExt, '2838020')
    //     AADD(aIdExt, '2838022')
    //     AADD(aIdExt, '2838024')
    //     AADD(aIdExt, '2838026')
    //     AADD(aIdExt, '2838027')
    //     AADD(aIdExt, '2838030')
    //     AADD(aIdExt, '2838034')
    //     AADD(aIdExt, '2838036')
    //     AADD(aIdExt, '2838070')
    //     AADD(aIdExt, '2838074')
    //     AADD(aIdExt, '2838079')
    //     AADD(aIdExt, '2838079')
    //     AADD(aIdExt, '2838086')
    //     AADD(aIdExt, '2838103')
    //     AADD(aIdExt, '2838110')
    //     AADD(aIdExt, '2838110')
    //     AADD(aIdExt, '2838121')
    //     AADD(aIdExt, '2838121')
    //     AADD(aIdExt, '2838138')
    //     AADD(aIdExt, '2838140')
    //     AADD(aIdExt, '2838150')
    //     AADD(aIdExt, '2838151')
    //     AADD(aIdExt, '2838161')
    //     AADD(aIdExt, '2838172')
    //     AADD(aIdExt, '2838190')
    //     AADD(aIdExt, '2838190')
    //     AADD(aIdExt, '2838199')
    //     AADD(aIdExt, '2838210')
    //     AADD(aIdExt, '2838223')
    //     AADD(aIdExt, '2838237')
    //     AADD(aIdExt, '2838246')
    //     AADD(aIdExt, '2838246')
    //     AADD(aIdExt, '2838250')
    //     AADD(aIdExt, '2838282')
    //     AADD(aIdExt, '2838288')
    //     AADD(aIdExt, '2838296')
    //     AADD(aIdExt, '2838310')
    //     AADD(aIdExt, '2838323')
    //     AADD(aIdExt, '2838324')
    //     AADD(aIdExt, '2838324')
    //     AADD(aIdExt, '2838326')
    //     AADD(aIdExt, '2838332')
    //     AADD(aIdExt, '2838352')
    //     AADD(aIdExt, '2838354')
    //     AADD(aIdExt, '2838358')
    //     AADD(aIdExt, '2838360')
    //     AADD(aIdExt, '2838360')
    //     AADD(aIdExt, '2838365')
    //     AADD(aIdExt, '2838389')
    //     AADD(aIdExt, '2868083')
    //     AADD(aIdExt, '2868091')
    //     AADD(aIdExt, '2868113')
    //     AADD(aIdExt, '2868127')
    //     AADD(aIdExt, '2868146')
    //     AADD(aIdExt, '2868151')
    //     AADD(aIdExt, '2868162')
    //     AADD(aIdExt, '2868175')
    //     AADD(aIdExt, '2868175')
    //     AADD(aIdExt, '2868197')
    //     AADD(aIdExt, '2868252')
    //     AADD(aIdExt, '2868254')
    //     AADD(aIdExt, '2868346')
    //     AADD(aIdExt, '2868573')
    //     AADD(aIdExt, '2868592')
    //     AADD(aIdExt, '2868653')
    //     AADD(aIdExt, '2868721')
    //     AADD(aIdExt, '2868752')
    //     AADD(aIdExt, '2868786')
    //     AADD(aIdExt, '2868809')
    //     AADD(aIdExt, '2868855')
    //     AADD(aIdExt, '2869035')
    //     AADD(aIdExt, '2869065')
    //     AADD(aIdExt, '2869102')
    //     AADD(aIdExt, '2838394')
    //     AADD(aIdExt, '2838396')
    //     AADD(aIdExt, '2838429')
    //     AADD(aIdExt, '2838431')
    //     AADD(aIdExt, '2838433')
    //     AADD(aIdExt, '2838434')
    //     AADD(aIdExt, '2838439')
    //     AADD(aIdExt, '2838439')
    //     AADD(aIdExt, '2838442')
    //     AADD(aIdExt, '2838445')
    //     AADD(aIdExt, '2838446')
    //     AADD(aIdExt, '2838453')
    //     AADD(aIdExt, '2838460')
    //     AADD(aIdExt, '2838460')
    //     AADD(aIdExt, '2838460')
    //     AADD(aIdExt, '2838475')
    //     AADD(aIdExt, '2838475')
    //     AADD(aIdExt, '2838478')
    //     AADD(aIdExt, '2838497')
    //     AADD(aIdExt, '2838497')
    //     AADD(aIdExt, '2838537')
    //     AADD(aIdExt, '2838537')
    //     AADD(aIdExt, '2838552')
    //     AADD(aIdExt, '2838565')
    //     AADD(aIdExt, '2838570')
    //     AADD(aIdExt, '2838572')
    //     AADD(aIdExt, '2838583')
    //     AADD(aIdExt, '2838584')
    //     AADD(aIdExt, '2838584')
    //     AADD(aIdExt, '2838603')
    //     AADD(aIdExt, '2838603')
    //     AADD(aIdExt, '2838612')
    //     AADD(aIdExt, '2838621')
    //     AADD(aIdExt, '2838629')
    //     AADD(aIdExt, '2838629')
    //     AADD(aIdExt, '2838630')
    //     AADD(aIdExt, '2838631')
    //     AADD(aIdExt, '2838633')
    //     AADD(aIdExt, '2838649')
    //     AADD(aIdExt, '2838662')
    //     AADD(aIdExt, '2838679')
    //     AADD(aIdExt, '2838680')
    //     AADD(aIdExt, '2838698')
    //     AADD(aIdExt, '2838706')
    //     AADD(aIdExt, '2838707')
    //     AADD(aIdExt, '2838707')
    //     AADD(aIdExt, '2838708')
    //     AADD(aIdExt, '2838708')
    //     AADD(aIdExt, '2838716')
    //     AADD(aIdExt, '2838721')
    //     AADD(aIdExt, '2838723')
    //     AADD(aIdExt, '2838730')
    //     AADD(aIdExt, '2838730')
    //     AADD(aIdExt, '2838731')
    //     AADD(aIdExt, '2838752')
    //     AADD(aIdExt, '2838754')
    //     AADD(aIdExt, '2838754')
    //     AADD(aIdExt, '2838760')
    //     AADD(aIdExt, '2838773')
    //     AADD(aIdExt, '2838774')
    //     AADD(aIdExt, '2838785')
    //     AADD(aIdExt, '2838792')
    //     AADD(aIdExt, '2838803')
    //     AADD(aIdExt, '2838818')
    //     AADD(aIdExt, '2838822')
    //     AADD(aIdExt, '2838826')
    //     AADD(aIdExt, '2838835')
    //     AADD(aIdExt, '2838839')
    //     AADD(aIdExt, '2838839')
    //     AADD(aIdExt, '2838843')
    //     AADD(aIdExt, '2838843')
    //     AADD(aIdExt, '2838862')
    //     AADD(aIdExt, '2838866')
    //     AADD(aIdExt, '2838867')
    //     AADD(aIdExt, '2838873')
    //     AADD(aIdExt, '2838882')
    //     AADD(aIdExt, '2838889')
    //     AADD(aIdExt, '2838894')
    //     AADD(aIdExt, '2838898')
    //     AADD(aIdExt, '2838904')
    //     AADD(aIdExt, '2838904')
    //     AADD(aIdExt, '2838907')
    //     AADD(aIdExt, '2838922')
    //     AADD(aIdExt, '2838924')
    //     AADD(aIdExt, '2838943')
    //     AADD(aIdExt, '2838985')
    //     AADD(aIdExt, '2838992')
    //     AADD(aIdExt, '2838995')
    //     AADD(aIdExt, '2838995')
    //     AADD(aIdExt, '2839008')
    //     AADD(aIdExt, '2839037')
    //     AADD(aIdExt, '2839040')
    //     AADD(aIdExt, '2839040')
    //     AADD(aIdExt, '2839047')
    //     AADD(aIdExt, '2839052')
    //     AADD(aIdExt, '2839059')
    //     AADD(aIdExt, '2839063')
    //     AADD(aIdExt, '2839069')
    //     AADD(aIdExt, '2839089')
    //     AADD(aIdExt, '2839094')
    //     AADD(aIdExt, '2839095')
    //     AADD(aIdExt, '2839102')
    //     AADD(aIdExt, '2839119')
    //     AADD(aIdExt, '2839120')
    //     AADD(aIdExt, '2839121')
    //     AADD(aIdExt, '2839133')
    //     AADD(aIdExt, '2839144')
    //     AADD(aIdExt, '2839147')
    //     AADD(aIdExt, '2839156')
    //     AADD(aIdExt, '2839175')
    //     AADD(aIdExt, '2839182')
    //     AADD(aIdExt, '2839182')
    //     AADD(aIdExt, '2839185')
    //     AADD(aIdExt, '2839189')
    //     AADD(aIdExt, '2839204')
    //     AADD(aIdExt, '2839208')
    //     AADD(aIdExt, '2839209')
    //     AADD(aIdExt, '2839209')
    //     AADD(aIdExt, '2839210')
    //     AADD(aIdExt, '2839215')
    //     AADD(aIdExt, '2839217')
    //     AADD(aIdExt, '2839217')
    //     AADD(aIdExt, '2839229')
    //     AADD(aIdExt, '2839233')
    //     AADD(aIdExt, '2839242')
    //     AADD(aIdExt, '2839252')
    //     AADD(aIdExt, '2839262')
    //     AADD(aIdExt, '2839264')
    //     AADD(aIdExt, '2839264')
    //     AADD(aIdExt, '2839264')
    //     AADD(aIdExt, '2839268')
    //     AADD(aIdExt, '2839270')
    //     AADD(aIdExt, '2839270')
    //     AADD(aIdExt, '2839290')
    //     AADD(aIdExt, '2839294')
    //     AADD(aIdExt, '2839294')
    //     AADD(aIdExt, '2839297')
    //     AADD(aIdExt, '2839302')
    //     AADD(aIdExt, '2839307')
    //     AADD(aIdExt, '2839312')
    //     AADD(aIdExt, '2839321')
    //     AADD(aIdExt, '2839327')
    //     AADD(aIdExt, '2839328')
    //     AADD(aIdExt, '2839354')
    //     AADD(aIdExt, '2839356')
    //     AADD(aIdExt, '2839359')
    //     AADD(aIdExt, '2839382')
    //     AADD(aIdExt, '2839382')
    //     AADD(aIdExt, '2839384')
    //     AADD(aIdExt, '2839392')
    //     AADD(aIdExt, '2839392')
    //     AADD(aIdExt, '2839399')
    //     AADD(aIdExt, '2839402')
    //     AADD(aIdExt, '2839402')
    //     AADD(aIdExt, '2839410')
    //     AADD(aIdExt, '2839417')
    //     AADD(aIdExt, '2839450')
    //     AADD(aIdExt, '2839465')
    //     AADD(aIdExt, '2839468')
    //     AADD(aIdExt, '2839501')
    //     AADD(aIdExt, '2839501')
    //     AADD(aIdExt, '2839504')
    //     AADD(aIdExt, '2839526')
    //     AADD(aIdExt, '2839535')
    //     AADD(aIdExt, '2839535')
    //     AADD(aIdExt, '2839544')
    //     AADD(aIdExt, '2839562')
    //     AADD(aIdExt, '2839565')
    //     AADD(aIdExt, '2839565')
    //     AADD(aIdExt, '2839565')
    //     AADD(aIdExt, '2839565')
    //     AADD(aIdExt, '2839577')
    //     AADD(aIdExt, '2839579')
    //     AADD(aIdExt, '2839601')
    //     AADD(aIdExt, '2839605')
    //     AADD(aIdExt, '2839610')
    //     AADD(aIdExt, '2839613')
    //     AADD(aIdExt, '2839615')
    //     AADD(aIdExt, '2839616')
    //     AADD(aIdExt, '2839616')
    //     AADD(aIdExt, '2839617')
    //     AADD(aIdExt, '2839618')
    //     AADD(aIdExt, '2839631')
    //     AADD(aIdExt, '2839632')
    //     AADD(aIdExt, '2839641')
    //     AADD(aIdExt, '2839654')
    //     AADD(aIdExt, '2839657')
    //     AADD(aIdExt, '2839658')
    //     AADD(aIdExt, '2839658')
    //     AADD(aIdExt, '2869243')
    //     AADD(aIdExt, '2869294')
    //     AADD(aIdExt, '2869294')
    //     AADD(aIdExt, '2869294')
    //     AADD(aIdExt, '2839673')
    //     AADD(aIdExt, '2839673')
    //     AADD(aIdExt, '2839691')
    //     AADD(aIdExt, '2839729')
    //     AADD(aIdExt, '2839745')
    //     AADD(aIdExt, '2839747')
    //     AADD(aIdExt, '2839751')
    //     AADD(aIdExt, '2839756')
    //     AADD(aIdExt, '2839785')
    //     AADD(aIdExt, '2839788')
    //     AADD(aIdExt, '2839792')
    //     AADD(aIdExt, '2839795')
    //     AADD(aIdExt, '2839814')
    //     AADD(aIdExt, '2839826')
    //     AADD(aIdExt, '2839827')
    //     AADD(aIdExt, '2839828')
    //     AADD(aIdExt, '2839851')
    //     AADD(aIdExt, '2839856')
    //     AADD(aIdExt, '2839866')
    //     AADD(aIdExt, '2839892')
    //     AADD(aIdExt, '2839892')
    //     AADD(aIdExt, '2839894')
    //     AADD(aIdExt, '2839907')
    //     AADD(aIdExt, '2839915')
    //     AADD(aIdExt, '2839921')
    //     AADD(aIdExt, '2839928')
    //     AADD(aIdExt, '2839930')
    //     AADD(aIdExt, '2839936')
    //     AADD(aIdExt, '2839941')
    //     AADD(aIdExt, '2839952')
    //     AADD(aIdExt, '2839969')
    //     AADD(aIdExt, '2839970')
    //     AADD(aIdExt, '2839978')
    //     AADD(aIdExt, '2839980')
    //     AADD(aIdExt, '2839981')
    //     AADD(aIdExt, '2839990')
    //     AADD(aIdExt, '2839991')
    //     AADD(aIdExt, '2839995')
    //     AADD(aIdExt, '2839997')
    //     AADD(aIdExt, '2840001')
    //     AADD(aIdExt, '2840002')
    //     AADD(aIdExt, '2840014')
    //     AADD(aIdExt, '2840016')
    //     AADD(aIdExt, '2840016')
    //     AADD(aIdExt, '2840020')
    //     AADD(aIdExt, '2840024')
    //     AADD(aIdExt, '2840029')
    //     AADD(aIdExt, '2840030')
    //     AADD(aIdExt, '2840035')
    //     AADD(aIdExt, '2840050')
    //     AADD(aIdExt, '2840057')
    //     AADD(aIdExt, '2840064')
    //     AADD(aIdExt, '2840085')
    //     AADD(aIdExt, '2840086')
    //     AADD(aIdExt, '2840089')
    //     AADD(aIdExt, '2840089')
    //     AADD(aIdExt, '2840092')
    //     AADD(aIdExt, '2840094')
    //     AADD(aIdExt, '2840104')
    //     AADD(aIdExt, '2840105')
    //     AADD(aIdExt, '2840112')
    //     AADD(aIdExt, '2840114')
    //     AADD(aIdExt, '2840123')
    //     AADD(aIdExt, '2840132')
    //     AADD(aIdExt, '2840136')
    //     AADD(aIdExt, '2840145')
    //     AADD(aIdExt, '2840148')
    //     AADD(aIdExt, '2840161')
    //     AADD(aIdExt, '2840162')
    //     AADD(aIdExt, '2840164')
    //     AADD(aIdExt, '2840192')
    //     AADD(aIdExt, '2840197')
    //     AADD(aIdExt, '2840197')
    //     AADD(aIdExt, '2840205')
    //     AADD(aIdExt, '2840213')
    //     AADD(aIdExt, '2840219')
    //     AADD(aIdExt, '2840219')
    //     AADD(aIdExt, '2840231')
    //     AADD(aIdExt, '2840234')
    //     AADD(aIdExt, '2840234')
    //     AADD(aIdExt, '2840239')
    //     AADD(aIdExt, '2840254')
    //     AADD(aIdExt, '2840254')
    //     AADD(aIdExt, '2840267')
    //     AADD(aIdExt, '2840269')
    //     AADD(aIdExt, '2840277')
    //     AADD(aIdExt, '2840293')
    //     AADD(aIdExt, '2840293')
    //     AADD(aIdExt, '2840313')
    //     AADD(aIdExt, '2840346')
    //     AADD(aIdExt, '2840349')
    //     AADD(aIdExt, '2840354')
    //     AADD(aIdExt, '2840373')
    //     AADD(aIdExt, '2840373')
    //     AADD(aIdExt, '2840373')
    //     AADD(aIdExt, '2840404')
    //     AADD(aIdExt, '2840404')
    //     AADD(aIdExt, '2840426')
    //     AADD(aIdExt, '2840444')
    //     AADD(aIdExt, '2840445')
    //     AADD(aIdExt, '2840485')
    //     AADD(aIdExt, '2840486')
    //     AADD(aIdExt, '2840505')
    //     AADD(aIdExt, '2840543')
    //     AADD(aIdExt, '2840543')
    //     AADD(aIdExt, '2840569')
    //     AADD(aIdExt, '2840572')
    //     AADD(aIdExt, '2840572')
    //     AADD(aIdExt, '2840579')
    //     AADD(aIdExt, '2840593')
    //     AADD(aIdExt, '2840605')
    //     AADD(aIdExt, '2840606')
    //     AADD(aIdExt, '2840606')
    //     AADD(aIdExt, '2840614')
    //     AADD(aIdExt, '2840615')
    //     AADD(aIdExt, '2840625')
    //     AADD(aIdExt, '2840645')
    //     AADD(aIdExt, '2840646')
    //     AADD(aIdExt, '2840656')
    //     AADD(aIdExt, '2840659')
    //     AADD(aIdExt, '2840666')
    //     AADD(aIdExt, '2840671')
    //     AADD(aIdExt, '2840677')
    //     AADD(aIdExt, '2840683')
    //     AADD(aIdExt, '2840694')
    //     AADD(aIdExt, '2840699')
    //     AADD(aIdExt, '2840714')
    //     AADD(aIdExt, '2840714')
    //     AADD(aIdExt, '2840727')
    //     AADD(aIdExt, '2840727')
    //     AADD(aIdExt, '2840733')
    //     AADD(aIdExt, '2840740')
    //     AADD(aIdExt, '2840742')
    //     AADD(aIdExt, '2840749')
    //     AADD(aIdExt, '2840771')
    //     AADD(aIdExt, '2840797')
    //     AADD(aIdExt, '2840798')
    //     AADD(aIdExt, '2840816')
    //     AADD(aIdExt, '2840823')
    //     AADD(aIdExt, '2840836')
    //     AADD(aIdExt, '2840845')
    //     AADD(aIdExt, '2840862')
    //     AADD(aIdExt, '2840881')
    //     AADD(aIdExt, '2840886')
    //     AADD(aIdExt, '2840907')
    //     AADD(aIdExt, '2840912')
    //     AADD(aIdExt, '2840936')
    //     AADD(aIdExt, '2840945')
    //     AADD(aIdExt, '2840952')
    //     AADD(aIdExt, '2840953')
    //     AADD(aIdExt, '2840955')
    //     AADD(aIdExt, '2840970')
    //     AADD(aIdExt, '2840980')
    //     AADD(aIdExt, '2840998')
    //     AADD(aIdExt, '2840998')
    //     AADD(aIdExt, '2841002')
    //     AADD(aIdExt, '2841003')
    //     AADD(aIdExt, '2841014')
    //     AADD(aIdExt, '2841016')
    //     AADD(aIdExt, '2841018')
    //     AADD(aIdExt, '2841022')
    //     AADD(aIdExt, '2841023')
    //     AADD(aIdExt, '2841032')
    //     AADD(aIdExt, '2841033')
    //     AADD(aIdExt, '2841038')
    //     AADD(aIdExt, '2841042')
    //     AADD(aIdExt, '2841043')
    //     AADD(aIdExt, '2841043')
    //     AADD(aIdExt, '2841050')
    //     AADD(aIdExt, '2841054')
    //     AADD(aIdExt, '2841054')
    //     AADD(aIdExt, '2841071')
    //     AADD(aIdExt, '2841093')
    //     AADD(aIdExt, '2841096')
    //     AADD(aIdExt, '2841106')
    //     AADD(aIdExt, '2841133')
    //     AADD(aIdExt, '2841137')
    //     AADD(aIdExt, '2841137')
    //     AADD(aIdExt, '2841139')
    //     AADD(aIdExt, '2841153')
    //     AADD(aIdExt, '2841161')
    //     AADD(aIdExt, '2841161')
    //     AADD(aIdExt, '2841161')
    //     AADD(aIdExt, '2841162')
    //     AADD(aIdExt, '2841169')
    //     AADD(aIdExt, '2841170')
    //     AADD(aIdExt, '2841176')
    //     AADD(aIdExt, '2841177')
    //     AADD(aIdExt, '2841180')
    //     AADD(aIdExt, '2841180')
    //     AADD(aIdExt, '2841195')
    //     AADD(aIdExt, '2841198')
    //     AADD(aIdExt, '2841205')
    //     AADD(aIdExt, '2841206')
    //     AADD(aIdExt, '2841206')
    //     AADD(aIdExt, '2841215')
    //     AADD(aIdExt, '2841221')
    //     AADD(aIdExt, '2841227')
    //     AADD(aIdExt, '2841240')
    //     AADD(aIdExt, '2841275')
    //     AADD(aIdExt, '2841285')
    //     AADD(aIdExt, '2841287')
    //     AADD(aIdExt, '2841287')
    //     AADD(aIdExt, '2841291')
    //     AADD(aIdExt, '2841306')
    //     AADD(aIdExt, '2841317')
    //     AADD(aIdExt, '2841321')
    //     AADD(aIdExt, '2841327')
    //     AADD(aIdExt, '2841337')
    //     AADD(aIdExt, '2841355')
    //     AADD(aIdExt, '2841356')
    //     AADD(aIdExt, '2841369')
    //     AADD(aIdExt, '2841371')
    //     AADD(aIdExt, '2841389')
    //     AADD(aIdExt, '2841389')
    //     AADD(aIdExt, '2841421')
    //     AADD(aIdExt, '2841425')
    //     AADD(aIdExt, '2841447')
    //     AADD(aIdExt, '2841452')
    //     AADD(aIdExt, '2841454')
    //     AADD(aIdExt, '2841458')
    //     AADD(aIdExt, '2841458')
    //     AADD(aIdExt, '2841468')
    //     AADD(aIdExt, '2841468')
    //     AADD(aIdExt, '2841484')
    //     AADD(aIdExt, '2841484')
    //     AADD(aIdExt, '2841489')
    //     AADD(aIdExt, '2841493')
    //     AADD(aIdExt, '2841497')
    //     AADD(aIdExt, '2841498')
    //     AADD(aIdExt, '2841498')
    //     AADD(aIdExt, '2841498')
    //     AADD(aIdExt, '2841516')
    //     AADD(aIdExt, '2841524')
    //     AADD(aIdExt, '2841526')
    //     AADD(aIdExt, '2841526')
    //     AADD(aIdExt, '2841543')
    //     AADD(aIdExt, '2841547')
    //     AADD(aIdExt, '2841549')
    //     AADD(aIdExt, '2841576')
    //     AADD(aIdExt, '2841596')
    //     AADD(aIdExt, '2841604')
    //     AADD(aIdExt, '2841610')
    //     AADD(aIdExt, '2841614')
    //     AADD(aIdExt, '2841620')
    //     AADD(aIdExt, '2841627')
    //     AADD(aIdExt, '2841633')
    //     AADD(aIdExt, '2841645')
    //     AADD(aIdExt, '2841648')
    //     AADD(aIdExt, '2841650')
    //     AADD(aIdExt, '2841657')
    //     AADD(aIdExt, '2841661')
    //     AADD(aIdExt, '2841663')
    //     AADD(aIdExt, '2841666')
    //     AADD(aIdExt, '2841674')
    //     AADD(aIdExt, '2841685')
    //     AADD(aIdExt, '2841687')
    //     AADD(aIdExt, '2841690')
    //     AADD(aIdExt, '2841690')
    //     AADD(aIdExt, '2841694')
    //     AADD(aIdExt, '2841698')
    //     AADD(aIdExt, '2841698')
    //     AADD(aIdExt, '2841701')
    //     AADD(aIdExt, '2841704')
    //     AADD(aIdExt, '2841707')
    //     AADD(aIdExt, '2841710')
    //     AADD(aIdExt, '2841711')
    //     AADD(aIdExt, '2841713')
    //     AADD(aIdExt, '2841716')
    //     AADD(aIdExt, '2841716')
    //     AADD(aIdExt, '2841735')
    //     AADD(aIdExt, '2841749')
    //     AADD(aIdExt, '2841773')
    //     AADD(aIdExt, '2841773')
    //     AADD(aIdExt, '2841775')
    //     AADD(aIdExt, '2869422')
    //     AADD(aIdExt, '2869434')
    //     AADD(aIdExt, '2869449')
    //     AADD(aIdExt, '2869449')
    //     AADD(aIdExt, '2869472')
    //     AADD(aIdExt, '2869484')
    //     AADD(aIdExt, '2869664')
    //     AADD(aIdExt, '2869664')
    //     AADD(aIdExt, '2869818')
    //     AADD(aIdExt, '2869952')
    //     AADD(aIdExt, '2869984')
    //     AADD(aIdExt, '2870006')
    //     AADD(aIdExt, '2870030')
    //     AADD(aIdExt, '2870099')
    //     AADD(aIdExt, '2870136')
    //     AADD(aIdExt, '2870192')
    //     AADD(aIdExt, '2870243')
    //     AADD(aIdExt, '2870292')
    //     AADD(aIdExt, '2870316')
    //     AADD(aIdExt, '2870339')
    //     AADD(aIdExt, '2870339')
    //     AADD(aIdExt, '2870358')
    //     AADD(aIdExt, '2870379')
    //     AADD(aIdExt, '2870518')
    //     AADD(aIdExt, '2870533')
    //     AADD(aIdExt, '2870660')
    //     AADD(aIdExt, '2870664')
    //     AADD(aIdExt, '2870664')
    //     AADD(aIdExt, '2870730')
    //     AADD(aIdExt, '2870769')
    //     AADD(aIdExt, '2870791')
    //     AADD(aIdExt, '2870839')
    //     AADD(aIdExt, '2870870')
    //     AADD(aIdExt, '2841802')
    //     AADD(aIdExt, '2841833')
    //     AADD(aIdExt, '2841837')
    //     AADD(aIdExt, '2841844')
    //     AADD(aIdExt, '2841857')
    //     AADD(aIdExt, '2841857')
    //     AADD(aIdExt, '2841874')
    //     AADD(aIdExt, '2841896')
    //     AADD(aIdExt, '2841899')
    //     AADD(aIdExt, '2841900')
    //     AADD(aIdExt, '2841903')
    //     AADD(aIdExt, '2841904')
    //     AADD(aIdExt, '2841920')
    //     AADD(aIdExt, '2870916')
    //     AADD(aIdExt, '2871043')
    //     AADD(aIdExt, '2871044')
    //     AADD(aIdExt, '2871067')
    //     AADD(aIdExt, '2871098')
    //     AADD(aIdExt, '2871186')
    //     AADD(aIdExt, '2871211')
    //     AADD(aIdExt, '2871278')
    //     AADD(aIdExt, '2871299')
    //     AADD(aIdExt, '2871299')
    //     AADD(aIdExt, '2871306')
    //     AADD(aIdExt, '2871367')
    //     AADD(aIdExt, '2871369')
    //     AADD(aIdExt, '2871407')
    //     AADD(aIdExt, '2871414')
    //     AADD(aIdExt, '2871506')
    //     AADD(aIdExt, '2871606')
    //     AADD(aIdExt, '2871676')
    //     AADD(aIdExt, '2871676')
    //     AADD(aIdExt, '2871817')
    //     AADD(aIdExt, '2871995')
    //     AADD(aIdExt, '2872181')
    //     AADD(aIdExt, '2872244')
    //     AADD(aIdExt, '2872289')
    //     AADD(aIdExt, '2841921')
    //     AADD(aIdExt, '2841929')
    //     AADD(aIdExt, '2841932')
    //     AADD(aIdExt, '2841936')
    //     AADD(aIdExt, '2841937')
    //     AADD(aIdExt, '2841937')
    //     AADD(aIdExt, '2841939')
    //     AADD(aIdExt, '2841956')
    //     AADD(aIdExt, '2841956')
    //     AADD(aIdExt, '2841957')
    //     AADD(aIdExt, '2872494')
    //     AADD(aIdExt, '2872494')
    //     AADD(aIdExt, '2872494')
    //     AADD(aIdExt, '2872568')
    //     AADD(aIdExt, '2872676')
    //     AADD(aIdExt, '2873120')
    //     AADD(aIdExt, '2873120')
    //     AADD(aIdExt, '2873481')
    //     AADD(aIdExt, '2873805')
    //     AADD(aIdExt, '2873873')
    //     AADD(aIdExt, '2841969')
    //     AADD(aIdExt, '2841977')
    //     AADD(aIdExt, '2842003')
    //     AADD(aIdExt, '2842008')
    //     AADD(aIdExt, '2842024')
    //     AADD(aIdExt, '2842038')
    //     AADD(aIdExt, '2842039')
    //     AADD(aIdExt, '2842040')
    //     AADD(aIdExt, '2842078')
    //     AADD(aIdExt, '2842078')
    //     AADD(aIdExt, '2842096')
    //     AADD(aIdExt, '2842107')
    //     AADD(aIdExt, '2842119')
    //     AADD(aIdExt, '2842126')
    //     AADD(aIdExt, '2842130')
    //     AADD(aIdExt, '2842162')
    //     AADD(aIdExt, '2842168')
    //     AADD(aIdExt, '2842172')
    //     AADD(aIdExt, '2842173')
    //     AADD(aIdExt, '2842178')
    //     AADD(aIdExt, '2842178')
    //     AADD(aIdExt, '2842196')
    //     AADD(aIdExt, '2842200')
    //     AADD(aIdExt, '2842212')
    //     AADD(aIdExt, '2842215')
    //     AADD(aIdExt, '2842239')
    //     AADD(aIdExt, '2842240')
    //     AADD(aIdExt, '2842240')
    //     AADD(aIdExt, '2842241')
    //     AADD(aIdExt, '2842246')
    //     AADD(aIdExt, '2842255')
    //     AADD(aIdExt, '2842258')
    //     AADD(aIdExt, '2842268')
    //     AADD(aIdExt, '2842278')
    //     AADD(aIdExt, '2842293')
    //     AADD(aIdExt, '2842294')
    //     AADD(aIdExt, '2842300')
    //     AADD(aIdExt, '2842300')
    //     AADD(aIdExt, '2842301')
    //     AADD(aIdExt, '2842306')
    //     AADD(aIdExt, '2842324')
    //     AADD(aIdExt, '2842326')
    //     AADD(aIdExt, '2842334')
    //     AADD(aIdExt, '2842349')
    //     AADD(aIdExt, '2842349')
    //     AADD(aIdExt, '2842349')
    //     AADD(aIdExt, '2842353')
    //     AADD(aIdExt, '2842359')
    //     AADD(aIdExt, '2842367')
    //     AADD(aIdExt, '2842368')
    //     AADD(aIdExt, '2842369')
    //     AADD(aIdExt, '2842385')
    //     AADD(aIdExt, '2842450')
    //     AADD(aIdExt, '2842456')
    //     AADD(aIdExt, '2842470')
    //     AADD(aIdExt, '2842476')
    //     AADD(aIdExt, '2842478')
    //     AADD(aIdExt, '2842491')
    //     AADD(aIdExt, '2842492')
    //     AADD(aIdExt, '2842492')
    //     AADD(aIdExt, '2842494')
    //     AADD(aIdExt, '2842499')
    //     AADD(aIdExt, '2842503')
    //     AADD(aIdExt, '2842506')
    //     AADD(aIdExt, '2842528')
    //     AADD(aIdExt, '2842566')
    //     AADD(aIdExt, '2842566')
    //     AADD(aIdExt, '2842566')
    //     AADD(aIdExt, '2842567')
    //     AADD(aIdExt, '2842582')
    //     AADD(aIdExt, '2842584')
    //     AADD(aIdExt, '2842604')
    //     AADD(aIdExt, '2842606')
    //     AADD(aIdExt, '2842607')
    //     AADD(aIdExt, '2842607')
    //     AADD(aIdExt, '2842610')
    //     AADD(aIdExt, '2842618')
    //     AADD(aIdExt, '2842631')
    //     AADD(aIdExt, '2842634')
    //     AADD(aIdExt, '2842648')
    //     AADD(aIdExt, '2842649')
    //     AADD(aIdExt, '2842650')
    //     AADD(aIdExt, '2842665')
    //     AADD(aIdExt, '2842669')
    //     AADD(aIdExt, '2842677')
    //     AADD(aIdExt, '2842678')
    //     AADD(aIdExt, '2842681')
    //     AADD(aIdExt, '2842692')
    //     AADD(aIdExt, '2842695')
    //     AADD(aIdExt, '2842698')
    //     AADD(aIdExt, '2842701')
    //     AADD(aIdExt, '2842709')
    //     AADD(aIdExt, '2842711')
    //     AADD(aIdExt, '2842725')
    //     AADD(aIdExt, '2842747')
    //     AADD(aIdExt, '2842747')
    //     AADD(aIdExt, '2842762')
    //     AADD(aIdExt, '2842762')
    //     AADD(aIdExt, '2842763')
    //     AADD(aIdExt, '2842775')
    //     AADD(aIdExt, '2842786')
    //     AADD(aIdExt, '2842791')
    //     AADD(aIdExt, '2842812')
    //     AADD(aIdExt, '2842812')
    //     AADD(aIdExt, '2842818')
    //     AADD(aIdExt, '2842849')
    //     AADD(aIdExt, '2842855')
    //     AADD(aIdExt, '2842861')
    //     AADD(aIdExt, '2842864')
    //     AADD(aIdExt, '2842869')
    //     AADD(aIdExt, '2842869')
    //     AADD(aIdExt, '2842878')
    //     AADD(aIdExt, '2842888')
    //     AADD(aIdExt, '2842895')
    //     AADD(aIdExt, '2842900')
    //     AADD(aIdExt, '2842903')
    //     AADD(aIdExt, '2842903')
    //     AADD(aIdExt, '2842903')
    //     AADD(aIdExt, '2842909')
    //     AADD(aIdExt, '2842909')
    //     AADD(aIdExt, '2842915')
    //     AADD(aIdExt, '2842918')
    //     AADD(aIdExt, '2842918')
    //     AADD(aIdExt, '2842922')
    //     AADD(aIdExt, '2842925')
    //     AADD(aIdExt, '2842925')
    //     AADD(aIdExt, '2842926')
    //     AADD(aIdExt, '2842932')
    //     AADD(aIdExt, '2842939')
    //     AADD(aIdExt, '2842939')
    //     AADD(aIdExt, '2842970')
    //     AADD(aIdExt, '2842985')
    //     AADD(aIdExt, '2842989')
    //     AADD(aIdExt, '2842992')
    //     AADD(aIdExt, '2842999')
    //     AADD(aIdExt, '2843002')
    //     AADD(aIdExt, '2843006')
    //     AADD(aIdExt, '2843014')
    //     AADD(aIdExt, '2843021')
    //     AADD(aIdExt, '2843023')
    //     AADD(aIdExt, '2843023')
    //     AADD(aIdExt, '2843037')
    //     AADD(aIdExt, '2843044')
    //     AADD(aIdExt, '2843046')
    //     AADD(aIdExt, '2843053')
    //     AADD(aIdExt, '2843061')
    //     AADD(aIdExt, '2843072')
    //     AADD(aIdExt, '2843079')
    //     AADD(aIdExt, '2843083')
    //     AADD(aIdExt, '2843088')
    //     AADD(aIdExt, '2843090')
    //     AADD(aIdExt, '2843093')
    //     AADD(aIdExt, '2843122')
    //     AADD(aIdExt, '2843127')
    //     AADD(aIdExt, '2843133')
    //     AADD(aIdExt, '2843148')
    //     AADD(aIdExt, '2843173')
    //     AADD(aIdExt, '2843173')
    //     AADD(aIdExt, '2843174')
    //     AADD(aIdExt, '2843183')
    //     AADD(aIdExt, '2843189')
    //     AADD(aIdExt, '2843190')
    //     AADD(aIdExt, '2843191')
    //     AADD(aIdExt, '2843192')
    //     AADD(aIdExt, '2843196')
    //     AADD(aIdExt, '2843202')
    //     AADD(aIdExt, '2843221')
    //     AADD(aIdExt, '2843226')
    //     AADD(aIdExt, '2843237')
    //     AADD(aIdExt, '2843253')
    //     AADD(aIdExt, '2843257')
    //     AADD(aIdExt, '2843269')
    //     AADD(aIdExt, '2843269')
    //     AADD(aIdExt, '2843289')
    //     AADD(aIdExt, '2843299')
    //     AADD(aIdExt, '2843299')
    //     AADD(aIdExt, '2843304')
    //     AADD(aIdExt, '2843323')
    //     AADD(aIdExt, '2843331')
    //     AADD(aIdExt, '2843342')
    //     AADD(aIdExt, '2843358')
    //     AADD(aIdExt, '2843369')
    //     AADD(aIdExt, '2843371')
    //     AADD(aIdExt, '2843383')
    //     AADD(aIdExt, '2843398')
    //     AADD(aIdExt, '2843404')
    //     AADD(aIdExt, '2843418')
    //     AADD(aIdExt, '2843427')
    //     AADD(aIdExt, '2843432')
    //     AADD(aIdExt, '2843433')
    //     AADD(aIdExt, '2843441')
    //     AADD(aIdExt, '2843446')
    //     AADD(aIdExt, '2843468')
    //     AADD(aIdExt, '2843468')
    //     AADD(aIdExt, '2843469')
    //     AADD(aIdExt, '2843484')
    //     AADD(aIdExt, '2843488')
    //     AADD(aIdExt, '2843492')
    //     AADD(aIdExt, '2843500')
    //     AADD(aIdExt, '2843507')
    //     AADD(aIdExt, '2843509')
    //     AADD(aIdExt, '2843513')
    //     AADD(aIdExt, '2843517')
    //     AADD(aIdExt, '2843525')
    //     AADD(aIdExt, '2843525')
    //     AADD(aIdExt, '2843527')
    //     AADD(aIdExt, '2843529')
    //     AADD(aIdExt, '2843559')
    //     AADD(aIdExt, '2843563')
    //     AADD(aIdExt, '2843563')
    //     AADD(aIdExt, '2843570')
    //     AADD(aIdExt, '2843587')
    //     AADD(aIdExt, '2843587')
    //     AADD(aIdExt, '2843587')
    //     AADD(aIdExt, '2843588')
    //     AADD(aIdExt, '2874234')
    //     AADD(aIdExt, '2874234')
    //     AADD(aIdExt, '2874307')
    //     AADD(aIdExt, '2874534')
    //     AADD(aIdExt, '2874534')
    //     AADD(aIdExt, '2874638')
    //     AADD(aIdExt, '2874730')
    //     AADD(aIdExt, '2874748')
    //     AADD(aIdExt, '2875230')
    //     AADD(aIdExt, '2875291')
    //     AADD(aIdExt, '2843613')
    //     AADD(aIdExt, '2843629')
    //     AADD(aIdExt, '2843636')
    //     AADD(aIdExt, '2843647')
    //     AADD(aIdExt, '2843652')
    //     AADD(aIdExt, '2843658')
    //     AADD(aIdExt, '2843664')
    //     AADD(aIdExt, '2843669')
    //     AADD(aIdExt, '2843678')
    //     AADD(aIdExt, '2843690')
    //     AADD(aIdExt, '2843699')
    //     AADD(aIdExt, '2843704')
    //     AADD(aIdExt, '2843704')
    //     AADD(aIdExt, '2843712')
    //     AADD(aIdExt, '2843715')
    //     AADD(aIdExt, '2843724')
    //     AADD(aIdExt, '2843726')
    //     AADD(aIdExt, '2843731')
    //     AADD(aIdExt, '2843733')
    //     AADD(aIdExt, '2843742')
    //     AADD(aIdExt, '2843743')
    //     AADD(aIdExt, '2843747')
    //     AADD(aIdExt, '2843788')
    //     AADD(aIdExt, '2843788')
    //     AADD(aIdExt, '2843793')
    //     AADD(aIdExt, '2843799')
    //     AADD(aIdExt, '2843818')
    //     AADD(aIdExt, '2843831')
    //     AADD(aIdExt, '2843833')
    //     AADD(aIdExt, '2843837')
    //     AADD(aIdExt, '2843845')
    //     AADD(aIdExt, '2843862')
    //     AADD(aIdExt, '2843866')
    //     AADD(aIdExt, '2843877')
    //     AADD(aIdExt, '2843877')
    //     AADD(aIdExt, '2843880')
    //     AADD(aIdExt, '2843901')
    //     AADD(aIdExt, '2843908')
    //     AADD(aIdExt, '2843910')
    //     AADD(aIdExt, '2843910')
    //     AADD(aIdExt, '2843916')
    //     AADD(aIdExt, '2843921')
    //     AADD(aIdExt, '2843925')
    //     AADD(aIdExt, '2843925')
    //     AADD(aIdExt, '2843927')
    //     AADD(aIdExt, '2843930')
    //     AADD(aIdExt, '2843974')
    //     AADD(aIdExt, '2843988')
    //     AADD(aIdExt, '2843988')
    //     AADD(aIdExt, '2843992')
    //     AADD(aIdExt, '2843992')
    //     AADD(aIdExt, '2843995')
    //     AADD(aIdExt, '2844002')
    //     AADD(aIdExt, '2844017')
    //     AADD(aIdExt, '2844096')
    //     AADD(aIdExt, '2844114')
    //     AADD(aIdExt, '2844123')
    //     AADD(aIdExt, '2844137')
    //     AADD(aIdExt, '2844138')
    //     AADD(aIdExt, '2844144')
    //     AADD(aIdExt, '2844148')
    //     AADD(aIdExt, '2844150')
    //     AADD(aIdExt, '2844154')
    //     AADD(aIdExt, '2844156')
    //     AADD(aIdExt, '2844156')
    //     AADD(aIdExt, '2844173')
    //     AADD(aIdExt, '2844173')
    //     AADD(aIdExt, '2844181')
    //     AADD(aIdExt, '2844181')
    //     AADD(aIdExt, '2844183')
    //     AADD(aIdExt, '2844188')
    //     AADD(aIdExt, '2844189')
    //     AADD(aIdExt, '2844190')
    //     AADD(aIdExt, '2844194')
    //     AADD(aIdExt, '2844196')
    //     AADD(aIdExt, '2844197')
    //     AADD(aIdExt, '2844198')
    //     AADD(aIdExt, '2844202')
    //     AADD(aIdExt, '2844203')
    //     AADD(aIdExt, '2844225')
    //     AADD(aIdExt, '2844238')
    //     AADD(aIdExt, '2844255')
    //     AADD(aIdExt, '2844270')
    //     AADD(aIdExt, '2844274')
    //     AADD(aIdExt, '2844281')
    //     AADD(aIdExt, '2844281')
    //     AADD(aIdExt, '2844284')
    //     AADD(aIdExt, '2844286')
    //     AADD(aIdExt, '2844290')
    //     AADD(aIdExt, '2844318')
    //     AADD(aIdExt, '2844320')
    //     AADD(aIdExt, '2844335')
    //     AADD(aIdExt, '2844337')
    //     AADD(aIdExt, '2844337')
    //     AADD(aIdExt, '2844346')
    //     AADD(aIdExt, '2844346')
    //     AADD(aIdExt, '2844348')
    //     AADD(aIdExt, '2844365')
    //     AADD(aIdExt, '2844367')
    //     AADD(aIdExt, '2844376')
    //     AADD(aIdExt, '2844377')
    //     AADD(aIdExt, '2844387')
    //     AADD(aIdExt, '2844390')
    //     AADD(aIdExt, '2844391')
    //     AADD(aIdExt, '2844398')
    //     AADD(aIdExt, '2844418')
    //     AADD(aIdExt, '2844420')
    //     AADD(aIdExt, '2844420')
    //     AADD(aIdExt, '2844440')
    //     AADD(aIdExt, '2844465')
    //     AADD(aIdExt, '2844480')
    //     AADD(aIdExt, '2844480')
    //     AADD(aIdExt, '2844482')
    //     AADD(aIdExt, '2844490')
    //     AADD(aIdExt, '2844497')
    //     AADD(aIdExt, '2844501')
    //     AADD(aIdExt, '2844501')
    //     AADD(aIdExt, '2844508')
    //     AADD(aIdExt, '2844508')
    //     AADD(aIdExt, '2844518')
    //     AADD(aIdExt, '2844521')
    //     AADD(aIdExt, '2844537')
    //     AADD(aIdExt, '2844537')
    //     AADD(aIdExt, '2844537')
    //     AADD(aIdExt, '2844542')
    //     AADD(aIdExt, '2844548')
    //     AADD(aIdExt, '2844551')
    //     AADD(aIdExt, '2844551')
    //     AADD(aIdExt, '2844552')
    //     AADD(aIdExt, '2844559')
    //     AADD(aIdExt, '2844577')
    //     AADD(aIdExt, '2844584')
    //     AADD(aIdExt, '2844584')
    //     AADD(aIdExt, '2844600')
    //     AADD(aIdExt, '2844600')
    //     AADD(aIdExt, '2844605')
    //     AADD(aIdExt, '2844609')
    //     AADD(aIdExt, '2844614')
    //     AADD(aIdExt, '2844657')
    //     AADD(aIdExt, '2844671')
    //     AADD(aIdExt, '2844677')
    //     AADD(aIdExt, '2844683')
    //     AADD(aIdExt, '2844705')
    //     AADD(aIdExt, '2844708')
    //     AADD(aIdExt, '2844709')
    //     AADD(aIdExt, '2844722')
    //     AADD(aIdExt, '2844727')
    //     AADD(aIdExt, '2844731')
    //     AADD(aIdExt, '2844742')
    //     AADD(aIdExt, '2844761')
    //     AADD(aIdExt, '2844764')
    //     AADD(aIdExt, '2844767')
    //     AADD(aIdExt, '2844768')
    //     AADD(aIdExt, '2844772')
    //     AADD(aIdExt, '2844774')
    //     AADD(aIdExt, '2844786')
    //     AADD(aIdExt, '2844786')
    //     AADD(aIdExt, '2844794')
    //     AADD(aIdExt, '2844800')
    //     AADD(aIdExt, '2844803')
    //     AADD(aIdExt, '2844804')
    //     AADD(aIdExt, '2844818')
    //     AADD(aIdExt, '2844842')
    //     AADD(aIdExt, '2844845')
    //     AADD(aIdExt, '2844847')
    //     AADD(aIdExt, '2844858')
    //     AADD(aIdExt, '2844858')
    //     AADD(aIdExt, '2844858')
    //     AADD(aIdExt, '2844862')
    //     AADD(aIdExt, '2844866')
    //     AADD(aIdExt, '2844872')
    //     AADD(aIdExt, '2844876')
    //     AADD(aIdExt, '2844883')
    //     AADD(aIdExt, '2844893')
    //     AADD(aIdExt, '2844905')
    //     AADD(aIdExt, '2844905')
    //     AADD(aIdExt, '2844914')
    //     AADD(aIdExt, '2844916')
    //     AADD(aIdExt, '2844931')
    //     AADD(aIdExt, '2844935')
    //     AADD(aIdExt, '2844940')
    //     AADD(aIdExt, '2844947')
    //     AADD(aIdExt, '2844949')
    //     AADD(aIdExt, '2844951')
    //     AADD(aIdExt, '2844952')
    //     AADD(aIdExt, '2844962')
    //     AADD(aIdExt, '2844971')
    //     AADD(aIdExt, '2844978')
    //     AADD(aIdExt, '2844984')
    //     AADD(aIdExt, '2844984')
    //     AADD(aIdExt, '2844992')
    //     AADD(aIdExt, '2845007')
    //     AADD(aIdExt, '2845019')
    //     AADD(aIdExt, '2845019')
    //     AADD(aIdExt, '2845031')
    //     AADD(aIdExt, '2845043')
    //     AADD(aIdExt, '2845048')
    //     AADD(aIdExt, '2845050')
    //     AADD(aIdExt, '2845057')
    //     AADD(aIdExt, '2876289')
    //     AADD(aIdExt, '2845097')
    //     AADD(aIdExt, '2845106')
    //     AADD(aIdExt, '2845119')
    //     AADD(aIdExt, '2845123')
    //     AADD(aIdExt, '2845174')
    //     AADD(aIdExt, '2845186')
    //     AADD(aIdExt, '2845190')
    //     AADD(aIdExt, '2845205')
    //     AADD(aIdExt, '2845205')
    //     AADD(aIdExt, '2845205')
    //     AADD(aIdExt, '2845216')
    //     AADD(aIdExt, '2845217')
    //     AADD(aIdExt, '2845220')
    //     AADD(aIdExt, '2845226')
    //     AADD(aIdExt, '2845229')
    //     AADD(aIdExt, '2845229')
    //     AADD(aIdExt, '2845231')
    //     AADD(aIdExt, '2845243')
    //     AADD(aIdExt, '2845244')
    //     AADD(aIdExt, '2845250')
    //     AADD(aIdExt, '2845259')
    //     AADD(aIdExt, '2845262')
    //     AADD(aIdExt, '2845275')
    //     AADD(aIdExt, '2845279')
    //     AADD(aIdExt, '2845281')
    //     AADD(aIdExt, '2845281')
    //     AADD(aIdExt, '2845282')
    //     AADD(aIdExt, '2845293')
    //     AADD(aIdExt, '2845295')
    //     AADD(aIdExt, '2845324')
    //     AADD(aIdExt, '2845365')
    //     AADD(aIdExt, '2845379')
    //     AADD(aIdExt, '2845389')
    //     AADD(aIdExt, '2845389')
    //     AADD(aIdExt, '2845391')
    //     AADD(aIdExt, '2845394')
    //     AADD(aIdExt, '2845404')
    //     AADD(aIdExt, '2845404')
    //     AADD(aIdExt, '2845409')
    //     AADD(aIdExt, '2845410')
    //     AADD(aIdExt, '2845411')
    //     AADD(aIdExt, '2845411')
    //     AADD(aIdExt, '2845429')
    //     AADD(aIdExt, '2845446')
    //     AADD(aIdExt, '2845457')
    //     AADD(aIdExt, '2845467')
    //     AADD(aIdExt, '2845473')
    //     AADD(aIdExt, '2845474')
    //     AADD(aIdExt, '2845475')
    //     AADD(aIdExt, '2845475')
    //     AADD(aIdExt, '2845476')
    //     AADD(aIdExt, '2845476')
    //     AADD(aIdExt, '2845479')
    //     AADD(aIdExt, '2845508')
    //     AADD(aIdExt, '2845518')
    //     AADD(aIdExt, '2845520')
    //     AADD(aIdExt, '2845524')
    //     AADD(aIdExt, '2845525')
    //     AADD(aIdExt, '2845527')
    //     AADD(aIdExt, '2845534')
    //     AADD(aIdExt, '2845543')
    //     AADD(aIdExt, '2845545')
    //     AADD(aIdExt, '2845557')
    //     AADD(aIdExt, '2845564')
    //     AADD(aIdExt, '2845564')
    //     AADD(aIdExt, '2845576')
    //     AADD(aIdExt, '2845580')
    //     AADD(aIdExt, '2845654')
    //     AADD(aIdExt, '2845659')
    //     AADD(aIdExt, '2845670')
    //     AADD(aIdExt, '2845677')
    //     AADD(aIdExt, '2845682')
    //     AADD(aIdExt, '2845682')
    //     AADD(aIdExt, '2845690')
    //     AADD(aIdExt, '2845708')
    //     AADD(aIdExt, '2845728')
    //     AADD(aIdExt, '2845740')
    //     AADD(aIdExt, '2845749')
    //     AADD(aIdExt, '2845753')
    //     AADD(aIdExt, '2845764')
    //     AADD(aIdExt, '2845768')
    //     AADD(aIdExt, '2845777')
    //     AADD(aIdExt, '2845781')
    //     AADD(aIdExt, '2845783')
    //     AADD(aIdExt, '2845789')
    //     AADD(aIdExt, '2845804')
    //     AADD(aIdExt, '2845805')
    //     AADD(aIdExt, '2845806')
    //     AADD(aIdExt, '2845814')
    //     AADD(aIdExt, '2845832')
    //     AADD(aIdExt, '2845832')
    //     AADD(aIdExt, '2845835')
    //     AADD(aIdExt, '2845835')
    //     AADD(aIdExt, '2845851')
    //     AADD(aIdExt, '2845857')
    //     AADD(aIdExt, '2845858')
    //     AADD(aIdExt, '2845869')
    //     AADD(aIdExt, '2845869')
    //     AADD(aIdExt, '2845877')
    //     AADD(aIdExt, '2845879')
    //     AADD(aIdExt, '2845879')
    //     AADD(aIdExt, '2845887')
    //     AADD(aIdExt, '2845894')
    //     AADD(aIdExt, '2845903')
    //     AADD(aIdExt, '2845918')
    //     AADD(aIdExt, '2845933')
    //     AADD(aIdExt, '2845954')
    //     AADD(aIdExt, '2845958')
    //     AADD(aIdExt, '2845965')
    //     AADD(aIdExt, '2845988')
    //     AADD(aIdExt, '2845999')
    //     AADD(aIdExt, '2846003')
    //     AADD(aIdExt, '2846009')
    //     AADD(aIdExt, '2846021')
    //     AADD(aIdExt, '2846027')
    //     AADD(aIdExt, '2846033')
    //     AADD(aIdExt, '2846050')
    //     AADD(aIdExt, '2846053')
    //     AADD(aIdExt, '2846061')
    //     AADD(aIdExt, '2846087')
    //     AADD(aIdExt, '2846091')
    //     AADD(aIdExt, '2846092')
    //     AADD(aIdExt, '2846099')
    //     AADD(aIdExt, '2846104')
    //     AADD(aIdExt, '2846104')
    //     AADD(aIdExt, '2846105')
    //     AADD(aIdExt, '2846112')
    //     AADD(aIdExt, '2846115')
    //     AADD(aIdExt, '2846116')
    //     AADD(aIdExt, '2846130')
    //     AADD(aIdExt, '2846148')
    //     AADD(aIdExt, '2846150')
    //     AADD(aIdExt, '2846154')
    //     AADD(aIdExt, '2846183')
    //     AADD(aIdExt, '2846186')
    //     AADD(aIdExt, '2846189')
    //     AADD(aIdExt, '2846204')
    //     AADD(aIdExt, '2846207')
    //     AADD(aIdExt, '2846208')
    //     AADD(aIdExt, '2846208')
    //     AADD(aIdExt, '2846211')
    //     AADD(aIdExt, '2846212')
    //     AADD(aIdExt, '2846212')
    //     AADD(aIdExt, '2846214')
    //     AADD(aIdExt, '2846216')
    //     AADD(aIdExt, '2846228')
    //     AADD(aIdExt, '2846228')
    //     AADD(aIdExt, '2846242')
    //     AADD(aIdExt, '2846257')
    //     AADD(aIdExt, '2846257')
    //     AADD(aIdExt, '2846257')
    //     AADD(aIdExt, '2846263')
    //     AADD(aIdExt, '2846267')
    //     AADD(aIdExt, '2846278')
    //     AADD(aIdExt, '2846279')
    //     AADD(aIdExt, '2846290')
    //     AADD(aIdExt, '2846293')
    //     AADD(aIdExt, '2846296')
    //     AADD(aIdExt, '2846303')
    //     AADD(aIdExt, '2846306')
    //     AADD(aIdExt, '2846321')
    //     AADD(aIdExt, '2846331')
    //     AADD(aIdExt, '2846343')
    //     AADD(aIdExt, '2846356')
    //     AADD(aIdExt, '2846368')
    //     AADD(aIdExt, '2846379')
    //     AADD(aIdExt, '2846386')
    //     AADD(aIdExt, '2846397')
    //     AADD(aIdExt, '2846415')
    //     AADD(aIdExt, '2846420')
    //     AADD(aIdExt, '2846421')
    //     AADD(aIdExt, '2846423')
    //     AADD(aIdExt, '2846425')
    //     AADD(aIdExt, '2846425')
    //     AADD(aIdExt, '2846446')
    //     AADD(aIdExt, '2846452')
    //     AADD(aIdExt, '2846458')
    //     AADD(aIdExt, '2846458')
    //     AADD(aIdExt, '2846461')
    //     AADD(aIdExt, '2846464')
    //     AADD(aIdExt, '2846468')
    //     AADD(aIdExt, '2846476')
    //     AADD(aIdExt, '2846477')
    //     AADD(aIdExt, '2846477')
    //     AADD(aIdExt, '2846509')
    //     AADD(aIdExt, '2846510')
    //     AADD(aIdExt, '2846529')
    //     AADD(aIdExt, '2846530')
    //     AADD(aIdExt, '2846530')
    //     AADD(aIdExt, '2846530')
    //     AADD(aIdExt, '2846531')
    //     AADD(aIdExt, '2846531')
    //     AADD(aIdExt, '2846535')
    //     AADD(aIdExt, '2846544')
    //     AADD(aIdExt, '2846550')
    //     AADD(aIdExt, '2846552')
    //     AADD(aIdExt, '2846553')
    //     AADD(aIdExt, '2846581')
    //     AADD(aIdExt, '2846586')
    //     AADD(aIdExt, '2846586')
    //     AADD(aIdExt, '2846598')
    //     AADD(aIdExt, '2846601')
    //     AADD(aIdExt, '2846601')
    //     AADD(aIdExt, '2846602')
    //     AADD(aIdExt, '2846602')
    //     AADD(aIdExt, '2846615')
    //     AADD(aIdExt, '2846617')
    //     AADD(aIdExt, '2846621')
    //     AADD(aIdExt, '2846642')
    //     AADD(aIdExt, '2846645')
    //     AADD(aIdExt, '2846645')
    //     AADD(aIdExt, '2846654')
    //     AADD(aIdExt, '2846664')
    //     AADD(aIdExt, '2846676')
    //     AADD(aIdExt, '2846683')
    //     AADD(aIdExt, '2846687')
    //     AADD(aIdExt, '2846690')
    //     AADD(aIdExt, '2846696')
    //     AADD(aIdExt, '2846703')
    //     AADD(aIdExt, '2846705')
    //     AADD(aIdExt, '2846705')
    //     AADD(aIdExt, '2846713')
    //     AADD(aIdExt, '2846714')
    //     AADD(aIdExt, '2846719')
    //     AADD(aIdExt, '2846721')
    //     AADD(aIdExt, '2846731')
    //     AADD(aIdExt, '2846750')
    //     AADD(aIdExt, '2846750')
    //     AADD(aIdExt, '2846760')
    //     AADD(aIdExt, '2846778')
    //     AADD(aIdExt, '2846790')
    //     AADD(aIdExt, '2846803')
    //     AADD(aIdExt, '2846819')
    //     AADD(aIdExt, '2846820')
    //     AADD(aIdExt, '2846841')
    //     AADD(aIdExt, '2846842')
    //     AADD(aIdExt, '2846847')
    //     AADD(aIdExt, '2846854')
    //     AADD(aIdExt, '2846856')
    //     AADD(aIdExt, '2846859')
    //     AADD(aIdExt, '2846859')
    //     AADD(aIdExt, '2846859')
    //     AADD(aIdExt, '2846862')
    //     AADD(aIdExt, '2846862')
    //     AADD(aIdExt, '2846876')
    //     AADD(aIdExt, '2846899')
    //     AADD(aIdExt, '2846902')
    //     AADD(aIdExt, '2846907')
    //     AADD(aIdExt, '2846911')
    //     AADD(aIdExt, '2846923')
    //     AADD(aIdExt, '2846925')
    //     AADD(aIdExt, '2846926')
    //     AADD(aIdExt, '2846932')
    //     AADD(aIdExt, '2846933')
    //     AADD(aIdExt, '2846933')
    //     AADD(aIdExt, '2846953')
    //     AADD(aIdExt, '2846958')
    //     AADD(aIdExt, '2846967')
    //     AADD(aIdExt, '2846967')
    //     AADD(aIdExt, '2846973')
    //     AADD(aIdExt, '2846993')
    //     AADD(aIdExt, '2847000')
    //     AADD(aIdExt, '2847004')
    //     AADD(aIdExt, '2847011')
    //     AADD(aIdExt, '2847011')
    //     AADD(aIdExt, '2847018')
    //     AADD(aIdExt, '2847019')
    //     AADD(aIdExt, '2847021')
    //     AADD(aIdExt, '2847037')
    //     AADD(aIdExt, '2847046')
    //     AADD(aIdExt, '2847053')
    //     AADD(aIdExt, '2847063')
    //     AADD(aIdExt, '2847080')
    //     AADD(aIdExt, '2847083')
    //     AADD(aIdExt, '2847123')
    //     AADD(aIdExt, '2847128')
    //     AADD(aIdExt, '2847130')
    //     AADD(aIdExt, '2847134')
    //     AADD(aIdExt, '2847140')
    //     AADD(aIdExt, '2847150')
    //     AADD(aIdExt, '2847154')
    //     AADD(aIdExt, '2847161')
    //     AADD(aIdExt, '2847191')
    //     AADD(aIdExt, '2847205')
    //     AADD(aIdExt, '2847214')
    //     AADD(aIdExt, '2847220')
    //     AADD(aIdExt, '2847232')
    //     AADD(aIdExt, '2847259')
    //     AADD(aIdExt, '2847262')
    //     AADD(aIdExt, '2847269')
    //     AADD(aIdExt, '2847271')
    //     AADD(aIdExt, '2847286')
    //     AADD(aIdExt, '2847287')
    //     AADD(aIdExt, '2847294')
    //     AADD(aIdExt, '2847304')
    //     AADD(aIdExt, '2847312')
    //     AADD(aIdExt, '2847320')
    //     AADD(aIdExt, '2847326')
    //     AADD(aIdExt, '2847336')
    //     AADD(aIdExt, '2847360')
    //     AADD(aIdExt, '2847389')
    //     AADD(aIdExt, '2847391')
    //     AADD(aIdExt, '2847399')
    //     AADD(aIdExt, '2847435')
    //     AADD(aIdExt, '2847448')
    //     AADD(aIdExt, '2847448')
    //     AADD(aIdExt, '2847450')
    //     AADD(aIdExt, '2847450')
    //     AADD(aIdExt, '2847452')
    //     AADD(aIdExt, '2847452')
    //     AADD(aIdExt, '2847463')
    //     AADD(aIdExt, '2847463')
    //     AADD(aIdExt, '2847473')
    //     AADD(aIdExt, '2847479')
    //     AADD(aIdExt, '2847479')
    //     AADD(aIdExt, '2847487')
    //     AADD(aIdExt, '2847528')
    //     AADD(aIdExt, '2847540')
    //     AADD(aIdExt, '2847551')
    //     AADD(aIdExt, '2847551')
    //     AADD(aIdExt, '2847554')
    //     AADD(aIdExt, '2847571')
    //     AADD(aIdExt, '2847594')
    //     AADD(aIdExt, '2847601')
    //     AADD(aIdExt, '2847613')
    //     AADD(aIdExt, '2847621')
    //     AADD(aIdExt, '2847622')
    //     AADD(aIdExt, '2847630')
    //     AADD(aIdExt, '2847646')
    //     AADD(aIdExt, '2847646')
    //     AADD(aIdExt, '2847656')
    //     AADD(aIdExt, '2847659')
    //     AADD(aIdExt, '2847659')
    //     AADD(aIdExt, '2847661')
    //     AADD(aIdExt, '2847661')
    //     AADD(aIdExt, '2847663')
    //     AADD(aIdExt, '2847663')
    //     AADD(aIdExt, '2847665')
    //     AADD(aIdExt, '2847670')
    //     AADD(aIdExt, '2847681')
    //     AADD(aIdExt, '2847681')
    //     AADD(aIdExt, '2847689')
    //     AADD(aIdExt, '2847690')
    //     AADD(aIdExt, '2847712')
    //     AADD(aIdExt, '2847727')
    //     AADD(aIdExt, '2847727')
    //     AADD(aIdExt, '2847737')
    //     AADD(aIdExt, '2847737')
    //     AADD(aIdExt, '2847747')
    //     AADD(aIdExt, '2847747')
    //     AADD(aIdExt, '2847753')
    //     AADD(aIdExt, '2847766')
    //     AADD(aIdExt, '2847767')
    //     AADD(aIdExt, '2847776')
    //     AADD(aIdExt, '2847809')
    //     AADD(aIdExt, '2847816')
    //     AADD(aIdExt, '2847817')
    //     AADD(aIdExt, '2847832')
    //     AADD(aIdExt, '2847832')
    //     AADD(aIdExt, '2847834')
    //     AADD(aIdExt, '2847837')
    //     AADD(aIdExt, '2847864')
    //     AADD(aIdExt, '2847875')
    //     AADD(aIdExt, '2847877')
    //     AADD(aIdExt, '2847890')
    //     AADD(aIdExt, '2847904')
    //     AADD(aIdExt, '2847905')
    //     AADD(aIdExt, '2847928')
    //     AADD(aIdExt, '2847932')
    //     AADD(aIdExt, '2847934')
    //     AADD(aIdExt, '2847940')
    //     AADD(aIdExt, '2847963')
    //     AADD(aIdExt, '2847963')
    //     AADD(aIdExt, '2847967')
    //     AADD(aIdExt, '2847999')
    //     AADD(aIdExt, '2848002')
    //     AADD(aIdExt, '2848004')
    //     AADD(aIdExt, '2848009')
    //     AADD(aIdExt, '2848011')
    //     AADD(aIdExt, '2848016')
    //     AADD(aIdExt, '2848029')
    //     AADD(aIdExt, '2848046')
    //     AADD(aIdExt, '2848072')
    //     AADD(aIdExt, '2848078')
    //     AADD(aIdExt, '2848084')
    //     AADD(aIdExt, '2848086')
    //     AADD(aIdExt, '2848106')
    //     AADD(aIdExt, '2848114')
    //     AADD(aIdExt, '2848114')
    //     AADD(aIdExt, '2848141')
    //     AADD(aIdExt, '2848142')
    //     AADD(aIdExt, '2848144')
    //     AADD(aIdExt, '2848152')
    //     AADD(aIdExt, '2848160')
    //     AADD(aIdExt, '2848176')
    //     AADD(aIdExt, '2848181')
    //     AADD(aIdExt, '2848182')
    //     AADD(aIdExt, '2848189')
    //     AADD(aIdExt, '2848193')
    //     AADD(aIdExt, '2848193')
    //     AADD(aIdExt, '2848200')
    //     AADD(aIdExt, '2848208')
    //     AADD(aIdExt, '2848218')
    //     AADD(aIdExt, '2848242')
    //     AADD(aIdExt, '2848242')
    //     AADD(aIdExt, '2848247')
    //     AADD(aIdExt, '2848250')
    //     AADD(aIdExt, '2848268')
    //     AADD(aIdExt, '2848282')
    //     AADD(aIdExt, '2848283')
    //     AADD(aIdExt, '2848304')
    //     AADD(aIdExt, '2848308')
    //     AADD(aIdExt, '2848309')
    //     AADD(aIdExt, '2848309')
    //     AADD(aIdExt, '2848312')
    //     AADD(aIdExt, '2848314')
    //     AADD(aIdExt, '2848322')
    //     AADD(aIdExt, '2848323')
    //     AADD(aIdExt, '2848336')
    //     AADD(aIdExt, '2848340')
    //     AADD(aIdExt, '2848351')
    //     AADD(aIdExt, '2848352')
    //     AADD(aIdExt, '2848354')
    //     AADD(aIdExt, '2848355')
    //     AADD(aIdExt, '2848358')
    //     AADD(aIdExt, '2848363')
    //     AADD(aIdExt, '2848378')
    //     AADD(aIdExt, '2848380')
    //     AADD(aIdExt, '2848385')
    //     AADD(aIdExt, '2848441')
    //     AADD(aIdExt, '2848441')
    //     AADD(aIdExt, '2848451')
    //     AADD(aIdExt, '2848453')
    //     AADD(aIdExt, '2848460')
    //     AADD(aIdExt, '2848460')
    //     AADD(aIdExt, '2848473')
    //     AADD(aIdExt, '2848474')
    //     AADD(aIdExt, '2848482')
    //     AADD(aIdExt, '2848486')
    //     AADD(aIdExt, '2848502')
    //     AADD(aIdExt, '2848503')
    //     AADD(aIdExt, '2848511')
    //     AADD(aIdExt, '2848511')
    //     AADD(aIdExt, '2848511')
    //     AADD(aIdExt, '2848512')
    //     AADD(aIdExt, '2848519')
    //     AADD(aIdExt, '2848519')
    //     AADD(aIdExt, '2848527')
    //     AADD(aIdExt, '2848538')
    //     AADD(aIdExt, '2848545')
    //     AADD(aIdExt, '2848546')
    //     AADD(aIdExt, '2848551')
    //     AADD(aIdExt, '2848551')
    //     AADD(aIdExt, '2848554')
    //     AADD(aIdExt, '2848558')
    //     AADD(aIdExt, '2848562')
    //     AADD(aIdExt, '2848568')
    //     AADD(aIdExt, '2848568')
    //     AADD(aIdExt, '2848571')
    //     AADD(aIdExt, '2848578')
    //     AADD(aIdExt, '2848582')
    //     AADD(aIdExt, '2848585')
    //     AADD(aIdExt, '2848589')
    //     AADD(aIdExt, '2848622')
    //     AADD(aIdExt, '2848626')
    //     AADD(aIdExt, '2848639')
    //     AADD(aIdExt, '2848646')
    //     AADD(aIdExt, '2848668')
    //     AADD(aIdExt, '2848681')
    //     AADD(aIdExt, '2848710')
    //     AADD(aIdExt, '2848710')
    //     AADD(aIdExt, '2848712')
    //     AADD(aIdExt, '2848721')
    //     AADD(aIdExt, '2848726')
    //     AADD(aIdExt, '2848736')
    //     AADD(aIdExt, '2848738')
    //     AADD(aIdExt, '2848749')
    //     AADD(aIdExt, '2848750')
    //     AADD(aIdExt, '2848751')
    //     AADD(aIdExt, '2848752')
    //     AADD(aIdExt, '2876754')
    //     AADD(aIdExt, '2877117')
    //     AADD(aIdExt, '2877117')
    //     AADD(aIdExt, '2877377')
    //     AADD(aIdExt, '2877659')
    //     AADD(aIdExt, '2877925')
    //     AADD(aIdExt, '2848775')
    //     AADD(aIdExt, '2848789')
    //     AADD(aIdExt, '2848795')
    //     AADD(aIdExt, '2848800')
    //     AADD(aIdExt, '2848808')
    //     AADD(aIdExt, '2848830')
    //     AADD(aIdExt, '2848836')
    //     AADD(aIdExt, '2848843')
    //     AADD(aIdExt, '2848844')
    //     AADD(aIdExt, '2848848')
    //     AADD(aIdExt, '2848848')
    //     AADD(aIdExt, '2848860')
    //     AADD(aIdExt, '2848860')
    //     AADD(aIdExt, '2848865')
    //     AADD(aIdExt, '2848878')
    //     AADD(aIdExt, '2848881')
    //     AADD(aIdExt, '2848883')
    //     AADD(aIdExt, '2848888')
    //     AADD(aIdExt, '2848910')
    //     AADD(aIdExt, '2848915')
    //     AADD(aIdExt, '2848918')
    //     AADD(aIdExt, '2848920')
    //     AADD(aIdExt, '2848927')
    //     AADD(aIdExt, '2848931')
    //     AADD(aIdExt, '2848933')
    //     AADD(aIdExt, '2848935')
    //     AADD(aIdExt, '2848937')
    //     AADD(aIdExt, '2848951')
    //     AADD(aIdExt, '2848977')
    //     AADD(aIdExt, '2848978')
    //     AADD(aIdExt, '2849006')
    //     AADD(aIdExt, '2849018')
    //     AADD(aIdExt, '2849038')
    //     AADD(aIdExt, '2849045')
    //     AADD(aIdExt, '2849064')
    //     AADD(aIdExt, '2849067')
    //     AADD(aIdExt, '2849067')
    //     AADD(aIdExt, '2849070')
    //     AADD(aIdExt, '2849072')
    //     AADD(aIdExt, '2849073')
    //     AADD(aIdExt, '2849109')
    //     AADD(aIdExt, '2849138')
    //     AADD(aIdExt, '2849150')
    //     AADD(aIdExt, '2849151')
    //     AADD(aIdExt, '2849156')
    //     AADD(aIdExt, '2849163')
    //     AADD(aIdExt, '2849176')
    //     AADD(aIdExt, '2849193')
    //     AADD(aIdExt, '2849200')
    //     AADD(aIdExt, '2849216')
    //     AADD(aIdExt, '2849217')
    //     AADD(aIdExt, '2849219')
    //     AADD(aIdExt, '2849234')
    //     AADD(aIdExt, '2849236')
    //     AADD(aIdExt, '2849245')
    //     AADD(aIdExt, '2849252')
    //     AADD(aIdExt, '2849262')
    //     AADD(aIdExt, '2849266')
    //     AADD(aIdExt, '2849268')
    //     AADD(aIdExt, '2849287')
    //     AADD(aIdExt, '2849288')
    //     AADD(aIdExt, '2849290')
    //     AADD(aIdExt, '2849297')
    //     AADD(aIdExt, '2849305')
    //     AADD(aIdExt, '2849306')
    //     AADD(aIdExt, '2849310')
    //     AADD(aIdExt, '2849311')
    //     AADD(aIdExt, '2849311')
    //     AADD(aIdExt, '2849325')
    //     AADD(aIdExt, '2849330')
    //     AADD(aIdExt, '2849337')
    //     AADD(aIdExt, '2849341')
    //     AADD(aIdExt, '2849355')
    //     AADD(aIdExt, '2849358')
    //     AADD(aIdExt, '2849368')
    //     AADD(aIdExt, '2849376')
    //     AADD(aIdExt, '2849376')
    //     AADD(aIdExt, '2849416')
    //     AADD(aIdExt, '2849426')
    //     AADD(aIdExt, '2849430')
    //     AADD(aIdExt, '2849430')
    //     AADD(aIdExt, '2849444')
    //     AADD(aIdExt, '2849447')
    //     AADD(aIdExt, '2849454')
    //     AADD(aIdExt, '2849465')
    //     AADD(aIdExt, '2849472')
    //     AADD(aIdExt, '2849472')
    //     AADD(aIdExt, '2849519')
    //     AADD(aIdExt, '2849522')
    //     AADD(aIdExt, '2849524')
    //     AADD(aIdExt, '2849532')
    //     AADD(aIdExt, '2849545')
    //     AADD(aIdExt, '2849553')
    //     AADD(aIdExt, '2849557')
    //     AADD(aIdExt, '2849571')
    //     AADD(aIdExt, '2849592')
    //     AADD(aIdExt, '2849595')
    //     AADD(aIdExt, '2849595')
    //     AADD(aIdExt, '2849596')
    //     AADD(aIdExt, '2849597')
    //     AADD(aIdExt, '2849598')
    //     AADD(aIdExt, '2849605')
    //     AADD(aIdExt, '2849609')
    //     AADD(aIdExt, '2849612')
    //     AADD(aIdExt, '2849623')
    //     AADD(aIdExt, '2849629')
    //     AADD(aIdExt, '2849634')
    //     AADD(aIdExt, '2849640')
    //     AADD(aIdExt, '2849642')
    //     AADD(aIdExt, '2849648')
    //     AADD(aIdExt, '2849658')
    //     AADD(aIdExt, '2849664')
    //     AADD(aIdExt, '2849690')
    //     AADD(aIdExt, '2849715')
    //     AADD(aIdExt, '2849722')
    //     AADD(aIdExt, '2849726')
    //     AADD(aIdExt, '2849751')
    //     AADD(aIdExt, '2849763')
    //     AADD(aIdExt, '2849770')
    //     AADD(aIdExt, '2849777')
    //     AADD(aIdExt, '2849785')
    //     AADD(aIdExt, '2849797')
    //     AADD(aIdExt, '2849806')
    //     AADD(aIdExt, '2849806')
    //     AADD(aIdExt, '2849809')
    //     AADD(aIdExt, '2849819')
    //     AADD(aIdExt, '2849819')
    //     AADD(aIdExt, '2849820')
    //     AADD(aIdExt, '2849823')
    //     AADD(aIdExt, '2849832')
    //     AADD(aIdExt, '2849838')
    //     AADD(aIdExt, '2849854')
    //     AADD(aIdExt, '2849888')
    //     AADD(aIdExt, '2849898')
    //     AADD(aIdExt, '2849913')
    //     AADD(aIdExt, '2849915')
    //     AADD(aIdExt, '2849924')
    //     AADD(aIdExt, '2849924')
    //     AADD(aIdExt, '2849957')
    //     AADD(aIdExt, '2849957')
    //     AADD(aIdExt, '2849962')
    //     AADD(aIdExt, '2849968')
    //     AADD(aIdExt, '2849971')
    //     AADD(aIdExt, '2849976')
    //     AADD(aIdExt, '2849982')
    //     AADD(aIdExt, '2849982')
    //     AADD(aIdExt, '2849983')
    //     AADD(aIdExt, '2849997')
    //     AADD(aIdExt, '2850002')
    //     AADD(aIdExt, '2850010')
    //     AADD(aIdExt, '2850016')
    //     AADD(aIdExt, '2850017')
    //     AADD(aIdExt, '2850021')
    //     AADD(aIdExt, '2850033')
    //     AADD(aIdExt, '2850070')
    //     AADD(aIdExt, '2850070')
    //     AADD(aIdExt, '2850083')
    //     AADD(aIdExt, '2850096')
    //     AADD(aIdExt, '2850101')
    //     AADD(aIdExt, '2850122')
    //     AADD(aIdExt, '2850124')
    //     AADD(aIdExt, '2850128')
    //     AADD(aIdExt, '2850138')
    //     AADD(aIdExt, '2850148')
    //     AADD(aIdExt, '2850149')
    //     AADD(aIdExt, '2850149')
    //     AADD(aIdExt, '2850165')
    //     AADD(aIdExt, '2850167')
    //     AADD(aIdExt, '2850174')
    //     AADD(aIdExt, '2850177')
    //     AADD(aIdExt, '2850179')
    //     AADD(aIdExt, '2850217')
    //     AADD(aIdExt, '2850219')
    //     AADD(aIdExt, '2850219')
    //     AADD(aIdExt, '2850222')
    //     AADD(aIdExt, '2850222')
    //     AADD(aIdExt, '2850228')
    //     AADD(aIdExt, '2850230')
    //     AADD(aIdExt, '2850249')
    //     AADD(aIdExt, '2850254')
    //     AADD(aIdExt, '2850273')
    //     AADD(aIdExt, '2850274')
    //     AADD(aIdExt, '2850281')
    //     AADD(aIdExt, '2850296')
    //     AADD(aIdExt, '2850309')
    //     AADD(aIdExt, '2850309')
    //     AADD(aIdExt, '2850321')
    //     AADD(aIdExt, '2850322')
    //     AADD(aIdExt, '2850334')
    //     AADD(aIdExt, '2850334')
    //     AADD(aIdExt, '2850334')
    //     AADD(aIdExt, '2850344')
    //     AADD(aIdExt, '2850351')
    //     AADD(aIdExt, '2850351')
    //     AADD(aIdExt, '2850354')
    //     AADD(aIdExt, '2850356')
    //     AADD(aIdExt, '2850368')
    //     AADD(aIdExt, '2850382')
    //     AADD(aIdExt, '2850405')
    //     AADD(aIdExt, '2850417')
    //     AADD(aIdExt, '2850419')
    //     AADD(aIdExt, '2850420')
    //     AADD(aIdExt, '2850423')
    //     AADD(aIdExt, '2850424')
    //     AADD(aIdExt, '2850424')
    //     AADD(aIdExt, '2850435')
    //     AADD(aIdExt, '2850448')
    //     AADD(aIdExt, '2850448')
    //     AADD(aIdExt, '2850453')
    //     AADD(aIdExt, '2850454')
    //     AADD(aIdExt, '2850459')
    //     AADD(aIdExt, '2850465')
    //     AADD(aIdExt, '2850514')
    //     AADD(aIdExt, '2850518')
    //     AADD(aIdExt, '2850548')
    //     AADD(aIdExt, '2850573')
    //     AADD(aIdExt, '2850573')
    //     AADD(aIdExt, '2850587')
    //     AADD(aIdExt, '2850603')
    //     AADD(aIdExt, '2850624')
    //     AADD(aIdExt, '2850638')
    //     AADD(aIdExt, '2850646')
    //     AADD(aIdExt, '2850647')
    //     AADD(aIdExt, '2850649')
    //     AADD(aIdExt, '2850658')
    //     AADD(aIdExt, '2850669')
    //     AADD(aIdExt, '2850669')
    //     AADD(aIdExt, '2850671')
    //     AADD(aIdExt, '2850671')
    //     AADD(aIdExt, '2850680')
    //     AADD(aIdExt, '2850698')
    //     AADD(aIdExt, '2850700')
    //     AADD(aIdExt, '2850723')
    //     AADD(aIdExt, '2850738')
    //     AADD(aIdExt, '2850738')
    //     AADD(aIdExt, '2850743')
    //     AADD(aIdExt, '2850743')
    //     AADD(aIdExt, '2850748')
    //     AADD(aIdExt, '2850751')
    //     AADD(aIdExt, '2850755')
    //     AADD(aIdExt, '2850757')
    //     AADD(aIdExt, '2850768')
    //     AADD(aIdExt, '2850769')
    //     AADD(aIdExt, '2850777')
    //     AADD(aIdExt, '2850814')
    //     AADD(aIdExt, '2850830')
    //     AADD(aIdExt, '2850835')
    //     AADD(aIdExt, '2850854')
    //     AADD(aIdExt, '2850854')
    //     AADD(aIdExt, '2850864')
    //     AADD(aIdExt, '2850864')
    //     AADD(aIdExt, '2850899')
    //     AADD(aIdExt, '2850899')
    //     AADD(aIdExt, '2850901')
    //     AADD(aIdExt, '2850901')
    //     AADD(aIdExt, '2850915')
    //     AADD(aIdExt, '2850915')
    //     AADD(aIdExt, '2850919')
    //     AADD(aIdExt, '2850922')
    //     AADD(aIdExt, '2850922')
    //     AADD(aIdExt, '2850932')
    //     AADD(aIdExt, '2850976')
    //     AADD(aIdExt, '2850993')
    //     AADD(aIdExt, '2851001')
    //     AADD(aIdExt, '2851008')
    //     AADD(aIdExt, '2851029')
    //     AADD(aIdExt, '2851032')
    //     AADD(aIdExt, '2851045')
    //     AADD(aIdExt, '2851048')
    //     AADD(aIdExt, '2851077')
    //     AADD(aIdExt, '2851114')
    //     AADD(aIdExt, '2851115')
    //     AADD(aIdExt, '2851119')
    //     AADD(aIdExt, '2851138')
    //     AADD(aIdExt, '2851138')
    //     AADD(aIdExt, '2851144')
    //     AADD(aIdExt, '2851144')
    //     AADD(aIdExt, '2851156')
    //     AADD(aIdExt, '2851167')
    //     AADD(aIdExt, '2851187')
    //     AADD(aIdExt, '2851212')
    //     AADD(aIdExt, '2851259')
    //     AADD(aIdExt, '2851275')
    //     AADD(aIdExt, '2851282')
    //     AADD(aIdExt, '2851296')
    //     AADD(aIdExt, '2851322')
    //     AADD(aIdExt, '2851356')
    //     AADD(aIdExt, '2851370')
    //     AADD(aIdExt, '2851370')
    //     AADD(aIdExt, '2851375')
    //     AADD(aIdExt, '2851384')
    //     AADD(aIdExt, '2851388')
    //     AADD(aIdExt, '2851388')
    //     AADD(aIdExt, '2851397')
    //     AADD(aIdExt, '2851398')
    //     AADD(aIdExt, '2851408')
    //     AADD(aIdExt, '2851423')
    //     AADD(aIdExt, '2851425')
    //     AADD(aIdExt, '2851430')
    //     AADD(aIdExt, '2851436')
    //     AADD(aIdExt, '2851446')
    //     AADD(aIdExt, '2851456')
    //     AADD(aIdExt, '2851474')
    //     AADD(aIdExt, '2851474')
    //     AADD(aIdExt, '2851474')
    //     AADD(aIdExt, '2851501')
    //     AADD(aIdExt, '2851511')
    //     AADD(aIdExt, '2851511')
    //     AADD(aIdExt, '2851536')
    //     AADD(aIdExt, '2851552')
    //     AADD(aIdExt, '2851563')
    //     AADD(aIdExt, '2851570')
    //     AADD(aIdExt, '2851579')
    //     AADD(aIdExt, '2851602')
    //     AADD(aIdExt, '2851603')
    //     AADD(aIdExt, '2851624')
    //     AADD(aIdExt, '2851637')
    //     AADD(aIdExt, '2851638')
    //     AADD(aIdExt, '2851645')
    //     AADD(aIdExt, '2851648')
    //     AADD(aIdExt, '2851649')
    //     AADD(aIdExt, '2851684')
    //     AADD(aIdExt, '2851693')
    //     AADD(aIdExt, '2851707')
    //     AADD(aIdExt, '2851711')
    //     AADD(aIdExt, '2851727')
    //     AADD(aIdExt, '2851736')
    //     AADD(aIdExt, '2851741')
    //     AADD(aIdExt, '2851751')
    //     AADD(aIdExt, '2851758')
    //     AADD(aIdExt, '2851784')
    //     AADD(aIdExt, '2851784')
    //     AADD(aIdExt, '2851812')
    //     AADD(aIdExt, '2851822')
    //     AADD(aIdExt, '2851840')
    //     AADD(aIdExt, '2851855')
    //     AADD(aIdExt, '2851864')
    //     AADD(aIdExt, '2851866')
    //     AADD(aIdExt, '2851866')
    //     AADD(aIdExt, '2851878')
    //     AADD(aIdExt, '2851892')
    //     AADD(aIdExt, '2851892')
    //     AADD(aIdExt, '2851892')
    //     AADD(aIdExt, '2851896')
    //     AADD(aIdExt, '2851906')
    //     AADD(aIdExt, '2851909')
    //     AADD(aIdExt, '2851914')
    //     AADD(aIdExt, '2851936')
    //     AADD(aIdExt, '2851939')
    //     AADD(aIdExt, '2851943')
    //     AADD(aIdExt, '2851949')
    //     AADD(aIdExt, '2851972')
    //     AADD(aIdExt, '2851977')
    //     AADD(aIdExt, '2851981')
    //     AADD(aIdExt, '2851984')
    //     AADD(aIdExt, '2852030')
    //     AADD(aIdExt, '2852034')
    //     AADD(aIdExt, '2852053')
    //     AADD(aIdExt, '2852062')
    //     AADD(aIdExt, '2852063')
    //     AADD(aIdExt, '2852066')
    //     AADD(aIdExt, '2852100')
    //     AADD(aIdExt, '2852103')
    //     AADD(aIdExt, '2852115')
    //     AADD(aIdExt, '2852116')
    //     AADD(aIdExt, '2852119')
    //     AADD(aIdExt, '2852123')
    //     AADD(aIdExt, '2852124')
    //     AADD(aIdExt, '2852136')
    //     AADD(aIdExt, '2852145')
    //     AADD(aIdExt, '2852154')
    //     AADD(aIdExt, '2852166')
    //     AADD(aIdExt, '2852181')
    //     AADD(aIdExt, '2852181')
    //     AADD(aIdExt, '2852194')
    //     AADD(aIdExt, '2852194')
    //     AADD(aIdExt, '2852229')
    //     AADD(aIdExt, '2852234')
    //     AADD(aIdExt, '2852251')
    //     AADD(aIdExt, '2852276')
    //     AADD(aIdExt, '2852295')
    //     AADD(aIdExt, '2852303')
    //     AADD(aIdExt, '2852305')
    //     AADD(aIdExt, '2852308')
    //     AADD(aIdExt, '2852320')
    //     AADD(aIdExt, '2852344')
    //     AADD(aIdExt, '2852368')
    //     AADD(aIdExt, '2852368')
    //     AADD(aIdExt, '2852369')
    //     AADD(aIdExt, '2852382')
    //     AADD(aIdExt, '2852392')
    //     AADD(aIdExt, '2852410')
    //     AADD(aIdExt, '2852424')
    //     AADD(aIdExt, '2852424')
    //     AADD(aIdExt, '2852442')
    //     AADD(aIdExt, '2852456')
    //     AADD(aIdExt, '2852484')
    //     AADD(aIdExt, '2852485')
    //     AADD(aIdExt, '2852486')
    //     AADD(aIdExt, '2852486')
    //     AADD(aIdExt, '2852487')
    //     AADD(aIdExt, '2852496')
    //     AADD(aIdExt, '2852507')
    //     AADD(aIdExt, '2852524')
    //     AADD(aIdExt, '2852530')
    //     AADD(aIdExt, '2852533')
    //     AADD(aIdExt, '2852548')
    //     AADD(aIdExt, '2852550')
    //     AADD(aIdExt, '2852578')
    //     AADD(aIdExt, '2852590')
    //     AADD(aIdExt, '2852607')
    //     AADD(aIdExt, '2852607')
    //     AADD(aIdExt, '2852611')
    //     AADD(aIdExt, '2852622')
    //     AADD(aIdExt, '2852626')
    //     AADD(aIdExt, '2852637')
    //     AADD(aIdExt, '2852651')
    //     AADD(aIdExt, '2852667')
    //     AADD(aIdExt, '2852708')
    //     AADD(aIdExt, '2852711')
    //     AADD(aIdExt, '2852716')
    //     AADD(aIdExt, '2852739')
    //     AADD(aIdExt, '2852741')
    //     AADD(aIdExt, '2852770')
    //     AADD(aIdExt, '2852772')
    //     AADD(aIdExt, '2852845')
    //     AADD(aIdExt, '2852845')
    //     AADD(aIdExt, '2852860')
    //     AADD(aIdExt, '2852860')
    //     AADD(aIdExt, '2852865')
    //     AADD(aIdExt, '2852868')
    //     AADD(aIdExt, '2852872')
    //     AADD(aIdExt, '2852876')
    //     AADD(aIdExt, '2852889')
    //     AADD(aIdExt, '2852906')
    //     AADD(aIdExt, '2852907')
    //     AADD(aIdExt, '2852939')
    //     AADD(aIdExt, '2852948')
    //     AADD(aIdExt, '2852949')
    //     AADD(aIdExt, '2852950')
    //     AADD(aIdExt, '2852968')
    //     AADD(aIdExt, '2852971')
    //     AADD(aIdExt, '2852983')
    //     AADD(aIdExt, '2852992')
    //     AADD(aIdExt, '2852992')
    //     AADD(aIdExt, '2853003')
    //     AADD(aIdExt, '2853004')
    //     AADD(aIdExt, '2853021')
    //     AADD(aIdExt, '2853022')
    //     AADD(aIdExt, '2853023')
    //     AADD(aIdExt, '2853028')
    //     AADD(aIdExt, '2853038')
    //     AADD(aIdExt, '2853038')
    //     AADD(aIdExt, '2853038')
    //     AADD(aIdExt, '2853042')
    //     AADD(aIdExt, '2853044')
    //     AADD(aIdExt, '2853048')
    //     AADD(aIdExt, '2853049')
    //     AADD(aIdExt, '2853052')
    //     AADD(aIdExt, '2853052')
    //     AADD(aIdExt, '2853058')
    //     AADD(aIdExt, '2853066')
    //     AADD(aIdExt, '2853070')
    //     AADD(aIdExt, '2853087')
    //     AADD(aIdExt, '2853104')
    //     AADD(aIdExt, '2853107')
    //     AADD(aIdExt, '2853115')
    //     AADD(aIdExt, '2853117')
    //     AADD(aIdExt, '2853118')
    //     AADD(aIdExt, '2853121')
    //     AADD(aIdExt, '2853127')
    //     AADD(aIdExt, '2853129')
    //     AADD(aIdExt, '2853144')
    //     AADD(aIdExt, '2853149')
    //     AADD(aIdExt, '2853160')
    //     AADD(aIdExt, '2853178')
    //     AADD(aIdExt, '2853192')
    //     AADD(aIdExt, '2853202')
    //     AADD(aIdExt, '2853205')
    //     AADD(aIdExt, '2853210')
    //     AADD(aIdExt, '2853215')
    //     AADD(aIdExt, '2853221')
    //     AADD(aIdExt, '2853221')
    //     AADD(aIdExt, '2853225')
    //     AADD(aIdExt, '2853236')
    //     AADD(aIdExt, '2853244')
    //     AADD(aIdExt, '2853246')
    //     AADD(aIdExt, '2853247')
    //     AADD(aIdExt, '2853248')
    //     AADD(aIdExt, '2853248')
    //     AADD(aIdExt, '2853250')
    //     AADD(aIdExt, '2853254')
    //     AADD(aIdExt, '2853254')
    //     AADD(aIdExt, '2853264')
    //     AADD(aIdExt, '2853281')
    //     AADD(aIdExt, '2853282')
    //     AADD(aIdExt, '2853316')
    //     AADD(aIdExt, '2853319')
    //     AADD(aIdExt, '2853326')
    //     AADD(aIdExt, '2853332')
    //     AADD(aIdExt, '2853332')
    //     AADD(aIdExt, '2853345')
    //     AADD(aIdExt, '2853349')
    //     AADD(aIdExt, '2853384')
    //     AADD(aIdExt, '2853384')
    //     AADD(aIdExt, '2853394')
    //     AADD(aIdExt, '2853434')
    //     AADD(aIdExt, '2853436')
    //     AADD(aIdExt, '2853451')
    //     AADD(aIdExt, '2853465')
    //     AADD(aIdExt, '2853465')
    //     AADD(aIdExt, '2853465')
    //     AADD(aIdExt, '2853486')
    //     AADD(aIdExt, '2853505')
    //     AADD(aIdExt, '2853505')
    //     AADD(aIdExt, '2853508')
    //     AADD(aIdExt, '2853514')
    //     AADD(aIdExt, '2853517')
    //     AADD(aIdExt, '2853527')
    //     AADD(aIdExt, '2853547')
    //     AADD(aIdExt, '2853555')
    //     AADD(aIdExt, '2853572')
    //     AADD(aIdExt, '2853573')
    //     AADD(aIdExt, '2853603')
    //     AADD(aIdExt, '2853606')
    //     AADD(aIdExt, '2853606')
    //     AADD(aIdExt, '2853628')
    //     AADD(aIdExt, '2853660')
    //     AADD(aIdExt, '2853661')
    //     AADD(aIdExt, '2853671')
    //     AADD(aIdExt, '2853687')
    //     AADD(aIdExt, '2853690')
    //     AADD(aIdExt, '2853699')
    //     AADD(aIdExt, '2853713')
    //     AADD(aIdExt, '2853722')
    //     AADD(aIdExt, '2853724')
    //     AADD(aIdExt, '2853772')
    //     AADD(aIdExt, '2853773')
    //     AADD(aIdExt, '2853779')
    //     AADD(aIdExt, '2853779')
    //     AADD(aIdExt, '2853788')
    //     AADD(aIdExt, '2853801')
    //     AADD(aIdExt, '2853804')
    //     AADD(aIdExt, '2853805')
    //     AADD(aIdExt, '2853814')
    //     AADD(aIdExt, '2853826')
    //     AADD(aIdExt, '2853833')
    //     AADD(aIdExt, '2853834')
    //     AADD(aIdExt, '2853867')
    //     AADD(aIdExt, '2853897')
    //     AADD(aIdExt, '2853901')
    //     AADD(aIdExt, '2853905')
    //     AADD(aIdExt, '2853907')
    //     AADD(aIdExt, '2853927')
    //     AADD(aIdExt, '2853931')
    //     AADD(aIdExt, '2853931')
    //     AADD(aIdExt, '2853939')
    //     AADD(aIdExt, '2853945')
    //     AADD(aIdExt, '2853962')
    //     AADD(aIdExt, '2853976')
    //     AADD(aIdExt, '2853978')
    //     AADD(aIdExt, '2853979')
    //     AADD(aIdExt, '2853979')
    //     AADD(aIdExt, '2853982')
    //     AADD(aIdExt, '2853982')
    //     AADD(aIdExt, '2853995')
    //     AADD(aIdExt, '2853995')
    //     AADD(aIdExt, '2853996')
    //     AADD(aIdExt, '2854007')
    //     AADD(aIdExt, '2854008')
    //     AADD(aIdExt, '2854010')
    //     AADD(aIdExt, '2854017')
    //     AADD(aIdExt, '2854023')
    //     AADD(aIdExt, '2854035')
    //     AADD(aIdExt, '2854048')
    //     AADD(aIdExt, '2854049')
    //     AADD(aIdExt, '2854050')
    //     AADD(aIdExt, '2854086')
    //     AADD(aIdExt, '2854090')
    //     AADD(aIdExt, '2854152')
    //     AADD(aIdExt, '2854152')
    //     AADD(aIdExt, '2854191')
    //     AADD(aIdExt, '2854216')
    //     AADD(aIdExt, '2854235')
    //     AADD(aIdExt, '2854252')
    //     AADD(aIdExt, '2854258')
    //     AADD(aIdExt, '2854258')
    //     AADD(aIdExt, '2854266')
    //     AADD(aIdExt, '2854267')
    //     AADD(aIdExt, '2854275')
    //     AADD(aIdExt, '2854277')
    //     AADD(aIdExt, '2854277')
    //     AADD(aIdExt, '2854278')
    //     AADD(aIdExt, '2854286')
    //     AADD(aIdExt, '2854292')
    //     AADD(aIdExt, '2854302')
    //     AADD(aIdExt, '2854308')
    //     AADD(aIdExt, '2854312')
    //     AADD(aIdExt, '2854313')
    //     AADD(aIdExt, '2854322')
    //     AADD(aIdExt, '2854323')
    //     AADD(aIdExt, '2854342')
    //     AADD(aIdExt, '2854342')
    //     AADD(aIdExt, '2854359')
    //     AADD(aIdExt, '2854364')
    //     AADD(aIdExt, '2854389')
    //     AADD(aIdExt, '2854401')
    //     AADD(aIdExt, '2854401')
    //     AADD(aIdExt, '2854403')
    //     AADD(aIdExt, '2854406')
    //     AADD(aIdExt, '2854410')
    //     AADD(aIdExt, '2854414')
    //     AADD(aIdExt, '2854417')
    //     AADD(aIdExt, '2854417')
    //     AADD(aIdExt, '2854418')
    //     AADD(aIdExt, '2854419')
    //     AADD(aIdExt, '2854445')
    //     AADD(aIdExt, '2854448')
    //     AADD(aIdExt, '2854448')
    //     AADD(aIdExt, '2854453')
    //     AADD(aIdExt, '2854455')
    //     AADD(aIdExt, '2854455')
    //     AADD(aIdExt, '2854468')
    //     AADD(aIdExt, '2854473')
    //     AADD(aIdExt, '2854497')
    //     AADD(aIdExt, '2854542')
    //     AADD(aIdExt, '2854550')
    //     AADD(aIdExt, '2854557')
    //     AADD(aIdExt, '2854561')
    //     AADD(aIdExt, '2854574')
    //     AADD(aIdExt, '2854577')
    //     AADD(aIdExt, '2854577')
    //     AADD(aIdExt, '2854585')
    //     AADD(aIdExt, '2854608')
    //     AADD(aIdExt, '2854608')
    //     AADD(aIdExt, '2854617')
    //     AADD(aIdExt, '2854640')
    //     AADD(aIdExt, '2854661')
    //     AADD(aIdExt, '2854671')
    //     AADD(aIdExt, '2854686')
    //     AADD(aIdExt, '2854694')
    //     AADD(aIdExt, '2854695')
    //     AADD(aIdExt, '2854703')
    //     AADD(aIdExt, '2854711')
    //     AADD(aIdExt, '2854720')
    //     AADD(aIdExt, '2854726')
    //     AADD(aIdExt, '2854729')
    //     AADD(aIdExt, '2854732')
    //     AADD(aIdExt, '2854740')
    //     AADD(aIdExt, '2854752')
    //     AADD(aIdExt, '2854774')
    //     AADD(aIdExt, '2854787')
    //     AADD(aIdExt, '2854790')
    //     AADD(aIdExt, '2854811')
    //     AADD(aIdExt, '2854814')
    //     AADD(aIdExt, '2854823')
    //     AADD(aIdExt, '2854829')
    //     AADD(aIdExt, '2854839')
    //     AADD(aIdExt, '2854839')
    //     AADD(aIdExt, '2854841')
    //     AADD(aIdExt, '2854850')
    //     AADD(aIdExt, '2854894')
    //     AADD(aIdExt, '2854895')
    //     AADD(aIdExt, '2854901')
    //     AADD(aIdExt, '2854909')
    //     AADD(aIdExt, '2854929')
    //     AADD(aIdExt, '2854941')
    //     AADD(aIdExt, '2854945')
    //     AADD(aIdExt, '2854978')
    //     AADD(aIdExt, '2854989')
    //     AADD(aIdExt, '2855008')
    //     AADD(aIdExt, '2855020')
    //     AADD(aIdExt, '2855048')
    //     AADD(aIdExt, '2855057')
    //     AADD(aIdExt, '2855085')
    //     AADD(aIdExt, '2855098')
    //     AADD(aIdExt, '2855098')
    //     AADD(aIdExt, '2855109')
    //     AADD(aIdExt, '2855110')
    //     AADD(aIdExt, '2855122')
    //     AADD(aIdExt, '2855131')
    //     AADD(aIdExt, '2855135')
    //     AADD(aIdExt, '2855169')
    //     AADD(aIdExt, '2855175')
    //     AADD(aIdExt, '2855175')
    //     AADD(aIdExt, '2855175')
    //     AADD(aIdExt, '2855179')
    //     AADD(aIdExt, '2855190')
    //     AADD(aIdExt, '2855200')
    //     AADD(aIdExt, '2855203')
    //     AADD(aIdExt, '2855207')
    //     AADD(aIdExt, '2855222')
    //     AADD(aIdExt, '2855223')
    //     AADD(aIdExt, '2855232')
    //     AADD(aIdExt, '2855248')
    //     AADD(aIdExt, '2855260')
    //     AADD(aIdExt, '2855260')
    //     AADD(aIdExt, '2855260')
    //     AADD(aIdExt, '2855280')
    //     AADD(aIdExt, '2855285')
    //     AADD(aIdExt, '2855288')
    //     AADD(aIdExt, '2855295')
    //     AADD(aIdExt, '2855312')
    //     AADD(aIdExt, '2855312')
    //     AADD(aIdExt, '2855331')
    //     AADD(aIdExt, '2855336')
    //     AADD(aIdExt, '2855338')
    //     AADD(aIdExt, '2855355')
    //     AADD(aIdExt, '2855375')
    //     AADD(aIdExt, '2855377')
    //     AADD(aIdExt, '2855379')
    //     AADD(aIdExt, '2855389')
    //     AADD(aIdExt, '2855405')
    //     AADD(aIdExt, '2855407')
    //     AADD(aIdExt, '2855440')
    //     AADD(aIdExt, '2855440')
    //     AADD(aIdExt, '2855448')
    //     AADD(aIdExt, '2855458')
    //     AADD(aIdExt, '2855466')
    //     AADD(aIdExt, '2855477')
    //     AADD(aIdExt, '2855477')
    //     AADD(aIdExt, '2855502')
    //     AADD(aIdExt, '2855509')
    //     AADD(aIdExt, '2855520')
    //     AADD(aIdExt, '2855524')
    //     AADD(aIdExt, '2855524')
    //     AADD(aIdExt, '2855524')
    //     AADD(aIdExt, '2855545')
    //     AADD(aIdExt, '2855560')
    //     AADD(aIdExt, '2855583')
    //     AADD(aIdExt, '2855587')
    //     AADD(aIdExt, '2855594')
    //     AADD(aIdExt, '2855598')
    //     AADD(aIdExt, '2855605')
    //     AADD(aIdExt, '2855605')
    //     AADD(aIdExt, '2855606')
    //     AADD(aIdExt, '2855628')
    //     AADD(aIdExt, '2855648')
    //     AADD(aIdExt, '2855659')
    //     AADD(aIdExt, '2855691')
    //     AADD(aIdExt, '2855693')
    //     AADD(aIdExt, '2855695')
    //     AADD(aIdExt, '2855709')
    //     AADD(aIdExt, '2855717')
    //     AADD(aIdExt, '2855721')
    //     AADD(aIdExt, '2855743')
    //     AADD(aIdExt, '2855745')
    //     AADD(aIdExt, '2855747')
    //     AADD(aIdExt, '2855753')
    //     AADD(aIdExt, '2855753')
    //     AADD(aIdExt, '2855763')
    //     AADD(aIdExt, '2855763')
    //     AADD(aIdExt, '2855765')
    //     AADD(aIdExt, '2855765')
    //     AADD(aIdExt, '2855777')
    //     AADD(aIdExt, '2855789')
    //     AADD(aIdExt, '2855789')
    //     AADD(aIdExt, '2855796')
    //     AADD(aIdExt, '2855800')
    //     AADD(aIdExt, '2855828')
    //     AADD(aIdExt, '2855835')
    //     AADD(aIdExt, '2855836')
    //     AADD(aIdExt, '2855887')
    //     AADD(aIdExt, '2855898')
    //     AADD(aIdExt, '2855949')
    //     AADD(aIdExt, '2855950')
    //     AADD(aIdExt, '2855950')
    //     AADD(aIdExt, '2855975')
    //     AADD(aIdExt, '2855975')
    //     AADD(aIdExt, '2855982')
    //     AADD(aIdExt, '2856008')
    //     AADD(aIdExt, '2856015')
    //     AADD(aIdExt, '2856021')
    //     AADD(aIdExt, '2856032')
    //     AADD(aIdExt, '2856061')
    //     AADD(aIdExt, '2856081')
    //     AADD(aIdExt, '2856082')
    //     AADD(aIdExt, '2856128')
    //     AADD(aIdExt, '2856131')
    //     AADD(aIdExt, '2856152')
    //     AADD(aIdExt, '2856153')
    //     AADD(aIdExt, '2856167')
    //     AADD(aIdExt, '2856168')
    //     AADD(aIdExt, '2856171')
    //     AADD(aIdExt, '2856197')
    //     AADD(aIdExt, '2856205')
    //     AADD(aIdExt, '2856242')
    //     AADD(aIdExt, '2856252')
    //     AADD(aIdExt, '2856273')
    //     AADD(aIdExt, '2856289')
    //     AADD(aIdExt, '2856306')
    //     AADD(aIdExt, '2856317')
    //     AADD(aIdExt, '2856319')
    //     AADD(aIdExt, '2856324')
    //     AADD(aIdExt, '2856334')
    //     AADD(aIdExt, '2856340')
    //     AADD(aIdExt, '2856340')
    //     AADD(aIdExt, '2856361')
    //     AADD(aIdExt, '2856416')
    //     AADD(aIdExt, '2856424')
    //     AADD(aIdExt, '2856427')
    //     AADD(aIdExt, '2856440')
    //     AADD(aIdExt, '2856473')
    //     AADD(aIdExt, '2856475')
    //     AADD(aIdExt, '2856478')
    //     AADD(aIdExt, '2856495')
    //     AADD(aIdExt, '2856496')
    //     AADD(aIdExt, '2856496')
    //     AADD(aIdExt, '2856524')
    //     AADD(aIdExt, '2856524')
    //     AADD(aIdExt, '2856533')
    //     AADD(aIdExt, '2856539')
    //     AADD(aIdExt, '2856567')
    //     AADD(aIdExt, '2856594')
    //     AADD(aIdExt, '2856594')
    //     AADD(aIdExt, '2856604')
    //     AADD(aIdExt, '2856604')
    //     AADD(aIdExt, '2856619')
    //     AADD(aIdExt, '2856648')
    //     AADD(aIdExt, '2856670')
    //     AADD(aIdExt, '2856670')
    //     AADD(aIdExt, '2856671')
    //     AADD(aIdExt, '2856680')
    //     AADD(aIdExt, '2856697')
    //     AADD(aIdExt, '2856700')
    //     AADD(aIdExt, '2856705')
    //     AADD(aIdExt, '2856718')
    //     AADD(aIdExt, '2856731')
    //     AADD(aIdExt, '2856731')
    //     AADD(aIdExt, '2856748')
    //     AADD(aIdExt, '2856777')
    //     AADD(aIdExt, '2856777')
    //     AADD(aIdExt, '2856795')
    //     AADD(aIdExt, '2856808')
    //     AADD(aIdExt, '2856814')
    //     AADD(aIdExt, '2856827')
    //     AADD(aIdExt, '2856837')
    //     AADD(aIdExt, '2856859')
    //     AADD(aIdExt, '2856887')
    //     AADD(aIdExt, '2856888')
    //     AADD(aIdExt, '2856916')
    //     AADD(aIdExt, '2856918')
    //     AADD(aIdExt, '2856927')
    //     AADD(aIdExt, '2856978')
    //     AADD(aIdExt, '2857009')
    //     AADD(aIdExt, '2857010')
    //     AADD(aIdExt, '2857013')
    //     AADD(aIdExt, '2857013')
    //     AADD(aIdExt, '2857026')
    //     AADD(aIdExt, '2857026')
    //     AADD(aIdExt, '2857040')
    //     AADD(aIdExt, '2857050')
    //     AADD(aIdExt, '2857050')
    //     AADD(aIdExt, '2857068')
    //     AADD(aIdExt, '2857081')
    //     AADD(aIdExt, '2857085')
    //     AADD(aIdExt, '2857085')
    //     AADD(aIdExt, '2857086')
    //     AADD(aIdExt, '2857109')
    //     AADD(aIdExt, '2857123')
    //     AADD(aIdExt, '2857154')
    //     AADD(aIdExt, '2857169')
    //     AADD(aIdExt, '2857172')
    //     AADD(aIdExt, '2857176')
    //     AADD(aIdExt, '2857177')
    //     AADD(aIdExt, '2857180')
    //     AADD(aIdExt, '2857183')
    //     AADD(aIdExt, '2857183')
    //     AADD(aIdExt, '2857193')
    //     AADD(aIdExt, '2857198')
    //     AADD(aIdExt, '2857198')
    //     AADD(aIdExt, '2857203')
    //     AADD(aIdExt, '2857216')
    //     AADD(aIdExt, '2857217')
    //     AADD(aIdExt, '2857227')
    //     AADD(aIdExt, '2857229')
    //     AADD(aIdExt, '2857238')
    //     AADD(aIdExt, '2857238')
    //     AADD(aIdExt, '2857255')
    //     AADD(aIdExt, '2857271')
    //     AADD(aIdExt, '2857274')
    //     AADD(aIdExt, '2857286')
    //     AADD(aIdExt, '2857294')
    //     AADD(aIdExt, '2857302')
    //     AADD(aIdExt, '2857317')
    //     AADD(aIdExt, '2857325')
    //     AADD(aIdExt, '2857335')
    //     AADD(aIdExt, '2857345')
    //     AADD(aIdExt, '2857362')
    //     AADD(aIdExt, '2857383')
    //     AADD(aIdExt, '2857416')
    //     AADD(aIdExt, '2857416')
    //     AADD(aIdExt, '2857423')
    //     AADD(aIdExt, '2857432')
    //     AADD(aIdExt, '2857439')
    //     AADD(aIdExt, '2857473')
    //     AADD(aIdExt, '2857473')
    //     AADD(aIdExt, '2857474')
    //     AADD(aIdExt, '2857482')
    //     AADD(aIdExt, '2857503')
    //     AADD(aIdExt, '2857539')
    //     AADD(aIdExt, '2857542')
    //     AADD(aIdExt, '2857563')
    //     AADD(aIdExt, '2857585')
    //     AADD(aIdExt, '2857590')
    //     AADD(aIdExt, '2857590')
    //     AADD(aIdExt, '2857626')
    //     AADD(aIdExt, '2857649')
    //     AADD(aIdExt, '2857690')
    //     AADD(aIdExt, '2857696')
    //     AADD(aIdExt, '2857703')
    //     AADD(aIdExt, '2857730')
    //     AADD(aIdExt, '2857741')
    //     AADD(aIdExt, '2857745')
    //     AADD(aIdExt, '2857787')
    //     AADD(aIdExt, '2857794')
    //     AADD(aIdExt, '2857802')
    //     AADD(aIdExt, '2857819')
    //     AADD(aIdExt, '2857851')
    //     AADD(aIdExt, '2857860')
    //     AADD(aIdExt, '2857867')
    //     AADD(aIdExt, '2857930')
    //     AADD(aIdExt, '2857939')
    //     AADD(aIdExt, '2857947')
    //     AADD(aIdExt, '2857949')
    //     AADD(aIdExt, '2857962')
    //     AADD(aIdExt, '2857969')
    //     AADD(aIdExt, '2857971')
    //     AADD(aIdExt, '2857992')
    //     AADD(aIdExt, '2857992')
    //     AADD(aIdExt, '2857993')
    //     AADD(aIdExt, '2857996')
    //     AADD(aIdExt, '2857998')
    //     AADD(aIdExt, '2858009')
    //     AADD(aIdExt, '2858039')
    //     AADD(aIdExt, '2858050')
    //     AADD(aIdExt, '2858077')
    //     AADD(aIdExt, '2858088')
    //     AADD(aIdExt, '2858093')
    //     AADD(aIdExt, '2858140')
    //     AADD(aIdExt, '2858140')
    //     AADD(aIdExt, '2858155')
    //     AADD(aIdExt, '2858156')
    //     AADD(aIdExt, '2858159')
    //     AADD(aIdExt, '2858163')
    //     AADD(aIdExt, '2858166')
    //     AADD(aIdExt, '2858178')
    //     AADD(aIdExt, '2858178')
    //     AADD(aIdExt, '2858179')
    //     AADD(aIdExt, '2858206')
    //     AADD(aIdExt, '2858206')
    //     AADD(aIdExt, '2858207')
    //     AADD(aIdExt, '2858209')
    //     AADD(aIdExt, '2858231')
    //     AADD(aIdExt, '2858238')
    //     AADD(aIdExt, '2858254')
    //     AADD(aIdExt, '2858262')
    //     AADD(aIdExt, '2858264')
    //     AADD(aIdExt, '2858266')
    //     AADD(aIdExt, '2858294')
    //     AADD(aIdExt, '2858305')
    //     AADD(aIdExt, '2858307')
    //     AADD(aIdExt, '2858310')
    //     AADD(aIdExt, '2858326')
    //     AADD(aIdExt, '2858327')
    //     AADD(aIdExt, '2858328')
    //     AADD(aIdExt, '2858329')
    //     AADD(aIdExt, '2858332')
    //     AADD(aIdExt, '2858376')
    //     AADD(aIdExt, '2858392')
    //     AADD(aIdExt, '2858426')
    //     AADD(aIdExt, '2858450')
    //     AADD(aIdExt, '2858450')
    //     AADD(aIdExt, '2858476')
    //     AADD(aIdExt, '2858478')
    //     AADD(aIdExt, '2858484')
    //     AADD(aIdExt, '2858484')
    //     AADD(aIdExt, '2858491')
    //     AADD(aIdExt, '2858491')
    //     AADD(aIdExt, '2858508')
    //     AADD(aIdExt, '2858515')
    //     AADD(aIdExt, '2858525')
    //     AADD(aIdExt, '2858540')
    //     AADD(aIdExt, '2858541')
    //     AADD(aIdExt, '2858546')
    //     AADD(aIdExt, '2858546')
    //     AADD(aIdExt, '2858555')
    //     AADD(aIdExt, '2858563')
    //     AADD(aIdExt, '2858576')
    //     AADD(aIdExt, '2858593')
    //     AADD(aIdExt, '2858597')
    //     AADD(aIdExt, '2858607')
    //     AADD(aIdExt, '2858608')
    //     AADD(aIdExt, '2858613')
    //     AADD(aIdExt, '2858639')
    //     AADD(aIdExt, '2858647')
    //     AADD(aIdExt, '2858648')
    //     AADD(aIdExt, '2858656')
    //     AADD(aIdExt, '2858659')
    //     AADD(aIdExt, '2858660')
    //     AADD(aIdExt, '2858701')
    //     AADD(aIdExt, '2858704')
    //     AADD(aIdExt, '2858710')
    //     AADD(aIdExt, '2858729')
    //     AADD(aIdExt, '2858747')
    //     AADD(aIdExt, '2858756')
    //     AADD(aIdExt, '2858808')
    //     AADD(aIdExt, '2858816')
    //     AADD(aIdExt, '2858818')
    //     AADD(aIdExt, '2858818')
    //     AADD(aIdExt, '2858839')
    //     AADD(aIdExt, '2858882')
    //     AADD(aIdExt, '2858891')
    //     AADD(aIdExt, '2858897')
    //     AADD(aIdExt, '2858925')
    //     AADD(aIdExt, '2858946')
    //     AADD(aIdExt, '2858960')
    //     AADD(aIdExt, '2858996')
    //     AADD(aIdExt, '2859007')
    //     AADD(aIdExt, '2859007')
    //     AADD(aIdExt, '2859039')
    //     AADD(aIdExt, '2859041')
    //     AADD(aIdExt, '2859047')
    //     AADD(aIdExt, '2859062')
    //     AADD(aIdExt, '2859073')
    //     AADD(aIdExt, '2859111')
    //     AADD(aIdExt, '2859113')
    //     AADD(aIdExt, '2859139')
    //     AADD(aIdExt, '2859145')
    //     AADD(aIdExt, '2859148')
    //     AADD(aIdExt, '2859165')
    //     AADD(aIdExt, '2859182')
    //     AADD(aIdExt, '2859185')
    //     AADD(aIdExt, '2859199')
    //     AADD(aIdExt, '2859202')
    //     AADD(aIdExt, '2859230')
    //     AADD(aIdExt, '2859247')
    //     AADD(aIdExt, '2859248')
    //     AADD(aIdExt, '2859250')
    //     AADD(aIdExt, '2859255')
    //     AADD(aIdExt, '2859274')
    //     AADD(aIdExt, '2859281')
    //     AADD(aIdExt, '2859285')
    //     AADD(aIdExt, '2859311')
    //     AADD(aIdExt, '2859325')
    //     AADD(aIdExt, '2859325')
    //     AADD(aIdExt, '2859336')
    //     AADD(aIdExt, '2859337')
    //     AADD(aIdExt, '2859346')
    //     AADD(aIdExt, '2859356')
    //     AADD(aIdExt, '2859378')
    //     AADD(aIdExt, '2859380')
    //     AADD(aIdExt, '2859387')
    //     AADD(aIdExt, '2859399')
    //     AADD(aIdExt, '2859399')
    //     AADD(aIdExt, '2859418')
    //     AADD(aIdExt, '2859422')
    //     AADD(aIdExt, '2859431')
    //     AADD(aIdExt, '2859438')
    //     AADD(aIdExt, '2859448')
    //     AADD(aIdExt, '2859449')
    //     AADD(aIdExt, '2859470')
    //     AADD(aIdExt, '2859488')
    //     AADD(aIdExt, '2859488')
    //     AADD(aIdExt, '2859489')
    //     AADD(aIdExt, '2859500')
    //     AADD(aIdExt, '2859514')
    //     AADD(aIdExt, '2859516')
    //     AADD(aIdExt, '2859533')
    //     AADD(aIdExt, '2859546')
    //     AADD(aIdExt, '2859581')
    //     AADD(aIdExt, '2859590')
    //     AADD(aIdExt, '2859603')
    //     AADD(aIdExt, '2859608')
    //     AADD(aIdExt, '2859648')
    //     AADD(aIdExt, '2859651')
    //     AADD(aIdExt, '2859685')
    //     AADD(aIdExt, '2859685')
    //     AADD(aIdExt, '2859702')
    //     AADD(aIdExt, '2859703')
    //     AADD(aIdExt, '2859703')
    //     AADD(aIdExt, '2859705')
    //     AADD(aIdExt, '2859706')
    //     AADD(aIdExt, '2859728')
    //     AADD(aIdExt, '2859734')
    //     AADD(aIdExt, '2859735')
    //     AADD(aIdExt, '2859750')
    //     AADD(aIdExt, '2859753')
    //     AADD(aIdExt, '2859757')
    //     AADD(aIdExt, '2859770')
    //     AADD(aIdExt, '2859786')
    //     AADD(aIdExt, '2859786')
    //     AADD(aIdExt, '2859789')
    //     AADD(aIdExt, '2859803')
    //     AADD(aIdExt, '2859817')
    //     AADD(aIdExt, '2859828')
    //     AADD(aIdExt, '2859835')
    //     AADD(aIdExt, '2859850')
    //     AADD(aIdExt, '2859851')
    //     AADD(aIdExt, '2859883')
    //     AADD(aIdExt, '2859888')
    //     AADD(aIdExt, '2859890')
    //     AADD(aIdExt, '2859907')
    //     AADD(aIdExt, '2859916')
    //     AADD(aIdExt, '2859916')
    //     AADD(aIdExt, '2859927')
    //     AADD(aIdExt, '2859957')
    //     AADD(aIdExt, '2859988')
    //     AADD(aIdExt, '2859999')
    //     AADD(aIdExt, '2860005')
    //     AADD(aIdExt, '2860008')
    //     AADD(aIdExt, '2860017')
    //     AADD(aIdExt, '2860025')
    //     AADD(aIdExt, '2860025')
    //     AADD(aIdExt, '2860025')
    //     AADD(aIdExt, '2860042')
    //     AADD(aIdExt, '2860059')
    //     AADD(aIdExt, '2860065')
    //     AADD(aIdExt, '2860070')
    //     AADD(aIdExt, '2860070')
    //     AADD(aIdExt, '2860085')
    //     AADD(aIdExt, '2860107')
    //     AADD(aIdExt, '2860124')
    //     AADD(aIdExt, '2860127')
    //     AADD(aIdExt, '2860135')
    //     AADD(aIdExt, '2860155')
    //     AADD(aIdExt, '2860198')
    //     AADD(aIdExt, '2860237')
    //     AADD(aIdExt, '2860259')
    //     AADD(aIdExt, '2860276')
    //     AADD(aIdExt, '2860302')
    //     AADD(aIdExt, '2860336')
    //     AADD(aIdExt, '2860341')
    //     AADD(aIdExt, '2860341')
    //     AADD(aIdExt, '2860377')
    //     AADD(aIdExt, '2860410')
    //     AADD(aIdExt, '2860414')
    //     AADD(aIdExt, '2860417')
    //     AADD(aIdExt, '2860459')
    //     AADD(aIdExt, '2860459')
    //     AADD(aIdExt, '2860462')
    //     AADD(aIdExt, '2860491')
    //     AADD(aIdExt, '2860513')
    //     AADD(aIdExt, '2860534')
    //     AADD(aIdExt, '2860542')
    //     AADD(aIdExt, '2860551')
    //     AADD(aIdExt, '2860565')
    //     AADD(aIdExt, '2860583')
    //     AADD(aIdExt, '2860587')
    //     AADD(aIdExt, '2860589')
    //     AADD(aIdExt, '2860617')
    //     AADD(aIdExt, '2860629')
    //     AADD(aIdExt, '2860634')
    //     AADD(aIdExt, '2860636')
    //     AADD(aIdExt, '2860636')
    //     AADD(aIdExt, '2860640')
    //     AADD(aIdExt, '2860640')
    //     AADD(aIdExt, '2860658')
    //     AADD(aIdExt, '2860664')
    //     AADD(aIdExt, '2860686')
    //     AADD(aIdExt, '2860689')
    //     AADD(aIdExt, '2860707')
    //     AADD(aIdExt, '2860753')
    //     AADD(aIdExt, '2860760')
    //     AADD(aIdExt, '2860764')
    //     AADD(aIdExt, '2860771')
    //     AADD(aIdExt, '2860809')
    //     AADD(aIdExt, '2860887')
    //     AADD(aIdExt, '2860894')
    //     AADD(aIdExt, '2860930')
    //     AADD(aIdExt, '2860953')
    //     AADD(aIdExt, '2860953')
    //     AADD(aIdExt, '2860953')
    //     AADD(aIdExt, '2860963')
    //     AADD(aIdExt, '2860963')
    //     AADD(aIdExt, '2860982')
    //     AADD(aIdExt, '2861001')
    //     AADD(aIdExt, '2861015')
    //     AADD(aIdExt, '2861042')
    //     AADD(aIdExt, '2861065')
    //     AADD(aIdExt, '2861074')
    //     AADD(aIdExt, '2861074')
    //     AADD(aIdExt, '2861078')
    //     AADD(aIdExt, '2861084')
    //     AADD(aIdExt, '2861122')
    //     AADD(aIdExt, '2861141')
    //     AADD(aIdExt, '2861164')
    //     AADD(aIdExt, '2861166')
    //     AADD(aIdExt, '2861182')
    //     AADD(aIdExt, '2861209')
    //     AADD(aIdExt, '2861223')
    //     AADD(aIdExt, '2861244')
    //     AADD(aIdExt, '2861253')
    //     AADD(aIdExt, '2861263')
    //     AADD(aIdExt, '2861274')
    //     AADD(aIdExt, '2861278')
    //     AADD(aIdExt, '2861278')
    //     AADD(aIdExt, '2861297')
    //     AADD(aIdExt, '2861297')
    //     AADD(aIdExt, '2861310')
    //     AADD(aIdExt, '2861313')
    //     AADD(aIdExt, '2861317')
    //     AADD(aIdExt, '2861327')
    //     AADD(aIdExt, '2861426')
    //     AADD(aIdExt, '2861461')
    //     AADD(aIdExt, '2861462')
    //     AADD(aIdExt, '2861495')
    //     AADD(aIdExt, '2861500')
    //     AADD(aIdExt, '2861500')
    //     AADD(aIdExt, '2861519')
    //     AADD(aIdExt, '2861521')
    //     AADD(aIdExt, '2861543')
    //     AADD(aIdExt, '2861551')
    //     AADD(aIdExt, '2861553')
    //     AADD(aIdExt, '2861578')
    //     AADD(aIdExt, '2861602')
    //     AADD(aIdExt, '2861624')
    //     AADD(aIdExt, '2861629')
    //     AADD(aIdExt, '2861645')
    //     AADD(aIdExt, '2861678')
    //     AADD(aIdExt, '2861708')
    //     AADD(aIdExt, '2861732')
    //     AADD(aIdExt, '2861758')
    //     AADD(aIdExt, '2861777')
    //     AADD(aIdExt, '2861786')
    //     AADD(aIdExt, '2861786')
    //     AADD(aIdExt, '2861799')
    //     AADD(aIdExt, '2861807')
    //     AADD(aIdExt, '2861809')
    //     AADD(aIdExt, '2861810')
    //     AADD(aIdExt, '2861810')
    //     AADD(aIdExt, '2861827')
    //     AADD(aIdExt, '2861852')
    //     AADD(aIdExt, '2861865')
    //     AADD(aIdExt, '2861867')
    //     AADD(aIdExt, '2861887')
    //     AADD(aIdExt, '2861907')
    //     AADD(aIdExt, '2861918')
    //     AADD(aIdExt, '2861918')
    //     AADD(aIdExt, '2861918')
    //     AADD(aIdExt, '2861936')
    //     AADD(aIdExt, '2861957')
    //     AADD(aIdExt, '2861967')
    //     AADD(aIdExt, '2862033')
    //     AADD(aIdExt, '2862044')
    //     AADD(aIdExt, '2862054')
    //     AADD(aIdExt, '2862094')
    //     AADD(aIdExt, '2862099')
    //     AADD(aIdExt, '2862150')
    //     AADD(aIdExt, '2862179')
    //     AADD(aIdExt, '2862222')
    //     AADD(aIdExt, '2862239')
    //     AADD(aIdExt, '2862239')
    //     AADD(aIdExt, '2862289')
    //     AADD(aIdExt, '2862323')
    //     AADD(aIdExt, '2862330')
    //     AADD(aIdExt, '2862330')
    //     AADD(aIdExt, '2862358')
    //     AADD(aIdExt, '2832194')
    //     AADD(aIdExt, '2834538')
    //     AADD(aIdExt, '2834538')
    //     AADD(aIdExt, '2834631')
    //     AADD(aIdExt, '2834926')
    //     AADD(aIdExt, '2834967')
    //     AADD(aIdExt, '2835018')
    //     AADD(aIdExt, '2835190')
    //     AADD(aIdExt, '2835191')
    //     AADD(aIdExt, '2835214')
    //     AADD(aIdExt, '2863388')
    //     AADD(aIdExt, '2864175')
    //     AADD(aIdExt, '2864509')
    //     AADD(aIdExt, '2835414')
    //     AADD(aIdExt, '2866497')
    //     AADD(aIdExt, '2866867')
    //     AADD(aIdExt, '2835774')
    //     AADD(aIdExt, '2835899')
    //     AADD(aIdExt, '2836046')
    //     AADD(aIdExt, '2836296')
    //     AADD(aIdExt, '2836459')
    //     AADD(aIdExt, '2867232')
    //     AADD(aIdExt, '2837299')
    //     AADD(aIdExt, '2837324')
    //     AADD(aIdExt, '2837325')
    //     AADD(aIdExt, '2837375')
    //     AADD(aIdExt, '2837488')
    //     AADD(aIdExt, '2837523')
    //     AADD(aIdExt, '2837613')
    //     AADD(aIdExt, '2837749')
    //     AADD(aIdExt, '2837814')
    //     AADD(aIdExt, '2837884')
    //     AADD(aIdExt, '2838039')
    //     AADD(aIdExt, '2838298')
    //     AADD(aIdExt, '2868132')
    //     AADD(aIdExt, '2838521')
    //     AADD(aIdExt, '2838558')
    //     AADD(aIdExt, '2839064')
    //     AADD(aIdExt, '2839206')
    //     AADD(aIdExt, '2839431')
    //     AADD(aIdExt, '2839463')
    //     AADD(aIdExt, '2839519')
    //     AADD(aIdExt, '2811597')
    //     AADD(aIdExt, '2839770')
    //     AADD(aIdExt, '2840393')
    //     AADD(aIdExt, '2840468')
    //     AADD(aIdExt, '2840834')
    //     AADD(aIdExt, '2841268')
    //     AADD(aIdExt, '2841292')
    //     AADD(aIdExt, '2841361')
    //     AADD(aIdExt, '2841531')
    //     AADD(aIdExt, '2841569')
    //     AADD(aIdExt, '2841692')
    //     AADD(aIdExt, '2841754')
    //     AADD(aIdExt, '2869855')
    //     AADD(aIdExt, '2869950')
    //     AADD(aIdExt, '2870307')
    //     AADD(aIdExt, '2870951')
    //     AADD(aIdExt, '2871584')
    //     AADD(aIdExt, '2872534')
    //     AADD(aIdExt, '2872785')
    //     AADD(aIdExt, '2873000')
    //     AADD(aIdExt, '2873101')
    //     AADD(aIdExt, '2873344')
    //     AADD(aIdExt, '2842010')
    //     AADD(aIdExt, '2842348')
    //     AADD(aIdExt, '2842485')
    //     AADD(aIdExt, '2842598')
    //     AADD(aIdExt, '2842672')
    //     AADD(aIdExt, '2842700')
    //     AADD(aIdExt, '2842867')
    //     AADD(aIdExt, '2843016')
    //     AADD(aIdExt, '2843087')
    //     AADD(aIdExt, '2843129')
    //     AADD(aIdExt, '2843242')
    //     AADD(aIdExt, '2873918')
    //     AADD(aIdExt, '2873956')
    //     AADD(aIdExt, '2873961')
    //     AADD(aIdExt, '2874022')
    //     AADD(aIdExt, '2874597')
    //     AADD(aIdExt, '2843692')
    //     AADD(aIdExt, '2844052')
    //     AADD(aIdExt, '2844060')
    //     AADD(aIdExt, '2844272')
    //     AADD(aIdExt, '2844303')
    //     AADD(aIdExt, '2844494')
    //     AADD(aIdExt, '2844499')
    //     AADD(aIdExt, '2844638')
    //     AADD(aIdExt, '2844659')
    //     AADD(aIdExt, '2844741')
    //     AADD(aIdExt, '2844834')
    //     AADD(aIdExt, '2875539')
    //     AADD(aIdExt, '2875825')
    //     AADD(aIdExt, '2875825')
    //     AADD(aIdExt, '2876155')
    //     AADD(aIdExt, '2845096')
    //     AADD(aIdExt, '2845175')
    //     AADD(aIdExt, '2845221')
    //     AADD(aIdExt, '2845307')
    //     AADD(aIdExt, '2845362')
    //     AADD(aIdExt, '2845380')
    //     AADD(aIdExt, '2845403')
    //     AADD(aIdExt, '2845458')
    //     AADD(aIdExt, '2845566')
    //     AADD(aIdExt, '2845577')
    //     AADD(aIdExt, '2845813')
    //     AADD(aIdExt, '2845813')
    //     AADD(aIdExt, '2845966')
    //     AADD(aIdExt, '2845975')
    //     AADD(aIdExt, '2846017')
    //     AADD(aIdExt, '2846444')
    //     AADD(aIdExt, '2846499')
    //     AADD(aIdExt, '2846501')
    //     AADD(aIdExt, '2846574')
    //     AADD(aIdExt, '2846599')
    //     AADD(aIdExt, '2846845')
    //     AADD(aIdExt, '2846890')
    //     AADD(aIdExt, '2847157')
    //     AADD(aIdExt, '2847171')
    //     AADD(aIdExt, '2847531')
    //     AADD(aIdExt, '2847600')
    //     AADD(aIdExt, '2847698')
    //     AADD(aIdExt, '2847744')
    //     AADD(aIdExt, '2848020')
    //     AADD(aIdExt, '2848225')
    //     AADD(aIdExt, '2848675')
    //     AADD(aIdExt, '2848689')
    //     AADD(aIdExt, '2876650')
    //     AADD(aIdExt, '2876680')
    //     AADD(aIdExt, '2877082')
    //     AADD(aIdExt, '2848849')
    //     AADD(aIdExt, '2848980')
    //     AADD(aIdExt, '2849097')
    //     AADD(aIdExt, '2849177')
    //     AADD(aIdExt, '2849177')
    //     AADD(aIdExt, '2849318')
    //     AADD(aIdExt, '2849491')
    //     AADD(aIdExt, '2849563')
    //     AADD(aIdExt, '2849576')
    //     AADD(aIdExt, '2849753')
    //     AADD(aIdExt, '2849793')
    //     AADD(aIdExt, '2849995')
    //     AADD(aIdExt, '2850044')
    //     AADD(aIdExt, '2850081')
    //     AADD(aIdExt, '2850294')
    //     AADD(aIdExt, '2850569')
    //     AADD(aIdExt, '2850644')
    //     AADD(aIdExt, '2850655')
    //     AADD(aIdExt, '2850679')
    //     AADD(aIdExt, '2850821')
    //     AADD(aIdExt, '2850920')
    //     AADD(aIdExt, '2851022')
    //     AADD(aIdExt, '2851082')
    //     AADD(aIdExt, '2851592')
    //     AADD(aIdExt, '2851718')
    //     AADD(aIdExt, '2851828')
    //     AADD(aIdExt, '2851860')
    //     AADD(aIdExt, '2823679')
    //     AADD(aIdExt, '2852085')
    //     AADD(aIdExt, '2852186')
    //     AADD(aIdExt, '2852218')
    //     AADD(aIdExt, '2852253')
    //     AADD(aIdExt, '2852612')
    //     AADD(aIdExt, '2852793')
    //     AADD(aIdExt, '2853366')
    //     AADD(aIdExt, '2853408')
    //     AADD(aIdExt, '2853427')
    //     AADD(aIdExt, '2853473')
    //     AADD(aIdExt, '2854052')
    //     AADD(aIdExt, '2854626')
    //     AADD(aIdExt, '2854682')
    //     AADD(aIdExt, '2854702')
    //     AADD(aIdExt, '2854786')
    //     AADD(aIdExt, '2854934')
    //     AADD(aIdExt, '2854958')
    //     AADD(aIdExt, '2855208')
    //     AADD(aIdExt, '2855270')
    //     AADD(aIdExt, '2855286')
    //     AADD(aIdExt, '2855674')
    //     AADD(aIdExt, '2855708')
    //     AADD(aIdExt, '2828803')
    //     AADD(aIdExt, '2828803')
    //     AADD(aIdExt, '2855822')
    //     AADD(aIdExt, '2855926')
    //     AADD(aIdExt, '2856006')
    //     AADD(aIdExt, '2856111')
    //     AADD(aIdExt, '2856754')
    //     AADD(aIdExt, '2856867')
    //     AADD(aIdExt, '2857045')
    //     AADD(aIdExt, '2857519')
    //     AADD(aIdExt, '2857522')
    //     AADD(aIdExt, '2857584')
    //     AADD(aIdExt, '2857688')
    //     AADD(aIdExt, '2857763')
    //     AADD(aIdExt, '2858022')
    //     AADD(aIdExt, '2858022')
    //     AADD(aIdExt, '2858022')
    //     AADD(aIdExt, '2858171')
    //     AADD(aIdExt, '2858220')
    //     AADD(aIdExt, '2858365')
    //     AADD(aIdExt, '2858924')
    //     AADD(aIdExt, '2859571')
    //     AADD(aIdExt, '2859575')
    //     AADD(aIdExt, '2859623')
    //     AADD(aIdExt, '2860293')
    //     AADD(aIdExt, '2860323')
    //     AADD(aIdExt, '2860380')
    //     AADD(aIdExt, '2860450')
    //     AADD(aIdExt, '2860505')
    //     AADD(aIdExt, '2860635')
    //     AADD(aIdExt, '2860724')
    //     AADD(aIdExt, '2860995')
    //     AADD(aIdExt, '2861348')
    //     AADD(aIdExt, '2861574')
    //     AADD(aIdExt, '2861626')
    //     AADD(aIdExt, '2861633')
    //     AADD(aIdExt, '2861798')
    //     AADD(aIdExt, '2861994')

    // Return aIdExt
//feito - descontinuado - ficar como historico

METHOD VLDPRD(_EXTERNID, aPedid) class LIBGLASS
    Local cAlSC7    := GetNextAlias()
    Local lRet      := .F.
    Local X

    FOR X:=1 TO LEN(aPedid)
        cQuery := " SELECT C7_PRODUTO "
        cQuery += " FROM "+RetSQLName("SC7") + " AS C7 WITH (NOLOCK) "
        cQuery += " WHERE C7.D_E_L_E_T_ <> '*' AND C7_ZIDPDCI = '"+_EXTERNID+"' AND C7_PRODUTO = '"+aPedid[X,8]+"' "
        DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSC7, .F., .T.)    

        IF EMPTY((cAlSC7)->C7_PRODUTO)
            lRet := .T.
        ENDIF
        (cAlSC7)->(dbclosearea())
    NEXT

Return lRet

//feito - descontinuado - ficar como historico
    // Static Function aOrId()
    //     Local aIdExt := {}
    //     AADD(aIdExt, '2877925')
    //     AADD(aIdExt, '2877377')
    //     AADD(aIdExt, '2877117')
    //     AADD(aIdExt, '2876754')
    //     AADD(aIdExt, '2862330')
    //     AADD(aIdExt, '2862323')
    //     AADD(aIdExt, '2862289')
    //     AADD(aIdExt, '2862239')
    //     AADD(aIdExt, '2862222')
    //     AADD(aIdExt, '2862179')
    //     AADD(aIdExt, '2862150')
    //     AADD(aIdExt, '2862054')
    //     AADD(aIdExt, '2862044')
    //     AADD(aIdExt, '2862033')
    //     AADD(aIdExt, '2861967')
    //     AADD(aIdExt, '2861936')
    //     AADD(aIdExt, '2861907')
    //     AADD(aIdExt, '2861887')
    //     AADD(aIdExt, '2861867')
    //     AADD(aIdExt, '2861865')
    //     AADD(aIdExt, '2861852')
    //     AADD(aIdExt, '2861827')
    //     AADD(aIdExt, '2861809')
    //     AADD(aIdExt, '2861807')
    //     AADD(aIdExt, '2861786')
    //     AADD(aIdExt, '2861777')
    //     AADD(aIdExt, '2861732')
    //     AADD(aIdExt, '2861708')
    //     AADD(aIdExt, '2861629')
    //     AADD(aIdExt, '2861624')
    //     AADD(aIdExt, '2847046')
    //     AADD(aIdExt, '2847063')
    //     AADD(aIdExt, '2847080')
    //     AADD(aIdExt, '2847083')
    //     AADD(aIdExt, '2847128')
    //     AADD(aIdExt, '2847134')
    //     AADD(aIdExt, '2847140')
    //     AADD(aIdExt, '2847150')
    //     AADD(aIdExt, '2847154')
    //     AADD(aIdExt, '2861602')
    //     AADD(aIdExt, '2847161')
    //     AADD(aIdExt, '2847191')
    //     AADD(aIdExt, '2847205')
    //     AADD(aIdExt, '2847214')
    //     AADD(aIdExt, '2847232')
    //     AADD(aIdExt, '2847262')
    //     AADD(aIdExt, '2847304')
    //     AADD(aIdExt, '2847312')
    //     AADD(aIdExt, '2847320')
    //     AADD(aIdExt, '2847326')
    //     AADD(aIdExt, '2847389')
    //     AADD(aIdExt, '2847399')
    //     AADD(aIdExt, '2847435')
    //     AADD(aIdExt, '2847448')
    //     AADD(aIdExt, '2847450')
    //     AADD(aIdExt, '2847452')
    //     AADD(aIdExt, '2847463')
    //     AADD(aIdExt, '2847479')
    //     AADD(aIdExt, '2847528')
    //     AADD(aIdExt, '2847540')
    //     AADD(aIdExt, '2847551')
    //     AADD(aIdExt, '2847613')
    //     AADD(aIdExt, '2847621')
    //     AADD(aIdExt, '2847622')
    //     AADD(aIdExt, '2847646')
    //     AADD(aIdExt, '2847656')
    //     AADD(aIdExt, '2847659')
    //     AADD(aIdExt, '2847661')
    //     AADD(aIdExt, '2847663')
    //     AADD(aIdExt, '2847665')
    //     AADD(aIdExt, '2847670')
    //     AADD(aIdExt, '2847681')
    //     AADD(aIdExt, '2847689')
    //     AADD(aIdExt, '2847690')
    //     AADD(aIdExt, '2847727')
    //     AADD(aIdExt, '2847737')
    //     AADD(aIdExt, '2847747')
    //     AADD(aIdExt, '2847753')
    //     AADD(aIdExt, '2847766')
    //     AADD(aIdExt, '2847767')
    //     AADD(aIdExt, '2847809')
    //     AADD(aIdExt, '2847816')
    //     AADD(aIdExt, '2847817')
    //     AADD(aIdExt, '2847832')
    //     AADD(aIdExt, '2847834')
    //     AADD(aIdExt, '2847837')
    //     AADD(aIdExt, '2847864')
    //     AADD(aIdExt, '2847875')
    //     AADD(aIdExt, '2847877')
    //     AADD(aIdExt, '2847904')
    //     AADD(aIdExt, '2847905')
    //     AADD(aIdExt, '2847928')
    //     AADD(aIdExt, '2847932')
    //     AADD(aIdExt, '2847940')
    //     AADD(aIdExt, '2847963')
    //     AADD(aIdExt, '2847967')
    //     AADD(aIdExt, '2847999')
    //     AADD(aIdExt, '2848002')
    //     AADD(aIdExt, '2848009')
    //     AADD(aIdExt, '2848046')
    //     AADD(aIdExt, '2848086')
    //     AADD(aIdExt, '2848142')
    //     AADD(aIdExt, '2848160')
    //     AADD(aIdExt, '2848176')
    //     AADD(aIdExt, '2848182')
    //     AADD(aIdExt, '2848189')
    //     AADD(aIdExt, '2848193')
    //     AADD(aIdExt, '2848200')
    //     AADD(aIdExt, '2848208')
    //     AADD(aIdExt, '2848218')
    //     AADD(aIdExt, '2848247')
    //     AADD(aIdExt, '2848268')
    //     AADD(aIdExt, '2848283')
    //     AADD(aIdExt, '2848304')
    //     AADD(aIdExt, '2848308')
    //     AADD(aIdExt, '2848309')
    //     AADD(aIdExt, '2848312')
    //     AADD(aIdExt, '2848314')
    //     AADD(aIdExt, '2848336')
    //     AADD(aIdExt, '2848340')
    //     AADD(aIdExt, '2848351')
    //     AADD(aIdExt, '2848352')
    //     AADD(aIdExt, '2848354')
    //     AADD(aIdExt, '2848358')
    //     AADD(aIdExt, '2848378')
    //     AADD(aIdExt, '2848441')
    //     AADD(aIdExt, '2848451')
    //     AADD(aIdExt, '2848453')
    //     AADD(aIdExt, '2848460')
    //     AADD(aIdExt, '2848474')
    //     AADD(aIdExt, '2848486')
    //     AADD(aIdExt, '2848503')
    //     AADD(aIdExt, '2848511')
    //     AADD(aIdExt, '2848519')
    //     AADD(aIdExt, '2848527')
    //     AADD(aIdExt, '2848538')
    //     AADD(aIdExt, '2848545')
    //     AADD(aIdExt, '2848546')
    //     AADD(aIdExt, '2848551')
    //     AADD(aIdExt, '2848562')
    //     AADD(aIdExt, '2848568')
    //     AADD(aIdExt, '2848571')
    //     AADD(aIdExt, '2848585')
    //     AADD(aIdExt, '2848626')
    //     AADD(aIdExt, '2848639')
    //     AADD(aIdExt, '2848646')
    //     AADD(aIdExt, '2848668')
    //     AADD(aIdExt, '2861578')
    //     AADD(aIdExt, '2848710')
    //     AADD(aIdExt, '2848736')
    //     AADD(aIdExt, '2848749')
    //     AADD(aIdExt, '2848751')
    //     AADD(aIdExt, '2848752')
    //     AADD(aIdExt, '2848795')
    //     AADD(aIdExt, '2848808')
    //     AADD(aIdExt, '2848836')
    //     AADD(aIdExt, '2848843')
    //     AADD(aIdExt, '2848844')
    //     AADD(aIdExt, '2861553')
    //     AADD(aIdExt, '2848860')
    //     AADD(aIdExt, '2848865')
    //     AADD(aIdExt, '2848881')
    //     AADD(aIdExt, '2848883')
    //     AADD(aIdExt, '2848915')
    //     AADD(aIdExt, '2848931')
    //     AADD(aIdExt, '2848937')
    //     AADD(aIdExt, '2848977')
    //     AADD(aIdExt, '2849038')
    //     AADD(aIdExt, '2849045')
    //     AADD(aIdExt, '2849067')
    //     AADD(aIdExt, '2849070')
    //     AADD(aIdExt, '2849109')
    //     AADD(aIdExt, '2849138')
    //     AADD(aIdExt, '2849150')
    //     AADD(aIdExt, '2849151')
    //     AADD(aIdExt, '2849156')
    //     AADD(aIdExt, '2849163')
    //     AADD(aIdExt, '2849193')
    //     AADD(aIdExt, '2849216')
    //     AADD(aIdExt, '2849217')
    //     AADD(aIdExt, '2849219')
    //     AADD(aIdExt, '2849234')
    //     AADD(aIdExt, '2849236')
    //     AADD(aIdExt, '2849245')
    //     AADD(aIdExt, '2849252')
    //     AADD(aIdExt, '2849262')
    //     AADD(aIdExt, '2849266')
    //     AADD(aIdExt, '2849288')
    //     AADD(aIdExt, '2849290')
    //     AADD(aIdExt, '2849305')
    //     AADD(aIdExt, '2849306')
    //     AADD(aIdExt, '2849311')
    //     AADD(aIdExt, '2849337')
    //     AADD(aIdExt, '2849341')
    //     AADD(aIdExt, '2849358')
    //     AADD(aIdExt, '2849368')
    //     AADD(aIdExt, '2849376')
    //     AADD(aIdExt, '2849416')
    //     AADD(aIdExt, '2849430')
    //     AADD(aIdExt, '2849444')
    //     AADD(aIdExt, '2849447')
    //     AADD(aIdExt, '2849454')
    //     AADD(aIdExt, '2849465')
    //     AADD(aIdExt, '2849472')
    //     AADD(aIdExt, '2849519')
    //     AADD(aIdExt, '2849524')
    //     AADD(aIdExt, '2849532')
    //     AADD(aIdExt, '2849545')
    //     AADD(aIdExt, '2849557')
    //     AADD(aIdExt, '2861543')
    //     AADD(aIdExt, '2849592')
    //     AADD(aIdExt, '2849595')
    //     AADD(aIdExt, '2849597')
    //     AADD(aIdExt, '2849598')
    //     AADD(aIdExt, '2849612')
    //     AADD(aIdExt, '2849623')
    //     AADD(aIdExt, '2849629')
    //     AADD(aIdExt, '2849634')
    //     AADD(aIdExt, '2849640')
    //     AADD(aIdExt, '2849642')
    //     AADD(aIdExt, '2849648')
    //     AADD(aIdExt, '2849690')
    //     AADD(aIdExt, '2849715')
    //     AADD(aIdExt, '2849722')
    //     AADD(aIdExt, '2849726')
    //     AADD(aIdExt, '2849763')
    //     AADD(aIdExt, '2849777')
    //     AADD(aIdExt, '2861519')
    //     AADD(aIdExt, '2849806')
    //     AADD(aIdExt, '2849819')
    //     AADD(aIdExt, '2849820')
    //     AADD(aIdExt, '2849823')
    //     AADD(aIdExt, '2849838')
    //     AADD(aIdExt, '2849888')
    //     AADD(aIdExt, '2849913')
    //     AADD(aIdExt, '2849915')
    //     AADD(aIdExt, '2861500')
    //     AADD(aIdExt, '2849957')
    //     AADD(aIdExt, '2849968')
    //     AADD(aIdExt, '2849976')
    //     AADD(aIdExt, '2849982')
    //     AADD(aIdExt, '2849983')
    //     AADD(aIdExt, '2849997')
    //     AADD(aIdExt, '2850002')
    //     AADD(aIdExt, '2850016')
    //     AADD(aIdExt, '2850017')
    //     AADD(aIdExt, '2850033')
    //     AADD(aIdExt, '2850083')
    //     AADD(aIdExt, '2850096')
    //     AADD(aIdExt, '2850101')
    //     AADD(aIdExt, '2850124')
    //     AADD(aIdExt, '2850128')
    //     AADD(aIdExt, '2850138')
    //     AADD(aIdExt, '2850148')
    //     AADD(aIdExt, '2850149')
    //     AADD(aIdExt, '2850167')
    //     AADD(aIdExt, '2850179')
    //     AADD(aIdExt, '2850217')
    //     AADD(aIdExt, '2850219')
    //     AADD(aIdExt, '2850222')
    //     AADD(aIdExt, '2850228')
    //     AADD(aIdExt, '2850230')
    //     AADD(aIdExt, '2850249')
    //     AADD(aIdExt, '2850274')
    //     AADD(aIdExt, '2850281')
    //     AADD(aIdExt, '2861495')
    //     AADD(aIdExt, '2850296')
    //     AADD(aIdExt, '2850322')
    //     AADD(aIdExt, '2850351')
    //     AADD(aIdExt, '2850354')
    //     AADD(aIdExt, '2850368')
    //     AADD(aIdExt, '2850405')
    //     AADD(aIdExt, '2850417')
    //     AADD(aIdExt, '2850420')
    //     AADD(aIdExt, '2850423')
    //     AADD(aIdExt, '2850424')
    //     AADD(aIdExt, '2850448')
    //     AADD(aIdExt, '2850459')
    //     AADD(aIdExt, '2850518')
    //     AADD(aIdExt, '2850573')
    //     AADD(aIdExt, '2850587')
    //     AADD(aIdExt, '2850603')
    //     AADD(aIdExt, '2850624')
    //     AADD(aIdExt, '2850646')
    //     AADD(aIdExt, '2850647')
    //     AADD(aIdExt, '2850649')
    //     AADD(aIdExt, '2850658')
    //     AADD(aIdExt, '2850669')
    //     AADD(aIdExt, '2850671')
    //     AADD(aIdExt, '2850680')
    //     AADD(aIdExt, '2850698')
    //     AADD(aIdExt, '2850700')
    //     AADD(aIdExt, '2850723')
    //     AADD(aIdExt, '2850743')
    //     AADD(aIdExt, '2850748')
    //     AADD(aIdExt, '2850755')
    //     AADD(aIdExt, '2850757')
    //     AADD(aIdExt, '2850769')
    //     AADD(aIdExt, '2850777')
    //     AADD(aIdExt, '2850814')
    //     AADD(aIdExt, '2850830')
    //     AADD(aIdExt, '2850835')
    //     AADD(aIdExt, '2850854')
    //     AADD(aIdExt, '2850864')
    //     AADD(aIdExt, '2850899')
    //     AADD(aIdExt, '2850901')
    //     AADD(aIdExt, '2850915')
    //     AADD(aIdExt, '2850919')
    //     AADD(aIdExt, '2850922')
    //     AADD(aIdExt, '2850932')
    //     AADD(aIdExt, '2851001')
    //     AADD(aIdExt, '2851008')
    //     AADD(aIdExt, '2851029')
    //     AADD(aIdExt, '2851032')
    //     AADD(aIdExt, '2851045')
    //     AADD(aIdExt, '2851048')
    //     AADD(aIdExt, '2851114')
    //     AADD(aIdExt, '2851138')
    //     AADD(aIdExt, '2851144')
    //     AADD(aIdExt, '2851156')
    //     AADD(aIdExt, '2851167')
    //     AADD(aIdExt, '2851187')
    //     AADD(aIdExt, '2851212')
    //     AADD(aIdExt, '2851259')
    //     AADD(aIdExt, '2851275')
    //     AADD(aIdExt, '2851282')
    //     AADD(aIdExt, '2851296')
    //     AADD(aIdExt, '2851322')
    //     AADD(aIdExt, '2851388')
    //     AADD(aIdExt, '2851397')
    //     AADD(aIdExt, '2851398')
    //     AADD(aIdExt, '2851408')
    //     AADD(aIdExt, '2851430')
    //     AADD(aIdExt, '2851446')
    //     AADD(aIdExt, '2851456')
    //     AADD(aIdExt, '2851474')
    //     AADD(aIdExt, '2851501')
    //     AADD(aIdExt, '2851511')
    //     AADD(aIdExt, '2851536')
    //     AADD(aIdExt, '2851552')
    //     AADD(aIdExt, '2851563')
    //     AADD(aIdExt, '2851570')
    //     AADD(aIdExt, '2851579')
    //     AADD(aIdExt, '2851602')
    //     AADD(aIdExt, '2851645')
    //     AADD(aIdExt, '2851684')
    //     AADD(aIdExt, '2851707')
    //     AADD(aIdExt, '2861461')
    //     AADD(aIdExt, '2851727')
    //     AADD(aIdExt, '2851736')
    //     AADD(aIdExt, '2851741')
    //     AADD(aIdExt, '2851751')
    //     AADD(aIdExt, '2851784')
    //     AADD(aIdExt, '2851812')
    //     AADD(aIdExt, '2851822')
    //     AADD(aIdExt, '2851840')
    //     AADD(aIdExt, '2851855')
    //     AADD(aIdExt, '2861426')
    //     AADD(aIdExt, '2851866')
    //     AADD(aIdExt, '2851878')
    //     AADD(aIdExt, '2851892')
    //     AADD(aIdExt, '2851896')
    //     AADD(aIdExt, '2851906')
    //     AADD(aIdExt, '2851936')
    //     AADD(aIdExt, '2851939')
    //     AADD(aIdExt, '2851943')
    //     AADD(aIdExt, '2851972')
    //     AADD(aIdExt, '2852034')
    //     AADD(aIdExt, '2861313')
    //     AADD(aIdExt, '2852100')
    //     AADD(aIdExt, '2852103')
    //     AADD(aIdExt, '2852115')
    //     AADD(aIdExt, '2852123')
    //     AADD(aIdExt, '2852136')
    //     AADD(aIdExt, '2852181')
    //     AADD(aIdExt, '2852194')
    //     AADD(aIdExt, '2861310')
    //     AADD(aIdExt, '2852229')
    //     AADD(aIdExt, '2852234')
    //     AADD(aIdExt, '2852276')
    //     AADD(aIdExt, '2852303')
    //     AADD(aIdExt, '2852305')
    //     AADD(aIdExt, '2852320')
    //     AADD(aIdExt, '2852344')
    //     AADD(aIdExt, '2852369')
    //     AADD(aIdExt, '2852382')
    //     AADD(aIdExt, '2852410')
    //     AADD(aIdExt, '2852424')
    //     AADD(aIdExt, '2852442')
    //     AADD(aIdExt, '2852485')
    //     AADD(aIdExt, '2852487')
    //     AADD(aIdExt, '2852496')
    //     AADD(aIdExt, '2852507')
    //     AADD(aIdExt, '2852524')
    //     AADD(aIdExt, '2852550')
    //     AADD(aIdExt, '2852578')
    //     AADD(aIdExt, '2852590')
    //     AADD(aIdExt, '2852607')
    //     AADD(aIdExt, '2852622')
    //     AADD(aIdExt, '2852626')
    //     AADD(aIdExt, '2852637')
    //     AADD(aIdExt, '2852667')
    //     AADD(aIdExt, '2852708')
    //     AADD(aIdExt, '2852711')
    //     AADD(aIdExt, '2852741')
    //     AADD(aIdExt, '2852772')
    //     AADD(aIdExt, '2861278')
    //     AADD(aIdExt, '2852845')
    //     AADD(aIdExt, '2852860')
    //     AADD(aIdExt, '2852865')
    //     AADD(aIdExt, '2852872')
    //     AADD(aIdExt, '2852906')
    //     AADD(aIdExt, '2852907')
    //     AADD(aIdExt, '2852949')
    //     AADD(aIdExt, '2852992')
    //     AADD(aIdExt, '2853004')
    //     AADD(aIdExt, '2853021')
    //     AADD(aIdExt, '2853022')
    //     AADD(aIdExt, '2853023')
    //     AADD(aIdExt, '2853042')
    //     AADD(aIdExt, '2853044')
    //     AADD(aIdExt, '2853048')
    //     AADD(aIdExt, '2853052')
    //     AADD(aIdExt, '2853087')
    //     AADD(aIdExt, '2853107')
    //     AADD(aIdExt, '2853117')
    //     AADD(aIdExt, '2853118')
    //     AADD(aIdExt, '2853127')
    //     AADD(aIdExt, '2853129')
    //     AADD(aIdExt, '2853144')
    //     AADD(aIdExt, '2853192')
    //     AADD(aIdExt, '2853205')
    //     AADD(aIdExt, '2853210')
    //     AADD(aIdExt, '2853221')
    //     AADD(aIdExt, '2853225')
    //     AADD(aIdExt, '2853236')
    //     AADD(aIdExt, '2853244')
    //     AADD(aIdExt, '2853246')
    //     AADD(aIdExt, '2853247')
    //     AADD(aIdExt, '2853248')
    //     AADD(aIdExt, '2853254')
    //     AADD(aIdExt, '2853264')
    //     AADD(aIdExt, '2853282')
    //     AADD(aIdExt, '2853326')
    //     AADD(aIdExt, '2853332')
    //     AADD(aIdExt, '2853345')
    //     AADD(aIdExt, '2853349')
    //     AADD(aIdExt, '2853384')
    //     AADD(aIdExt, '2853434')
    //     AADD(aIdExt, '2853505')
    //     AADD(aIdExt, '2853508')
    //     AADD(aIdExt, '2853527')
    //     AADD(aIdExt, '2853547')
    //     AADD(aIdExt, '2853572')
    //     AADD(aIdExt, '2853573')
    //     AADD(aIdExt, '2853603')
    //     AADD(aIdExt, '2853660')
    //     AADD(aIdExt, '2853661')
    //     AADD(aIdExt, '2853671')
    //     AADD(aIdExt, '2853699')
    //     AADD(aIdExt, '2853713')
    //     AADD(aIdExt, '2853722')
    //     AADD(aIdExt, '2853773')
    //     AADD(aIdExt, '2853788')
    //     AADD(aIdExt, '2853804')
    //     AADD(aIdExt, '2853814')
    //     AADD(aIdExt, '2853833')
    //     AADD(aIdExt, '2853834')
    //     AADD(aIdExt, '2853867')
    //     AADD(aIdExt, '2853897')
    //     AADD(aIdExt, '2853901')
    //     AADD(aIdExt, '2853907')
    //     AADD(aIdExt, '2853927')
    //     AADD(aIdExt, '2853931')
    //     AADD(aIdExt, '2853945')
    //     AADD(aIdExt, '2853962')
    //     AADD(aIdExt, '2853976')
    //     AADD(aIdExt, '2853978')
    //     AADD(aIdExt, '2853979')
    //     AADD(aIdExt, '2853982')
    //     AADD(aIdExt, '2853996')
    //     AADD(aIdExt, '2854008')
    //     AADD(aIdExt, '2854010')
    //     AADD(aIdExt, '2854023')
    //     AADD(aIdExt, '2854035')
    //     AADD(aIdExt, '2854048')
    //     AADD(aIdExt, '2854049')
    //     AADD(aIdExt, '2854086')
    //     AADD(aIdExt, '2854152')
    //     AADD(aIdExt, '2854191')
    //     AADD(aIdExt, '2854216')
    //     AADD(aIdExt, '2854235')
    //     AADD(aIdExt, '2854252')
    //     AADD(aIdExt, '2854266')
    //     AADD(aIdExt, '2854267')
    //     AADD(aIdExt, '2854275')
    //     AADD(aIdExt, '2854277')
    //     AADD(aIdExt, '2854278')
    //     AADD(aIdExt, '2854292')
    //     AADD(aIdExt, '2854302')
    //     AADD(aIdExt, '2854313')
    //     AADD(aIdExt, '2854322')
    //     AADD(aIdExt, '2854323')
    //     AADD(aIdExt, '2854342')
    //     AADD(aIdExt, '2854359')
    //     AADD(aIdExt, '2854401')
    //     AADD(aIdExt, '2854410')
    //     AADD(aIdExt, '2854414')
    //     AADD(aIdExt, '2854417')
    //     AADD(aIdExt, '2854419')
    //     AADD(aIdExt, '2854445')
    //     AADD(aIdExt, '2854448')
    //     AADD(aIdExt, '2854453')
    //     AADD(aIdExt, '2854455')
    //     AADD(aIdExt, '2854468')
    //     AADD(aIdExt, '2854473')
    //     AADD(aIdExt, '2854497')
    //     AADD(aIdExt, '2854542')
    //     AADD(aIdExt, '2854550')
    //     AADD(aIdExt, '2854557')
    //     AADD(aIdExt, '2854574')
    //     AADD(aIdExt, '2854577')
    //     AADD(aIdExt, '2854585')
    //     AADD(aIdExt, '2854617')
    //     AADD(aIdExt, '2854640')
    //     AADD(aIdExt, '2854661')
    //     AADD(aIdExt, '2854671')
    //     AADD(aIdExt, '2854686')
    //     AADD(aIdExt, '2854694')
    //     AADD(aIdExt, '2854695')
    //     AADD(aIdExt, '2854703')
    //     AADD(aIdExt, '2854711')
    //     AADD(aIdExt, '2854726')
    //     AADD(aIdExt, '2854729')
    //     AADD(aIdExt, '2854740')
    //     AADD(aIdExt, '2854787')
    //     AADD(aIdExt, '2854790')
    //     AADD(aIdExt, '2854829')
    //     AADD(aIdExt, '2854839')
    //     AADD(aIdExt, '2854841')
    //     AADD(aIdExt, '2854894')
    //     AADD(aIdExt, '2854895')
    //     AADD(aIdExt, '2854909')
    //     AADD(aIdExt, '2854929')
    //     AADD(aIdExt, '2861263')
    //     AADD(aIdExt, '2854941')
    //     AADD(aIdExt, '2854945')
    //     AADD(aIdExt, '2854978')
    //     AADD(aIdExt, '2855008')
    //     AADD(aIdExt, '2855020')
    //     AADD(aIdExt, '2855057')
    //     AADD(aIdExt, '2855085')
    //     AADD(aIdExt, '2855098')
    //     AADD(aIdExt, '2855109')
    //     AADD(aIdExt, '2855110')
    //     AADD(aIdExt, '2855122')
    //     AADD(aIdExt, '2855131')
    //     AADD(aIdExt, '2855169')
    //     AADD(aIdExt, '2855190')
    //     AADD(aIdExt, '2855200')
    //     AADD(aIdExt, '2855207')
    //     AADD(aIdExt, '2855260')
    //     AADD(aIdExt, '2855280')
    //     AADD(aIdExt, '2855285')
    //     AADD(aIdExt, '2855312')
    //     AADD(aIdExt, '2855331')
    //     AADD(aIdExt, '2855336')
    //     AADD(aIdExt, '2855355')
    //     AADD(aIdExt, '2855377')
    //     AADD(aIdExt, '2855379')
    //     AADD(aIdExt, '2855389')
    //     AADD(aIdExt, '2855405')
    //     AADD(aIdExt, '2855466')
    //     AADD(aIdExt, '2855502')
    //     AADD(aIdExt, '2855509')
    //     AADD(aIdExt, '2855520')
    //     AADD(aIdExt, '2855545')
    //     AADD(aIdExt, '2855560')
    //     AADD(aIdExt, '2855598')
    //     AADD(aIdExt, '2855605')
    //     AADD(aIdExt, '2855628')
    //     AADD(aIdExt, '2855659')
    //     AADD(aIdExt, '2855693')
    //     AADD(aIdExt, '2855695')
    //     AADD(aIdExt, '2855709')
    //     AADD(aIdExt, '2855717')
    //     AADD(aIdExt, '2855721')
    //     AADD(aIdExt, '2855753')
    //     AADD(aIdExt, '2855763')
    //     AADD(aIdExt, '2855765')
    //     AADD(aIdExt, '2855777')
    //     AADD(aIdExt, '2855789')
    //     AADD(aIdExt, '2855796')
    //     AADD(aIdExt, '2855828')
    //     AADD(aIdExt, '2855836')
    //     AADD(aIdExt, '2855887')
    //     AADD(aIdExt, '2861244')
    //     AADD(aIdExt, '2855975')
    //     AADD(aIdExt, '2856008')
    //     AADD(aIdExt, '2856032')
    //     AADD(aIdExt, '2856061')
    //     AADD(aIdExt, '2856082')
    //     AADD(aIdExt, '2856152')
    //     AADD(aIdExt, '2856153')
    //     AADD(aIdExt, '2856171')
    //     AADD(aIdExt, '2856197')
    //     AADD(aIdExt, '2856242')
    //     AADD(aIdExt, '2856252')
    //     AADD(aIdExt, '2856273')
    //     AADD(aIdExt, '2856306')
    //     AADD(aIdExt, '2856324')
    //     AADD(aIdExt, '2856334')
    //     AADD(aIdExt, '2856340')
    //     AADD(aIdExt, '2856361')
    //     AADD(aIdExt, '2856416')
    //     AADD(aIdExt, '2856473')
    //     AADD(aIdExt, '2856496')
    //     AADD(aIdExt, '2856524')
    //     AADD(aIdExt, '2856533')
    //     AADD(aIdExt, '2856567')
    //     AADD(aIdExt, '2856594')
    //     AADD(aIdExt, '2856670')
    //     AADD(aIdExt, '2856680')
    //     AADD(aIdExt, '2856697')
    //     AADD(aIdExt, '2856705')
    //     AADD(aIdExt, '2856718')
    //     AADD(aIdExt, '2856731')
    //     AADD(aIdExt, '2856748')
    //     AADD(aIdExt, '2856795')
    //     AADD(aIdExt, '2856808')
    //     AADD(aIdExt, '2856827')
    //     AADD(aIdExt, '2856859')
    //     AADD(aIdExt, '2856887')
    //     AADD(aIdExt, '2856888')
    //     AADD(aIdExt, '2856916')
    //     AADD(aIdExt, '2856927')
    //     AADD(aIdExt, '2856978')
    //     AADD(aIdExt, '2857009')
    //     AADD(aIdExt, '2857010')
    //     AADD(aIdExt, '2857040')
    //     AADD(aIdExt, '2861223')
    //     AADD(aIdExt, '2857050')
    //     AADD(aIdExt, '2857068')
    //     AADD(aIdExt, '2857081')
    //     AADD(aIdExt, '2857085')
    //     AADD(aIdExt, '2857154')
    //     AADD(aIdExt, '2857169')
    //     AADD(aIdExt, '2857172')
    //     AADD(aIdExt, '2857177')
    //     AADD(aIdExt, '2857180')
    //     AADD(aIdExt, '2857183')
    //     AADD(aIdExt, '2857193')
    //     AADD(aIdExt, '2857198')
    //     AADD(aIdExt, '2857203')
    //     AADD(aIdExt, '2857216')
    //     AADD(aIdExt, '2857217')
    //     AADD(aIdExt, '2857227')
    //     AADD(aIdExt, '2857229')
    //     AADD(aIdExt, '2857238')
    //     AADD(aIdExt, '2857255')
    //     AADD(aIdExt, '2857271')
    //     AADD(aIdExt, '2857274')
    //     AADD(aIdExt, '2857286')
    //     AADD(aIdExt, '2857294')
    //     AADD(aIdExt, '2857302')
    //     AADD(aIdExt, '2857325')
    //     AADD(aIdExt, '2857335')
    //     AADD(aIdExt, '2857362')
    //     AADD(aIdExt, '2857416')
    //     AADD(aIdExt, '2857423')
    //     AADD(aIdExt, '2857432')
    //     AADD(aIdExt, '2857439')
    //     AADD(aIdExt, '2857473')
    //     AADD(aIdExt, '2857474')
    //     AADD(aIdExt, '2857482')
    //     AADD(aIdExt, '2857503')
    //     AADD(aIdExt, '2861209')
    //     AADD(aIdExt, '2857539')
    //     AADD(aIdExt, '2857542')
    //     AADD(aIdExt, '2861182')
    //     AADD(aIdExt, '2857626')
    //     AADD(aIdExt, '2857690')
    //     AADD(aIdExt, '2857696')
    //     AADD(aIdExt, '2857730')
    //     AADD(aIdExt, '2857745')
    //     AADD(aIdExt, '2857794')
    //     AADD(aIdExt, '2857802')
    //     AADD(aIdExt, '2857851')
    //     AADD(aIdExt, '2857860')
    //     AADD(aIdExt, '2857939')
    //     AADD(aIdExt, '2857962')
    //     AADD(aIdExt, '2857992')
    //     AADD(aIdExt, '2858009')
    //     AADD(aIdExt, '2858039')
    //     AADD(aIdExt, '2858088')
    //     AADD(aIdExt, '2858140')
    //     AADD(aIdExt, '2858155')
    //     AADD(aIdExt, '2858156')
    //     AADD(aIdExt, '2858159')
    //     AADD(aIdExt, '2858163')
    //     AADD(aIdExt, '2858178')
    //     AADD(aIdExt, '2858179')
    //     AADD(aIdExt, '2858206')
    //     AADD(aIdExt, '2858209')
    //     AADD(aIdExt, '2858238')
    //     AADD(aIdExt, '2858254')
    //     AADD(aIdExt, '2858294')
    //     AADD(aIdExt, '2858305')
    //     AADD(aIdExt, '2858307')
    //     AADD(aIdExt, '2858326')
    //     AADD(aIdExt, '2858328')
    //     AADD(aIdExt, '2858392')
    //     AADD(aIdExt, '2858426')
    //     AADD(aIdExt, '2858450')
    //     AADD(aIdExt, '2858476')
    //     AADD(aIdExt, '2858478')
    //     AADD(aIdExt, '2858491')
    //     AADD(aIdExt, '2858508')
    //     AADD(aIdExt, '2858540')
    //     AADD(aIdExt, '2858541')
    //     AADD(aIdExt, '2858546')
    //     AADD(aIdExt, '2858555')
    //     AADD(aIdExt, '2858576')
    //     AADD(aIdExt, '2858597')
    //     AADD(aIdExt, '2858607')
    //     AADD(aIdExt, '2858608')
    //     AADD(aIdExt, '2858613')
    //     AADD(aIdExt, '2858639')
    //     AADD(aIdExt, '2858647')
    //     AADD(aIdExt, '2858648')
    //     AADD(aIdExt, '2858656')
    //     AADD(aIdExt, '2858660')
    //     AADD(aIdExt, '2858701')
    //     AADD(aIdExt, '2858710')
    //     AADD(aIdExt, '2858729')
    //     AADD(aIdExt, '2858747')
    //     AADD(aIdExt, '2858756')
    //     AADD(aIdExt, '2858808')
    //     AADD(aIdExt, '2858816')
    //     AADD(aIdExt, '2858891')
    //     AADD(aIdExt, '2858897')
    //     AADD(aIdExt, '2858925')
    //     AADD(aIdExt, '2858960')
    //     AADD(aIdExt, '2858996')
    //     AADD(aIdExt, '2859007')
    //     AADD(aIdExt, '2859039')
    //     AADD(aIdExt, '2859047')
    //     AADD(aIdExt, '2859062')
    //     AADD(aIdExt, '2859073')
    //     AADD(aIdExt, '2859111')
    //     AADD(aIdExt, '2859113')
    //     AADD(aIdExt, '2859139')
    //     AADD(aIdExt, '2859145')
    //     AADD(aIdExt, '2859165')
    //     AADD(aIdExt, '2859182')
    //     AADD(aIdExt, '2859185')
    //     AADD(aIdExt, '2859199')
    //     AADD(aIdExt, '2859202')
    //     AADD(aIdExt, '2859230')
    //     AADD(aIdExt, '2859248')
    //     AADD(aIdExt, '2859274')
    //     AADD(aIdExt, '2859325')
    //     AADD(aIdExt, '2859336')
    //     AADD(aIdExt, '2859337')
    //     AADD(aIdExt, '2859356')
    //     AADD(aIdExt, '2859378')
    //     AADD(aIdExt, '2859387')
    //     AADD(aIdExt, '2859399')
    //     AADD(aIdExt, '2859418')
    //     AADD(aIdExt, '2859422')
    //     AADD(aIdExt, '2859431')
    //     AADD(aIdExt, '2859438')
    //     AADD(aIdExt, '2859448')
    //     AADD(aIdExt, '2859449')
    //     AADD(aIdExt, '2859470')
    //     AADD(aIdExt, '2859488')
    //     AADD(aIdExt, '2859489')
    //     AADD(aIdExt, '2859500')
    //     AADD(aIdExt, '2859516')
    //     AADD(aIdExt, '2859581')
    //     AADD(aIdExt, '2859603')
    //     AADD(aIdExt, '2859648')
    //     AADD(aIdExt, '2859702')
    //     AADD(aIdExt, '2859703')
    //     AADD(aIdExt, '2859705')
    //     AADD(aIdExt, '2859706')
    //     AADD(aIdExt, '2859734')
    //     AADD(aIdExt, '2859750')
    //     AADD(aIdExt, '2859753')
    //     AADD(aIdExt, '2859757')
    //     AADD(aIdExt, '2859789')
    //     AADD(aIdExt, '2859803')
    //     AADD(aIdExt, '2859828')
    //     AADD(aIdExt, '2859835')
    //     AADD(aIdExt, '2859850')
    //     AADD(aIdExt, '2859851')
    //     AADD(aIdExt, '2859888')
    //     AADD(aIdExt, '2859907')
    //     AADD(aIdExt, '2859916')
    //     AADD(aIdExt, '2859957')
    //     AADD(aIdExt, '2859988')
    //     AADD(aIdExt, '2860005')
    //     AADD(aIdExt, '2860017')
    //     AADD(aIdExt, '2860025')
    //     AADD(aIdExt, '2860042')
    //     AADD(aIdExt, '2860059')
    //     AADD(aIdExt, '2860070')
    //     AADD(aIdExt, '2860085')
    //     AADD(aIdExt, '2860107')
    //     AADD(aIdExt, '2860124')
    //     AADD(aIdExt, '2860135')
    //     AADD(aIdExt, '2860155')
    //     AADD(aIdExt, '2860336')
    //     AADD(aIdExt, '2860377')
    //     AADD(aIdExt, '2860410')
    //     AADD(aIdExt, '2860414')
    //     AADD(aIdExt, '2860417')
    //     AADD(aIdExt, '2860459')
    //     AADD(aIdExt, '2860462')
    //     AADD(aIdExt, '2860491')
    //     AADD(aIdExt, '2860513')
    //     AADD(aIdExt, '2860534')
    //     AADD(aIdExt, '2860587')
    //     AADD(aIdExt, '2860589')
    //     AADD(aIdExt, '2860658')
    //     AADD(aIdExt, '2860664')
    //     AADD(aIdExt, '2860689')
    //     AADD(aIdExt, '2860760')
    //     AADD(aIdExt, '2860764')
    //     AADD(aIdExt, '2860771')
    //     AADD(aIdExt, '2860809')
    //     AADD(aIdExt, '2860930')
    //     AADD(aIdExt, '2860953')
    //     AADD(aIdExt, '2860963')
    //     AADD(aIdExt, '2860982')
    //     AADD(aIdExt, '2861042')
    //     AADD(aIdExt, '2861065')
    //     AADD(aIdExt, '2861074')
    //     AADD(aIdExt, '2861078')
    //     AADD(aIdExt, '2861084')
    //     AADD(aIdExt, '2861164')
    //     AADD(aIdExt, '2861166')
    // Return aIdExt
//feito - descontinuado - ficar como historico

Static Function aOrId()
    Local aIdExt := {}
    // AADD(aIdExt, '2858163')
    // AADD(aIdExt, '2858178')
    // AADD(aIdExt, '2858179')
    // AADD(aIdExt, '2858206')
    // AADD(aIdExt, '2858209')
    // AADD(aIdExt, '2858238')
    // AADD(aIdExt, '2858254')
    // AADD(aIdExt, '2858294')
    // AADD(aIdExt, '2858305')
    // AADD(aIdExt, '2858307')
    // AADD(aIdExt, '2858326')
    // AADD(aIdExt, '2858328')
    // AADD(aIdExt, '2858392')
    // AADD(aIdExt, '2858426')
    // AADD(aIdExt, '2858450')
    // AADD(aIdExt, '2858476')
    // AADD(aIdExt, '2858478')
    // AADD(aIdExt, '2858491')
    // AADD(aIdExt, '2858508')
    // AADD(aIdExt, '2858540')
    // AADD(aIdExt, '2858541')
    // AADD(aIdExt, '2858546')
    // AADD(aIdExt, '2858555')
    // AADD(aIdExt, '2858576')
    // AADD(aIdExt, '2858597')
    // AADD(aIdExt, '2858607')
    // AADD(aIdExt, '2858608')
    // AADD(aIdExt, '2858613')
    // AADD(aIdExt, '2858639')
    // AADD(aIdExt, '2858647')
    // AADD(aIdExt, '2858648')
    // AADD(aIdExt, '2858656')
    // AADD(aIdExt, '2858660')
    // AADD(aIdExt, '2858701')
    // AADD(aIdExt, '2858710')
    // AADD(aIdExt, '2858729')
    // AADD(aIdExt, '2858747')
    // AADD(aIdExt, '2858756')
    // AADD(aIdExt, '2858808')
    // AADD(aIdExt, '2858816')
    // AADD(aIdExt, '2858891')
    // AADD(aIdExt, '2858897')
    // AADD(aIdExt, '2858925')
    // AADD(aIdExt, '2858960')
    // AADD(aIdExt, '2858996')
    // AADD(aIdExt, '2859007')
    // AADD(aIdExt, '2859039')
    // AADD(aIdExt, '2859047')
    // AADD(aIdExt, '2859062')
    // AADD(aIdExt, '2859073')
    // AADD(aIdExt, '2859111')
    // AADD(aIdExt, '2859113')
    // AADD(aIdExt, '2859139')
    // AADD(aIdExt, '2859145')
    // AADD(aIdExt, '2859165')
    // AADD(aIdExt, '2859182')
    // AADD(aIdExt, '2859185')
    // AADD(aIdExt, '2859199')
    // AADD(aIdExt, '2859202')
    // AADD(aIdExt, '2859230')
    // AADD(aIdExt, '2859248')
    // AADD(aIdExt, '2859274')
    // AADD(aIdExt, '2859325')
    // AADD(aIdExt, '2859336')
    // AADD(aIdExt, '2859337')
    // AADD(aIdExt, '2859356')
    // AADD(aIdExt, '2859378')
    // AADD(aIdExt, '2859387')
    // AADD(aIdExt, '2859399')
    // AADD(aIdExt, '2859418')
    // AADD(aIdExt, '2859422')
    // AADD(aIdExt, '2859431')
    // AADD(aIdExt, '2859438')
    // AADD(aIdExt, '2859448')
    // AADD(aIdExt, '2859449')
    // AADD(aIdExt, '2859470')
    // AADD(aIdExt, '2859488')
    // AADD(aIdExt, '2859489')
    // AADD(aIdExt, '2859500')
    // AADD(aIdExt, '2859516')
    // AADD(aIdExt, '2859581')
    // AADD(aIdExt, '2859603')
    // AADD(aIdExt, '2859648')
    // AADD(aIdExt, '2859702')
    // AADD(aIdExt, '2859703')
    // AADD(aIdExt, '2859705')
    // AADD(aIdExt, '2859706')
    // AADD(aIdExt, '2859734')
    // AADD(aIdExt, '2859750')
    // AADD(aIdExt, '2859753')
    // AADD(aIdExt, '2859757')
    // AADD(aIdExt, '2859789')
    // AADD(aIdExt, '2859803')
    // AADD(aIdExt, '2859828')
    // AADD(aIdExt, '2859835')
    // AADD(aIdExt, '2859850')
    // AADD(aIdExt, '2859851')
    // AADD(aIdExt, '2859888')
    // AADD(aIdExt, '2859907')
    // AADD(aIdExt, '2859916')
    // AADD(aIdExt, '2859957')
    // AADD(aIdExt, '2859988')
    // AADD(aIdExt, '2860005')
    // AADD(aIdExt, '2860017')
    // AADD(aIdExt, '2860025')
    // AADD(aIdExt, '2860042')
    // AADD(aIdExt, '2860059')
    // AADD(aIdExt, '2860070')
    // AADD(aIdExt, '2860085')
    // AADD(aIdExt, '2860107')
    // AADD(aIdExt, '2860124')
    // AADD(aIdExt, '2860135')
    // AADD(aIdExt, '2860155')
    // AADD(aIdExt, '2860336')
    // AADD(aIdExt, '2860377')
    // AADD(aIdExt, '2860410')
    // AADD(aIdExt, '2860414')
    // AADD(aIdExt, '2860417')
    // AADD(aIdExt, '2860459')
    // AADD(aIdExt, '2860462')
    // AADD(aIdExt, '2860491')
    // AADD(aIdExt, '2860513')
    // AADD(aIdExt, '2860534')
    // AADD(aIdExt, '2860587')
    // AADD(aIdExt, '2860589')
    // AADD(aIdExt, '2860658')
    // AADD(aIdExt, '2860664')
    // AADD(aIdExt, '2860689')
    // AADD(aIdExt, '2860760')
    // AADD(aIdExt, '2860764')
    // AADD(aIdExt, '2860771')
    // AADD(aIdExt, '2860809')
    // AADD(aIdExt, '2860930')
    // AADD(aIdExt, '2860953')
    // AADD(aIdExt, '2860963')
    // AADD(aIdExt, '2860982')
    // AADD(aIdExt, '2861042')
    // AADD(aIdExt, '2861065')
    // AADD(aIdExt, '2861074')
    // AADD(aIdExt, '2861078')
    // AADD(aIdExt, '2861084')
    // AADD(aIdExt, '2861164')
    // AADD(aIdExt, '2861166')
Return aIdExt


METHOD TransNfe(cDocumento, cSerie) Class LIBGLASS
	Local aArea          := FWGetArea()
	//Transmissão e Monitoramento
	Local cModelo        := "55"
	Local cIdEnt         := ""
	Local cError         := ""
	//Transmissão
	Local cAmbiente      := ""
	Local cModalidade    := ""
	Local cVersao        := ""
	Local lCte           := .F. //( cModelo == "57" )
	Local lEnd           := .F.
	//Monitoramento
	Local nVezes         := 0
	Local cURL           := PadR(GetNewPar("MV_SPEDURL", "http://"), 250)
	Local aParam         := {}
	Local nTpMonitor     := 1
	Local aRetMonit      := {}
	//Retorno da Função
	Local lDeuCerto      := .F.
	Local cMensagem      := ""
	Local aRetorno       := {.F., ""}
    Local cRet           := ""

	//Posiciona na Nota (que não tenha chave de acesso ainda)
	Dbselectarea('SF2')
	SF2->(DbSetOrder(1)) // F2_FILIAL + F2_DOC + F2_SERIE + F2_CLIENTE + F2_LOJA + F2_FORMUL + F2_TIPO
	If SF2->(MsSeek(FWxFilial('SF2') + cDocumento + cSerie)) .And. Empty(SF2->F2_CHVNFE)
		cIdEnt := getCfgEntidade(@cError)

		//Se encontrou a entidade
		If ! Empty( cIdEnt )

			//Busca o ambiente, modalidade e versão
			cAmbiente := getCfgAmbiente(@cError, cIdEnt, cModelo)
			If ! Empty(cAmbiente)
				cModalidade := getCfgModalidade(@cError, cIdEnt, cModelo)

				If ! Empty(cModalidade)
					cVersao    := getCfgVersao(@cError, cIdEnt, cModelo)
				EndIf
			EndIf

			//Se conseguiu buscar as informações
			If ! Empty(cVersao)
				//Aciona a transmissão da Nota para o Sefaz
				cRetorno := SpedNFeTrf(;
					"SF2",;         //cAlias
				SF2->F2_SERIE,; //cSerie
				SF2->F2_DOC,;   //cNotaIni
				SF2->F2_DOC,;   //cNotaFim
				cIdEnt,;        //cIDEnt
				cAmbiente,;     //cAmbiente
				cModalidade,;   //cModalidade
				cVersao,;       //cVersao
				@lEnd,;         //lEnd
				lCte,;          //lCte
				.T.,;           //lAuto
				Nil,;           //dDataDe
				Nil;            //dDataAte
				)

				//Se tiver a mensagem de sucesso, tenta acionar o monitoramento
				If "SUCESSO" $ Upper(cRetorno)

					//Monta o array de parâmetros para monitorar
					aParam    := Array(5)
					aParam[1] := SF2->F2_SERIE
					aParam[2] := SF2->F2_DOC
					aParam[3] := SF2->F2_DOC
					aParam[4] := MonthSub(SF2->F2_EMISSAO, 1)
					aParam[5] := MonthSum(SF2->F2_EMISSAO, 1)

					//Tenta monitorar 3 vezes
					While nVezes < 3
						aRetMonit := procMonitorDoc(;
							cIdent,;          //cIdEnt
						cUrl,;            //cUrl
						aParam,;          //aParam
						nTpMonitor,;      //nTpMonitor (1=Range de Notas; 2=Lote de Id;3=Tempo)
						"0" + cModelo,;   //cModelo
						lCte,;            //lCte
						@cError;          //cAviso
						)

						//Se teve retorno o monitoramento
						If Len(aRetMonit) > 0

							//Se começar com 001, deu certo o monitoramento
							If Left(Alltrim(aRetMonit[1][9]), 3) == '001'
								lDeuCerto := .T.
								cMensagem := "Sucesso na transmissão e monitoramento da Nota!"
								Exit
							EndIf
						EndIf

						//Aguarda 3 segundos antes da próxima tentativa
						Sleep(3000)
						nVezes++
					EndDo

					//Se mesmo ao acionar o monitoramento, não der certo, atualiza a variável de retorno
					If ! lDeuCerto
						cMensagem := "Falha ao tentar acionar o monitoramento! " + cError
					EndIf

				Else
					cMensagem := "Falha na transmissão da Nota! " + cRetorno
				EndIf
			Else
				cMensagem := "Falha ao buscar informações (Ambiente, Modalidade e Versão)! " + cError
			EndIf

		Else
			cMensagem := "Falha ao buscar o IdEnt da Empresa! " + cError
		EndIf

	Else
		cMensagem := "Nota e Série não encontradas na SF2!"
	EndIf

	//Define o retorno
	aRetorno[1] := lDeuCerto
	aRetorno[2] := cMensagem
    cRet        := cMensagem

	FWRestArea(aArea)
Return cRet
