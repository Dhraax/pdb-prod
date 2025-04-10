int StartingConditional()
{
object oPC = GetPCSpeaker();

if(GetLocalInt(oPC, "NIVELTORRE") >= 7)
return TRUE;
return FALSE;
}
