#include "f_vampire_spls_h"
#include "lib_race"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    string sSubraza = GetSubRace(oPC);
    if ((PB_Race_GetIsUndead(oPC)) || (GetIsVampire(oPC)) || (sSubraza=="ghul") || (sSubraza=="necropolita") || (sSubraza=="deathknight") || (sSubraza=="liche"))
            {
                return TRUE;
            }
    return FALSE;
}
