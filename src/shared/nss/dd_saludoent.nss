//::///////////////////////////////////////////////
//:: FileName dd_saludoent
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 07/03/2004 20:54:58
//:://////////////////////////////////////////////
int StartingConditional()
{

	// Restricción basada en la clase de personaje
	int iPassed = 0;
	if(GetLevelByClass(CLASS_TYPE_DRUID, GetPCSpeaker()) >= 1)
		iPassed = 1;
	if((iPassed == 0) && (GetLevelByClass(CLASS_TYPE_RANGER, GetPCSpeaker()) >= 1))
		iPassed = 1;
	if(iPassed == 0)
		return FALSE;

	return TRUE;
}
