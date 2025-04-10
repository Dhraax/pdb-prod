#include "mti_libreria"

void main()
{
  object oPC = GetPCSpeaker();

  CreateItemOnObject("llavedelportacle", oPC, 1);
  GuardarIntPersistente(oPC, "QUESTARACH", 1);
}
