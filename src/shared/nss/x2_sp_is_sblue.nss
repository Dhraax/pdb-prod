//::///////////////////////////////////////////////
//:: Name x2_sp_is_sblue
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Ioun Stone Power: Scarlet Blue
    Gives the user 1 hours worth of +2 Intelligence bonus.
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
    DoNoStackAbilityBonus(OBJECT_SELF, OBJECT_SELF, 2, ABILITY_INTELLIGENCE, 3600.0);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(1541), OBJECT_SELF, 3600.0);
}
