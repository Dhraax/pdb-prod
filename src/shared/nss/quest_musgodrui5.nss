#include "mti_libreria"
void main()
{
    object oPC = GetPCSpeaker();
    object oCofresemillas = GetItemPossessedBy(oPC, "q_semidruida");
    if (oCofresemillas != OBJECT_INVALID){
        GiveGoldToCreature(oPC,450);
        GiveXPToCreature(oPC,500);
        DestroyObject(oCofresemillas,0.1f);
        GuardarIntPersistente(oPC,"QUEST_MUSGO_ARCHIDRUIDA",3);
    }
}
