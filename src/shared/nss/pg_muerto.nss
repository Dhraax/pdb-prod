#include "mti_libreria"
#include "inc_sqlite_time"

void main()
{
    object oPC = GetPCSpeaker();

    // Quitamos del jugador el modo cutsecene
    SetCutsceneMode(oPC, FALSE);

    //Ajustamos el tiempo de espera.
    int iNivelPJ = GetHitDice(oPC);
    int iHorasDeEspera;
    if(iNivelPJ >= 1 && iNivelPJ <= 4) iHorasDeEspera = 2;
    else if(iNivelPJ >= 5 && iNivelPJ <= 8) iHorasDeEspera = 3;
    else if(iNivelPJ >= 9 && iNivelPJ <= 12) iHorasDeEspera = 4;
    else if(iNivelPJ >= 13 && iNivelPJ <= 16) iHorasDeEspera = 5;
    else iHorasDeEspera = 6;
    iHorasDeEspera = iHorasDeEspera * 180;
    GuardarIntPersistente(oPC, "ESTOY_EN_PLANOFUGA", SQLite_GetTimeStamp() + iHorasDeEspera);


    // Mandamos el jugador al abismo
    location lPlanoFuga = GetLocation(GetWaypointByTag("pg_planofuga"));
    DelayCommand(0.5, AssignCommand(oPC, JumpToLocation(lPlanoFuga)));
}
