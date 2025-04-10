//::///////////////////////////////////////////////
//:: XP3 Portable Encampment Script
//:: Copyright (c) 2008 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Allows the PC to rest.

*/
//:://////////////////////////////////////////////
//:: Created By:   Peter Thomas
//:: Adapted for core game by: Craig Welburn
//:: Created On:   2008-01-07
//:://////////////////////////////////////////////

#include "x2_inc_switches"

void main()
{
    // get the player
    object oPC = GetPCSpeaker();

    // check to see if a monster can be seen within 10.0
    int nCount = 1;
    int bHostile = FALSE;
    object oCreature = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE, oPC, nCount);
    string sTag = GetTag(oCreature);
    float fDistance = GetDistanceBetween(oPC, oCreature);
    int bLOS;

    if ((oCreature != OBJECT_INVALID) && (GetIsEnemy(oPC, oCreature) == TRUE) && (fDistance <= 10.0))
    {
        bLOS = LineOfSightObject(oPC, oCreature);
        if (bLOS == TRUE)
        {
            bHostile = TRUE;
        }
    }

    if (bHostile == FALSE)
    {
        nCount++;
    }

    while ((bHostile == FALSE) && (oCreature != OBJECT_INVALID) && (fabs(fDistance) <= 10.0))
    {
        oCreature = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE, oPC, nCount);
        sTag = GetTag(oCreature);
        fDistance = GetDistanceBetween(oPC, oCreature);

        if ((GetIsEnemy(oPC, oCreature) == TRUE) && (fDistance <= 10.0))
        {
            bLOS = LineOfSightObject(oPC, oCreature);

            if (bLOS == TRUE)
            {
                bHostile = TRUE;
            }
        }

        if (bHostile == FALSE)
        {
            nCount++;
        }
    }

    if (bHostile == FALSE)
    {
        // let player rest
        SetLocalInt(oPC, "bCanRest", TRUE);
        DelayCommand(0.5, SetLocalInt(oPC, "bCanRest", FALSE));
        AssignCommand(oPC, ClearAllActions());
        AssignCommand(oPC, ActionRest(TRUE));

        // rest henchmen
        int nCount = 1;
        object oHenchman = GetHenchman(oPC, nCount);
        while (oHenchman != OBJECT_INVALID)
        {
            SetLocalInt(oHenchman, "bCanRest", TRUE);
            DelayCommand(0.5, SetLocalInt(oHenchman, "bCanRest", FALSE));
            AssignCommand(oHenchman, ClearAllActions());
            AssignCommand(oHenchman, ActionRest(TRUE));

            nCount++;
            oHenchman = GetHenchman(oPC, nCount);
        }
    }
    else
    {
        AssignCommand(oPC, SpeakString(GetStringByStrRef(66234), TALKVOLUME_WHISPER));
    }
}
