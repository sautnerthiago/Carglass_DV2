#include "totvs.ch"
#include "protheus.ch"
#include "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

User Function TESTEJOB(_Fil, aCab, aItens, cOpc)
    Local aAreaIm   := GetArea()
    Local aRet      := {}
    ojb    := LIBGLASS():new()
    ConOut(OemToAnsi("INICIO DO TESTEJOB: ")+Time())
    if _Fil == "05"
        aRet := ojb:pedCompra(aCab, aItens, cOpc) 
    endif 
    ConOut(OemToAnsi("FINAL DO TESTEJOB: ")+Time())
    RestArea(aAreaIm)
Return aRet
