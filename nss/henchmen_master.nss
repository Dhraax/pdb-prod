int StartingConditional()
{
  object oPC = GetPCSpeaker();
  if(GetLocalString(OBJECT_SELF, "AMO") == GetName(oPC) ) AddHenchman(oPC);
  if(GetMaster(OBJECT_SELF) == OBJECT_INVALID) return TRUE;
  return FALSE;
}
