int StartingConditional()
{
object oPJ = GetPCSpeaker();
int iOro = GetGold(oPJ);
if (iOro >= 15000)
    return TRUE;
return FALSE;
}
