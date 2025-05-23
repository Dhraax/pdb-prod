#include "meteo_library"
void main()
{
    object oPC =GetPCSpeaker();
    SendMessageToPC(oPC, "Has modificado el clima del Archipiélago de Nelanzher.");
    int num=7;
    Cambiar_ClimaZona(num);
    object oArea = GetArea(oPC);
    Obtener_Clima(num,oArea,oPC);
}
