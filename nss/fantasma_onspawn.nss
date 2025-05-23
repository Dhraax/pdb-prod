#include "NW_I0_GENERIC"

void main()
{
    // CADAVERES USABLES AL MORIR
    SetLootable(OBJECT_SELF, TRUE);

    // REG. DE TESOROS
    if(GetLocalInt(OBJECT_SELF, "JEFAZO") > 0) {
        //ExecuteScript("pb_tesoro_boss", OBJECT_SELF);
    } else {
        ExecuteScript("pb_tesoros_pnjs", OBJECT_SELF);
    }

    // EFECTO FANTASMA
    effect eSombra = SupernaturalEffect(EffectVisualEffect(VFX_DUR_GHOSTLY_VISAGE));
    effect ePasaParedes = SupernaturalEffect(EffectCutsceneGhost());
    effect eParpadeo = SupernaturalEffect(EffectVisualEffect(VFX_DUR_GHOSTLY_PULSE));

    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSombra, OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePasaParedes, OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eParpadeo, OBJECT_SELF);
    ActionCastSpellAtObject(SPELL_GHOSTLY_VISAGE, OBJECT_SELF, METAMAGIC_EXTEND, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);

    SetListeningPatterns();
    WalkWayPoints();
}
