int StartingConditional()
{

object oPC = GetPCSpeaker();
int nComprobarVar = GetLocalInt(oPC, "fallo_convencer_darek");

if(!(nComprobarVar == 1)) return FALSE;

return TRUE;
}
