//::///////////////////////////////////////////////
//:: Web: Heartbeat
//:: NW_S0_WebC.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates a mass of sticky webs that cling to
    and entangle targets who fail a Reflex Save
    Those caught can make a new save every
    round.  Movement in the web is 1/5 normal.
    The higher the creatures Strength the faster
    they move within the web.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 8, 2001
//:://////////////////////////////////////////////

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "lib_disguise"

void main()
{

    //Declare major variables
    effect eWeb = EffectEntangle();
    effect eVis = EffectVisualEffect(VFX_DUR_WEB);
    object oTarget;
    int iSpellid = GetSpellId();
    //Spell resistance check
    oTarget = GetFirstInPersistentObject();
    while(GetIsObjectValid(oTarget))
    {
        //Inmunidad de la forma de Araña Gigante (193) y Araña Gargantuesca (195) del MMF
        if(ObtenerIntPersistente(oTarget,"POLYMORPHED_FORM")== 193 || ObtenerIntPersistente(oTarget,"POLYMORPHED_FORM")== 195)
        {
            SendMessageToPC(oTarget,StringToRGBString(PB_Disguise_GetNameOverride(oTarget)+": inmune a Telaraña.","637"));
            SendMessageToPC(GetAreaOfEffectCreator(),StringToRGBString(PB_Disguise_GetNameOverride(oTarget)+": inmune a Telaraña.","637"));
            return;
        }
        if(!GetHasFeat(FEAT_WOODLAND_STRIDE, oTarget) &&(GetCreatureFlag(oTarget, CREATURE_VAR_IS_INCORPOREAL) != TRUE) )
        {
            if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
            {
            // *************
            // * Patch Fix
            // * Brent
            // * Moved the two spell cast events down after the reaction check check
                //Fire cast spell at event for the target
                SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), SPELL_WEB));
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_WEB));

                if(iSpellid == 1544) //Casted by MMF as a special ability
                {
                    int nCasterLvl = GetHitDice(GetAreaOfEffectCreator());
                    int nDruidLevel = GetLevelByClass(CLASS_TYPE_DRUID,GetAreaOfEffectCreator());
                    int nWizardLevel = GetLevelByClass(CLASS_TYPE_WIZARD,GetAreaOfEffectCreator());
                    int nSorcererLevel = GetLevelByClass(CLASS_TYPE_SORCERER,GetAreaOfEffectCreator());
                    int iAbility;

                    if(nDruidLevel >= nWizardLevel && nDruidLevel >= nSorcererLevel) {iAbility = ABILITY_WISDOM;}
                    else if(nWizardLevel >= nDruidLevel && nWizardLevel >= nSorcererLevel) {iAbility = ABILITY_INTELLIGENCE;}
                    else if(nSorcererLevel >= nWizardLevel && nSorcererLevel >= nDruidLevel) {iAbility = ABILITY_CHARISMA;}

                    int iCD = 10 + nCasterLvl/3 + GetAbilityModifier(iAbility,GetAreaOfEffectCreator());
                    //Make a Fortitude Save to avoid the effects of the entangle.
                    if(!/*Reflex Save*/ MySavingThrow(SAVING_THROW_REFLEX, oTarget, iCD))
                    {
                        //Entangle effect and Web VFX impact
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eWeb, oTarget, RoundsToSeconds(1));
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, RoundsToSeconds(1));
                    }
                }
                else //Normal spells.
                {
                    if(!MyResistSpell(GetAreaOfEffectCreator(), oTarget))
                    {
                        //Make a Fortitude Save to avoid the effects of the entangle.
                        if(!/*Reflex Save*/ MySavingThrow(SAVING_THROW_REFLEX, oTarget, GetSpellSaveDC()+ GetChangesToSaveDC(OBJECT_SELF)))
                        {
                            //Entangle effect and Web VFX impact
                            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eWeb, oTarget, RoundsToSeconds(1));
                            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, RoundsToSeconds(1));
                        }
                    }
                }
            }
        }
        oTarget = GetNextInPersistentObject();
    }
}
