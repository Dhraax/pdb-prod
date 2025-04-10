void main()
{
object oPC = GetPCSpeaker();
object oWP = GetNearestObjectByTag("WP_esmedesague01");

 AssignCommand(oPC,JumpToObject(oWP));
}
