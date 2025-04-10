int StartingConditional()
{
object oPJ = GetPCSpeaker();
if(!(GetLocalInt(oPJ, "apuesta_tril_mucho") == 1))
    return FALSE;
return TRUE;
}
