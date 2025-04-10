int StartingConditional()
{
object oPC = GetPCSpeaker();

if(GetHasFeat(FEAT_WEAPON_FINESSE, oPC) && (GetHasFeat(FEAT_WEAPON_FOCUS_RAPIER, oPC) || GetHasFeat(FEAT_WEAPON_FOCUS_SHORT_SWORD, oPC))
   && GetBaseAttackBonus(oPC) >= 10 || GetLevelByClass(58, oPC) >= 3) return TRUE;
else return FALSE;
}
