//::///////////////////////////////////////////////
//:: Orc Warlord
//:://////////////////////////////////////////////
/*
    Inspire Courage - +2 saves vs. fear and charm and +1 to attack and damage for allies for 5 rounds.
*/
//:://////////////////////////////////////////////
//:: Created By: Oni5115
//:://////////////////////////////////////////////
//#include "prc_alterations"
#include "x0_i0_spells"

void main()
{
    object oPC = OBJECT_SELF;
    if (GetHasEffect(EFFECT_TYPE_SILENCE,OBJECT_SELF))
    {
     // Not useable when silenced. Floating text to user
        FloatingTextStrRefOnCreature(85764,OBJECT_SELF);
        return;
    }

    effect eAttack = EffectAttackIncrease(1);// Attack effect increased
    effect eDamage = EffectDamageIncrease(DAMAGE_BONUS_1, DAMAGE_TYPE_BLUDGEONING);// Increased damage effect
    effect eLink = EffectLinkEffects(eAttack, eDamage);// link effects

    effect eSaveFear = EffectSavingThrowIncrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_FEAR);
    effect eSaveCharm = EffectSavingThrowIncrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_MIND_SPELLS);

    eLink = EffectLinkEffects(eLink, eSaveFear);
    eLink = EffectLinkEffects(eLink, eSaveCharm);
    eLink = ExtraordinaryEffect(eLink);// make effects ExtraOrdinary

    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);// Get VFX
    eLink = EffectLinkEffects(eLink, eDur);// link VFXs

    effect eImpact = EffectVisualEffect(VFX_IMP_PDK_GENERIC_HEAD_HIT);// Get VFX

         // Apply effect at location
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_PDK_INSPIRE_COURAGE), OBJECT_SELF);
    DelayCommand(0.8, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_PDK_GENERIC_PULSE), OBJECT_SELF));

    // Get first target
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));

   // Keep processing while oTarget is valid
    while(GetIsObjectValid(oTarget))
    {
         // * GZ Oct 2003: If we are silenced, we can not benefit from bard song
         if (!GetHasEffect(EFFECT_TYPE_SILENCE,oTarget) && !GetHasEffect(EFFECT_TYPE_DEAF,oTarget))
         {
            if(GetIsNeutral(oTarget) || GetIsFriend(oTarget) && oTarget != oPC )
            {
                // oTarget is a friend, apply effects
                DelayCommand(0.9, ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget));
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(5));
            }

         }

        // Get next object in the sphere
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    }
}

