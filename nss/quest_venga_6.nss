#include "mti_libreria"
int StartingConditional()
{

object oPC = GetPCSpeaker();
int nComprobarVar = ObtenerIntPersistente(oPC, "QUEST_VENGA_ESMEL_3");

if(!(nComprobarVar == 3)) return FALSE;

return TRUE;
}

