// Ir a Murann desde la Bolsa Planar.

#include "inicio_mundo_inc"

void main()
{
  object oPC = GetPCSpeaker();
  string sSubraza = GetStringLowerCase(GetSubRace(oPC));
  location lMinotauros = GetLocation(GetWaypointByTag("inicio_minotauros"));
  location lTrasgos = GetLocation(GetWaypointByTag("inicio_trasgos"));
  location lOgros = GetLocation(GetWaypointByTag("inicio_ogros"));
  // Comprobaciones iniciales...
  if(ComprobarRestriccionesIniciales(oPC) == FALSE) return;

  // MINOTAUROS, ORCOS Y OSGOS a ARENA DE MURANN
  if(sSubraza == "minotauro" || sSubraza == "orco" || sSubraza == "osgo" || sSubraza == "orco gris")
  {
      DelayCommand(1.9, AssignCommand(oPC, ClearAllActions()));
      DelayCommand(2.0, AssignCommand(oPC, ActionJumpToLocation(lMinotauros)));
      return;
  }
  else if(sSubraza == "trasgo" || sSubraza == "gran trasgo" || sSubraza == "kobold" || sSubraza == "gnoll")
  {
      DelayCommand(1.9, AssignCommand(oPC, ClearAllActions()));
      DelayCommand(2.0, AssignCommand(oPC, ActionJumpToLocation(lTrasgos)));
      return;
  }

  // OGROS, SEMIOGROS Y SEMIINFERNALES a DISTRITO NORTE DE MURANN
  else if(sSubraza == "ogro" || sSubraza == "ogro hechicero" || sSubraza == "semiogro" || sSubraza == "semiinfernal")
  {
      DelayCommand(1.9, AssignCommand(oPC, ClearAllActions()));
      DelayCommand(2.0, AssignCommand(oPC, ActionJumpToLocation(lOgros)));
      return;
  }


  DelayCommand(1.9, AssignCommand(oPC, ClearAllActions()));
  DelayCommand(2.0, AssignCommand(oPC, ActionJumpToLocation(lMinotauros)));
}
