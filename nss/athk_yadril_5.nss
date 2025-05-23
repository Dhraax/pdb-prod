#include "mti_libreria"
int StartingConditional()
{

object oPC = GetPCSpeaker();
int nComprobarVar = ObtenerIntPersistente(oPC, "YADRIL_CALLES_F");

if(!(nComprobarVar == 1)) return FALSE;

return TRUE;
}

