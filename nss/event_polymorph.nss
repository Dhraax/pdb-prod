#include "nwnx_events"
#include "lib_disguise"
#include "lib_dm_vfx"

void main()
{
    string sCurrentEvent = NWNX_Events_GetCurrentEvent();
    object oPC = OBJECT_SELF;

    if (sCurrentEvent == "NWNX_ON_POLYMORPH_BEFORE") {
        RemoveAllDMVFX(oPC);
    }

    else if (sCurrentEvent == "NWNX_ON_UNPOLYMORPH_BEFORE") {
        LoadAllDMVFX(oPC);
    }

    else if (sCurrentEvent == "NWNX_ON_UNPOLYMORPH_AFTER") {
        if (GetLocalInt(OBJECT_SELF, "POLY_ON") == 1) {
            SetLocalInt(OBJECT_SELF, "POLY_ON", 0);
        }
    }
}

