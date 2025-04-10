//::///////////////////////////////////////////////
//:: SALTO
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Salto.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 10 de Junio de 2010
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

  //Declare major variables
  object oTarget = GetSpellTargetObject();
  int iNivelLanzador = GetTotalCasterLevel(OBJECT_SELF);
  int nDuration = iNivelLanzador; // * Duracion 1 turno / nivel
  effect eVis1 = EffectVisualEffect(1746);
  effect eVis2 = EffectVisualEffect(1751);
  effect eLink1 = EffectLinkEffects(eVis1, eVis2);

  // Calculo bono en saltar
  int iBono;
  if(iNivelLanzador >= 1 && iNivelLanzador <= 4) iBono = 10;
  else if(iNivelLanzador >= 5 && iNivelLanzador <= 8) iBono = 20;
  else iBono = 30;

  // Dotes metamagicas
  int nMetaMagic = GetSpellCastItem()==OBJECT_INVALID?GetMetaMagicFeat():METAMAGIC_NONE;
  if(nMetaMagic == METAMAGIC_EXTEND)    //Duration is +100%
  {
       nDuration = nDuration * 2;
  }
  else if(nMetaMagic == METAMAGIC_EMPOWER) // +50% de bono
  {
       iBono = iBono + (iBono / 2);
  }

  //Fire spell cast at event for target
  SignalEvent(oTarget, EventSpellCastAt(oTarget, GetSpellId(), FALSE));

  //Apply VFX impact and bonus effects
  ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink1, oTarget);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE), oTarget, TurnsToSeconds(nDuration));
  DoNoStackSkillBonus(OBJECT_SELF, oTarget, iBono, 26, TurnsToSeconds(nDuration),GetSpellId());
  DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
