#include "mti_libreria"
void main()
{
  object oPC = GetPCSpeaker();
  GuardarIntPersistente(oPC, "LITHQUESTHADA", 4);
  SetXP(oPC, GetXP(oPC) + 100);
  CreateItemOnObject("nw_it_msmlmisc19", oPC);
}
