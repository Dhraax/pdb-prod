//::///////////////////////////////////////////////
//:: DOTE DOMINIO DE ORCO
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Castigo orco del Dominio de Orco.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 21/08/2012
//:://////////////////////////////////////////////

void main()
{
    //Determine bonus amount
    int nBonus = GetLevelByClass(CLASS_TYPE_CLERIC);
    if(nBonus > 5) nBonus = nBonus + 10;
    if(nBonus > 30) nBonus = 30;

    //Declare effects
    effect eDanyo = EffectDamageIncrease(nBonus);
    effect eDanyoElfos = VersusRacialTypeEffect(EffectAttackIncrease(4), RACIAL_TYPE_ELF);
    effect eDanyoEnanos = VersusRacialTypeEffect(EffectAttackIncrease(4), RACIAL_TYPE_DWARF);
    effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    //Link effects
    effect eLink = EffectLinkEffects(eDanyo, eDanyoElfos);
    eLink = EffectLinkEffects(eLink, eDanyoEnanos);
    eLink = EffectLinkEffects(eLink, eDur);

    //Fire cast spell at event for the specified target
    SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

    //Apply effects
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, 12.0);
}

