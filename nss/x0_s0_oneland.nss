//::///////////////////////////////////////////////
//:: One with the Land
//:: x0_s0_oneland.nss
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
 bonus +3: animal empathy, move silently, search, hide
 Duration: 1 hour/level
*/
//:://////////////////////////////////////////////
//:: Created By: Brent Knowles
//:: Created On: July 19, 2002
//:://////////////////////////////////////////////
//:: Last Update By: Andrew Nobbs May 01, 2003

#include "NW_I0_SPELLS"
#include "nostack_inc"
#include "x2_inc_spellhook"
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

    //Declare major variables
    object oTarget = OBJECT_SELF;
    int nDuration = GetTotalCasterLevel(OBJECT_SELF); // * Duration 1 hour/level

    if((GetSpellCastItem()==OBJECT_INVALID?GetMetaMagicFeat():METAMAGIC_NONE) == METAMAGIC_EXTEND)    //Duration is +100%
    {
         nDuration = nDuration * 2;
    }

    //Fire spell cast at event for target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 420, FALSE));

    //Apply VFX impact and bonus effects
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE), oTarget);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE), oTarget, HoursToSeconds(nDuration));

    RemoveMagicSkillBonus(OBJECT_SELF, 36);
    DoNoStackSkillBonus(OBJECT_SELF, oTarget, 4, SKILL_ANIMAL_EMPATHY, HoursToSeconds(nDuration),GetSpellId());
    DoNoStackSkillBonus(OBJECT_SELF, oTarget, 4, SKILL_HIDE, HoursToSeconds(nDuration),GetSpellId());
    DoNoStackSkillBonus(OBJECT_SELF, oTarget, 4, SKILL_MOVE_SILENTLY, HoursToSeconds(nDuration),GetSpellId());
    DoNoStackSkillBonus(OBJECT_SELF, oTarget, 4, SKILL_SET_TRAP, HoursToSeconds(nDuration),GetSpellId());
    DoNoStackSkillBonus(OBJECT_SELF, oTarget, 4, 36, HoursToSeconds(nDuration),GetSpellId());
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
