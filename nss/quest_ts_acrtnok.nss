void main()
{
  object oPC = GetPCSpeaker();

  // Penalizacion, no se puede usar esta estatua los proximos 5 minutos
  SetLocalInt(OBJECT_SELF, "QUEST_ACERTIJOS_STOP", TRUE);
  DelayCommand(60.0, DeleteLocalInt(OBJECT_SELF, "QUEST_ACERTIJOS_STOP"));

  // Efecto maloso
  ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(813), oPC);

  // Danyo aleatorio
  int iDado6 = d6();
  if(iDado6 == 1)
  {
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBlindness(), oPC, 500.0);
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCurse(2,2,2,2,2,2), oPC, 500.0);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(GetCurrentHitPoints(oPC)/2, DAMAGE_TYPE_NEGATIVE, DAMAGE_POWER_PLUS_TWENTY), oPC);
  }
  else if(iDado6 == 2)
  {
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectNegativeLevel(2), oPC, 500.0);
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectPoison(POISON_GARGANTUAN_SPIDER_VENOM), oPC, 500.0);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(GetCurrentHitPoints(oPC)/3, DAMAGE_TYPE_NEGATIVE, DAMAGE_POWER_PLUS_TWENTY), oPC);
  }
  else if(iDado6 == 3)
  {
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAttackDecrease(6), oPC, 500.0);
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectACDecrease(6), oPC, 500.0);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(GetCurrentHitPoints(oPC)/2, DAMAGE_TYPE_NEGATIVE, DAMAGE_POWER_PLUS_TWENTY), oPC);
  }
  else if(iDado6 == 4)
  {
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectPetrify(), oPC, 200.0);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(GetCurrentHitPoints(oPC)/2, DAMAGE_TYPE_NEGATIVE, DAMAGE_POWER_PLUS_TWENTY), oPC);
  }
  else if(iDado6 == 5)
  {
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDazed(), oPC, 400.0);
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDeaf(), oPC, 300.0);
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectStunned(), oPC, 200.0);
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectFrightened(), oPC, 100.0);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(GetCurrentHitPoints(oPC)/4, DAMAGE_TYPE_NEGATIVE, DAMAGE_POWER_PLUS_TWENTY), oPC);
  }
  else if(iDado6 == 6)
  {
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectConfused(), oPC, 200.0);
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSlow(), oPC, 600.0);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(GetCurrentHitPoints(oPC)/2, DAMAGE_TYPE_NEGATIVE, DAMAGE_POWER_PLUS_TWENTY), oPC);
  }
}
