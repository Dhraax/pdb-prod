/// ----------------------------------------------------------------------------
/// @system Spellcasting
/// @file x2_s0_undeath.nss
/// @author Dhraax (adapted for simultaneous deaths, no arrays)
/// @brief Slays a number of undead with lowest HD first, up to caster's limit. All deaths occur at once.
/// ----------------------------------------------------------------------------

#include "NW_I0_SPELLS"
#include "x0_i0_spells"
#include "x2_inc_toollib"
#include "x2_inc_spellhook"
#include "pb_nivellanzador"

// -----------------------------------------------------------------------------
// Function Prototypes
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Main Entrypoint
// -----------------------------------------------------------------------------

void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_NECROMANCY);

    if (!X2PreSpellCastCode())
    {
        return;
    }

    int iMetaMagic = GetSpellCastItem() == OBJECT_INVALID ? GetMetaMagicFeat() : METAMAGIC_NONE;
    location lLoc = GetSpellTargetLocation();
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_STRIKE_HOLY), lLoc);
    TLVFXPillar(VFX_FNF_LOS_HOLY_20, lLoc, 3, 0.0f);

    int iLevel = GetTotalCasterLevel(OBJECT_SELF);
    if (iLevel > 20) iLevel = 20;
    int iHDLeft = iLevel * d4();
    if (iMetaMagic == METAMAGIC_MAXIMIZE) iHDLeft = 4 * iLevel;
    if (iMetaMagic == METAMAGIC_EMPOWER) iHDLeft += (iHDLeft / 2);

    // Limpieza de tags previos y candidatos
    int i;
    for (i = 0; i < 64; i++)
    {
        DeleteLocalObject(OBJECT_SELF, "UTD_CAND_" + IntToString(i));
    }
    DeleteLocalInt(OBJECT_SELF, "UTD_CAND_COUNT");

    // 1. Recopila todos los candidatos válidos y guarda en variables locales
    int iCount = 0;
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 20.0f, lLoc);
    while (GetIsObjectValid(oTarget) && iCount < 64)
    {
        if (PB_Race_GetIsUndead(oTarget)
            && GetIsEnemy(oTarget, OBJECT_SELF)
            && oTarget != OBJECT_SELF
            && !GetPlotFlag(oTarget)
            && !GetIsDead(oTarget))
        {
            SetLocalObject(OBJECT_SELF, "UTD_CAND_" + IntToString(iCount), oTarget);
            SetLocalInt(oTarget, "UTD_TEMP_HD", GetHitDice(oTarget));
            iCount++;
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, 20.0f, lLoc);
    }
    SetLocalInt(OBJECT_SELF, "UTD_CAND_COUNT", iCount);

    // 2. Ordena por HD ascendente (burbuja, máximo 64, seguro)
    int j, k, n = iCount;
    for (j = 0; j < n - 1; j++)
    {
        for (k = j + 1; k < n; k++)
        {
            object oA = GetLocalObject(OBJECT_SELF, "UTD_CAND_" + IntToString(j));
            object oB = GetLocalObject(OBJECT_SELF, "UTD_CAND_" + IntToString(k));
            if (GetLocalInt(oA, "UTD_TEMP_HD") > GetLocalInt(oB, "UTD_TEMP_HD"))
            {
                // Swap
                SetLocalObject(OBJECT_SELF, "UTD_CAND_" + IntToString(j), oB);
                SetLocalObject(OBJECT_SELF, "UTD_CAND_" + IntToString(k), oA);
            }
        }
    }

    // 3. Proceso: decidir quién muere
    int iPool = iHDLeft;
    int iKill = 0;
    for (i = 0; i < iCount; i++)
    {
        object oT = GetLocalObject(OBJECT_SELF, "UTD_CAND_" + IntToString(i));
        int iT_HD = GetLocalInt(oT, "UTD_TEMP_HD");
        // Solo si quedan HD suficientes
        if (iT_HD <= iPool)
        {
            // Will Save
            if (!MySavingThrow(SAVING_THROW_WILL, oT, (GetSpellSaveDC() + GetChangesToSaveDC(OBJECT_SELF)), SAVING_THROW_TYPE_NONE, OBJECT_SELF))
            {
                // Spell Resistance
                if (!MyResistSpell(OBJECT_SELF, oT, 0.0f))
                {
                    // Marca para morir, se sobrescribe a sí mismo (usar el mismo slot)
                    SetLocalInt(oT, "UTD_TO_KILL", TRUE);
                    iPool -= iT_HD;
                    iKill++;
                }
            }
        }
    }

    // 4. Todos los elegidos mueren "a la vez"
    float fDelay = GetRandomDelay(0.2f, 0.4f);
    for (i = 0; i < iCount; i++)
    {
        object oT = GetLocalObject(OBJECT_SELF, "UTD_CAND_" + IntToString(i));
        if (GetLocalInt(oT, "UTD_TO_KILL"))
        {
            effect eDeath = EffectDamage(GetCurrentHitPoints(oT), DAMAGE_TYPE_DIVINE, DAMAGE_POWER_ENERGY);
            effect eVis = EffectVisualEffect(VFX_IMP_DEATH);

            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oT));
            DelayCommand(fDelay + 0.5f, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oT));

            if (GetIsPC(oT) || GetIsDM(oT))
            {
                DelayCommand(fDelay + 0.6f, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(15, DAMAGE_TYPE_DIVINE, DAMAGE_POWER_ENERGY), oT));
            }
        }
        // Limpieza
        DeleteLocalInt(oT, "UTD_TEMP_HD");
        DeleteLocalInt(oT, "UTD_TO_KILL");
        DeleteLocalObject(OBJECT_SELF, "UTD_CAND_" + IntToString(i));
    }
    DeleteLocalInt(OBJECT_SELF, "UTD_CAND_COUNT");

    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
