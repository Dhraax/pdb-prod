int StartingConditional()
{
object oPC = GetPCSpeaker();
object oMod = GetModule();

if(GetLocalInt(oMod, "NOESCLAVOS") == 1) return TRUE;
return FALSE;
}
