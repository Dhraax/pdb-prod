int StartingConditional()
{
object oPC = GetPCSpeaker();

if(GetHitDice(oPC) >= 12) return TRUE;
return FALSE;
}
