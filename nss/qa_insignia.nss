#include "mti_libreria"

void main()
{
    object oPC = GetPCSpeaker();
    if(!SiObjetoInventario (oPC,"preadventurer") && GetGold(oPC) >= 1000)
    {
        CreateItemOnObject("preadventurer",oPC,1);
        TakeGoldFromCreature(1000, OBJECT_SELF, TRUE);
    }
}
