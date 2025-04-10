//::///////////////////////////////////////////////
//:: XP3 Portable Encampment Script
//:: Copyright (c) 2008 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Destroy the camp object and recover it as inventory

*/
//:://////////////////////////////////////////////
//:: Created By:   Peter Thomas
//:: Adapted for core game by: Craig Welburn
//:: Created On:   2008-01-07
//:://////////////////////////////////////////////

void main()
{
    object oPC = GetPCSpeaker();
    DestroyObject(OBJECT_SELF);
    CreateItemOnObject("q_it_camp", oPC);
}
