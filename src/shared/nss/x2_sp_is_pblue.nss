//::///////////////////////////////////////////////
//:: Name x2_sp_is_pblue
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Ioun Stone Power: Pale Blue
    Gives the user 1 hours worth of +2 Strength bonus.
    Cancels any other Ioun stone powers in effect
    on the PC.
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: Dec 13/02
//:://////////////////////////////////////////////

#include "nostack_inc"

void main()
{
    DoNoStackAbilityBonus(OBJECT_SELF, OBJECT_SELF, 2, ABILITY_STRENGTH, 3600.0);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(1543), OBJECT_SELF, 3600.0);
}
