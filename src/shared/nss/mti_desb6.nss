#include "mti_libreria"
void main()
{
  object oJugador_DM = GetPCSpeaker();
  object oPJ = GetLocalObject(oJugador_DM, "VJDM_OBJETIVO");

  SetCampaignInt("DESBLOQUEO", "NIVEL6", 1, oPJ);
  FloatingTextStringOnCreature(ColorTexto("Se te ha concedido permiso para subir al nivel 6", TXT_COLOR_CELESTE), oPJ, FALSE);
  SendMessageToPC(oJugador_DM, "Le has desbloqueado el nivel 6 a " + GetName(oPJ, TRUE) + ".");
}
