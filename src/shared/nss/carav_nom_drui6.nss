#include "mti_libreria"

int StartingConditional()
{
object oPC = GetPCSpeaker();
int ivariable = ObtenerIntPersistente(oPC,"ALCALDECARAVASAR");

if((GetItemPossessedBy(oPC, "CabezadeldruidasombriodeWeldath") != OBJECT_INVALID) && (ivariable == 6) )
   {
   return TRUE;
   }
return FALSE;
}
