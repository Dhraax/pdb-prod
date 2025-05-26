//::///////////////////////////////////////////////
//:: Delayed Blast Fireball: On Enter
//:: NW_S0_DelFireA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The caster creates a trapped area which detects
    the entrance of enemy creatures into 3 m area
    around the spell location.  When tripped it
    causes a fiery explosion that does 1d6 per
    caster level up to a max of 20d6 damage.
*/
//:://////////////////////////////////////////////
//:: Georg: Removed Spellhook, fixed damage cap
//:: Created By: Preston Watamaniuk
//:: Created On: July 27, 2001
//:://////////////////////////////////////////////

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "pb_nivellanzador"

void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);

    object oTarget = GetEnteringObject();
    object oCaster = GetAreaOfEffectCreator();
    location lTarget = GetLocation(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();
    int nCasterLevel = GetTotalCasterLevel(oCaster);
    int nFire = GetLocalInt(OBJECT_SELF, "NW_SPELL_DELAY_BLAST_FIREBALL");

    // Limit caster level
    if (nCasterLevel > 20)
    {
        nCasterLevel = 20;
    }

    effect eExplode = EffectVisualEffect(VFX_FNF_FIREBALL);
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);

    // Check if already fired
    if(nFire == 0)
    {
        // Mastery of Shaping logic (unchanged)
        if ((GetHasFeat(FEAT_MASTERY_SHAPES, OBJECT_SELF)) && (GetLocalInt(OBJECT_SELF, "archmage_mastery_shaping") == 1) && (!GetIsReactionTypeHostile(oTarget, OBJECT_SELF) || oTarget == OBJECT_SELF || GetMaster(oTarget) == OBJECT_SELF))
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SPELL_MANTLE_USE), oTarget);
        }
        else if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
            SetLocalInt(OBJECT_SELF, "NW_SPELL_DELAY_BLAST_FIREBALL", TRUE);
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);

            // Loop through targets in the explosion area
            object oAoETarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
            while (GetIsObjectValid(oAoETarget))
            {
                if ((GetHasFeat(FEAT_MASTERY_SHAPES, OBJECT_SELF)) && (GetLocalInt(OBJECT_SELF, "archmage_mastery_shaping") == 1) && (!GetIsReactionTypeHostile(oAoETarget, OBJECT_SELF) || oAoETarget == OBJECT_SELF || GetMaster(oAoETarget) == OBJECT_SELF))
                {
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SPELL_MANTLE_USE), oAoETarget);
                }
                else if (spellsIsTarget(oAoETarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
                {
                    // Fire cast spell at event for the specified target
                    SignalEvent(oAoETarget, EventSpellCastAt(oCaster, SPELL_DELAYED_BLAST_FIREBALL));

                    // Spell Resistance
                    if (!MyResistSpell(oCaster, oAoETarget))
                    {
                        int nDamage = d6(nCasterLevel);

                        // Metamagic
                        if (nMetaMagic == METAMAGIC_MAXIMIZE)
                        {
                            nDamage = 6 * nCasterLevel;
                        }
                        else if (nMetaMagic == METAMAGIC_EMPOWER)
                        {
                            nDamage = nDamage + (nDamage / 2);
                        }

                        nDamage = GetReflexAdjustedDamage(
                            nDamage,
                            oAoETarget,
                            (GetSpellSaveDC() + GetChangesToSaveDC(OBJECT_SELF)),
                            SAVING_THROW_TYPE_FIRE
                        );

                        effect eDam = EffectDamage(nDamage, ChangedElementalDamage(oCaster, DAMAGE_TYPE_FIRE));
                        if(nDamage > 0)
                        {
                            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oAoETarget);
                            DelayCommand(0.01, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oAoETarget));
                        }
                    }
                }
                // Next target
                oAoETarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
            }
            DestroyObject(OBJECT_SELF, 1.0);
        }
    }
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}