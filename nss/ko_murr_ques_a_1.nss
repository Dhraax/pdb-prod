int StartingConditional()
{


    if(!(GetLocalInt(GetPCSpeaker(), "ko_quest_cerrajero") == 1))
        return FALSE;

    return TRUE;
}
