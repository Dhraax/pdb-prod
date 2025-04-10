int StartingConditional()
{

object oPC = GetPCSpeaker();
int nComprobarVar = GetLocalInt(oPC, "fallo_convencer_enterrador");

if(!(nComprobarVar == 1)) return FALSE;

return TRUE;
}
