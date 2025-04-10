void main()
{
  object oContenedor = GetObjectByTag("spawn_encuentros");
  object oCreatura = GetObjectByTag(GetLocalString(oContenedor, "Raza"));
  int oBase = GetAbilityScore(oCreatura,ABILITY_STRENGTH,TRUE);
  effect eBonus = SupernaturalEffect(EffectAbilityIncrease(ABILITY_STRENGTH,1));
  ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBonus, oCreatura);
  SetLocalInt(oContenedor,"iFue",GetAbilityScore(oCreatura,ABILITY_STRENGTH)-oBase);

}
