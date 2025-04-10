#include "mti_libreria"

int StartingConditional()
{
object oPC = GetPCSpeaker();

int otravariable = ObtenerIntPersistente(oPC, "ALCALDECARAVASAR");



if(otravariable == 1) return TRUE;

return FALSE;
}

