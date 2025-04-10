//Seduccion Brujo //

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

    //Declare major variables
    effect eInvSeduccion = EffectSkillIncrease(SKILL_BLUFF, 6);
           eInvSeduccion = EffectLinkEffects(eInvSeduccion, EffectSkillIncrease(SKILL_INTIMIDATE, 6));
           eInvSeduccion = EffectLinkEffects(eInvSeduccion, EffectSkillIncrease(SKILL_PERSUADE, 6));

    //Fire cast spell at event for the specified target
    SignalEvent(oPC, EventSpellCastAt(oPC, SPELL_MONSTROUS_REGENERATION , FALSE));

    //Apply the VFX impact and effect
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eInvSeduccion, oPC, HoursToSeconds(24));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(1227), oPC);
}
