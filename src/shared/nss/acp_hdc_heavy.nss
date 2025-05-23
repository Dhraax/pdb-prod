/////////////////////////////////////////////////
// ACP_S35_heavy
// Author: Adam Anden
// Creation Date: 09 March 2007
////////////////////////////////////////////////

//#include "acp_S3_diffstyle"
#include "q_inc_acp"
//Sets heavy style

void main()
{

  object oPC = GetPCSpeaker();
  //SetCustomFightingStyle(47);
  string sText = "modo heavy";
  Q_ACPCheckChat(oPC, sText);
  SendMessageToPC(oPC, "Estilo de Matón...");//SendMessageToPC(oPC, "Barbarian Style...");
}
