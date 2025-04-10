//Created by 420 for the CEP
//Check for valid cloak and local variable
//Based on script tlr_clothcheck.nss by Stacy L. Ropella
//editado para comprobar si tiene capa para reversible
int StartingConditional()
{
    object oPC = GetPCSpeaker();

    if(GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_CLOAK, oPC)) ) return TRUE;

 return FALSE;
}
