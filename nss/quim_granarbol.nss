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
  object oPC = GetEnteringObject();
  int iVariable = GetLocalInt(oPC, "LITHARBOL");

  if(GetIsPC(oPC) == FALSE) return;
  if(iVariable == 1) return;

  CurarCualquierEfectoNegativos(oPC);

  effect eEfecto1 = EffectConcealment(25);
  effect eEfecto2 = EffectSavingThrowIncrease(SAVING_THROW_ALL,1);
  effect eEfecto3 = EffectHeal(GetMaxHitPoints(oPC));
  effect eEfecto4 = EffectVisualEffect(VFX_FNF_NATURES_BALANCE);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEfecto1, oPC, 500.0);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEfecto2, oPC, 500.0);
  ApplyEffectToObject(DURATION_TYPE_INSTANT, eEfecto3, oPC);
  DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eEfecto4, oPC));

  DelayCommand(1.0, FloatingTextStringOnCreature("<cßþ>La majestuosa presencia del Gran Árbol y sus energias mágicas ancestrales sanan tus heridas físicas y espirituales.</c>", oPC));

  SetLocalInt(oPC, "LITHARBOL", 1);
  DelayCommand(500.0, DeleteLocalInt(oPC, "LITHARBOL"));
}
