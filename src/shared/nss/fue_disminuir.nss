void main()
{
  object oContenedor = GetObjectByTag("spawn_encuentros");
  object oCreatura = GetObjectByTag(GetLocalString(oContenedor, "Raza"));
  int iFue = GetAbilityScore(oCreatura,ABILITY_STRENGTH);
  int oBase = GetAbilityScore(oCreatura,ABILITY_STRENGTH,TRUE);
  if(iFue==10){
  SpeakString("Límite mínimo alcanzado");
  }
  else
  {
  effect eBonus = SupernaturalEffect(EffectAbilityDecrease(ABILITY_STRENGTH,1));
  ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBonus, oCreatura);
  SetLocalInt(oContenedor,"iFue",GetAbilityScore(oCreatura,ABILITY_STRENGTH)-oBase);
  }
}
