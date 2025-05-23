//::///////////////////////////////////////////////
//:: DOTE CARRERA
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Carrera.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 19 de Octubre de 2011
//:://////////////////////////////////////////////

#include "x0_i0_spells"
#include "mti_libreria"
#include "pb_tiradas_inc"

void main()
{
   object oPC = OBJECT_SELF;

  // Desactivacion del modo
  if(GetHasSpellEffect(984))
  {
      FloatingTextStringOnCreature("<cþ<<>* Modo Carrera desactivado *</c>", oPC, FALSE);
      RemoveEffectsFromSpell(oPC, 984);
      return;
  }

  // No polimorfado
  if(GetHasEffect(EFFECT_TYPE_POLYMORPH))
  {
      FloatingTextStringOnCreature("<cþ<<>* El Modo Carrera no se puede activar polimorfado *</c>", OBJECT_SELF, FALSE);
      return;
  }

  // No funciona montado en montura
  if(ObtenerIntPersistente(OBJECT_SELF, "CAB_MONTADO") > 0)
  {
      FloatingTextStringOnCreature("<cþ<<>* El Modo Carrera no se puede activar montado en montura *</c>", OBJECT_SELF, FALSE);
      return;
  }

  // Ninguna armadura o armaduras ligeras
  object oArmadura = GetItemInSlot(INVENTORY_SLOT_CHEST);
  if(GetIsObjectValid(oArmadura) == TRUE)
  {
      if(GetArmorType(oArmadura) > 3)
      {
          FloatingTextStringOnCreature("<cþ<<>* El Modo Carrera no se puede activar con armaduras intermedias o pesadas *</c>", OBJECT_SELF, FALSE);
          return;
      }
  }

  // No tenemos que ir ralentizados por el peso
  // Debug: SendMessageToPC(oPC, "Fuerza: "+IntToString(iFuerza)+"; Carga Maxima: "+IntToString(iCargaMaxima)+"; Peso: "+IntToString(iPeso)+".");
  if(CargaMaxima(oPC) == TRUE)
  {
     FloatingTextStringOnCreature("<cþ<<>* El Modo Carrera no se puede activar con tanto peso *</c>", OBJECT_SELF, FALSE);
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
      FloatingTextStringOnCreature("<cþ<<>* En tu estado no puedes activar el Modo Carrera *</c>", OBJECT_SELF, FALSE);
      return;
  }

  // Aplicacion de efectos
  effect eVelocidad = EffectMovementSpeedIncrease(15);
  eVelocidad = ExtraordinaryEffect(eVelocidad);
  ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVelocidad, oPC);
  FloatingTextStringOnCreature("<c´þd>* Modo Carrera activado *</c>", OBJECT_SELF, FALSE);
}
