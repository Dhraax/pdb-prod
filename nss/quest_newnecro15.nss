int StartingConditional()
{

object oPC = GetPCSpeaker();
int nComprobarVar = GetLocalInt(oPC, "AGATHA_NO_NO");

if(!(nComprobarVar == 1)) return FALSE;

return TRUE;
}
