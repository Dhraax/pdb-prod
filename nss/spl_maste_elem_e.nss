#include "pb_nivellanzador"
#include "x2_inc_spellhook"

void main()
{
    object oTarget = GetSpellTargetObject();
    effect eDur = EffectVisualEffect(2082);//463

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, RoundsToSeconds(1));

    DeleteLocalInt(OBJECT_SELF, "archmage_mastery_elements");
    SetLocalInt(OBJECT_SELF, "archmage_mastery_elements", DAMAGE_TYPE_ELECTRICAL);
    FloatingTextStringOnCreature("Maestria de los elementos:  Conjuros Electricos.", OBJECT_SELF, FALSE);
}
