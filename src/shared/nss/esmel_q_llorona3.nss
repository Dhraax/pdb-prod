#include "mti_libreria"
int StartingConditional()
{

object oPC = GetPCSpeaker();
int nComprobarVar = ObtenerIntPersistente(oPC, "ESMEL_QUEST_LLORONA");

if(!(nComprobarVar == 2)) return FALSE;

return TRUE;
}

