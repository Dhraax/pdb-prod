void main()
{
  object oPC = GetPCSpeaker();
  object oTarget = GetObjectByTag("puerta_drows_pic_esmel");

  SetLocked(oTarget, FALSE);
  AssignCommand(oTarget, ActionOpenDoor(oTarget));
}
