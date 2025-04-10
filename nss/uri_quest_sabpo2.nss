#include "mti_libreria"
int StartingConditional()
{

object oPC = GetPCSpeaker();
int nComprobarVar = ObtenerIntPersistente(oPC, "QUEST_SAB_POP_MERCADERES");

if(!(nComprobarVar == 1)) return FALSE;

return TRUE;
}
