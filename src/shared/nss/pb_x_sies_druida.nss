//::///////////////////////////////////////////////
//:: FileName pb_x_sies_druida
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 25/06/2005 0:11:14
//:://////////////////////////////////////////////
int StartingConditional()
{

	// Restricción basada en la clase de personaje
	int iPassed = 0;
	if(GetLevelByClass(CLASS_TYPE_DRUID, GetPCSpeaker()) >= 1)
		iPassed = 1;
	if(iPassed == 0)
		return FALSE;

	return TRUE;
}
