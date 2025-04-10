//::///////////////////////////////////////////////
//:: DOTE DOMINIO DE GNOMO
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Imagen ilusoria del Dominio de Gnomo.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 21/08/2012
//:://////////////////////////////////////////////

void main()
{
    int nDuration = GetAbilityModifier(ABILITY_CHARISMA) + GetLevelByClass(CLASS_TYPE_CLERIC);
    effect eInvis = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
    effect eVis = EffectVisualEffect(VFX_DUR_INVISIBILITY);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eCover = EffectConcealment(50);
    effect eLink = EffectLinkEffects(eDur, eCover);
    eLink = EffectLinkEffects(eLink, eVis);

    //Fire cast spell at event for the specified target
    SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

    //Apply the VFX impact and effects
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEAD_MIND), OBJECT_SELF);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, RoundsToSeconds(nDuration));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eInvis, OBJECT_SELF, RoundsToSeconds(nDuration));
}
