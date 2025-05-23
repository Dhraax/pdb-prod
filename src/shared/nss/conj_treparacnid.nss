//::///////////////////////////////////////////////
//:: TREPAR CUAL ARACNIDO
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Trepar cual aracnido.
    Bono de +10 a Trepar, imposible hacerlo igual que en mesa.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 7 de Junio de 2010
//:://////////////////////////////////////////////

#include "x2_inc_spellhook"
#include "nostack_inc"
#include "pb_nivellanzador"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);
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

  int iBono = 10;
  int nMetaMagic = GetSpellCastItem()==OBJECT_INVALID?GetMetaMagicFeat():METAMAGIC_NONE;
  int nDuration = GetTotalCasterLevel(OBJECT_SELF) * 10;

  if(nMetaMagic == METAMAGIC_EXTEND)    //Duration is +100%
  {
       nDuration = nDuration * 2;
  }
  else if(nMetaMagic == METAMAGIC_EMPOWER) // +50% de bono
  {
       iBono = iBono + (iBono / 2);
  }

  //Declare major variables
  object oTarget = GetSpellTargetObject();
  effect eVis1 = EffectVisualEffect(1750);
  effect eVis2 = EffectVisualEffect(1751);
  effect eLink1 = EffectLinkEffects(eVis1, eVis2);

  //Fire spell cast at event for target
  SignalEvent(oTarget, EventSpellCastAt(oTarget, GetSpellId(), FALSE));
  //Apply VFX impact and bonus effects
  ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink1, oTarget);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE), oTarget, TurnsToSeconds(nDuration));
  DoNoStackSkillBonus(OBJECT_SELF, oTarget, iBono, 37, TurnsToSeconds(nDuration),GetSpellId());
  DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
