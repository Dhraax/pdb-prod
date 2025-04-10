int StartingConditional()
{
     object oPC = GetPCSpeaker();

   if(GetLocalString(OBJECT_SELF, "AMO") == GetName(oPC, TRUE))  return TRUE;
   if(GetLocalObject(oPC, "LIGADURA") == OBJECT_SELF) return TRUE;

   return FALSE;
}

