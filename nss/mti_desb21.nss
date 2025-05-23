#include "mti_libreria"
void main()
{
  object oJugador_DM = GetPCSpeaker();
  object oPJ = GetLocalObject(oJugador_DM, "VJDM_OBJETIVO");

  SetCampaignInt("DESBLOQUEO", "NIVEL21", 1, oPJ);
  FloatingTextStringOnCreature(ColorTexto("Se te ha concedido permiso para subir al nivel 21", TXT_COLOR_CELESTE), oPJ, FALSE);
  SendMessageToPC(oJugador_DM, "Le has desbloqueado el nivel 21 a " + GetName(oPJ, TRUE) + ".");
}
