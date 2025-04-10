int StartingConditional()
{
object oPJ = GetPCSpeaker();
if(!(GetLocalInt(oPJ, "apuesta_tril_10000") == 1))
    return FALSE;
return TRUE;
}



