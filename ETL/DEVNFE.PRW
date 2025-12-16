#Include 'Protheus.ch'
#include "rwmake.ch"
#include "tbiconn.ch"


User Function MyMata103DEV()
    Local aArea  := GetArea()
    	Processa({|| ADEVOLUI() },"Aguarde Devolucao das Notas Saida.... " )
    	Processa({|| AEXCLUIR() },"Aguarde Exclusao das Notas Saida.... " )
		Processa({|| ADEVOLU1() },"Aguarde Devolucao das Notas Saida - COM FROTISTA E cfop 5949.... " )
		Processa({|| AEXCLU1R() },"Aguarde Exclusao das Notas Saida  - COM FROTISTA E cfop 5949.... " )
    RestArea(aArea)
Return

Static Function ADEVOLUI() //teste com ambiente atualizado....

	Local aCabec        := {}
	Local aItens        := {}
	Local aLinha        := {}
	Local cDoc          := ""

    Local aRexId  		:= PedADev(cFilAnt)
    Local cDirLog 		:= '\x_logs\'
    Local cLog    		:= ""
	Local Y, X, Z
	Local _DOCCUM		:= ""

	oWSNfs 				:= LIBGLASS():new()	
	Local aNota			:= {}
	
	PRIVATE lMsErroAuto := .F.

    FOR Z := 1 TO 5 //LEN(aRexId)
		ConOut(Repl("-",80))
		ConOut(PadC(OemToAnsi("Inclusao de NFE DEVOLUCAO COM NOTA DE ORIGEM NFS"),80))
		ConOut(Repl("-",80))

		aNotas := reTNotas(aRexId[Z,1], aRexId[Z,2]) 
		
        FOR Y := 1 TO LEN(aNotas)
			 //cDoc   := GetSXENum("SF2","F2_DOC")
			 aCabec := {}
			 aItens := {}

			 //cDoc := TemNota(cDoc)

			 aPedi  := retAped(aNotas[Y,1], aNotas[Y,2], aNotas[Y,3])
			 _Forne := aNotas[Y,4]
			 _loja  := aNotas[Y,5]
			 FOR X := 1 TO LEN(aPedi)

				_DOCCUM		:= aPedi[X,01]
				_SERIE		:= aPedi[X,02]
				_FORNECE	:= aPedi[X,03]
				_LOJA		:= aPedi[X,04]
				_EMISSAO	:= StoD(aPedi[X,06])
				
				nItem		:= aPedi[X,08] 
				_COD		:= aPedi[X,09]
				_QUANT		:= aPedi[X,10]
				_VUNIT		:= aPedi[X,11]
				_TOTAL		:= aPedi[X,12]
				_TES		:= aPedi[X,13]
				_CF			:= aPedi[X,14]
				_IDENTB6	:= aPedi[X,15]
				_Pedi       := aPedi[X,16]
				_CHVNFE     := aPedi[X,17]

				SB1->(DbSetOrder(1))
				SB1->(MsSeek(Xfilial("SB1")+_COD))    //FILIAL+PRODUTO
				lServic := (SB1->B1_TIPO == "SV")  //07/11/2025 - VERIFICA SE O TIPO DEO PRODUTO É SERVIÇO
				
				if X == 1
					aadd(aCabec,{"F1_TIPO"      ,"D"        })
					aadd(aCabec,{"F1_FORMUL"    ,"S"        })
					// aadd(aCabec,{"F1_DOC"       ,cDoc       })
					aadd(aCabec,{"F1_SERIE"     ,_SERIE     })
					aadd(aCabec,{"F1_EMISSAO"   ,_EMISSAO   })
					aadd(aCabec,{"F1_FORNECE"   ,_FORNECE   })
					aadd(aCabec,{"F1_LOJA"      ,_LOJA      })
					aadd(aCabec,{"F1_ESPECIE"   ,"SPED"     })
					// aadd(aCabec,{"F1_CHVNFE"    ,_CHVNFE    })

					aLinha := {}
				endif

				aadd(aLinha,{"D1_ITEM"      , nItem     ,Nil})
				aadd(aLinha,{"D1_COD"       , _COD      ,Nil})
				aadd(aLinha,{"D1_QUANT"     , _QUANT    ,Nil})
				aadd(aLinha,{"D1_VUNIT"     , _VUNIT    ,Nil})
				aadd(aLinha,{"D1_TOTAL"     , _TOTAL    ,Nil})
				aadd(aLinha,{"D1_TES"       , "038"     ,Nil}) //TES DEVOLUÇÃO - PASSADO POR LUCIANA 10/12/2025 16:57
				aAdd(aLinha,{"D1_CF"        , "1949"    ,Nil}) 
				// aAdd(aLinha,{"D1_DOC"       , cDoc      ,Nil}) // *
				aAdd(aLinha,{"D1_SERIE"     , _SERIE    ,Nil}) // *
				aAdd(aLinha,{"D1_EMISSAO"   , _EMISSAO  ,Nil}) // ADICIONEI
				aadd(aLinha,{"D1_NFORI"     , _DOCCUM   ,Nil}) // nota de origem
				aadd(aLinha,{"D1_SERIORI"   , _SERIE    ,Nil})
				aadd(aLinha,{"D1_ITEMORI"   , nItem     ,Nil})
				AAdd(aLinha,{"D1_IDENTB6"   , _IDENTB6  ,Nil}) // d2_numseq
				aadd(aLinha,{"AUTDELETA"    , "N"       ,Nil})
				aadd(aItens,aLinha)
			NEXT
			if !EMPTY(_DOCCUM)
				MSExecAuto({|x,y,z| mata103(x,y,z)},aCabec,aItens,3)
				cDoc 	:= SF1->F1_DOC
				_SERIE	:= SF1->F1_SERIE
				AADD(aNota, { PadR(Alltrim(cDoc), TamSx3('F2_DOC')[1]), PadR(Alltrim(_SERIE), TamSx3('F2_SERIE')[1]) })
				
				If !lMsErroAuto
					IF lServic
							cRetorno := SpedNFeTrf("SF1",;
								_SERIE/*cSerie*/,;
								cDoc/*cNotaIni*/,;
								cDoc/*cNotaFim*/,;
								cIdEnt,;
								cAmbiente,;
								cModalidade,;
								cVersao,;
								@lEnd,;
								.F./*lCte*/,;
								.T.)      
							SpedNFe6Mnt( _SERIE/*cSerie*/,cDoc/*cNotaIni*/,cDoc/*cNotaFim*/,.T. /*lCTe*/) //não transmitir de primeiro
							ConOut("Incluido com sucesso! "+cDoc)
							cLog += 'DEVOLUCAO REALIZADA COM SUCESSO - ' + cDoc + " - " + _SERIE
							ConfirmSX8()
					ELSE
						cFilNF  := Xfilial("SF1")
						cMensa  := TransNfe(cDoc, _SERIE)
						Conout("Transmissao da nota: " + cDoc + " - " + cMensa + "  , gerado com sucesso!!!")
						aMonit  := MonitNf(aNota) 

						//Distribuição
						if aMonit[1]
							_LOCAL := POSICIONE('SB1',1,Xfilial('SB1')+_COD,'B1_LOCPAD') 
							TMATA265(_COD, _QUANT, _LOCAL, cDoc, _SERIE, _FORNECE, _LOJA)
						EndiF
						ConfirmSX8()
					EndIf
				Else
					ConOut("Erro na inclusao!")
					cLog += 'EXCLUSÃO NAO REALIZADA - ' + cDoc + CRLF
					mostraerro()
				EndIf
				ConOut(OemToAnsi("Fim : ")+Time())
			EndIf
		Next

	Next
    cArqLog := 'DEVONFS_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
    MemoWrite(cDirLog + cArqLog, cLog)

Return(.T.)

Static Function PedADev(_Fil)
    Local aRet   := {}
    Local cAlSC5 := GetNextAlias()

    cQuery := " SELECT COUNT(D2_DOC) AS QTD, D2_PEDIDO, D2_EMISSAO, D2_FILIAL FROM SD2010 D2 "
    cQuery += " INNER JOIN SC5010 C5 ON C5_NUM = D2_PEDIDO AND C5_FILIAL = D2_FILIAL "
    cQuery += " WHERE C5.D_E_L_E_T_ = '' AND D2.D_E_L_E_T_ = '' AND D2_FILIAL = '"+_Fil+"' "
    cQuery += " AND D2_FILIAL NOT IN ('15', '01', '10') "
    cQuery += " AND D2_EMISSAO > '20251201' AND D2_CLIENTE NOT IN ('0050539327', '0051278112', '0050635124', '0050783270', '0050630011', '0001634036', '0050604254', '0001963653') "    
    cQuery += " GROUP BY D2_PEDIDO, D2_EMISSAO, D2_FILIAL "
    cQuery += " HAVING COUNT(*) > 1 "
    cQuery += " ORDER BY D2_FILIAL, D2_EMISSAO, D2_PEDIDO "
    DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSC5, .F., .T.) 

    WHILE !(cAlSC5)->(EOF())
        AADD(aRet, { (cAlSC5)->D2_PEDIDO, (cAlSC5)->D2_FILIAL} )
        (cAlSC5)->(DBSKIP())
        LOOP
    ENDDO
    (cAlSC5)->(DBCLOSEAREA())   
   
Return aRet

Static Function ADEVOLU1() //teste com ambiente atualizado....

	Local aCabec        := {}
	Local aItens        := {}
	Local aLinha        := {}
	Local cDoc          := ""

    Local aRexId  		:= PedADev1(cFilAnt)
    Local cDirLog 		:= '\x_logs\'
    Local cLog    		:= ""
	Local Y, X, Z
	Local _DOCCUM		:= ""

	oWSNfs 				:= LIBGLASS():new()	
	Local aNota			:= {}
	
	PRIVATE lMsErroAuto := .F.

    FOR Z := 1 TO 5 //LEN(aRexId)
		ConOut(Repl("-",80))
		ConOut(PadC(OemToAnsi("Inclusao de NFE DEVOLUCAO COM NOTA DE ORIGEM NFS"),80))
		ConOut(Repl("-",80))

		aNotas := reTNotas(aRexId[Z,1], aRexId[Z,2]) 
		
        FOR Y := 1 TO LEN(aNotas)
			 //cDoc   := GetSXENum("SF2","F2_DOC")
			 aCabec := {}
			 aItens := {}

			 //cDoc := TemNota(cDoc)

			 aPedi  := retAped(aNotas[Y,1], aNotas[Y,2], aNotas[Y,3])
			 _Forne := aNotas[Y,4]
			 _loja  := aNotas[Y,5]
			 FOR X := 1 TO LEN(aPedi)

				_DOCCUM		:= aPedi[X,01]
				_SERIE		:= aPedi[X,02]
				_FORNECE	:= aPedi[X,03]
				_LOJA		:= aPedi[X,04]
				_EMISSAO	:= StoD(aPedi[X,06])
				
				nItem		:= aPedi[X,08] 
				_COD		:= aPedi[X,09]
				_QUANT		:= aPedi[X,10]
				_VUNIT		:= aPedi[X,11]
				_TOTAL		:= aPedi[X,12]
				_TES		:= aPedi[X,13]
				_CF			:= aPedi[X,14]
				_IDENTB6	:= aPedi[X,15]
				_Pedi       := aPedi[X,16]
				_CHVNFE     := aPedi[X,17]

				SB1->(DbSetOrder(1))
				SB1->(MsSeek(Xfilial("SB1")+_COD))    //FILIAL+PRODUTO
				lServic := (SB1->B1_TIPO == "SV")  //07/11/2025 - VERIFICA SE O TIPO DEO PRODUTO É SERVIÇO
				
				if X == 1
					aadd(aCabec,{"F1_TIPO"      ,"D"        })
					aadd(aCabec,{"F1_FORMUL"    ,"S"        })
					// aadd(aCabec,{"F1_DOC"       ,cDoc       })
					aadd(aCabec,{"F1_SERIE"     ,_SERIE     })
					aadd(aCabec,{"F1_EMISSAO"   ,_EMISSAO   })
					aadd(aCabec,{"F1_FORNECE"   ,_FORNECE   })
					aadd(aCabec,{"F1_LOJA"      ,_LOJA      })
					aadd(aCabec,{"F1_ESPECIE"   ,"SPED"     })
					aadd(aCabec,{"F1_CHVNFE"    ,_CHVNFE    })

					aLinha := {}
				endif

				aadd(aLinha,{"D1_ITEM"      , nItem     ,Nil})
				aadd(aLinha,{"D1_COD"       , _COD      ,Nil})
				aadd(aLinha,{"D1_QUANT"     , _QUANT    ,Nil})
				aadd(aLinha,{"D1_VUNIT"     , _VUNIT    ,Nil})
				aadd(aLinha,{"D1_TOTAL"     , _TOTAL    ,Nil})
				aadd(aLinha,{"D1_TES"       , "038"     ,Nil}) //TES DEVOLUÇÃO - PASSADO POR LUCIANA 10/12/2025 16:57
				aAdd(aLinha,{"D1_CF"        , "1949"    ,Nil}) 
				// aAdd(aLinha,{"D1_DOC"       , cDoc      ,Nil}) // *
				aAdd(aLinha,{"D1_SERIE"     , _SERIE    ,Nil}) // *
				aAdd(aLinha,{"D1_EMISSAO"   , _EMISSAO  ,Nil}) // ADICIONEI
				aadd(aLinha,{"D1_NFORI"     , _DOCCUM   ,Nil}) // nota de origem
				aadd(aLinha,{"D1_SERIORI"   , _SERIE    ,Nil})
				aadd(aLinha,{"D1_ITEMORI"   , nItem     ,Nil})
				AAdd(aLinha,{"D1_IDENTB6"   , _IDENTB6  ,Nil}) // d2_numseq
				aadd(aLinha,{"AUTDELETA"    , "N"       ,Nil})
				aadd(aItens,aLinha)
			NEXT
			if !EMPTY(_DOCCUM)
				MSExecAuto({|x,y,z| mata103(x,y,z)},aCabec,aItens,3)
				cDoc 	:= SF1->F1_DOC
				_SERIE	:= SF1->F1_SERIE
				AADD(aNota, { PadR(Alltrim(cDoc), TamSx3('F2_DOC')[1]), PadR(Alltrim(_SERIE), TamSx3('F2_SERIE')[1]) })
				
				If !lMsErroAuto
					IF lServic
							cRetorno := SpedNFeTrf("SF2",;
								_SERIE/*cSerie*/,;
								cDoc/*cNotaIni*/,;
								cDoc/*cNotaFim*/,;
								cIdEnt,;
								cAmbiente,;
								cModalidade,;
								cVersao,;
								@lEnd,;
								.F./*lCte*/,;
								.T.)      
							SpedNFe6Mnt( _SERIE/*cSerie*/,cDoc/*cNotaIni*/,cDoc/*cNotaFim*/,.T. /*lCTe*/) //não transmitir de primeiro
							ConOut("Incluido com sucesso! "+cDoc)
							cLog += 'DEVOLUCAO REALIZADA COM SUCESSO - ' + cDoc + " - " + _SERIE
							ConfirmSX8()
					ELSE
						cFilNF  := Xfilial("SF2")
						cMensa  := TransNfe(cDoc, _SERIE)
						Conout("Transmissao da nota: " + cDoc + " - " + cMensa + "  , gerado com sucesso!!!")
						aMonit  := MonitNf(aNota) 

						//Distribuição
						if aMonit[1]
							_LOCAL := POSICIONE('SB1',1,Xfilial('SB1')+_COD,'B1_LOCPAD') 
							TMATA265(_COD, _QUANT, _LOCAL, cDoc, _SERIE, _FORNECE, _LOJA)
						EndiF
						ConfirmSX8()
					EndIf
				Else
					ConOut("Erro na inclusao!")
					cLog += 'EXCLUSÃO NAO REALIZADA - ' + cDoc + CRLF
					mostraerro()
				EndIf
				ConOut(OemToAnsi("Fim : ")+Time())
			EndIf
		Next
	Next
    cArqLog := 'DEVONFS_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
    MemoWrite(cDirLog + cArqLog, cLog)

Return(.T.)


Static Function PedADev1(_Fil)
    Local aRet   := {}
    Local cAlSC5 := GetNextAlias()

    cQuery := " SELECT COUNT(D2_DOC) AS QTD, D2_PEDIDO, D2_EMISSAO, D2_FILIAL FROM SD2010 D2 "
    cQuery += " INNER JOIN SC5010 C5 ON C5_NUM = D2_PEDIDO AND C5_FILIAL = D2_FILIAL "
    cQuery += " WHERE C5.D_E_L_E_T_ = '' AND D2.D_E_L_E_T_ = '' AND D2_FILIAL = '"+_Fil+"'  "
    cQuery += " AND D2_FILIAL NOT IN ('15', '01', '10') "
    cQuery += " AND D2_EMISSAO > '20251201' AND D2_CF = '5949' "    
    cQuery += " GROUP BY D2_PEDIDO, D2_EMISSAO, D2_FILIAL "
    cQuery += " HAVING COUNT(*) > 1 "
    cQuery += " ORDER BY D2_FILIAL, D2_EMISSAO, D2_PEDIDO "
    DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSC5, .F., .T.) 

    WHILE !(cAlSC5)->(EOF())
        AADD(aRet, { (cAlSC5)->D2_PEDIDO, (cAlSC5)->D2_FILIAL} )
        (cAlSC5)->(DBSKIP())
        LOOP
    ENDDO
    (cAlSC5)->(DBCLOSEAREA())          
    
Return aRet

Static Function retAped(cPedi, cFil, cNota)
    local aRet 	 := {}
    Local cAlSC5 := GetNextAlias()
	Local aDadFr := {}
	Local aClien := {}
	Local xX

	Local cForne   := ""
	Local cLoja    := ""
	Local aExtFor  := {}

    cQuery := " SELECT *, D2.R_E_C_N_O_ RECNO, F2_CHVNFE "
    cQuery += " FROM SD2010 D2 "
    cQuery += " INNER JOIN SF2010 F2 ON D2_DOC = F2_DOC AND D2_FILIAL = F2_FILIAL "
    cQuery += " WHERE D2.D_E_L_E_T_ = '' AND D2_PEDIDO = '"+cPedi+"' AND D2_FILIAL = '"+cFil+"' AND D2_DOC = '"+cNota+"' AND F2_DAUTNFE <> '' "
    DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSC5, .F., .T.) 

    WHILE !(cAlSC5)->(EOF())
		aExtFor := VldForn( (cAlSC5)->D2_CLIENTE, (cAlSC5)->D2_LOJA )
		IF !aExtFor[1,1]
			aDadFr := DadsForn((cAlSC5)->D2_CLIENTE, (cAlSC5)->D2_LOJA)
			aClien := GrvForn(aDadFr)
			if len(aClien) > 0
				FOR xX := 1 To Len(aClien)
					cForne   	:= aClien[xX,1]
					cLoja      	:= aClien[xX,2]
				NEXT
			else
				Return aRet
			endif
		Else			
			cForne   	:= aExtFor[1,2]
			cLoja      	:= aExtFor[1,3]
		endif

		cForne   	:= (cAlSC5)->D2_CLIENTE
		cLoja      	:= (cAlSC5)->D2_LOJA
        cDocumento 	:= (cAlSC5)->D2_DOC
        cSerie     	:= (cAlSC5)->D2_SERIE
        cFil       	:= (cAlSC5)->D2_FILIAL
        dEmiss     	:= (cAlSC5)->D2_EMISSAO
        nRecN      	:= (cAlSC5)->RECNO
		nItem	   	:= (cAlSC5)->D2_ITEM

		_COD		:= (cAlSC5)->D2_COD
		_QUANT		:= (cAlSC5)->D2_QUANT
		_VUNIT		:= (cAlSC5)->D2_PRCVEN
		_TOTAL		:= (cAlSC5)->D2_TOTAL
		_TES		:= (cAlSC5)->D2_TES
		_CF			:= (cAlSC5)->D2_CF
		_IDENTB6	:= (cAlSC5)->D2_IDENTB6
		_Pedido     := (cAlSC5)->D2_PEDIDO
		_Chavnf     := (cAlSC5)->F2_CHVNFE

		IF TemEntrd(cDocumento, cSerie, cForne, cLoja, cFil)
	        AADD(aRet, {cDocumento, cSerie, cForne, cLoja, cFil, dEmiss, nRecN, nItem, _COD,_QUANT,_VUNIT,_TOTAL,_TES,_CF,_IDENTB6, _Pedido, _Chavnf})
		endif
        (cAlSC5)->(DBSKIP())
        LOOP
    ENDDO
    (cAlSC5)->(DBCLOSEAREA())
    
Return aRet

Static Function GrvForn(aDadFr)
	Local aRet := {}
	Local xY
	Local aLogAuto := {}
	Local nLinha
	Local cErrorLog := ""

	//Pegando o modelo de dados, setando a operação de inclusão
	oModel := FWLoadModel("MATA020M")
	oModel:SetOperation(3)
	oModel:Activate()

	For xY := 1 To Len(aDadFr)
		cCodi := GetSXENum("SA2","A2_COD")
		cLoja := aDadFr[xY, 01]

		//Pegando o model dos campos da SA2
		//oSA2Mod:= oModel:getModel("SA2MASTER")
		oModel:setValue('SA2MASTER', "A2_FILIAL"  , FWCodFil()          )
		oModel:setValue('SA2MASTER', "A2_COD"     , cCodi   			)
		oModel:setValue('SA2MASTER', "A2_LOJA"    , aDadFr[xY, 01] 		)
		oModel:setValue('SA2MASTER', "A2_NOME"    , Alltrim(aDadFr[xY, 02]) )
		oModel:setValue('SA2MASTER', "A2_NREDUZ"  , Alltrim(aDadFr[xY, 03]) )
		oModel:setValue('SA2MASTER', "A2_BAIRRO"  , aDadFr[xY, 04] 	    )
		oModel:setValue('SA2MASTER', "A2_EMAIL"   , aDadFr[xY, 05]      )
		oModel:setValue('SA2MASTER', "A2_CEP"     , aDadFr[xY, 06]      )
		oModel:setValue('SA2MASTER', "A2_CGC"     , aDadFr[xY, 07]      )
		oModel:setValue('SA2MASTER', "A2_EST"     , aDadFr[xY, 08]      )
		oModel:setValue('SA2MASTER', "A2_COD_MUN" , aDadFr[xY, 09]      )
		oModel:setValue('SA2MASTER', "A2_DDD"     , aDadFr[xY, 10]      )
		oModel:setValue('SA2MASTER', "A2_END"     , aDadFr[xY, 11] 		)
		oModel:setValue('SA2MASTER', "A2_INSCR"   , aDadFr[xY, 12] 		)    
		oModel:setValue('SA2MASTER', "A2_MUN"     , aDadFr[xY, 13] 		)
		oModel:setValue('SA2MASTER', "A2_TIPO"    , aDadFr[xY, 14] 	    )
		oModel:setValue('SA2MASTER', "A2_TEL"     , aDadFr[xY, 15]      )
		oModel:setValue('SA2MASTER', "A2_PAIS"    , '105'  			    )
		oModel:setValue('SA2MASTER', "A2_MSBLQL"  , aDadFr[xY, 24]  	)
		oModel:setValue('SA2MASTER', "A2_ZATIVO"  , aDadFr[xY, 25] 		)
		oModel:setValue('SA2MASTER', "A2_INDRUR"  , '0'					) //08/09/2025 - INDICAÇÃO TOTVS - CONSIDERADO OU NÃO O CPF
		oModel:setValue('SA2MASTER', "A2_CONTA"   , '21111001'			) //06/11/2025 - DEFINIÇÃO DE FIXO POR MARCOS PINTO - CONTA INFORMADA POR LUCIANA
		oModel:setValue('SA2MASTER', "A2_CODPAIS" , '01058'				) //02/12/2025 - SOLICITAÇÃO VICTOR / TANIA
	Next

	//Se conseguir validar as informações
	If oModel:VldData()
		//Tenta realizar o Commit
		If oModel:CommitData()
			lDeuCerto := .T.
			AADD(aRet, {cCodi, cLoja})
			//Se não deu certo, altera a variável para false
		Else
			lDeuCerto := .F.
			aLogAuto    := oModel:GetErrorMessage()
			For nLinha := 1 To Len(aLogAuto)
				IF VALTYPE(aLogAuto[nLinha]) == "C"
					cErrorLog += aLogAuto[nLinha] + CRLF
				ENDIF
			Next nLinha
		EndIf
		//Se não conseguir validar as informações, altera a variável para false
	Else
		lDeuCerto := .F.
		aLogAuto    := oModel:GetErrorMessage()
		For nLinha := 1 To Len(aLogAuto)
			IF VALTYPE(aLogAuto[nLinha]) == "C"
				cErrorLog += aLogAuto[nLinha] + CRLF
			ENDIF
		Next nLinha
	EndIf
Return aRet

Static Function VldForn(cCodig, cLoja)
	Local aRet := {}
	Local cCGC := Posicione("SA1",1,xFilial("SA1")+cCodig+cLoja, "A1_CGC")

    cQuery := " SELECT * FROM SA2010 A2 "
    cQuery += " WHERE A2.D_E_L_E_T_ = '' AND A2_CGC = '"+cCGC+"' "
    DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),"TMPSA2", .F., .T.) 

	IF !EMPTY(TMPSA2->A2_COD)
		AADD(aRet, {.T., TMPSA2->A2_COD, TMPSA2->A2_LOJA})
	ELSE
		AADD(aRet, {.F., "", ""})
	ENDIF
	TMPSA2->(DBCLOSEAREA())

Return aRet

Static Function DadsForn(cCodig, cLoja)
	Local aRet := {}
    Local cAlSC5   := GetNextAlias()

    cQuery := " SELECT * FROM SA1010  "
    cQuery += " WHERE D_E_L_E_T_ = '' AND A1_COD = '"+cCodig+"' AND A1_LOJA = '"+cLoja+"' "
    DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSC5, .F., .T.) 

    WHILE !(cAlSC5)->(EOF())
        AADD(aRet, { 	(cAlSC5)->A1_LOJA	, (cAlSC5)->A1_NOME		, (cAlSC5)->A1_NREDUZ	, (cAlSC5)->A1_BAIRRO	,;
						(cAlSC5)->A1_EMAIL	, (cAlSC5)->A1_CEP		, (cAlSC5)->A1_CGC		, (cAlSC5)->A1_EST		, (cAlSC5)->A1_COD_MUN,;
						(cAlSC5)->A1_DDD	, (cAlSC5)->A1_END		, (cAlSC5)->A1_INSCR	, (cAlSC5)->A1_MUN		, (cAlSC5)->A1_TIPO,;
						(cAlSC5)->A1_TEL	, (cAlSC5)->A1_PAIS		, (cAlSC5)->A1_ZINTEGR	, (cAlSC5)->A1_ZMOBILE	, (cAlSC5)->A1_ZTPVEIC,; 
						(cAlSC5)->A1_ZPGTADT, (cAlSC5)->A1_ZREVAFI	, (cAlSC5)->A1_ZAFICON	, (cAlSC5)->A1_ZTPAFIL	, (cAlSC5)->A1_MSBLQL,;
						(cAlSC5)->A1_ZATIVO	} )
        (cAlSC5)->(DBSKIP())
        LOOP
    ENDDO
    (cAlSC5)->(DBCLOSEAREA())    		

Return aRet

Static Function reTNotas(cPedi, cFil)
    local aRet 	 := {}
    Local cAlSC5 := GetNextAlias()
	Local aDadFr := {}
	Local aClien := {}
	Local xX

	Local cForne := ""
	Local cLoja  := ""

	Local aExtFor:= {}

    cQuery := " SELECT *, D2.R_E_C_N_O_ RECNO, F2_CHVNFE "
    cQuery += " FROM SD2010 D2 "
    cQuery += " INNER JOIN SF2010 F2 ON D2_DOC = F2_DOC AND D2_FILIAL = F2_FILIAL "
    cQuery += " WHERE D2.D_E_L_E_T_ = '' AND D2_PEDIDO = '"+cPedi+"' AND D2_FILIAL = '"+cFil+"' AND F2_DAUTNFE <> '' "
    DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSC5, .F., .T.) 

    WHILE !(cAlSC5)->(EOF())
		aExtFor := VldForn( (cAlSC5)->D2_CLIENTE, (cAlSC5)->D2_LOJA )
		IF !aExtFor[1,1]
			aDadFr := DadsForn((cAlSC5)->D2_CLIENTE, (cAlSC5)->D2_LOJA)
			aClien := GrvForn(aDadFr)
			if len(aClien) > 0
				FOR xX := 1 To Len(aClien)
					cForne   	:= aClien[xX,1]
					cLoja      	:= aClien[xX,2]
				NEXT
			else
				Return aRet
			endif
		ELSE
			cForne   	:= aExtFor[1,2]
			cLoja      	:= aExtFor[1,3]
		endif

        cDocumento 	:= (cAlSC5)->D2_DOC
		_Pedido     := (cAlSC5)->D2_PEDIDO

        AADD(aRet, {_Pedido, cFil, cDocumento, cForne, cLoja })
        (cAlSC5)->(DBSKIP())
        LOOP
    ENDDO
    (cAlSC5)->(DBCLOSEAREA())
    
Return aRet

Static Function ExitForn(_CGCCPF)
	Local aRet := {}
    Local cAlSA2 := GetNextAlias()

    cQuery := " SELECT * "
    cQuery += " FROM "+RetSQLName("SA2") + " WITH (NOLOCK) "
    cQuery += " WHERE D_E_L_E_T_ = '' AND A2_CGC = '"+_CGCCPF+"' "
    DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSA2, .F., .T.) 

    IF !EMPTY( (cAlSA2)->(A2_COD) )
		AAdd(aRet, {.T., (cAlSA2)->(A2_COD), (cAlSA2)->(A2_LOJA)} )
	ELSE
		AAdd(aRet, {.F., "", ""} )
	ENDIF
	(cAlSA2)->(DBCLOSEAREA())

Return aRet

Static Function TemNota(_Doc)
	Local cRet := _Doc
    Local cAlF1 := GetNextAlias()

    cQuery := " SELECT F2_DOC "
    cQuery += " FROM "+RetSQLName("SF2") + " WITH (NOLOCK) "
    cQuery += " WHERE D_E_L_E_T_ = '' AND F2_DOC = '"+_Doc+"' AND F2_SERIE = '001' "
    DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlF1, .F., .T.) 

    IF !EMPTY( (cAlF1)->(F2_DOC) )
		ConfirmSX8()
		cRet := GetSXENum("SF2","F2_DOC")
	ENDIF
	(cAlF1)->(DBCLOSEAREA())

RETURN cRet 

Static Function TemEntrd(cDocumento, cSerie, cForne, cLoja, cFil)
	Local lRet := .F.
    Local cAlF1 := GetNextAlias()

    cQuery := " SELECT D1_DOC "
    cQuery += " FROM "+RetSQLName("SD1") + " WITH (NOLOCK) "
    cQuery += " WHERE D_E_L_E_T_ = '' AND D1_NFORI = '"+cDocumento+"' AND D1_SERIORI = '"+cSerie+"' "
    DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlF1, .F., .T.) 

    IF EMPTY( (cAlF1)->(D1_DOC) )
		lRet := .T.
	ENDIF
	(cAlF1)->(DBCLOSEAREA())

Return lRet

Static Function TransNfe(cDocumento, cSerie)
	Local aArea          := FWGetArea()
	//Transmissão e Monitoramento
	Local cModelo        := "55"
	Local cIdEnt         := ""
	Local cError         := ""
	//Transmissão
	Local cAmbiente      := ""
	Local cModalidade    := ""
	Local cVersao        := ""
	Local lCte           := .F. //( cModelo == "57" )
	Local lEnd           := .F.
	//Monitoramento
	Local nVezes         := 0
	Local cURL           := PadR(GetNewPar("MV_SPEDURL", "http://"), 250)
	Local aParam         := {}
	Local nTpMonitor     := 1
	Local aRetMonit      := {}
	//Retorno da Função
	Local lDeuCerto      := .F.
	Local cMensagem      := ""
	Local aRetorno       := {.F., ""}
    Local cRet           := ""
	Local lAcho          := .F.

	Dbselectarea('SF1')
	SF1->(DbSetOrder(1)) // F2_FILIAL + F2_DOC + F2_SERIE + F2_CLIENTE + F2_LOJA + F2_FORMUL + F2_TIPO
	lAcho := SF1->(MsSeek(FWxFilial('SF1') + cDocumento + cSerie))
	If lAcho .And. Empty(SF1->F1_CHVNFE)
		cIdEnt := getCfgEntidade(@cError)
		//Se encontrou a entidade
		If ! Empty( cIdEnt )
			//Busca o ambiente, modalidade e versão
			cAmbiente := getCfgAmbiente(@cError, cIdEnt, cModelo)
			If ! Empty(cAmbiente)
				cModalidade := getCfgModalidade(@cError, cIdEnt, cModelo)
				If ! Empty(cModalidade)
					cVersao    := getCfgVersao(@cError, cIdEnt, cModelo)
				EndIf
			EndIf

			//Se conseguiu buscar as informações
			If ! Empty(cVersao)
				//Aciona a transmissão da Nota para o Sefaz
				cRetorno := SpedNFeTrf(;
					"SF1",;     //cAlias
				cSERIE,; 		//cSerie
				cDocumento,;   	//cNotaIni
				cDocumento,;   	//cNotaFim
				cIdEnt,;        //cIDEnt
				cAmbiente,;     //cAmbiente
				cModalidade,;   //cModalidade
				cVersao,;       //cVersao
				@lEnd,;         //lEnd
				lCte,;          //lCte
				.T.,;           //lAuto
				Nil,;           //dDataDe
				Nil;            //dDataAte
				)

				//Se tiver a mensagem de sucesso, tenta acionar o monitoramento
				If "SUCESSO" $ Upper(cRetorno)
					//Monta o array de parâmetros para monitorar
					aParam    := Array(5)
					aParam[1] := SF1->F1_SERIE
					aParam[2] := SF1->F1_DOC
					aParam[3] := SF1->F1_DOC
					aParam[4] := MonthSub(SF1->F1_EMISSAO, 1)
					aParam[5] := MonthSum(SF1->F1_EMISSAO, 1)
					//Tenta monitorar 3 vezes
					While nVezes < 3
						aRetMonit := procMonitorDoc(;
						cIdent,;          //cIdEnt
						cUrl,;            //cUrl
						aParam,;          //aParam
						nTpMonitor,;      //nTpMonitor (1=Range de Notas; 2=Lote de Id;3=Tempo)
						"0" + cModelo,;   //cModelo
						lCte,;            //lCte
						@cError;          //cAviso
						)

						//Se teve retorno o monitoramento
						If Len(aRetMonit) > 0

							//Se começar com 001, deu certo o monitoramento
							If Left(Alltrim(aRetMonit[1][9]), 3) == '001'
								lDeuCerto := .T.
								cMensagem := "Sucesso na transmissão e monitoramento da Nota!"
								Exit
							EndIf
						EndIf

						//Aguarda 3 segundos antes da próxima tentativa
						Sleep(3000)
						nVezes++
					EndDo

					//Se mesmo ao acionar o monitoramento, não der certo, atualiza a variável de retorno
					If ! lDeuCerto
						cMensagem := "Falha ao tentar acionar o monitoramento! " + cError
					EndIf

				Else
					cMensagem := "Falha na transmissão da Nota! " + cRetorno
				EndIf
			Else
				cMensagem := "Falha ao buscar informações (Ambiente, Modalidade e Versão)! " + cError
			EndIf

		Else
			cMensagem := "Falha ao buscar o IdEnt da Empresa! " + cError
		EndIf
	Else
		cMensagem := "Nota e Série não encontradas na SF2!"
	EndIf

	//Define o retorno
	aRetorno[1] := lDeuCerto
	aRetorno[2] := cMensagem
    cRet        := cMensagem
	FWRestArea(aArea)
	
Return cRet

Static Function MonitNf(aNotas)
    Local lOk := {.F., ''}
    Local cLockFile   as character
    Local cProcesso   as character
    Local aNFDeAte    as array
    Local aMonDocs    as array
    Local aInfMonNFe  as array
    Local cCodEmp     as character
    Local cCodFil     as character
    Local cIDEnt      as character
    Local cURL        as character
    Local cModelo     as character
    Local cSerie      as character
    Local cAviso      as character
    Local nI          as numeric
    Local nTentantiva as numeric
 
    cLockFile   := ""
    cProcesso   := "Transmissão"
    aNFDeAte    := {}
    aadd(aNFDeAte, {"", "", aNotas[1,1]}) // nota inicial
    aadd(aNFDeAte, {"", "", aNotas[1,1]}) // nota final
    aMonDocs    := {aNotas[1,2], aNotas[1,1], aNotas[1,1]} // serie, nota inicial, nota final
    aInfMonNFe  := {}
    cCodEmp     := cEmpAnt
    cCodFil     := cFilAnt
    cIDEnt      := RetIdEnti()
    cURL        := SuperGetMV("MV_SPEDURL",.F.,"") // precisa existir
    cModelo     := "55" // NFe
    cSerie      := aNotas[1,2]
    cAviso      := ""
    nTentantiva := SuperGetMv("MV_XOFIMON",,5)
 
    transmiteAutoNFE(;
        cLockFile,; // lock de registros
        cProcesso,;     // descrição do processo
        aNFDeAte,;      // array com a nota inicial e nota final
        cCodEmp,;       // código da empresa que esta fazendo a transmissão
        cCodFil,;       // código da filial que esta fazendo a transmissão
        cIDEnt,;        // identificador da entidade que está transmitindo
        cURL,;          // URL da NFE SEFAZ
        cModelo,;       // modelo dos documentos
        cSerie;         // série dos documentos
    )
 
    Sleep(1000)
    CONOUT("Monitorando Notas Transmitidas...")
 
    For nI := 1 To nTentantiva
 
        CONOUT("Monitorando... Tentativa: " + cValToChar(nI) + " de " + cValToChar(nTentantiva))
 
        aInfMonNFe := procMonitorDoc(;
            cIdEnt,;      // identificador da entidade que está transmitindo
            cUrl,;        // URL da NFE SEFAZ
            aMonDocs,;    // array com a nota a ser monitorada
            1,;           // tipo de monitoramento - usar por faixa de notas
            cModelo,;     // modelo dos documentos
            .F.,;         // usado para CTE
            @cAviso)      // mensagem de retorno quando tiver erro no WS
 
        If !Empty(cAviso)
            CONOUT(cAviso,"TOTVS")
            Exit
        ElseIf !Empty(aInfMonNFe) .And. !(SubStr(aInfMonNFe[1][9],1,3) $ "003-004-009-025")
            CONOUT("Nota trasmitada com sucesso!","TOTVS")
            RETURN lOk := {.T., "serie e Nota: "+aInfMonNFe[1,1] + " trasmitada com sucesso!"}
        ElseIf nI == nTentantiva
            CONOUT("Não foi possível obter informações da nota fiscal transmitida!","TOTVS")
        EndIf
        Sleep(1000)
 
    Next

Return lOk


Static Function TMATA265(cProd, _QUANT, _LOCAL, _DOC, _SERIE, _CLIFOR, _LOJA)
    Local aCab      := {}
	Local aItens    := {}
    Local aItem     := {}
    Local cAltb     := "TBL24112025"//GetNextAlias()

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
    cQuery += " 	AND DA_DATA = '"+dToS( ddatabase )+"' "
    cQuery += " 	AND DA_CLIFOR = '"+_CLIFOR+"' "
    cQuery += " 	AND DA_LOJA = '"+_LOJA+"' "
    cQuery += " 	AND DA_DOC = '"+_DOC+"' "
    cQuery += " 	AND DA_PRODUTO = '"+cProd+"' "
    cQuery += " 	AND DA_LOCAL = '"+_LOCAL+"'
    DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAltb, .F., .T.)    
    //dbUseArea(.t.,"TOPCONN",tcGenQry(,,cQuery),"T01",.t.)

    cItem 	:= "0001"

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
            //aAdd(aRet, {"erro Distribuicao da NOTA ENTRADA", .F.})
            //MostraErro()
        EndIF
    ENDIF
    (cAltb)->(dbCloseArea())

Return


Static Function AEXCLUIR()
    Local Y, X
    Local aRexId  := PedADev(cFilAnt)
    Local cDirLog := '\x_logs\'
    Local cLog    := ""
    
    FOR Y := 1 TO LEN(aRexId)
        
        aPedi := retApedEx(aRexId[Y,1], aRexId[Y,2])
        IncProc("Pedido " + aRexId[Y,1] )
        nTot := LEN(aPedi)

        FOR X := 1 TO nTot

            //Define as variáveis base
            cDocumento := AvKey(aPedi[X,1], "F2_DOC")
            cSerie     := AvKey(aPedi[X,2], "F2_SERIE")
            cCliente   := AvKey(aPedi[X,3], "F2_CLIENTE")
            cLoja      := AvKey(aPedi[X,4], "F2_LOJA")
            cFil       := aPedi[X,5]
            dEmiss     := aPedi[X,6]
            nRecNo     := aPedi[X,7]
            dDataBase  := StoD(dEmiss)
            
            IncProc("Pedido " + aRexId[Y,1] + " - Nota fiscal: " + Alltrim(cDocumento) + " - Serie: " + cSerie  )

            //Define as variáveis específicas do processo de exclusão
            cMarca     := GetMark(, "SF2", "F2_OK")
            aRegSD2    := {}
            aRegSE1    := {}
            aRegSE2    := {}
            lMostraCtb := .F.
            lAglCtb    := .F.
            lContab    := .F.
            lCarteira  := .F.
            lPodeExcl  := .F.
            lDeuCerto  := .F.
            nRecE1     := 0

            SC5->(DBGoTop())
            SC5->(dbSeek(cFil+aRexId[Y,1]))

            SA1->(DBGoTop())
            SA1->(dbSeek(Xfilial("SA1") + cCliente + cLoja))

            cEmpAt1 := cEmpAnt
            cFilAt1 := cFilAnt

            cEmpAt   := "01"
            cFilAt   := Iif(EMPTY(cFil), "01", cFil)

            lServic := (SB1->B1_TIPO == "SV")  

            //Abre a tabela de documentos de saída
            DbSelectArea("SF2")
            SF2->(DbSetOrder(1)) // F2_FILIAL + F2_DOC + F2_SERIE + F2_CLIENTE + F2_LOJA + F2_FORMUL + F2_TIPO
            
            //Se conseguir posicionar na Nota
            If SF2->(MsSeek(cFil + cDocumento + cSerie + cCliente + cLoja))
                //Simula a marcação da tela de exclusão de Documento de Saída
                RecLock("SF2", .F.)
                    SF2->F2_OK := cMarca
                SF2->(MsUnlock())
                //nRecE1 := recTit(cDocumento, cSerie, cCliente, cLoja)
            
                //Verifica se é possível excluir a NF ou tem alguma restrição
                lPodeExcl := MaCanDelF2("SF2", SF2->(RecNo()), @aRegSD2, @aRegSE1, @aRegSE2)
            
                //Se for possível excluir, aciona a rotina para efetivar a exclusão
                If lPodeExcl
                    lDeuCerto := MaDelNFS(aRegSD2, aRegSE1, aRegSE2, lMostraCtb, lAglCtb, lContab, lCarteira)
                    //Se deu tudo certo, mostra mensagem de sucesso
                    If lDeuCerto
                        //FWAlertSuccess("Nota de número '" + cDocumento + "'  foi excluída com sucesso!", "Sucesso")
                        cLog += 'EXCLUSÃO REALIZADA COM SUCESSO - ' + cDocumento + CRLF
                    ELSE
                        cLog += 'EXCLUSÃO NAO REALIZADA - ' + cDocumento + CRLF
                    EndIf
                EndIf
            EndIf
        NEXT
    Next
    cArqLog := 'EXCLNFS_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
    MemoWrite(cDirLog + cArqLog, cLog)

    cEmpAnt  := cEmpAt
    cFilAnt  := cFilAt

Return

Static Function retApedEx(cPedi, cFil)
    local aRet := {}
    Local cAlSC5 := GetNextAlias()

    cQuery := " SELECT *, D2.R_E_C_N_O_ RECNO, F2_CHVNFE "
    cQuery += " FROM SD2010 D2 "
    cQuery += " INNER JOIN SF2010 F2 ON D2_DOC = F2_DOC AND D2_FILIAL = F2_FILIAL "
    cQuery += " WHERE D2.D_E_L_E_T_ = '' AND D2_PEDIDO = '"+cPedi+"' AND D2_FILIAL = '"+cFil+"' AND D2_DOC = '"+cNota+"' AND F2_DAUTNFE = '' "
    DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlSC5, .F., .T.) 

    WHILE !(cAlSC5)->(EOF())
        cDocumento := (cAlSC5)->D2_DOC
        cSerie     := (cAlSC5)->D2_SERIE
        cCliente   := (cAlSC5)->D2_CLIENTE
        cLoja      := (cAlSC5)->D2_LOJA
        cFil       := (cAlSC5)->D2_FILIAL
        dEmiss     := (cAlSC5)->D2_EMISSAO
        nRecN      := (cAlSC5)->RECNO
        AADD(aRet, {cDocumento, cSerie, cCliente, cLoja, cFil, dEmiss, nRecN})
        (cAlSC5)->(DBSKIP())
        LOOP
    ENDDO
    (cAlSC5)->(DBCLOSEAREA())
    
Return aRet

Static Function AEXCLU1R()
    Local Y, X
    Local aRexId  := PedADev1(cFilAnt)
    Local cDirLog := '\x_logs\'
    Local cLog    := ""
    
    FOR Y := 1 TO LEN(aRexId)
        
        aPedi := retApedEx(aRexId[Y,1], aRexId[Y,2])
        IncProc("Pedido " + aRexId[Y,1] )
        nTot := LEN(aPedi)

        FOR X := 1 TO nTot

            //Define as variáveis base
            cDocumento := AvKey(aPedi[X,1], "F2_DOC")
            cSerie     := AvKey(aPedi[X,2], "F2_SERIE")
            cCliente   := AvKey(aPedi[X,3], "F2_CLIENTE")
            cLoja      := AvKey(aPedi[X,4], "F2_LOJA")
            cFil       := aPedi[X,5]
            dEmiss     := aPedi[X,6]
            nRecNo     := aPedi[X,7]
            dDataBase  := StoD(dEmiss)
            
            IncProc("Pedido " + aRexId[Y,1] + " - Nota fiscal: " + Alltrim(cDocumento) + " - Serie: " + cSerie  )

            //Define as variáveis específicas do processo de exclusão
            cMarca     := GetMark(, "SF2", "F2_OK")
            aRegSD2    := {}
            aRegSE1    := {}
            aRegSE2    := {}
            lMostraCtb := .F.
            lAglCtb    := .F.
            lContab    := .F.
            lCarteira  := .F.
            lPodeExcl  := .F.
            lDeuCerto  := .F.
            nRecE1     := 0

            SC5->(DBGoTop())
            SC5->(dbSeek(cFil+aRexId[Y,1]))

            SA1->(DBGoTop())
            SA1->(dbSeek(Xfilial("SA1") + cCliente + cLoja))

            cEmpAt1 := cEmpAnt
            cFilAt1 := cFilAnt

            cEmpAt   := "01"
            cFilAt   := Iif(EMPTY(cFil), "01", cFil)

            lServic := (SB1->B1_TIPO == "SV")  

            //Abre a tabela de documentos de saída
            DbSelectArea("SF2")
            SF2->(DbSetOrder(1)) // F2_FILIAL + F2_DOC + F2_SERIE + F2_CLIENTE + F2_LOJA + F2_FORMUL + F2_TIPO
            
            //Se conseguir posicionar na Nota
            If SF2->(MsSeek(cFil + cDocumento + cSerie + cCliente + cLoja))
                //Simula a marcação da tela de exclusão de Documento de Saída
                RecLock("SF2", .F.)
                    SF2->F2_OK := cMarca
                SF2->(MsUnlock())
                //nRecE1 := recTit(cDocumento, cSerie, cCliente, cLoja)
            
                //Verifica se é possível excluir a NF ou tem alguma restrição
                lPodeExcl := MaCanDelF2("SF2", SF2->(RecNo()), @aRegSD2, @aRegSE1, @aRegSE2)
            
                //Se for possível excluir, aciona a rotina para efetivar a exclusão
                If lPodeExcl
                    lDeuCerto := MaDelNFS(aRegSD2, aRegSE1, aRegSE2, lMostraCtb, lAglCtb, lContab, lCarteira)
                    //Se deu tudo certo, mostra mensagem de sucesso
                    If lDeuCerto
                        //FWAlertSuccess("Nota de número '" + cDocumento + "'  foi excluída com sucesso!", "Sucesso")
                        cLog += 'EXCLUSÃO REALIZADA COM SUCESSO - ' + cDocumento + CRLF
                    ELSE
                        cLog += 'EXCLUSÃO NAO REALIZADA - ' + cDocumento + CRLF
                    EndIf
                EndIf
            EndIf
        NEXT
    Next
    cArqLog := 'EXCLNFS_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.log'
    MemoWrite(cDirLog + cArqLog, cLog)

    cEmpAnt  := cEmpAt
    cFilAnt  := cFilAt

Return

