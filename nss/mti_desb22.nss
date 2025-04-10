#include "mti_libreria"
void main()
{
  object oJugador_DM = GetPCSpeaker();
  object oPJ = GetLocalObject(oJugador_DM, "VJDM_OBJETIVO");

  SetCampaignInt("DESBLOQUEO", "NIVEL22", 1, oPJ);
  FloatingTextStringOnCreature(ColorTexto("Se te ha concedido permiso para subir al nivel 22", TXT_COLOR_CELESTE), oPJ, FALSE);
  SendMessageToPC(oJugador_DM, "Le has desbloqueado el nivel 22 a " + GetName(oPJ, TRUE) + ".");
}
