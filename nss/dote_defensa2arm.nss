//::///////////////////////////////////////////////
//:: DOTE DEFENSA CON DOS ARMAS
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Defensa con dos armas.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 19 de Octubre de 2011
//:://////////////////////////////////////////////

#include "x0_i0_spells"
#include "zep_inc_armas"

void main()
{
   object oPC = OBJECT_SELF;

  // Desactivacion del modo
  if(GetHasSpellEffect(983))
  {
      if(GetLocalInt(oPC, "SPAM_DEF2AR"))
      {
          FloatingTextStringOnCreature("<cþ<<>* No puedes cancelar tan rápidamente el Modo Defensa con dos armas *</c>", OBJECT_SELF, FALSE);
          return;
      }

      FloatingTextStringOnCreature("<cþ<<>* Modo Defensa con dos armas desactivado *</c>", oPC, FALSE);
      RemoveEffectsFromSpell(oPC, 983);
      SetLocalInt(oPC, "SPAM_DEF2AR", TRUE);
      DelayCommand(6.0, DeleteLocalInt(oPC, "SPAM_DEF2AR"));
      return;
  }

  // Con efectos dayninos no puedes usarla
  int iFalloDote = FALSE;
  if(GetIsResting(oPC) || GetLocalInt(oPC, "DERRIBADO") || GetLocalInt(oPC, "SLIDING")) iFalloDote = TRUE;

  effect eEfecto = GetFirstEffect(oPC);
  while(GetIsEffectValid(eEfecto))
  {
      if(GetEffectType(eEfecto) == EFFECT_TYPE_CHARMED ||           GetEffectType(eEfecto) == EFFECT_TYPE_CONFUSED ||
         GetEffectType(eEfecto) == EFFECT_TYPE_CUTSCENE_PARALYZE || GetEffectType(eEfecto) == EFFECT_TYPE_CUTSCENEIMMOBILIZE ||
         GetEffectType(eEfecto) == EFFECT_TYPE_DAZED ||             GetEffectType(eEfecto) == EFFECT_TYPE_DOMINATED ||
         GetEffectType(eEfecto) == EFFECT_TYPE_ENTANGLE ||          GetEffectType(eEfecto) == EFFECT_TYPE_FRIGHTENED ||
         GetEffectType(eEfecto) == EFFECT_TYPE_PARALYZE ||          GetEffectType(eEfecto) == EFFECT_TYPE_PETRIFY ||
         GetEffectType(eEfecto) == EFFECT_TYPE_SLEEP ||             GetEffectType(eEfecto) == EFFECT_TYPE_STUNNED) iFalloDote = TRUE;

      eEfecto = GetNextEffect(oPC);
  }

  if(iFalloDote == TRUE)
  {
      FloatingTextStringOnCreature("<cþ<<>* En tu estado no puedes activar el Modo Defensa con Dos Armas *</c>", OBJECT_SELF, FALSE);
      return;
  }

    //Revisa primero si se lleva un arma doble de las siguientes:
    int nArma = GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC));
    if(nArma != BASE_ITEM_TWOBLADEDSWORD &&     //Espada de doble hoja
    nArma != BASE_ITEM_DIREMACE &&              //Maza doble
    nArma != BASE_ITEM_DOUBLEAXE &&             //Hacha doble
    nArma != 321 &&                             //Cimitarra doble
    nArma != BASE_ITEM_QUARTERSTAFF             //Bastón
    ){
        // Si no se lleva un arma doble revisa que lleve un arma en la mano torpe.
        if(VerSiEsArmaCuerpoACuerpo(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC)) == FALSE)
        {
            FloatingTextStringOnCreature("<cþ<<>* No llevas dos armas *</c>", OBJECT_SELF, FALSE);
            return;
        }
    }

  // AntiSPAM
  if(GetLocalInt(oPC, "SPAM_DEF2AR"))
  {
      FloatingTextStringOnCreature("<cþ<<>* No puedes reactivar tan rápidamente el Modo Defensa con Dos Armas *</c>", OBJECT_SELF, FALSE);
      return;
  }

  // Combatir a la defensiva, defensa total o pericia aumenta en +1 la CA
  int iCA = 1;
  //Defensa con dos armas mejorada y mayor
  if(GetHasFeat(1439, oPC)) iCA = 2;
  if(GetHasFeat(1441, oPC)) iCA = 3;
  if(GetHasSpellEffect(883) || GetHasSpellEffect(884) ||
     GetHasSpellEffect(901) || GetHasSpellEffect(904)) iCA = iCA *2;

  // Aplicacion de efectos
  effect eCA = EffectACIncrease(iCA, AC_DODGE_BONUS);
  eCA = ExtraordinaryEffect(eCA);
  ApplyEffectToObject(DURATION_TYPE_PERMANENT, eCA, oPC);
  FloatingTextStringOnCreature("<c´þd>* Modo Defensa con dos armas activado *</c>", OBJECT_SELF, FALSE);

  SetLocalInt(oPC, "SPAM_DEF2AR", TRUE);
  DelayCommand(6.0, DeleteLocalInt(oPC, "SPAM_DEF2AR"));
}

