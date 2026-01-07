#include "protheus.ch"
#Include 'TopConn.ch'
/*/{Protheus.doc} CTB102EXC
description - Processo para efetuar a limpeza do flag do SF1 sempre que efetuar uma exclusão de lancamento contabil online
@type function
@version
@author LUCIANO GARCIA
@since 10/31/2025
@return variant, return_description
/*/
User function CTB102EXC()
    Local cQuery := ''

    cQuery := " SELECT "
    cQuery += " DISTINCT D1_FILIAL,D1_DOC,D1_SERIE,D1_FORNECE,D1_LOJA "
    cQuery += " FROM "+RetSqlName("CT2")+" CT2 "
    cQuery += " INNER JOIN "+RetSqlName("CV3")+" CV3 ON CV3.CV3_IDDEST = CT2.CT2_MSUIDT AND CV3.D_E_L_E_T_ <> '*' "
    cQuery += " INNER JOIN "+RetSqlName("SD1")+" SD1 ON SD1.D1_MSUIDT = CV3.CV3_IDORIG AND SD1.D_E_L_E_T_ <> '*' "
    cQuery += " WHERE "
    cQuery += " CT2_MSUIDT = '"+CT2->CT2_MSUIDT + "'"
    cQuery += " AND CT2.D_E_L_E_T_ <> '*'
    cQuery := ChangeQuery(cQuery)
    TcQuery cQuery New Alias "QRY"
    QRY->(DbGotop())
    if QRY->(!Eof())
        SF1->(DbSetOrder(1))
        if SF1->(MsSeek(QRY->D1_FILIAL+QRY->D1_DOC+QRY->D1_SERIE+QRY->D1_FORNECE+QRY->D1_LOJA))
            if !Empty(SF1->F1_DTLANC)
                Reclock("SF1",.F.)
                SF1->F1_DTLANC := CTOD('  /  /  ')
                MsUnlock()
            Endif
        Endif
    Endif
    QRY->(DbCloseArea())
Return
