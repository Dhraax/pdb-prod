int StartingConditional()
{
object oPJ = GetPCSpeaker();
if(!(GetLocalInt(oPJ, "apuesta_tril_500") == 1))
    return FALSE;
return TRUE;
}

