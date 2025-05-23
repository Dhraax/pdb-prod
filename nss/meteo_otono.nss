#include "meteo_library"
void main()
{
    object oMod = GetModule();
    object oPC =GetPCSpeaker();
    SendMessageToPC(oPC, "La caida de hojas ha comenzado, el Otoño ya llego.");
    SetLocalString(oMod, "ESTACION", "OTOÑO");
    Reinciar_ClimaAreas();
    Indicar_ClimaAreas();
    object oArea = GetArea(oPC);
    Obtener_Clima(GetLocalInt(oArea, "ZONA_CLIMA"),oArea,oPC);
}
