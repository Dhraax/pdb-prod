#include "pb_nivellanzador"
#include "x2_inc_spellhook"

void main()
{
    object oTarget = GetSpellTargetObject();
    effect eDur = EffectVisualEffect(2081);//VFX_IMP_AC_BONUS

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, RoundsToSeconds(8));

    DeleteLocalInt(OBJECT_SELF, "archmage_mastery_elements");
    SetLocalInt(OBJECT_SELF, "archmage_mastery_elements", DAMAGE_TYPE_COLD);
    FloatingTextStringOnCreature("Maestria de los elementos:  Conjuros de Frio.", OBJECT_SELF, FALSE);
}
