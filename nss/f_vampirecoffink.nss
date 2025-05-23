//::///////////////////////////////////////////////
//:: FileName f_vampirecoffink
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 7/13/2003 11:44:34 PM
//:://////////////////////////////////////////////
void main()
{

    // Remove items from the player's inventory
    object oItemToTake = GetItemPossessedBy(GetPCSpeaker(), "X1_WMGRENADE005");
    if(!GetIsObjectValid(oItemToTake)) oItemToTake = GetItemPossessedBy(GetPCSpeaker(), "NW_IT_MSMLMISC15");
    if(!GetIsObjectValid(oItemToTake))
        {
        FloatingTextStringOnCreature("¡No tienes agua bendita para usar!", GetPCSpeaker());
        return;
        }
    if(!GetLocalInt(OBJECT_SELF, "FALLEN_IN_COFFIN"))
        {
        FloatingTextStringOnCreature("¡Has llegado tarde, el vampiro se ha despertado!", GetPCSpeaker());
        return;
        }
    DestroyObject(oItemToTake);
    // Set the variables
    SetLocalInt(OBJECT_SELF, "FALLEN_VAMPIRE_HOLYWATER", TRUE);
    FloatingTextStringOnCreature("El agua bendita quema al vampiro, haciendole gran daño.", GetPCSpeaker());
}
