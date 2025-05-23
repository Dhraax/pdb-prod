#include "mti_libreria"
void main()
{
  object oPC = GetPCSpeaker();

  // Ifriti ya usado
  SetLocalInt(OBJECT_SELF, "IFRITIUSADO", 1);

  // Solo se pide un deseo una vez
  int iDeseoPreparacion = ObtenerIntPersistente(oPC, "DESEO_PREPARACION");
  if(iDeseoPreparacion == 1)
  {
      AssignCommand(OBJECT_SELF, SpeakString("¡Pero si ya te he concedido este deseo alguna vez, inepto!"));
      DelayCommand(2.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_MYSTICAL_EXPLOSION), GetLocation(OBJECT_SELF)));
      DestroyObject(OBJECT_SELF, 2.2);
      return;
  }

  GuardarIntPersistente(oPC, "DESEO_PREPARACION", 1);

  AssignCommand(OBJECT_SELF, SpeakString("La planificación es la clave de la preparación. No obstante, ¡ayuda mia tendrás!"));

  ActionCastFakeSpellAtObject(SPELL_CREATE_GREATER_UNDEAD, oPC, PROJECTILE_PATH_TYPE_DEFAULT);
  DelayCommand(2.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_PWSTUN), oPC));

  effect eEfectoVisual1 = EffectVisualEffect(VFX_DUR_ELEMENTAL_SHIELD);
  effect eEfectoVisual2 = EffectVisualEffect(VFX_DUR_GLOBE_INVULNERABILITY);
  effect eEfectoVisual3 = EffectVisualEffect(VFX_DUR_MAGIC_RESISTANCE);
  effect eEfectoVisual4 = EffectVisualEffect(VFX_DUR_PROT_PREMONITION);
  effect eEfectoVisual5 = EffectVisualEffect(VFX_DUR_PROTECTION_ELEMENTS);
  effect eEfectoVisual6 = EffectVisualEffect(VFX_DUR_SPELLTURNING);
  effect eEfectoVisual7 = EffectVisualEffect(VFX_DUR_PROT_GREATER_STONESKIN);
  effect eAptitud1 = EffectAbilityIncrease(ABILITY_CHARISMA, 10);
  effect eAptitud2 = EffectAbilityIncrease(ABILITY_CONSTITUTION, 10);
  effect eAptitud3 = EffectAbilityIncrease(ABILITY_DEXTERITY, 10);
  effect eAptitud4 = EffectAbilityIncrease(ABILITY_INTELLIGENCE, 10);
  effect eAptitud5 = EffectAbilityIncrease(ABILITY_STRENGTH, 10);
  effect eAptitud6 = EffectAbilityIncrease(ABILITY_WISDOM, 10);
  effect eAptitud7 = EffectAttackIncrease(5);
  effect eAptitud8 = EffectDamageIncrease(5);
  effect eAptitud9 = EffectDamageShield(10, DAMAGE_BONUS_1d10, DAMAGE_TYPE_COLD);
  effect eAptitud10 = EffectSpellResistanceIncrease(32);
  effect eAptitud11 = EffectDamageResistance(DAMAGE_TYPE_ACID, 15);
  effect eAptitud12 = EffectDamageResistance(DAMAGE_TYPE_BLUDGEONING, 15);
  effect eAptitud13 = EffectDamageResistance(DAMAGE_TYPE_COLD, 15);
  effect eAptitud14 = EffectDamageResistance(DAMAGE_TYPE_DIVINE, 15);
  effect eAptitud15 = EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, 15);
  effect eAptitud16 = EffectDamageResistance(DAMAGE_TYPE_FIRE, 15);
  effect eAptitud17 = EffectDamageResistance(DAMAGE_TYPE_NEGATIVE, 15);
  effect eAptitud18 = EffectDamageResistance(DAMAGE_TYPE_PIERCING, 15);
  effect eAptitud19 = EffectDamageResistance(DAMAGE_TYPE_POSITIVE, 15);
  effect eAptitud20 = EffectDamageResistance(DAMAGE_TYPE_SLASHING, 15);
  effect eAptitud21 = EffectDamageResistance(DAMAGE_TYPE_ACID, 15);
  effect eAptitud22 = EffectDamageResistance(DAMAGE_TYPE_SONIC, 15);
  effect eAptitud23 = EffectACIncrease(5, AC_DODGE_BONUS);

  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEfectoVisual1, oPC, 3600.0);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEfectoVisual2, oPC, 3600.0);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEfectoVisual3, oPC, 3600.0);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEfectoVisual4, oPC, 3600.0);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEfectoVisual5, oPC, 3600.0);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEfectoVisual6, oPC, 3600.0);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEfectoVisual7, oPC, 3600.0);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAptitud1, oPC, 3600.0);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAptitud2, oPC, 3600.0);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAptitud3, oPC, 3600.0);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAptitud4, oPC, 3600.0);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAptitud5, oPC, 3600.0);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAptitud6, oPC, 3600.0);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAptitud7, oPC, 3600.0);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAptitud8, oPC, 3600.0);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAptitud9, oPC, 3600.0);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAptitud10, oPC, 3600.0);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAptitud11, oPC, 3600.0);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAptitud12, oPC, 3600.0);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAptitud13, oPC, 3600.0);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAptitud14, oPC, 3600.0);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAptitud15, oPC, 3600.0);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAptitud16, oPC, 3600.0);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAptitud17, oPC, 3600.0);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAptitud18, oPC, 3600.0);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAptitud19, oPC, 3600.0);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAptitud20, oPC, 3600.0);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAptitud21, oPC, 3600.0);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAptitud22, oPC, 3600.0);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAptitud23, oPC, 3600.0);

  DelayCommand(4.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_MYSTICAL_EXPLOSION), GetLocation(OBJECT_SELF)));
  DestroyObject(OBJECT_SELF, 4.2);
}
