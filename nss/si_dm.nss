//::///////////////////////////////////////////////
//:: FileName ukiconj_si_maghe
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 11/07/2007 1:27:41
//:://////////////////////////////////////////////
int StartingConditional()
{

    // Restricción basada en la clase de personaje
    int iPassed = 0;
    if(GetIsDM(GetLastSpeaker()))
        iPassed = 1;
    if(iPassed == 0)
        return FALSE;

    return TRUE;
}
