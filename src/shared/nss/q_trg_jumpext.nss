void main()
{
    object oPC = GetEnteringObject();
    DeleteLocalInt(oPC, "Q_JUMP_ALLOWED");
    DeleteLocalString(oPC, "Q_JUMP_FACING");
}
