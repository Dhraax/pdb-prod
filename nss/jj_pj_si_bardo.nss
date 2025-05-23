/*se abre si es bardo y tiene interpretar */

int StartingConditional()
{
object oPC = GetPCSpeaker();

if ((GetLevelByClass(CLASS_TYPE_BARD, oPC)==0))
return FALSE;

if (!GetHasSkill(SKILL_PERFORM, oPC)) return FALSE;

return TRUE;
}
