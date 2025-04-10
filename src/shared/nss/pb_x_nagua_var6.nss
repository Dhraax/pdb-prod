int StartingConditional()
{
object oPC = GetPCSpeaker();

if(GetLocalInt(oPC, "NIVELTORRE") >= 6)
return TRUE;
return FALSE;
}
