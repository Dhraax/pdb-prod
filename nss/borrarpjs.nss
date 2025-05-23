//#include "nwnx_exalt"
//#include "nwnx_system"
#include "nwnx_admin"

void DelayDelChar(object oPC) {

  //FileDelete(sBic);
  NWNX_Administration_DeletePlayerCharacter(oPC, FALSE);
}

void main()
{
  object oPC = GetPCSpeaker();
  //string sBic = "/home/baldurs/nwn/server/servervault/"; //"/home/baldurs/nwserver/servervault/";

  //sBic += GetPCPlayerName(oPC) +"/"+ NWNX_GetPCFileName(oPC) +".bic";
  FadeToBlack(oPC);
  SetCommandable (FALSE, oPC);
  AssignCommand (oPC, ClearAllActions ());

  // REGISTRO EN EL LOG
  WriteTimestampedLogEntry("[INFORME DE BORRADO DE PJ] Informe: El PJ: " + GetName(oPC, TRUE) + " de la cuenta: "
  + GetPCPlayerName(oPC)+" ha sido borrado del servidor."
  + " Su CdKey es: " + GetPCPublicCDKey(oPC) + ";"
  + " y su dirección ip es: "  + GetPCIPAddress(oPC));

  DelayCommand(4.0f, DelayDelChar(oPC));
}
