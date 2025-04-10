//::///////////////////////////////////////////////
//:: DOTE DOMINIO DE SUERTE
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Buena fortuna del Dominio de Suerte.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 3 de Noviembre de 2011
//:://////////////////////////////////////////////

void main()
{
    //Determine bonus amount
    int nBonus = GetLevelByClass(CLASS_TYPE_CLERIC);
    nBonus /= 5;
    nBonus = nBonus + 1;

    //Declare effects
    effect eSalvaciones = EffectSavingThrowIncrease(SAVING_THROW_ALL, nBonus);
    effect eCA = EffectACIncrease(nBonus);
    effect eVis = EffectVisualEffect(VFX_IMP_KNOCK);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEUTRAL);

    //Link effects
    effect eLink = EffectLinkEffects(eSalvaciones, eCA);
    eLink = EffectLinkEffects(eLink, eDur);

    //Fire cast spell at event for the specified target
    SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

    //Determined duration
    int nDuration = GetAbilityModifier(ABILITY_CHARISMA) + 5;
    //Apply effects
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, RoundsToSeconds(nDuration));
}

