#include "mti_libreria"

void main()
{
  object oPC = GetPCSpeaker();

  object oObjetoAEliminar1 = GetItemPossessedBy(oPC, "nedroncuerpo");
  if(GetIsObjectValid(oObjetoAEliminar1)) DestroyObject(oObjetoAEliminar1);

  object oObjetoAEliminar2 = GetItemPossessedBy(oPC, "LlavedelportalaThormallemcle");
  if(GetIsObjectValid(oObjetoAEliminar2)) DestroyObject(oObjetoAEliminar2);

  GiveXPToCreature(oPC, 2500);
  GiveGoldToCreature(oPC, 2000);
  CreateItemOnObject("x2_it_wpmwhip1", oPC);
  GuardarIntPersistente(oPC, "QUESTARACH", 2);
}
