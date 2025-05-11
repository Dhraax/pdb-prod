/// ----------------------------------------------------------------------------
/// @system IMMUNE_MAGIC
/// @file immune_cleanup.nss
/// @author Dhraax
/// @brief Removes spell effects on creatures with IMMUNE_MAGIC created by the caster,
///        using extended gsSPRemoveEffect logic.
/// ----------------------------------------------------------------------------

#include "inc_spells"

// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

/// @brief Removes caster's effects from a target if the target has IMMUNE_MAGIC.
/// @param oCaster The object who cast the spell (typically OBJECT_SELF)
/// @param oTarget The potential target to clean effects from
void RemoveIfImmuneFromCaster(object oCaster, object oTarget);

// -----------------------------------------------------------------------------
//                             Function Definitions
// -----------------------------------------------------------------------------

void RemoveIfImmuneFromCaster(object oCaster, object oTarget)
{
    if (!GetIsObjectValid(oCaster) || !GetIsObjectValid(oTarget))
    {
        return;
    }

    if (!GetIsPC(oCaster))
    {
        return;
    }

    if (GetLocalInt(oTarget, "IMMUNE_MAGIC") == TRUE)
    {
        // Global mode: remove all spell effects from this caster
        int iRemoved = gsSPRemoveEffect(oTarget, -1, oCaster);

        if (iRemoved > 0)
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_GLOBE_USE), oTarget);
        }
    }
}

void main()
{
    object oCaster = OBJECT_SELF;
    location lLoc = GetLocation(oCaster);
    vector vCenter = GetPositionFromLocation(lLoc);
    float fRadius = 20.0;

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lLoc, TRUE, OBJECT_TYPE_CREATURE, vCenter);
    while (GetIsObjectValid(oTarget))
    {
        RemoveIfImmuneFromCaster(oCaster, oTarget);
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lLoc, TRUE, OBJECT_TYPE_CREATURE, vCenter);
    }
}