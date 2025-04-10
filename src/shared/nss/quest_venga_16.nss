
#include "mti_libreria"
int StartingConditional()
{

object oPC = GetPCSpeaker();
int nComprobarVar = ObtenerIntPersistente(oPC, "QUEST_VENGA_ESMEL_8");

if(!(nComprobarVar == 8)) return FALSE;

return TRUE;
}

