int StartingConditional()
{
object oPJ = GetPCSpeaker();
int iOro = GetGold(oPJ);
if (iOro <= 700)
    return TRUE;
return FALSE;
}

