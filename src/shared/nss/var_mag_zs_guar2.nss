int StartingConditional()
{
object oPC = GetPCSpeaker();
int nComprobarVar = GetLocalInt(OBJECT_SELF, "GUARDIA_SUNE_MAGA");

if(!(nComprobarVar == 1)) return FALSE;

return TRUE;
}
