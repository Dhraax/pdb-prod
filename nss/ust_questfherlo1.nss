#include "mti_libreria"

void main()
{
  object oPC = GetPCSpeaker();

  // Contador placas de fherlock
  int iContadorPlacas;
  object oPlacas = GetFirstItemInInventory(oPC);
  while(GetIsObjectValid(oPlacas) == TRUE && iContadorPlacas < 20)
  {
      if(GetTag(oPlacas) == "ust_plaksfher") iContadorPlacas = iContadorPlacas + GetItemStackSize(oPlacas);

      oPlacas = GetNextItemInInventory(oPC);
  }

  // Si no tenemos 20 placas, nanay
  if(iContadorPlacas < 20)
  {
      ActionSpeakString("¡No tienes las 20 placas de fherlock! No me hagas perder el tiempo, ¡lárgate!");
      return;
  }

  // Tenemos las 20 placas, las eliminamos
  int iContadorPlacas2, iStackActual;
  object oPlacas2 = GetFirstItemInInventory(oPC);
  while(GetIsObjectValid(oPlacas2) == TRUE && iContadorPlacas2 < 20)
  {
      if(GetTag(oPlacas2) == "ust_plaksfher")
      {
          iStackActual = iContadorPlacas2 + GetItemStackSize(oPlacas2);

          if(iStackActual <= 20) DestroyObject(oPlacas2);
          else
          {
              SetItemStackSize(oPlacas2, GetItemStackSize(oPlacas2) - (20 - iContadorPlacas2));
          }

          iContadorPlacas2 = iContadorPlacas2 + GetItemStackSize(oPlacas2);
      }

      oPlacas2 = GetNextItemInInventory(oPC);
  }

  // Damos recompensa
  ActionSpeakString("¡Fantástico! Aquí tienes unas pocas monedas de oro y una mochila mágica, espero que sea suficiente pago.");
  GiveXPToCreature(oPC, 1500);
  GiveGoldToCreature(oPC, 2000);
  CreateItemOnObject("nw_it_contain002", oPC);
  GuardarIntPersistente(oPC, "QUESTFHERLOCK", TRUE);
}
