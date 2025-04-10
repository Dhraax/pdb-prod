//::///////////////////////////////////////////////
//:: Entangle
//:: NW_S0_EntangleC.NSS
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Upon entering the AOE the target must make
    a reflex save or be entangled by vegitation
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: July 30, 2001
//:://////////////////////////////////////////////
//::Updated Aug 14, 2003 Georg: removed some artifacts
#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{

    //Declare major variables
    effect eHold = EffectEntangle();
    effect eEntangle = EffectVisualEffect(VFX_DUR_ENTANGLE);
    //Link Entangle and Hold effects
    effect eLink = EffectLinkEffects(eHold, eEntangle);
    int iSpellid = GetSpellId();
    int bValid;

    object oTarget = GetFirstInPersistentObject();

    while(GetIsObjectValid(oTarget))
    {  // SpawnScriptDebugger();
        if(!GetHasFeat(FEAT_WOODLAND_STRIDE, oTarget) &&(GetCreatureFlag(OBJECT_SELF, CREATURE_VAR_IS_INCORPOREAL) != TRUE) )
        {
            if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
            {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_ENTANGLE));
                //Make SR check
                if(!GetHasSpellEffect(SPELL_ENTANGLE, oTarget) && !GetHasSpellEffect(1548, oTarget))
                {
                    int iCD;
                    if(iSpellid == 1548)
                    {
                        int nCasterLvl = GetHitDice(GetAreaOfEffectCreator());
                        int nDruidLevel = GetLevelByClass(CLASS_TYPE_DRUID,GetAreaOfEffectCreator());
                        int nWizardLevel = GetLevelByClass(CLASS_TYPE_WIZARD,GetAreaOfEffectCreator());
                        int nSorcererLevel = GetLevelByClass(CLASS_TYPE_SORCERER,GetAreaOfEffectCreator());
                        int iAbility;

                        if(nDruidLevel >= nWizardLevel && nDruidLevel >= nSorcererLevel) {iAbility = ABILITY_WISDOM;}
                        else if(nWizardLevel >= nDruidLevel && nWizardLevel >= nSorcererLevel) {iAbility = ABILITY_INTELLIGENCE;}
                        else if(nSorcererLevel >= nWizardLevel && nSorcererLevel >= nDruidLevel) {iAbility = ABILITY_CHARISMA;}

                        iCD = 10 + nCasterLvl/3 + GetAbilityModifier(iAbility,GetAreaOfEffectCreator());
                    }
                    else iCD = GetSpellSaveDC() + GetChangesToSaveDC(OBJECT_SELF);
                    //Make reflex save
                    if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, iCD))
                    {
                       //Apply linked effects
                       ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(2));
                    }
                }
            }
        }
        //Get next target in the AOE
        oTarget = GetNextInPersistentObject();
    }
}
