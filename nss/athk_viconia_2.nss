int StartingConditional()
{

object oPC = GetPCSpeaker();
int nComprobarVar = GetLocalInt(oPC, "FALLO_CONV_SOLD_DROW");

if(!(nComprobarVar == 1)) return FALSE;

return TRUE;
}
