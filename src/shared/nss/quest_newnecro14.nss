#include "mti_libreria"
void main()
{

    object oPC = GetPCSpeaker();
    GuardarIntPersistente(oPC,"QUEST_NUEVONECRO",6);
    AdjustAlignment(oPC, ALIGNMENT_EVIL, 5);

}
