void main()
{
    object oPC = GetLastUsedBy();
    object oSilla = OBJECT_SELF;

    if (GetIsPC(oPC))
    {
        float fFacing = GetFacing(OBJECT_SELF);

        AssignCommand(oPC, ActionSit(oSilla));
        AssignCommand(oPC, SetFacing(fFacing));
    }
}
