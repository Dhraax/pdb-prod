void main()
{
  object oContenedor = GetObjectByTag("spawn_encuentros");
  object oCreatura = GetObjectByTag(GetLocalString(oContenedor, "Raza"));
  int iDes = GetAbilityScore(oCreatura,ABILITY_DEXTERITY);
  int oBase = GetAbilityScore(oCreatura,ABILITY_DEXTERITY,TRUE);
  if(iDes==10){
  SpeakString("Límite mínimo alcanzado");
  }
  else
  {
  effect eBonus = SupernaturalEffect(EffectAbilityDecrease(ABILITY_DEXTERITY,1));
  ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBonus, oCreatura);
  SetLocalInt(oContenedor,"iDes",GetAbilityScore(oCreatura,ABILITY_DEXTERITY)-oBase);
  }
}
