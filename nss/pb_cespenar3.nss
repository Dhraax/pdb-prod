#include "mti_libreria"

void main()
{
  object oPC = GetPCSpeaker();
  GuardarIntPersistente(oPC, "VAR_CESPENAR", 1);

}
