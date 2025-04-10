//::///////////////////////////////////////////////
//:: FileName gof_chkcristok
//:://////////////////////////////////////////////
#include "mti_libreria"

int StartingConditional()
{
object oPC = GetPCSpeaker();
int nComprobarVar = ObtenerIntPersistente(oPC, "gof_cristalOK");

if(nComprobarVar == 1) return TRUE;

return FALSE;
}
