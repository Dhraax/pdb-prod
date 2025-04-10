int StartingConditional()
{
object oPJ = GetPCSpeaker();
if(!(GetLocalInt(oPJ, "apuesta_tril_80000") == 1))
    return FALSE;
return TRUE;
}


