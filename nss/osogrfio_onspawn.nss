#include "x0_i0_anims"
#include "x2_inc_switches"

void main()
{
    // CADAVERES USABLES AL MORIR
    SetLootable(OBJECT_SELF, TRUE);

    // REG. DE TESOROS
    if(GetLocalInt(OBJECT_SELF, "JEFAZO") > 0) {
        //ExecuteScript("pb_tesoro_boss", OBJECT_SELF);
    } else {
        ExecuteScript("pb_tesoros_pnjs", OBJECT_SELF);
    }

    // PIEL DEL OSEOGARFIO
    effect ePielDeHielo = SupernaturalEffect(EffectVisualEffect(VFX_DUR_ICESKIN));
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePielDeHielo, OBJECT_SELF);

    //--------------------------------------------------------------------------
    // Enable stealth mode by setting a variable on the creature
    // Great for ambushes
    // See x2_inc_switches for more information about this
    //--------------------------------------------------------------------------
    if (GetCreatureFlag(OBJECT_SELF, CREATURE_VAR_USE_SPAWN_STEALTH) == TRUE)
    {
        SetSpawnInCondition(NW_FLAG_STEALTH);
    }

    //--------------------------------------------------------------------------
    // Make creature enter search mode after spawning by setting a variable
    // Great for guards, etc
    // See x2_inc_switches for more information about this
    //--------------------------------------------------------------------------
    if (GetCreatureFlag(OBJECT_SELF, CREATURE_VAR_USE_SPAWN_SEARCH) == TRUE)
    {
        SetSpawnInCondition(NW_FLAG_SEARCH);
    }

    //--------------------------------------------------------------------------
    // Enable immobile ambient animations by setting a variable
    // See x2_inc_switches for more information about this
    //--------------------------------------------------------------------------
    if (GetCreatureFlag(OBJECT_SELF, CREATURE_VAR_USE_SPAWN_AMBIENT_IMMOBILE) == TRUE)
    {
        SetSpawnInCondition(NW_FLAG_IMMOBILE_AMBIENT_ANIMATIONS);
    }

    //--------------------------------------------------------------------------
    // Enable mobile ambient animations by setting a variable
    // See x2_inc_switches for more information about this
    //--------------------------------------------------------------------------
    if (GetCreatureFlag(OBJECT_SELF, CREATURE_VAR_USE_SPAWN_AMBIENT) == TRUE)
    {
        SetSpawnInCondition(NW_FLAG_AMBIENT_ANIMATIONS);
    }

    SetListeningPatterns();
    WalkWayPoints();
}
