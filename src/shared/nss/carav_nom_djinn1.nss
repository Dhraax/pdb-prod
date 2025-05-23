#include "mti_libreria"
int StartingConditional()
{
object oPC = GetPCSpeaker();
int nComprobarVar = ObtenerIntPersistente(oPC, "QUEST_CARAVASAR_DJINN");


if(GetItemPossessedBy(oPC, "caravasarcabezarakasha") != OBJECT_INVALID)
   {
   if( nComprobarVar == 2 ) return TRUE;
   return FALSE;
   }
return FALSE;
}

