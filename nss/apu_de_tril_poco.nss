int StartingConditional()
{
object oPJ = GetPCSpeaker();
if(!(GetLocalInt(oPJ, "apuesta_tril_poco") == 1))
    return FALSE;
return TRUE;
}
