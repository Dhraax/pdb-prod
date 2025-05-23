//::///////////////////////////////////////////////
//:: Project Q Rust Monster OnUserDefined
//:: q_rustmonstr_ud.nss
//:://////////////////////////////////////////////
/*
    Rust Monster

        OnDamaged   - destroy attacker's weapon unless attacker makes a DC 17
                      reflex save.

        OnHeartbeat - wander around looking for metal objects to devour.

        OnPerceived - attack perceived creature if it is carrying any metal
                      items.

*/
//:://////////////////////////////////////////////
//:: Created By: Pstemarie
//:: Created On: 31 Jan 2010
//:://////////////////////////////////////////////
#include "nw_i0_generic"
#include "x0_i0_spells"
#include "x2_inc_switches"
#include "q_inc_rustmnstr"

void main()
{
    int nUser = GetUserDefinedEventNumber();

    if(nUser == 1001) //HEARTBEAT
    {
        ActionRandomWalk(); // Default is wander around a bit

        float fDetectRange = 25.0;
        object oItem = GetNearestObject(OBJECT_TYPE_ITEM);
        if (GetIsObjectValid(oItem))
        {
            float fDist = GetDistanceToObject(oItem);
            if (fDist < fDetectRange) // Can we detect garbage?
            {
                ClearAllActions();
                ActionMoveToObject(oItem,FALSE,1.0); // Move to item.
                if ((rm_GetIsItemMetal(oItem) != 0) && (GetDistanceToObject(oItem) < 1.5))
                {
                    ApplyEffectAtLocation(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_ACID),GetLocation(oItem));
                    DestroyObject(oItem);
                }
            }
        }
    }
    else if(nUser == 1002) // PERCEIVE
    {
        object oTarget = GetNearestCreature(CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN, OBJECT_SELF, 1);

        if (oTarget != OBJECT_INVALID)
        {
            if (rm_GetHasMetalItemEquipped(oTarget) || rm_GetHasMetalItemInInventory(oTarget))
            {
                AttackTarget(oTarget);
            }
            else if (GetNextTarget(2) != OBJECT_INVALID)
            {
                oTarget = GetNextTarget(2);
                if (rm_GetHasMetalItemEquipped(oTarget) || rm_GetHasMetalItemInInventory(oTarget))
                {
                    AttackTarget(oTarget);
                }
                else if (GetNextTarget(3) != OBJECT_INVALID)
                {
                    oTarget = GetNextTarget(3);
                    if (rm_GetHasMetalItemEquipped(oTarget) || rm_GetHasMetalItemInInventory(oTarget))
                    {
                        AttackTarget(oTarget);
                    }
                    else if (GetNextTarget(4) != OBJECT_INVALID)
                    {
                        oTarget = GetNextTarget(4);
                        if (rm_GetHasMetalItemEquipped(oTarget) || rm_GetHasMetalItemInInventory(oTarget))
                        {
                            AttackTarget(oTarget);
                        }
                        else if (GetNextTarget(5) != OBJECT_INVALID)
                        {
                            oTarget = GetNextTarget(5);
                            if (rm_GetHasMetalItemEquipped(oTarget) || rm_GetHasMetalItemInInventory(oTarget))
                            {
                                AttackTarget(oTarget);
                            }
                        }
                    }
                }
            }
        }
    }
    else if(nUser == 1006) // DAMAGED
    {
        if (GetModuleSwitchValue(MODULE_SWITCH_ENABLE_BEBILITH_RUIN_ARMOR))
        {
            object oAttacker    = GetLastDamager(OBJECT_SELF);
            object oItem        = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oAttacker);

            if (!GetIsObjectValid(oItem))
            {
                oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oAttacker);
            }

            if (GetWeaponRanged(oItem) || rm_GetIsItemMetal(oItem) == 0)
            {
                oItem = OBJECT_INVALID;
            }

            if (GetIsObjectValid(oItem) && GetPlotFlag(oItem) == FALSE)
            {
                //Set the save DC and adjust if oItem is a magic item
                int nDC = 17;
                if (Q_IPGetIsMagicItem(oItem))
                {
                    int nMod = 2 + Q_IPGetItemLevel(oItem)/2;
                    nDC = nDC - nMod;
                }

                //Make a Reflex Save check
                if (!MySavingThrow(SAVING_THROW_REFLEX, oAttacker, nDC, SAVING_THROW_TYPE_NONE))
                {
                    DestroyObject(oItem);
                    FloatingTextStringOnCreature("Your weapon has been destroyed!", oAttacker, FALSE);
                }
            }
        }
    }
}
