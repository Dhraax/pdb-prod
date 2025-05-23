void main()
{
  object oPC = GetEnteringObject();

  if(!GetIsPC(oPC)) return;

  object oTarget = GetNearestObjectByTag("01");
  ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_IMPLOSION), GetLocation(oTarget));

  FloatingTextStringOnCreature("* A medida que te acercas crece el mal *", oPC);
}
