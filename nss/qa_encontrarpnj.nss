int StartingConditional()
{
    object oPC = GetPCSpeaker();
    int iQuest = GetLocalInt(OBJECT_SELF, "TENGO_QUEST");
    int iQuestPC = GetLocalInt(oPC, "QUEST_ALEATORIA");

    if(iQuest == iQuestPC) return TRUE;
    return FALSE;
}
