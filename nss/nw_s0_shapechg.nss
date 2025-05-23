//::///////////////////////////////////////////////
//:: Shapechange
//:: NW_S0_ShapeChg.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 22, 2002
//:://////////////////////////////////////////////

#include "x2_inc_spellhook"
#include "pb_nivellanzador"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);
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
    int nSpell = GetSpellId();
    object oTarget = GetSpellTargetObject();
    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3);
    effect ePoly;
    int nPoly;
    int nMetaMagic = GetSpellCastItem()==OBJECT_INVALID?GetMetaMagicFeat():METAMAGIC_NONE;
    int nDuration = GetCasterLevel(OBJECT_SELF);
    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2; //Duration is +100%
    }

    //Determine Polymorph subradial type
    if(nSpell == 392)
    {
        //Get the alignment of the caster
        int nAlign = GetAlignmentGoodEvil(OBJECT_SELF);
        float fDelay = 3.0;
        switch (nAlign)
        {
            //Set the polimorph effect based on alignment
            case ALIGNMENT_EVIL:
                {
                    nPoly = POLYMORPH_TYPE_RED_DRAGON;
                }
            break;
            case ALIGNMENT_GOOD:
                {
                    nPoly = 108;
                }
            break;
            case ALIGNMENT_NEUTRAL:
                {
                    nPoly = 107;
                }
            break;
        }
    }
    else if (nSpell == 393)
    {
        nPoly = POLYMORPH_TYPE_FIRE_GIANT;
    }
    else if (nSpell == 394)
    {
        nPoly = POLYMORPH_TYPE_BALOR;
    }
    else if (nSpell == 395)
    {
        nPoly = POLYMORPH_TYPE_DEATH_SLAAD;
    }
    else if (nSpell == 396)
    {
        nPoly = POLYMORPH_TYPE_IRON_GOLEM;
    }
    ePoly = EffectPolymorph(nPoly);
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SHAPECHANGE, FALSE));

    //Apply the VFX impact and effects
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oTarget));
    DelayCommand(0.4, AssignCommand(oTarget, ClearAllActions())); // prevents an exploit
    DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePoly, oTarget, TurnsToSeconds(nDuration)));
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
