void main()
{
  object oPC = GetPCSpeaker();
  object item = GetItemPossessedBy(oPC,"uri_ojooso");

  DestroyObject(item);
  GiveXPToCreature(oPC, 500);
  GiveGoldToCreature(oPC, 1000);
  CreateItemOnObject("ReliquiadeEdive", oPC);

  DeleteLocalInt(oPC, "QUESTMISNOR");
}
