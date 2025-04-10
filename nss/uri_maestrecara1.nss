#include "mti_libreria"

int StartingConditional()
{
object oPC = GetPCSpeaker();
int nComprobarVar = ObtenerIntPersistente(oPC, "QUEST_CARAVASAR_DJINN");
int otravariable = ObtenerIntPersistente(oPC, "MAESTRECARAVASAR");



if((nComprobarVar == 3) && (!otravariable == 1)) return TRUE;

return FALSE;
}

