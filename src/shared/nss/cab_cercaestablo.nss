int StartingConditional()
{
  object oPC = GetPCSpeaker();
  location lLugarEstablo = GetLocation(GetWaypointByTag(GetTag(GetArea(oPC)) + "establo"));
  float fDistanciaEstablo = GetDistanceBetweenLocations(GetLocation(oPC), lLugarEstablo);

  if(fDistanciaEstablo == -1.0 || fDistanciaEstablo > 15.0) return TRUE;

  return FALSE;
}
