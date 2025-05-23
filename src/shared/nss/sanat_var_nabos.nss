#include "mti_libreria"
int StartingConditional()
{

object oPC = GetPCSpeaker();
int nComprobarVar = ObtenerIntPersistente(oPC, "NABOS_SANATORIO");

if(!(nComprobarVar == 1)) return FALSE;

return TRUE;
}

