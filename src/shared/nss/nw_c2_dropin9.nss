#include "NW_I0_GENERIC"
void main()
{
    SetLootable(OBJECT_SELF, TRUE);
    if(GetLocalInt(OBJECT_SELF, "JEFAZO") > 0) {
        //ExecuteScript("pb_tesoro_boss", OBJECT_SELF);
    } else {
        ExecuteScript("pb_tesoros_pnjs", OBJECT_SELF);
    }

    SetSpawnInCondition(NW_FLAG_AMBIENT_ANIMATIONS);
    SetSpawnInCondition(NW_FLAG_IMMOBILE_AMBIENT_ANIMATIONS);
    SetSpawnInCondition(NW_FLAG_APPEAR_SPAWN_IN_ANIMATION);

    SetListeningPatterns();
    WalkWayPoints();
}
