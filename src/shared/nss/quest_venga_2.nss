#include "mti_libreria"
int StartingConditional()
{

object oPC = GetPCSpeaker();
int nComprobarVar = ObtenerIntPersistente(oPC, "QUEST_VENGA_ESMEL");

if(!(nComprobarVar == 1)) return FALSE;

return TRUE;
}
