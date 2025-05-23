//::///////////////////////////////////////////////
//:: Thrall of Orcus Carrion Stench
//:: prc_to_carrionA.nss
//:://////////////////////////////////////////////
/*
    Creatures entering the area around the Thrall
    must save or be cursed with Doom
*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: July 11, 2004
//:://////////////////////////////////////////////

#include "NW_I0_SPELLS"
#include "pb_nivellanzador"

void main()
{
    //Declare major variables
    object oTarget = GetEnteringObject();
    effect eVis = EffectVisualEffect(VFX_IMP_DOOM);
    effect eAttackDecrease = EffectAttackDecrease(2);
    effect eAbilityDecrease = EffectAttackDecrease(2);

    int nDC = (10 + GetLevelByClass(CLASS_TYPE_ORCUS, GetAreaOfEffectCreator()) + GetAbilityModifier(ABILITY_CONSTITUTION, GetAreaOfEffectCreator()));
    int nDur = GetLevelByClass(CLASS_TYPE_ORCUS, GetAreaOfEffectCreator());


           // if(GetHasSpellEffect(1148, oPC) == FALSE) return;
            if(GetIsEnemy(oTarget, GetAreaOfEffectCreator()))
            {
                //Make a saving throw check
                if(!MySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_POISON))
                {
                    //Apply the VFX impact and effects
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

                 // Apply the effect to the object
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSavingThrowDecrease(SAVING_THROW_ALL, 2), oTarget, RoundsToSeconds(nDur));
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAttackDecrease, oTarget, RoundsToSeconds(nDur));
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAbilityDecrease, oTarget, RoundsToSeconds(nDur));
                }
            }
}

