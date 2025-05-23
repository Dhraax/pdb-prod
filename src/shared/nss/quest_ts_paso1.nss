#include "mti_libreria"

void main()
{
  object oPC = GetPCSpeaker();

  GuardarIntPersistente(oPC, "QUEST_TS", 1);
  CreateItemOnObject("quest_ts_mapa", oPC);
}
