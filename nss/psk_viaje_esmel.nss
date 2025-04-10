void main()
{
  object oPC = GetPCSpeaker();
  object oMarinero = OBJECT_SELF;
  location lEsmeltaran = GetLocation(GetWaypointByTag("barco_esmel"));
  int iOro = GetGold(oPC);

  if(iOro < 2000)
  {
      SendMessageToPC(oPC, "*¡No tienes dos mil monedas de oro!*");
      return;
  }

  AssignCommand(oMarinero, SpeakString("Arreglado, ¡y no vuelvas!"));
  AssignCommand(oPC, TakeGoldFromCreature(2000, oPC, TRUE));
  DelayCommand(1.5, AssignCommand(oPC, ClearAllActions()));
  DelayCommand(1.6, AssignCommand(oPC, ActionJumpToLocation(lEsmeltaran)));
}
