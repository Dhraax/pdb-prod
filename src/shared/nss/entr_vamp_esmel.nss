void main()
{
object oPC = GetPCSpeaker();
object oTarget = GetObjectByTag("entrada_vampis_cloakas_esmel");

SetLocked(oTarget, FALSE);
AssignCommand(oTarget, ActionOpenDoor(oTarget));
}

