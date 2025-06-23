//::///////////////////////////////////////////////
//:: Darkness: On Exit
//:: NW_S0_DarknessB.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Removes all darkness effects from the exiting object, regardless of caster.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Feb 28, 2002
//:: Modified By: Dhraax
//:: Modified On: 21/06/2025
//:://////////////////////////////////////////////
#include "x2_inc_spellhook"
#include "nw_i0_spells"
#include "inc_spells"

/// -----------------------------------------------------------------------------
/// @system PB_EE_PROD
/// @file nw_s0_darknessb.nss
/// @author Dhraax
/// @brief  Removes all darkness effects from the exiting object on area exit.
/// -----------------------------------------------------------------------------

void main()
{
    /// @brief Removes all darkness effects from the exiting object, regardless of caster.
    /// @param oExiting The object exiting the area of effect.
    /// @returns void
    object oExiting = GetExitingObject();
    gsSPRemoveEffect(oExiting, SPELL_DARKNESS, OBJECT_INVALID, "", TRUE);
    gsSPRemoveEffect(oExiting, SPELL_SHADOW_CONJURATION_DARKNESS, OBJECT_INVALID, "", TRUE);
}
