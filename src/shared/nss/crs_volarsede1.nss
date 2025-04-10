// Aliado / Esclavo de Amn

#include "inicio_mundo_inc"

void main()
{
  object oPC = GetPCSpeaker();

  // Comprobaciones iniciales...
  if(ComprobarRestriccionesIniciales(oPC) == FALSE) return;

  location lAthkatla = GetLocation(GetWaypointByTag("crs_amn_llanos"));

  if(GetItemPossessedBy(oPC, "aliadoanm") != OBJECT_INVALID)
  {
      DelayCommand(1.9, AssignCommand(oPC, ClearAllActions()));
      DelayCommand(2.0, AssignCommand(oPC, ActionJumpToLocation(lAthkatla)));
  }
}
