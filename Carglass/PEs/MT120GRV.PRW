#include "rwmake.ch"
#include "TOPCONN.CH"

User Function MT120GRV()
    Local aArea   := GetArea()
    Local aAreaC7 := SC7->(GetArea())

    Local cNum    := PARAMIXB[1]
    Local lInclui := PARAMIXB[2]
    Local lAltera := PARAMIXB[3]
    Local lExclui := PARAMIXB[4]
    Local cAlSC7  := GetNextAlias()
    
    Local lRet    := .T. 

    IF lAltera
        cQuery := " SELECT C7_APROV "
        cQuery += " FROM "+RetSQLName("SC7") + " AS C7 WITH (NOLOCK) "
        cQuery += " WHERE C7.D_E_L_E_T_ <> '*' AND C7_NUM = '"+cNum+"' "
        DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSC7, .F., .T.)    

        cAPROV := (cAlSC7)->C7_APROV 

        (cAlSC7)->(dbclosearea())

        If EMPTY(cAPROV)
            lRet := .F.
        Endif
    Endif
    RestArea(aAreaC7)
    RestArea(aArea)

Return lRet
