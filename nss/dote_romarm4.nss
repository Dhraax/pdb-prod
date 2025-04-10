#include "x2_inc_itemprop"
#include "mti_libreria"

void main()
{
  object oPC = GetPCSpeaker();
  object oArma = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);

  if(GetIsObjectValid(oArma) == FALSE ||
     GetLocalInt(oArma, "DOTE_ROMPERARMA_DESTROZADO") == FALSE)
  {
      AssignCommand(OBJECT_SELF, ActionSpeakString("O no tienes un arma equipada en la mano derecha, o bien el arma equipada no está rota. ¡Así no puedes arreglarla!"));
      return;
  }

  if(GetGold(oPC) < 100)
  {
      AssignCommand(OBJECT_SELF, ActionSpeakString("¡No tienes las 100 monedas de oro que necesitas!"));
      return;
  }

  int iNivelHerreria = 20;
  int iValorOroArma = GetGoldPieceValue(oArma);
  if(iValorOroArma < 4500) iNivelHerreria = 20;
  else if(iValorOroArma < 17000) iNivelHerreria = 40;
  else if(iValorOroArma < 49000) iNivelHerreria = 60;
  else if(iValorOroArma < 120000) iNivelHerreria = 80;
  else iNivelHerreria = 100;

  if(ObtenerIntPersistente(oPC, "NIVELHERRERIA") < iNivelHerreria)
  {
      AssignCommand(OBJECT_SELF, ActionSpeakString("¡Tienes muy poca experiencia en herrería! Así dificilmente podrás arreglar esa arma."));
      return;
  }

  // Animaciones
  DeleteLocalInt(oArma, "DOTE_ROMPERARMA_DESTROZADO");
  DeleteLocalInt(oArma, "DOTE_ROMPERARMA_GOLPES");
  IPRemoveMatchingItemProperties(oArma, ITEM_PROPERTY_DECREASED_ENHANCEMENT_MODIFIER, DURATION_TYPE_PERMANENT);
  IPRemoveMatchingItemProperties(oArma, ITEM_PROPERTY_QUALITY, DURATION_TYPE_PERMANENT);

  int iCalidadGuardada = GetLocalInt(oArma, "CALIDAD_GUARDADA");
  if(iCalidadGuardada != 0) IPSafeAddItemProperty(oArma, ItemPropertyQuality(iCalidadGuardada));

  AssignCommand(oPC, TakeGoldFromCreature(100, oPC, TRUE));
  SetCutsceneMode(oPC, TRUE);
  FadeToBlack(oPC, FADE_SPEED_MEDIUM);
  AssignCommand(oPC, PlaySound("as_cv_shopmetal1"));
  AssignCommand(oPC, PlaySound("as_cv_minepick1"));
  DelayCommand(2.0, AssignCommand(oPC, PlaySound("as_cv_shopmetal1")));
  DelayCommand(2.0, AssignCommand(oPC, PlaySound("as_cv_minepick2")));
  DelayCommand(4.0, FadeFromBlack(oPC, FADE_SPEED_MEDIUM));
  DelayCommand(4.5, SetCutsceneMode(oPC, FALSE));
  DelayCommand(5.0, AssignCommand(OBJECT_SELF, ActionSpeakString("¡Lo conseguiste! Jajaja, un trabajo espléndido.")));
}
