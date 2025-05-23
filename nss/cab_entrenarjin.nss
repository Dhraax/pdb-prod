#include "cab_inc"

int ObtenerRangoJineteInt(object oPC)
{
  int iNivelEquitacion = ObtenerIntPersistente(oPC, "NIVELEQUITACION");
  int iRango;
  if(iNivelEquitacion >= 100) iRango = 7;
  else if(iNivelEquitacion >= 90) iRango = 6;
  else if(iNivelEquitacion >= 70) iRango = 5;
  else if(iNivelEquitacion >= 50) iRango = 4;
  else if(iNivelEquitacion >= 25) iRango = 3;
  else if(iNivelEquitacion >= 10) iRango = 2;
  else if(iNivelEquitacion >= 1) iRango = 1;

  return iRango;
}

void main()
{
  object oPC = GetPCSpeaker();

  // Obtenemos el oro y la experiencia segun el rango
  int iRangoActual = ObtenerRangoJineteInt(oPC);
  int iOro, iExperiencia;
  if(iRangoActual == 1) {iOro = 6000; iExperiencia = 400;}
  else if(iRangoActual == 2) {iOro = 7000; iExperiencia = 650;}
  else if(iRangoActual == 3) {iOro = 8000; iExperiencia = 1000;}
  else if(iRangoActual == 4) {iOro = 9000; iExperiencia = 1500;}
  else if(iRangoActual == 5) {iOro = 10000; iExperiencia = 2250;}
  else if(iRangoActual == 6) {iOro = 15000; iExperiencia = 3500;}

  // Si no tenemos oro nanay
  if(GetGold(oPC) < iOro)
  {
      ActionSpeakString("Vuelve cuando dispongas de las "+IntToString(iOro)+" po que te pido. Hasta entonces no te enseñaré nada.");
      return;
  }

  // Variables, mensajes, oro, xp y objetos
  int iNivelEquitacion = ObtenerIntPersistente(oPC, "NIVELEQUITACION");
  GuardarIntPersistente(oPC, "NIVELEQUITACION", iNivelEquitacion + 1);
  DelayCommand(5.0, SendMessageToPC(oPC,"<c´þd>¡Tu habilidad de Equitación ha subido al nivel "+IntToString(iNivelEquitacion+1)+"!</c>"));
  DelayCommand(5.1, SendMessageToPC(oPC,"<cþ>Tu nuevo rango de jinete es: <c´þd>"+ObtenerRangoJineteString(oPC)+".</c></c>"));
  TakeGoldFromCreature(iOro, oPC, TRUE);
  SetXP(oPC, GetXP(oPC) + iExperiencia);

  // Animaciones
  SetCutsceneMode(oPC, TRUE);
  FadeToBlack(oPC, FADE_SPEED_MEDIUM);
  DelayCommand(2.0, AssignCommand(oPC, PlaySound("gui_level_up")));
  DelayCommand(4.0, FadeFromBlack(oPC, FADE_SPEED_MEDIUM));
  DelayCommand(4.5, SetCutsceneMode(oPC, FALSE));
}
