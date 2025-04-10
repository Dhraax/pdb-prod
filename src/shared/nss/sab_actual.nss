int StartingConditional()
{
  object oContenedor = GetObjectByTag("spawn_encuentros");
  object oCreatura = GetObjectByTag(GetLocalString(oContenedor, "Raza"));
  SetLocalInt(oCreatura,"iSab", GetAbilityScore(oCreatura,ABILITY_WISDOM));
  int iSab = GetAbilityModifier(ABILITY_WISDOM,oCreatura);
  int iSabRes = GetAbilityScore(oCreatura,ABILITY_WISDOM);
  SetCustomToken(3005, IntToString(iSab));
  SetCustomToken(4005, IntToString(iSabRes));
    return TRUE;
}
