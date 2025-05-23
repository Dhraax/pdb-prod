#include "mti_libreria"
void main()
{
object oPC = GetPCSpeaker();
GuardarIntPersistente(oPC, "ESPOSA_COMPULGIDA", 1);
}

