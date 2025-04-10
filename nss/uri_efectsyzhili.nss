#include "nw_i0_generic"
void main()
{
    effect eEfecto2 = SupernaturalEffect(EffectVisualEffect(VFX_DUR_MAGIC_RESISTANCE));

  WalkWayPoints();

    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEfecto2, OBJECT_SELF);
}
