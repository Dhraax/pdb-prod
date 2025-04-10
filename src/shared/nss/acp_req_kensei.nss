int StartingConditional()
{
object oPC = GetPCSpeaker();

if(GetLevelByClass(CLASS_TYPE_WEAPON_MASTER, oPC) >= 5) return TRUE;
else return FALSE;
}
