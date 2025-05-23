void main()
{
object oPC = GetPCSpeaker();
//object oTarget = GetObjectByTag("xxx_bodhi");

SetLocked(OBJECT_SELF, FALSE);
AssignCommand(OBJECT_SELF, ActionOpenDoor(OBJECT_SELF));
}
