void main()
{
  int iOro = GetGold(GetPCSpeaker());
  if(iOro >= 100000)
  {
      TakeGoldFromCreature(100000, GetPCSpeaker(), TRUE);
      CreateItemOnObject("permisodeciudada", GetPCSpeaker(), 1);
  }

  else
  {
      ActionSpeakString("¡No tienes suficiente oro! Vuelve a mi cuando tengas el oro que pido.");
  }
}
