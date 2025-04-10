void main()
{
  object oJugador = GetLastUsedBy();
  AssignCommand(oJugador, ActionJumpToObject(GetWaypointByTag("salida_marinerogolpe")));
  DestroyObject(GetItemPossessedBy(oJugador, "marinero_golpedequilla"));
}

