#include "nwnx_events"
#include "mti_libreria"
#include "nwnx_creature"


void main()
{
    string sCurrentEvent = NWNX_Events_GetCurrentEvent();
    object oPC = OBJECT_SELF;

    if (sCurrentEvent == "NWNX_ON_LEVEL_DOWN_AFTER")
    {
        int iMMF = GetLevelByClass(63);
        int iOriginalRace = ObtenerIntPersistente(oPC,"MMF_ORIGINAL_RACE");
        if(iMMF < 10 && iMMF > 0 && GetRacialType(oPC) != iOriginalRace) {
            NWNX_Creature_SetRacialType(oPC,iOriginalRace);
        }
    }
}
