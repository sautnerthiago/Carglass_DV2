#Include 'Protheus.ch'
#include "rwmake.ch"
#include "tbiconn.ch"

#Define CTRL Chr(13)+Chr(10)

User Function MYREENDEREC()
    Local aArea  := GetArea()
    Local aFili  := {'01', '02', '03', '04', '06', '08', '09', '10', '11', '12', '13', '14', '16', '17', '20' }    
    Local xX
        FOR xX := 1 TO LEN(aFili)
    	    Processa({|| REENDER(aFili[xX]) },"Aguarde REENDEREÇAMENTO das Notas - Filial:  " + aFili[xX] )
        NEXT
    RestArea(aArea)
Return

Static Function REENDER(_FIL) 

    Local cDirLog 		:= '\x_logs\'
    Local cLog    		:= ""
    Local cAlSDA        := GetNextAlias()
	
    ConOut(Repl("-",80))
    ConOut(PadC(OemToAnsi(" - REENDEREÇAMENTO - "),80))
    ConOut(Repl("-",80))

    cQuery := " SELECT * FROM SDA010 "
    cQuery += " WHERE D_E_L_E_T_ = '' "
    cQuery += " AND DA_FILIAL IN ('"+_FIL+"') "
    cQuery += " AND DA_SALDO > 0 "
    cQuery += " AND DA_LOCAL = '01' "
    DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSDA, .F., .T.) 

    WHILE !(cAlSDA)->(EOF())
        _COD        := (cAlSDA)->DA_PRODUTO
        _QUANT      := (cAlSDA)->DA_SALDO
        _LOCAL      := (cAlSDA)->DA_LOCAL
        cDoc        := (cAlSDA)->DA_DOC
        _SERIE      := (cAlSDA)->DA_SERIE
        _FORNECE    := (cAlSDA)->DA_CLIFOR
        _LOJA       := (cAlSDA)->DA_LOJA

        TMATA265(_COD, _QUANT, _LOCAL, cDoc, _SERIE, _FORNECE, _LOJA, _Fil)
        
        cLog += "REENDEREÇAMENTO REALIZADO EM NOTA: " + cDoc + ", REF. PRODUTO: " + _COD 
        cLog += CTRL

        (cAlSDA)->(DBSKIP())
        LOOP
    ENDDO
	(cAlSDA)->(DBCLOSEAREA())

    ConOut(OemToAnsi("Fim : ")+Time())

    cArqLog := _FIL+'_REEVNFS_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
    MemoWrite(cDirLog + cArqLog, cLog)

Return(.T.)

Static Function TMATA265(cProd, _QUANT, _LOCAL, _DOC, _SERIE, _CLIFOR, _LOJA, _Fil)
    Local aCab      := {}
	Local aItens    := {}
    Local aItem     := {}
    Local cAltb     := "TBL24112025"

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
    cQuery += " 	AND DA_CLIFOR = '"+_CLIFOR+"' "
    cQuery += " 	AND DA_LOJA = '"+_LOJA+"' "
    cQuery += " 	AND DA_DOC = '"+_DOC+"' "
    cQuery += " 	AND DA_PRODUTO = '"+cProd+"' "
    cQuery += " 	AND DA_LOCAL = '"+_LOCAL+"'
    DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAltb, .F., .T.)    
    //dbUseArea(.t.,"TOPCONN",tcGenQry(,,cQuery),"T01",.t.)

    cItem 	:= "0001"

    cFilAt1 := cFilAnt
    cFilAt  := _Fil

    cFilAnt := cFilAt


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
        EndIF
    ENDIF
    (cAltb)->(dbCloseArea())

Return
