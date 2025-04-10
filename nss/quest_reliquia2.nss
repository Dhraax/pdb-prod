#include "mti_libreria"

void main()
{
  object oPC = GetPCSpeaker();
  GuardarIntPersistente(oPC, "QUEST_RELIQUIA_SAGRADA", 1);

}
