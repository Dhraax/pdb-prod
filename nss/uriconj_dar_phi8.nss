void main()
{
  int iOro = GetGold(GetPCSpeaker());
  if(iOro >= 20000)
  {
      TakeGoldFromCreature(20000, GetPCSpeaker(), TRUE);
      CreateItemOnObject("entdeguerra", GetPCSpeaker());
      GiveXPToCreature(GetPCSpeaker(),400);
  }
  else ActionSpeakString("¡No es una ofrenda suficientemente valiosa! Vuelve a mi cuando tengas una ofrenda acorde a lo que pido.");
}
