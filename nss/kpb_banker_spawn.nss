#include "NW_I0_GENERIC"

void main()
{
    SetListenPattern(OBJECT_SELF, "**ingresar ** po**", 20);
    SetListenPattern(OBJECT_SELF, "**sacar ** po**", 21);
    SetListenPattern(OBJECT_SELF, "**balance**", 22);
    SetListenPattern(OBJECT_SELF, "**sacar todo**", 23);
    SetListenPattern(OBJECT_SELF, "**ingresar todo**", 24);
    SetListening(OBJECT_SELF, TRUE);

    SetListeningPatterns();
    WalkWayPoints();
}
