/*********************************************************************************************************************************
Programa    : CGSUBG01
Titulo      : CADASTRO SUBGRUPOS
Descricao   : CADASTRO SUBGRUPOS
Tipo        : Cadastro
Autor       : Edilson
Data        : 15/09/25
Tabelas     : ZZC
          
--- MANUTENÇÕES -----------------------------------------------------------------------------------------------------------------
DATA        AUTOR                       SOLICITANTE/CHAMADO  DESCRIÇÃO
 
 
**********************************************************************************************************************************/
#INCLUDE "rwmake.ch"

USER FUNCTION CGSUBG01()

    Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
    Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

	DBSELECTAREA("ZZC")
	DBSETORDER(1)
	AxCadastro("ZZC","Cadastro de Sub-Grupos",cVldExc,cVldAlt)

RETURN()
