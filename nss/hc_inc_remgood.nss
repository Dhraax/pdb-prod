// hcr3.1
// took out old subrace code.
//sr6.1
// script to remove good effects.


void RemoveGoodEffects(object oTarget)
{
    //Declare major variables
    effect eVisual = EffectVisualEffect(VFX_IMP_RESTORATION);
    int bValid;
    effect eGood = GetFirstEffect(oTarget);
    //Search for negative effects
    while(GetIsEffectValid(eGood))
    {
        int nEtype=GetEffectType(eGood);
        if (nEtype != EFFECT_TYPE_ABILITY_DECREASE &&
            nEtype != EFFECT_TYPE_CHARMED  &&
            nEtype != EFFECT_TYPE_CURSE  &&
            nEtype != EFFECT_TYPE_DOMINATED  &&
            nEtype != EFFECT_TYPE_DARKNESS  &&
            nEtype != EFFECT_TYPE_ENTANGLE  &&
            nEtype != EFFECT_TYPE_MOVEMENT_SPEED_DECREASE  &&
            nEtype != EFFECT_TYPE_AC_DECREASE &&
            nEtype != EFFECT_TYPE_ATTACK_DECREASE &&
            nEtype != EFFECT_TYPE_DAMAGE_DECREASE &&
            nEtype != EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE &&
            nEtype != EFFECT_TYPE_SAVING_THROW_DECREASE &&
            nEtype != EFFECT_TYPE_SPELL_RESISTANCE_DECREASE &&
            nEtype != EFFECT_TYPE_SKILL_DECREASE &&
            nEtype != EFFECT_TYPE_BLINDNESS &&
            nEtype != EFFECT_TYPE_DEAF &&
            nEtype != EFFECT_TYPE_PARALYZE &&
            nEtype != EFFECT_TYPE_NEGATIVELEVEL &&
            nEtype != EFFECT_TYPE_FRIGHTENED &&
            nEtype != EFFECT_TYPE_DAZED &&
            nEtype != EFFECT_TYPE_CONFUSED &&
            nEtype != EFFECT_TYPE_POISON &&
            nEtype != EFFECT_TYPE_PARALYZE  &&
            nEtype != EFFECT_TYPE_SLOW  &&
            nEtype != EFFECT_TYPE_SLEEP  &&
            nEtype != EFFECT_TYPE_STUNNED  &&
            nEtype != EFFECT_TYPE_TURNED  &&
            nEtype != EFFECT_TYPE_SILENCE  &&
            nEtype != EFFECT_TYPE_DISEASE
            )
             {
                // 5.5 Lorinton change, use RemoveEffect and then respawn the subrace
                //Remove effect if it is negative.
                // 5.5.1
                // hcr3.1
                if (GetEffectSubType(eGood) != SUBTYPE_EXTRAORDINARY)
                    RemoveEffect( oTarget, eGood );
             }
        eGood = GetNextEffect(oTarget);
    }
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_RESTORATION, FALSE));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oTarget);

}
