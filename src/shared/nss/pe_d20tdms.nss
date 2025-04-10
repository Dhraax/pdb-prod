int StartingConditional()
{
    if(GetLocalInt(GetPCSpeaker(), "iDadosDms") == 1)
        return TRUE;

    return FALSE;
}
