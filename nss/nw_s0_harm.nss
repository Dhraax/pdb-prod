//::///////////////////////////////////////////////
//:: [Harm]
//:: [NW_S0_Harm.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Reduces target to 1d4 HP on successful touch
//:: attack.  If the target is undead it is healed.
//:://////////////////////////////////////////////
//:: Created By: Keith Soleski
//:: Created On: Jan 18, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001
//:: Update Pass By: Preston W, On: Aug 1, 2001
//:: Last Update: Georg Zoeller On: Oct 10, 2004
//:://////////////////////////////////////////////

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"
//#include "mti_libreria"

// return TRUE if the effect created by a supernatural force and can't be dispelled by spells
int GetIsSupernaturalCurse(effect eEff);

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_NECROMANCY);
/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

    //Declare major variables
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = GetTotalCasterLevel(OBJECT_SELF);
    int nDamage, nHeal;
    int nMetaMagic = GetSpellCastItem()==OBJECT_INVALID?GetMetaMagicFeat():METAMAGIC_NONE;
    int nTouch = TouchAttackMelee(oTarget);
    effect eVis = EffectVisualEffect(246);
    effect eVis2 = EffectVisualEffect(VFX_IMP_HEALING_G);
    effect eHeal, eDam;

    if (nCasterLevel > 15) nCasterLevel = 15;

    //Check that the target is undead
    if (PB_Race_GetIsUndead(oTarget))
    {
        if(GetLocalInt(oTarget, "dm_nocurar") != 1)
        {
            //MONTI, D&D 3.5
            nHeal = nCasterLevel * 10;

            //Set the heal effect
            eHeal = EffectHeal(nHeal);
            //Apply heal effect and VFX impact
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);


            effect eBad = GetFirstEffect(oTarget);
            //Search for negative effects
            while(GetIsEffectValid(eBad))
            {
                if (GetEffectType(eBad) == EFFECT_TYPE_ABILITY_DECREASE ||
                    GetEffectType(eBad) == EFFECT_TYPE_BLINDNESS ||
                    GetEffectType(eBad) == EFFECT_TYPE_DEAF ||
                    GetEffectType(eBad) == EFFECT_TYPE_DAZED ||
                    GetEffectType(eBad) == EFFECT_TYPE_CONFUSED)
                {
                    //Remove effect if it is negative.
                    if(!GetIsSupernaturalCurse(eBad))
                    RemoveEffect(oTarget, eBad);
                }
            eBad = GetNextEffect(oTarget);
            }
        }
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HARM, FALSE));
        // APLICAMOS LOS EFECTOS DE LAS SUBRAZAS, MONTURAS Y ARMADURAS
        //ReaplicarEfectosPB(oTarget);
    }
    else if (nTouch != FALSE)  //GZ: Fixed boolean check to work in NWScript. 1 or 2 are valid return numbers from TouchAttackMelee
    {
        if(!GetIsReactionTypeFriendly(oTarget))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HARM));
            if (!MyResistSpell(OBJECT_SELF, oTarget))
            {
                //MONTI, D&D 3.5
                nDamage = nCasterLevel * 10;

                if(nTouch == 2)
                      {
                        nDamage *= 2;
                      }
                if(WillSave(oTarget, (GetSpellSaveDC()+ GetChangesToSaveDC(OBJECT_SELF)), SAVING_THROW_TYPE_NEGATIVE))
                    {
                        nDamage = nDamage/2;
                    }
                if(GetCurrentHitPoints(oTarget) <= nDamage)
                {
                    //Check for metamagic
                    if(nMetaMagic == METAMAGIC_MAXIMIZE) nDamage = GetCurrentHitPoints(oTarget) - 1;
                    else nDamage = GetCurrentHitPoints(oTarget) - 1;
                }

                eDam = EffectDamage(nDamage,DAMAGE_TYPE_NEGATIVE);
                //Apply the VFX impact and effects
                DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
            }
        }
    }
}
int GetIsSupernaturalCurse(effect eEff)
{
    object oCreator = GetEffectCreator(eEff);
    if(GetTag(oCreator) == "q6e_ShaorisFellTemple")
        return TRUE;
    return FALSE;
}
