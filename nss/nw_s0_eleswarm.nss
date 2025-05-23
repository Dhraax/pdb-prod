//::///////////////////////////////////////////////
//:: Elemental Swarm
//:: NW_S0_EleSwarm.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This spell creates a conduit from the caster
    to the elemental planes.  The first elemental
    summoned is a 24 HD Air elemental.  Whenever an
    elemental dies it is replaced by the next
    elemental in the chain Air, Earth, Water, Fire
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 12, 2001
//:://////////////////////////////////////////////
//:: Update Pass By: Preston W, On: July 30, 2001

#include "x2_inc_spellhook"
#include "conv_inc"
#include "pb_nivellanzador"

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
    int nMetaMagic = GetSpellCastItem()==OBJECT_INVALID?GetMetaMagicFeat():METAMAGIC_NONE;
    int nCasterLevel = GetTotalCasterLevel(OBJECT_SELF);
    int nDuration = nCasterLevel;
    if(nDuration < 5) nDuration = 5;

    effect eSummon;
    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3);
    //Check for metamagic duration
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration * 2;  //Duration is +100%
    }
    //Set the summoning effect
    eSummon = EffectSwarm(FALSE, "NW_SW_AIRGREAT", "NW_SW_WATERGREAT","NW_SW_EARTHGREAT","NW_SW_FIREGREAT");
    //Apply the summon effect
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSummon, OBJECT_SELF, TurnsToSeconds(nDuration));

    // Aumentar convocacion
    DelayCommand(2.0, BonosConvocarCriatura());
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
