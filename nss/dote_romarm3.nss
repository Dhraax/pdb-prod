#include "x2_inc_itemprop"

void main()
{
  object oPC = GetPCSpeaker();
  object oArma = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);

  if(GetIsObjectValid(oArma) == FALSE ||
     GetLocalInt(oArma, "DOTE_ROMPERARMA_DESTROZADO") == FALSE)
  {
      AssignCommand(OBJECT_SELF, ActionSpeakString("O no tienes un arma equipada en la mano derecha, o bien el arma equipada no está rota. ¡No me hagas perder el tiempo!"));
      return;
  }

  int iOro = 1000;
  int iValorOroArma = GetGoldPieceValue(oArma);
  if(iValorOroArma < 4500) iOro = 1000;
  else if(iValorOroArma < 17000) iOro = 2000;
  else if(iValorOroArma < 49000) iOro = 3000;
  else if(iValorOroArma < 120000) iOro = 4000;
  else iOro = 5000;

  if(GetGold(oPC) < iOro)
  {
      AssignCommand(OBJECT_SELF, ActionSpeakString("¡No tienes las "+IntToString(iOro)+" monedas de oro que pido! No me hagas perder el tiempo."));
      return;
  }

  // Animaciones
  DeleteLocalInt(oArma, "DOTE_ROMPERARMA_DESTROZADO");
  DeleteLocalInt(oArma, "DOTE_ROMPERARMA_GOLPES");
  IPRemoveMatchingItemProperties(oArma, ITEM_PROPERTY_DECREASED_ENHANCEMENT_MODIFIER, DURATION_TYPE_PERMANENT);
  IPRemoveMatchingItemProperties(oArma, ITEM_PROPERTY_QUALITY, DURATION_TYPE_PERMANENT);

  int iCalidadGuardada = GetLocalInt(oArma, "CALIDAD_GUARDADA");
  if(iCalidadGuardada != 0) IPSafeAddItemProperty(oArma, ItemPropertyQuality(iCalidadGuardada));

  AssignCommand(oPC, TakeGoldFromCreature(iOro, oPC, TRUE));
  SetCutsceneMode(oPC, TRUE);
  FadeToBlack(oPC, FADE_SPEED_MEDIUM);
  AssignCommand(oPC, PlaySound("as_cv_shopmetal1"));
  AssignCommand(oPC, PlaySound("as_cv_minepick1"));
  DelayCommand(2.0, AssignCommand(oPC, PlaySound("as_cv_shopmetal1")));
  DelayCommand(2.0, AssignCommand(oPC, PlaySound("as_cv_minepick2")));
  DelayCommand(4.0, FadeFromBlack(oPC, FADE_SPEED_MEDIUM));
  DelayCommand(4.5, SetCutsceneMode(oPC, FALSE));
  DelayCommand(5.0, AssignCommand(OBJECT_SELF, ActionSpeakString("¡Aquí tienes tu arma mejor que nunca! Jajaja")));
}
