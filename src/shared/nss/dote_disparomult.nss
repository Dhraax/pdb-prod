//::///////////////////////////////////////////////
//:: DOTE DISPARO MULTIPLE (normal y mejorado)
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Disparo Multiple (normal y mejorado).
*/
//:://////////////////////////////////////////////
//:: Created By: Jose-G-C
//:: Created On: 15 de Octubre de 2011
//:://////////////////////////////////////////////

#include "x0_i0_spells"
#include "mti_libreria"

void main()
{
  object oPC = OBJECT_SELF;

  // Desactivacion del modo
  if(GetHasSpellEffect(980) || GetHasSpellEffect(981))
  {
      FloatingTextStringOnCreature("<cþ<<>* Modo Disparos múltiples desactivado *</c>", OBJECT_SELF, FALSE);
      RemoveEffectsFromSpell(oPC, 980);
      RemoveEffectsFromSpell(oPC, 981);
      return;
  }

  // No se puede usar con armas cuerpo a cuerpo
  if(GetWeaponRanged(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) == FALSE)
  {
      FloatingTextStringOnCreature("<cþ<<>* ¡No puedes activarlo con ese arma! *</c>", OBJECT_SELF, FALSE);
      return;
  }

  // Variables
  int iVelocidadAtaque = 1;
  int iPenalizadorAtaque = 4;
  int iDanyo = DAMAGE_BONUS_1d8;
  int iNivelExplorador = 6;

  if(GetHasFeat(1329))
  {
      iVelocidadAtaque = 1;
      iPenalizadorAtaque = 2;
      iDanyo = DAMAGE_BONUS_1d12;
      iNivelExplorador = 11;
  }

  // Explorador: no llevar armadura intermedia o pesada
  if(GetLevelByClass(CLASS_TYPE_RANGER) >= iNivelExplorador)
  {
      object oArmadura = GetItemInSlot(INVENTORY_SLOT_CHEST);
      if(GetIsObjectValid(oArmadura) == TRUE)
      {
          if(GetArmorType(oArmadura) > 3)
          {
              FloatingTextStringOnCreature("<cþ<<>* El Modo Disparos múltiples siendo explotador no se puede activar con armaduras intermedias o pesadas *</c>", OBJECT_SELF, FALSE);
              return;
          }
      }
  }

  // Aplicacion de efectos
  effect eVelocidadAtaque = EffectModifyAttacks(iVelocidadAtaque);
  effect ePenalizadorAtaque = EffectAttackDecrease(iPenalizadorAtaque);
  effect eDanyo = EffectDamageIncrease(iDanyo, DAMAGE_TYPE_PIERCING);
  effect eLink = EffectLinkEffects(eVelocidadAtaque, ePenalizadorAtaque);
  eLink = EffectLinkEffects(eLink, eDanyo);
  eLink = ExtraordinaryEffect(eLink);

  FloatingTextStringOnCreature("<c´þd>* Modo Disparos múltiples activado *</c>", oPC, FALSE);
  ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
}
