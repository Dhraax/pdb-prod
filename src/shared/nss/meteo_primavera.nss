#include "meteo_library"
void main()
{
    object oPC =GetPCSpeaker();
    SendMessageToPC(oPC, "Ya ha llegado la Primavera al servidor.");
    object oMod = GetModule();
    SetLocalString(oMod, "ESTACION", "PRIMAVERA");
    Reinciar_ClimaAreas();
    Indicar_ClimaAreas();
    object oArea = GetArea(oPC);
    Obtener_Clima(GetLocalInt(oArea, "ZONA_CLIMA"),oArea,oPC);
}
