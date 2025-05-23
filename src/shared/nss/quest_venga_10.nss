#include "mti_libreria"
int StartingConditional()
{

object oPC = GetPCSpeaker();
int nComprobarVar = ObtenerIntPersistente(oPC, "QUEST_VENGA_ESMEL_5");

if(!(nComprobarVar == 5)) return FALSE;

return TRUE;
}

