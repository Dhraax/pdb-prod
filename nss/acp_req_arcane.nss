int StartingConditional()
{
object oPC = GetPCSpeaker();

if(GetLevelByClass(CLASS_TYPE_WIZARD, oPC) >= 15 || GetLevelByClass(CLASS_TYPE_SORCERER, oPC) >= 15 || GetLevelByClass(57, oPC) >= 15) return TRUE;
else return FALSE;
}
