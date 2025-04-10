void main()
{
  object oContenedor = GetObjectByTag("spawn_encuentros");
  object oCreatura = GetObjectByTag(GetLocalString(oContenedor, "Raza"));
  effect eBonus = SupernaturalEffect(EffectAbilityIncrease(ABILITY_DEXTERITY,1));
  int oBase = GetAbilityScore(oCreatura,ABILITY_DEXTERITY,TRUE);
  ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBonus, oCreatura);
  SetLocalInt(oContenedor,"iDes",GetAbilityScore(oCreatura,ABILITY_DEXTERITY)-oBase);
}
