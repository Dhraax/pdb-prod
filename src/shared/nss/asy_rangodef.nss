void main()
{
    object oPC = GetPCSpeaker();
    int iDefecto = GetLocalInt(oPC, "bDefaultRange");

    //If the range hasn't been set, use the default of 15.
    if (iDefecto == FALSE)
    {
        SetLocalInt(oPC, "iRange", 35);
        SetLocalInt(oPC, "bDefaultRange", TRUE);
    }
}
