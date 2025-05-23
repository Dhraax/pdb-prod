int StartingConditional()
{
object oPC = GetPCSpeaker();
int iVariable = GetLocalInt(oPC, "DONACIONTEATRO");

if(iVariable == 0) return FALSE;
return TRUE;
}
