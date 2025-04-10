void main()
{
  object oPC = GetEnteringObject();

  if(GetIsPC(oPC) != TRUE) return;
  if(GetIsNight()) return;

  object oVendedor = GetNearestObjectByTag("Hombreextrao_amnagua");
  AssignCommand(oVendedor, ActionSpeakString("Psss, pssss, aquí, aquí amigo... Tengo cosas para ti..."));
}
