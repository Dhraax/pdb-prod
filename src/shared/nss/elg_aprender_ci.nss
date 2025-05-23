void main()
{
  object oPC = GetLastUsedBy();

  if(GetItemPossessedBy(oPC, "comprensionidiom") != OBJECT_INVALID)
  {
      SendMessageToPC(oPC, "<cþ>No encuentras nada más en las hojas de papel.</c>");
      return;
  }

  if(GetLevelByClass(CLASS_TYPE_BARD, oPC) == 0 &&
     GetLevelByClass(CLASS_TYPE_CLERIC, oPC) == 0 &&
     GetLevelByClass(CLASS_TYPE_WIZARD, oPC) == 0 &&
     GetLevelByClass(CLASS_TYPE_SORCERER, oPC) == 0)
  {
      SendMessageToPC(oPC, "<cþ>Encontraste un pergamino de [Comprensión idiomática] pero al no ser bardo, ni cérigo, ni mago, ni hechicero no conseguiste aprender el conjuro.</c>");
      return;
  }

  SendMessageToPC(oPC, "<c þ >¡Encontraste un pergamino de [Comprensión idiomática] y conseguiste aprenderlo!</c>");
  CreateItemOnObject("comprensionidiom", oPC);
}
