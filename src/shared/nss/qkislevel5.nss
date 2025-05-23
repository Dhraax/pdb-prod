#include "mti_libreria"

void main()
{
  object oPC = GetPCSpeaker();

  CreateItemOnObject("odisea", oPC);
  GuardarIntPersistente(oPC, "QUESTRIBALD", 1);
}
