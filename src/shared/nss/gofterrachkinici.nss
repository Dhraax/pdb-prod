//::///////////////////////////////////////////////
//:: FileName gofterrachkinici
//:://////////////////////////////////////////////
#include "mti_libreria"

int StartingConditional()
{
object oPC = GetPCSpeaker();
int nComprobarVar = ObtenerIntPersistente(oPC, "gofTerraStart");

if(nComprobarVar == 1) return TRUE;

return FALSE;
}
