int StartingConditional()
{
    object oPC = GetPCSpeaker();
    string sPCSubRace = GetStringLowerCase(GetSubRace(OBJECT_SELF));
    string sCheckSubRace = GetStringLowerCase(GetScriptParam("SUBRACE"));

    return (sPCSubRace == sCheckSubRace);
}
