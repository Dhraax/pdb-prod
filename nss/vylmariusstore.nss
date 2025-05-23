#include "nw_i0_plot"
void main()
{
  object oPC = GetPCSpeaker();

  if(GetHitDice(oPC) < 5)
  {
      ActionSpeakString("¡No verás mis mercancías todavía! ¡Sal a conocer experiencias del mundo donde vives! Vuelve a mi cuando tengas una visión más global.");
      return;
  }

  object oStore = GetNearestObjectByTag("Vylmarius");
  if (GetObjectType(oStore) == OBJECT_TYPE_STORE)
  {
      gplotAppraiseOpenStore(oStore, GetPCSpeaker());
  }
  else
  {
      ActionSpeakStringByStrRef(53090, TALKVOLUME_TALK);
  }
}
