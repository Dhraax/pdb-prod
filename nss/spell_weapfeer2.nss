//OnHit de Espada Feerica, hace 2d6 de daño divino a cualquier criatura de la raza orco, gigante y trasgo.
void main()
{
    object oTarget = GetSpellTargetObject();
    int nDmg = d6(2);
    int iRaza = GetRacialType(oTarget);

    effect eDmg = EffectDamage(nDmg,DAMAGE_TYPE_POSITIVE);
    effect eVis = EffectVisualEffect(VFX_COM_HIT_DIVINE);
    eDmg = EffectLinkEffects (eVis, eDmg);

    if (GetIsObjectValid(oTarget))
    {
        if(iRaza == RACIAL_TYPE_GIANT || iRaza == RACIAL_TYPE_HUMANOID_ORC || iRaza == RACIAL_TYPE_HUMANOID_GOBLINOID)
        {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDmg, oTarget);
        }

    }

}
