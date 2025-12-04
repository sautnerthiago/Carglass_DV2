#INCLUDE "APWIZARD.CH"
#include 'parmtype.ch'
#Include "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#include 'tbiconn.ch'
#INCLUDE "TOTVS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "RESTFUL.CH"
#INCLUDE "FWAdapterEAI.ch"

user function AJUSTSA1()
	Local aArea := GetArea()
    FWMsgRun(, {|oSay| PFF(oSay) }, "Processando", "Processando dados....")
    RestArea(aArea)
Return

//---------------------------------------------------------------------------------
Static Function PFF(oMens)

	oMens:SetText('Aguarde...')
	oMens:Refresh()
	ProcessMessages()

	IF cEmpAnt == "01"
		oMens:SetText("Migrando - CARGLASS...")
		oMens:Refresh()
		ProcessMessages()
		AjustCAR()
	ENDIF

	IF cEmpAnt == "02"
		oMens:SetText("Migrando - DSK...")
		oMens:Refresh()
		ProcessMessages()
		AjustDSK()
	ENDIF

	Alert("Processamento Terminado. Processadas "+Transform(nContador,"@E 999,999")+" tabelas.")
	oMens:SetText("Proc. "+Transform(nContador,"@E 999,999"))
	oMens:Refresh()
	ProcessMessages()

RETURN

//------------------------------------------------------------------------------------------
Static Function AjustDSK()
	Local aErr 	 := {}
	Local X      := 0
	Local aDados := {}
	Local cQuery := ""

	Local nTotReg := 0
	Local nTotGrv := 0
	Local nTotErr := 0


	cQuery := ChangeQuery("SELECT * FROM ZZB010 ")
	ZZB	   := CriaTrab(Nil,.F.)
	DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),ZZB, .F., .T.)   

	nTotReg := 0
	nTotGrv := 0
 	nTotErr := 0
	While !(ZZB)->(EOF())
		nTotReg++
		IF !JAEXIT((ZZB)->ZZB_CGC, "020") //DSK
			aDados := {}
			aAdd(aDados, {'A1_FILIAL' 	, (ZZB)->ZZB_FILIAL		, Nil} )
			aAdd(aDados, {'A1_COD'    	, (ZZB)->ZZB_COD   		, Nil} )
			aAdd(aDados, {'A1_LOJA'   	, (ZZB)->ZZB_LOJA  		, Nil} )
			aAdd(aDados, {'A1_NOME'   	, (ZZB)->ZZB_NOME  		, Nil} )
			aAdd(aDados, {'A1_PESSOA'	, (ZZB)->ZZB_PESSOA 	, Nil} )
			aAdd(aDados, {'A1_END'		, (ZZB)->ZZB_END 		, Nil} )
			aAdd(aDados, {'A1_NREDUZ'	, (ZZB)->ZZB_NREDUZ  	, Nil} )
			aAdd(aDados, {'A1_CONTAT'	, (ZZB)->ZZB_CONTAT  	, Nil} )
			aAdd(aDados, {'A1_TEL'		, (ZZB)->ZZB_TEL    	, Nil} )
			aAdd(aDados, {'A1_MUN'		, (ZZB)->ZZB_MUN    	, Nil} )
			aAdd(aDados, {'A1_BAIRRO'	, (ZZB)->ZZB_BAIRRO		, Nil} )
			aAdd(aDados, {'A1_TIPO'		, (ZZB)->ZZB_TIPO   	, Nil} )
			aAdd(aDados, {'A1_EST'		, (ZZB)->ZZB_EST    	, Nil} )
			aAdd(aDados, {'A1_COD_MUN'	, (ZZB)->ZZB_COD_MUN  	, Nil} )
			aAdd(aDados, {'A1_CEP'		, (ZZB)->ZZB_CEP    	, Nil} )
			aAdd(aDados, {'A1_ENDCOB'	, (ZZB)->ZZB_ENDCOB  	, Nil} )
			aAdd(aDados, {'A1_ENDREC'	, (ZZB)->ZZB_ENDREC   	, Nil} )
			aAdd(aDados, {'A1_CGC'		, (ZZB)->ZZB_CGC    	, Nil} )
			aAdd(aDados, {'A1_PAIS'		, (ZZB)->ZZB_PAIS 		, Nil} )
			aAdd(aDados, {'A1_CODPAI'	, (ZZB)->ZZB_CODPAI 	, Nil} )
			aAdd(aDados, {'A1_CALCSU'	, (ZZB)->ZZB_CALCSU  	, Nil} )
			aAdd(aDados, {'A1_CEPC'		, (ZZB)->ZZB_CEPC    	, Nil} )
			aAdd(aDados, {'A1_MUNC'		, (ZZB)->ZZB_MUNC   	, Nil} )
			aAdd(aDados, {'A1_ESTC'		, (ZZB)->ZZB_ESTC		, Nil} )
			aAdd(aDados, {'A1_BAIRRC'	, (ZZB)->ZZB_BAIRRC		, Nil} )
			aAdd(aDados, {'A1_ENDENT'	, (ZZB)->ZZB_ENDENT		, Nil} )
			aAdd(aDados, {'A1_ESTE'		, (ZZB)->ZZB_ESTE		, Nil} )
			aAdd(aDados, {'A1_BAIRRE'	, (ZZB)->ZZB_BAIRRE		, Nil} )
			aAdd(aDados, {'A1_EMAIL'	, (ZZB)->ZZB_EMAIL		, Nil} )
			aAdd(aDados, {'A1_CONTA'	, (ZZB)->ZZB_CONTA		, Nil} )
			aAdd(aDados, {'A1_GRPTRI' 	, (ZZB)->ZZB_GRPTRI		, Nil} )
			aAdd(aDados, {'A1_INSCR' 	, (ZZB)->ZZB_INSCR		, Nil} )
			aAdd(aDados, {'A1_CODSEG'	, (ZZB)->ZZB_CODSEG		, Nil} )
			(ZZB)->(DBSKIP())

			aErr := GRAVA(aDados, "02", "")

			If nTotReg % 10 == 0
				ConOut("Total de Registro: " + Alltrim(Str(nTotReg)))
			endif

			FOR X:= 1 TO LEN(aErr)
				IF !Empty(aErr[x,1])
					nTotErr++
					cQuery := " UPDATE ZZB010 SET ZZB_ERRO = '"+aErr[1,2]+"' "
					cQuery += " WHERE ZZB_COD = '"+aErr[1,3]+"' AND "
					cQuery += " ZZB_LOJA = '"+aErr[1,4]+"'  "
					if TCSqlExec(cQuery) < 0
						lRet := .T.
						ConOut("Erro na gravação do Cliente: " + TCSQLError())
					else
						TcSqlExec("COMMIT")
					endif

					If nTotErr % 10 == 0
						ConOut("Total de Registros Com Erro: " + Alltrim(Str(nTotErr)))
					endif

				ELSE
					nTotGrv++
					cQuery := " UPDATE ZZB010 SET ZZB_INTEGR = 'S' "
					cQuery += " WHERE ZZB_COD = '"+aErr[1,3]+"' AND "
					cQuery += " ZZB_LOJA = '"+aErr[1,4]+"'  "
					if TCSqlExec(cQuery) < 0
						lRet := .T.
						ConOut("Erro na gravação do Cliente: " + TCSQLError())
					else
						TcSqlExec("COMMIT")
					endif

					If nTotGrv % 10 == 0
						ConOut("Total de Registros sem Erros: " + Alltrim(Str(nTotGrv)))
					endif

				endif
			Next
		ELSE
			(ZZB)->(DBSKIP())
		ENDIF

	Enddo
	(ZZB)->(DBCLOSEAREA())
	
Return aDados

Static Function AjustCAR()
	Local aErr 	  := {}
	Local X       := 0
	Local aDados  := {}

	Local nTotReg := 0
	Local nTotGrv := 0
	Local nTotErr := 0

    Local cQuery := "SELECT * FROM ZZA010 "
	QRYO := CriaTrab(Nil,.F.)
	DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),QRYO, .F., .T.)   

	nTotReg := 0
	nTotGrv := 0
 	nTotErr := 0
	While !(QRYO)->(EOF())
		nTotReg++
		IF !JAEXIT((QRYO)->ZZA_CGC, "010") //CARGLASS
			aDados := {}	
			aAdd(aDados, {'A1_FILIAL' 	, (QRYO)->ZZA_FILIAL	, Nil} )
			aAdd(aDados, {'A1_COD'    	, (QRYO)->ZZA_COD   	, Nil} )
			aAdd(aDados, {'A1_LOJA'   	, (QRYO)->ZZA_LOJA  	, Nil} )
			aAdd(aDados, {'A1_NOME'   	, (QRYO)->ZZA_NOME  	, Nil} )
			aAdd(aDados, {'A1_PESSOA'	, (QRYO)->ZZA_PESSOA 	, Nil} )
			aAdd(aDados, {'A1_END'		, (QRYO)->ZZA_END 		, Nil} )
			aAdd(aDados, {'A1_NREDUZ'	, (QRYO)->ZZA_NREDUZ  	, Nil} )
			aAdd(aDados, {'A1_CONTAT'	, (QRYO)->ZZA_CONTAT  	, Nil} )
			aAdd(aDados, {'A1_TEL'		, (QRYO)->ZZA_TEL    	, Nil} )
			aAdd(aDados, {'A1_MUN'		, (QRYO)->ZZA_MUN    	, Nil} )
			aAdd(aDados, {'A1_BAIRRO'	, (QRYO)->ZZA_BAIRRO	, Nil} )
			aAdd(aDados, {'A1_TIPO'		, (QRYO)->ZZA_TIPO   	, Nil} )
			aAdd(aDados, {'A1_EST'		, (QRYO)->ZZA_EST    	, Nil} )
			aAdd(aDados, {'A1_COD_MUN'	, (QRYO)->ZZA_COD_MUN  	, Nil} )
			aAdd(aDados, {'A1_CEP'		, (QRYO)->ZZA_CEP    	, Nil} )
			aAdd(aDados, {'A1_ENDCOB'	, (QRYO)->ZZA_ENDCOB  	, Nil} )
			aAdd(aDados, {'A1_ENDREC'	, (QRYO)->ZZA_ENDREC   	, Nil} )
			aAdd(aDados, {'A1_CGC'		, (QRYO)->ZZA_CGC    	, Nil} )
			aAdd(aDados, {'A1_PAIS'		, (QRYO)->ZZA_PAIS 		, Nil} )
			aAdd(aDados, {'A1_CODPAI'	, (QRYO)->ZZA_CODPAI 	, Nil} )
			aAdd(aDados, {'A1_CALCSU'	, (QRYO)->ZZA_CALCSU  	, Nil} )
			aAdd(aDados, {'A1_CEPC'		, (QRYO)->ZZA_CEPC    	, Nil} )
			aAdd(aDados, {'A1_MUNC'		, (QRYO)->ZZA_MUNC   	, Nil} )
			aAdd(aDados, {'A1_ESTC'		, (QRYO)->ZZA_ESTC		, Nil} )
			aAdd(aDados, {'A1_BAIRRC'	, (QRYO)->ZZA_BAIRRC	, Nil} )
			aAdd(aDados, {'A1_ENDENT'	, (QRYO)->ZZA_ENDENT	, Nil} )
			aAdd(aDados, {'A1_ESTE'		, (QRYO)->ZZA_ESTE		, Nil} )
			aAdd(aDados, {'A1_BAIRRE'	, (QRYO)->ZZA_BAIRRE	, Nil} )
			aAdd(aDados, {'A1_EMAIL'	, (QRYO)->ZZA_EMAIL		, Nil} )
			aAdd(aDados, {'A1_CONTA'	, (QRYO)->ZZA_CONTA		, Nil} )
			aAdd(aDados, {'A1_GRPTRI' 	, (QRYO)->ZZA_GRPTRI	, Nil} )
			aAdd(aDados, {'A1_INSCR' 	, (QRYO)->ZZA_INSCR		, Nil} )
			aAdd(aDados, {'A1_CODSEG'	, (QRYO)->ZZA_CODSEG	, Nil} )
			(QRYO)->(DBSKIP())
			
			aErr := GRAVA(aDados, "01", "")

			If nTotReg % 10 == 0
				ConOut("Total de Registro: " + Alltrim(Str(nTotReg)))
			endif

			FOR X:= 1 TO LEN(aErr)
				IF !Empty(aErr[x,1])
			 		nTotErr++
					cQuery := " UPDATE ZZA010 SET ZZA_ERRO = '"+aErr[1,2]+"' "
					cQuery += " WHERE ZZA_COD = '"+aErr[1,3]+"' AND "
					cQuery += " ZZA_LOJA = '"+aErr[1,4]+"'  "
					if TCSqlExec(cQuery) < 0
						lRet := .T.
						ConOut("Erro na gravação do Cliente: " + TCSQLError())
					else
						TcSqlExec("COMMIT")
					endif
					
					If nTotErr % 10 == 0
						ConOut("Total de Registros Com Erro: " + Alltrim(Str(nTotErr)))
					endif

				ELSE
					nTotGrv++
					cQuery := " UPDATE ZZA010 SET ZZA_INTEGR = 'S' "
					cQuery += " WHERE ZZA_COD = '"+aErr[1,3]+"' AND "
					cQuery += " ZZA_LOJA = '"+aErr[1,4]+"'  "
					if TCSqlExec(cQuery) < 0
						lRet := .T.
						ConOut("Erro na gravação do Cliente: " + TCSQLError())
					else
						TcSqlExec("COMMIT")
					endif
					
					If nTotGrv % 10 == 0
						ConOut("Total de Registros sem Erros: " + Alltrim(Str(nTotGrv)))
					endif

				endif
			Next
		ELSE
			(QRYO)->(DBSKIP())
		ENDIF

	Enddo
	(QRYO)->(DBCLOSEAREA())
	
Return aDados

Static Function GRAVA(aDados, cEmpAt, cFilAt)
	Local nCampo, nLinha := 0
	Local aRet := {}
	
	Private lMsErroAuto  := .F.

	cClien := aDados[2,2]
	cLoja  := aDados[3,2]

	//RPCSetEnv(cEmpAt, cFilAt)
		
	For nCampo := 1 To Len(aDados)
		//Se o campo for data, retira os hifens e faz a conversão
		If GetSX3Cache(aDados[nCampo][1], 'X3_TIPO') == 'D'
			//aDados[nCampo][2] := StrTran(aDados[nCampo][2], '-', '')
			aDados[nCampo][2] := sToD(aDados[nCampo][2])
		EndIf
	Next

	MsExecAuto({|x, y| MATA030(x, y)}, aDados, 3)

	//Se houve erro, gera um arquivo de log dentro do diretório da protheus data
	If lMsErroAuto
		//Monta o texto do Error Log que será salvo
		cErrorLog   := ''
		aLogAuto    := GetAutoGrLog()
		For nLinha := 1 To Len(aLogAuto)
			cErrorLog += aLogAuto[nLinha] + CRLF
		Next nLinha

		//Grava o arquivo de log
		cArqLog := cErrorLog
		AADD(aRet, { "E", cArqLog, cClien, cLoja } )

	Else
		cArqLog := 'Registro incluido com sucesso'
		AADD(aRet, { "", cArqLog, cClien, cLoja } )
	EndIf

	//rpcClearEnv()

Return aRet


Static Function JAEXIT(_CGC, cEmpFil)
	Local lRet := .T.
	cQuery := " SELECT A1_FILIAL, A1_COD, A1_LOJA, A1_NOME, A1_NREDUZ, A1_CGC, A1_END "
	cQuery += " FROM SA1"+cEmpFil+" AS SA1 WITH (NOLOCK) "
	cQuery += " WHERE "
    cQuery += " SA1.A1_CGC = '"+_CGC+"'  "
	cAlSA1:= CriaTrab(Nil,.F.)
	DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSA1, .F., .T.)    

	If EMPTY((cAlSA1)->A1_COD)
        lRet := .F. 
	Endif
    (cAlSA1)->(dbclosearea())

Return lRet


Static Function GetQuery(cQuery)
	Local cDes		:= ""
	Local cAliasTmp	:= CriaTrab(Nil,.F.)

	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTmp,.T.,.T.) 
	(cAliasTmp)->(dbgotop())
	IF(cAliasTmp)->(!EOF())
		cDes:=(cAliasTmp)->CONTEU
	EndIf  
	
	(cAliasTmp)->( dbCloseArea())  
	
Return(cDes)
