int StartingConditional()
{

object oMod = GetModule();
int nComprobarVar = GetLocalInt(oMod, "ESTAR_CON_AMBOS");

if(!(nComprobarVar == 1)) return FALSE;

return TRUE;
}
