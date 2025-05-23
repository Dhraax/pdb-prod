int StartingConditional()
{
object oPC = GetPCSpeaker();

if(GetLocalInt(oPC, "NIVELTORRE") >= 5)
return TRUE;
return FALSE;
}
