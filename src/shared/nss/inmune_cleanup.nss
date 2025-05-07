/////////////////////////////////////////////////////////
//
// SYSTEM: IMMUNE_MAGIC - Delayed Cleanup
//
// Name: immune_cleanup
//
// Desc: Limpia efectos mágicos creados por el lanzador en criaturas
//       con IMMUNE_MAGIC, usando gsSPRemoveEffect() extendida.
//
// Author: Dhraax - 20250507
//
/////////////////////////////////////////////////////////

#include "inc_spells"

void RemoveIfImmuneFromCaster(object oCaster, object oTarget)
{
    if (!GetIsObjectValid(oCaster) || !GetIsObjectValid(oTarget))
        return;

    if (!GetIsPC(oCaster))
        return;

    if (GetLocalInt(oTarget, "IMMUNE_MAGIC") == TRUE)
    {
        // Modo global: eliminar todos los efectos con SpellID válidos creados por oCaster
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
