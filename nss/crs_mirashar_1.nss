int StartingConditional()
{
object oPC = GetPCSpeaker();
if (GetStringLowerCase(GetDeity(oPC)) != "shar") return FALSE;
return TRUE;
}

