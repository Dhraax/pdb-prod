//::///////////////////////////////////////////////
//:: AURA DE VALOR
//:: Copyright (c) www.puertadebaldur.net
//:://////////////////////////////////////////////
/*
    Aptitud sobrenatural de los Paladines a Nivel 3.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 6 de Octubre de 2011
//:://////////////////////////////////////////////

#include "x0_i0_spells"
#include "inc_spells"

void main()
{
  object oPC = OBJECT_SELF;

  if(GetHasSpellEffect(1104))
  {
      gsSPRemoveEffect(oPC, 1104);
      IncrementRemainingFeatUses(oPC, 300);
      FloatingTextStringOnCreature("<cþ<<>** Aura de valor desactivada **</c>", oPC);
      return;
  }

  //Set and apply AOE object
  FloatingTextStringOnCreature("<c´þd>** Aura de valor activada **</c>", oPC);
  effect eAOE = EffectAreaOfEffect(AOE_MOB_CIRCEVIL, "dote_auravalor2", "****", "doteauravalor3");
  gsSPApplyEffect(oPC, eAOE, 1104, GS_SP_DURATION_PERMANENT);
}
