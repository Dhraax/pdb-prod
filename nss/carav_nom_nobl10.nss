#include "mti_libreria"

int StartingConditional()
{
object oPC = GetPCSpeaker();
int nComprobarVar = ObtenerIntPersistente(oPC, "QUEST_CARAVASAR_ALIKABAR");


if(GetItemPossessedBy(oPC, "uri_mantowauken") != OBJECT_INVALID)
   {
   if( nComprobarVar == 1 ) return TRUE;
   return FALSE;
   }
return FALSE;
}
