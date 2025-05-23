#include "mti_libreria"

int StartingConditional()
{
object oPC = GetPCSpeaker();

int otravariable = ObtenerIntPersistente(oPC, "ALCALDECARAVASAR");



if(otravariable == 2) return TRUE;

return FALSE;
}

