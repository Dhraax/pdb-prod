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
  CreateItemOnObject("libroherreria", oPC, 1);

  // Quitar algo de oro al jugador
  TakeGoldFromCreature(200, oPC, FALSE);

  GuardarIntPersistente(oPC, "NIVELMINERIA", 1);
  GuardarIntPersistente(oPC, "NIVELFUNDICION", 1);
  GuardarIntPersistente(oPC, "NIVELHERRERIA", 1);
  GuardarIntPersistente(oPC, "NIVELAFILADURA", 1);
}
