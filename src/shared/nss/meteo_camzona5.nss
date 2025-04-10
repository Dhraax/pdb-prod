#include "meteo_library"
void main()
{

    int num=5;
    object oPC =GetPCSpeaker();
    SendMessageToPC(oPC, "Has modificado el clima del Valle de Minsor.");
    Cambiar_ClimaZona(num);
    object oArea = GetArea(oPC);
    Obtener_Clima(num,oArea,oPC);
}
