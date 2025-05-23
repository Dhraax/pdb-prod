//::///////////////////////////////////////////////
//:: AURA DE CABALLERO DE LA MUERTE
//:: Copyright (c) www.puertadebaldur.net
//:://////////////////////////////////////////////

#include "x0_i0_spells"

void main()
{
  object oPC = OBJECT_SELF;
  effect eAOE = EffectAreaOfEffect(AOE_MOB_FEAR, "auradeath", "****", "****");
  /*if(GetHasSpellEffect(1102) || GetHasFeatEffect(1304))
  {
      FloatingTextStringOnCreature("<cþ<<>** Aura amenazadora desactivada **</c>", oPC);
      RemoveEffectsFromSpell(oPC, 1102);
      RemoveEffect(oPC, eAOE);
      return;
  }*/
  int bFound = FALSE;
  effect eEffect = GetFirstEffect(oPC);
  while (GetIsEffectValid(eEffect)) {
    if(GetEffectType(eEffect) == GetEffectType(eAOE) && GetEffectSubType(eEffect) == GetEffectSubType(eAOE)) {
      bFound = TRUE;
      RemoveEffect(oPC, eEffect);
    }
    eEffect = GetNextEffect(oPC);
  }

  if(bFound)
    FloatingTextStringOnCreature("<cþ<<>** Aura amenazadora desactivada **</c>", oPC);
  else {
    //Set and apply AOE object
    FloatingTextStringOnCreature("<c´þd>** Aura amenazadora activada **</c>", oPC);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, OBJECT_SELF, HoursToSeconds(100));
  }
}
