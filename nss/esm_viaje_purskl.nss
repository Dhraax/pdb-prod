void main()
{
  object oPC = GetPCSpeaker();
  object oZach = OBJECT_SELF;
  location lPurskul = GetLocation(GetWaypointByTag("barco_purskul"));
  int iOro = GetGold(oPC);

  if(iOro < 1000)
  {
      SendMessageToPC(oPC, "*¡No tienes mil monedas de oro!*");
      return;
  }

  AssignCommand(oZach, SpeakString("¡Perfecto! ¡Buen viaje!"));
  AssignCommand(oPC, TakeGoldFromCreature(1000, oPC, TRUE));
  DelayCommand(1.5, AssignCommand(oPC, ClearAllActions()));
  DelayCommand(1.6, AssignCommand(oPC, ActionJumpToLocation(lPurskul)));
}
