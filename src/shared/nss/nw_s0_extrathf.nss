//::///////////////////////////////////////////////
//:: Rogues Cunning AKA Potion of Extra Theiving
//:: NW_S0_ExtraThf.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Grants the user +10 Search, Disable Traps and
    Move Silently, Open Lock (+5), Pick Pockets
    Set Trap for 5 Turns
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: November 9, 2001
//:://////////////////////////////////////////////

#include "x2_inc_spellhook"
#include "nostack_inc"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);
/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
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
    object oTarget = GetSpellTargetObject();

    //Apply the VFX impact and effects
    DoNoStackSkillBonus(OBJECT_SELF, oTarget, 10, SKILL_SEARCH, TurnsToSeconds(5),GetSpellId());
    DoNoStackSkillBonus(OBJECT_SELF, oTarget, 10, SKILL_DISABLE_TRAP, TurnsToSeconds(5),GetSpellId());
    DoNoStackSkillBonus(OBJECT_SELF, oTarget, 10, SKILL_MOVE_SILENTLY, TurnsToSeconds(5),GetSpellId());
    DoNoStackSkillBonus(OBJECT_SELF, oTarget, 10, SKILL_OPEN_LOCK, TurnsToSeconds(5),GetSpellId());
    DoNoStackSkillBonus(OBJECT_SELF, oTarget, 10, SKILL_PICK_POCKET, TurnsToSeconds(5),GetSpellId());
    DoNoStackSkillBonus(OBJECT_SELF, oTarget, 10, SKILL_SET_TRAP, TurnsToSeconds(5),GetSpellId());
    DoNoStackSkillBonus(OBJECT_SELF, oTarget, 10, SKILL_HIDE, TurnsToSeconds(5),GetSpellId());
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE), oTarget, TurnsToSeconds(5));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_MAGICAL_VISION), oTarget);
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
