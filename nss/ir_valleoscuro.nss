// Ir al Valle Oscuro desde la Bolsa Planar (solo para razas de la antipoda)

#include "inicio_mundo_inc"

void main()
{
  object oPC = GetPCSpeaker();

  // Comprobaciones iniciales...
  if(ComprobarRestriccionesIniciales(oPC) == FALSE) return;

  location lValleOscuro = GetLocation(GetWaypointByTag("WP_a_gruta_osc_infra"));

  DelayCommand(1.9, AssignCommand(oPC, ClearAllActions()));
  DelayCommand(2.0, AssignCommand(oPC, ActionJumpToLocation(lValleOscuro)));
}
