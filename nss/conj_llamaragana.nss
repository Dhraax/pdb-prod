//::///////////////////////////////////////////////
//:: LLAMARADA DE AGANAZAAR
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Llamarada de Aganazaar.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 31 de Mayo de 2010
//:://////////////////////////////////////////////

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "pb_nivellanzador"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);
  /*
    Spellcast Hook Code
    Added 2003-07-07 by Georg Zoeller
    If you want to make changes to all spells,
    check x2_inc_spellhook.nss to find out more
  */

  if (!X2PreSpellCastCode())
  {
      // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
      return;
  }

  // End of Spell Cast Hook

  object oCaster = OBJECT_SELF;

  //Declare major variables
  int nCasterLevel = GetTotalCasterLevel(oCaster);
  //Limit caster level
  if (nCasterLevel > 10)
  {
      nCasterLevel = 10;
  }

  int nDamage;
  int nMetaMagic = GetSpellCastItem()==OBJECT_INVALID?GetMetaMagicFeat():METAMAGIC_NONE;
  //Set the lightning stream to start at the caster's hands
  effect eLightning = EffectBeam(VFX_BEAM_FIRE, oCaster, BODY_NODE_HAND);
  effect eVis  = EffectVisualEffect(VFX_COM_HIT_FIRE);
  effect eDamage;
  object oTarget = GetSpellTargetObject();
  location lTarget = GetLocation(oTarget);
  object oNextTarget, oTarget2;
  float fDelay;
  int nCnt = 1;

  oTarget2 = GetNearestObject(OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, oCaster, nCnt);
  while(GetIsObjectValid(oTarget2) && GetDistanceToObject(oTarget2) <= 30.0)
  {
      //Get first target in the lightning area by passing in the location of first target and the casters vector (position)
      oTarget = GetFirstObjectInShape(SHAPE_SPELLCYLINDER, 30.0, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, GetPosition(oCaster));
      while (GetIsObjectValid(oTarget))
      {
          //Exclude the caster from the damage effects
          if(oTarget != oCaster && oTarget2 == oTarget)
          {
              if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
              {
                  //Fire cast spell at event for the specified target
                  SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId()));
                  //Make an SR check
                  if (!MyResistSpell(oCaster, oTarget))
                  {
                      //Roll damage
                      nDamage =  d8(nCasterLevel / 2);
                      //Enter Metamagic conditions
                      if(nMetaMagic == METAMAGIC_MAXIMIZE)
                      {
                          nDamage = 8 * (nCasterLevel / 2);//Damage is at max
                      }

                      if(nMetaMagic == METAMAGIC_EMPOWER)
                      {
                          nDamage = nDamage + (nDamage / 2); //Damage/Healing is +50%
                      }

                      //Adjust damage based on Reflex Save, Evasion and Improved Evasion
                      nDamage = GetReflexAdjustedDamage(nDamage, oTarget, (GetSpellSaveDC()+ GetChangesToSaveDC(OBJECT_SELF)),SAVING_THROW_TYPE_FIRE);
                      //Set damage effect
                      eDamage = EffectDamage(nDamage, ChangedElementalDamage(OBJECT_SELF, DAMAGE_TYPE_FIRE));
                      if(nDamage > 0)
                      {
                          fDelay = GetSpellEffectDelay(GetLocation(oTarget), oTarget);
                          //Apply VFX impcat, damage effect and lightning effect
                          DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oTarget));
                          DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget));
                      }
                  }

                  ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLightning,oTarget,1.0);
                  //Set the currect target as the holder of the lightning effect
                  oNextTarget = oTarget;
                  eLightning = EffectBeam(VFX_BEAM_FIRE, oNextTarget, BODY_NODE_CHEST);
              }
          }

          //Get the next object in the lightning cylinder
          oTarget = GetNextObjectInShape(SHAPE_SPELLCYLINDER, 30.0, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, GetPosition(oCaster));
      }

      nCnt++;
      oTarget2 = GetNearestObject(OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, oCaster, nCnt);
      DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
  }
}

