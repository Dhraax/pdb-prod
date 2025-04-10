//::///////////////////////////////////////////////
//:: Lay_On_Hands
//:: NW_S2_LayOnHand.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The Paladin is able to heal his Chr Bonus times
    his level.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 15, 2001
//:: Updated On: Oct 20, 2003
//:://////////////////////////////////////////////

#include "NW_I0_SPELLS"
#include "pb_constantes"
void main()
{

    object oTarget = GetSpellTargetObject();
    int nChr = GetAbilityModifier(ABILITY_CHARISMA);
    if (nChr < 0)
    {
        nChr = 0;
    }
    //Modificación de El_Vara, 04/10/2024: Ahora recoge los niveles de la clase que ha usado para castear la dote. (Se supone que la dote solo la tiene habilitada clases que así se desea).
    int iClassPrincipal;
    int iClassSecundario;
    int nLevel;
    int nSR = GetSpellResistance(oTarget);

    //--------------------------------------------------------------------------
    // July 2003: Add Divine Champion levels to lay on hands ability
    //--------------------------------------------------------------------------
    //Solo tiene en cuenta una de las clases de paladín.
    if(GetLevelByClass(CLASS_TYPE_PALADIN,OBJECT_SELF) > 0) { iClassPrincipal = GetLevelByClass(CLASS_TYPE_PALADIN,OBJECT_SELF); }
    else if(GetLevelByClass(CLASS_TYPE_PAL_ANTIGUO,OBJECT_SELF) > 0) { iClassPrincipal = GetLevelByClass(CLASS_TYPE_PAL_ANTIGUO,OBJECT_SELF); }
    else if(GetLevelByClass(CLASS_TYPE_PAL_OSCURO,OBJECT_SELF) > 0) { iClassPrincipal = GetLevelByClass(CLASS_TYPE_PAL_OSCURO,OBJECT_SELF); }
    else if(GetLevelByClass(CLASS_TYPE_PAL_VENGADOR,OBJECT_SELF) > 0) { iClassPrincipal = GetLevelByClass(CLASS_TYPE_PAL_VENGADOR,OBJECT_SELF); }
    //Y se puede combinar con el Campeón Divino.
    if(GetLevelByClass(CLASS_TYPE_DIVINECHAMPION,OBJECT_SELF) > 0) { iClassSecundario = GetLevelByClass(CLASS_TYPE_DIVINECHAMPION,OBJECT_SELF); }

    nLevel = iClassPrincipal + iClassSecundario;

    //--------------------------------------------------------------------------
    // Caluclate the amount to heal, min is 1 hp
    //--------------------------------------------------------------------------
    int nHeal = nLevel * nChr;
    if(nHeal < 0)
    {
        nHeal = 0;
    }
    effect eHeal = EffectHeal(nHeal);
    effect eVis = EffectVisualEffect(VFX_IMP_HEALING_M);
    effect eVis2 = EffectVisualEffect(VFX_IMP_SUNSTRIKE);
    effect eDam;
    int nTouch;

    //--------------------------------------------------------------------------
    // A paladine can use his lay on hands ability to damage undead creatures
    // having undead class levels qualifies as undead as well
    //--------------------------------------------------------------------------
    if(PB_Race_GetIsUndead(oTarget) || GetLevelByClass(CLASS_TYPE_UNDEAD,oTarget)>0)
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_LAY_ON_HANDS));
        //Make a ranged touch attack
        nTouch = TouchAttackMelee(oTarget,TRUE);

        //----------------------------------------------------------------------
        // GZ: The PhB classifies Lay on Hands as spell like ability, so it is
        //     subject to SR. No more cheesy demi lich kills on touch, sorry.
        //----------------------------------------------------------------------
     /* int nResist = MyResistSpell(OBJECT_SELF,oTarget);
        if (nResist == 0 ) */

            if(nTouch > 0)
            {
                if(nTouch == 2)
                {
                    nHeal *= 2;
                }

                if(nLevel + d20(1) > nSR)
                {
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_LAY_ON_HANDS));
                eDam = EffectDamage(nHeal, DAMAGE_TYPE_DIVINE);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
                return;
                }
                else
                {
                   effect eSR = EffectVisualEffect(VFX_IMP_MAGIC_RESISTANCE_USE);
                   DelayCommand(0.3, ApplyEffectToObject(DURATION_TYPE_INSTANT, eSR, oTarget));
                   SendMessageToPC(OBJECT_SELF,"*Tu imposición ha sido resistida!*");
                   return;
                }
            }


    }
    if (GetRacialType(oTarget) == RACIAL_TYPE_CONSTRUCT || GetHasSpellEffect(996,oTarget) == TRUE)
    {
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_LAY_ON_HANDS, FALSE));
        SendMessageToPC(OBJECT_SELF,"*Los constructos no pueden recibir curaciones!*");
        return;
    }
    else
    {
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_LAY_ON_HANDS, FALSE));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    }

}

