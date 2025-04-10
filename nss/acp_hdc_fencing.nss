/////////////////////////////////////////////////
// ACP_S35_fencing
// Author: Adam Anden
// Creation Date: 09 March 2007
////////////////////////////////////////////////

//#include "acp_S3_diffstyle"
 #include "q_inc_acp"
//Sets fencing style

void main()
{
  //SetCustomFightingStyle(44);
  object oPC = GetPCSpeaker();
  string sText = "modo fencing";
  Q_ACPCheckChat(oPC, sText);
  SendMessageToPC(oPC, "Estilo Esgrima...");//SendMessageToPC(oPC, "Fencing Style");
}
