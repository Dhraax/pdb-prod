#include "mti_libreria"

int StartingConditional()
{
object oPC = GetPCSpeaker();

int otravariable = ObtenerIntPersistente(oPC, "ALCALDECARAVASAR");



if(otravariable == 5) return TRUE;

return FALSE;
}

