int StartingConditional()
{
object oPC = GetPCSpeaker();

if(GetLevelByClass(CLASS_TYPE_FIGHTER, oPC) >= 15
   || GetLevelByClass(CLASS_TYPE_PALADIN, oPC) >= 15
   || GetLevelByClass(CLASS_TYPE_DIVINECHAMPION, oPC) >= 5
   || GetLevelByClass(CLASS_TYPE_DWARVEN_DEFENDER, oPC) >= 5) return TRUE;
else return FALSE;
}
