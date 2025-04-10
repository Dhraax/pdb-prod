/////////////////////////////////////////////////
// ACP_S35_arcane
// Author: Adam Anden
// Creation Date: 09 March 2007
////////////////////////////////////////////////

//#include "acp_S3_diffstyle"
#include "q_inc_acp"
//Sets arcane style

void main()
{
  object oPC = GetPCSpeaker();
  //SetCustomFightingStyle(45);
  string sText = "modo arcane";
  Q_ACPCheckChat(oPC, sText);

  SendMessageToPC(oPC, "Artes Magna...");//SendMessageToPC(oPC, "Ars Magna...");
}
