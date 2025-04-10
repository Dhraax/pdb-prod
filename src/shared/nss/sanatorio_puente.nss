#include "nw_i0_tool"

void main()
{
    object oIntruso = GetEnteringObject();
if(!HasItem(oIntruso,"qk_bastonmagos"))
    {
    effect e1 = EffectPetrify();
    effect e2 = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_2);
    effect e4 = EffectCurse(4,4,4,4,4,4);
    effect e3 = EffectVisualEffect(VFX_FNF_PWSTUN);
    object oWP = GetNearestObjectByTag("WP_sanatoriointruso");
    location loc = GetLocation(oWP);


    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,e2,oIntruso);
    DelayCommand(0.2,AssignCommand(oIntruso,JumpToLocation(loc)));
    DelayCommand(0.4,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,e1,oIntruso,300.0));
    DelayCommand(3.0,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,e3,oIntruso));
    DelayCommand(4.0,AssignCommand(oIntruso,JumpToLocation(loc)));
    DelayCommand(6.0,AssignCommand(oIntruso,JumpToLocation(loc)));
    DelayCommand(8.0,AssignCommand(oIntruso,JumpToLocation(loc)));
    DelayCommand(8.5,ApplyEffectToObject(DURATION_TYPE_PERMANENT,e4,oIntruso));
    }
}
