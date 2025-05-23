#include "x0_inc_henai"
void main()
{
  SetLootable(OBJECT_SELF, TRUE);
  SetAssociateState(NW_ASC_DISTANCE_2_METERS);
  DelayCommand(900.0,ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectDamage(999),OBJECT_SELF));
}
