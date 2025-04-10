#include "mti_libreria"

int StartingConditional()
{
object oPC = GetPCSpeaker();
int nComprobarVar = ObtenerIntPersistente(oPC, "QUEST_CARAVASAR_DJINN");
int otravariable = ObtenerIntPersistente(oPC, "ALCALDECARAVASAR");


if(nComprobarVar == 3 || otravariable == 7) return TRUE;

return FALSE;
}
