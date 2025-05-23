void main()
{
  object oPC = GetLastUsedBy();
  object oTarget = GetWaypointByTag("Esmeraltan_agujas");
  object oItem = GetItemPossessedBy(oPC, "Mon_sag_Waukeen");

  effect eSummon1 = EffectVisualEffect(VFX_IMP_GOOD_HELP);
  effect eSummon2 = EffectVisualEffect(VFX_FNF_SOUND_BURST);
  effect eSummon3 = EffectVisualEffect(VFX_IMP_UNSUMMON);

  if(GetItemPossessedBy(oPC, "Mon_sag_Waukeen") != OBJECT_INVALID)
  {
      ApplyEffectToObject(DURATION_TYPE_INSTANT, eSummon1, oPC);
      DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eSummon1, oPC));
      DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eSummon2, oPC));
      DelayCommand(3.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eSummon3, oPC));
      DelayCommand(3.9, AssignCommand(oPC, ClearAllActions()));
      DelayCommand(4.0, AssignCommand(oPC, ActionJumpToObject(oTarget)));
      DelayCommand(7.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eSummon2, oPC));
      DelayCommand(9.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eSummon3, oPC));
      if(GetIsObjectValid(oItem)) DestroyObject(oItem);
  }
  else
  {
      FloatingTextStringOnCreature("No puedes utilizar el portal si no tienes la Moneda Sagrada de Waukin", oPC);
  }
}
