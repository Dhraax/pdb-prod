/////////////////////////////////////////////////
// ACP_S35_warrior
// Author: Adam Anden
// Creation Date: 09 March 2007
////////////////////////////////////////////////

//#include "acp_S3_diffstyle"
#include "q_inc_acp"
//Sets classic warrior style

void main()
{
  object oPC = GetPCSpeaker();
  //SetCustomFightingStyle(47);
  string sText = "modo normal";
  Q_ACPCheckChat(oPC, sText);
  SendMessageToPC(oPC,"Estilo Normal...");//SendMessageToPC(oPC, "Warrior...");
}
