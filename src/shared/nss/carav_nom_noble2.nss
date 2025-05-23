#include "mti_libreria"

int StartingConditional()
{
object oPC = GetPCSpeaker();
int nComprobarVar1 = ObtenerIntPersistente(oPC, "QUEST_CARAVASAR_LUXARROL");
int nComprobarVar2 = ObtenerIntPersistente(oPC, "QUEST_CARAVASAR_ALIKABAR");
int otravariable = ObtenerIntPersistente(oPC, "ALCALDECARAVASAR");

if(!(otravariable == 2)) return FALSE;
if((nComprobarVar1 == 1) || (nComprobarVar1 == 2)) return FALSE;
if((nComprobarVar2 == 1) || (nComprobarVar2 == 2)) return FALSE;

return TRUE;
}
