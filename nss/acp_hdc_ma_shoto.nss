/////////////////////////////////////////////////
// acp_s35_MA_shoto
// Author: Adam Anden
// Creation Date: 28 January 2008
////////////////////////////////////////////////

//#include "acp_S3_diffstyle"
#include "q_inc_acp"
//Sets Sun Fist style

void main()
{
  object oPC = GetPCSpeaker();
  //SetCustomFightingStyle(49);
  string sText = "modo shoto";
  Q_ACPCheckChat(oPC, sText);
  SendMessageToPC(oPC,"Saludo al Sol...");//SendMessageToPC(oPC, "Sun Fist...");
}

