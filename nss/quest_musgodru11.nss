#include "mti_libreria"
void main()
{

    object oPC = GetPCSpeaker();
    object oBolsaOro = GetItemPossessedBy(oPC, "q_bolsaoro");
    DestroyObject(oBolsaOro);
    CreateItemOnObject("q_semidruida", oPC, 1);
    GuardarIntPersistente(oPC,"QUEST_MUSGO_ARCHIDRUIDA",2);

}
