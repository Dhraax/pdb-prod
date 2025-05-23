#include "mti_libreria"
void main()
{
  object oPC = GetPCSpeaker();

  GiveXPToCreature(oPC, 3000);
  GuardarIntPersistente(oPC, "ESMEL_QUEST_LLORONA", 2);
  AdjustAlignment(oPC, ALIGNMENT_EVIL, 5);
}

