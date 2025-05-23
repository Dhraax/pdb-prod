#include "mti_libreria"

void main()
{
  object oPC = GetPCSpeaker();

  GuardarIntPersistente(oPC, "QUEST_TS", 4);
  SetXP(oPC, GetXP(oPC) + 2000);
  AdjustAlignment(oPC, ALIGNMENT_GOOD, 5, FALSE);
}
