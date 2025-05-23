void main()
{
  if(GetIsNight()) return;

  object oVendedor = GetNearestObjectByTag("tendnaskhel2");
  AssignCommand(oVendedor, ActionSpeakString("¡Mire que pescadito tengo señora! ¡mire que pescadito!"));
}
