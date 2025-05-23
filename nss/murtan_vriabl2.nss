#include "mti_libreria"
int StartingConditional()
{
object oPC = GetPCSpeaker();

if(ObtenerIntPersistente(oPC, "QUEST_HERO") == 1) return FALSE;
return TRUE;
}
