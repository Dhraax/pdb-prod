#include "nw_i0_tool"

int StartingConditional()
{

    // Perform skill checks
    if(!(AutoDC(25, SKILL_PERSUADE, GetPCSpeaker())))
        return FALSE;

    return TRUE;
}
