//::///////////////////////////////////////////////
//:: Wail of the Banshee
//:: NW_S0_WailBansh
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
  You emit a terrible scream that kills enemy creatures who hear it
  The spell affects up to one creature per caster level. Creatures
  closest to the point of origin are affected first.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On:  Dec 12, 2000
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 11, 2001
//:: VFX Pass By: Preston W, On: June 25, 2001

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "mti_libreria"
#include "pb_constantes"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_NECROMANCY);
/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
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

          else AssignCommand(OBJECT_SELF, ActionSpeakString("<c!}þ>*Te concentras unos instantes en tu foco divino para lanzar el conjuro*</c>"));
      }
      else// Hechieros y magos...
      {
          // Si tienes la dote Abstencion de materiales, no necesitas componentes
          if(GetHasFeat(1200, OBJECT_SELF) == TRUE) SendMessageToPC(OBJECT_SELF, "<c´þd>Gracias a la dote 'Abestención de materiales' puedes lanzar el conjuro sin necesitar ningún componente.</c>");
          else
          {
              if(GetItemPossessedBy(OBJECT_SELF, "polvoseta")==OBJECT_INVALID)
              {
                  SendMessageToPC(OBJECT_SELF,"¡Necesitas un poco de polvo de seta nocturna para lanzar el conjuro!");
                  return;
              }
              else
              {
                  object oIngrediente = GetItemPossessedBy(OBJECT_SELF,"polvoseta");
                  int iUsosIngrediente = GetLocalInt(oIngrediente, "USOS");

                  if(iUsosIngrediente == 0)
                  {
                      SetLocalInt(oIngrediente, "USOS", 1 + d2());
                      SendMessageToPC(OBJECT_SELF,"Utilizas un poco de polvo de seta nocturna para lanzar este conjuro.");
                  }
                  else if(iUsosIngrediente == 1)
                  {
                      DestroyObject(oIngrediente);
                      SendMessageToPC(OBJECT_SELF,"Consumes todo el polvo de seta nocturna para lanzar este conjuro.");
                  }
                  else
                  {
                      SetLocalInt(oIngrediente, "USOS", iUsosIngrediente - 1);
                      SendMessageToPC(OBJECT_SELF,"Utilizas un poco de polvo de seta nocturna para lanzar este conjuro.");
                  }
              }
          }
      }
  }

    //Declare major variables
    int nCasterLevel = GetTotalCasterLevel(OBJECT_SELF);
    int nToAffect = nCasterLevel;
    object oTarget;
    float fTargetDistance;
    float fDelay;
    location lTarget;
    effect eVis = EffectVisualEffect(VFX_IMP_DEATH);
    effect eWail = EffectVisualEffect(VFX_FNF_WAIL_O_BANSHEES);
    int nCnt = 1;
    //Apply the FNF VFX impact
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eWail, GetSpellTargetLocation());
    //Get the closet target from the spell target location
    oTarget = GetSpellTargetObject(); // direct target
    if (!GetIsObjectValid(oTarget))
      oTarget = GetNearestObjectToLocation(OBJECT_TYPE_CREATURE, GetSpellTargetLocation(), nCnt);
    while (nCnt <= nToAffect)
    {
        lTarget = GetLocation(oTarget);
        //Get the distance of the target from the center of the effect
        fDelay = GetRandomDelay(3.0, 4.0);//
        fTargetDistance = GetDistanceBetweenLocations(GetSpellTargetLocation(), lTarget);
        //Check that the current target is valid and closer than 10.0m
        if(GetIsObjectValid(oTarget) && fTargetDistance <= 10.0)
        {
            if ((GetHasFeat(FEAT_MASTERY_SHAPES, OBJECT_SELF)) && (GetLocalInt(OBJECT_SELF, "archmage_mastery_shaping") == 1) && (!GetIsReactionTypeHostile(oTarget, OBJECT_SELF) || oTarget == OBJECT_SELF || GetMaster(oTarget) == OBJECT_SELF))
         {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SPELL_MANTLE_USE), oTarget);
        }
    else if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF)
            {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_WAIL_OF_THE_BANSHEE));
                //Make SR check
                if(!MyResistSpell(OBJECT_SELF, oTarget)) //, 0.1))
                {
                    //Make a fortitude save to avoid death
                    if(!MySavingThrow(SAVING_THROW_FORT, oTarget, (GetSpellSaveDC()+ GetChangesToSaveDC(OBJECT_SELF)), SAVING_THROW_TYPE_DEATH)) //, OBJECT_SELF, 3.0))
                    {
                        //Apply the delay VFX impact and death effect
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                        effect eDeath = EffectDeath();
                        if(GetHasSpellEffect(1329,oTarget))
                            {
                             SetImmortal(oTarget, FALSE);
                            }
                        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget)); // no delay
                    }
              }
            }
        }
        else
        {
            //Kick out of the loop
            nCnt = nToAffect;
        }
        //Increment the count of creatures targeted
        nCnt++;
        //Get the next closest target in the spell target location.
        oTarget = GetNearestObjectToLocation(OBJECT_TYPE_CREATURE, GetSpellTargetLocation(), nCnt);
       DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    }
}
