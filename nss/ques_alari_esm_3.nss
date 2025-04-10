#include "mti_libreria"
int StartingConditional()
{

object oPC = GetPCSpeaker();
int nComprobarVar = ObtenerIntPersistente(oPC, "QUEST_ALARICO_ESMEL");

if(!(nComprobarVar == 2)) return FALSE;

return TRUE;
}

