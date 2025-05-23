//Suerte del Oscuro Brujo //


#include "x2_inc_spellhook"
#include "war_utilities"

void main()
{

if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

if (!CheckWarlockSpellCharisma()) return;

  object oPC = OBJECT_SELF;

    //Suerte del Oscuro
    int iCarisma = GetAbilityModifier(ABILITY_CHARISMA, oPC);
    effect eSaveF = EffectSavingThrowIncrease(SAVING_THROW_FORT, iCarisma, SAVING_THROW_TYPE_NONE);
    effect eSaveR = EffectSavingThrowIncrease(SAVING_THROW_REFLEX, iCarisma, SAVING_THROW_TYPE_NONE);
    effect eSaveV = EffectSavingThrowIncrease(SAVING_THROW_WILL, iCarisma, SAVING_THROW_TYPE_NONE);
    effect eSaveALL = EffectLinkEffects(eSaveF, eSaveR);
    eSaveALL = EffectLinkEffects(eSaveALL, eSaveV);

    //Fire cast spell at event for the specified target
    SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_MONSTROUS_REGENERATION , FALSE));

    //Apply the VFX impact and effect
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSaveALL, oPC, HoursToSeconds(24));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(1728), oPC);
}
