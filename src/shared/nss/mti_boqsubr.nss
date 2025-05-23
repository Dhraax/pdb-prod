#include "mti_libreria"
void main()
{
  object oPC = GetPCSpeaker();
  object oObjetivo = GetLocalObject(oPC, "VJDM_OBJETIVO");

  GuardarIntPersistente(oObjetivo, "SUBRAZAACEPTADA", 0);
  FloatingTextStringOnCreature(ColorTexto("Se te ha bloqueado la raza/subraza", TXT_COLOR_ROJO), oObjetivo, FALSE);
  SendMessageToPC(oPC, "Le has bloqueado la raza/subraza a " + GetName(oObjetivo, TRUE) + ".");
}
