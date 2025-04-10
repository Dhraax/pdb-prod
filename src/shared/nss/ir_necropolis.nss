// Ir a la necrópolis desde la Bolsa Planar.

#include "inicio_mundo_inc"

void main()
{
  object oPC = GetPCSpeaker();
  string sSubraza = GetStringLowerCase(GetSubRace(oPC));
  // Comprobaciones iniciales...
  if(ComprobarRestriccionesIniciales(oPC) == FALSE) return;
  location lNecropolis = GetLocation(GetWaypointByTag("inicio_vamps"));
  if(sSubraza == "ghul")
  {
    lNecropolis = GetLocation(GetWaypointByTag("inicio_ghouls"));
  }
  DelayCommand(1.9, AssignCommand(oPC, ClearAllActions()));
  DelayCommand(2.0, AssignCommand(oPC, ActionJumpToLocation(lNecropolis)));
}
