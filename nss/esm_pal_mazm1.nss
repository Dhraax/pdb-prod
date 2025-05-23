#include "mti_libreria"
void main()
{
  object oPC = GetPCSpeaker();
  GuardarIntPersistente(oPC, "ESM_PALACIOMAZMORRAS", 1);
}
