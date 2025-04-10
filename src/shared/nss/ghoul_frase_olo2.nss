void main()
{
  object oSaliente = GetExitingObject();
  string sSubraza = GetStringLowerCase(GetSubRace(oSaliente));

  if(sSubraza == "ghul") AssignCommand(oSaliente, ActionSpeakString("Mmmmh... ¡Olía que alimentaba!"));
}
