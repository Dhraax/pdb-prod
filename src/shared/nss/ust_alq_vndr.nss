void main()
{
  object oPC = GetPCSpeaker();
  int iContadorPlacas, iContadorAbdomen, iContadorGlandulas;

  // Contador de ingredientes
  object oIngredientes = GetFirstItemInInventory(oPC);
  while(GetIsObjectValid(oIngredientes) == TRUE)
  {
      if(GetTag(oIngredientes) == "ust_plaksfher") // Placas de fherlock
      {
          iContadorPlacas = iContadorPlacas + GetItemStackSize(oIngredientes);
          DestroyObject(oIngredientes);
      }
      if(GetTag(oIngredientes) == "NW_IT_MSMLMISC08") // Abdomen de escarabajo de fuego
      {
          iContadorAbdomen = iContadorAbdomen + 1;
          DestroyObject(oIngredientes);
      }
      if(GetTag(oIngredientes) == "glandulademiconi") // Glandulas de miconido
      {
          iContadorGlandulas = iContadorGlandulas + 1;
          DestroyObject(oIngredientes);
      }

      oIngredientes = GetNextItemInInventory(oPC);
  }

  int iOro = (iContadorPlacas * 10) + (iContadorAbdomen * 20) + (iContadorGlandulas * 30);

  if(iOro == 0) ActionSpeakString("¡No tienes ingredientes para mi! No me hagas perder el tiempo, ¡lárgate!");
  else
  {
      ActionSpeakString("Aquí tienes tu oro, un placer hacer tratos contigo.");
      GiveGoldToCreature(oPC, iOro);
  }
}
