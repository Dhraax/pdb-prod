//::///////////////////////////////////////////////
//:: NIEBLA DE OBSCURECIMIENTO
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Niebla de obscurecimiento.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 30 de Marzo de 2011
//:://////////////////////////////////////////////

#include "nw_i0_spells"
#include "x2_inc_spellhook"
#include "pb_nivellanzador"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ABJURATION);
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
  int iNivelLanzador = GetTotalCasterLevel(OBJECT_SELF);
  int nDuration = iNivelLanzador; // * Duracion 1 turno / nivel
  float fDelay;

  // Dotes metamagicas
  int nMetaMagic = GetSpellCastItem()==OBJECT_INVALID?GetMetaMagicFeat():METAMAGIC_NONE;
  if(nMetaMagic == METAMAGIC_EXTEND)    //Duration is +100%
  {
       nDuration = nDuration * 2;
  }

  effect eOcultacion1 = EffectConcealment(30);
  effect eOcultacion2 = EffectConcealment(20);
  effect eVis = EffectVisualEffect(479);  //1780
  effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

  effect eOcultacionPersonal = EffectLinkEffects(eOcultacion1, eDur);
  eOcultacionPersonal = EffectLinkEffects(eOcultacionPersonal, eVis);

  effect eOcultacionProximos = EffectLinkEffects(eOcultacion2, eDur);
  eOcultacionProximos = EffectLinkEffects(eOcultacionProximos, eVis);

  ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectVisualEffect(1687), GetLocation(OBJECT_SELF), 6.0);

  object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 5.0, GetLocation(OBJECT_SELF));
  while(GetIsObjectValid(oTarget))
  {
      if(GetIsReactionTypeFriendly(oTarget) || GetFactionEqual(oTarget))
      {
          fDelay = GetRandomDelay(0.4, 1.1);

          //Fire spell cast at event for target
          SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

          //Apply VFX impact and bonus effects
          if(oTarget == OBJECT_SELF) ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eOcultacionPersonal, oTarget, TurnsToSeconds(nDuration));
          else ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eOcultacionProximos, oTarget, TurnsToSeconds(nDuration));
      }

      //Get the next target in the specified area around the caster
      oTarget = GetNextObjectInShape(SHAPE_SPHERE, 5.0, GetLocation(OBJECT_SELF));

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
  }
}
