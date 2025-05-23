void main()
{



    int iOro = GetGold(GetPCSpeaker());
        if(iOro >= 5000)
            {
          TakeGoldFromCreature(5000, GetPCSpeaker(), TRUE);
          CreateItemOnObject("llamarraices", GetPCSpeaker(), 1);
          GiveXPToCreature(GetPCSpeaker(),400);
            }
         else
            {
            ActionSpeakString("¡No tienes suficiente oro!, Vuelve a mi cuando tengas el oro que pido.");

            }

}

