//::///////////////////////////////////////////////
//:: Amplify
//:: x0_s0_amplify.nss
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The caster or target is able to hear sounds better.
    Listen skill increases by 20.
    DURATION: 1 round/level
*/
//:://////////////////////////////////////////////
//:: Created By: Brent Knowles
//:: Created On: July 30, 2002
//:://////////////////////////////////////////////

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
    object oTarget = GetSpellTargetObject();
    int nDuration = GetTotalCasterLevel(OBJECT_SELF); // * Duration 1 turn/level

    if((GetSpellCastItem()==OBJECT_INVALID?GetMetaMagicFeat():METAMAGIC_NONE) == METAMAGIC_EXTEND)    //Duration is +100%
    {
         nDuration = nDuration * 2;
    }

    //Fire spell cast at event for target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_AMPLIFY, FALSE));

    //Apply VFX impact and bonus effects
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE), oTarget);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE), oTarget, RoundsToSeconds(nDuration));
    DoNoStackSkillBonus(OBJECT_SELF, oTarget, 14, SKILL_LISTEN, RoundsToSeconds(nDuration),GetSpellId());
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");

}







