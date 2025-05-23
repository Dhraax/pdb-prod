void main()
{
  object oContenedor = GetObjectByTag("spawn_encuentros");
  object oCreatura = GetObjectByTag(GetLocalString(oContenedor, "Raza"));
  int oBase = GetAbilityScore(oCreatura,ABILITY_WISDOM,TRUE);
  int iSab = GetAbilityScore(oCreatura,ABILITY_WISDOM);
  if(iSab==10){
  SpeakString("Límite mínimo alcanzado");
  }
  else
  {
  effect eBonus = SupernaturalEffect(EffectAbilityDecrease(ABILITY_WISDOM,1));
  ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBonus, oCreatura);
  SetLocalInt(oContenedor,"iSab",GetAbilityScore(oCreatura,ABILITY_WISDOM)-oBase);
  }
}
