#include "lib_race"

int StartingConditional()
{
    object oPC = GetPCSpeaker();

    return PB_Race_GetIsUndead(oPC);
}
