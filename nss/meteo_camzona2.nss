#include "meteo_library"
void main()
{
    int num=2;
    object oPC =GetPCSpeaker();
    SendMessageToPC(oPC, "Has modificado el clima del Amn Centro-Norte.");
    Cambiar_ClimaZona(num);
    object oArea = GetArea(oPC);
    Obtener_Clima(num,oArea,oPC);
}
