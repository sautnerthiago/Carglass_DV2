#Include "protheus.ch"
#Include "rwmake.ch"

User Function F240FIL()
    Local cFiltro  := ""
    Local nOpc     := 0
    Local oDlg
    Local oCombo
    Local aOpcoes  := {;
        "PIX",;
        "TED",;
        "Transferencia Itau",;
        "Boleto Itau",;
        "Boleto Outros Bancos",;
        "Tributos",;
        "Afiliados PIX",;  
        "Afiliados - TED",;
        "Afiliados Transferencia Itau",;
        "Total em aberto"}
    Local cEscolha := aOpcoes[1]    
        

    // --- Tela de selesao ---
    DEFINE DIALOG oDlg TITLE "Selecione o tipo de titulo" FROM 100,100 TO 400,530 PIXEL
        @ 10,10 SAY "Tipo de titulo:" SIZE 80,10 PIXEL
        oCombo := TComboBox():New( 25,10, {|u| If(PCount()>0, cEscolha:=u, cEscolha)},aOpcoes, 200, 15, oDlg,, NIL, ,,, .T. )

        @ 50,30 BUTTON "OK" SIZE 50,13 PIXEL ACTION (nOpc := Ascan(aOpcoes, cEscolha),oDlg:End() )
        @ 50,90 BUTTON "Cancelar" SIZE 60,13 PIXEL ACTION (nOpc := 0,oDlg:End() )

    ACTIVATE DIALOG oDlg CENTERED

    Do Case
        Case nOpc == 1 // NF - PIX
            cFiltro := "E2_TIPO <> '" + PadR('TX',TamSX3("E1_TIPO")[1]) +"' .AND. Empty(E2_CODBAR)"
        Case nOpc == 2 // NF - TED 
            cFiltro := "E2_TIPO <> '" + PadR('TX',TamSX3("E1_TIPO")[1]) +"' .AND. Empty(E2_CODBAR) .AND. (E2_FORBCO <>'000' .OR. !Empty(E2_FORBCO)) .AND. (E2_FORAGE<>'0000' .OR. !Empty(E2_FORAGE)) .AND. (!Empty(E2_FCTADV) .and. E2_FORBCO <>'341')"
        Case nOpc == 3 // Transferencia Itau
            cFiltro := "E2_TIPO <> '" + PadR('TX',TamSX3("E1_TIPO")[1]) +"' .AND. Empty(E2_CODBAR) .AND. E2_FORBCO == '341'"
        Case nOpc == 4 // Boleto Itau
            cFiltro := "Left(E2_CODBAR,3) == '341'"
        Case nOpc == 5 // Boleto Outros Bancos
            cFiltro := "!Empty(E2_CODBAR) .AND. Left(E2_CODBAR,3) <> '341'"
        Case nOpc == 6 // Tributos
            cFiltro := "E2_TIPO == '" + PadR('TX',TamSX3("E1_TIPO")[1]) +"'"
        Case nOpc == 7 // Afiliados PIX
            cFiltro := "E2_TIPO <> '" + PadR('TX',TamSX3("E1_TIPO")[1]) +"' .AND. Empty(E2_CODBAR) .AND. (E2_NATUREZ='02.01.01' .OR. E2_NATUREZ='02.01.02')"
        Case nOpc == 8// Afiliados - TED
            cFiltro := "E2_TIPO <> '" + PadR('TX',TamSX3("E1_TIPO")[1]) +"' .AND. Empty(E2_CODBAR) .AND. (E2_FORBCO<>'000' .OR. !Empty(E2_FORBCO)) .AND. (E2_FORAGE<>'0000' .OR. !Empty(E2_FORAGE)) .AND. (!Empty(E2_FCTADV)) .AND. (E2_NATUREZ='02.01.01' .OR. E2_NATUREZ='02.01.02') .AND. E2_FORBCO<>'341'"
        Case nOpc == 9 // Afiliados Transferencia Itau
            cFiltro := "E2_TIPO <> '" + PadR('TX',TamSX3("E1_TIPO")[1]) +"' .AND. Empty(E2_CODBAR) .AND. E2_FORBCO == '341' .AND. (E2_NATUREZ='02.01.01' .OR. E2_NATUREZ='02.01.02')"
        Case nOpc == 10 // Total em aberto
             cFiltro := ""
    EndCase

    
Return cFiltro
