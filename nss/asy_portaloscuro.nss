void main()
{
  object oPC = GetLastUsedBy();
  if (!GetIsPC(oPC)) return;
  object oSalto=GetObjectByTag("asy_saldevampiros");
  AssignCommand(oPC,ActionJumpToObject(oSalto));

}
