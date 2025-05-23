int StartingConditional()
{
object oPC = GetPCSpeaker();
object oMod = GetModule();

if(GetLocalInt(oMod, "NOEJERCITOS") == 1) return TRUE;
return FALSE;
}
