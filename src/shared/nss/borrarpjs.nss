// modified by: Dhraax
#include "pwdb_i_user"

void main()
{
  object oPC = GetPCSpeaker();
  int iCharacterId = PWDB_MarkCharacterDeleted(oPC);
  if (iCharacterId <= 0)
  {
    SendMessageToPC(oPC, PWDB_MSG_VALIDATION_FAILED);
    WriteTimestampedLogEntry("[PWDB:DELETE] Refused BIC deletion because the tombstone failed.");
    return;
  }
  //string sBic = "/home/baldurs/nwn/server/servervault/"; //"/home/baldurs/nwserver/servervault/";

  //sBic += GetPCPlayerName(oPC) +"/"+ NWNX_GetPCFileName(oPC) +".bic";
  FadeToBlack(oPC);
  SetCommandable (FALSE, oPC);
  AssignCommand (oPC, ClearAllActions ());

  // REGISTRO EN EL LOG
  WriteTimestampedLogEntry("[INFORME DE BORRADO DE PJ] Informe: El PJ: " + GetName(oPC, TRUE) + " de la cuenta: "
  + GetPCPlayerName(oPC)+" ha sido borrado del servidor."
  + " Su CdKey es: " + GetStringLeft(GetPCPublicCDKey(oPC), 4) + "*;"
  + " y su dirección ip es: "  + GetPCIPAddress(oPC));

  DelayCommand(PWDB_DELETE_DELAY, PWDB_FinalizeDeletedCharacter(oPC, iCharacterId));
}
