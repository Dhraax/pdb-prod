//::///////////////////////////////////////////////
//:: Tailoring - Check for Valid Clothing on PC & Model
//:: Also check to see if clothing copying is allowed
//:: tlr_clothcheck.nss
//:://////////////////////////////////////////////
/*
//:://////////////////////////////////////////////
//:: Created By: Stacy L. Ropella
//:: from Mandragon's mil_tailor
//:://////////////////////////////////////////////
*/
//modificado para comprobar si llevar ropa para reversible
int StartingConditional()
{
    object oPC = GetPCSpeaker();

    if (GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_CHEST, oPC) ) ) return TRUE;

 return FALSE;
}
