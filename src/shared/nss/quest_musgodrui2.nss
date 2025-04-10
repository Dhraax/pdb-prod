#include "mti_libreria"
void main()
{

    object oPC = GetPCSpeaker();
    GuardarIntPersistente(oPC,"QUEST_MUSGO_ARCHIDRUIDA",1);
    CreateItemOnObject("q_bolsaoro", oPC, 1);

}

