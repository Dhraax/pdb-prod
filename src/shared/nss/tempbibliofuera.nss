void main()
{
  object oJugador = GetLastUsedBy();
  AssignCommand(oJugador, ActionJumpToObject(GetWaypointByTag("WP_bibliosalida")));
}
