void main()
{
  object oPC = GetLastAttacker();
  effect eEfecto1 = EffectFrightened();
  effect eEfecto2 = EffectVisualEffect(VFX_DUR_PROTECTION_EVIL_MAJOR);
  effect eEfecto3 = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);
  effect eEfecto4 = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_EVIL);

  if(!GetIsPC(oPC)) return;

  ApplyEffectToObject(DURATION_TYPE_INSTANT, eEfecto2, oPC);
  DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEfecto1, oPC, 30.0f));
  DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eEfecto4, oPC));
  DelayCommand(2.0, FloatingTextStringOnCreature("* El lugar parece maldito *", oPC));

  if(!GetIsImmune(oPC, IMMUNITY_TYPE_FEAR))
  {
      DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEfecto3, oPC, 30.0f));
  }
}
