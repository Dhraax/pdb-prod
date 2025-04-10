#include "mti_libreria"

int StartingConditional()
{
object oPC = GetPCSpeaker();
int nComprobarVar = ObtenerIntPersistente(oPC, "QUEST_KAZAD_GRANITO_ROJO");

if ((GetItemPossessedBy(oPC, "ko_granito_rojo") == OBJECT_INVALID)||(nComprobarVar == 1)) return FALSE;


return TRUE;
}
