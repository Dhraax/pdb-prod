//::///////////////////////////////////////////////
//:: Fiery Skeleton OnUserDefined event script
//:: q_burnskeltn_ud.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Explode on death

        - 1d6 fire damage
        - Reflex save for half - DC 11
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

const int EVENT_USER_DEFINED_PRESPAWN = 1510;
const int EVENT_USER_DEFINED_POSTSPAWN = 1511;

#include "NW_I0_SPELLS"

void main()
{
    int nUser = GetUserDefinedEventNumber();

    if(nUser == 1007) // DEATH  - do not use for critical code, does not fire reliably all the time
    {
        {
            object oTarget = GetNearestObject(OBJECT_TYPE_CREATURE);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_FIREBALL), OBJECT_SELF);
            //Make a Fort save to negate
            if (GetDistanceToObject(oTarget) <= 2.0)
            if (!MySavingThrow(SAVING_THROW_REFLEX, oTarget, 11, SAVING_THROW_TYPE_FIRE))
            {
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FLAME_S), oTarget);
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDamage(d6(1), DAMAGE_TYPE_FIRE), oTarget);
            }
        }
    }
}
