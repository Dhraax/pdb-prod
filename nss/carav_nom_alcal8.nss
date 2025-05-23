#include "mti_libreria"

int StartingConditional()
{
object oPC = GetPCSpeaker();


if(GetItemPossessedBy(oPC, "uri_mantowauken") != OBJECT_INVALID)
   {
   return TRUE;
   }
return FALSE;
}
