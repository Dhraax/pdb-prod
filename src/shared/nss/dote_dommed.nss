//::///////////////////////////////////////////////
//:: DOTE DOMINIO DE MEDIANO
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Maestria mediana del Dominio de Mediano.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 21/08/2012
//:://////////////////////////////////////////////

void main()
{
    //Determine bonus amount
    int nBonus = GetAbilityModifier(ABILITY_CHARISMA);

    //Declare effects
    effect eMoverse = EffectSkillIncrease(SKILL_MOVE_SILENTLY, nBonus);
    effect eEsconderse = EffectSkillIncrease(SKILL_HIDE, nBonus);
    effect eSaltar = EffectSkillIncrease(26, nBonus);
    effect eTrepar = EffectSkillIncrease(37, nBonus);
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_NATURE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEUTRAL);

    //Link effects
    effect eLink = EffectLinkEffects(eMoverse, eEsconderse);
    eLink = EffectLinkEffects(eLink, eSaltar);
    eLink = EffectLinkEffects(eLink, eTrepar);
    eLink = EffectLinkEffects(eLink, eDur);

    //Fire cast spell at event for the specified target
    SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

    //Apply effects
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, 300.0);
}
