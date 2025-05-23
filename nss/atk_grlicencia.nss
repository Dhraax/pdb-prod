void main()
{
  object oPC = GetPCSpeaker();
  int iOro = GetGold(oPC);

  if(iOro < 5000)
  {
      SendMessageToPC(oPC, "*¡No tienes tanto dinero!*");
      return;
  }

  CreateItemOnObject("licenciagr", oPC);
  TakeGoldFromCreature(5000, oPC, TRUE);
  AssignCommand(OBJECT_SELF, ActionSpeakString("Aquí tienes tu licencia, ahora estarás dentro de la absoluta legalidad."));
}
