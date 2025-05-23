#include "f_vampire_spls_h"

int StartingConditional()
{
  object oPC = GetPCSpeaker();
  string sSubraza = GetStringLowerCase(GetSubRace(oPC));

  if ((GetIsVampire(oPC)==TRUE)||(GetItemPossessedBy(oPC, "asy_emblemavamp") != OBJECT_INVALID)||(sSubraza == "ghul")||(sSubraza == "deathknight")||(sSubraza == "necropolita")||(sSubraza == "liche"))
  return TRUE;
  return FALSE;
}
