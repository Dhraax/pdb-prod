#include "mti_libreria"
int StartingConditional()
{

object oPC = GetPCSpeaker();
int nComprobarVar = ObtenerIntPersistente(oPC, "MARIUS_RELIQUIA");

if(!(nComprobarVar == 1)) return FALSE;

return TRUE;
}

