#include "x0_i0_petrify"
void main()
{
    object oPC = GetPCSpeaker();
    object oTarget = GetWaypointByTag("salida_maga_zs");
    effect eSummon = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_2);
    effect eFantasma = EffectVisualEffect(VFX_DUR_ETHEREAL_VISAGE);
    effect eArmarioEfecto = EffectVisualEffect(VFX_FNF_PWSTUN);
    object oArmario = GetObjectByTag("armario_entrada_zs");
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eSummon, oPC);
    DeleteLocalInt(oArmario, "GUARDIA_SUNE_MAGA");
    DeleteLocalInt(oPC, "ESTOYENZAPSUNE");
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eArmarioEfecto, oArmario);
    RemoveEffectOfType(oArmario,EFFECT_TYPE_VISUALEFFECT);
    AssignCommand(oPC, JumpToObject(oTarget));
}
