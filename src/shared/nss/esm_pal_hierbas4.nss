#include "mti_libreria"
void main()
{
  object oPC = GetPCSpeaker();

  GuardarIntPersistente(oPC, "ESM_PALACIOHIERBAS", 2);
  SetXP(oPC, GetXP(oPC) + 500);
  AdjustAlignment(oPC, ALIGNMENT_LAWFUL, 2);
}
