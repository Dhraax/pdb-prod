void main()
{
  object oPC = GetPCSpeaker();

  // Dar algunos PX al que habla
  GiveXPToCreature(oPC, 2750);

  // Dar los objetos al que habla
  CreateItemOnObject("chaunteaquest", oPC, 1);

  // Eliminar objetos del inventario del jugador.
  object oAmuletoRoto = GetItemPossessedBy(oPC, "purskulselloroto");
  if(oAmuletoRoto != OBJECT_INVALID) DestroyObject(oAmuletoRoto);

  // Establecer las variables
  SetCampaignInt("QUESTPURSKUL", "AVANCE", 3, oPC);
}
