//::///////////////////////////////////////////////
//:: Blood Frenzy
//:: x0_s0_bldfrenzy.nss
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
 Similar to Barbarian Rage.
 +2 Strength, Con. +1 morale bonus to Will
 -1 AC
*/
//:://////////////////////////////////////////////
//:: Created By: Brent Knowles
//:: Created On: July 19, 2002
//:://////////////////////////////////////////////
//:: VFX Pass By:

#include "x2_inc_spellhook"
#include "nostack_inc"
#include "pb_nivellanzador"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);
/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook



    if(!GetHasSpellEffect(422))
    {
        //Declare major variables
        int nDuration = GetTotalCasterLevel(OBJECT_SELF);
        int nIncrease;
        int nSave;
        nIncrease = 2;
        nSave = 1;

        int nMetaMagic = GetSpellCastItem()==OBJECT_INVALID?GetMetaMagicFeat():METAMAGIC_NONE;
        if (nMetaMagic == METAMAGIC_EXTEND)
        {
            nDuration = nDuration * 2;
        }

        PlayVoiceChat(VOICE_CHAT_BATTLECRY1);

        effect eSave = EffectSavingThrowIncrease(SAVING_THROW_WILL, nSave);
        effect eAC = EffectACDecrease(1, AC_DODGE_BONUS);
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

        effect eLink = EffectLinkEffects(eSave, eAC);
        eLink = EffectLinkEffects(eLink, eDur);
        SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, 422, FALSE));
        //Make effect extraordinary
        eLink = MagicalEffect(eLink);
        effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE); //Change to the Rage VFX

        //Apply the VFX impact and effects
        DoNoStackAbilityBonus(OBJECT_SELF, OBJECT_SELF, nIncrease, ABILITY_STRENGTH, RoundsToSeconds(nDuration));
        DoNoStackAbilityBonus(OBJECT_SELF, OBJECT_SELF, nIncrease, ABILITY_CONSTITUTION, RoundsToSeconds(nDuration));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, RoundsToSeconds(nDuration));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF) ;
        DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    }
}
