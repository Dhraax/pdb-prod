//::///////////////////////////////////////////////
//:: Name: tk_zomb_ondeath
//:://////////////////////////////////////////////
/*
    OnDeath script for The Krit's zombies, if
    you want the zombies to respawn after death.

    Only works in combination with tk_zomb_onspawn.
*/
//:://////////////////////////////////////////////
//:: Created By: The Krit
//:: Created On: October 24, 2007
//:://////////////////////////////////////////////


#include "tk_zomb_inc"


// Respawns the zombie at the indicated location, once no PC's are in the area.
void RespawnZombie(string sResRef, location lWhere);


void main()
{
    // Get the time before we respawn.
    // Local on the creature overrides the global setting.
    float fRespawnDelay = GetLocalFloat(OBJECT_SELF, TK_ZOMBIE_RESPAWN);
    if ( fRespawnDelay == 0.0 )
        fRespawnDelay = TK_ZOMBIE_DEFAULT_RESPAWN;

    // See if we are configured to respawn.
    if ( TK_ZOMBIE_RESPAWN_FLAG  &&  fRespawnDelay > 0.0  &&
         GetLocalInt(OBJECT_SELF, TK_ZOMBIE_SPAWN_FLAG)  &&
        !GetLocalInt(OBJECT_SELF, TK_ZOMBIE_DESPAWNING) )
        // Schedule a respawn.
    {
        string sResRef = GetLocalString(OBJECT_SELF, TK_ZOMBIE_ORIGINAL);
        location lWhere = GetLocalLocation(OBJECT_SELF, TK_ZOMBIE_SPAWN_LOC);
        AssignCommand(GetModule(), DelayCommand(fRespawnDelay,
                                        RespawnZombie(sResRef, lWhere)));
    }

    // Execute default OnDeath script.
    // (The Hordes script is just a wrapper for this, so we'll save time.)
    ExecuteScript("nw_c2_default7", OBJECT_SELF);
}


// Respawns the zombie at the indicated location, once no PC's are in the area.
void RespawnZombie(string sResRef, location lWhere)
{
    // See if we should check for PC's in the area.
    if ( TK_ZOMBIE_RESPAWN_HEARTBEAT > 0.0 )
    {
        // Look for a PC in the area.
        object oArea = GetAreaFromLocation(lWhere);
        object oPC = GetFirstPC();
        while ( GetIsObjectValid(oPC)  &&  GetArea(oPC) != oArea )
            oPC = GetNextPC();
        // If there is a PC in the area, try again later.
        if ( GetIsObjectValid(oPC) )
        {
            DelayCommand(TK_ZOMBIE_RESPAWN_HEARTBEAT, RespawnZombie(sResRef, lWhere));
            return;
        }
    }

    // Respawn the original zombie creature.
    CreateObject(OBJECT_TYPE_CREATURE, sResRef, lWhere);
}

