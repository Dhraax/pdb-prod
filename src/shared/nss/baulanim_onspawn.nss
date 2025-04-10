//:://////////////////////////////////////////////////
//:: henchmen_onspawn
//:: Script para el onspwn de los ayudantes
//:://////////////////////////////////////////////////

#include "x0_inc_henai"

void main()
{
string sMaster = GetName(GetMaster(OBJECT_SELF));
SetLocalString(OBJECT_SELF,"AMO",sMaster);
    //FIJAR AL AYUDANTE COMO SAQUEABLE
    SetLootable(OBJECT_SELF, TRUE);

    //Sets up the special henchmen listening patterns
    SetAssociateListenPatterns();

    // Set additional henchman listening patterns
    bkSetListeningPatterns();

    // Default behavior for henchmen at start
    SetAssociateState(NW_ASC_POWER_CASTING);
    SetAssociateState(NW_ASC_HEAL_AT_50);
    SetAssociateState(NW_ASC_RETRY_OPEN_LOCKS);
    SetAssociateState(NW_ASC_DISARM_TRAPS);

    // * July 2003. Set this to true so henchmen
    // * will hopefully run off a little less often
    // * by default
    // * September 2003. Bad decision. Reverted back
    // * to original. This mode too often looks like a bug
    // * because they hang back and don't help each other out.
    //SetAssociateState(NW_ASC_MODE_DEFEND_MASTER, TRUE);
    SetAssociateState(NW_ASC_DISTANCE_2_METERS);

    //Use melee weapons by default
    SetAssociateState(NW_ASC_USE_RANGED_WEAPON, FALSE);

    // Set starting location
    SetAssociateStartLocation();

    // Set respawn location
    SetRespawnLocation();

    // For some general behavior while we don't have a master,
    // let's do some immobile animations
    SetSpawnInCondition(NW_FLAG_IMMOBILE_AMBIENT_ANIMATIONS);

    SetIsDestroyable(FALSE, TRUE, TRUE);

    // * September 2003
    // * Scan through all equipped items and make
    // * sure they are identified
    int i = 0;
    object oItem;
    for (i = INVENTORY_SLOT_HEAD; i<=INVENTORY_SLOT_CARMOUR; i++)
    {
        oItem = GetItemInSlot(i, OBJECT_SELF);
        if (GetIsObjectValid(oItem) == TRUE)
            SetIdentified( oItem, TRUE);
    }


}
