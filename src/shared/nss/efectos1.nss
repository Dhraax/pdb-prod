#include "nw_i0_generic"
void main()
{
  WalkWayPoints();

  ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectVisualEffect(VFX_DUR_ICESKIN)), OBJECT_SELF);
  //ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectVisualEffect(1501)), OBJECT_SELF);
  //ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectVisualEffect(1506)), OBJECT_SELF);
  SetFootstepType(FOOTSTEP_TYPE_LEATHER_WING);

  ExecuteScript("nw_c2_dropin9", OBJECT_SELF);
}
