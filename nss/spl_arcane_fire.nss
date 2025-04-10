#include "pb_nivellanzador"
#include "x2_inc_spellhook"

void main()
{
    /* Dont activate twice */
    if (GetLocalInt(OBJECT_SELF, "arcane_fire_active") == 1)
    {
        FloatingTextStringOnCreature("Fuego Arcano ya esta canalizado... Lanza un hechizo.", OBJECT_SELF, FALSE);
        return;
    }

    /* Setup as active */
    SetLocalInt(OBJECT_SELF, "arcane_fire_active", 1);
    //DelayCommand(18.0, SetLocalInt(OBJECT_SELF, "arcane_fire_active", 0));

    /* Save old hook, if any */
    SetLocalString(GetModule(), "archmage_save_overridespellscript", GetModuleOverrideSpellscript());

    /* Setup the global spellhok so we can intercept the next spell */
    SetModuleOverrideSpellscript("archmage_fire");

    /* Save the designed victi..erm..target */
    SetLocalObject(OBJECT_SELF, "arcane_fire_target", GetSpellTargetObject());

    FloatingTextStringOnCreature("Fuego Arcano canalizado. Lanza cualquier hechizo memorizado.", OBJECT_SELF, FALSE);

    /* And now some nifty spell effects */
    effect eVis = EffectVisualEffect(VFX_IMP_CHARM);
    effect eVis3 = EffectVisualEffect(VFX_DUR_SPELLTURNING);
    effect eVis2 = EffectVisualEffect(VFX_DUR_ELEMENTAL_SHIELD);
    effect eLink = EffectLinkEffects (eVis3 , eVis2);

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetSpellTargetLocation());
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, OBJECT_SELF);
    DelayCommand(0.2, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis3, OBJECT_SELF));
}
