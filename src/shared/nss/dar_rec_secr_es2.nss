#include "mti_libreria"
void main()
{
  object oPC = GetPCSpeaker();
  object oCarta = GetItemPossessedBy(oPC, "CartaalaUniversidaddeAthkatla");

  GuardarIntPersistente(oPC, "CARTA_SECR_ESMEL", 2);
  SetXP(oPC, GetXP(oPC) + 1000);
  if(GetIsObjectValid(oCarta) == TRUE) DestroyObject(oCarta);
}
