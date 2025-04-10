void main()
{
  if(GetIsNight()) return;

  object oVendedor = GetNearestObjectByTag("tendnaskhel1");
  AssignCommand(oVendedor, ActionSpeakString("¡Mire que carne señora! ¡mire que carne!"));
}
