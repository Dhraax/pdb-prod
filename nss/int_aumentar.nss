void main()
{
  object oContenedor = GetObjectByTag("spawn_encuentros");
  object oCreatura = GetObjectByTag(GetLocalString(oContenedor, "Raza"));
  effect eBonus = SupernaturalEffect(EffectAbilityIncrease(ABILITY_INTELLIGENCE,1));
  int oBase = GetAbilityScore(oCreatura,ABILITY_INTELLIGENCE,TRUE);
  ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBonus, oCreatura);
  SetLocalInt(oContenedor,"iInt",GetAbilityScore(oCreatura,ABILITY_INTELLIGENCE)-oBase);
}
