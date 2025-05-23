#include "mti_libreria"
#include "lib_race"

int StartingConditional()
{
  object oPC = GetPCSpeaker();
  int iRaza = GetRacialType(oPC);
  int iClase1 = GetClassByPosition(1, oPC);
  int iClase2 = GetClassByPosition(2, oPC);
  int iClase3 = GetClassByPosition(3, oPC);
  string sSubraza = GetSubRace(oPC);
  int iVariable = ObtenerIntPersistente(oPC, "QUEST_MUSGO_ARCHIDRUIDA");

  if((iVariable==0) && (PB_Race_GetIsElf(oPC) || iRaza==RACIAL_TYPE_HALFELF || sSubraza=="lythari" || sSubraza=="semifata" || iClase1==CLASS_TYPE_DRUID  || iClase1==CLASS_TYPE_RANGER || iClase2==CLASS_TYPE_DRUID  || iClase2==CLASS_TYPE_RANGER|| iClase3==CLASS_TYPE_DRUID  || iClase3==CLASS_TYPE_RANGER)) return TRUE;
  return FALSE;

}
