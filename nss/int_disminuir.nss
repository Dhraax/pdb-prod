void main()
{
  object oContenedor = GetObjectByTag("spawn_encuentros");
  object oCreatura = GetObjectByTag(GetLocalString(oContenedor, "Raza"));
  int iInt = GetAbilityScore(oCreatura,ABILITY_INTELLIGENCE);
  int oBase = GetAbilityScore(oCreatura,ABILITY_INTELLIGENCE,TRUE);
  if(iInt==10){
  SpeakString("Límite mínimo alcanzado");
  }
  else
  {
  effect eBonus = SupernaturalEffect(EffectAbilityDecrease(ABILITY_INTELLIGENCE,1));
  ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBonus, oCreatura);
  SetLocalInt(oContenedor,"iInt",GetAbilityScore(oCreatura,ABILITY_INTELLIGENCE)-oBase);
  }
}
