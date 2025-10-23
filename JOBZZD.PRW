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
Local cCta   := ""
Local cTPA   := SuperGetMV("CG_CARGTPA",,"341|0048 |25519")
Local cCBc   := ""
Local cCAg   := ""
Local cCCt   := ""

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
      cBco        := ALLTRIM((cAliasTemp)->ZZD_FORBCO)
      cAge        := ALLTRIM((cAliasTemp)->ZZD_FORAGE) 
      cCta        := ALLTRIM((cAliasTemp)->ZZD_FORCTA)
      cCBc        := SUBSTR(cTPA,01,3)
      cCAg        := SUBSTR(cTPA,05,4)
      cCCt        := SUBSTR(cTPA,11,5)

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

      // VERIFICA SE EXISTE O BANCO CADASTRADO NA TABELA "FIL"
      DBSELECTAREA("FIL")
      DBSETORDER(1)
      IF !DBSEEK(XFILIAL("FIL")+alltrim((cAliasTemp)->ZZD_COD)+(cAliasTemp)->ZZD_LOJA+"2"+cBco+cAge+cCta)
         RECLOCK("FIL",.T.)
          FIL->FIL_FILIAL := XFILIAL("FIL")
          FIL->FIL_FORNEC := ALLTRIM((cAliasTemp)->ZZD_COD)  
          FIL->FIL_LOJA   := ALLTRIM((cAliasTemp)->ZZD_LOJA)
          FIL->FIL_BANCO  := cBco
          FIL->FIL_AGENCI := cAge
          FIL->FIL_CONTA  := cCta
          FIL->FIL_TIPO   := "2"
          FIL->FIL_MOEDA  := 1
          FIL->FIL_TIPCTA := "1"
         MSUNLOCK("FIL")
      ENDIF

      // INICIO DO PROCESSO DE INCLUSAO DE TITULOS
      IF (cAliasTemp)->ZZD_PREFIX == "ADT"
         aadd(aArray,{ "E2_FILIAL"  ,XFILIAL("SE2")           , NIL})
         aAdd(aArray,{ "E2_PREFIXO" ,ALLTRIM((cAliasTemp)->ZZD_PREFIX) , NIL })
         aAdd(aArray,{ "E2_NUM"     ,ALLTRIM(cNrTT)                    , NIL })
         aAdd(aArray,{ "E2_PARCELA" ,ALLTRIM((cAliasTemp)->ZZD_PARCEL) , NIL })
         aAdd(aArray,{ "E2_TIPO"    ,ALLTRIM((cAliasTemp)->ZZD_TIPO)   , NIL })
         aAdd(aArray,{ "E2_NATUREZ" ,ALLTRIM((cAliasTemp)->ZZD_NATURE) , NIL })
         aAdd(aArray,{ "E2_FORNECE" ,ALLTRIM((cAliasTemp)->ZZD_COD)    , NIL })
         aAdd(aArray,{ "E2_LOJA"    ,ALLTRIM((cAliasTemp)->ZZD_LOJA)   , NIL })
         aAdd(aArray,{ "E2_EMISSAO" ,dDtEmi                   , NIL })
         aAdd(aArray,{ "E2_VENCTO"  ,dDtVto                   , NIL })
         aAdd(aArray,{ "E2_VENCREA" ,dDtVto                   , NIL })
         aAdd(aArray,{ "E2_HIST"    ,ALLTRIM((cAliasTemp)->ZZD_HIST)   , NIL })
         aAdd(aArray,{ "E2_VALOR"   ,(cAliasTemp)->ZZD_VALOR  , NIL })
         aAdd(aArray,{ "E2_CCUSTO"  ,cCusto                   , NIL })         
         aAdd(aArray,{ "E2_CONTAD"  ,cCnta                    , NIL })         
         aAdd(aArray,{ "E2_FORBCO"  ,cBco , NIL })
         aAdd(aArray,{ "E2_FORAGE"  ,cAge , NIL })
         aAdd(aArray,{ "E2_FORCTA"  ,cCta , NIL })
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
               IF !dBSEEK(XFILIAL("F72")+alltrim((cAliasTemp)->ZZD_COD)+(cAliasTemp)->ZZD_LOJA+"03"+cChvP)
                  RECLOCK("F72",.T.)
                   F72->F72_FILIAL := XFILIAL("F72")
                   F72->F72_COD    := (cAliasTemp)->ZZD_COD 
                   F72->F72_LOJA   := (cAliasTemp)->ZZD_LOJA
                   F72->F72_TPCHV  := "03"
                   F72->F72_CHVPIX := cChvP
                   F72->F72_ACTIVE := "2"                
                  MSUNLOCK("F72")
               ENDIF
            ENDIF
         Else
      	   // VERIFICAR PROCEDIMENTO DE ERRO E INCLUSAO DE FORNECEDOR
            ConOut("Erro na inclusao do titulo (ADT) : "+ZZD->ZZD_NUM)
         EndIf

      Else

         aadd(aArray,{ "E2_FILIAL"  ,XFILIAL("SE2")           , NIL})
         aAdd(aArray,{ "E2_PREFIXO" ,ALLTRIM((cAliasTemp)->ZZD_PREFIX) , NIL })
         aAdd(aArray,{ "E2_NUM"     ,ALLTRIM(cNrTT)                    , NIL })
         aAdd(aArray,{ "E2_PARCELA" ,ALLTRIM((cAliasTemp)->ZZD_PARCEL) , NIL })
         aAdd(aArray,{ "E2_TIPO"    ,ALLTRIM((cAliasTemp)->ZZD_TIPO)   , NIL })
         aAdd(aArray,{ "E2_NATUREZ" ,ALLTRIM((cAliasTemp)->ZZD_NATURE) , NIL })
         aAdd(aArray,{ "E2_FORNECE" ,ALLTRIM((cAliasTemp)->ZZD_COD)    , NIL })
         aAdd(aArray,{ "E2_LOJA"    ,ALLTRIM((cAliasTemp)->ZZD_LOJA)   , NIL })
         aAdd(aArray,{ "E2_EMISSAO" ,dDtEmi                   , NIL })
         aAdd(aArray,{ "E2_VENCTO"  ,dDtVto                   , NIL })
         aAdd(aArray,{ "E2_VENCREA" ,dDtVto                   , NIL })
         aAdd(aArray,{ "E2_HIST"    ,ALLTRIM((cAliasTemp)->ZZD_HIST)   , NIL })
         aAdd(aArray,{ "E2_VALOR"   ,(cAliasTemp)->ZZD_VALOR  , NIL })
         aAdd(aArray,{ "E2_CCUSTO"  ,ALLTRIM(cCusto)                   , NIL })      
         aAdd(aArray,{ "E2_CONTAD"  ,ALLTRIM(cCnta)                    , NIL })            
         aAdd(aArray,{ "E2_FORBCO"  ,cBco , NIL })
         aAdd(aArray,{ "E2_FORAGE"  ,cAge , NIL })
         aAdd(aArray,{ "E2_FORCTA"  ,cCta , NIL })

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
               IF !dBSEEK(XFILIAL("F72")+alltrim((cAliasTemp)->ZZD_COD)+(cAliasTemp)->ZZD_LOJA+"03"+cChvP)
                  RECLOCK("F72",.T.)
                   F72->F72_FILIAL := XFILIAL("F72")
                   F72->F72_COD    := (cAliasTemp)->ZZD_COD 
                   F72->F72_LOJA   := (cAliasTemp)->ZZD_LOJA
                   F72->F72_TPCHV  := "03"
                   F72->F72_CHVPIX := cChvP
                   F72->F72_ACTIVE := "2"                
                  MSUNLOCK("F72")
               ENDIF
            ENDIF
         Else
      	   // VERIFICAR PROCEDIMENTO DE ERRO E INCLUSAO DE FORNECEDOR
            ConOut("Erro na inclusao do titulo (RMB) : "+ZZD->ZZD_NUM)
         EndIf
      ENDIF
  
    DBSELECTAREA(cAliasTemp)
    DBSKIP()
    LOOP
End
Return
