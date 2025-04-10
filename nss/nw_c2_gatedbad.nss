//::///////////////////////////////////////////////
//:: Custom On Spawn In
//:: nw_c2_gatedbad
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Balor o Deva astral hostil will destroy self after 1 minute
*/
//:://////////////////////////////////////////////

#include "NW_I0_GENERIC"

void main()
{
  // Efecto visual de devas astrales hostiles
  if(GetResRef(OBJECT_SELF) == "asy_solarconv_bu") DelayCommand(1.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(558), OBJECT_SELF));

  SetListeningPatterns();    // Goes through and sets up which shouts the NPC will listen to.

  DestroyObject(OBJECT_SELF, 60.0);
  effect e = EffectVisualEffect(VFX_IMP_UNSUMMON);
  location lLoc = GetLocation(OBJECT_SELF);
  DelayCommand(59.5, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, e, lLoc));
}
