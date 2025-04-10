// Project Q Healer's Kit
//:://////////////////////////////////////////////

#include "lib_race"

int GetIsLivingCreature(object oTarget)
{
    int nRace = GetRacialType(oTarget);
    int bValid = TRUE;

    switch (nRace)
    {
        case RACIAL_TYPE_CONSTRUCT:
        case RACIAL_TYPE_ELEMENTAL:
            bValid = FALSE;
        break;
    }

    if (PB_Race_GetIsUndead(oTarget)) bValid = FALSE;

    return bValid;
}


void main()
{
    object oItem = GetSpellCastItem();
    object oCaster = GetItemPossessor(oItem);
    object oTarget = GetSpellTargetObject();
    int nCharges = GetItemCharges(oItem);

    // pnp DC = 15, but healer's kits provide a +2 bonus - thus the DC is set to 13
    int nDC = 13;

    if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE && GetIsLivingCreature(oTarget) == TRUE)
    {
        effect eVis = EffectVisualEffect(VFX_IMP_HEALING_S);
        effect eLink;

        // target is dead - abort
        if (GetCurrentHitPoints(oTarget) <= -10)
        {
            nCharges ++;
            SetItemCharges(oItem, nCharges);

            SendMessageToPC(oCaster, "This creature is beyond your help.");
        }
        // target is dying - stop bleeding
        else if (GetCurrentHitPoints(oTarget) <= 0)
        {
            effect eHeal = EffectHeal(1);
            eLink = EffectLinkEffects(eVis, eHeal);

            if (GetIsSkillSuccessful(oCaster, SKILL_HEAL, nDC))
            {
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
                SendMessageToPC(oCaster, "Success: the target's wounds have been stabilized.");
            }
            else
            {
                //visual feedback that something happened
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FORTITUDE_SAVING_THROW_USE), oTarget);
                SendMessageToPC(oCaster, "Failure: you were unable to stabilize the target's wounds.");
            }
        }
        // target is alive and not dying - apply +2 save bonus vs. disease and poison for next 24 hours
        else
        {
            effect eSave1 = EffectSavingThrowIncrease(SAVING_THROW_FORT, 2, SAVING_THROW_TYPE_DISEASE);
            effect eSave2 = EffectSavingThrowIncrease(SAVING_THROW_FORT, 2, SAVING_THROW_TYPE_POISON);
            eLink = EffectLinkEffects(eSave1, eSave2);

            //* hotfix - prevent stacking
            if (!GetHasSpellEffect(840, oTarget))
            {
                if (GetIsSkillSuccessful(oCaster, SKILL_HEAL, nDC))
                {
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(24));
                    SendMessageToPC(oCaster, "Success: you have bolstered the target's fortitude.");
                }
                else
                {
                    //visual feedback that something happened
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_FORTITUDE_SAVING_THROW_USE), oTarget);
                    SendMessageToPC(oCaster, "Failure: you were unable to bolster the target's fortitude.");
                }
            }
            else //Fort already bolstered
            {
                nCharges ++;
                SetItemCharges(oItem, nCharges);

                if (oTarget == oCaster)
                {
                    SendMessageToPC(oCaster, "You have already bolstered your fortitude.");
                }
                else
                {
                    SendMessageToPC(oCaster, "You have already bolstered the target's fortitude.");
                }
            }
        }
    }
    else
    {
        SendMessageToPC(oCaster, "You may only use healing kits on living creatures.");
    }
}
