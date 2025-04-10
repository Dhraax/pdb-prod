int StartingConditional()
{
object oPJ = GetPCSpeaker();
string sSubraza = GetSubRace(oPJ);
if((sSubraza == "Drow")||(sSubraza == "drow")||(sSubraza == "DROW"))
        return TRUE;
    return FALSE;
}
