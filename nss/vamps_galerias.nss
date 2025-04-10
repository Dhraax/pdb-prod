void main()
{
  object oPC = GetClickingObject();
  string sPuntoderuta = "vamps_galerias1";
  string sSubraza = GetStringLowerCase(GetSubRace(oPC));
  location lPuntoderuta = GetLocation(GetWaypointByTag(sPuntoderuta));

  if(sSubraza == "vampiro" || sSubraza == "ghul" || sSubraza == "deathknight" || sSubraza == "necropolita" || sSubraza == "liche")
  {
      AssignCommand(oPC, ClearAllActions());
      AssignCommand(oPC, ActionJumpToLocation(lPuntoderuta));
  }

  else
  {
      SendMessageToPC(oPC, "*Al final del túnel hay una puerta cerrada con runas sangrientas que no soy capaz de abrirla*");
  }
}
