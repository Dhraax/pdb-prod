//  ----------------------------------------------------------------------------
//  hc_act_healkit
//  ----------------------------------------------------------------------------
/*
    Hardcore Heal Kits & Heal Ability

    OnActivate event script for HCR Heal Kits and Heal Ability
*/
//  ----------------------------------------------------------------------------
/*
    HCR 3.02
    - rewritten for HCR 3.02

    Credits:
    - Archaegeo
*/
//  ----------------------------------------------------------------------------
#include "hc_inc"
#include "hc_inc_timecheck"
#include "hc_text_bleed"


//  ----------------------------------------------------------------------------
//  CONSTANTS
//  ----------------------------------------------------------------------------

// DC to stop healing
const int HC_HEAL_DC = 15;

// name of the attribute holding the time of the player's last recovery check
const string HC_VAR_BLEED_RECOVERY_CHECK    = "LastRecCheck";


//  ----------------------------------------------------------------------------
//  MAIN
//  ----------------------------------------------------------------------------

void main()
{

    object oUser = OBJECT_SELF;
    object oItem = GetLocalObject(oUser, "ITEM");
    object oOther = GetLocalObject(oUser, "OTHER");

    DeleteLocalObject(oUser, "ITEM");
    DeleteLocalObject(oUser, "OTHER");

    // check the user is close enough to the target
    if (GetDistanceToObject(oOther) > FeetToMeters(8.0))
    {
        SendMessageToPC(oUser, "Necesitas acercarte más.");
        SetItemCharges(oItem, GetItemCharges(oItem) + 1);
        return;
    }

    int bHealing;
    int nHealSkill = GetSkillRank(SKILL_HEAL, oUser);

    int nModifier = 2;
    // no modifier if using heal ability rather than a heal kit
    if(GetResRef(oItem) == "healability") nModifier = 0;

    // -------------------------------------------------------------------------
    // Part 1: if target is bleeding attempt to stop the bleeding.
    // -------------------------------------------------------------------------

    int nState = GPS(oOther);
    if(nState == PWS_PLAYER_STATE_DYING || nState == PWS_PLAYER_STATE_STABLE)
    {
        // skill check
        if(d20(1) + nHealSkill + nModifier > HC_HEAL_DC)
        {
            // passed: target enters recovery
            HC_SetPersistantAttribute(oOther, HC_VAR_BLEED_RECOVERY_CHECK, SecondsSinceBegin());
            SendMessageToPC(oOther, HC_TEXT_BLEED_NOW_RECOVERING);
            SPS(oOther, PWS_PLAYER_STATE_RECOVERING);
            SendMessageToPC(oUser, "Has parado satisfactoriamente la hemorragia.");
        }
        else
        {
            // failed: inform user
            SendMessageToPC(oUser, "No has conseguido parar la hemorragia.");
        }

        // make user work on the target
        DelayCommand(1.0, AssignCommand(oUser, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 2.0)));

        // raise a flag to show that healing was attempted
        bHealing = TRUE;

        // only one heal/cure per attempt
        return;
    }

    // -------------------------------------------------------------------------
    // Part 2: if the target is poisoned or diseased attempt to cure them.
    // -------------------------------------------------------------------------

    effect eBad = GetFirstEffect(oOther);
    while(GetIsEffectValid(eBad))
    {
        int nBad = GetEffectType(eBad);
        if(nBad == EFFECT_TYPE_POISON || nBad == EFFECT_TYPE_DISEASE)
        {
            // TEMPORARY: Generate random DC from 12-22.  This will be replaced
            // by specific poison/disease DC once we figure out how to determine
            // what type of poison or disease is afflicting the PC.
            int nCureDC = d6(2) + 10;

            // skill check
            if(d20(1) + nHealSkill + nModifier > nCureDC)
            {
                // passed: apply VFX and remove poison/disease
                effect eVis = EffectVisualEffect(VFX_IMP_REMOVE_CONDITION);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oOther);
                RemoveEffect(oOther, eBad);
            }
            else
            {
                // failed: inform user
                SendMessageToPC(oUser, "Tu tratamiento falló.");
            }

            // make user work on the target
            DelayCommand(1.0, AssignCommand(oUser, ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, 2.0)));

            // raise a flag to show that healing was attempted
            bHealing = TRUE;

            // only one heal/cure per attempt
            return;
        }
        eBad=GetNextEffect(oOther);
    }

    // -------------------------------------------------------------------------
    // Part 3: nothing to heal/cure
    // -------------------------------------------------------------------------

    if(bHealing == FALSE)
    {
        // nothing to heal or cure so add back a charge
        SetItemCharges(oItem, GetItemCharges(oItem) + 1);
    }
}

