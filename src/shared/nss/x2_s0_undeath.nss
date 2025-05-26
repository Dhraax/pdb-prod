/// ----------------------------------------------------------------------------
/// @system Spellcasting
/// @file x2_s0_undeath.nss
/// @author Dhraax (adapted from Bioware original)
/// @brief Slays a number of undead with lowest HD first, up to caster's limit.
/// ----------------------------------------------------------------------------

#include "NW_I0_SPELLS"
#include "x0_i0_spells"
#include "x2_inc_toollib"
#include "x2_inc_spellhook"
#include "pb_nivellanzador"

// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

/// @brief Kills an undead creature if it fails saving throw and resists.
/// @param oCreature The creature to be slain.
/// @returns Nothing.
void DoUndeadToDeath(object oCreature);

// -----------------------------------------------------------------------------
//                             Function Definitions
// -----------------------------------------------------------------------------

void DoUndeadToDeath(object oCreature)
{
    SignalEvent(oCreature, EventSpellCastAt(OBJECT_SELF, GetSpellId()));

    if (!MySavingThrow(SAVING_THROW_WILL, oCreature, (GetSpellSaveDC() + GetChangesToSaveDC(OBJECT_SELF)), SAVING_THROW_TYPE_NONE, OBJECT_SELF))
    {
        float fDelay = GetRandomDelay(0.2f, 0.4f);
        if (!MyResistSpell(OBJECT_SELF, oCreature, fDelay))
        {
            effect eDeath = EffectDamage(GetCurrentHitPoints(oCreature), DAMAGE_TYPE_DIVINE, DAMAGE_POWER_ENERGY);
            effect eVis = EffectVisualEffect(VFX_IMP_DEATH);

            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oCreature));
            DelayCommand(fDelay + 0.5f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oCreature));

            // Only apply "finisher" damage to PCs or DMs for robust instant death
            if (GetIsPC(oCreature) || GetIsDM(oCreature))
            {
                DelayCommand(fDelay + 0.6f, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(15, DAMAGE_TYPE_DIVINE, DAMAGE_POWER_ENERGY), oCreature));
            }
        }
        else
        {
            DelayCommand(1.0f, DeleteLocalInt(oCreature, "X2_EBLIGHT_I_AM_DEAD"));
        }
    }
    else
    {
        DelayCommand(1.0f, DeleteLocalInt(oCreature, "X2_EBLIGHT_I_AM_DEAD"));
    }
}


void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_NECROMANCY);

    // Spellcast Hook (custom pre-casting logic)
    if (!X2PreSpellCastCode())
    {
        // PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    int iMetaMagic = GetSpellCastItem() == OBJECT_INVALID ? GetMetaMagicFeat() : METAMAGIC_NONE;

    // Impact VFX
    location lLoc = GetSpellTargetLocation();
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_STRIKE_HOLY), lLoc);
    TLVFXPillar(VFX_FNF_LOS_HOLY_20, lLoc, 3, 0.0f);

    // Calculation
    int iLevel = GetTotalCasterLevel(OBJECT_SELF);
    if (iLevel > 20)
    {
        iLevel = 20;
    }
    int iHDLeft = iLevel * d4();
    if (iMetaMagic == METAMAGIC_MAXIMIZE)
    {
        iHDLeft = 4 * iLevel; // Damage is at max
    }
    if (iMetaMagic == METAMAGIC_EMPOWER)
    {
        iHDLeft += (iHDLeft / 2); // Damage/Healing is +50%
    }

    // -------------------------------------------------------------------------
    // Corrected loop: always select the valid undead with the lowest HD.
    // -------------------------------------------------------------------------
    while (iHDLeft > 0)
    {
        int iLowestHD = 9999;
        object oLowest = OBJECT_INVALID;
        object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 20.0f, lLoc);

        // Search for the lowest-HD valid undead
        while (GetIsObjectValid(oTarget))
        {
            if (PB_Race_GetIsUndead(oTarget))
            {
                int iCurHD = GetHitDice(oTarget);
                if (iCurHD <= iHDLeft)
                {
                    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
                    {
                        if (GetLocalInt(oTarget, "X2_EBLIGHT_I_AM_DEAD") == 0 && !GetPlotFlag(oTarget) && !GetIsDead(oTarget))
                        {
                            if (iCurHD < iLowestHD)
                            {
                                iLowestHD = iCurHD;
                                oLowest = oTarget;
                            }
                        }
                    }
                }
            }
            oTarget = GetNextObjectInShape(SHAPE_SPHERE, 20.0f, lLoc);
        }

        // If found, slay and reduce HD pool. If not, exit.
        if (GetIsObjectValid(oLowest) && iHDLeft >= iLowestHD)
        {
            DoUndeadToDeath(oLowest);
            iHDLeft -= iLowestHD;
        }
        else
        {
            break; // No more valid targets or can't afford next lowest HD
        }
    }

    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}