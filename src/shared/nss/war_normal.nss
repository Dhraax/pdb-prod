#include "pb_nivellanzador"
#include "x2_inc_spellhook"

void main()
{
    object oTarget = GetSpellTargetObject();
    effect eDur = EffectVisualEffect(460);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, RoundsToSeconds(2));

    SetLocalInt(OBJECT_SELF, "esencia_sobrenatural", 0);
	SetLocalInt(OBJECT_SELF, "esencia_ajuste", 0);
    FloatingTextStringOnCreature("Invocación: Explosión Sobrenatural normal.", OBJECT_SELF, FALSE);
}
