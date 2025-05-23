int StartingConditional()
{
object oPJ = GetPCSpeaker();
int iOro = GetGold(oPJ);
if (iOro >= 30)
    return TRUE;
return FALSE;
}


