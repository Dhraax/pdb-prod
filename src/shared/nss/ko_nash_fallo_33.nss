int StartingConditional()
{

object oPC = GetPCSpeaker();
int nComprobarVar = GetLocalInt(oPC, "fallo_animar_lyretha");

if(!(nComprobarVar == 1)) return FALSE;

return TRUE;
}
