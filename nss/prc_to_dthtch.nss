//:: prc_to_deathtouch
//:://////////////////////////////////////////////
/*
    Thrall of Orcus may kill their foes.

    -Requires melee Touch attack
    -Save vs DC of 10 + Class Level + Cha bonus

*/


#include "NW_I0_SPELLS"
#include "X2_inc_switches"

void main()
{
    //Declare major variables
    object oTarget = GetSpellTargetObject();
    //object oCaster = GetCurrentHitPoints(OBJECT_SELF);
    int nCasterLvl = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetSpellCastItem()==OBJECT_INVALID?GetMetaMagicFeat():METAMAGIC_NONE;

    //Declare effects
    effect eSlay = EffectDeath();
    effect eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
    effect eVis2 = EffectVisualEffect(VFX_IMP_DEATH);
    int nClass = GetLevelByClass(CLASS_TYPE_ORCUS, OBJECT_SELF);
    int nCha = GetAbilityModifier(ABILITY_CHARISMA, OBJECT_SELF);
    int nSave = 10 + nCha + nClass;

    //Link effects

    if(TouchAttackMelee(oTarget,TRUE)>0)
    {
        //Signal spell cast at event
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 624));


        if ((GetCreatureSize(oTarget)>CREATURE_SIZE_LARGE )&& (GetModuleSwitchValue(MODULE_SWITCH_SPELL_CORERULES_DMASTERTOUCH) == TRUE))
        {
            return; // creature too large to be affected.
        }
        //CHECK RC
       if(!MyResistSpell(OBJECT_SELF, oTarget))
         {
          //Saving Throw
           if(!MySavingThrow(SAVING_THROW_FORT, oTarget, nSave, SAVING_THROW_TYPE_DEATH))
        {
            //Apply effects to target and caster
            if(GetHasSpellEffect(1329,oTarget))
               {
                SetImmortal(oTarget, FALSE);
               }
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eSlay, oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
        }
   }

}

 }
