//::///////////////////////////////////////////////
//:: Legend Lore
//:: NW_S0_Lore.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Gives the caster a boost to Lore skill of 10
    plus 1 / 2 caster levels.  Lasts for 1 Turn per
    caster level.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 22, 2001
//:://////////////////////////////////////////////
//:: 2003-10-29: GZ: Corrected spell target object
//::             so potions work wit henchmen now

#include "x2_inc_spellhook"
#include "nostack_inc"
#include "pb_nivellanzador"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_DIVINATION);
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
    int nLevel = GetTotalCasterLevel(oTarget);
    int nBonus = 10 + (nLevel / 2);

    //Meta-Magic checks
    if((GetSpellCastItem()==OBJECT_INVALID?GetMetaMagicFeat():METAMAGIC_NONE) == METAMAGIC_EXTEND)
    {
        nLevel *= 2;
    }

    //Make sure the spell has not already been applied
    if(!GetHasSpellEffect(SPELL_IDENTIFY, oTarget) || !GetHasSpellEffect(SPELL_LEGEND_LORE, oTarget))
    {
         SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_LEGEND_LORE, FALSE));

         //Apply linked and VFX effects
         DoNoStackSkillBonus(OBJECT_SELF, oTarget, nBonus, SKILL_LORE, TurnsToSeconds(nLevel),GetSpellId());
         ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE), oTarget, TurnsToSeconds(nLevel));
         ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_MAGICAL_VISION), oTarget);
         DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    }
}

