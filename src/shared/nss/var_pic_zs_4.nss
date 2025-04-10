#include "mti_libreria"
int StartingConditional()
{

object oPC = GetPCSpeaker();
int nComprobarVar = ObtenerIntPersistente(oPC, "PICARO_ZS_RELIQUIA");

if(!(nComprobarVar == 2)) return FALSE;

return TRUE;
}

