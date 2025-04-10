//::///////////////////////////////////////////////
//:: CUERPO FERREO
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Cuerpo ferreo.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 8 de Noviembre de 2011
//:://////////////////////////////////////////////

#include "nw_i0_spells"
#include "x2_inc_spellhook"
#include "nostack_inc"
#include "pb_nivellanzador"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);
  /*
    Spellcast Hook Code
    Added 2003-07-07 by Georg Zoeller
    If you want to make changes to all spells,
    check x2_inc_spellhook.nss to find out more
  */

  if (!X2PreSpellCastCode())
  {
      // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
      return;
  }

  object oCaster = OBJECT_SELF;
  int nCasterLevel = GetTotalCasterLevel(oCaster);
  float fDuration = 60.0f * nCasterLevel;

  // Se disipan los siguientes conjuros por incompatibilidades... medida extrema antiabuso
  RemoveEffectsFromSpell(OBJECT_SELF, 996); // Cuerpo ferreo
  RemoveEffectsFromSpell(OBJECT_SELF, 62);  // Libertad
  RemoveEffectsFromSpell(OBJECT_SELF, 1022);// Libertad de asesino
  RemoveEffectsFromSpell(OBJECT_SELF, 1093);// Libertad de guardia negro
  RemoveEffectsFromSpell(OBJECT_SELF, 1124);// Libertad de agente arpista
  RemoveEffectsFromSpell(OBJECT_SELF, 125); // Proteccion contra energia negativa
  RemoveEffectsFromSpell(OBJECT_SELF, 444); // Undeaths_Eternal_Foe

  // Metamagias
  if((GetSpellCastItem()==OBJECT_INVALID?GetMetaMagicFeat():METAMAGIC_NONE) == METAMAGIC_EXTEND)
  {
      fDuration = fDuration * 2; //Duration is +100%
  }

    effect eLink    =                          EffectDamageReduction(15, DAMAGE_POWER_PLUS_FIVE);
           eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_BLINDNESS));
           eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT));
           eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_ABILITY_DECREASE));
           eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_DEAFNESS));
           eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_DISEASE));
           eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_POISON));
           eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_STUN));
           eLink    = EffectLinkEffects(eLink, EffectSpellImmunity(SPELL_DROWN));
           eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_ELECTRICAL, 100));
           eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_ACID, 50));
           eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE, 50));
           eLink    = EffectLinkEffects(eLink, EffectVisualEffect(927));
           eLink    = EffectLinkEffects(eLink, EffectSpellFailure(50, SPELL_SCHOOL_GENERAL));
           eLink    = EffectLinkEffects(eLink, EffectMovementSpeedDecrease(50));
           eLink    = EffectLinkEffects(eLink, EffectACDecrease(8));
    effect eDes     = EffectAbilityDecrease(ABILITY_DEXTERITY, 6);

  DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDes, oCaster, fDuration));
  DelayCommand(1.5, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, fDuration));
  DoNoStackAbilityBonus(OBJECT_SELF, OBJECT_SELF, 6, ABILITY_STRENGTH, fDuration);

  ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DEATH_WARD), oCaster);
  ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_CHARM), oCaster);

  SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
  DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
