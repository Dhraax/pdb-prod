int StartingConditional()
{
  object oContenedor = GetObjectByTag("spawn_encuentros");
  object oCreatura = GetObjectByTag(GetLocalString(oContenedor, "Raza"));
  SetLocalInt(oCreatura,"iInt", GetAbilityScore(oCreatura,ABILITY_INTELLIGENCE));
  int iInt = GetAbilityModifier(ABILITY_INTELLIGENCE,oCreatura);
  int iIntRes = GetAbilityScore(oCreatura,ABILITY_INTELLIGENCE);
  SetCustomToken(3007, IntToString(iInt));
  SetCustomToken(4007, IntToString(iIntRes));
    return TRUE;
}
