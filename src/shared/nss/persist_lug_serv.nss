void main()
{
  object oPC = GetEnteringObject();

  // TORRE DE AMNAGUA
  if(GetLocalInt(oPC, "NIVELTORRE") > 0)
  {
      location lFueraTorreAmnag = GetLocation(GetWaypointByTag("mago_amn_sala_7"));
      DeleteLocalInt(oPC, "NIVELTORRE");
      SetCutsceneMode(oPC, TRUE);
      DelayCommand(7.1, SetCutsceneMode(oPC, FALSE));
      DelayCommand(7.0, AssignCommand(oPC, ActionJumpToLocation(lFueraTorreAmnag)));
      DelayCommand(6.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_PWSTUN), GetLocation(oPC)));
      DelayCommand(7.2, FloatingTextStringOnCreature("Por motivos de persistencia, al reentrar abandonastes la torre", oPC));
      return;
   }

  // DROWS, PLANO SORCERE
  if(GetLocalInt(oPC, "ESTOYENTHORMALLEM") == 1)
  {
      location lFueraThormallem = GetLocation(GetWaypointByTag("salida_dorwmago"));
      DeleteLocalInt(oPC, "ESTOYENTHORMALLEM");
      SetCutsceneMode(oPC, TRUE);
      DelayCommand(7.1, SetCutsceneMode(oPC, FALSE));
      DelayCommand(7.0, AssignCommand(oPC, ActionJumpToLocation(lFueraThormallem)));
      DelayCommand(6.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_PWSTUN), GetLocation(oPC)));
      DelayCommand(7.2, FloatingTextStringOnCreature("Por motivos de persistencia, al reentrar abandonastes el plano", oPC));
      return;
  }

  // DROWS, PLANO ARACH TINLILITH
  if(GetLocalInt(oPC, "ESTOYENTHORMALLEM2") == 1)
  {
      location lFueraThormallem2 = GetLocation(GetWaypointByTag("salida_drowcleric"));
      DeleteLocalInt(oPC, "ESTOYENTHORMALLEM2");
      SetCutsceneMode(oPC, TRUE);
      DelayCommand(7.1, SetCutsceneMode(oPC, FALSE));
      DelayCommand(7.0, AssignCommand(oPC, ActionJumpToLocation(lFueraThormallem2)));
      DelayCommand(6.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_PWSTUN), GetLocation(oPC)));
      DelayCommand(7.2, FloatingTextStringOnCreature("Por motivos de persistencia, al reentrar abandonastes el plano", oPC));
      return;
  }

  // ZAPATILLAS SUNE
  if(GetLocalInt(oPC, "ESTOYENZAPSUNE") > 0)
  {
      location lZapSune = GetLocation(GetWaypointByTag("salida_maga_zs"));
      DeleteLocalInt(oPC, "ESTOYENZAPSUNE");
      SetCutsceneMode(oPC, TRUE);
      DelayCommand(7.1, SetCutsceneMode(oPC, FALSE));
      DelayCommand(7.0, AssignCommand(oPC, ActionJumpToLocation(lZapSune)));
      DelayCommand(6.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_PWSTUN), GetLocation(oPC)));
      DelayCommand(7.2, FloatingTextStringOnCreature("Por motivos de persistencia, al reentrar abandonastes la habitación de la maga.", oPC));
      return;
  }
}
