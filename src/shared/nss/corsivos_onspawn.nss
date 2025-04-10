#include "NW_O2_CONINCLUDE"
#include "NW_I0_GENERIC"

void main()
{
    SetSpawnInCondition(NW_FLAG_HEARTBEAT_EVENT);
    SetListeningPatterns();
    WalkWayPoints();
    if(GetLocalInt(OBJECT_SELF, "JEFAZO") > 0) {
        //ExecuteScript("pb_tesoro_boss", OBJECT_SELF);
    } else {
        ExecuteScript("pb_tesoros_pnjs", OBJECT_SELF);
    }
    SetLootable(OBJECT_SELF, TRUE);
}
