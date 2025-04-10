// Ir a Kazad Gromdal desde la Bolsa Planar

#include "inicio_mundo_inc"

void main()
{
  object oPC = GetPCSpeaker();

  // Comprobaciones iniciales...
  if(ComprobarRestriccionesIniciales(oPC) == FALSE) return;

  location lKazadGromdal = GetLocation(GetWaypointByTag("antipoda_tel"));

  DelayCommand(1.9, AssignCommand(oPC, ClearAllActions()));
  DelayCommand(2.0, AssignCommand(oPC, ActionJumpToLocation(lKazadGromdal)));
}
