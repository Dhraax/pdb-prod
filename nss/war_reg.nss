//Regeneracin Brujo //

void main()
{

    //Declare major variables
    int nDuration = 2;
    int nWarlock = GetLevelByClass(57);

    int nHealAmt;
    if(nWarlock > 17) nHealAmt = 5;
    else if(nWarlock > 12) nHealAmt = 2;
    else if(nWarlock > 7)  nHealAmt = 1;

    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    effect eFastHeal = EffectRegenerate(nHealAmt, RoundsToSeconds(1));
    effect eLink = EffectLinkEffects(eFastHeal, eDur);

    //Fire cast spell at event for the specified target
    SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, SPELL_MONSTROUS_REGENERATION , FALSE));

    //Apply the VFX impact and effect
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, TurnsToSeconds(nDuration));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEAD_NATURE), OBJECT_SELF);
}
