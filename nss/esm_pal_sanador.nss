void main()
{
  object oPC = GetPCSpeaker();

  int iVariable = GetLocalInt(oPC, "ESM_PAL_SANADOR");
  if(iVariable == 1)
  {
      AssignCommand(OBJECT_SELF, SpeakString("Lo siento... pero las vendas con las que te curé la última vez eran las últimas."));
      return;
  }

  AssignCommand(OBJECT_SELF, SpeakString("¡Y ten mucho cuidado si bajas allá abajo!"));

  effect eEfecto1 = EffectHeal(GetMaxHitPoints(oPC));
  effect eEfecto2 = EffectVisualEffect(VFX_IMP_HEALING_S);
  ApplyEffectToObject(DURATION_TYPE_INSTANT, eEfecto1, oPC);
  ApplyEffectToObject(DURATION_TYPE_INSTANT, eEfecto2, oPC);

  DelayCommand(1.0, FloatingTextStringOnCreature("*¡Tus heridas se sanan por completo!*", oPC));

  SetLocalInt(oPC, "ESM_PAL_SANADOR", 1);
  DelayCommand(3600.0, DeleteLocalInt(oPC, "ESM_PAL_SANADOR"));
}
