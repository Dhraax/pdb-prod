#include "mti_libreria"
void main()
{
  object oJugador_DM = GetPCSpeaker();
  object oPJ = GetLocalObject(oJugador_DM, "VJDM_OBJETIVO");

  SetXP(oPJ, 594999);
  SetCampaignInt("DESBLOQUEO", "NIVEL35", 0, oPJ);
  FloatingTextStringOnCreature(ColorTexto("Se te ha bloqueado el nivel 35", TXT_COLOR_ROJO), oPJ, FALSE);
  SendMessageToPC(oJugador_DM, "Le has bloqueado el nivel 35 a " + GetName(oPJ, TRUE) + ".");
}
