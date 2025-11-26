#Include "Protheus.ch"
#Include "TReport.ch"
#Include "TopConn.ch"

// --------------------------------------------------------------------------
// Relatório de Notas Fiscais x Pedidos de Venda (SFT010 x SC5010)
// Autor: George Eivazian
// --------------------------------------------------------------------------
User Function RELSFTSC5()
    Local oReport, oSection, oQuery
    Local cFilial   := ""
    Local dDtIni    := CTOD("")
    Local dDtFim    := CTOD("")
    Local cArqExcel := ""

    // ----------------------------------------------------------------------
    // ParamBox para seleção de filtros
    // ----------------------------------------------------------------------
    Private aPerg := {}

    AAdd(aPerg, {"cFilial",  "Filial:",     "",      "@!", "mv_par01"})
    AAdd(aPerg, {"dDtIni",   "Data Inicial:", Date()-30, "@D", "mv_par02"})
    AAdd(aPerg, {"dDtFim",   "Data Final:",   Date(),    "@D", "mv_par03"})

    If !ParamBox(aPerg, "Filtros - Relatório NF x PV", , .T.)
        Return
    EndIf

    cFilial := mv_par01
    dDtIni  := mv_par02
    dDtFim  := mv_par03

    // ----------------------------------------------------------------------
    // Criação do relatório
    // ----------------------------------------------------------------------
    oReport := TReport():New("R_SFTSC5", ;
        "Notas Fiscais x Pedidos de Venda", ;
        "Relação entre Notas Fiscais (SFT010) e Pedidos (SC5010)", ;
        "GEORGE")

    oSection := TRSection():New(oReport, "Relatório", "Dados de NF e PV", , , .T.)

    // ----------------------------------------------------------------------
    // Montagem da consulta SQL
    // ----------------------------------------------------------------------
    oQuery := TCSQLExec():New()

    oQuery:cSql := ;
        "SELECT " + ;
        "SFT.FT_FILIAL, " + ;
        "SFT.FT_SERIE, " + ;
        "SFT.FT_NFISCAL, " + ;
        "SFT.FT_CLIFOR, " + ;
        "SFT.FT_LOJA, " + ;
        "SFT.FT_EMISSAO, " + ;
        "SFT.FT_VALBRUT, " + ;
        "SFT.FT_PEDIDO, " + ;
        "SC5.C5_NUM, " + ;
        "SC5.C5_CLIENTE, " + ;
        "SC5.C5_LOJACLI, " + ;
        "SC5.C5_EMISSAO, " + ;
        "SC5.C5_VALOR " + ;
        "FROM " + RetSqlName("SFT010") + " SFT " + ;
        "LEFT JOIN " + RetSqlName("SC5010") + " SC5 " + ;
        "ON SFT.FT_PEDIDO = SC5.C5_NUM " + ;
        "AND SFT.FT_FILIAL = SC5.C5_FILIAL " + ;
        "WHERE SFT.D_E_L_E_T_ = ' ' " + ;
        "AND SC5.D_E_L_E_T_ = ' ' "

    If !Empty(cFilial)
        oQuery:cSql += "AND SFT.FT_FILIAL = '" + cFilial + "' "
    EndIf

    If !Empty(dDtIni) .And. !Empty(dDtFim)
        oQuery:cSql += "AND SFT.FT_EMISSAO BETWEEN '" + DToS(dDtIni) + "' AND '" + DToS(dDtFim) + "' "
    EndIf

    oQuery:cSql += "ORDER BY SFT.FT_EMISSAO, SFT.FT_NFISCAL"

    oQuery:Exec()

    // ----------------------------------------------------------------------
    // Definição das colunas
    // ----------------------------------------------------------------------
    oSection:AddColumn("FT_FILIAL",  "Filial",             6)
    oSection:AddColumn("FT_SERIE",   "Série",              4)
    oSection:AddColumn("FT_NFISCAL", "Nota Fiscal",        8)
    oSection:AddColumn("FT_CLIFOR",  "Cliente/Fornecedor", 12)
    oSection:AddColumn("FT_EMISSAO", "Emissão NF",         10)
    oSection:AddColumn("FT_VALBRUT", "Valor Bruto NF",     12)
    oSection:AddColumn("FT_PEDIDO",  "Pedido Vinculado",   10)
    oSection:AddColumn("C5_EMISSAO", "Emissão Pedido",     10)
    oSection:AddColumn("C5_VALOR",   "Valor Pedido",       12)

    // ----------------------------------------------------------------------
    // Totalização dos valores
    // ----------------------------------------------------------------------
    oSection:SetTotal("FT_VALBRUT")
    oSection:SetTotal("C5_VALOR")
    oSection:cFooter := "Totais do Período Selecionado"

    // ----------------------------------------------------------------------
    // Vincula a query ao relatório
    // ----------------------------------------------------------------------
    oSection:SetSource(oQuery:oResult)
    oReport:AddSection(oSection)

    // ----------------------------------------------------------------------
    // Exportação direta para Excel e abertura automática
    // ----------------------------------------------------------------------
    cArqExcel := GetTempPath() + "REL_SFTSC5_" + DToS(Date()) + ".xlsx"

    // Exporta para Excel sem abrir preview
    oReport:Print(.F., cArqExcel)

    // Verifica se o arquivo foi gerado e abre automaticamente
    If File(cArqExcel)
        MsgInfo("Relatório exportado com sucesso!" + CRLF + ;
                "Abrindo Excel...", "Exportação concluída")

        // Abre o arquivo no Excel (somente Windows)
        WinExec("excel.exe " + cArqExcel, 1)
    Else
        MsgStop("Erro ao gerar o arquivo Excel.", "Falha na exportação")
    EndIf

Return
