void main()
{
object oPC = GetLastUsedBy();
object oWP = GetNearestObjectByTag("WP_esmel_agua1x");

 AssignCommand(oPC,JumpToObject(oWP));
}
