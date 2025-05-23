#include "mti_libreria"
#include "pb_tesoros_inc"
void main()
{
  object oPC = GetPCSpeaker();

  object oReli1 = GetItemPossessedBy(oPC, "ReliquiadeIdeepton");
  object oReli2 = GetItemPossessedBy(oPC, "ReliquiadeShatar");
  object oReli3 = GetItemPossessedBy(oPC, "ReliquiadeMinsor");
  GuardarIntPersistente(oPC, "QUEST_RELIQUIA_SAGRADA", 2);
  DestroyObject(oReli1);
  DestroyObject(oReli2);
  DestroyObject(oReli3);
  GiveXPToCreature(oPC, 5000);
  GiveGoldToCreature(oPC, 25000);
  DelayCommand(2.0, CrearArmaCuerpo(oPC, 4));
  DelayCommand(2.0, CrearArmadura(oPC, 4));
  DelayCommand(2.0, CrearPergamino(oPC, 4));
 DelayCommand(2.0, Crear1ObjetoAleatorio(oPC, 4, 2));


}
