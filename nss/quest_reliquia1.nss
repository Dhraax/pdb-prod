#include "mti_libreria"
int StartingConditional()
{
    object oPC = GetPCSpeaker();
    int iNivel1 = GetLevelByPosition(1, oPC);
    int iNivel2 = GetLevelByPosition(2, oPC);
    int iNivel3 = GetLevelByPosition(3, oPC);
    int iTotal = iNivel1 + iNivel2 + iNivel3;
    int iAlig = GetAlignmentGoodEvil(oPC);
    int iVariable = ObtenerIntPersistente(oPC, "QUEST_RELIQUIA_SAGRADA");
    if((iVariable==0) && (iTotal >=16))
        if ((iAlig==ALIGNMENT_GOOD) || (iAlig ==ALIGNMENT_NEUTRAL)) return TRUE;
    return FALSE;
}
