int StartingConditional()
{
object oPJ = GetPCSpeaker();
if(!(GetLocalInt(oPJ, "apuesta_tril_50000") == 1))
    return FALSE;
return TRUE;
}


