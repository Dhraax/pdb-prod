void main()
{
    if(GetLocalInt(GetPCSpeaker(), "iDadosDms") == 1)
        SetLocalInt(GetPCSpeaker(), "iDadosDms", 0);
    else
        SetLocalInt(GetPCSpeaker(), "iDadosDms", 1);
}
