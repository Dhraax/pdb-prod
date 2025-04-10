#include "mti_libreria"

int StartingConditional()
{
object oPC = GetPCSpeaker();
int nComprobarVar = ObtenerIntPersistente(oPC, "QUEST_CN_NINFA");

if((nComprobarVar != 1)&&(nComprobarVar != 2)&&(nComprobarVar != 3)) return TRUE;

return FALSE;
}
