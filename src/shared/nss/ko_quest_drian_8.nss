#include "mti_libreria"

int StartingConditional()
{
object oPC = GetPCSpeaker();
int nComprobarVar = ObtenerIntPersistente(oPC, "QUEST_CAMINOCOSTA_DRIANNA");

if(nComprobarVar == 4) return TRUE;

return FALSE;
}
