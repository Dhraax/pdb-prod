#include "meteo_library"
void main()
{
    object oMod = GetModule();
     object oPC =GetPCSpeaker();
    SendMessageToPC(oPC, "Por fin el buen tiempo, es hora de playita ya que el Verano está aquí.");
    SetLocalString(oMod, "ESTACION", "VERANO");
    Reinciar_ClimaAreas();
    Indicar_ClimaAreas();
    object oArea = GetArea(oPC);
    Obtener_Clima(GetLocalInt(oArea, "ZONA_CLIMA"),oArea,oPC);
}
