// Ir a Suldanessalar desde la Bolsa Planar (solo para elfos o invitados)

#include "inicio_mundo_inc"
#include "lib_race"

void main()
{
  object oPC = GetPCSpeaker();

  // Comprobaciones iniciales...
  if(ComprobarRestriccionesIniciales(oPC) == FALSE) return;

  location lSuldanessalar = GetLocation(GetWaypointByTag("WP_Suldanessalar"));
  string sSubraza = GetStringLowerCase(GetSubRace(oPC));

  if(PB_Race_GetIsElf(oPC) || GetRacialType(oPC) == RACIAL_TYPE_HALFELF ||
     GetItemPossessedBy( oPC, "AliadodeSuldanessalar") != OBJECT_INVALID &&
     sSubraza != "drow" &&
     sSubraza != "vampiro" &&
     sSubraza != "ghul" &&
     sSubraza != "semidrow")
  {
      DelayCommand(1.9, AssignCommand(oPC, ClearAllActions()));
      DelayCommand(2.0, AssignCommand(oPC, ActionJumpToLocation(lSuldanessalar)));
  }
}
