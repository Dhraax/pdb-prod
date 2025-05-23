#include "mti_libreria"
int StartingConditional()
{
object oPC = GetPCSpeaker();

int iVariable = ObtenerIntPersistente(oPC, "DESPELLEJADOR_CARAVASSAR");


if(GetItemPossessedBy(oPC, "CuerpoinconscientedeTyris") != OBJECT_INVALID)
   {
   if(iVariable ==3) return TRUE;
   return FALSE;
   }
return FALSE;
}








