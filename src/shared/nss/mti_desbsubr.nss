#include "mti_libreria"
void main()
{
  object oPC = GetPCSpeaker();
  object oObjetivo = GetLocalObject(oPC, "VJDM_OBJETIVO");

  GuardarIntPersistente(oObjetivo, "SUBRAZAACEPTADA", 1);
  FloatingTextStringOnCreature(ColorTexto("Se te ha desbloqueado la raza/subraza", TXT_COLOR_CELESTE), oObjetivo, FALSE);
  SendMessageToPC(oPC, "Le has desbloqueado la raza/subraza a " + GetName(oObjetivo, TRUE) + ".");
}
