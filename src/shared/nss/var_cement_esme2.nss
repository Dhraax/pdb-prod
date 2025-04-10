#include "mti_libreria"
int StartingConditional()
{

object oPC = GetPCSpeaker();
int nComprobarVar = ObtenerIntPersistente(oPC, "AVISO_CEMENTERIO");

if(!(nComprobarVar == 1)) return FALSE;

return TRUE;
}

