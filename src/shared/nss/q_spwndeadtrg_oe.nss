//::///////////////////////////////////////////////
//:: Project Q Spawn Risen Dead Trigger OnEnter
//:: q_spwndeadtrg_oe.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Project Q v2.1
*/
//:://////////////////////////////////////////////
//:: Created By: Pstemarie
//:: Created On: November 8, 2015
//:://////////////////////////////////////////////

#include "x0_i0_position"

void main()
{
    object oPC = GetEnteringObject();
    //Abort if not a PC or already triggered
    if (!GetIsPC(oPC) || GetLocalInt(OBJECT_SELF, "TRIGGERED") == 1)
        return;

    //Only at night - you can comment this if statement out to have the trigger active at all times of day
    if (GetIsNight() || GetLocalInt(OBJECT_SELF, "Q_AlwaysActive") == 1)
    {
        //Get the spawn location from the trigger
        object oSpawn = GetWaypointByTag(GetLocalString(OBJECT_SELF, "Q_SPAWN_WP"));
        location lSpawn;
        string sResRef;
        //Determine the size of the loop to use based upon the value of the variable set on the trigger
        int iLoop = GetLocalInt(OBJECT_SELF, "Q_SPAWN_MULTIPLE");
        if (iLoop > 1)
        {
            int i;
            for (i = 0; i < iLoop; i++)
            {
                //Cycle the multiple resrefs supplied by variables on the trigger
                sResRef = GetLocalString(OBJECT_SELF, "Q_SPAWN_RESREF"+IntToString(i));
                if (sResRef == "") //if no addition values for a multiple spawn use the default value instead
                {
                    sResRef = GetLocalString(OBJECT_SELF, "Q_SPAWN_RESREF0");
                    if (sResRef == "") //abort on error and write to log
                    {
                        WriteTimestampedLogEntry("ERROR: " +GetTag(OBJECT_SELF)+ " - no resref value assigned to variable Q_SPAWN_RESREF0");
                        return;
                    }
                }
                lSpawn = GetRandomLocation(GetArea(OBJECT_SELF), oSpawn, 2.5);
                DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DUST_EXPLOSION), lSpawn));
                CreateObject(OBJECT_TYPE_CREATURE, sResRef, lSpawn, TRUE);
            }
        }
        else
        {
            lSpawn = GetLocation(oSpawn);
            sResRef = GetLocalString(OBJECT_SELF, "Q_SPAWN_RESREF0");
            if (sResRef == "") //abort on error and write to log
            {
                WriteTimestampedLogEntry("ERROR: " +GetTag(OBJECT_SELF)+ " - no resref value assigned to variable Q_SPAWN_RESREF0");
                return;
            }
            DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DUST_EXPLOSION), lSpawn));
            CreateObject(OBJECT_TYPE_CREATURE, sResRef, lSpawn, TRUE);
        }
        //Flag the trigger as actvated so it only spawns creatures once
        SetLocalInt(OBJECT_SELF, "TRIGGERED", 1);
    }
}
