int StartingConditional()
{
object oPJ = GetPCSpeaker();
int iOro = GetGold(oPJ);
if (iOro <= 50)
    return TRUE;
return FALSE;
}


