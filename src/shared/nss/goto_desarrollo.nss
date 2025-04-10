void main()
{
    object oPC = GetLastSpeaker();
    object oDest = GetObjectByTag("dst_desarrollo");

    AssignCommand(oPC, ActionJumpToObject(oDest));
}
