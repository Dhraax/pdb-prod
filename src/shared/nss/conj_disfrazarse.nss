//::///////////////////////////////////////////////
//:: DISFRAZARSE
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Disfrazarse.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 30 de Marzo de 2011
//:://////////////////////////////////////////////

#include "x2_inc_spellhook"
#include "nostack_inc"
#include "pb_nivellanzador"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ILLUSION);
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
  object oCaster = OBJECT_SELF;
  object oTarget = GetSpellTargetObject();
  int iNivelLanzador = GetTotalCasterLevel(oCaster);
  int nDuration = iNivelLanzador; // * Duracion 1 turno / nivel
  effect eVis1 = EffectVisualEffect(1747);
  effect eVis2 = EffectVisualEffect(1751);
  effect eLink1 = EffectLinkEffects(eVis1, eVis2);

  // Dotes metamagicas
  int nMetaMagic = GetSpellCastItem()==OBJECT_INVALID?GetMetaMagicFeat():METAMAGIC_NONE;
  if(nMetaMagic == METAMAGIC_EXTEND)    //Duration is +100%
  {
       nDuration = nDuration * 2;
  }

  //Fire spell cast at event for target
  SignalEvent(oCaster, EventSpellCastAt(oTarget, GetSpellId(), FALSE));

  //Apply VFX impact and bonus effects
  ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink1, oTarget);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE), oTarget, TurnsToSeconds(nDuration));
  DoNoStackSkillBonus(OBJECT_SELF, oTarget, 10, 30, HoursToSeconds(nDuration),GetSpellId());
  DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
