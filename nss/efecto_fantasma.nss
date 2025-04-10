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

    effect eEfecto1 = SupernaturalEffect(EffectVisualEffect(VFX_DUR_GHOSTLY_VISAGE));
    effect eEfecto2 = SupernaturalEffect(EffectVisualEffect(VFX_DUR_SANCTUARY ));

    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEfecto1, OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEfecto2, OBJECT_SELF);

    SetListeningPatterns();
    WalkWayPoints();
}
