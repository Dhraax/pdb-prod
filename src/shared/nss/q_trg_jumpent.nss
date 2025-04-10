void main()
{
    object oPC = GetEnteringObject();
    string sTag = GetTag(OBJECT_SELF);

    if (!GetIsPC(oPC))
        return;

    SetLocalInt(oPC, "Q_JUMP_ALLOWED", 1);
    SetLocalString(oPC, "Q_JUMP_FACING", sTag);
}
