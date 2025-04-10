#include "mti_libreria"
void main()
{
  object oPC = GetPCSpeaker();
  int iVariable = ObtenerIntPersistente(oPC, "ESM_PALACIOHIERBAS");

  if(iVariable == 0) GuardarIntPersistente(oPC, "ESM_PALACIOHIERBAS", 1);
}
