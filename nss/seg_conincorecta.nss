#include "mti_libreria"

void main()
{
  object oPC = GetPCSpeaker();
  object oMod = GetModule();
  string sCdKey = GetPCPublicCDKey(oPC);
  string sIP = GetPCIPAddress(oPC);
  int iIntentos = GetLocalInt(oMod, "SEG_INTENTOS" + sCdKey);

  DeleteLocalString(oPC, "SEGSERIE");
  SetLocalInt(oMod, "SEG_INTENTOS" + sCdKey, iIntentos + 1);

  if((iIntentos + 1) >= 3)
  {
      WriteTimestampedLogEntry("[SISTEMA DE SEGURIDAD DE CUENTAS] La cdkey "+sCdKey+" y la IP "+sIP+" no ha introducido correctamente su contraseña de seguridad con el PJ "+GetName(oPC)+" ("+GetPCPlayerName(oPC)+"), 0 intentos restantes. Dicha cdkey e IP han sido baneadas hasta el próximo reinicio.");
      SendMessageToAllDMs("[SISTEMA DE SEGURIDAD DE CUENTAS] La cdkey "+sCdKey+" y la IP "+sIP+" no ha introducido correctamente su contraseña de seguridad con el PJ "+GetName(oPC)+" ("+GetPCPlayerName(oPC)+") 0 intentos restantes. Dicha cdkey e IP han sido baneadas hasta el próximo reinicio.");
      AssignCommand(oPC, ActionPauseConversation());
      FloatingTextStringOnCreature("¡Serás baneado hasta el próximo reinicio!", oPC, FALSE);
      SetLocalInt(oMod, "SEG_BANCDKEY_" + sCdKey, TRUE);
      SetLocalInt(oMod, "SEG_BANIP_" + sIP, TRUE);
      DelayCommand(2.5, BootPC(oPC));
  }
  else
  {
      SendMessageToAllDMs("[SISTEMA DE SEGURIDAD DE CUENTAS] La cdkey "+sCdKey+" y la IP "+sIP+" no ha introducido correctamente su contraseña de seguridad con el PJ "+GetName(oPC)+" ("+GetPCPlayerName(oPC)+"), "+IntToString(3-(iIntentos+1))+" intentos restantes.");
      WriteTimestampedLogEntry("[SISTEMA DE SEGURIDAD DE CUENTAS] La cdkey "+sCdKey+" y la IP "+sIP+" no ha introducido correctamente su contraseña de seguridad con el PJ "+GetName(oPC)+" ("+GetPCPlayerName(oPC)+"), "+IntToString(3-(iIntentos+1))+" intentos restantes.");
  }
}
