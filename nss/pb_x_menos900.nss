int StartingConditional()
{
object oPJ = GetPCSpeaker();
int iOro = GetGold(oPJ);
if (iOro <= 900)
    return TRUE;
return FALSE;
}


