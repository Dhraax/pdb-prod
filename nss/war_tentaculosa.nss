//::///////////////////////////////////////////////
//:: Evards Black Tentacles: On Enter
//:: NW_S0_EvardsA
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Upon entering the mass of rubbery tentacles the
    target is struck by 1d4 +1/lvl tentacles.  Each
    makes a grapple check. If it succeeds then
    it does 1d6+4damage and the target must make
    a Fortitude Save versus paralysis or be paralyzed
    for 1 round.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 23, 2001
//:://////////////////////////////////////////////
//:: GZ: Removed SR, its not there by the book

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "pb_nivellanzador"
#include "war_utilities"
#include "nwnx_damage"

void Tentaculos(object oTarget)
{
    struct NWNX_Damage_DamageData damage;
    damage.iPower = 10;
    damage.iBludgeoning = d6() + GetLevelByClass(57, GetAreaOfEffectCreator());
    damage.iCold = d6(2);
    float fDelay;

   if(GetLocalInt(oTarget, "TENTACULOS") == 1 )
     {
       fDelay = GetRandomDelay(1.0, 2.2);
       DelayCommand(fDelay, NWNX_Damage_DealDamage(damage, oTarget, OBJECT_SELF, TRUE));
       DelayCommand(6.0, Tentaculos(oTarget));
     }
    else return;

}
void main()
{

    object oTarget = GetEnteringObject();
    object oPC = GetAreaOfEffectCreator();
    effect eParal = EffectParalyze();
    effect eDur = EffectVisualEffect(VFX_DUR_PARALYZED);
    effect eLink = EffectLinkEffects(eDur, eParal);
    int iCarisma = GetAbilityModifier(ABILITY_CHARISMA, oPC);
    float fDelay;
    int nTargetSize;
    int nTentacleGrappleCheck;
    int nOpposedGrappleCheck;
    int nOppossedGrappleCheckModifiers;
    int nTentaclesPerTarget;
    int nCasterLevel = GetTotalCasterLevel(GetAreaOfEffectCreator());

    /*if ( GetCreatureSize(oTarget) < CREATURE_SIZE_MEDIUM )
    {
        // Some visual feedback that the spell doesn't affect creatures of this type.
        effect eFail = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
        fDelay = GetRandomDelay(0.75, 1.5);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFail, oTarget,fDelay);
        return;
    }  */

    if ( nCasterLevel > 20 )
    {
        nCasterLevel = 20;
    }

        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_EVARDS_BLACK_TENTACLES));

            //Tirada para paralizar
            nOppossedGrappleCheckModifiers = GetBaseAttackBonus(oTarget) + GetAbilityModifier(ABILITY_STRENGTH,oTarget);
            nTargetSize = GetCreatureSize(oTarget);
            if (nTargetSize == CREATURE_SIZE_LARGE )
            {
                nOppossedGrappleCheckModifiers = nOppossedGrappleCheckModifiers + 4;
            }
            else if ( nTargetSize = CREATURE_SIZE_HUGE )
            {
                nOppossedGrappleCheckModifiers = nOppossedGrappleCheckModifiers + 8;
            }

                // Comprobamos si lo paralizamos.
                nTentacleGrappleCheck = d20() + nCasterLevel + 8;
                nOpposedGrappleCheck = d20() + nOppossedGrappleCheckModifiers;

                if(nTentacleGrappleCheck >= nOpposedGrappleCheck)
                {
                   if(!MySavingThrow(SAVING_THROW_FORT, oTarget, 17 + iCarisma))
                      {
                        fDelay = GetRandomDelay(1.0, 2.2);
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(1)));
                      }
                }

            //Aplicamos el daño por asalto
            SetLocalInt(oTarget, "TENTACULOS", 1);
            Tentaculos(oTarget);
         }
}
