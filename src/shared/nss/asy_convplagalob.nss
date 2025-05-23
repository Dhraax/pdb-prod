#include "f_vampirebite_h"
int StartingConditional()
{
    object oPC =GetPCSpeaker();

    int iLevel = Determine_Vampire_Level(oPC);
    if (iLevel<5) return FALSE;
    return TRUE;
}
