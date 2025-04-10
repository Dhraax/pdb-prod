//::///////////////////////////////////////////////
//:: AURA DE CABALLERO DE LA MUERTE (al entrar al aura)
//:: Copyright (c) www.puertadebaldur.net
//:://////////////////////////////////////////////
#include "NW_I0_SPELLS"

void main()
{
  //Declare major variables

  object oPC = GetEnteringObject();

  effect eVis = EffectVisualEffect(VFX_IMP_FEAR_S);
  effect eDur = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);
  effect eDur2 = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
  effect eFear = EffectFrightened();
  effect eLink = EffectLinkEffects(eFear, eDur);
  eLink = EffectLinkEffects(eLink, eDur2);
  object oDragon = GetAreaOfEffectCreator() ;
  int nHD = GetHitDice(oDragon);
  int nDC = 10 + nHD/2 + GetAbilityModifier(ABILITY_CHARISMA,oDragon);
  int nDuration ;
  // Loop on all creature in area
  //object oTarget = GetFirstInPersistentObject();
  //while( GetIsObjectValid(oTarget) ){
  object oTarget = oPC;
  if(GetIsObjectValid(oTarget)){
      if(GetIsEnemy(oTarget, oDragon) && GetHitDice(oTarget) <= 8){
        nDuration = GetScaledDuration(1+nHD/3, oTarget);
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), SPELLABILITY_AURA_FEAR));
        //Make a saving throw check
        if( (!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_FEAR)) &&
            (! GetHasSpellEffect(SPELLABILITY_AURA_FEAR, oTarget)) ){
            //Apply the VFX impact and effects
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        }
      }
  //    oTarget = GetNextInPersistentObject();
  }
}
