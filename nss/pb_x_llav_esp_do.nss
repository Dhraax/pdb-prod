void CurarCualquierEfectoNegativos(object oObjetivo)
{
  effect eBad = GetFirstEffect(oObjetivo);
  while(GetIsEffectValid(eBad))
  {
     if((GetEffectType(eBad) == EFFECT_TYPE_ABILITY_DECREASE ||
         GetEffectType(eBad) == EFFECT_TYPE_AC_DECREASE ||
         GetEffectType(eBad) == EFFECT_TYPE_ATTACK_DECREASE ||
         GetEffectType(eBad) == EFFECT_TYPE_DAMAGE_DECREASE ||
         GetEffectType(eBad) == EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE ||
         GetEffectType(eBad) == EFFECT_TYPE_SAVING_THROW_DECREASE ||
         GetEffectType(eBad) == EFFECT_TYPE_SPELL_RESISTANCE_DECREASE ||
         GetEffectType(eBad) == EFFECT_TYPE_SKILL_DECREASE ||
         GetEffectType(eBad) == EFFECT_TYPE_BLINDNESS ||
         GetEffectType(eBad) == EFFECT_TYPE_DEAF ||
         GetEffectType(eBad) == EFFECT_TYPE_CURSE ||
         GetEffectType(eBad) == EFFECT_TYPE_DISEASE ||
         GetEffectType(eBad) == EFFECT_TYPE_POISON ||
         GetEffectType(eBad) == EFFECT_TYPE_MOVEMENT_SPEED_DECREASE ||
         GetEffectType(eBad) == EFFECT_TYPE_PARALYZE ||
         GetEffectType(eBad) == EFFECT_TYPE_CHARMED ||
         GetEffectType(eBad) == EFFECT_TYPE_SILENCE ||
         GetEffectType(eBad) == EFFECT_TYPE_DOMINATED ||
         GetEffectType(eBad) == EFFECT_TYPE_DAZED ||
         GetEffectType(eBad) == EFFECT_TYPE_CONFUSED ||
         GetEffectType(eBad) == EFFECT_TYPE_FRIGHTENED ||
         GetEffectType(eBad) == EFFECT_TYPE_NEGATIVELEVEL ||
         GetEffectType(eBad) == EFFECT_TYPE_PARALYZE ||
         GetEffectType(eBad) == EFFECT_TYPE_SLOW ||
         GetEffectType(eBad) == EFFECT_TYPE_STUNNED) &&
         GetEffectSpellId(eBad) != 996 &&
         GetEffectSubType(eBad) == SUBTYPE_MAGICAL)
     {
         RemoveEffect(oObjetivo, eBad);
     }

     eBad = GetNextEffect(oObjetivo);
  }
}

void main()
{
  object oPC = GetPCSpeaker();
  string sSubraza = GetStringLowerCase(GetSubRace(oPC));
  effect eCurar = EffectHeal(GetMaxHitPoints(oPC));

  ApplyEffectToObject(DURATION_TYPE_INSTANT, eCurar, oPC);
  CurarCualquierEfectoNegativos(oPC);

  if(sSubraza == "vampiro" || sSubraza == "ghul" || sSubraza == "deathknight" || sSubraza == "necropolita" || sSubraza == "liche") ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HARM), oPC);
  else ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_X), oPC);
}
