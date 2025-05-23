#include "mti_libreria"
void main()
{
  object oJugador_DM = GetPCSpeaker();
  object oPJ = GetLocalObject(oJugador_DM, "VJDM_OBJETIVO");

  SetXP(oPJ, 77999);
  SetCampaignInt("DESBLOQUEO", "NIVEL13", 0, oPJ);
  FloatingTextStringOnCreature(ColorTexto("Se te ha bloqueado el nivel 12", TXT_COLOR_ROJO), oPJ, FALSE);
  SendMessageToPC(oJugador_DM, "Le has bloqueado el nivel 12 a " + GetName(oPJ, TRUE) + ".");
}
