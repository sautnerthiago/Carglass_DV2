/*********************************************************************************************************************************
Programa    : CGPRD001
Titulo      : CADASTRO DE PRODUTOS DO SISTEMA LEGADO
Descricao   : CADASTRO DOS PRODUTOS ORIUNDOS DO SISTEMA ANTERIOR, PARA REFERENCIA NA PESQUISA, MANTENDO RELACIONAMENTO.
Tipo        : Cadastro
Autor       : Edilson
Data        : 22/07/25
Tabelas     : Za2
          
--- MANUTENÇÕES -----------------------------------------------------------------------------------------------------------------
DATA        AUTOR                       SOLICITANTE/CHAMADO  DESCRIÇÃO
 
 
**********************************************************************************************************************************/
#INCLUDE "rwmake.ch"

USER FUNCTION CGPRD001()

    Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
    Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

	DBSELECTAREA("ZA2")
	DBSETORDER(1)
	AxCadastro("ZA2","Cadastro de Produtos Sistema Legado",cVldExc,cVldAlt)

RETURN()
