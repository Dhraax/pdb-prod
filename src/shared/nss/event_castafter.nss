/////////////////////////////////////////////////////////
//
// SYSTEM: NWNX_ON_CAST_SPELL_AFTER
//
// Name: event_castafter
//
// Desc: 
//
// Author: Dhraax - 20250430
//
/////////////////////////////////////////////////////////

#include "nwnx_events"
/////////////////////////////////////////////////////////
//Elimina todos los efectos de criaturas con IMMUNE_MAGIC, si el hechizo fue lanzado por un jugador.
/////////////////////////////////////////////////////////
void RemoveAllEffectsFromObject(object oTarget)
{
    effect eEff = GetFirstEffect(oTarget);
    while (GetIsEffectValid(eEff))
    {
        RemoveEffect(oTarget, eEff);
        eEff = GetNextEffect(oTarget);
    }
}

void RemoveAllEffectsIfImmuneFromPC(object oCaster, object oTarget)
{
    if (!GetIsObjectValid(oCaster) || !GetIsObjectValid(oTarget))
        return;

    if (!GetIsPC(oCaster))
        return;

    if (GetLocalInt(oTarget, "IMMUNE_MAGIC") == TRUE)
    {
        RemoveAllEffectsFromObject(oTarget);
    }
}
/////////////////////////////////////////////////////////

void main()
{
    object oCaster = OBJECT_SELF;
    location lLoc = GetLocation(oCaster);
    vector vCenter = GetPositionFromLocation(lLoc);
    float fRadius = 20.0;

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lLoc, TRUE, OBJECT_TYPE_CREATURE, vCenter);
    while (GetIsObjectValid(oTarget))
    {
        RemoveAllEffectsIfImmuneFromPC(oCaster, oTarget);
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lLoc, TRUE, OBJECT_TYPE_CREATURE, vCenter);
    }
}
