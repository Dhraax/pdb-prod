//::///////////////////////////////////////////////
//:: tk_zomb_rise
//:://////////////////////////////////////////////
/*
    When run by a zombie's placeable corpse, the
    corpse rises into the zombie.
*/
//:://////////////////////////////////////////////
//:: Created by: The Krit
//:: Created on: October 24, 2007
//:://////////////////////////////////////////////


#include "tk_zomb_inc"


// Clear a creature's inventory so nothing gets dropped in a body bag.
void SetUndroppableInventory(object oCreature = OBJECT_SELF);

void main()
{
    // Create and initialize the zombie.
    object oZombie = CreateObject(OBJECT_TYPE_CREATURE,
                        GetLocalString(OBJECT_SELF, TK_ZOMBIE_CREATURE),
                        TK_GetRotatedLocation(GetLocalFloat(OBJECT_SELF, TK_ZOMBIE_ROTATION)));
    TK_CopyZombieLocals(oZombie, OBJECT_SELF);

    // Hide the zombie while it is lying down.
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                        EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY),
                        oZombie, TK_ZOMBIE_FALLDOWNTIME);

    // Make the zombie assume the placeable's pose.
    if ( GetLocalInt(OBJECT_SELF, TK_ZOMBIE_FACEUP) )
        AssignCommand(oZombie, PlayAnimation(ANIMATION_LOOPING_DEAD_BACK,  1.0, 2.0));
    else
        AssignCommand(oZombie, PlayAnimation(ANIMATION_LOOPING_DEAD_FRONT, 1.0, 2.0));

    // Some additional processing in case the corpse is really a dead creature.
    if ( GetObjectType(OBJECT_SELF) == OBJECT_TYPE_CREATURE )
    {
        SetUndroppableInventory();
        SetIsDestroyable(TRUE, FALSE);
    }

    // Destroy the corpse once the zombie appears.
    DestroyObject(OBJECT_SELF, TK_ZOMBIE_FALLDOWNTIME);
}


// Set a creature's inventory to undroppable so nothing gets dropped in a body bag.
void SetUndroppableInventory(object oCreature = OBJECT_SELF)
{
    // First a sanity check because otherwise the game could freeze.
    if ( !GetHasInventory(oCreature) )
        return;

    // Loop through the inventory.
    object oItem = GetFirstItemInInventory(oCreature);
    while ( oItem != OBJECT_INVALID )
    {
        SetDroppableFlag(oItem, FALSE);
        oItem = GetNextItemInInventory(oCreature);
    }

    // Another sanity check, in case someone decides to use this for non-creatures.
    if ( GetObjectType(oCreature) != OBJECT_TYPE_CREATURE )
        return;

    // Loop through equipped inventory.
    int nSlot = NUM_INVENTORY_SLOTS;
    while ( nSlot-- > 0 )
        SetDroppableFlag(GetItemInSlot(nSlot, oCreature), FALSE);

    // Remove gold.
    TakeGoldFromCreature(GetGold(oCreature), oCreature, TRUE);
}

