int StartingConditional()
{


    if(!(GetLocalInt(GetPCSpeaker(), "ko_quest_cerrajero") == 2))
        return FALSE;

    return TRUE;
}
