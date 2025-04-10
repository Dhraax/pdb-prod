//::///////////////////////////////////////////////
//:: FileName f_vampirecoffinl
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 7/13/2003 11:44:34 PM
//:://////////////////////////////////////////////
void main()
{

    // Remove items from the player's inventory
    object oItemToTake = GetItemPossessedBy(GetPCSpeaker(), "NW_IT_MSMLMISC24");
    if(!GetIsObjectValid(oItemToTake))
        {
        FloatingTextStringOnCreature("¡No tienes un ajo para usar!", GetPCSpeaker());
        return;
        }
    if(!GetLocalInt(OBJECT_SELF, "FALLEN_IN_COFFIN"))
        {
        FloatingTextStringOnCreature("¡Has llegado tarde, el vampiro se ha despertado!", GetPCSpeaker());
        return;
        }
    DestroyObject(oItemToTake);
    // Set the variables
    SetLocalInt(OBJECT_SELF, "FALLEN_VAMPIRE_GARLIC", TRUE);
}
