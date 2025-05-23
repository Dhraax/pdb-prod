int StartingConditional()
{
object oPJ = GetPCSpeaker();
if(!(GetLocalInt(oPJ, "apuesta_tril_5000") == 1))
    return FALSE;
return TRUE;
}



