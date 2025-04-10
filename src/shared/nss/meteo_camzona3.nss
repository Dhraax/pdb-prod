#include "meteo_library"
void main()
{
    int num=3;
    object oPC =GetPCSpeaker();
    SendMessageToPC(oPC, "Has modificado el clima del Amn Centro-Sur.");
    Cambiar_ClimaZona(num);
    object oArea = GetArea(oPC);
    Obtener_Clima(num,oArea,oPC);
}
