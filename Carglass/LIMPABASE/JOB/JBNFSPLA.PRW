#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#DEFINE CRLF CHR(13)+CHR(10)

/*/{Protheus.doc} JBNFSPLA - FATURAMENTO NFS PLANO AUTO - APENAS PLANO AUTO
    @author J.EDILSON
    @since 17/11/2025
/*/

User Function JBNFSPLA()
    Local cAlSC5  := GetNextAlias()
    Local cQuery  := ""
    Local nLinha  := 0
    Local aRetGrv := {}
    Local oJob    := LIBGLASS():new()

	//PREPARE ENVIRONMENT EMPRESA cEmpAnt FILIAL cFilAnt MODULO 'FAT'

    cQuery := " SELECT * "
    cQuery += " FROM "+RetSQLName("SC5") + " AS C5 WITH (NOLOCK) "
    cQuery += " WHERE C5.D_E_L_E_T_ <> '*' AND C5_ZEXTID = '20251102956796PA' AND C5_NOTA = '' "
    // cQuery += " WHERE C5.D_E_L_E_T_ <> '*' AND C5_ZEXTID LIKE '%PA' AND C5_NOTA = '' "
    DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSC5, .F., .T.)    

	Do While !(cAlSC5)->(eof())

        cPdv    := (cAlSC5)->C5_NUM
		cFilAt  := (cAlSC5)->C5_FILIAL
        aRetGrv := oJob:GerarNota(cPdv, cFilAt)

		If Len(aRetGrv) == 0
			cErrorLog   := ''
			aLogAuto    := aRetGrv
			For nLinha := 1 To Len(aLogAuto)
				cErrorLog += aLogAuto[nLinha,1] + CRLF
			Next nLinha

			//Grava o arquivo de log
			cArqLog := 'WSNFS_JOB_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
			MemoWrite(cDirLog + cArqLog, cErrorLog)

			cResponc := jResponse['errorId'] + jResponse['error'] + jResponse['solution']
			oJob:GRAVALOGMURO(cResponc, "", "JOBWSNFS", "INCLUSÃO DE Nota Fiscal de Saida")
            ConOut("JOB NOTA SAIDA")
		Else
            ConOut('Registro incluido com sucesso - ' + aRetGrv[1,1] + " - " + aRetGrv[1,2])
		EndIf
		(cAlSC5)->( dbSkip() )	
		Loop
	EndDo

    (cAlSC5)->(dbclosearea())

    //RESET ENVIRONMENT

Return
