// CRISTAL ANTIMAGIA

void CristalAntimagia(object oPC)
{
  effect eBad = GetFirstEffect(oPC);
  while(GetIsEffectValid(eBad))
  {
      if((GetEffectType(eBad) == EFFECT_TYPE_ABILITY_INCREASE ||
          GetEffectType(eBad) == EFFECT_TYPE_AC_INCREASE ||
          GetEffectType(eBad) == EFFECT_TYPE_ATTACK_INCREASE ||
          GetEffectType(eBad) == EFFECT_TYPE_CONCEALMENT ||
          GetEffectType(eBad) == EFFECT_TYPE_DAMAGE_IMMUNITY_INCREASE ||
          GetEffectType(eBad) == EFFECT_TYPE_DAMAGE_INCREASE ||
          GetEffectType(eBad) == EFFECT_TYPE_DAMAGE_REDUCTION ||
          GetEffectType(eBad) == EFFECT_TYPE_DAMAGE_RESISTANCE ||
          GetEffectType(eBad) == EFFECT_TYPE_ELEMENTALSHIELD ||
          GetEffectType(eBad) == EFFECT_TYPE_ETHEREAL ||
          GetEffectType(eBad) == EFFECT_TYPE_HASTE ||
          GetEffectType(eBad) == EFFECT_TYPE_IMMUNITY ||
          GetEffectType(eBad) == EFFECT_TYPE_IMPROVEDINVISIBILITY ||
          GetEffectType(eBad) == EFFECT_TYPE_INVISIBILITY ||
          GetEffectType(eBad) == EFFECT_TYPE_INVULNERABLE ||
          GetEffectType(eBad) == EFFECT_TYPE_MOVEMENT_SPEED_INCREASE ||
          GetEffectType(eBad) == EFFECT_TYPE_POLYMORPH ||
          GetEffectType(eBad) == EFFECT_TYPE_REGENERATE ||
          GetEffectType(eBad) == EFFECT_TYPE_SANCTUARY ||
          GetEffectType(eBad) == EFFECT_TYPE_SAVING_THROW_INCREASE ||
          GetEffectType(eBad) == EFFECT_TYPE_SEEINVISIBLE ||
          GetEffectType(eBad) == EFFECT_TYPE_SKILL_INCREASE ||
          GetEffectType(eBad) == EFFECT_TYPE_SPELL_IMMUNITY ||
          GetEffectType(eBad) == EFFECT_TYPE_SPELL_RESISTANCE_INCREASE ||
          GetEffectType(eBad) == EFFECT_TYPE_SPELLLEVELABSORPTION ||
          GetEffectType(eBad) == EFFECT_TYPE_TEMPORARY_HITPOINTS ||
          GetEffectType(eBad) == EFFECT_TYPE_TRUESEEING ||
          GetEffectType(eBad) == EFFECT_TYPE_TURN_RESISTANCE_INCREASE ||
          GetEffectType(eBad) == EFFECT_TYPE_ULTRAVISION ||
          GetEffectType(eBad) == EFFECT_TYPE_VISUALEFFECT) &&
         (GetEffectSubType(eBad) != SUBTYPE_SUPERNATURAL))

      {
          RemoveEffect(oPC, eBad);
      }

      // Parche para que elimine los efectos malignos de cuerpo ferreo
      else if(GetEffectSpellId(eBad) == 996)
      {
          RemoveEffect(oPC, eBad);
      }

      eBad = GetNextEffect(oPC);
  }

  ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_BREACH), oPC);
  DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_PWSTUN), oPC));
}

void main()
{
  object oPC = GetEnteringObject();

  CristalAntimagia(oPC);

  FloatingTextStringOnCreature("<cþ<<>* La magia de tu cuerpo se ha disipado *</c>", oPC, FALSE);
}
