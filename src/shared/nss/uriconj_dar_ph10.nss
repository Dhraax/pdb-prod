void main()
{
  int iOro = GetGold(GetPCSpeaker());
  if(iOro >= 3000)
  {
      TakeGoldFromCreature(3000, GetPCSpeaker(), TRUE);
      CreateItemOnObject("enjambrearacnido", GetPCSpeaker(), 1);
      GiveXPToCreature(GetPCSpeaker(),300);
  }

  else
  {
      ActionSpeakString("¡No tienes suficientes esclavos escoria!, sal ahora mismo de mi vista y no vuelva hasta que tengas mas esclavos.");
  }
}
