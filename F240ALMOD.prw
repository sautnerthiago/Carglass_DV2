#include "rwmake.ch" 

User Function F240ALMOD() 

Local cModelo := ParamIxb[1]
If cModelo == "91" // Novo modelo
				   // No caso deste modelo o segmento "O" � gerado no arquivo remessa
   cModelo := "13" // Modelo 13 j� existente
EndIf
Return cModelo
