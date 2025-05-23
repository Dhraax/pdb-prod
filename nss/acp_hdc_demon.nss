/////////////////////////////////////////////////
// ACP_S35_demon
// Author: Adam Anden
// Creation Date: 09 March 2007
////////////////////////////////////////////////

//#include "acp_S3_diffstyle"
#include "q_inc_acp"
//Sets Demon Blade style

void main()
{
  object oPC = GetPCSpeaker();
  string sText = "modo demon";
  Q_ACPCheckChat(oPC, sText);
  //SetCustomFightingStyle(46);
  SendMessageToPC(oPC, "Estilo Espada Demoníaca...");//SendMessageToPC(oPC, "Demon Blade...");
}
