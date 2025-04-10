void main()
{
  object oPC = GetEnteringObject();

  if(GetIsPC(oPC) != TRUE) return;
  if(GetIsNight()) return;

  object oVendedor = GetNearestObjectByTag("Venderdora_amnag");
  AssignCommand(oVendedor, ActionSpeakString("¡Venid, venid, tengo los mejores complementos para el aventurero!"));
}
