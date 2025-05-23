#include "mti_libreria"
int StartingConditional()
{
object oPC = GetPCSpeaker();

if(ObtenerIntPersistente(oPC, "ALANDARMA") == 1) return FALSE;
return TRUE;
}
