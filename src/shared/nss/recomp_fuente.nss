void main()
{
object oPJ = GetPCSpeaker();
effect eVida2 = EffectHeal(d10(6));
effect eRegenera = EffectRegenerate(d20(1),5.0);
effect eVida = EffectVisualEffect(VFX_IMP_HEALING_L);
effect eRegenera_1 = EffectVisualEffect(VFX_IMP_ELEMENTAL_PROTECTION);
effect eRegenera_2 = EffectVisualEffect(VFX_IMP_GOOD_HELP);
DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVida, oPJ));
DelayCommand(1.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVida2 , oPJ));
DelayCommand(3.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eRegenera_1 , oPJ));
DelayCommand(4.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eRegenera_2 , oPJ));
DelayCommand(5.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRegenera , oPJ, 180.0));
DelayCommand(5.0, SetLocalInt(oPJ, "Fuente_esmel", 1));
DelayCommand(900.0, DeleteLocalInt(oPJ, "Fuente_esmel"));
}
