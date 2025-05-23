void main()
{
  object oPC = GetLastUsedBy();
  location lZapSune = GetLocation(GetWaypointByTag("esm_zs_cocina"));
  AssignCommand(oPC, JumpToLocation(lZapSune));
}
