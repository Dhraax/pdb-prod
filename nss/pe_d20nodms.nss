int StartingConditional()
{
    if(GetLocalInt(GetPCSpeaker(), "iDadosDms") == 1)
        return FALSE;

    return TRUE;
}
