int StartingConditional()
{
object oPJ = GetPCSpeaker();
int iOro = GetGold(oPJ);
if (iOro >= 80000)
    return TRUE;
return FALSE;
}


