#include "mti_libreria"
//libro del cuero
void main()
{
  object oPC = GetPCSpeaker();

  if(GetGold(GetPCSpeaker()) < 200)
  {
      FloatingTextStringOnCreature("*¡Pero si no tienes 200 po!*", oPC, FALSE);
      return;
  }

  // Dar los objetos al que habla
  CreateItemOnObject("manualdelcuero", oPC, 1);

  // Quitar algo de oro al jugador
  TakeGoldFromCreature(200, oPC, FALSE);
  //
  GuardarIntPersistente(oPC, "Profesion9", 1);
  GuardarIntPersistente(oPC, "Profesion12", 1);
  GuardarIntPersistente(oPC, "NIVELDESOLLADOR", 1);

}
