//::///////////////////////////////////////////////
//:: Aura of Fear On Enter
//:: NW_S1_DragFearA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Upon entering the aura of the creature the player
    must make a will save or be struck with fear because
    of the creatures presence.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 25, 2001
//:: LastUpdated: 24, Oct 2003, GeorgZ
//:://////////////////////////////////////////////
#include "NW_I0_SPELLS"
#include "mti_libreria"

void main()
{
    //Declare major variables
    object oTarget = GetEnteringObject();
    effect eVis = EffectVisualEffect(VFX_IMP_FEAR_S);
    effect eDur = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);
    effect eDur2 = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eFear = EffectFrightened();
    effect eLink = EffectLinkEffects(eFear, eDur);
    eLink = EffectLinkEffects(eLink, eDur2);

    //Ajustes para cuando lo usa el MMF
    int nHD = GetHitDice(GetAreaOfEffectCreator());
    int iCD;
    if(ObtenerIntPersistente(GetAreaOfEffectCreator(),"POLYMORPHED") && ObtenerIntPersistente(GetAreaOfEffectCreator(),"POLYMORPHED_FORM")>= 207 &&
        ObtenerIntPersistente(GetAreaOfEffectCreator(),"POLYMORPHED_FORM")<= 216) //Polymorphed + dragon form
    {
        int nCasterLvl =nHD;
        int nDruidLevel = GetLevelByClass(CLASS_TYPE_DRUID,GetAreaOfEffectCreator());
        int nWizardLevel = GetLevelByClass(CLASS_TYPE_WIZARD,GetAreaOfEffectCreator());
        int nSorcererLevel = GetLevelByClass(CLASS_TYPE_SORCERER,GetAreaOfEffectCreator());
        int iAbility;

        if(nDruidLevel >= nWizardLevel && nDruidLevel >= nSorcererLevel) {iAbility = ABILITY_WISDOM;}
        else if(nWizardLevel >= nDruidLevel && nWizardLevel >= nSorcererLevel) {iAbility = ABILITY_INTELLIGENCE;}
        else if(nSorcererLevel >= nWizardLevel && nSorcererLevel >= nDruidLevel) {iAbility = ABILITY_CHARISMA;}

        iCD = 10 + nCasterLvl/3 + GetAbilityModifier(iAbility,GetAreaOfEffectCreator());
    }
    else iCD = GetDragonFearDC(GetHitDice(GetAreaOfEffectCreator()));//10 + GetHitDice(GetAreaOfEffectCreator())/3;
    int nDC = iCD;

    int nDuration = GetScaledDuration(nHD, oTarget);
    //--------------------------------------------------------------------------
    // Capping at 20
    //--------------------------------------------------------------------------
    if (nDuration > 20)
    {
        nDuration = 20;
    }
    //--------------------------------------------------------------------------
    // Yaron does not like the stunning beauty of a very specific dragon to
    // last more than 10 rounds ....
    //--------------------------------------------------------------------------
    if (GetTag(GetAreaOfEffectCreator()) == "q3_vixthra")
    {
        nDuration = 3+d6();
    }

    if(GetIsEnemy(oTarget, GetAreaOfEffectCreator()))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), SPELLABILITY_AURA_FEAR));
        //Make a saving throw check
        if(!MySavingThrow(SAVING_THROW_WILL, oTarget, iCD, SAVING_THROW_TYPE_FEAR))
        {
            //Apply the VFX impact and effects
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        }
    }
}

