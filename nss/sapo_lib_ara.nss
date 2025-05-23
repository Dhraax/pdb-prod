#include "mti_libreria"
#include "pb_ofi_artesa_i"

void main()
{
  object oPC = GetPCSpeaker();

  if(GetGold(oPC) < 200)
  {
      FloatingTextStringOnCreature("No tienes 200 po.", oPC, FALSE);
      return;
  }

  // Solo 3ª esfera de conjuros
  if(ConjurosTerceraEsfera(oPC) == FALSE) return;

  // Dar los objetos al que habla
  CreateItemOnObject("pb_ofi_man_artes", oPC);

  // Quitar algo de oro al jugador
  TakeGoldFromCreature(200, oPC, FALSE);

  // VAriables de oficio a nivel 1
  GuardarIntPersistente(oPC, "Profesion8", 1);
  GuardarIntPersistente(oPC, "Profesion8XP", 1);
  GuardarIntPersistente(oPC, "Profesion11", 1);
  GuardarIntPersistente(oPC, "Profesion11XP", 1);
  GuardarIntPersistente(oPC, "Profesion15", 1);
  GuardarIntPersistente(oPC, "Profesion15XP", 1);
}
