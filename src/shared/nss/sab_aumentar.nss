void main()
{
  object oContenedor = GetObjectByTag("spawn_encuentros");
  object oCreatura = GetObjectByTag(GetLocalString(oContenedor, "Raza"));
  effect eBonus = SupernaturalEffect(EffectAbilityIncrease(ABILITY_WISDOM,1));
  int oBase = GetAbilityScore(oCreatura,ABILITY_WISDOM,TRUE);
  ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBonus, oCreatura);
  SetLocalInt(oContenedor,"iSab",GetAbilityScore(oCreatura,ABILITY_WISDOM)-oBase);
}
