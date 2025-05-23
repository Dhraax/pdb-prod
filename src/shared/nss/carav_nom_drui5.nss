#include "mti_libreria"

int StartingConditional()
{
object oPC = GetLastSpeaker();

int otravariable = ObtenerIntPersistente(oPC, "ALCALDECARAVASAR");

if(otravariable == 6) return TRUE;

return FALSE;
}
