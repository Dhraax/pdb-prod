int StartingConditional()
{
  object oPC = GetPCSpeaker();
  object oArea = GetArea(oPC);
  string sArea = GetTag(oArea);

  if(sArea == "plano_fuga" || sArea == "BolsaPlanar" ||
     GetLocalInt(oArea, "NOTELEPORT")) return TRUE;

  return FALSE;
}
