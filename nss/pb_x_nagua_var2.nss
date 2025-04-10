int StartingConditional()
{
object oPC = GetPCSpeaker();

if(GetLocalInt(oPC, "NIVELTORRE") >= 2)
return TRUE;
return FALSE;
}
