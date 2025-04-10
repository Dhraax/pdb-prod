// Ir a los 17 Centinelas desde la Bolsa Planar

#include "inicio_mundo_inc"

void main()
{
  object oPC = GetPCSpeaker();

  // Comprobaciones iniciales...
  if(ComprobarRestriccionesIniciales(oPC) == FALSE) return;

  location lCentinelas = GetLocation(GetWaypointByTag("17centinelas_tel"));

  if(GetIsObjectValid(GetItemPossessedBy(oPC, "_llavecentinelas")) ||
          GetIsObjectValid(GetItemPossessedBy(oPC, "cuerno_centinelas")))
  {
      DelayCommand(1.9, AssignCommand(oPC, ClearAllActions()));
      DelayCommand(2.0, AssignCommand(oPC, ActionJumpToLocation(lCentinelas)));
  }
}
