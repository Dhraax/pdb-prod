#include "mti_libreria"
void main()
{
  object oPC = GetPCSpeaker();
  GuardarIntPersistente(oPC, "LITHQUESTHADA", 1);
}
