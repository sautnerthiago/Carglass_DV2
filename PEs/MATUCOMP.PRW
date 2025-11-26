#Include "protheus.ch"
/// _________________________________________________________________________________________________
//|Quando se referir aos complementos para geracao dos registros C110, C111, C112, C113, C114 e C115|
//|  a tabela CDT também deve ser alimentada, pois ela que efetua o relacionamentos com as outras   |
//|  conforme registro. C110 = Tab. CDT, C111 = Tab. CDG, , C112 = Tab. CDC, C113 = Tab. CDD,       |
//|  C114 = Tab. CDE e C115 = Tab. CDF                                                              |
//| Este PONTO DE ENTRADA é apenas um exemplo de como pode ser utilizado, deve ser adequado conforme|
//| a regra de negócio específica do cliente                                                        | 
//|_________________________________________________________________________________________________|*/

/*/{Protheus.doc} MATUCOMP
description: Ponto de entrada para gravar de forma automatica os registros na CDG quando a Serie de saida for RPF - notas fiscais de saida
@type function
@version  
@author luciano.garcia
@since 10/29/2025
@return variant, return_description
/*/
User Function MATUCOMP()

	Local lInclui   := .F.
	Local cEntSai   := ParamIXB[1] // E=Entrada ou S=Saida
	Local cSerie    := ParamIXB[2] // Serie do documento fiscal
	Local cDoc      := ParamIXB[3] // Numero do documento
	Local cCliefor  := ParamIXB[4] // Cliente/Fornecedor
	Local cLoja     := ParamIXB[5] // Loja do Cliente/Fornecedor
	Local lDeleta   := !Inclui .AND. !Altera

	CCF->(DbSetOrder(1))
	if cEntSai == 'S' .AND. cSerie == 'RPS' //--Default para Notas fiscais de Saida - Prestação de serviço - Regra passada em 29/10/2025
		If !lDeleta

			lInclui := CDT->(!dbSeek(xFilial("CDT")+cEntSai+cDoc+cSerie+cClieFor+cLoja))

			RecLock("CDT",lInclui)
			CDT->CDT_FILIAL := xFilial("CDT")
			CDT->CDT_TPMOV  := cEntSai
			CDT->CDT_DOC    := cDoc
			CDT->CDT_SERIE  := cSerie
			CDT->CDT_CLIFOR := cClieFor
			CDT->CDT_LOJA   := cLoja
			CDT->CDT_IFCOMP := "000001"
			CDT->(MsUnLock())

			lInclui := CDG->(!dbSeek(xFilial("CDG")+cEntSai+cDoc+cSerie+cClieFor+cLoja))
			if lInclui
				if CCF->(MsSeek(xFilial('CDT')))
					While CCF->CCF_FILIAL = xFilial('CDT') .and. CCF->(!Eof())
						RecLock("CDG",lInclui)
						CDG->CDG_FILIAL := xFilial("CDT")
						CDG->CDG_TPMOV  := cEntSai
						CDG->CDG_DOC    := cDoc
						CDG->CDG_SERIE  := cSerie
						CDG->CDG_CLIFOR := cClieFor
						CDG->CDG_LOJA   := cLoja
						CDG->CDG_PROCES := CCF->CCF_NUMERO
						CDG->CDG_ITPROC := CCF->CCF_IDITEM
						CDG->CDG_TPPROC := "1"
						CDG->CDG_ITEM   := "01"
						CDG->CDG_SDOC   := "RPS"
						CDG->(MsUnLock())

						CCF->(DbSkip())
					Enddo
				endif
			endif
		Else
			If CDT->(dbSeek(xFilial("CDT")+cEntSai+cDoc+cSerie+cClieFor+cLoja))
				RecLock("CDT",.F.)
				CDT->(DbDelete())
				CDT->(MsUnLock())
			EndIf
			//-----------------------------------------------------------------
			//--Executa a exclusão para todos os itens da nota que conterem CCF
			//-----------------------------------------------------------------
			if CCF->(MsSeek(xFilial('CDT')))
				While CCF->CCF_FILIAL = xFilial('CDT') .and. CCF->(!Eof())
					If CDG->(dbSeek(xFilial("CDG")+cEntSai+cDoc+cSerie+cClieFor+cLoja))
						RecLock("CDG",.F.)
						CDG->(DbDelete())
						CDG->(MsUnLock())
					EndIf
					CCF->(DbSkip())
				Enddo
			EndIf
		EndIf
	endif
Return
