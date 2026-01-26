#Include "TOTVS.CH"
#Include "TOPCONN.CH"
#Include "FWMVCDef.CH"
#Include "Protheus.ch"
#Include "RwMake.ch"
#Include "TbiConn.ch"
#INCLUDE "report.ch"

/*/{Protheus.doc} JOBZZD
JOB GERACAO DE TITULOS NO CONTAS A PAGAR CARGLASS 
@type function
@version  1.0
@author Cavalini
@since 17/10/2025
/*/
User Function JOBZZD(cParm01, cParm02)
	Local cCadastro := 'JOBZZD'
	Local cInstr := "Pressione OK - Para continuar"

	Default cParm01 := ''
	Default cParm02 := ''

	If !empty(cParm01) .and. !empty(cParm02)
		aParam := {cParm01, cParm02}
	ElseIf !empty(cParm01) .and. Valtype(cParm01) == "A"
		aParam := {cParm01[1], cParm01[2]}
	Else
		aParam := {'01','01',.T.}
	Endif

	ConOut("*** INICIO JOBZZD - " + Dtoc(Date()) + " " + Time() + " - " + cCadastro)
	varinfo('JOBZZD - aParam',aParam)

	If IsBlind()
		RpcSetEnv(aParam[1], aParam[2])
	EndIf

	If  LockByName( cCadastro, .F., .F. )
		BatchProcess(cCadastro, cInstr, cCadastro, {|| U_GOJOBZZD()}, {|| .F. })
	Else
		ConOut(cCadastro+cFilant+"esta sendo executado em outra thread")
	EndIf

	RpcClearEnv()
	UnLockByName(cCadastro,.F.,.F.)
	ConOut("*** FIM JOBZZD - " + Dtoc(Date()) + " " + Time() + " - " + cCadastro)

Return

/*/{Protheus.doc} GOJOBZZD
Gera titulos a pagar tendo como origem a tabela ZZD 
@type     function GOJOBZZD()
@author   Ricardo Cavalini
@since    12.10.2025
/*/
User function GOJOBZZD()
	Local cAliasTemp 	 := GetNextAlias()
	Local cquery := ""
	Local aArray := {}
	Local nOpc   := 3
	Local cNum   := ""
	Local nI     := 0
	Local nReg   := 1
	Local dDtEmi := CTOD("  /  /  ")
	Local dDtVto := CTOD("  /  /  ")
	Local nRcno  := 0
	Local cCusto := ""
	Local cCnta  := ""
	Local cChvP  := ""
	Local cNrTT  := ""
	Local cBco   := ""
	Local cAge   := ""
	Local cDvAge := ""
	Local cCta   := ""
	Local cDvCta := ""
	Local nHfAge := 0
	Local nHfCta := 0
	Local cTPA   := SuperGetMV("CG_CARGTPA",,"341|0048 |25519")
	Local cCBc   := ""
	Local cCAg   := ""
	Local cCCt   := ""
	Local cBsca  := "-"
	lOCAL cMsg   := {"",{"",""}}
	Local cCnpj  := ""
	Local cCodF  := ""
	Local cNomC  := ""
	Local cLojF  := ""
	Local cFlCg  := ""

	PRIVATE lMsErroAuto := .F.
	Private lMsHelpAuto := .T.
	Private lAutoErrNoFile := .T.

	cquery := " SELECT *  "
	cquery += " FROM " + RetSqlName("ZZD") +"  ZZD "
	cquery += " WHERE ZZD_STATUS = '0' AND ZZD.D_E_L_E_T_='' "

	dbUseArea(.T., "TOPCONN", TCGENQRY(,,cQuery),cAliasTemp,.F.,.T.)
	dbSelectArea(cAliasTemp)

	While !(cAliasTemp)->(Eof())

		lMsErroAuto := .F.
		lMsHelpAuto := .T.
		aArray      := {}
		nOpc        := 3
		cNum        := ""
		nI          := 0
		nReg        := 1
		dDtEmi      := STOD((cAliasTemp)->ZZD_EMISSA)
		dDtVto      := STOD((cAliasTemp)->ZZD_VENCTO)
		nRcno       := (cAliasTemp)->R_E_C_N_O_
		cChvP       := ALLTRIM((cAliasTemp)->ZZD_CHVPIX)
		cNrTT       := STRZERO(VAL((cAliasTemp)->ZZD_NUM),9)
		cCnpj       := (cAliasTemp)->ZZD_CNPJ
		cCodF       := (cAliasTemp)->ZZD_COD
		cLojF       := (cAliasTemp)->ZZD_LOJA
		cFlCg       := (cAliasTemp)->ZZD_FILIAL
		cCnta       := (cAliasTemp)->ZZD_CNTCTB
		cCusto      := (cAliasTemp)->ZZD_CC

		// tratamento de banco do fornecedor - visando tratamento de digito e ajuste no cadastro de fornecedor
		nHfAge      := At(cBsca,(cAliasTemp)->ZZD_FORAGE)
		nHfCta      := At(cBsca,(cAliasTemp)->ZZD_FORCTA)

		// Tratamento do banco
		cBco        := PADR((cAliasTemp)->ZZD_FORBCO,3)

		// Ttratamento de agencia
		if nHfAge != 0
			cAge     := PADR(SUBSTR((cAliasTemp)->ZZD_FORAGE,1,(nHfAge - 1)),5)
			cDvAge   := PADR(SUBSTR((cAliasTemp)->ZZD_FORAGE,(nHfAge + 1),1),1)
		Else
			cAge     := PADR((cAliasTemp)->ZZD_FORAGE,5)
			cDvAge   := ""
		Endif

		// Tratamento da conta corrente
		if nHfCta != 0
			cCta     := PADR(SUBSTR((cAliasTemp)->ZZD_FORCTA,1,(nHfCta - 1)),12)
			cDvCta   := PADR(SUBSTR((cAliasTemp)->ZZD_FORCTA,(nHfCta + 1),1),1)
		Else
			cCta     := PADR((cAliasTemp)->ZZD_FORCTA,12)
			cDvCta   := ""
		Endif

		// tratamento do banco que deve gerar o pagamento antecipado (PA)
		// Este banco deve existir na tabela SA6 e no parametro CG_CARGTPA
		cCBc        := SUBSTR(cTPA,01,3)
		cCAg        := SUBSTR(cTPA,05,4)
		cCCt        := SUBSTR(cTPA,11,5)

		// Verifica se tem fornecedor
		IF !EMPTY(ALLTRIM(cCnpj))

			DBSELECTAREA("SA2")
			DBSETORDER(3)
			IF DBSEEK(XFILIAL("SA2")+cCnpj)
				cCodF := SA2->A2_COD
				cLojF := SA2->A2_LOJA
				cNomC := SA2->A2_NOME

				// ajusta conta bancaria - conforme solicitacao do sr Victo ramon - 12/11/2025
				if !Empty(cBco)
					Reclock("SA2",.f.)
					SA2->A2_BANCO   := cBco
					SA2->A2_AGENCIA := cAge
					SA2->A2_DVAGE   := cDvAge
					SA2->A2_NUMCON  := cCta
					SA2->A2_DVCTA   := cDvCta
					Msunlock("SA2")
				Endif

			ELSE

				// AJUSTA O STATUS PARA IMPORTADO
				DBSELECTAREA("ZZD")
				DBGOTO(nRcno)
				RECLOCK("ZZD",.F.)
				ZZD->ZZD_STATUS := "2"
				ZZD->ZZD_ERROR  := "FORNECEDOR NAO CADASTRADO (CPF/CNPJ) :  " + cCnpj
				MSUNLOCK("ZZD")

				DBSELECTAREA(cAliasTemp)
				DBSKIP()
				LOOP
			ENDIF
		ELSE

			// AJUSTA O STATUS PARA IMPORTADO
			DBSELECTAREA("ZZD")
			DBGOTO(nRcno)
			RECLOCK("ZZD",.F.)
			ZZD->ZZD_STATUS := "2"
			ZZD->ZZD_ERROR  := "CAMPO ZZD_CNPJ, NAO PREENCHIDO !!! "
			MSUNLOCK("ZZD")

			DBSELECTAREA(cAliasTemp)
			DBSKIP()
			LOOP

		ENDIF

      /*
      Feito tratamento na procedure, segundo George
      // CONTA CONTABIL
      if ALLTRIM((cAliasTemp)->ZZD_CNTCTB) == "32211004"
         cCnta := "32131003"
      Elseif ALLTRIM((cAliasTemp)->ZZD_CNTCTB) $ "31211002"
         cCnta := "31211002"
      Elseif ALLTRIM((cAliasTemp)->ZZD_CNTCTB) $ "32112016|32112017"
         cCnta := "32121004"
      Elseif ALLTRIM((cAliasTemp)->ZZD_CNTCTB) == "32112024"
         cCnta := "32121005"
      Elseif ALLTRIM((cAliasTemp)->ZZD_CNTCTB) == "32112007"
         cCnta := "32121002"
      EndIf

      // CENTRO DE CUSTO
      if ALLTRIM((cAliasTemp)->ZZD_CC) == "1710103"
         cCusto := "210102"
      Elseif ALLTRIM((cAliasTemp)->ZZD_CC) $ "1240110"
         cCusto := "130107"
      Elseif ALLTRIM((cAliasTemp)->ZZD_CC) $ "1130102"
         cCusto := "120102"
      Elseif ALLTRIM((cAliasTemp)->ZZD_CC) $ "1130105"
         cCusto := "120105"
      Elseif ALLTRIM((cAliasTemp)->ZZD_CC) $ "1130101"
         cCusto := "120101"
      Elseif ALLTRIM((cAliasTemp)->ZZD_CC) $ "1120107"
         cCusto := "110104"
      EndIf   
      */

		// VERIFICA SE EXISTE O BANCO CADASTRADO NA TABELA "FIL"
		if !EMPTY(ALLTRIM(cBco))
			DBSELECTAREA("FIL")
			DBSETORDER(1)
			IF !DBSEEK(XFILIAL("FIL")+cCodF+cLojF+"2"+cBco+cAge+cCta)
				RECLOCK("FIL",.T.)
				FIL->FIL_FILIAL := XFILIAL("FIL")
				FIL->FIL_FORNEC := cCodF
				FIL->FIL_LOJA   := cLojF
				FIL->FIL_BANCO  := cBco
				FIL->FIL_AGENCI := cAge
				FIL->FIL_DVAGE  := cDvAge
				FIL->FIL_CONTA  := cCta
				FIL->FIL_DVCTA  := cDvCta
				FIL->FIL_TIPO   := "2"
				FIL->FIL_MOEDA  := 1
				FIL->FIL_TIPCTA := "1"
				MSUNLOCK("FIL")
			ENDIF
		Endif

		// Limpa o buffer do Help antes de executar
		FwClearHlp()

		// INICIO DO PROCESSO DE INCLUSAO DE TITULOS
		IF (cAliasTemp)->ZZD_PREFIX == "ADT"
			aadd(aArray,{ "E2_FILIAL"  ,cFlCg                             , NIL})
			aAdd(aArray,{ "E2_PREFIXO" ,ALLTRIM((cAliasTemp)->ZZD_PREFIX) , NIL })
			aAdd(aArray,{ "E2_NUM"     ,ALLTRIM(cNrTT)                    , NIL })
			aAdd(aArray,{ "E2_PARCELA" ,ALLTRIM((cAliasTemp)->ZZD_PARCEL) , NIL })
			aAdd(aArray,{ "E2_TIPO"    ,ALLTRIM((cAliasTemp)->ZZD_TIPO)   , NIL })
			aAdd(aArray,{ "E2_NATUREZ" ,ALLTRIM((cAliasTemp)->ZZD_NATURE) , NIL })
			aAdd(aArray,{ "E2_FORNECE" ,cCodF                             , NIL })
			aAdd(aArray,{ "E2_LOJA"    ,cLojF                             , NIL })
			aAdd(aArray,{ "E2_EMISSAO" ,dDtVto                            , NIL })  // AJUSTADO PARA USAR O VENCIMENTO. SOLICITACAO CARGLASS. (06/11/2025 - RICARDO)
			aAdd(aArray,{ "E2_VENCTO"  ,dDtVto                            , NIL })
			aAdd(aArray,{ "E2_VENCREA" ,dDtVto                            , NIL })
			aAdd(aArray,{ "E2_EMIS1"   ,dDtVto                            , NIL })
			aAdd(aArray,{ "E2_HIST"    ,ALLTRIM((cAliasTemp)->ZZD_HIST)   , NIL })
			aAdd(aArray,{ "E2_VALOR"   ,(cAliasTemp)->ZZD_VALOR           , NIL })
			aAdd(aArray,{ "E2_CCUSTO"  ,cCusto                           , NIL })
			aAdd(aArray,{ "E2_CONTAD"  ,cCnta                    , NIL })
			aAdd(aArray,{ "E2_FORBCO"  ,cBco , NIL })
			aAdd(aArray,{ "E2_FORAGE"  ,cAge , NIL })
			aAdd(aArray,{ "E2_FORCTA"  ,cCta , NIL })
			aAdd(aArray,{ "E2_REFID"   ,ALLTRIM((cAliasTemp)->ZZD_REFID)   , NIL })
			aAdd(aArray,{ "E2_ORDERID" ,ALLTRIM((cAliasTemp)->ZZD_ORDEID)  , NIL })
			aAdd(aArray,{ "AUTBANCO"   ,cCBc , NIL })
			aAdd(aArray,{ "AUTAGENCIA" ,cCAg , NIL })
			aAdd(aArray,{ "AUTCONTA"   ,cCCt , NIL })

			MsExecAuto( { |x,y| FINA050(x,y)}, aArray, 3) // 3 - Inclusao, 4 - Altera, 5 - Exclui

			If !lMsErroAuto
				// AJUSTA O STATUS PARA IMPORTADO
				DBSELECTAREA("ZZD")
				DBGOTO(nRcno)
				RECLOCK("ZZD",.F.)
				ZZD->ZZD_STATUS := "1"
				MSUNLOCK("ZZD")

				// CADASTRA CHAVE PIX
				IF !EMPTY(cChvP)
					DBSELECTAREA("F72")
					DBSETORDER(1)
					IF !dBSEEK(XFILIAL("F72")+cCodF+cLojF+"03"+cChvP)
						RECLOCK("F72",.T.)
						F72->F72_FILIAL := XFILIAL("F72")
						F72->F72_COD    := cCodF
						F72->F72_LOJA   := cLojF
						F72->F72_TPCHV  := "03"
						F72->F72_CHVPIX := cChvP
						F72->F72_ACTIVE := "1"
						F72->F72_NOME   := cNomC
						MSUNLOCK("F72")
					ENDIF
				ENDIF
			Else

				// Se falhou, pega a última mensagem de Help
				cMsg := FWGetUltHlp()

				// AJUSTA O STATUS PARA IMPORTADO
				DBSELECTAREA("ZZD")
				DBGOTO(nRcno)
				RECLOCK("ZZD",.F.)
				ZZD->ZZD_STATUS := "2"
				ZZD->ZZD_ERROR  := CMSG[1] + " - " + CMSG[2][1]
				MSUNLOCK("ZZD")

			EndIf

		Else
         //12/01/2025 - inclusão por solcitação da RENATA, em reunião com Thiago / Fábio e Renata
         cAtv := BusForPix()
         IF !EMPTY(cAtv)
   			aadd(aArray,{ "E2_XACTIVE"  ,cAtv                          , NIL})
         ENDIF

			aadd(aArray,{ "E2_FILIAL"  ,cFlCg                             , NIL})
			aAdd(aArray,{ "E2_PREFIXO" ,ALLTRIM((cAliasTemp)->ZZD_PREFIX) , NIL })
			aAdd(aArray,{ "E2_NUM"     ,ALLTRIM(cNrTT)                    , NIL })
			aAdd(aArray,{ "E2_PARCELA" ,ALLTRIM((cAliasTemp)->ZZD_PARCEL) , NIL })
			aAdd(aArray,{ "E2_TIPO"    ,ALLTRIM((cAliasTemp)->ZZD_TIPO)   , NIL })
			aAdd(aArray,{ "E2_NATUREZ" ,ALLTRIM((cAliasTemp)->ZZD_NATURE) , NIL })
			aAdd(aArray,{ "E2_FORNECE" ,cCodF                             , NIL })
			aAdd(aArray,{ "E2_LOJA"    ,cLojF                             , NIL })
			aAdd(aArray,{ "E2_EMISSAO" ,dDtEmi                   , NIL })
			aAdd(aArray,{ "E2_VENCTO"  ,dDtVto                   , NIL })
			aAdd(aArray,{ "E2_VENCREA" ,dDtVto                   , NIL })
			aAdd(aArray,{ "E2_EMIS1"   ,dDtEmi                            , NIL })
			aAdd(aArray,{ "E2_HIST"    ,ALLTRIM((cAliasTemp)->ZZD_HIST)   , NIL })
			aAdd(aArray,{ "E2_VALOR"   ,(cAliasTemp)->ZZD_VALOR  , NIL })
			aAdd(aArray,{ "E2_CCUSTO"  ,ALLTRIM(cCusto)                   , NIL })
			aAdd(aArray,{ "E2_CONTAD"  ,ALLTRIM(cCnta)                    , NIL })
			aAdd(aArray,{ "E2_FORBCO"  ,cBco , NIL })
			aAdd(aArray,{ "E2_FORAGE"  ,cAge , NIL })
			aAdd(aArray,{ "E2_FORCTA"  ,cCta , NIL })
			aAdd(aArray,{ "E2_REFID"   ,ALLTRIM((cAliasTemp)->ZZD_REFID)   , NIL })
			aAdd(aArray,{ "E2_ORDERID" ,ALLTRIM((cAliasTemp)->ZZD_ORDEID)  , NIL })

			MsExecAuto( { |x,y| FINA050(x,y)}, aArray, 3) // 3 - Inclusao, 4 - Altera, 5 - Exclui

			If !lMsErroAuto
				// AJUSTA O STATUS PARA IMPORTADO
				DBSELECTAREA("ZZD")
				DBGOTO(nRcno)
				RECLOCK("ZZD",.F.)
				ZZD->ZZD_STATUS := "1"
				MSUNLOCK("ZZD")

				// CADASTRA CHAVE PIX
				IF !EMPTY(cChvP)
					DBSELECTAREA("F72")
					DBSETORDER(1)
					IF !dBSEEK(XFILIAL("F72")+cCodF+cLojF+"03"+cChvP)
						RECLOCK("F72",.T.)
						F72->F72_FILIAL := XFILIAL("F72")
						F72->F72_COD    := cCodF
						F72->F72_LOJA   := cLojF
						F72->F72_TPCHV  := "03"
						F72->F72_CHVPIX := cChvP
						F72->F72_ACTIVE := "1"
						F72->F72_NOME   := cNomC
						MSUNLOCK("F72")
					ENDIF
				ENDIF
			Else

				// Se falhou, pega a última mensagem de Help
				cMsg := FWGetUltHlp()

				// AJUSTA O STATUS PARA IMPORTADO
				DBSELECTAREA("ZZD")
				DBGOTO(nRcno)
				RECLOCK("ZZD",.F.)
				ZZD->ZZD_STATUS := "2"
				ZZD->ZZD_ERROR  := CMSG[1] + " - " + CMSG[2][1]
				MSUNLOCK("ZZD")

			EndIf
		ENDIF

		DBSELECTAREA(cAliasTemp)
		DBSKIP()
		LOOP
	End
Return

/*/{Protheus.doc} JOBZZD
axcadastro da tabela ZZD
@type function
@version  1.0
@author Cavalini
@since 17/10/2025
/*/
USER FUNCTION ZZD
	AXCADASTRO("ZZD","ZZD - tabela intermediaria")
RETURN



/*/
	|---------------------------------------------------------------------|
	| Func:  BusForPix                                                    |
	| Autor: Fabio José Batista                                           |
	| Data:  05/12/2025                                                   |
	| Desc:  Valida a existencia do fornecedor com PIX                    |
	| Return: cActive                                                     |
	|---------------------------------------------------------------------|
 /*/
Static Function BusForPix()
	Local cQry    := ''
	Local aArea   := GetArea()
	Local cActive := ''

	cQry := "SELECT SE2.E2_FORNECE,SE2.E2_LOJA,F72.F72_ACTIVE "
	cQry += "from "+RetSqlName('SE2') + " SE2 " "
	cQry += "inner join "+RetSqlName('F72') + " F72 "
	cQry += "on SE2.E2_FORNECE = F72.F72_COD and SE2.E2_LOJA = F72.F72_LOJA and F72.D_E_L_E_T_ =  ' ' "
	cQry += "where SE2.D_E_L_E_T_ = ' ' "
	cQry += "and SE2.E2_NUM     = '" + SE2->E2_NUM     + "'  "
	cQry += "and SE2.E2_FORNECE = '" + SE2->E2_FORNECE + "'  "
	cQry += "and SE2.E2_LOJA    = '" + SE2->E2_LOJA    + "'  "

	cQry := ChangeQuery(cQry)
	TCQuery cQry New Alias "cQry"

	cQry->(DbGoTop())
	While !cQry->(Eof())
		cActive := cQry->(F72_ACTIVE)
		cQry->(DbSkip())
	EndDo

	cQry->(DbCloseArea())

	RestArea(aArea)

Return cActive
