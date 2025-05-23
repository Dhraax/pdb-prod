#include "nwnx_object"
#include "nwnx_player"
#include "pb_constantes"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    object oTarget = GetLocalObject(OBJECT_SELF, "DM_PAA_oTarget");
    int iAparienciaActual = NWNX_Object_GetAppearance(oTarget);
    string sAparienciaActual = Get2DAString("placeables", "Label", iAparienciaActual);

    int iApariencia1 = iAparienciaActual - 4;
    string sApariencia1 = Get2DAString("placeables", "Label", iApariencia1);

    int iApariencia2 = iAparienciaActual - 3;
    string sApariencia2 = Get2DAString("placeables", "Label", iApariencia2);

    int iApariencia3 = iAparienciaActual - 2;
    string sApariencia3 = Get2DAString("placeables", "Label", iApariencia3);

    int iApariencia4 = iAparienciaActual - 1;
    string sApariencia4 = Get2DAString("placeables", "Label", iApariencia4);

    int iApariencia5 = iAparienciaActual + 1;
    string sApariencia5 = Get2DAString("placeables", "Label", iApariencia5);

    int iApariencia6 = iAparienciaActual + 2;
    string sApariencia6 = Get2DAString("placeables", "Label", iApariencia6);

    int iApariencia7 = iAparienciaActual + 3;
    string sApariencia7 = Get2DAString("placeables", "Label", iApariencia7);

    int iApariencia8 = iAparienciaActual + 4;
    string sApariencia8 = Get2DAString("placeables", "Label", iApariencia8);


    NWNX_Player_SetCustomToken(oPC,15011,IntToString(iApariencia1)+": "+sApariencia1+".");
    NWNX_Player_SetCustomToken(oPC,15012,IntToString(iApariencia2)+": "+sApariencia2+".");
    NWNX_Player_SetCustomToken(oPC,15013,IntToString(iApariencia3)+": "+sApariencia3+".");
    NWNX_Player_SetCustomToken(oPC,15014,IntToString(iApariencia4)+": "+sApariencia4+".");
    NWNX_Player_SetCustomToken(oPC,15015,"Actual: "+IntToString(iAparienciaActual)+": "+sAparienciaActual+".");
    NWNX_Player_SetCustomToken(oPC,15016,IntToString(iApariencia5)+": "+sApariencia5+".");
    NWNX_Player_SetCustomToken(oPC,15017,IntToString(iApariencia6)+": "+sApariencia6+".");
    NWNX_Player_SetCustomToken(oPC,15018,IntToString(iApariencia7)+": "+sApariencia7+".");
    NWNX_Player_SetCustomToken(oPC,15019,IntToString(iApariencia8)+": "+sApariencia8+".");

    return TRUE;
}
