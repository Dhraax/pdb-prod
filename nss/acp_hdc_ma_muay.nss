/////////////////////////////////////////////////
// acp_s35_MA_muay
// Author: Adam Anden
// Creation Date: 28 January 2008
////////////////////////////////////////////////

//#include "acp_S3_diffstyle"
#include "q_inc_acp"
//Sets Tiger Fang style

void main()
{
  object oPC = GetPCSpeaker();
  //SetCustomFightingStyle(48);
  string sText = "modo muay";
  Q_ACPCheckChat(oPC, sText);
  SendMessageToPC(oPC,"Colmillos de Tigre...");//SendMessageToPC(oPC, "Tiger Fang...");
}

