#include "mti_libreria"
void main()
{
  object oPC = GetPCSpeaker();

  GuardarIntPersistente(oPC, "ALANDARMA", 1);
  GiveXPToCreature(oPC, 2000);
  CreateItemOnObject("maza_discr_6", oPC);
}
