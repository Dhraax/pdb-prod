#include "mti_libreria"
void main()
{
  object oPC = GetPCSpeaker();

  CreateItemOnObject("qui_aliadotierra", oPC);
  SetXP(oPC, GetXP(oPC) + 500);
  GuardarIntPersistente(oPC, "LITHQUESTEOWO", 3);
}
