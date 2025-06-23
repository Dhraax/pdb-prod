//::///////////////////////////////////////////////
//:: Heal
//:: [NW_S0_Heal.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Heals the target to full unless they are undead.
//:: If undead they reduced to 1d4 HP.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 12, 2001
//:://////////////////////////////////////////////
//:: Update Pass By: Preston W, On: Aug 1, 2001

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"
#include "colors_inc"
//#include "mti_libreria"

// return TRUE if the effect created by a supernatural force and can't be dispelled by spells
int GetIsSupernaturalCurse(effect eEff);

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);
/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

  //Declare major variables
  object oTarget = GetSpellTargetObject();
  effect eKill, eHeal;
  int nCasterLevel = GetTotalCasterLevel(OBJECT_SELF);
  int nDamage, nHeal, nMetaMagic, nTouch;
  int nNivelConjuro = 0;
  effect eSun = EffectVisualEffect(VFX_IMP_SUNSTRIKE);
  effect eHealVis = EffectVisualEffect(VFX_IMP_HEALING_X);
  int bValid;
  effect eBad = GetFirstEffect(oTarget);

//arreglando estropicio
    if(nCasterLevel > 15) nCasterLevel = 15;

    if(GetHasFeat(1121) == TRUE)      // Curacion aumentada
       {
          nNivelConjuro = 6;

          if ((GetLevelByClass(CLASS_TYPE_DRUID , OBJECT_SELF)) > 0 )
          nNivelConjuro = 7;
          SendMessageToPC(OBJECT_SELF, ColorToken(254,254,254) + "Sanar aumentado: +"+IntToString(nNivelConjuro * 2)+" pg.</c>");
       }
    nHeal = (nCasterLevel * 10) + (nNivelConjuro * 2);
    nDamage = nHeal;

    //Check to see if the target is an undead
    if (PB_Race_GetIsUndead(oTarget))
    {
        if(!GetIsReactionTypeFriendly(oTarget))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HEAL));
            //Make a touch attack
            int nTouch = TouchAttackMelee(oTarget);
            if (oTarget == GetLastSpellCaster() || nTouch > 0 )
            {
                //Make SR check
                if (!MyResistSpell(OBJECT_SELF, oTarget))
                {
                    /*//MONTI, D&D 3.5
                    nDamage = nCasterLevel * 10;

                    if(GetHasFeat(1121) == TRUE) // Curacion aumentada
                    {
                        int iNivelInnato = StringToInt(Get2DAString("spells", "Innate", GetSpellId()));

                        nDamage = nDamage + ( iNivelInnato * 2);

                        SendMessageToPC(OBJECT_SELF, ColorToken(254,254,254) + "Curación aumentada: +"+IntToString(iNivelInnato * 2)+" pg.</c>");
                    }

                    if(nDamage > 150) nDamage = 150;  */
                    if(nTouch == 2)
                      {
                        nDamage *= 2;
                      }
                    if(WillSave(oTarget, (GetSpellSaveDC()+ GetChangesToSaveDC(OBJECT_SELF)), SAVING_THROW_TYPE_POSITIVE))
                    {
                        nDamage = nDamage/2;
                    }
                    if(GetCurrentHitPoints(oTarget) <= nDamage)
                    {
                        /*//Check for metamagic
                        nMetaMagic = GetSpellCastItem()==OBJECT_INVALID?GetMetaMagicFeat():METAMAGIC_NONE;
                        if(nMetaMagic == METAMAGIC_MAXIMIZE) nDamage = GetCurrentHitPoints(oTarget) - 1;
                        else*/
                        nDamage = GetCurrentHitPoints(oTarget) - 1;
                    }

                    //Set damage
                    eKill = EffectDamage(nDamage, DAMAGE_TYPE_POSITIVE);
                    //Apply damage effect and VFX impact
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eKill, oTarget);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eSun, oTarget);
                }
            }
        }
    }
    else
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HEAL, FALSE));
        if(GetLocalInt(oTarget, "dm_nocurar") != 1)
        {
            /*//Figure out how much to heal
            //MONTI D&D 3.5
            nHeal = nCasterLevel * 10;
            if(nHeal > 150) nHeal = 150;*/

            //Set the heal effect
            eHeal = EffectHeal(nHeal);

            //Apply the heal effect and the VFX impact
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eHealVis, oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);


            //Search for negative effects
            while(GetIsEffectValid(eBad))
            {
                int nSubType = GetEffectSubType(eBad);
                if (GetEffectType(eBad) == EFFECT_TYPE_ABILITY_DECREASE ||
                    GetEffectType(eBad) == EFFECT_TYPE_ATTACK_DECREASE ||
                    GetEffectType(eBad) == EFFECT_TYPE_DAMAGE_DECREASE ||
                    GetEffectType(eBad) == EFFECT_TYPE_SKILL_DECREASE ||
                    GetEffectType(eBad) == EFFECT_TYPE_BLINDNESS ||
                    GetEffectType(eBad) == EFFECT_TYPE_DEAF ||
                    GetEffectType(eBad) == EFFECT_TYPE_DISEASE ||
                    GetEffectType(eBad) == EFFECT_TYPE_POISON ||
                    GetEffectType(eBad) == EFFECT_TYPE_DAZED ||
                    GetEffectType(eBad) == EFFECT_TYPE_CONFUSED ||
                    GetEffectType(eBad) == EFFECT_TYPE_FRIGHTENED ||
                    GetEffectType(eBad) == EFFECT_TYPE_SLOW ||
                    GetEffectType(eBad) == EFFECT_TYPE_STUNNED)
                {
                    //Remove effect if it is negative.
                    if(!GetIsSupernaturalCurse(eBad)
                        && nSubType != SUBTYPE_EXTRAORDINARY
                        && nSubType != SUBTYPE_UNYIELDING)
                    {
                        RemoveEffect(oTarget, eBad);
                    }
                }
                eBad = GetNextEffect(oTarget);
            }
            // APLICAMOS LOS EFECTOS DE LAS SUBRAZAS, MONTURAS Y ARMADURAS
            //ReaplicarEfectosPB(oTarget);
        }
        DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    }
}
int GetIsSupernaturalCurse(effect eEff)
{
    object oCreator = GetEffectCreator(eEff);
    if(GetTag(oCreator) == "q6e_ShaorisFellTemple")
        return TRUE;
    return FALSE;
}
