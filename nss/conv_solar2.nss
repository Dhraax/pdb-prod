#include "pb_constantes"

void main()
{
    object oPC = GetPCSpeaker();
    int iRaza = GetRacialType(oPC);
    string sSubRace = GetStringLowerCase(GetSubRace(oPC));
    string sUbiTag = GetTag(OBJECT_SELF);
    int iModo = StringToInt(GetScriptParam("Modo"));
    string sWP = GetScriptParam("WP");

    location lDestino = GetLocation(GetWaypointByTag(sWP));

    DelayCommand(1.9, AssignCommand(oPC, ClearAllActions()));
    DelayCommand(2.0, AssignCommand(oPC, ActionJumpToLocation(lDestino)));
}
