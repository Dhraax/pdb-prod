// Aliado / Esclavo de los Drows

#include "inicio_mundo_inc"

void main()
{
  object oPC = GetPCSpeaker();

  // Comprobaciones iniciales...
  if(ComprobarRestriccionesIniciales(oPC) == FALSE) return;

  location lUstNatha = GetLocation(GetWaypointByTag("inicio_drows"));

  if(GetItemPossessedBy(oPC, "aliadodrow") != OBJECT_INVALID)
  {
      DelayCommand(1.9, AssignCommand(oPC, ClearAllActions()));
      DelayCommand(2.0, AssignCommand(oPC, ActionJumpToLocation(lUstNatha)));
  }
}
