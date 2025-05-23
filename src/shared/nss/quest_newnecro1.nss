#include "mti_libreria"
#include "f_vampire_spls_h"
#include "lib_race"

int StartingConditional()
{
  object oPC = GetPCSpeaker();
  string sSubraza = GetSubRace(oPC);
  int iVariable = ObtenerIntPersistente(oPC, "QUEST_NUEVONECRO");

  int nivel1 = GetLevelByPosition(1, oPC);
  int nivel2 = GetLevelByPosition(2, oPC);
  int nivel3 = GetLevelByPosition(3, oPC);
  int total = nivel1 + nivel2 + nivel3;
  if((total<5) && (iVariable==0) && (PB_Race_GetIsUndead(oPC) || GetIsVampire(oPC) || sSubraza=="ghul" || sSubraza=="necropolita" || sSubraza=="deathknight" || sSubraza=="liche")) return TRUE;
  return FALSE;
}
