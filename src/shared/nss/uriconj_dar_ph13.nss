void main()
{
  int iOro = GetGold(GetPCSpeaker());

  if(iOro >= 1000)
  {
      TakeGoldFromCreature(1000, GetPCSpeaker(), TRUE);
      CreateItemOnObject("sute_s_longstrid", GetPCSpeaker(), 1);
      GiveXPToCreature(GetPCSpeaker(),100);
  }

  else
  {
      ActionSpeakString("¡No tienes suficiente oro! Vuelve a mi cuando tengas el oro que pido.");
  }
}
