int StartingConditional()
{
  object oContenedor = GetObjectByTag("spawn_encuentros");
  object oCreatura = GetObjectByTag(GetLocalString(oContenedor, "Raza"));
  SetLocalInt(oCreatura,"iFue", GetAbilityScore(oCreatura,ABILITY_STRENGTH));
  int iFue = GetAbilityModifier(ABILITY_STRENGTH,oCreatura);
  int iFueRes = GetAbilityScore(oCreatura,ABILITY_STRENGTH);
  SetCustomToken(3003, IntToString(iFue));
  SetCustomToken(4003, IntToString(iFueRes));
    return TRUE;
}
