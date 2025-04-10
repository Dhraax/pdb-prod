#include "mti_libreria"
int StartingConditional()
{
  object oPC = GetPCSpeaker();
  int iVariable1 = ObtenerIntPersistente(oPC, "PELETRERO_AESSINO");
  int iVariable2 = ObtenerIntPersistente(oPC, "HABLACONTIRIS");

  if((iVariable1 == 2) && !(iVariable2 ==1)&& !(iVariable2 ==2)) return TRUE;
  return FALSE;
}
