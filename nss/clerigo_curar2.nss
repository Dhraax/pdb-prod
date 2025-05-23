void main()
{
  object oPC = GetPCSpeaker();
  string sSubraza = GetStringLowerCase(GetSubRace(oPC));
  int iOro = 80;

  if(GetGold(oPC) >= iOro)
  {
      AssignCommand(oPC, TakeGoldFromCreature(iOro, oPC, TRUE));
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(d10()+20), oPC);

      if(sSubraza == "vampiro" || sSubraza == "ghul" || sSubraza == "deathknight" || sSubraza == "necropolita" || sSubraza == "liche") ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HARM), oPC);
      else ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_X), oPC);
  }

  else SendMessageToPC(oPC, "¡No tienes " + IntToString(iOro) + " monedas de oro!");
}
