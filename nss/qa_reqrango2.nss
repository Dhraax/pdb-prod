int StartingConditional()
{
object oPC = GetPCSpeaker();

if(GetHitDice(oPC) >= 12 && GetHitDice(oPC) <= 16 ) return TRUE;
else return FALSE;
}
