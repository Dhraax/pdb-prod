void main()
{
object oPC = GetLastUsedBy();
object oWP = GetNearestObjectByTag("WP_fuerabanopub");

AssignCommand(oPC, JumpToObject(oWP));
}
