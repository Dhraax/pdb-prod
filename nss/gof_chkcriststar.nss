#include "mti_libreria"

int StartingConditional()
{
object oPC = GetPCSpeaker();
int nComprobarVar = ObtenerIntPersistente(oPC, "gof_questcriststart");

if(nComprobarVar == 1) return TRUE;

return FALSE;
}
