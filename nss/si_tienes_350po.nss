int StartingConditional()
{
object oPJ = GetPCSpeaker();
int iOro = GetGold(oPJ);
if (iOro >= 350)
    return TRUE;
return FALSE;
}


