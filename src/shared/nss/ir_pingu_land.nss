#include "x0_i0_petrify"
void main()
{
object oPC = GetPCSpeaker();
object oMaga = GetObjectByTag("ZaraanaHyrrshas");
object oPinguland = GetWaypointByTag("pingu_por_listo");
object oArmario = GetObjectByTag("armario_entrada_zs");
effect eParalizar1 = EffectVisualEffect(VFX_DUR_PARALYZED);
effect eParalizar2 = EffectVisualEffect(VFX_DUR_PARALYZE_HOLD);
effect eEfectoFinal = EffectVisualEffect(VFX_IMP_POLYMORPH);

DelayCommand(0.0, SetCommandable(FALSE, oPC));
DelayCommand(1.0, AssignCommand(oMaga, PlayAnimation(ANIMATION_LOOPING_CONJURE2, 2.0, 4.0)));
DelayCommand(1.0, AssignCommand(oMaga, PlaySound("vs_chant_illu_lf")));
DelayCommand(3.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eParalizar1, oPC, 10.0));
DelayCommand(4.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eParalizar2, oPC, 10.0));
DelayCommand(6.0, AssignCommand(oMaga,SpeakString("¡¡¡Qué te lo pases bien en el plano helado, PINGÜINO!!!")));
DelayCommand(8.0, AssignCommand(oPC,SpeakString("¡¡¡¿Pingüino?!!!")));
DelayCommand(10.0, AssignCommand(oMaga, PlayAnimation(ANIMATION_LOOPING_CONJURE2, 2.0, 3.0)));
DelayCommand(10.0, AssignCommand(oMaga, PlaySound("vs_chant_illu_hm")));
DelayCommand(11.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eEfectoFinal, oPC));
DelayCommand(11.0, ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectPolymorph(POLYMORPH_TYPE_PENGUIN, TRUE), oPC));
DelayCommand(12.0, SetCommandable(TRUE,oPC));
DelayCommand(12.0, AssignCommand(oPC, JumpToObject(oPinguland)));
DelayCommand(13.0, DeleteLocalInt(oArmario, "GUARDIA_SUNE_MAGA"));
DelayCommand(13.0, DeleteLocalInt(oPC, "ESTOYENZAPSUNE"));
DelayCommand(14.0, RemoveEffectOfType(oArmario,EFFECT_TYPE_VISUALEFFECT));
}
