#include "mti_libreria"

int StartingConditional()
{
object oPC = GetPCSpeaker();
int nComprobarVar1 = ObtenerIntPersistente(oPC, "QUEST_CARAVASAR_LUXARROL");
int nComprobarVar2 = ObtenerIntPersistente(oPC, "QUEST_CARAVASAR_ALIKABAR");


if((nComprobarVar1 == 2)||(nComprobarVar2 == 2)) return TRUE;

return FALSE;
}
