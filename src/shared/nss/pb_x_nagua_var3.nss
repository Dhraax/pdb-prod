int StartingConditional()
{
object oPC = GetPCSpeaker();

if(GetLocalInt(oPC, "NIVELTORRE") >= 3)
return TRUE;
return FALSE;
}

