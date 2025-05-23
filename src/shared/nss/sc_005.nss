//::///////////////////////////////////////////////
//:: FileName sc_005
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 20/03/2016 13:04:15
//:://////////////////////////////////////////////

#include "lib_race"

int StartingConditional()
{

    // Rechazar las razas de personajes
    if(PB_Race_GetIsElf(GetPCSpeaker()))
        return FALSE;
    if(GetRacialType(GetPCSpeaker()) == RACIAL_TYPE_HALFORC)
        return FALSE;

    // Rechazar otras razas
    if(GetRacialType(GetPCSpeaker()) == RACIAL_TYPE_ABERRATION)
        return FALSE;
    if(GetRacialType(GetPCSpeaker()) == RACIAL_TYPE_OUTSIDER)
        return FALSE;
    if(GetRacialType(GetPCSpeaker()) == RACIAL_TYPE_ANIMAL)
        return FALSE;
    if(GetRacialType(GetPCSpeaker()) == RACIAL_TYPE_BEAST)
        return FALSE;
    if(GetRacialType(GetPCSpeaker()) == RACIAL_TYPE_MAGICAL_BEAST)
        return FALSE;
    if(GetRacialType(GetPCSpeaker()) == RACIAL_TYPE_SHAPECHANGER)
        return FALSE;
    if(GetRacialType(GetPCSpeaker()) == RACIAL_TYPE_OOZE)
        return FALSE;
    if(GetRacialType(GetPCSpeaker()) == RACIAL_TYPE_CONSTRUCT)
        return FALSE;
    if(GetRacialType(GetPCSpeaker()) == RACIAL_TYPE_DRAGON)
        return FALSE;
    if(GetRacialType(GetPCSpeaker()) == RACIAL_TYPE_ELEMENTAL)
        return FALSE;
    if(GetRacialType(GetPCSpeaker()) == RACIAL_TYPE_FEY)
        return FALSE;
    if(GetRacialType(GetPCSpeaker()) == RACIAL_TYPE_GIANT)
        return FALSE;
    if(GetRacialType(GetPCSpeaker()) == RACIAL_TYPE_HUMANOID_MONSTROUS)
        return FALSE;
    if(PB_Race_GetIsUndead(GetPCSpeaker()))
        return FALSE;
    if(GetRacialType(GetPCSpeaker()) == RACIAL_TYPE_HUMANOID_ORC)
        return FALSE;
    if(GetRacialType(GetPCSpeaker()) == RACIAL_TYPE_HUMANOID_REPTILIAN)
        return FALSE;
    if(GetRacialType(GetPCSpeaker()) == RACIAL_TYPE_VERMIN)
        return FALSE;
    if(GetRacialType(GetPCSpeaker()) == RACIAL_TYPE_HUMANOID_GOBLINOID)
        return FALSE;

    return TRUE;
}
