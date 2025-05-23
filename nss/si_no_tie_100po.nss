int StartingConditional()
{
object oPJ = GetPCSpeaker();
int iOro = GetGold(oPJ);
if (iOro <= 100)
    return TRUE;
return FALSE;
}


