int StartingConditional()
{
    object oPC = GetPCSpeaker();

    int nClass = StringToInt(GetScriptParam("CLASS"));
    int nLevel = StringToInt(GetScriptParam("LEVEL"));
    int nClassLevel = GetLevelByClass(nClass, oPC);

    return (nClassLevel >= nLevel);
}
