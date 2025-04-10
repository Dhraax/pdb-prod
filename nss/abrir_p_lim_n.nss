void main()
{
object oPC = GetPCSpeaker();
object oTarget = OBJECT_SELF;

SetLocked(oTarget, FALSE);
AssignCommand(oTarget, ActionOpenDoor(oTarget));
}
