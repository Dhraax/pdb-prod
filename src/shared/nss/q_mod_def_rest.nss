//::///////////////////////////////////////////////
//:: Project Q v2.1 OnPlayerRest event script
//:: q_mod_def_load.nss
//:://////////////////////////////////////////////
/*
    Wrapper function for OnPlayerRest event, set this script as the
    default under "Module Properties"

    If using the Project Q Rest System, you must enable the corresponding
    module switch in q_mod_def_load
*/
//:://////////////////////////////////////////////
//:: Created By: Pstemarie
//:: Created On: November 2015
//:://////////////////////////////////////////////

#include "q_inc_switches"

void main()
{
    // * If flagged as using the Project Q Rest System, fire q_playerrest.nss as
    // * the OnPlayerRest event, else fire x2_mod_def_rest.
    if (GetModuleSwitchValue(MODULE_SWITCH_RESTSYSTEM_ENABLED) == TRUE)
    {
        ExecuteScript("q_playerrest", OBJECT_SELF);
    }
    else
    {
        ExecuteScript("x2_mod_def_rest", OBJECT_SELF);
    }
}
