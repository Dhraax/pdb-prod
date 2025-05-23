#include "mti_libreria"

void main()
{
  object oPC = GetPCSpeaker();

  object oObjetoAEliminar1 = GetItemPossessedBy(oPC, "Thormmallem");
  if(GetIsObjectValid(oObjetoAEliminar1)) DestroyObject(oObjetoAEliminar1);

  object oObjetoAEliminar2 = GetItemPossessedBy(oPC, "LlavedelportalaThormallem");
  if(GetIsObjectValid(oObjetoAEliminar2)) DestroyObject(oObjetoAEliminar2);

  GiveXPToCreature(oPC, 2500);
  GiveGoldToCreature(oPC, 2000);
  CreateItemOnObject("nw_wmgwn004", oPC);
  GuardarIntPersistente(oPC, "QUESTSORCERE", 2);
}
