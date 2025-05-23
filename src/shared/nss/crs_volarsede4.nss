// Aliado / Esclavo de Murann

#include "inicio_mundo_inc"

void main()
{
  object oPC = GetPCSpeaker();

  // Comprobaciones iniciales...
  if(ComprobarRestriccionesIniciales(oPC) == FALSE) return;

  location lMurann = GetLocation(GetWaypointByTag("inicio_minotauros"));

  if(GetItemPossessedBy(oPC, "aliadomurann") != OBJECT_INVALID)
  {
      DelayCommand(1.9, AssignCommand(oPC, ClearAllActions()));
      DelayCommand(2.0, AssignCommand(oPC, ActionJumpToLocation(lMurann)));
  }
}
