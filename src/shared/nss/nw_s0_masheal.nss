//::///////////////////////////////////////////////
//:: Mass Heal
//:: [NW_S0_MasHeal.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Heals all friendly targets within 10ft to full
//:: unless they are undead.
//:: If undead they reduced to 1d4 HP.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 11, 2001
//:://////////////////////////////////////////////

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
  effect eKill;
  effect eVis = EffectVisualEffect(VFX_IMP_SUNSTRIKE);
  effect eHeal;
  effect eVis2 = EffectVisualEffect(VFX_IMP_HEALING_G);
  effect eStrike = EffectVisualEffect(VFX_FNF_LOS_HOLY_10);
  int nCasterLevel = GetTotalCasterLevel(OBJECT_SELF);
  int nTouch, nDamage, nHeal;
  int iNivelInnato = 0;
  int nMetaMagic = GetSpellCastItem()==OBJECT_INVALID?GetMetaMagicFeat():METAMAGIC_NONE;
  float fDelay;
  location lLoc =  GetSpellTargetLocation();

  //arreglando estropicio
  if(nCasterLevel > 25) nCasterLevel = 25;

  //Apply VFX area impact
  ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eStrike, lLoc);
  //Get first target in spell area
  object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lLoc);
  while(GetIsObjectValid(oTarget))
  {
      fDelay = GetRandomDelay();
      //Check to see if the target is an undead
      if (PB_Race_GetIsUndead(oTarget) && !GetIsReactionTypeFriendly(oTarget))
      {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_MASS_HEAL));
            //Make a touch attack
            //nTouch = TouchAttackRanged(oTarget);
            //if (nTouch > 0)
            //{
                if(!GetIsReactionTypeFriendly(oTarget))
                {
                    //Make an SR check
                    if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
                    {
                        /*//MONTI, D&D 3.5
                        nDamage = nCasterLevel * 10;

                        if(GetHasFeat(1121) == TRUE) // Curacion aumentada
                        {
                            int iNivelInnato = StringToInt(Get2DAString("spells", "Innate", GetSpellId()));

                            nDamage = nDamage + ( iNivelInnato * 2);

                            SendMessageToPC(OBJECT_SELF, ColorToken(254,254,254) + "Curación aumentada: +"+IntToString(iNivelInnato * 2)+" pg.</c>");
                        }

                        if(nDamage > 250) nDamage = 250; */
                        nDamage = nCasterLevel * 10;

                        if(WillSave(oTarget, (GetSpellSaveDC()+ GetChangesToSaveDC(OBJECT_SELF)), SAVING_THROW_TYPE_POSITIVE))
                        {
                            nDamage = nDamage/2;
                        }
                        if(GetCurrentHitPoints(oTarget) <= nDamage)
                        {
                            //Check for metamagic
                            if(nMetaMagic == METAMAGIC_MAXIMIZE) nDamage = GetCurrentHitPoints(oTarget) - 1;
                            else nDamage = GetCurrentHitPoints(oTarget) - 1;
                        }

                        //Set the damage effect
                        eKill = EffectDamage(nDamage, DAMAGE_TYPE_POSITIVE);
                        //Apply the VFX impact and damage effect
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eKill, oTarget));
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                    }
                 }
            //}
      }
      else
      {
            if(GetLocalInt(oTarget, "dm_nocurar") != 1)
            {
                //Make a faction check
                if(GetIsFriend(oTarget) && !PB_Race_GetIsUndead(oTarget))
                {
                    //Fire cast spell at event for the specified target
                    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_MASS_HEAL, FALSE));

                    //Figure out how much to heal
                    if(GetHasFeat(1121) == TRUE)      // Curacion aumentada
                    {
                       int iNivelInnato = StringToInt(Get2DAString("spells", "Innate", GetSpellId()));
                       SendMessageToPC(OBJECT_SELF, ColorToken(254,254,254) + "Curación aumentada: +"+IntToString(iNivelInnato * 2)+" pg.</c>");
                    }

                    //MONTI D&D 3.5
                    nHeal = (nCasterLevel * 10) + (iNivelInnato * 2);
                    //if(nHeal > 250) nHeal = 250;

                    //Set the damage effect
                    eHeal = EffectHeal(nHeal);
                    //Apply the VFX impact and heal effect
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget));

                    effect eBad = GetFirstEffect(oTarget);
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
          }
      }
      //Get next target in the spell area
      oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lLoc);

   }
   DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
int GetIsSupernaturalCurse(effect eEff)
{
    object oCreator = GetEffectCreator(eEff);
    if(GetTag(oCreator) == "q6e_ShaorisFellTemple")
        return TRUE;
    return FALSE;
}
