#include "mti_libreria"
int StartingConditional()
{

object oPC = GetPCSpeaker();
int nComprobarVar = ObtenerIntPersistente(oPC, "ESPOSA_COMPULGIDA");

if(!(nComprobarVar == 2)) return FALSE;

return TRUE;
}

