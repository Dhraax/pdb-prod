#include "pb_nivellanzador"
#include "x2_inc_spellhook"

void main()
{
    object oTarget = GetSpellTargetObject();
    effect eDur = EffectVisualEffect(1641);//460

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, RoundsToSeconds(1));

    if (GetLocalInt(OBJECT_SELF, "archmage_mastery_shaping") == 0)
    {
        DeleteLocalInt(OBJECT_SELF, "archmage_mastery_shaping");
        DelayCommand(1.5, SetLocalInt(OBJECT_SELF, "archmage_mastery_shaping", 1));
        FloatingTextStringOnCreature("Maestria en modelado : Proteccion aliados activada.", OBJECT_SELF, FALSE);
    }
    else
    {
        DeleteLocalInt(OBJECT_SELF, "archmage_mastery_shaping");
        DelayCommand(1.5, SetLocalInt(OBJECT_SELF, "archmage_mastery_shaping", 0));
        FloatingTextStringOnCreature("Maestria en modelado : Proteccion aliados desactivada.", OBJECT_SELF, FALSE);
    }
}
