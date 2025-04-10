/////////////////////////////////////////////////
// ACP_S35_assassin
// Author: Adam Anden
// Creation Date: 09 March 2007
////////////////////////////////////////////////

//Sets assassin style

  #include "q_inc_acp"


void main()
{
  object oPC = GetPCSpeaker();
  string sText = "modo assasin";
  Q_ACPCheckChat(oPC, sText);
  //SetCustomFightingStyle(42);
  SendMessageToPC(oPC, "Estilo Asesino...");
}
