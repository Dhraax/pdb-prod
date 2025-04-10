int StartingConditional()
{
object oPJ = GetPCSpeaker();
int iOro = GetGold(oPJ);
if (iOro <= 150)
    return TRUE;
return FALSE;
}

