int StartingConditional()
{
    //PHB FAMILIAR CODE ADDITIONS
    // Master can only speak with familiar if master is level 5 or over.
    object oPC = GetPCSpeaker();
    int iLevel = GetLevelByClass(CLASS_TYPE_SORCERER, oPC);
    iLevel = iLevel + GetLevelByClass(CLASS_TYPE_WIZARD, oPC);
    if ((iLevel < 5) && (oPC == GetMaster())) return TRUE;
    //PHB FAMILIAR CODE END

    return GetPCSpeaker() != GetMaster();
}
