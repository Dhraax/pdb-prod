#include "mti_libreria"
int StartingConditional()
{

object oPC = GetPCSpeaker();
int nComprobarVar =

ObtenerIntPersistente(oPC,

"QUESTLUNHAART");

if(!(nComprobarVar == 4)) return FALSE;

return TRUE;
}

