#include "NW_O2_CONINCLUDE"
#include "NW_I0_GENERIC"

void main()
{
  SetListenPattern(OBJECT_SELF, "**", 777);
  SetListening(OBJECT_SELF, TRUE);
  WalkWayPoints();
}
