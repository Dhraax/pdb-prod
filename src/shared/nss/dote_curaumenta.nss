//::///////////////////////////////////////////////
//:: spellsCure
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Used by the 'cure' series of spells.
    Will do max heal/damage if at normal or low
    difficulty.
    Random rolls occur at higher difficulties.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

#include "nw_i0_spells"
#include "pb_nivellanzador"
#include "colors_inc"

void ConjuroCuracion(int nDamage, int nMaxExtraDamage, int nMaximized, int vfx_impactHurt, int vfx_impactHeal, int nSpellID)
{
    //Declare major variables
    object oTarget = GetSpellTargetObject();
    int nHeal;
    int nMetaMagic = GetSpellCastItem()==OBJECT_INVALID?GetMetaMagicFeat():METAMAGIC_NONE;
    effect eHeal, eDam;

    int nExtraDamage = GetTotalCasterLevel(OBJECT_SELF); // * figure out the bonus damage
    if (nExtraDamage > nMaxExtraDamage)
    {
        nExtraDamage = nMaxExtraDamage;
    }

    nDamage = nDamage + nExtraDamage;

    //Make metamagic checks
    if (nMetaMagic == METAMAGIC_MAXIMIZE)
    {
        // 04/06/2005 CraigW - We should be using the maximized value here instead of 8.
        nDamage = nMaximized + nExtraDamage;
    }
    if (nMetaMagic == METAMAGIC_EMPOWER || GetHasFeat(FEAT_HEALING_DOMAIN_POWER))
    {
        if(GetHasFeat(FEAT_HEALING_DOMAIN_POWER)) SendMessageToPC(OBJECT_SELF,  ColorToken(254,254,254) + "Dominio de Curación: +"+IntToString(nDamage/2)+" pg.</c>");

        nDamage = nDamage + (nDamage/2);
    }
    if(GetHasFeat(1121) == TRUE) // Curacion aumentada
    {
        int iNivelInnato = StringToInt(Get2DAString("spells", "Innate", nSpellID));

        nDamage = nDamage + ( iNivelInnato * 2);

        SendMessageToPC(OBJECT_SELF,  ColorToken(254,254,254) + "Curación aumentada: +"+IntToString(iNivelInnato * 2)+" pg.</c>");
    }

    if (!PB_Race_GetIsUndead(oTarget))
    {
        //Figure out the amount of damage to heal
        //nHeal = nDamage;  -- this line seemed kinda pointless
        //Set the heal effect
        eHeal = EffectHeal(nDamage);
        //Apply heal effect and VFX impact
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
        effect eVis2 = EffectVisualEffect(vfx_impactHeal);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpellID, FALSE));


    }
    //Check that the target is undead
    else
    {
        int nTouch = TouchAttackMelee(oTarget);
        if (nTouch > 0)
        {
            if(!GetIsReactionTypeFriendly(oTarget))
            {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpellID));
                if (!MyResistSpell(OBJECT_SELF, oTarget))
                {
                    eDam = EffectDamage(nDamage,DAMAGE_TYPE_POSITIVE);
                    //Apply the VFX impact and effects
                    DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                    effect eVis = EffectVisualEffect(vfx_impactHurt);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                }
            }
        }
    }
}
