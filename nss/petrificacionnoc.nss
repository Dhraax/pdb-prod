#include "nw_i0_tool"

void main()
{
object oIntruso = GetEnteringObject();
if (GetIsNight())
   {
   effect e1 = EffectPetrify();
   effect e2 = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_2);
   effect e3 = EffectVisualEffect(VFX_FNF_PWSTUN);
   object oWP = GetNearestObjectByTag("WP_tiendajackintruso");
   location loc = GetLocation(oWP);


   ApplyEffectToObject(DURATION_TYPE_TEMPORARY,e2,oIntruso);
   DelayCommand(0.2,AssignCommand(oIntruso,JumpToLocation(loc)));
   DelayCommand(0.4,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,e1,oIntruso));
   DelayCommand(3.0,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,e3,oIntruso));
   DelayCommand(4.0,AssignCommand(oIntruso,JumpToLocation(loc)));
   DelayCommand(6.0,AssignCommand(oIntruso,JumpToLocation(loc)));
   DelayCommand(8.0,AssignCommand(oIntruso,JumpToLocation(loc)));
   }
}
