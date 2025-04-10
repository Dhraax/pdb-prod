//::///////////////////////////////////////////////
//:: PASAR SIN DEJAR RASTRO
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Pasar sin dejar rastro. Immune a Rastrear.
    1 criatura por nivel de lanzador.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 8 de Junio de 2010
//:://////////////////////////////////////////////

#include "nw_i0_spells"
#include "x2_inc_spellhook"
#include "pb_nivellanzador"
#include "colors_inc"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);
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

  //Declare major variables
  int nDuration = GetTotalCasterLevel(OBJECT_SELF);
  int iCriaturasMaximas = nDuration;
  effect eVis = EffectVisualEffect(VFX_IMP_CHARM);
  effect eDur1 = EffectVisualEffect(VFX_DUR_CESSATE_NEUTRAL);
  effect eDur2 = EffectVisualEffect(1245);
  effect eLink = EffectLinkEffects(eDur1, eDur2);
  effect eImpact = EffectVisualEffect(VFX_FNF_LOS_NORMAL_20);
  float fDelay;

  //Metamagic duration check
  int nMetaMagic = GetSpellCastItem()==OBJECT_INVALID?GetMetaMagicFeat():METAMAGIC_NONE;
  if(nMetaMagic == METAMAGIC_EXTEND)
  {
      nDuration = nDuration *2;   //Duration is +100%
  }

  //Apply Impact
  ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetSpellTargetLocation());

  //Get the first target in the radius around the caster

  object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 10.0, GetLocation(OBJECT_SELF));
  while(GetIsObjectValid(oTarget) && iCriaturasMaximas != 0)
  {
      if(GetIsReactionTypeFriendly(oTarget) || GetFactionEqual(oTarget))
      {
          fDelay = GetRandomDelay(0.4, 1.1);
          //Fire spell cast at event for target
          SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
          //Apply VFX impact and bonus effects
          DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
          DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration)));
          DelayCommand(fDelay, SetLocalInt(oTarget,"RASTREO_IMMUNIDAD",TRUE));
          DelayCommand(fDelay+IntToFloat(nDuration), DeleteLocalInt(oTarget,"RASTREO_IMMUNIDAD"));
          SendMessageToPC(oTarget, ColorToken(254,254,254) + "Ahora no dejarás nigún rastro al caminar, nadie será capaz de rastrearte.</c>");
          iCriaturasMaximas--;
      }

      //Get the next target in the specified area around the caster
      oTarget = GetNextObjectInShape(SHAPE_SPHERE, 10.0, GetLocation(OBJECT_SELF));
      DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");

  }
}
