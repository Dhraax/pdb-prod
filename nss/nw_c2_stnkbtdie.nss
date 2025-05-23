// HCR v3.2.0 -
//::////////////////////////////////////////////////////////////////////////////
//:: FileName:  NW_C2_StnkBtDie
//::////////////////////////////////////////////////////////////////////////////
/*
   Releases the Stink Beetle's Stinking Cloud special ability On Death.
*/
//::////////////////////////////////////////////////////////////////////////////
//:: Created By: Andrew
//:: Created On: Jan 2002
//::////////////////////////////////////////////////////////////////////////////
void main()
{
    // Create the AOE object at the selected location.
    effect eStkCloud = EffectAreaOfEffect(AOE_MOB_TYRANT_FOG, "NW_S1_Stink_A");
    location lTarget = GetLocation(OBJECT_SELF);
    float fDuration  = RoundsToSeconds(2);
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eStkCloud, lTarget, fDuration);

    // EJECUTAR EL SCRIPT DE MUERTE POR DEFECTO
    ExecuteScript("nw_c2_default7", OBJECT_SELF);
}
//::////////////////////////////////////////////////////////////////////////////
