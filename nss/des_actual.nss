int StartingConditional()
{
  object oContenedor = GetObjectByTag("spawn_encuentros");
  object oCreatura = GetObjectByTag(GetLocalString(oContenedor, "Raza"));
  SetLocalInt(oCreatura,"iCon",GetAbilityScore(oCreatura,ABILITY_DEXTERITY));
  int iDesRes = GetAbilityScore(oCreatura,ABILITY_DEXTERITY);
  int iDes = GetAbilityModifier(ABILITY_DEXTERITY,oCreatura);
  int iResult = GetLocalInt(oContenedor, "Destreza");

   SetCustomToken(3011, IntToString(iDes));
  SetCustomToken(4011, IntToString(iDesRes));
    return TRUE;
}
