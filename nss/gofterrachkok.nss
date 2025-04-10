//::///////////////////////////////////////////////
//:: FileName gofterrachkok
//:://////////////////////////////////////////////
#include "mti_libreria"

int StartingConditional()
{
object oPC = GetPCSpeaker();
int nComprobarVar = ObtenerIntPersistente(oPC, "gofterrafin");

if(nComprobarVar == 1) return TRUE;

return FALSE;
}
