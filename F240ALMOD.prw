#include "rwmake.ch" 

User Function F240ALMOD() 

Local cModelo := ParamIxb[1]
If cModelo == "91" // Novo modelo
				   // No caso deste modelo o segmento "O" é gerado no arquivo remessa
   cModelo := "13" // Modelo 13 já existente
EndIf
Return cModelo
