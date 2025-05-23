void main()
{
  object oPC = GetLastUsedBy();
  string sEtiquetaUbicado = GetTag(OBJECT_SELF);
  location lIglesia = GetLocation(GetWaypointByTag("omrc_iglesia_in"));
  location lResidenciaEmb = GetLocation(GetWaypointByTag("omrc_residenciaemb_in"));
  location lResidenciaEsc = GetLocation(GetWaypointByTag("omrc_residenciaesc_in"));

  AssignCommand(oPC, ClearAllActions());

  if(sEtiquetaUbicado == "omrc_iraiglesia")
  {
      AssignCommand(oPC, ActionJumpToLocation(lIglesia));
  }

  else if(sEtiquetaUbicado == "omrc_iraresemb")
  {
      AssignCommand(oPC, ActionJumpToLocation(lResidenciaEmb));
  }

  else if(sEtiquetaUbicado == "omrc_iraresesc")
  {
      AssignCommand(oPC, ActionJumpToLocation(lResidenciaEsc));
  }
}
