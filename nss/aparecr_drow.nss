int StartingConditional()
{
object oPC = GetPCSpeaker();

if (GetSubRace(oPC) != "Drow") return FALSE;

if (GetSubRace(oPC) != "drow") return FALSE;

if (GetSubRace(oPC) != "DROW") return FALSE;

return TRUE;
}
