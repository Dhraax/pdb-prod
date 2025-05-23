void BonosConvocarCriatura(object oPC = OBJECT_SELF)
{
    object oConvocado = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oPC);

    if(oConvocado == OBJECT_INVALID) return;

    if(GetHasFeat(1203, oPC) == TRUE)  // Aumentar convocacion
    {
        SendMessageToPC(oPC, "<c4~ø>Aumentar convocación: convocas una criatura con mejores aptitudes físicas (+4 a Fue y Con).</c>");
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectAbilityIncrease(ABILITY_STRENGTH, 4)), oConvocado);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectAbilityIncrease(ABILITY_CONSTITUTION, 4)), oConvocado);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(85), oConvocado);
    }

    if(GetHasFeat(FEAT_ANIMAL_DOMAIN_POWER, oPC) == TRUE &&
      (GetRacialType(oConvocado) == RACIAL_TYPE_ANIMAL || GetLevelByClass(CLASS_TYPE_ANIMAL, oConvocado) > 0)) // Dominio animal con animales
    {
        effect eEfectoElegido;
        string sFrase;
        int iSuerte = d3();

        if(iSuerte == 1)
        {
            eEfectoElegido = SupernaturalEffect(EffectLinkEffects(EffectDamageReduction(10, DAMAGE_POWER_PLUS_FIVE, 50), EffectVisualEffect(VFX_DUR_PROT_STONESKIN)));
            sFrase = "<c¦ó->Dominio Animal: tu animal convocado obtiene resistencia al daño extra (reducción 10/5+).</c>";
        }
        else if(iSuerte == 2)
        {
            eEfectoElegido = SupernaturalEffect(EffectRegenerate(2, 6.0));
            sFrase = "<c¦ó->Dominio Animal: tu animal convocado obtiene el don de la regeneración (2pg cada asalto).</c>";
        }
        else
        {
            eEfectoElegido = SupernaturalEffect(EffectDamageIncrease(DAMAGE_BONUS_2d4, DAMAGE_TYPE_SLASHING));
            sFrase = "<c¦ó->Dominio Animal: tu animal convocado obtiene un ataque superior (+2d4 daño cortante).</c>";
        }

        SendMessageToPC(oPC, sFrase);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEfectoElegido, oConvocado);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(29), oConvocado);
    }
}
