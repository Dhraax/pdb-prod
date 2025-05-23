#include "meteo_library"
void main()
{
    int num=6;
    object oPC =GetPCSpeaker();
    SendMessageToPC(oPC, "Has modificado el clima del Bosque de Tezhyr.");
    Cambiar_ClimaZona(num);
    object oArea = GetArea(oPC);
    Obtener_Clima(num,oArea,oPC);
}
