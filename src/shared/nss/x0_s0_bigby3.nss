//::///////////////////////////////////////////////
//:: Bigby's Grasping Hand
//:: [x0_s0_bigby3]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Apresa.
    make an attack roll. If succesful target is held for 1 round/level
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: September 7, 2002
//:://////////////////////////////////////////////

#include "x0_i0_spells"
#include "x2_inc_spellhook"
#include "x2_i0_spells"
#include "mti_libreria"
#include "pb_nivellanzador"
#include "colors_inc"
#include "pb_constantes"

int BonificadorPresa(object oCriatura)
{
  int iBonificadorEmbestida;
  int iTamanyoCriatura = GetCreatureSize(oCriatura);

  switch(iTamanyoCriatura)
  {
      case 21: iBonificadorEmbestida -=16;  break;
      case 20: iBonificadorEmbestida -=12;  break;
      case 1:  iBonificadorEmbestida -=8;  break;
      case 2:  iBonificadorEmbestida -=4;  break;
      case 4:  iBonificadorEmbestida +=4; break;
      case 5:  iBonificadorEmbestida +=8; break;
      case 22: iBonificadorEmbestida +=12; break;
      case 23: iBonificadorEmbestida +=16; break;
      default: iBonificadorEmbestida +=0;  break;
  }

  return iBonificadorEmbestida;
}

void RunHandImpact(object oTarget, object oCaster)
{
  // Finalizo el conjuro
  if(GZGetDelayedSpellEffectsExpired(461,oTarget,oCaster)) return;

  // Check caster ability vs. target's AC
  int nCasterModifier = GetCasterAbilityModifier(oCaster);
  int nCasterRollAt = d20(1) + nCasterModifier + GetTotalCasterLevel(oCaster) + 10 + -1;
  int nTargetRollAt = GetAC(oTarget);

  // * grapple HIT succesful,
  if(nCasterRollAt >= nTargetRollAt)
  {
      SendMessageToPC(OBJECT_SELF, ColorToken(155,254,254) + "La Mano aferradora de Bigby</c> "+ ColorToken(254,150,50) + "realiza una tirada de ataque: *éxito*: "+IntToString(nCasterRollAt)+" vs "+IntToString(nTargetRollAt)+"</c>");
      SendMessageToPC(oTarget, ColorToken(155,254,254) + "La Mano aferradora de Bigby</c> "+ ColorToken(254,150,50) + "realiza una tirada de ataque: *éxito*: "+IntToString(nCasterRollAt)+" vs "+IntToString(nTargetRollAt)+"</c>");

      // * now must make a GRAPPLE check to
      // * hold target for duration of spell
      // * check caster ability vs. target's size & strength
      int nCasterRoll = d20(1) + nCasterModifier + GetTotalCasterLevel(oCaster) + 10 + 4;
      int nTargetRoll = d20(1) + GetBaseAttackBonus(oTarget) + BonificadorPresa(oTarget) + GetAbilityModifier(ABILITY_STRENGTH, oTarget);

      if(nCasterRoll >= nTargetRoll)
      {
          // creatures immune to paralzation nanay
          if(GetIsImmune(oTarget, IMMUNITY_TYPE_PARALYSIS) ||
             GetIsImmune(oTarget, IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE) ||
             GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS))
          {
              SendMessageToPC(oCaster, ColorToken(155,254,254) + "La Mano aferradora de Bigby</c> "+ ColorToken(254,150,50) + "realiza un ataque de presa: *fallo, inmune a presa*: "+IntToString(nCasterRoll)+" vs "+IntToString(nTargetRoll)+"</c>");
              SendMessageToPC(oTarget, ColorToken(155,254,254) + "La Mano aferradora de Bigby</c> "+ ColorToken(254,150,50) + "realiza un ataque de presa: *fallo, inmune a presa*: "+IntToString(nCasterRoll)+" vs "+IntToString(nTargetRoll)+"</c>");
          }
          else
          {
              SendMessageToPC(oCaster, ColorToken(155,254,254) + "La Mano aferradora de Bigby</c> "+ ColorToken(254,150,50) + "realiza un ataque de presa: *éxito*: "+IntToString(nCasterRoll)+" vs "+IntToString(nTargetRoll)+"</c>");
              SendMessageToPC(oTarget, ColorToken(155,254,254) + "La Mano aferradora de Bigby</c> "+ ColorToken(254,150,50) + "realiza un ataque de presa: *éxito*: "+IntToString(nCasterRoll)+" vs "+IntToString(nTargetRoll)+"</c>");

              effect eVelocidad = EffectMovementSpeedDecrease(99);
              effect eAtaque = EffectMissChance(100);
              effect eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
              effect eLink = EffectLinkEffects(eVelocidad, eAtaque);
              eLink = EffectLinkEffects(eLink, eVis);
              ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 6.0);
          }
      }
      else
      {
          SendMessageToPC(oCaster, ColorToken(155,254,254) + "La Mano aferradora de Bigby</c> "+ ColorToken(254,150,50) + "realiza un ataque de presa: *fallo*: "+IntToString(nCasterRoll)+" vs "+IntToString(nTargetRoll)+"</c>");
          SendMessageToPC(oTarget, ColorToken(155,254,254) + "La Mano aferradora de Bigby</c> "+ ColorToken(254,150,50) + "realiza un ataque de presa: *fallo*: "+IntToString(nCasterRoll)+" vs "+IntToString(nTargetRoll)+"</c>");
      }
  }
  else
  {
      SendMessageToPC(OBJECT_SELF, ColorToken(155,254,254) + "La Mano aferradora de Bigby</c> "+ ColorToken(254,150,50) + "realiza una tirada de ataque: *fallo*: "+IntToString(nCasterRollAt)+" vs "+IntToString(nTargetRollAt)+"</c>");
      SendMessageToPC(oTarget, ColorToken(155,254,254) + "La Mano aferradora de Bigby</c> "+ ColorToken(254,150,50) + "realiza una tirada de ataque: *fallo*: "+IntToString(nCasterRollAt)+" vs "+IntToString(nTargetRollAt)+"</c>");
  }

  DelayCommand(6.0, RunHandImpact(oTarget, oCaster));
}

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);
/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

  if(!X2PreSpellCastCode())
  {
      // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
      return;
  }
  // End of Spell Cast Hook

  // COMPONENTE MATERIAL
  object oItm = GetSpellCastItem();
  if(GetIsPC(OBJECT_SELF) == TRUE &&
     oItm == OBJECT_INVALID &&
     GetIsDM(OBJECT_SELF) == FALSE &&
     GetIsDMPossessed(OBJECT_SELF) == FALSE)
  {
      int nLastSpellCastClass = GetLastSpellCastClass();
      if(nLastSpellCastClass == CLASS_TYPE_CLERIC || nLastSpellCastClass == CLASS_TYPE_FAVORED_SOUL) // Clerigos...
      {
          string sFocoPersonalizado = ObtenerStringPersistente(OBJECT_SELF, "FOCODIVINO");

          object oYelmo = GetItemInSlot(INVENTORY_SLOT_HEAD, OBJECT_SELF);
          object oArmadura = GetItemInSlot(INVENTORY_SLOT_CHEST, OBJECT_SELF);
          object oCapa = GetItemInSlot(INVENTORY_SLOT_CLOAK, OBJECT_SELF);
          object oBrazales = GetItemInSlot(INVENTORY_SLOT_ARMS, OBJECT_SELF);
          object oCinto = GetItemInSlot(INVENTORY_SLOT_BELT, OBJECT_SELF);
          object oCollar = GetItemInSlot(INVENTORY_SLOT_NECK, OBJECT_SELF);
          object oAnilloI = GetItemInSlot(INVENTORY_SLOT_LEFTRING, OBJECT_SELF);
          object oAnilloD = GetItemInSlot(INVENTORY_SLOT_RIGHTRING, OBJECT_SELF);
          object oReliquia = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, OBJECT_SELF);

          if(GetName(oYelmo) != sFocoPersonalizado &&
             GetName(oArmadura) != sFocoPersonalizado &&
             GetName(oCapa) != sFocoPersonalizado &&
             GetName(oBrazales) != sFocoPersonalizado &&
             GetName(oCinto) != sFocoPersonalizado &&
             GetName(oCollar) != sFocoPersonalizado &&
             GetName(oAnilloI) != sFocoPersonalizado &&
             GetName(oAnilloD) != sFocoPersonalizado &&
             GetName(oReliquia) != sFocoPersonalizado &&
             GetTag(oCollar) != "focodivino" &&
             GetTag(oReliquia) != "focodivino" &&
             GetTag(oCinto) != "focodivino")
          {
              SendMessageToPC(OBJECT_SELF,"¡Necesitas sujetar con fuerza un foco divino dotado de significado espiritual para lanzar este conjuro!");
              return;
          }

          else AssignCommand(OBJECT_SELF, ActionSpeakString(ColorToken(33,125,254) +"*Te concentras unos instantes en tu foco divino para lanzar el conjuro*</c>"));
      }
      else// Hechieros y magos...
      {
          // Si tienes la dote Abstencion de materiales, no necesitas componentes
          if(GetHasFeat(1200, OBJECT_SELF) == TRUE) SendMessageToPC(OBJECT_SELF, ColorToken(180,254,100) +"Gracias a la dote 'Abstención de materiales' puedes lanzar el conjuro sin necesitar ningún componente.</c>");
          else
          {
              if(GetItemPossessedBy(OBJECT_SELF, "guantearcano")==OBJECT_INVALID)
              {
                  SendMessageToPC(OBJECT_SELF,"¡Necesitas un guante arcano para lanzar el conjuro!");
                  return;
              }
              else
              {
                  object oIngrediente = GetItemPossessedBy(OBJECT_SELF,"guantearcano");
                  int iUsosIngrediente = GetLocalInt(oIngrediente, "USOS");

                  if(iUsosIngrediente == 0)
                  {
                      SetLocalInt(oIngrediente, "USOS", 1 + d2());
                      SendMessageToPC(OBJECT_SELF,"Utilizas parte de un guante arcano para lanzar este conjuro.");
                  }
                  else if(iUsosIngrediente == 1)
                  {
                      DestroyObject(oIngrediente);
                      SendMessageToPC(OBJECT_SELF,"Consumes todo un guante arcano para lanzar este conjuro.");
                  }
                  else
                  {
                      SetLocalInt(oIngrediente, "USOS", iUsosIngrediente - 1);
                      SendMessageToPC(OBJECT_SELF,"Utilizas parte de un guante arcano para lanzar este conjuro.");
                  }
              }
          }
      }
  }

  //Declare major variables
  object oTarget = GetSpellTargetObject();
  int nDuration = GetTotalCasterLevel(OBJECT_SELF);
  int nMetaMagic = GetSpellCastItem()==OBJECT_INVALID?GetMetaMagicFeat():METAMAGIC_NONE;

  //--------------------------------------------------------------------------
  // This spell no longer stacks. If there is one hand, that's enough
  //--------------------------------------------------------------------------
  if(GetHasSpellEffect(459, oTarget) ||  GetHasSpellEffect(460, oTarget) ||
     GetHasSpellEffect(461, oTarget) ||  GetHasSpellEffect(462, oTarget) ||
     GetHasSpellEffect(463, oTarget))
  {
      FloatingTextStrRefOnCreature(100775,OBJECT_SELF,FALSE);
      return;
  }

  //Check for metamagic extend
  if(nMetaMagic == METAMAGIC_EXTEND) //Duration is +100%
  {
       nDuration = nDuration * 2;
  }

  if(!GetIsReactionTypeFriendly(oTarget))
  {
      //Fire cast spell at event for the specified target
      SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 461, TRUE));

      // Check spell resistance
      if(!MyResistSpell(OBJECT_SELF, oTarget))
      {
          effect eHand = EffectVisualEffect(VFX_DUR_BIGBYS_GRASPING_HAND);
          ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHand, oTarget, RoundsToSeconds(nDuration));

          RunHandImpact(oTarget, OBJECT_SELF);
          DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
      }
  }
}
