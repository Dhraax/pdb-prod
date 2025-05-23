void main()
{
  if(GetIsNight()) return;

  object oVendedor = GetNearestObjectByTag("tendnaskhel3");
  AssignCommand(oVendedor, ActionSpeakString("¡El mejor maiz! ¡De tres cuartos el saco señores! ¡El mejor maiz!"));
}
