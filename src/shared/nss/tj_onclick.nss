void main()
{
  object oPC = GetLastUsedBy();
  string sIdentidad = GetName(oPC,TRUE) + GetPCPublicCDKey(oPC);
  string sVariable = GetLocalString(OBJECT_SELF, "TJIDENTIDAD");

  if(sVariable != sIdentidad) return;

  ActionStartConversation(GetLastUsedBy(), "", TRUE, FALSE);
}
