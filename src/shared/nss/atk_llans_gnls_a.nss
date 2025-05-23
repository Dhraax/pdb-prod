int StartingConditional()
{
  object oPC = GetPCSpeaker();
  object oMod = GetModule();

  if(GetLocalInt(oMod, "NOLLANOSGNOLL") == 1) return TRUE;
  return FALSE;
}
