#include "mti_libreria"
void main()
{
  object oJugador_DM = GetPCSpeaker();
  object oPJ = GetLocalObject(oJugador_DM, "VJDM_OBJETIVO");

  SetCampaignInt("DESBLOQUEO", "NIVEL17", 1, oPJ);
  FloatingTextStringOnCreature(ColorTexto("Se te ha concedido permiso para subir al nivel 17", TXT_COLOR_CELESTE), oPJ, FALSE);
  SendMessageToPC(oJugador_DM, "Le has desbloqueado el nivel 17 a " + GetName(oPJ) + ".");
}
