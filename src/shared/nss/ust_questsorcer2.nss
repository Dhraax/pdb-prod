#include "mti_libreria"

void main()
{
  object oPC = GetPCSpeaker();

  CreateItemOnObject("llavedelportalat", oPC, 1);
  GuardarIntPersistente(oPC, "QUESTSORCERE", 1);
}
