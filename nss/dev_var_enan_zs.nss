#include "mti_libreria"
int StartingConditional()
{

object oPC = GetPCSpeaker();
int nComprobarVar = ObtenerIntPersistente(oPC, "ENANO_RATAS_ZAP_SUNE");

if(!(nComprobarVar == 1)) return FALSE;

return TRUE;
}

