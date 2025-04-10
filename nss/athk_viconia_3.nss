#include "mti_libreria"
int StartingConditional()
{

object oPC = GetPCSpeaker();
int nComprobarVar = ObtenerIntPersistente(oPC, "SALVAR_VICONIA");

if(!(nComprobarVar == 1)) return FALSE;

return TRUE;
}
