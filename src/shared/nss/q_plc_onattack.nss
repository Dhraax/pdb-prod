//::///////////////////////////////////////////////
//:: Placeable OnPhysicalAttacked Script
//:: q_plc_onattack.nss
//:://////////////////////////////////////////////
/*
    Put into: Door's or Placeable's OnPhysicalAttacked Event

    Emmulates PHB object bashing and breaking. This system uses the FORT save
    value to determine the "break" DC of the object. By default, if no value
    is assigned to the FORT save value, the DC is 20. If the bash attempt fails,
    the object still takes damage as normal.

    To use this system the following variable must be placed upon your
    placeable objects:

    Q_MATERIAL_ID (int) - identifies the material the object is made from,
                          possible values are:

                          0 Invalid
                          1 Wood
                          2 Metal
                          3 Stone

*/
//:://////////////////////////////////////////////
//:: Created By: Pstemarie
//:: Created On: July 14, 2011
//:://////////////////////////////////////////////

void main()
{
    // Declare major variables
    object oAttacker = GetLastAttacker();
    object oTarget = OBJECT_SELF;

    // Abort if a "Plot" object
    if (GetPlotFlag(oTarget))
    {
        // Feedback for PCs only
        if (GetIsPC(oAttacker))
            SendMessageToPC(oAttacker, "You cannot break the" +GetStringLowerCase(GetName(oTarget))+ ".");
        return;
    }

    // Determine the DC - if no DC is assigned, assign the default value
    int nDC = GetFortitudeSavingThrow(oTarget);
    if (nDC = 0)
        nDC = 20;

    // DC for breaking locked wooden doors is at +2
    if (GetLocked(oTarget) && GetLocalInt(oTarget, "Q_MATERIAL_ID") == 1)
        nDC += 2;

    // If HP has been reduced to 50% or less then DC is at -2
    if (GetCurrentHitPoints(oTarget) <= (GetMaxHitPoints(oTarget)/2))
        nDC -= 2;

    // Modify the DC based upon creature size
    int nSize = GetCreatureSize(oAttacker);
    switch (nSize)
    {
        case CREATURE_SIZE_HUGE:  nDC -= 8; break;
        case CREATURE_SIZE_LARGE: nDC -= 4; break;
        case CREATURE_SIZE_SMALL: nDC += 4; break;
        case CREATURE_SIZE_TINY:  nDC += 8; break;
    }

    // Make the bash attempt
    int nRoll = d20(1);
    int nMod = GetAbilityModifier(ABILITY_STRENGTH, oAttacker);

    if ((nRoll + nMod) >= nDC)
    {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(GetCurrentHitPoints(oTarget)), oTarget);

        // Feedback for PCs
        if (GetIsPC(oAttacker))
            SendMessageToPC(oAttacker, "The " +GetStringLowerCase(GetName(oTarget))+ " breaks apart.");
    }
}
