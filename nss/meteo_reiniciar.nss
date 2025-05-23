#include "meteo_library"
void main()
{
    object oPC =GetPCSpeaker();
    SendMessageToPC(oPC, "Has modificado el clima de todas las áreas del servidor dependiendo de la estación del año establecida.");
    Reinciar_ClimaAreas();
    Indicar_ClimaAreas();
    object oArea = GetArea(oPC);
    Obtener_Clima(GetLocalInt(oArea, "ZONA_CLIMA"),oArea,oPC);

}
