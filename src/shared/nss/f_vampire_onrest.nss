#include "f_vampire_spls_h"
//This is the onrest hook for the Fallen PC Vampire system, if it
//returns TRUE you should stop executing your rest script as the
//rest will be handled through the vampire system.
int Vampire_On_Rest()
{
if (GetLastRestEventType() == REST_EVENTTYPE_REST_STARTED)
    {
    object oPC = GetLastPCRested();
    if(GetIsVampire(oPC))
        {
        if(!GetLocalInt(oPC, "FALLEN_IN_COFFIN") && GetLocalInt(oPC, "ARENA") != 1)
            {
            SetCommandable(TRUE, oPC);
            AssignCommand(oPC, ClearAllActions());
            FloatingTextStringOnCreature("Sólo puedes dormir dentro de un ataúd.", oPC);
            }
        return TRUE;
        }
    }
return FALSE;
}
