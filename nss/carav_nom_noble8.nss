#include "mti_libreria"

int StartingConditional()
{
object oPC = GetPCSpeaker();
int nComprobarVar = ObtenerIntPersistente(oPC, "QUEST_CARAVASAR_ALIKABAR");

if(nComprobarVar == 2) return TRUE;

return FALSE;
}
