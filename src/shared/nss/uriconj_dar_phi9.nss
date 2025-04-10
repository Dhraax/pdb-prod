void main()
{
  int iOro = GetGold(GetPCSpeaker());
  if(iOro >= 10000)
  {
      TakeGoldFromCreature(10000, GetPCSpeaker(), TRUE);
      CreateItemOnObject("formasdearana2", GetPCSpeaker(), 1);
      GiveXPToCreature(GetPCSpeaker(),400);
  }

  else
  {
      ActionSpeakString("¡No tienes suficientes esclavos escoria!, sal ahora mismo de mi vista y no vuelva hasta que tengas mas esclavos.");
  }
}
