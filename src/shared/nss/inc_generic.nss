/// -----------------------------------------------------------------------------
/// @system inc_generic
/// @file inc_generic.nss
/// @author Dhraax
/// @brief Defines utility functions for casting systems and feat management.
/// -----------------------------------------------------------------------------

#include "x2_inc_spellhook"
#include "nwnx_alts"

// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

/// @brief Checks whether the PC maintained concentration, and casts spell if so.
/// @param oPC The player character performing the casting.
/// @returns Nothing
void CheckConcentrationAndCastSpell(object oPC);

// -----------------------------------------------------------------------------
//                             Function Definitions
// -----------------------------------------------------------------------------

void CheckConcentrationAndCastSpell(object oPC)
{
    PrintString("DEBUG: Iniciando CheckConcentrationAndCastSpell()");

    if (!GetIsPC(oPC))
    {
        PrintString("DEBUG: OBJECT_SELF no es un jugador válido.");
        return;
    }

    if (!GetLocalInt(oPC, "APTITUD_CONCENTRATING"))
    {
        PrintString("DEBUG: No se encontró la variable APTITUD_CONCENTRATING.");
        return;
    }

    if (X2GetBreakConcentrationCondition(oPC))
    {
        PrintString("DEBUG: Se detectó una condición que rompe concentración.");
        DeleteLocalInt(oPC, "APTITUD_CONCENTRATING");
        SendMessageToPC(oPC, "Tu concentración se ha visto interrumpida (efecto).");
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY), oPC);
        return;
    }

    int iSpellId = GetLocalInt(oPC, "APTITUD_SPELL_ID");
    object oTarget = GetLocalObject(oPC, "APTITUD_SPELL_TARGET");
    location lLocation = GetLocalLocation(oPC, "APTITUD_SPELL_LOC");
    int iCL = GetTotalCasterLevel(oPC, CLASS_TYPE_WIZARD);

    PrintString("DEBUG: Datos del conjuro:");
    PrintString("DEBUG:  - SPELL_ID = " + IntToString(iSpellId));
    PrintString("DEBUG:  - CASTER_LEVEL = " + IntToString(iCL));
    PrintString("DEBUG:  - TARGET = " + GetName(oTarget));
    PrintString("DEBUG:  - LOCATION = " +
        FloatToString(GetPositionFromLocation(lLocation).x) + ", " +
        FloatToString(GetPositionFromLocation(lLocation).y) + ", " +
        FloatToString(GetPositionFromLocation(lLocation).z));

    NWNX_Creature_DoItemCastSpell(oPC, oTarget, lLocation, iSpellId, iCL, 0.0);

    PrintString("DEBUG: Hechizo ejecutado exitosamente.");

    // Limpieza
    DeleteLocalInt(oPC, "APTITUD_CONCENTRATING");
    DeleteLocalInt(oPC, "APTITUD_SPELL_ID");
    DeleteLocalObject(oPC, "APTITUD_SPELL_TARGET");
    DeleteLocalLocation(oPC, "APTITUD_SPELL_LOC");

    PrintString("DEBUG: Variables temporales eliminadas.");
}
