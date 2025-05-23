int StartingConditional()
{
object oPJ = GetPCSpeaker();
int iOro = GetGold(oPJ);
if (iOro >= 500)
    return TRUE;
return FALSE;
}


