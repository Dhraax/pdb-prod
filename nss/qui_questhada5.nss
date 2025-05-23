#include "mti_libreria"
void main()
{
  object oPC = GetPCSpeaker();
  GuardarIntPersistente(oPC, "LITHQUESTHADA", 3);
  SetXP(oPC, GetXP(oPC) + 100);
}
