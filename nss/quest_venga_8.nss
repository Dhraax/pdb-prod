#include "mti_libreria"
int StartingConditional()
{

object oPC = GetPCSpeaker();
int nComprobarVar = ObtenerIntPersistente(oPC, "QUEST_VENGA_ESMEL_4");

if(!(nComprobarVar == 4)) return FALSE;

return TRUE;
}

