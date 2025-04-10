int StartingConditional()
{
  object oPC = GetPCSpeaker();
  object oPuestoVenta = GetItemPossessedBy(oPC, "tj_tienda");

  if(GetIsObjectValid(oPuestoVenta) == TRUE) return TRUE;
  return FALSE;
}
