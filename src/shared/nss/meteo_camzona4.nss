#include "meteo_library"
void main()
{
    int num=4;
    object oPC =GetPCSpeaker();
    SendMessageToPC(oPC, "Has modificado el clima de Amn Sur.");
    Cambiar_ClimaZona(num);
    object oArea = GetArea(oPC);
    Obtener_Clima(num,oArea,oPC);
}
