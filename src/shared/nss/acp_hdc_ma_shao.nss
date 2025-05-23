/////////////////////////////////////////////////
// acp_s35_MA_shao
// Author: Adam Anden
// Creation Date: 28 January 2008
////////////////////////////////////////////////

//#include "acp_S3_diffstyle"
#include "q_inc_acp"
//Sets Dragon Palm style

void main()
{
  object oPC = GetPCSpeaker();
  //SetCustomFightingStyle(50);
  string sText = "modo shao";
  Q_ACPCheckChat(oPC, sText);
  SendMessageToPC(oPC,"Puño de Dragón..."); //SendMessageToPC(oPC, "Dragon Palm...");
}

