#include "mti_libreria"
int StartingConditional()
{
  object oPC = GetPCSpeaker();

  int iVariable = ObtenerIntPersistente(oPC, "DESPELLEJADOR_FINAL_CHUNGO");

  if(iVariable ==1) return TRUE;
  return FALSE;
}
