void main()
{
  object oPC = GetPCSpeaker();
  effect ePolvoHada1 = EffectVisualEffect(VFX_DUR_PIXIEDUST);
  effect ePolvoHada2 = EffectVisualEffect(VFX_DUR_AURA_GREEN);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePolvoHada1, oPC, 8.0);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePolvoHada2, oPC, 8.0);
}
