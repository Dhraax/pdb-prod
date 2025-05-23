// Realizado por el vara <3

#include "mti_libreria"

void main()
{
  object oPC = GetPCSpeaker();
  int iOro = GetGold(oPC);
  string sTag = GetScriptParam("Destino");
  location lPunto = GetLocation(GetWaypointByTag(sTag));

  if(iOro >= 500)
  {
      TakeGoldFromCreature(500, GetPCSpeaker(), TRUE);
      Teletransporte2(oPC, lPunto);
  }

  else
  {
      ActionSpeakString("Lo siento pero no tiene oro suficiente, vuelva cuando tenga la cantidad que le pido, disculpe.");
  }
}