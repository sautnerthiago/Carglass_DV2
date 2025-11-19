//Bibliotecas
#Include "Totvs.ch"
#Include "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RESTFUL.CH"


WSRESTFUL wsRecebe DESCRIPTION 'Ctas a Receber - FR' FORMAT APPLICATION_JSON
	//Atributos
	WSDATA cnpj       AS STRING OPTIONAL

	//Métodos
	WSMETHOD POST NEW    DESCRIPTION 'Inclusão de registro'         WSSYNTAX '/wsRecebe/new'      	PATH 'new'        		PRODUCES APPLICATION_JSON

END WSRESTFUL

WSMETHOD POST NEW WSRECEIVE WSSERVICE wsRecebe
    LOCAL oXmlManager := TXmlManager():New()
    LOCAL cXml 		  := Self:GetContent()
	LOCAL lRet 		  := .F.
	Local OResponse   := JsonObject():New()

	lOk := oXmlManager:Parse(cXml)

	//Caso ocorra erro no XML
	If lOk       
		_cBanco 		:= Alltrim(oXmlManager:XPathGetNodeValue("/infFat/cBanco"))
		_cExtPto 	    := Alltrim(oXmlManager:XPathGetNodeValue("/infFat/cExtPtoOper"))
		_xCnpjOpe 		:= Alltrim(oXmlManager:XPathGetNodeValue("/infFat/xCnpjOpe"))
		_dtEmi 			:= Alltrim(oXmlManager:XPathGetNodeValue("/infFat/dtEmi"))
		_dVencto 		:= Alltrim(oXmlManager:XPathGetNodeValue("/infFat/dVencto"))
		_cFat 			:= Alltrim(oXmlManager:XPathGetNodeValue("/infFat/cFat"))
		_cExtCli 		:= Alltrim(oXmlManager:XPathGetNodeValue("/infFat/cExtCli"))
		_cLancto 		:= Alltrim(oXmlManager:XPathGetNodeValue("/infFat/cLancto"))
		_nCntbil 		:= Alltrim(oXmlManager:XPathGetNodeValue("/infFat/nContabil"))
		_xSerie 		:= Alltrim(oXmlManager:XPathGetNodeValue("/infFat/xSerie"))
		_Observ 		:= Alltrim(oXmlManager:XPathGetNodeValue("/infFat/Observ"))
		_Senso 			:= Alltrim(oXmlManager:XPathGetNodeValue("/infFat/Senso"))
		_xTipo 			:= Alltrim(oXmlManager:XPathGetNodeValue("/infFat/xTipo"))
		_cSubGrp     	:= Alltrim(oXmlManager:XPathGetNodeValue("/infFat/cSubGrpCont"))
		_cStat 			:= Alltrim(oXmlManager:XPathGetNodeValue("/infFat/cStat"))
		_tsPagto 		:= Alltrim(oXmlManager:XPathGetNodeValue("/infFat/tsPagto"))
		_vLancto 		:= Alltrim(oXmlManager:XPathGetNodeValue("/infFat/vLancto"))
		_vValDes     	:= Alltrim(oXmlManager:XPathGetNodeValue("/infFat/vValDesconto"))

		aRetCli := PegCli(_cExtCli)
		_PREF   := "INT"
		_Natur  := ""
		aVetor:={,;
				{"E1_FILIAL"    ,XFILIAL("SE1"),NIL},;
				{"E1_PREFIXO"   ,_PREF,NIL},;
				{"E1_NUM"       ,_NUM,NIL},;
				{"E1_PARCELA"   ,"A",NIL},;
				{"E1_TIPO"      ,"FR",NIL},;
				{"E1_CLIENTE"   ,aRetCli[1,1],NIL},;
				{"E1_LOJA"      ,aRetCli[1,2],NIL},;
				{"E1_NOMCLI"    ,aRetCli[1,3],NIL},;
				{"E1_VENCTO"    ,_dVencto,NIL},;
				{"E1_VENCREA"   ,_dVencto,NIL},;
				{"E1_VALOR"     ,_vLancto,NIL},;
				{"E1_VLCRUZ"    ,_vLancto,NIL},;
				{"E1_DESCONT"   ,_vValDes,NIL},;
				{"E1_NATUREZ"   ,ALLTRIM(_Natur),NIL},;
				{"E1_HIST"      ,ALLTRIM(_Observ),NIL},;
			}   

		
		MSExecAuto({|x,y| fina040(x,y)},aVetor,3) //Inclusao

		If lMsErroAuto
			oResponse:SetStatus(400)
			//DisarmTransaction()
			//Mostraerro()
		else
			oResponse:SetStatus(200)
		Endif
	else
		oResponse:SetStatus(400)
	endif

    oXmlManager:Destroy()

Return lRet


Static Function PegCli(_cnpj)
    Local aRet    := {}
    Local cAlSA1  := GetNextAlias()

    cQuery := " SELECT A1_COD, A1_LOJA, A1_NOME"
	cQuery += " FROM "+RetSQLName("SA1") + " AS SA1 WITH (NOLOCK) "
	cQuery += " WHERE SA1.A1_CGC = '"+_cnpj+"' "
	cQuery += " AND SA1.D_E_L_E_T_ = '' AND SA1.A1_MSBLQL <> '1' "
	//cAlSA1:= CriaTrab(Nil,.F.)
	DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSA1, .F., .T.)    

    (cAlSA1)->(DbGoTop())
	If (cAlSA1)->(Eof())
		AADD(aRet,{cAlSA1->A1_COD, cAlSA1->A1_LOJA, cAlSA1->A1_NOME})
	Endif
    (cAlSA1)->(dbclosearea())

Return aRet
