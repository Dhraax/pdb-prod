// Ir al Enclave Esmeralda

#include "inicio_mundo_inc"

void main()
{
  object oPC = GetPCSpeaker();

  // Comprobaciones iniciales...
  if(ComprobarRestriccionesIniciales(oPC) == FALSE) return;
  location lEnclave = GetLocation(GetWaypointByTag("kro_enclave_esmeralda"));
  DelayCommand(1.9, AssignCommand(oPC, ClearAllActions()));
  DelayCommand(2.0, AssignCommand(oPC, ActionJumpToLocation(lEnclave)));
}
