int StartingConditional()
{
  object oPC = GetPCSpeaker();

  // Comprobar si el PJ que habla tiene los objetos en su inventario
  if(GetIsObjectValid(GetItemPossessedBy(oPC, "_llavecentinelas")) ||
     GetIsObjectValid(GetItemPossessedBy(oPC, "cuerno_centinelas"))) return TRUE;

  return FALSE;
}
