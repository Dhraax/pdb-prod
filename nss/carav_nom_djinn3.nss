#include "mti_libreria"

int StartingConditional()
{
object oPC = GetPCSpeaker();
int nComprobarVar = ObtenerIntPersistente(oPC, "QUEST_CARAVASAR_DJINN");

if(nComprobarVar == 1 || nComprobarVar == 2 ) return TRUE;

return FALSE;
}
