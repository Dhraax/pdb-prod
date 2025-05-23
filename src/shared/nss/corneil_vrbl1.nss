void main()
{
object oPC = GetPCSpeaker();
object oTarget = GetObjectByTag("puerta_ghoul");

SetLocked(oTarget, FALSE);
AssignCommand(oTarget, ActionOpenDoor(oTarget));
}
