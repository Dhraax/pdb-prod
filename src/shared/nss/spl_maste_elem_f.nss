#include "pb_nivellanzador"
#include "x2_inc_spellhook"

void main()
{
    object oTarget = GetSpellTargetObject();
    effect eDur = EffectVisualEffect(2083);//VFX_IMP_ELEMENTAL_PROTECTION

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, RoundsToSeconds(1));

    DeleteLocalInt(OBJECT_SELF, "archmage_mastery_elements");
    SetLocalInt(OBJECT_SELF, "archmage_mastery_elements", DAMAGE_TYPE_FIRE);
    FloatingTextStringOnCreature("Maestria de los elementos: Conjuros de Fuego.", OBJECT_SELF, FALSE);
}
