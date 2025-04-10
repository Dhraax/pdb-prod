//::///////////////////////////////////////////////
//:: Bigby's Clenched Fist
//:: [x0_s0_bigby4]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Does an attack EACH ROUND for 1 round/level.
    If the attack hits does
     1d8 +11 points of damage

    Any creature struck must make a FORT save or
    be stunned for one round.

    GZ, Oct 15 2003:
    Changed how this spell works by adding duration
    tracking based on the VFX added to the character.
    Makes the spell dispellable and solves some other
    issues with wrong spell DCs, checks, etc.

*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: September 7, 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Georg Zoeller October 15, 2003

#include "x0_i0_spells"
#include "x2_inc_spellhook"
#include "x2_i0_spells"
#include "mti_libreria"
#include "pb_nivellanzador"
#include "colors_inc"
#include "pb_constantes"

int nSpellID = 462;

void RunHandImpact(object oTarget, object oCaster)
{
  //--------------------------------------------------------------------------
  // Check if the spell has expired (check also removes effects)
  //--------------------------------------------------------------------------
  if(GZGetDelayedSpellEffectsExpired(nSpellID,oTarget,oCaster)) return;

  int nCasterModifiers = GetCasterAbilityModifier(oCaster) + GetTotalCasterLevel(oCaster);
  int nCasterRoll = d20(1) + nCasterModifiers + 11 + -1;
  int nTargetRoll = GetAC(oTarget);
  if (nCasterRoll >= nTargetRoll)
  {
      SendMessageToPC(oCaster, ColorToken(155,254,254) + "El Puño cerrado de Bigby</c> "+ ColorToken(254,150,50) + "realiza una tirada de ataque: *éxito*: "+IntToString(nCasterRoll)+" vs "+IntToString(nTargetRoll)+"</c>");
      SendMessageToPC(oTarget, ColorToken(155,254,254) + "El Puño cerrado de Bigby</c> "+ ColorToken(254,150,50) + "realiza una tirada de ataque: *éxito*: "+IntToString(nCasterRoll)+" vs "+IntToString(nTargetRoll)+"</c>");

      int nDC = GetLocalInt(oTarget,"XP2_L_SPELL_SAVE_DC_" + IntToString (nSpellID));
      int nDam  = MaximizeOrEmpower(8, 1, GetMetaMagicFeat(), 11);
      effect eDam = EffectDamage(nDam, DAMAGE_TYPE_BLUDGEONING);
      effect eVis = EffectVisualEffect(VFX_IMP_ACID_L);

      ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

      if(!MySavingThrow(SAVING_THROW_FORT, oTarget, nDC))
      {
          ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectStunned(), oTarget, RoundsToSeconds(1));
      }

      DelayCommand(6.0f,RunHandImpact(oTarget,oCaster));
  }
  else
  {
      SendMessageToPC(oCaster, ColorToken(155,254,254) + "El Puño cerrado de Bigby</c> "+ ColorToken(254,150,50) + "realiza una tirada de ataque: *fallo*: "+IntToString(nCasterRoll)+" vs "+IntToString(nTargetRoll)+"</c>");
      SendMessageToPC(oTarget, ColorToken(155,254,254) + "El Puño cerrado de Bigby</c> "+ ColorToken(254,150,50) + "realiza una tirada de ataque: *fallo*: "+IntToString(nCasterRoll)+" vs "+IntToString(nTargetRoll)+"</c>");
  }
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

    object oTarget = GetSpellTargetObject();

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

    int nDuration = GetTotalCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetSpellCastItem()==OBJECT_INVALID?GetMetaMagicFeat():METAMAGIC_NONE;
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
         nDuration = nDuration * 2;
    }

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpellID, TRUE));
        int nResult = MyResistSpell(OBJECT_SELF, oTarget);

        if(nResult  == 0)
        {
            int nCasterModifier = GetCasterAbilityModifier(OBJECT_SELF);
            effect eHand = EffectVisualEffect(VFX_DUR_BIGBYS_CLENCHED_FIST);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHand, oTarget, RoundsToSeconds(nDuration));

            //----------------------------------------------------------
            // GZ: 2003-Oct-15
            // Save the current save DC on the character because
            // GetSpellSaveDC won't work when delayed
            //----------------------------------------------------------
            SetLocalInt(oTarget,"XP2_L_SPELL_SAVE_DC_" + IntToString (nSpellID), (GetSpellSaveDC()+ GetChangesToSaveDC(OBJECT_SELF)));
            RunHandImpact(oTarget, OBJECT_SELF);
            DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        }
    }
}

