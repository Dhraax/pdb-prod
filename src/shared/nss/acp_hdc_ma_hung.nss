/////////////////////////////////////////////////
// acp_s35_MA_hung
// Author: Adam Anden
// Creation Date: 28 January 2008
////////////////////////////////////////////////

//#include "acp_S3_diffstyle"
#include "q_inc_acp"
//Sets Bear's Claw style

void main()
{
  object oPC = GetPCSpeaker();
  //SetCustomFightingStyle(51);
  string sText = "modo hung";
  Q_ACPCheckChat(oPC, sText);
  SendMessageToPC(oPC, "Garras de Oso...");//SendMessageToPC(oPC, "Bear's Claw...");
}

