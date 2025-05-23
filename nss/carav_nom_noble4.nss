#include "mti_libreria"

int StartingConditional()
{
object oPC = GetPCSpeaker();
int nComprobarVar = ObtenerIntPersistente(oPC, "QUEST_CARAVASAR_LUXARROL");
int otravariable = ObtenerIntPersistente(oPC, "NOBLESBURLADOS");


if(nComprobarVar == 1)
   {
   if(!(otravariable == 1)) return TRUE;
   return FALSE;
   }

return FALSE;
}



