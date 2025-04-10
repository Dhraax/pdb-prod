//::///////////////////////////////////////////////
//:: Acid Oil
//:: x0_s3_acid
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Grenade.
    Fires at a target. If hit, the target takes
    direct damage. If missed, all enemies within
    an area of effect take splash damage.

    HOWTO:
    - If target is valid attempt a hit
       - If miss then MISS
       - If hit then direct damage
    - If target is invalid or MISS
       - have area of effect near target
       - everyone in area takes splash damage
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: September 10, 2002
//:://////////////////////////////////////////////

#include "X0_I0_SPELLS"
void main()
{                  // SpawnScriptDebugger();
    object oItem = GetSpellCastItem();
    object oVeneno;
    location lTarget = GetSpellTargetLocation();
    int idVeneno;
    if (GetStringLeft(GetTag(oItem), 15) == "Saquitodeveneno")
    {
        idVeneno = StringToInt(GetStringRight(GetTag(oItem), 2));
        effect eAOE = EffectAreaOfEffect(AOE_PER_FOGACID, "cerr_venom_inh_i","cerr_venom_inh_h","cerr_venom_inh_o");
        effect eExplosion = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_ACID);
        eAOE = EffectLinkEffects(eExplosion, eAOE);
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(5));
        oVeneno = CreateObject(OBJECT_TYPE_WAYPOINT, "nw_waypoint001", lTarget, FALSE, IntToString(idVeneno)+"_envenenado");
        DestroyObject(oVeneno, RoundsToSeconds(5));
    }
    else
    {
        DoGrenade(d6(1),1, VFX_IMP_ACID_L, VFX_FNF_LOS_NORMAL_30,DAMAGE_TYPE_ACID,RADIUS_SIZE_HUGE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}
