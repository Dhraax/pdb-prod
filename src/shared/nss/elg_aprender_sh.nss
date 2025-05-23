#include "pb_nivellanzador"
void main()
{
object oPC = GetLastUsedBy();
int iCasterLevel = GetCL(oPC);

    if(GetItemPossessedBy(oPC, "siervosdehueso") != OBJECT_INVALID)
    {
        SendMessageToPC(oPC, "<cþ>No encuentras nada más en las pilas de libros.</c>");
        return;
    }

    if(GetHasFeat(399, oPC) && iCasterLevel < 13)
    {
        SendMessageToPC(oPC, "<cþ>Encontraste algo que te llama la atencion pero parece que careces del conocimiento necesario para aprenderlo.</c>");
        return;
    }

    if(GetHasFeat(399, oPC) && iCasterLevel >= 13)
    {

    SendMessageToPC(oPC, "<c þ >¡Encontraste un pergamino de [Invocar a los siervos de hueso] y conseguiste aprenderlo!</c>");
    CreateItemOnObject("siervosdehueso", oPC);

    }
}
