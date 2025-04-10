#include "mti_libreria"
void main()
{
  object oPC = GetPCSpeaker();
  object oObjetivo = GetLocalObject(oPC, "VJDM_OBJETIVO");

  SetCampaignInt("DESBLOQUEO", "NIVEL35", 1, oObjetivo);
  FloatingTextStringOnCreature(ColorTexto("Se te ha concedido permiso para subir al nivel 35", TXT_COLOR_CELESTE), oObjetivo, FALSE);
  SendMessageToPC(oPC, "Le has desbloqueado el nivel 35 a " + GetName(oObjetivo, TRUE) + ".");
}
