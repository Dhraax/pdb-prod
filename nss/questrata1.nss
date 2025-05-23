#include "mti_libreria"
int StartingConditional()
{

object oPC = GetPCSpeaker();
int nComprobarVar = ObtenerIntPersistente(oPC, "QUEST_MUR_RATA");

if(nComprobarVar == 1) return TRUE;
return FALSE;


}
