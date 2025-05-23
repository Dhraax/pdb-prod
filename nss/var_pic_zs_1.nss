#include "mti_libreria"
void main()
{
object oPC = GetPCSpeaker();
GuardarIntPersistente(oPC, "PICARO_ZS_RELIQUIA", 1);
}
