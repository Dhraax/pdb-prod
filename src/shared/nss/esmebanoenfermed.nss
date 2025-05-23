void main()
{
  object oPC = GetEnteringObject();
  int iVidaMaxima = GetMaxHitPoints(oPC);
  int iVidaActual = GetCurrentHitPoints(oPC);
  int iVariable = GetLocalInt(oPC, "ESMBANYOBAJO");

  if(iVariable == 1) return;

  if(iVidaActual < iVidaMaxima)
  {
      effect eEnfermedad = EffectDisease(DISEASE_ZOMBIE_CREEP);
      FloatingTextStringOnCreature("*¡Tus heridas abiertas se han infectado y has cogido hongos!*", oPC);
      ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEnfermedad, oPC);
  }

  effect eRegenerar = EffectRegenerate(1, 6.0);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRegenerar, oPC, 200.0);

  SetLocalInt(oPC, "ESMBANYOBAJO", 1);
  DelayCommand(200.0, DeleteLocalInt(oPC, "ESMBANYOBAJO"));
}
