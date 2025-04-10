//::///////////////////////////////////////////////
//:: Shield
//:: x0_s0_shield.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Immune to magic Missiles
    +4 general AC
    DIFFERENCES: should be +7 against one opponent
    but this cannot be done.
    Duration: 1 turn/level
*/
//:://////////////////////////////////////////////
//:: Created By: Brent Knowles
//:: Created On: July 15, 2002
//:://////////////////////////////////////////////
//:: Last Update By: Andrew Nobbs May 01, 2003
#include "x0_i0_spells"
#include "x2_inc_spellhook"
#include "pb_nivellanzador"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ABJURATION);
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
    effect eVis = EffectVisualEffect(VFX_IMP_AC_BONUS);
    int nMetaMagic = GetSpellCastItem()==OBJECT_INVALID?GetMetaMagicFeat():METAMAGIC_NONE;

    effect eArmor = EffectACIncrease(4, AC_SHIELD_ENCHANTMENT_BONUS);
    effect eSpell1 = EffectSpellImmunity(SPELL_MAGIC_MISSILE);
    effect eSpell2 = EffectSpellImmunity(SPELL_ISAACS_GREATER_MISSILE_STORM);
    effect eSpell3 = EffectSpellImmunity(SPELL_ISAACS_LESSER_MISSILE_STORM);
    effect eDur = EffectVisualEffect(4); /*tocado por ukiah, antes: VFX_DUR_GLOBE_MINOR*/

    effect eLink = EffectLinkEffects(eArmor, eDur);
    eLink = EffectLinkEffects(eLink, eSpell1);
    eLink = EffectLinkEffects(eLink, eSpell2);
    eLink = EffectLinkEffects(eLink, eSpell3);

    int nDuration = GetTotalCasterLevel(OBJECT_SELF); // * Duration 1 turn
    if (nMetaMagic == METAMAGIC_EXTEND) //Duration is +100%
    {
         nDuration = nDuration * 2;
    }
    //Fire spell cast at event for target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 417, FALSE));

    RemoveEffectsFromSpell(OBJECT_SELF, GetSpellId());

    //Apply VFX impact and bonus effects
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration));
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}



