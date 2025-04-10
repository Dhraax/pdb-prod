void main()
{
  object oPC = GetEnteringObject();
  object oWP = GetNearestObjectByTag("shar_atrapado");
  effect e1 = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1);

  if(GetItemPossessedBy(oPC, "hijodeshar") == OBJECT_INVALID)
  {
      AssignCommand(oPC, ClearAllActions(TRUE));
      DelayCommand(0.1, AssignCommand(oPC, ActionJumpToObject(oWP)));
      ApplyEffectToObject(DURATION_TYPE_INSTANT, e1, oPC);
  }
}
