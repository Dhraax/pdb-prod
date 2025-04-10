#include "meteo_library"
void main()
{
    object oMod = GetModule();
    object oPC =GetPCSpeaker();
    SendMessageToPC(oPC, "!Puff.... que frío¡, ya está aquí el Invierno.");
    SetLocalString(oMod, "ESTACION", "INVIERNO");
    Reinciar_ClimaAreas();
    Indicar_ClimaAreas();
    object oArea = GetArea(oPC);
    Obtener_Clima(GetLocalInt(oArea, "ZONA_CLIMA"),oArea,oPC);

}
