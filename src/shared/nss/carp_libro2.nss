#include "mti_libreria"
void main()
{
  object oPC = GetPCSpeaker();

  if(GetGold(GetPCSpeaker()) < 200)
  {
      FloatingTextStringOnCreature("*¡Pero si no tienes 200 po!*", oPC, FALSE);
      return;
  }

  // Dar los objetos al que habla
  CreateItemOnObject("carp_libro", oPC, 1);

  // Quitar algo de oro al jugador
  TakeGoldFromCreature(200, oPC, FALSE);

  GuardarIntPersistente(oPC, "NIVELLENYADOR", 1);
  GuardarIntPersistente(oPC, "NIVELSERRERIA", 1);
  GuardarIntPersistente(oPC, "NIVELCARPINTERIA", 1);
  GuardarIntPersistente(oPC, "NIVELEBANISTA", 1);
}

