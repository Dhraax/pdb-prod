void main()
{
  object oPC = GetEnteringObject();
  if(GetIsPC(oPC) == FALSE) return;

  effect eImmovilizar = EffectCutsceneImmobilize();
  int iDestreza = GetAbilityModifier(ABILITY_DEXTERITY, oPC);
  int iDado100 = d100();
  int iTirada = iDado100 + (iDestreza*6);

  if(iTirada <= 30)
  {
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eImmovilizar, oPC, 4.9);
      DelayCommand(0.5, AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_DEAD_BACK, 1.0, 5.0)));
      effect eDanyo = EffectDamage(d8(), DAMAGE_TYPE_BLUDGEONING);
      DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDanyo, oPC));
      DelayCommand(0.5, FloatingTextStringOnCreature("* ¡Te has resbalado y caes al suelo! *", oPC, FALSE));
      DelayCommand(0.5, PlayVoiceChat(Random(3)+14, oPC));
  }

  effect eLento = EffectMovementSpeedDecrease(35);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLento, oPC, 3.0);
}
