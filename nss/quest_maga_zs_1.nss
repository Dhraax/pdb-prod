#include "mti_libreria"
void main()
{
  object oPC = GetPCSpeaker();
  GuardarIntPersistente(oPC, "QUEST_MAGA_ZS", 1);
}
