#INCLUDE 'TOTVS.CH'
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} User Function PE01NFESEFAZ
    @type  Function
    @author J.Edilson
    @since 10/07/2025
/*/

User Function PE01NFESEFAZ()
    Local aRet       := {}
    Local aProd      := PARAMIXB[1]
    Local cMensCli   := PARAMIXB[2]
    Local cMensFis   := PARAMIXB[3]
    Local aDest      := PARAMIXB[4]
    Local aNota      := PARAMIXB[5]
    Local aInfoItem  := PARAMIXB[6]
    Local aDupl      := PARAMIXB[7]
    Local aTransp    := PARAMIXB[8]
    Local aEntrega   := PARAMIXB[9]
    Local aRetirada  := PARAMIXB[10]
    Local aVeiculo   := PARAMIXB[11]
    Local aReboque   := PARAMIXB[12]
    Local aNfVincRur := PARAMIXB[13]
    Local aEspVol    := PARAMIXB[14]
    Local aNfVinc    := PARAMIXB[15]
    Local aDetPag    := PARAMIXB[16]
    Local aObsCont   := PARAMIXB[17]
    Local aProcRef   := PARAMIXB[18]
    Local aMed       := PARAMIXB[19]
    Local aLote      := PARAMIXB[20]

    //Exemplo a ser utilizado
	//cMensCli := ExecBlock('PFFATA29', .F., .F., {cMensCli, aNota})
    cMensCli += ", Pedido: " + ainfoItem[1,1]
    cMensCli += ", Inf. Complementares: " + PgMsnNt(SF2->F2_FILIAL, SF2->F2_DOC, SF2->F2_SERIE, SF2->F2_CLIENTE, SF2->F2_LOJA)

    Aadd(aRet, aProd)
    Aadd(aRet, cMensCli)
    Aadd(aRet, cMensFis)
    Aadd(aRet, aDest)
    Aadd(aRet, aNota)
    Aadd(aRet, aInfoItem)
    Aadd(aRet, aDupl)
    Aadd(aRet, aTransp)
    Aadd(aRet, aEntrega)
    Aadd(aRet, aRetirada)
    Aadd(aRet, aVeiculo)
    Aadd(aRet, aReboque)
    Aadd(aRet, aNfVincRur)
    Aadd(aRet, aEspVol)
    Aadd(aRet, aNfVinc)
    Aadd(aRet, aDetPag)
    Aadd(aRet, aObsCont)
    Aadd(aRet, aProcRef)
    Aadd(aRet, aMed)
    Aadd(aRet, aLote)
Return aRet

Static Function PgMsnNt(_FILIAL, _DOC, _SERIE, _CLIENTE, _LOJA)
    local cRet := ""
    Local cAlSC5    := GetNextAlias()

    cQuery := " SELECT * "
    cQuery += " FROM "+RetSQLName("SC5") + " AS C5 WITH (NOLOCK) "
    cQuery += " WHERE C5.D_E_L_E_T_ <> '*' AND C5_NOTA = '"+_DOC+"' AND "
    cQuery += " C5_SERIE = '"+_SERIE+"' AND C5_CLIENTE = '"+_CLIENTE+"' AND C5_LOJACLI = '"+_LOJA+"'  "
    DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSC5, .F., .T.)    

    cRet := "CONTRATO: " + (cAlSC5)->C5_ZEXTID + "  "
	cRet += "PLACA / PEDIDO: " + (cAlSC5)->C5_PLACA + " - " + (cAlSC5)->C5_NUM + " "
	cRet += "SINISTRO / AUTORIZACAO: " + (cAlSC5)->C5_SINISTR + "  "

    (cAlSC5)->(DBCLOSEAREA())

Return cRet
