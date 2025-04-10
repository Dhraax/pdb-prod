void main()
{
  int nDmg = d6();

  effect eDmg = EffectDamage(nDmg,DAMAGE_TYPE_ACID);
  effect eVis = EffectVisualEffect(VFX_IMP_ACID_S);
  effect eVeneno = EffectPoison(POISON_TINY_SPIDER_VENOM); //1d2 a fuerza + 1d2 a fuerza CD 11.
  eDmg = EffectLinkEffects (eVis, eDmg);


  object oTarget = GetSpellTargetObject();

  if (GetIsObjectValid(oTarget))
  {
      ApplyEffectToObject(DURATION_TYPE_INSTANT, eDmg, oTarget);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, eVeneno, oTarget);
  }
}
