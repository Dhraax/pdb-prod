void main()
{
  object oPC = GetEnteringObject();

  if(GetIsNight()) return;
  if(GetIsPC(oPC) != TRUE) return;

  object oVendedor = GetObjectByTag("Venderdor_amnag");
  AssignCommand(oVendedor, ActionSpeakString("¡¡¡Anillos, colgantes, diamantes!!! Aquí encontraràs todas las joyas que buscas..."));
}
