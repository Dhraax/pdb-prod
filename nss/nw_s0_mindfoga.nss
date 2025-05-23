//::///////////////////////////////////////////////
//:: Mind Fog: On Enter
//:: NW_S0_MindFogA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates a bank of fog that lowers the Will save
    of all creatures within who fail a Will Save by
    -10.  Affect lasts for 2d6 rounds after leaving
    the fog
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 1, 2001
//:://////////////////////////////////////////////

#include "X0_I0_SPELLS"


void HeartBeat(object oTarget, effect eLink, int iSpellid)
{
    if(GetIsObjectValid(GetLocalObject(OBJECT_SELF,GetName(oTarget))) || GetLocalInt(oTarget, "AOE_PER_FOGMIND") == 1)
    {
        int bValid = FALSE;
        float fDelay = GetRandomDelay(1.0, 2.2);
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_MIND_FOG));
            effect eAOE = GetFirstEffect(oTarget);
            if(GetHasSpellEffect(SPELL_MIND_FOG, oTarget) || GetHasSpellEffect(1547, oTarget) )
            {
                while (GetIsEffectValid(eAOE))
                {
                    //If the effect was created by the Mind_Fog then remove it
                    if ((GetEffectSpellId(eAOE) == SPELL_MIND_FOG || GetEffectSpellId(eAOE) == 1547)  && GetAreaOfEffectCreator() == GetEffectCreator(eAOE))
                    {
                        if(GetEffectType(eAOE) == EFFECT_TYPE_SAVING_THROW_DECREASE)
                        {
                            RemoveEffect(oTarget, eAOE);
                            bValid = TRUE;
                        }
                    }
                    //Get the next effect on the creation
                    eAOE = GetNextEffect(oTarget);
                }
            //Check if the effect has been put on the creature already.  If no, then save again
            //If yes, apply without a save.
            }
            if(bValid == FALSE)
            {
                int iCD;
                if(iSpellid == 1547)
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
                else iCD = GetSpellSaveDC()+ GetChangesToSaveDC(OBJECT_SELF);
                //Make Will save to negate
                if(!MySavingThrow(SAVING_THROW_WILL, oTarget, iCD, SAVING_THROW_TYPE_MIND_SPELLS))
                {
                    if ( GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, GetAreaOfEffectCreator()) == FALSE )
                    {
                        //Apply VFX impact and lowered save effect
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget));
                    }
                }

            }
            else
            {
                if ( GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, GetAreaOfEffectCreator()) == FALSE )
                {
                    //Apply VFX impact and lowered save effect
                    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
                }
            }
            DelayCommand(6.0,HeartBeat(oTarget, eLink,iSpellid));
        }
    }
}



void main()
{

    //Declare major variables
    object oTarget = GetEnteringObject();
    effect eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    effect eLower = EffectSavingThrowDecrease(SAVING_THROW_WILL, 10);
    effect eLink = EffectLinkEffects(eVis, eLower);
    int iSpellid = GetSpellId();
    int bValid = FALSE;
    float fDelay = GetRandomDelay(1.0, 2.2);
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_MIND_FOG));
        //Make SR check
        effect eAOE = GetFirstEffect(oTarget);
        if(GetHasSpellEffect(SPELL_MIND_FOG, oTarget) || GetHasSpellEffect(1547, oTarget))
        {
            while (GetIsEffectValid(eAOE))
            {
                //If the effect was created by the Mind_Fog then remove it
                if ((GetEffectSpellId(eAOE) == SPELL_MIND_FOG || GetEffectSpellId(eAOE) == 1547) && GetAreaOfEffectCreator() == GetEffectCreator(eAOE))
                {
                    if(GetEffectType(eAOE) == EFFECT_TYPE_SAVING_THROW_DECREASE)
                    {
                        RemoveEffect(oTarget, eAOE);
                        bValid = TRUE;
                    }
                }
                //Get the next effect on the creation
                eAOE = GetNextEffect(oTarget);
            }
        //Check if the effect has been put on the creature already.  If no, then save again
        //If yes, apply without a save.
        }
        if(bValid == FALSE)
        {
            int iCD;
            if(iSpellid == 1547)
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
            else iCD = GetSpellSaveDC()+ GetChangesToSaveDC(OBJECT_SELF);
            //Make Will save to negate
            if(!MySavingThrow(SAVING_THROW_WILL, oTarget, iCD, SAVING_THROW_TYPE_MIND_SPELLS))
            {
                if ( GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, GetAreaOfEffectCreator()) == FALSE )
                {
                    //Apply VFX impact and lowered save effect
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget));
                }
            }
        }
        else
        {
            if ( GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, GetAreaOfEffectCreator()) == FALSE )
            {
                //Apply VFX impact and lowered save effect
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
            }
        }
        //Guardamos en el área de efecto al objetivo, para saber si aún está dentro.
        if(GetIsPC(oTarget)){SetLocalObject(OBJECT_SELF,GetName(oTarget),oTarget);}
        else if(!GetIsPC(oTarget)){SetLocalInt(oTarget, "AOE_PER_FOGMIND",1);}
        //HeartBeat cada 6 segundos.
        DelayCommand(6.0,HeartBeat(oTarget, eLink, iSpellid));
    }
}
