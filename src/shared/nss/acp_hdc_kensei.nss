/////////////////////////////////////////////////
// ACP_S35_kensei
// Author: Adam Anden
// Creation Date: 09 March 2007
////////////////////////////////////////////////

#include "q_inc_acp"
//#include "acp_S3_diffstyle"

//Sets kensei style

void main()
{
  object oPC = GetPCSpeaker();
  //SetCustomFightingStyle(41);
  string sText = "modo kensai";
  Q_ACPCheckChat(oPC, sText);
  SendMessageToPC(oPC, "Estilo Kensai...");//SendMessageToPC(oPC, "Kensei Style...");
}
