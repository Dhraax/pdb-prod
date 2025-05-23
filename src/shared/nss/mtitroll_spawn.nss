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

    SetSpawnInCondition(NW_FLAG_HEARTBEAT_EVENT);
    SetSpawnInCondition(NW_FLAG_ATTACK_EVENT);
    SetSpawnInCondition(NW_FLAG_DAMAGED_EVENT);
    SetSpawnInCondition(NW_FLAG_SPELL_CAST_AT_EVENT);

    SetListeningPatterns();
    WalkWayPoints();
    SetImmortal(OBJECT_SELF,TRUE);

    //Aplicar efectos visuales onspawn
    int nEffect1 = GetLocalInt(OBJECT_SELF, "EFECTO1");
    int nEffect2 = GetLocalInt(OBJECT_SELF, "EFECTO2");
    effect eEffect1 = SupernaturalEffect(EffectVisualEffect(nEffect1));
    effect eEffect2 = SupernaturalEffect(EffectVisualEffect(nEffect2));

    if(nEffect1 > 0 ) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEffect1, OBJECT_SELF);
    if(nEffect2 > 0 ) ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEffect2, OBJECT_SELF);
}
