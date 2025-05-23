//::///////////////////////////////////////////////
//:: Default: On User Defined
//:: NW_C2_DEFAULTD
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Determines the course of action to be taken
    on a user defined event.
*/
//:://////////////////////////////////////////////
//:: Created By: Don Moar
//:: Created On: April 28, 2002
//:://////////////////////////////////////////////

#include "nw_i0_generic"
#include "inc_sqlite_time"

// Función utilizada para añadir munición a una criatura
void AddRecoverableItem(object oItem) {
    object oCopy = CopyItem(oItem, OBJECT_SELF, TRUE);
    int oSize = GetItemStackSize(oItem);
    int tSize = GetItemStackSize(oCopy);

    // Calcular la cantidad de flechas que debería tener la criatura en el inventario y añadir 1
    SetItemStackSize(oCopy, tSize - oSize + 1);
    SetDroppableFlag(oCopy, TRUE);
    return;
}

// Función utilizada para controlar la recuperación de munición
void HandleAmmoRecovery(object oAttacker, object oWeapon) {
    int iWeapType = GetBaseItemType(oWeapon);
    int recoveryChance = FALSE, iRecoverable = FALSE;
    int iSlot = FALSE;

    // Detectar el hueco de munición utilizado por la arma y ajustar la probabilidad de recuperación
    switch (iWeapType) {
        case BASE_ITEM_LONGBOW:
        case BASE_ITEM_SHORTBOW:
            iSlot = INVENTORY_SLOT_ARROWS;
            recoveryChance = 25;
            break;

        case BASE_ITEM_LIGHTCROSSBOW:
        case BASE_ITEM_HEAVYCROSSBOW:
            iSlot = INVENTORY_SLOT_BOLTS;
            recoveryChance = 35;
            break;

        case BASE_ITEM_SLING:
            iSlot = INVENTORY_SLOT_BULLETS;
            recoveryChance = 35;
            break;

        case BASE_ITEM_THROWINGAXE:
            iSlot = INVENTORY_SLOT_RIGHTHAND;
            recoveryChance = 60;
            break;

        case BASE_ITEM_SHURIKEN:
            iSlot = INVENTORY_SLOT_RIGHTHAND;
            recoveryChance = 35;
            break;

        case BASE_ITEM_DART:
            iSlot = INVENTORY_SLOT_RIGHTHAND;
            recoveryChance = 35;
            break;
    }

    // Si el objeto no tiene la propiedad de munición infinita y supera un dado, marcar munición como recuperable
    if (iSlot && recoveryChance && !GetItemHasItemProperty(oWeapon, ITEM_PROPERTY_UNLIMITED_AMMUNITION) && d100() <= recoveryChance) iRecoverable = TRUE;

    // Si la munición debería ser recuperada, añadirla al inventario de la criatura
    if (iRecoverable) {
        AddRecoverableItem(GetItemInSlot(iSlot, oAttacker));
    }

}

void main()
{
    // enter desired behaviour here
    object oTarget;
    object oFriend;
    int nFriend;
    int nTime;
    float fDistance;
    float fDistanceToTarget;
    int bAggressive;
    switch (GetUserDefinedEventNumber()) {
        case EVENT_HEARTBEAT:
            fDistance = GetLocalFloat(OBJECT_SELF, "ANIMAL_MINDIST_HOSTILE");
            if(fDistance == 0.0 || !GetBehaviorState(NW_FLAG_BEHAVIOR_SPECIAL) || GetBehaviorState(NW_FLAG_BEHAVIOR_HERBIVORE) || GetIsInCombat(OBJECT_SELF) || IsInConversation(OBJECT_SELF))
                break;
            oTarget = GetNearestSeenEnemy();
            if(oTarget == OBJECT_INVALID || !GetIsPC(oTarget))
                break;
            if(fDistance == 25.0 && GetLocalInt(OBJECT_SELF, "ANIMAL_MINDIST_TIME") < SQLite_GetTimeStamp()) {
                fDistance = 15.0;
                SetLocalFloat(OBJECT_SELF, "ANIMAL_MINDIST_HOSTILE", 15.0);
            }
            if(GetLevelByClass(CLASS_TYPE_DRUID, oTarget) > 0 || GetLevelByClass(CLASS_TYPE_RANGER, oTarget) > 0) {
                if(GetBehaviorState(NW_FLAG_BEHAVIOR_OMNIVORE))
                    fDistance -= 1.5;
                else if(GetBehaviorState(NW_FLAG_BEHAVIOR_CARNIVORE))
                    fDistance -= 2.5;
            }
            fDistanceToTarget = GetDistanceToObject(oTarget);
            //FloatingTextStringOnCreature(GetName(OBJECT_SELF) + " - HB Dist: " + FloatToString(fDistanceToTarget) + " / " + FloatToString(fDistance), oTarget, TRUE);
            if(fDistanceToTarget <= fDistance) {
                SetIsTemporaryEnemy(oTarget, OBJECT_SELF, FALSE, 20.0);
                DetermineCombatRound(oTarget);
                nTime = SQLite_GetTimeStamp();
                SetLocalFloat(OBJECT_SELF, "ANIMAL_MINDIST_HOSTILE", 25.0);
                SetLocalInt(OBJECT_SELF, "ANIMAL_MINDIST_TIME", nTime+30);
                oFriend = GetNearestSeenFriend(OBJECT_SELF, 1);
                nFriend = 1;
                while(oFriend!=OBJECT_INVALID && nFriend <= 5) {
                    SetLocalFloat(oFriend, "ANIMAL_MINDIST_HOSTILE", 25.0);
                    SetLocalInt(oFriend, "ANIMAL_MINDIST_TIME", nTime+30);
                    SetIsTemporaryEnemy(oTarget, oFriend, FALSE, 20.0);
                    nFriend++;
                    oFriend = GetNearestSeenFriend(OBJECT_SELF, nFriend);
                }
            } else if(fDistance > 0.0 && fDistanceToTarget <= fDistance+3) {
                //ActionDoCommand(SpeakString("*Ruge amenazadoramente*"));
                PlayVoiceChat(VOICE_CHAT_GATTACK1);
                SetFacingPoint(GetPosition(oTarget));
            } else if(fDistanceToTarget <= fDistance+5.7) {
                SetFacingPoint(GetPosition(oTarget));
            }
            break;
        case EVENT_ATTACKED:
            object oAttacker = GetLastAttacker();
            object oWeapon = GetLastWeaponUsed(oAttacker);
            if (GetIsPC(oAttacker) && GetWeaponRanged(oWeapon)) {
            HandleAmmoRecovery(oAttacker, oWeapon);
            }

            if(!GetBehaviorState(NW_FLAG_BEHAVIOR_SPECIAL) || GetBehaviorState(NW_FLAG_BEHAVIOR_HERBIVORE))
                break;
            //oTarget = GetNearestSeenEnemy();
            oTarget = GetLastDamager();
            if(oTarget == OBJECT_INVALID)
                break;
            //SetIsTemporaryEnemy(oTarget, OBJECT_SELF, FALSE, 20.0);
            //DetermineCombatRound(oTarget);
            nTime = SQLite_GetTimeStamp();
            if(nTime<GetLocalInt(OBJECT_SELF, "ANIMAL_MINDIST_TIME")-18)
                break;
            SetLocalFloat(OBJECT_SELF, "ANIMAL_MINDIST_HOSTILE", 25.0);
            SetLocalInt(OBJECT_SELF, "ANIMAL_MINDIST_TIME", nTime+30);
            oFriend = GetNearestSeenFriend(OBJECT_SELF, 1);
            nFriend = 1;
            while(oFriend!=OBJECT_INVALID && nFriend <= 5) {
                SetLocalFloat(oFriend, "ANIMAL_MINDIST_HOSTILE", 25.0);
                SetLocalInt(oFriend, "ANIMAL_MINDIST_TIME", nTime+30);
                SetIsTemporaryEnemy(oTarget, oFriend, FALSE, 20.0);
                nFriend++;
                oFriend = GetNearestSeenFriend(OBJECT_SELF, nFriend);
            }
            break;
    }
    return;

}
