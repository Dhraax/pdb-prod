//::///////////////////////////////////////////////
//:: Pulse Drown
//:: NW_S1_PulsDrwn
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    CHANGED JANUARY 2003
     - does an actual 'drown spell' on each target
     in the area of effect.
     - Each use of this spells consumes 50% of the
     elementals hit points.

*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watmaniuk
//:: Created On: April 15, 2002
//:://////////////////////////////////////////////

#include "NW_I0_SPELLS"
void Drown(object oTarget, int iCD)
{

    effect eVis = EffectVisualEffect(VFX_IMP_FROST_S);
    int    nDam = GetCurrentHitPoints(oTarget);
    effect eDam = EffectDamage(nDam, DAMAGE_TYPE_MAGICAL);
    // * certain racial types are immune
    if ((GetRacialType(oTarget) != RACIAL_TYPE_CONSTRUCT)
     &&(!PB_Race_GetIsUndead(oTarget))
     &&(GetRacialType(oTarget) != RACIAL_TYPE_ELEMENTAL)
     &&(GetHasSpellEffect(996,oTarget) != TRUE))
    {
        //Make a fortitude save
        if(MySavingThrow(SAVING_THROW_FORT, oTarget, iCD) == FALSE)
        {
            //Apply the VFX impact and damage effect
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            //Set damage effect to kill the target
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);

         }
    }
}
void main ()
{
    int nDamage = GetCurrentHitPoints() / 2;
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDamage(nDamage), OBJECT_SELF);
    //Declare major variables
    object oTarget;
    int bSave = FALSE;
    int nIdx;
    int nSize = GetCreatureSize(OBJECT_SELF);
    int iCD = 26;
        if (nSize = CREATURE_SIZE_SMALL | CREATURE_SIZE_TINY) iCD = 14;
        if (nSize = CREATURE_SIZE_MEDIUM) iCD = 20;

    effect eImpact = EffectVisualEffect(VFX_IMP_PULSE_WATER);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, OBJECT_SELF);
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(OBJECT_SELF));
    while(GetIsObjectValid(oTarget) == TRUE)
    {
        if(!GetIsReactionTypeFriendly(oTarget) && oTarget != OBJECT_SELF)
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_PULSE_DROWN));
            Drown(oTarget, iCD);
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(OBJECT_SELF));
    }
}


