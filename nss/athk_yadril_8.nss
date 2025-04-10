#include "mti_libreria"
int StartingConditional()
{

object oPC = GetPCSpeaker();
int nComprobarVar = ObtenerIntPersistente(oPC, "YADRIL_CALLES");

if(!(nComprobarVar == 3)) return FALSE;

return TRUE;
}

