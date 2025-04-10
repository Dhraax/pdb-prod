#include "mti_libreria"
void main()
{
  object oPC = GetPCSpeaker();

  GiveGoldToCreature(GetPCSpeaker(), 600);
  GiveXPToCreature(GetPCSpeaker(), 400);
  GuardarIntPersistente(oPC, "YADRIL_CALLES", 3);
}
