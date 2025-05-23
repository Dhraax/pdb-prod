void main()
{
  object oJugador = GetLastUsedBy();
  AssignCommand(oJugador, ActionJumpToObject(GetWaypointByTag("salida_corsariogolpe")));
  DestroyObject(GetItemPossessedBy(oJugador, "corsario_golpedequilla"));
}

