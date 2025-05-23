#include "mti_libreria"
int StartingConditional()
{

object oPC = GetPCSpeaker();
int nComprobarVar = ObtenerIntPersistente(oPC, "QUEST_VENGA_ESMEL_7");

if(!(nComprobarVar == 7)) return FALSE;

return TRUE;
}

