//::///////////////////////////////////////////////
//:: FileName ukiconj_si_maghe
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 11/07/2007 1:27:41
//:://////////////////////////////////////////////
#include "pb_nivellanzador"

int StartingConditional()
{

    // Restricción basada en la clase de personaje
    int iPassed = 0;
    //Es mago?
    if(GetLevelByClass(CLASS_TYPE_SORCERER, GetPCSpeaker()) >= 1)
        iPassed = 1;
    //si no es mago... es hechicero?
    if((iPassed == 0) && (GetLevelByClass(CLASS_TYPE_WIZARD, GetPCSpeaker()) >= 1))
        iPassed = 1;
    //si no es mago, no es hechicero.... es caballero arcano?
    if((iPassed == 0) && (GetLevelByClass(CLASS_TYPE_CABALLERO_ARCANO, GetPCSpeaker()) >= 1))
        iPassed = 1;
    //Si no es na de lo anterior, pues es na.
    if(iPassed == 0)
        return FALSE;

    return TRUE;
}
