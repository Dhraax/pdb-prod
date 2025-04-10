// Aliado / Esclavo de los Vampiros

#include "inicio_mundo_inc"

void main()
{
  object oPC = GetPCSpeaker();

  // Comprobaciones iniciales...
  if(ComprobarRestriccionesIniciales(oPC) == FALSE) return;

  location lPrincipado = GetLocation(GetWaypointByTag("inicio_vamps"));
  location lCriptaOscura = GetLocation(GetWaypointByTag("WP_ko_espejo_necro_mansi"));

  if(GetItemPossessedBy(oPC, "asy_emblemavamp") != OBJECT_INVALID)
  {
      DelayCommand(1.9, AssignCommand(oPC, ClearAllActions()));
      DelayCommand(2.0, AssignCommand(oPC, ActionJumpToLocation(lPrincipado)));
  }
  else if(GetItemPossessedBy(oPC, "aliadovampis") != OBJECT_INVALID)
  {
      DelayCommand(1.9, AssignCommand(oPC, ClearAllActions()));
      DelayCommand(2.0, AssignCommand(oPC, ActionJumpToLocation(lCriptaOscura)));
  }
}
