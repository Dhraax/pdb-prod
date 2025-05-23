void main()
{



    int iOro = GetGold(GetPCSpeaker());
        if(iOro >= 10000)
            {
          TakeGoldFromCreature(10000, GetPCSpeaker(), TRUE);
              SetCutsceneMode(GetPCSpeaker(),TRUE);
          FadeToBlack(GetPCSpeaker(),FADE_SPEED_MEDIUM);
          CreateItemOnObject("pieldehielo", GetPCSpeaker(), 1);
          GiveXPToCreature(GetPCSpeaker(),100);
          DelayCommand(4.0,FadeFromBlack(GetPCSpeaker(),FADE_SPEED_MEDIUM));
          DelayCommand(4.5,SetCutsceneMode(GetPCSpeaker(),FALSE));

            }
         else
            {
            ActionSpeakString("¡No tienes suficiente oro inepto! Vuelve a mi cuando tengas el oro que pido.");

            }

}

