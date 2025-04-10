void main()
{
  object oEntrante = GetEnteringObject();
  string sSubraza = GetStringLowerCase(GetSubRace(oEntrante));

  if(sSubraza == "ghul") AssignCommand(oEntrante, ActionSpeakString("Mmmmh... ¡Qué delicioso olor a carne putrefacta!"));
}
