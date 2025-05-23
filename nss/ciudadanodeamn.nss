int StartingConditional()
{
  object oPC = GetPCSpeaker();
  object oCiudadano = GetItemPossessedBy(oPC, "permisodeciudada");

  if(GetIsObjectValid(oCiudadano) == TRUE) return TRUE;
  return FALSE;
}
