/// ----------------------------------------------------------------------------
/// @system  CNR Crafting
/// @file    cnr_i_prop
/// @author  Dhraax
/// @brief   Item property helpers shared by the crafting paths.
/// modified by: Dhraax
/// ----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

/// @brief Physical damage type of a weapon, read from baseitems.2da.
/// @param oItem Item to inspect.
/// @returns IP_CONST_DAMAGETYPE_BLUDGEONING, _PIERCING or _SLASHING;
///     -1 when the item has no physical weapon type.
int CnrProp_GetWeaponPhysicalType(object oItem);

/// @brief The opposite physical damage type: piercing -> slashing ->
///     bludgeoning -> piercing.
/// @param iDamageType An IP_CONST_DAMAGETYPE_* physical type.
/// @returns The opposite type, or MAGICAL when the input is not physical.
int CnrProp_GetOppositePhysical(int iDamageType);

/// @brief The physical damage a weapon does not already deal.
/// @param oItem The weapon.
/// @returns An IP_CONST_DAMAGETYPE_* value, or -1 when it is not a weapon.
int CnrProp_GetOppositeDamage(object oItem);

/// @brief Translate a property row into an IP_CONST_DAMAGEBONUS_* constant.
///     value2 carries a die size (4, 6, 8, 10, 12), 20 meaning 2d6, or 0 to
///     use value1 directly as the constant.
/// @param iVal1 value1 column.
/// @param iVal2 value2 column.
/// @returns The damage bonus constant, or -1 when value2 matches nothing.
int CnrProp_DamageAmount(int iVal1, int iVal2);

/// @brief How many properties the item carries right now.
/// @param oItem Item to count.
/// @returns The number of item properties on it, zero included.
int CnrProp_CountProperties(object oItem);

/// @brief Apply one property row to an item.
/// @param oItem Item to modify.
/// @param sType propertyType column.
/// @param iSubtype subtype column.
/// @param iVal1 value1 column.
/// @param iVal2 value2 column.
/// @returns TRUE when the item really gained a property, FALSE when nothing
///     was added. Three different things end in FALSE and the caller cannot
///     tell them apart, nor does it need to: an unsupported propertyType, a
///     constructor that returned an invalid property, and an AddItemProperty
///     the engine refused because itemprops.2da does not allow that property
///     on that base item - a bow will not take an on-hit, ammunition will not
///     take Keen. Only the last one is invisible from inside this function,
///     which is why the answer is measured on the item rather than deduced.
int CnrProp_Apply(object oItem, string sType, int iSubtype, int iVal1, int iVal2);

// -----------------------------------------------------------------------------
//                             Function Definitions
// -----------------------------------------------------------------------------

int CnrProp_GetWeaponPhysicalType(object oItem)
{
    // baseitems.2da column WeaponType:
    //   1 piercing, 2 bludgeoning, 3 slashing,
    //   4 piercing/slashing, 5 bludgeoning/piercing.
    //   0 or **** means it is not a weapon with a physical type.
    string sWeaponType = Get2DAString("baseitems", "WeaponType",
                                      GetBaseItemType(oItem));
    if (sWeaponType == "")
    {
        return -1;
    }

    switch (StringToInt(sWeaponType))
    {
        case 1: return IP_CONST_DAMAGETYPE_PIERCING;
        case 2: return IP_CONST_DAMAGETYPE_BLUDGEONING;
        case 3: return IP_CONST_DAMAGETYPE_SLASHING;
        // Dual types: the first one the 2da declares is used.
        case 4: return IP_CONST_DAMAGETYPE_PIERCING;
        case 5: return IP_CONST_DAMAGETYPE_BLUDGEONING;
    }

    return -1;
}

int CnrProp_GetOppositeDamage(object oItem)
{
    // What damage type to add to a weapon so it is not more of what it already
    // does. baseitems.2da, column WeaponType:
    //   1 piercing, 2 bludgeoning, 3 slashing,
    //   4 piercing and slashing, 5 bludgeoning and piercing.
    //
    // With one type it rotates: slashing -> bludgeoning -> piercing ->
    // slashing. With two it gives the third, the one the weapon lacks, which
    // is the whole point: a short sword already pierces and slashes, so adding
    // slashing to it adds nothing.
    string sWeaponType = Get2DAString("baseitems", "WeaponType",
                                      GetBaseItemType(oItem));
    if (sWeaponType == "")
    {
        return -1;
    }

    switch (StringToInt(sWeaponType))
    {
        case 1: return IP_CONST_DAMAGETYPE_SLASHING;      // pierces
        case 2: return IP_CONST_DAMAGETYPE_PIERCING;      // bludgeons
        case 3: return IP_CONST_DAMAGETYPE_BLUDGEONING;   // slashes
        case 4: return IP_CONST_DAMAGETYPE_BLUDGEONING;   // pierces + slashes
        case 5: return IP_CONST_DAMAGETYPE_SLASHING;      // bludgeons + pierces
    }

    // Ammunition carries no WeaponType - the 2da leaves the column at 0,
    // because what it hits with belongs to the launcher. It still deals a
    // physical type of its own, so the same rotation applies to that: an arrow
    // and a bolt pierce, a bullet bludgeons.
    switch (GetBaseItemType(oItem))
    {
        case BASE_ITEM_ARROW:  return IP_CONST_DAMAGETYPE_SLASHING;
        case BASE_ITEM_BOLT:   return IP_CONST_DAMAGETYPE_SLASHING;
        case BASE_ITEM_BULLET: return IP_CONST_DAMAGETYPE_PIERCING;
    }

    return -1;
}

int CnrProp_GetOppositePhysical(int iDamageType)
{
    if (iDamageType == IP_CONST_DAMAGETYPE_SLASHING)
        return IP_CONST_DAMAGETYPE_BLUDGEONING;
    else if (iDamageType == IP_CONST_DAMAGETYPE_BLUDGEONING)
        return IP_CONST_DAMAGETYPE_PIERCING;
    else if (iDamageType == IP_CONST_DAMAGETYPE_PIERCING)
        return IP_CONST_DAMAGETYPE_SLASHING;

    return IP_CONST_DAMAGETYPE_MAGICAL;
}

int CnrProp_DamageAmount(int iVal1, int iVal2)
{
    switch (iVal2)
    {
        case 4:  return IP_CONST_DAMAGEBONUS_1d4;
        case 6:  return IP_CONST_DAMAGEBONUS_1d6;
        case 8:  return IP_CONST_DAMAGEBONUS_1d8;
        case 10: return IP_CONST_DAMAGEBONUS_1d10;
        case 12: return IP_CONST_DAMAGEBONUS_1d12;
        case 20: return IP_CONST_DAMAGEBONUS_2d6;
        // value2 = 0: value1 already is the IP_CONST_DAMAGEBONUS_* constant.
        case 0:  return iVal1;
    }

    return -1;
}

/// @brief Apply one property row to an item.
/// @param oItem Item to modify.
/// @param sType propertyType column.
/// @param iSubtype subtype column.
/// @param iVal1 value1 column.
/// @param iVal2 value2 column.
int CnrProp_CountProperties(object oItem)
{
    int iCount = 0;
    itemproperty ip = GetFirstItemProperty(oItem);
    while (GetIsItemPropertyValid(ip))
    {
        iCount++;
        ip = GetNextItemProperty(oItem);
    }
    return iCount;
}

int CnrProp_Apply(object oItem, string sType, int iSubtype, int iVal1, int iVal2)
{
    itemproperty ip;
    int bHandled = TRUE;
    // Counted before and after, because AddItemProperty is void and the engine
    // drops a property the base item may not carry without saying so. Asking
    // the item is the only answer that covers that case as well as ours.
    int iBefore = CnrProp_CountProperties(oItem);

    if (sType == "DamageBonus")
    {
        int iAmount = CnrProp_DamageAmount(iVal1, iVal2);
        if (iAmount >= 0)
            ip = ItemPropertyDamageBonus(iSubtype, iAmount);
        else
            bHandled = FALSE;
    }
    else if (sType == "DamageBonusOpposite")
    {
        int iOpposite = CnrProp_GetOppositeDamage(oItem);
        int iAmount   = CnrProp_DamageAmount(iVal1, iVal2);
        if (iOpposite >= 0 && iAmount >= 0)
            ip = ItemPropertyDamageBonus(iOpposite, iAmount);
        else
            bHandled = FALSE;
    }
    else if (sType == "DamageBonusVsRace")
        ip = ItemPropertyDamageBonusVsRace(iSubtype, iVal1, iVal2);
    else if (sType == "DamageBonusVsAlign")
        ip = ItemPropertyDamageBonusVsAlign(iSubtype, iVal1, iVal2);
    else if (sType == "EnhancementBonus")
        ip = ItemPropertyEnhancementBonus(iVal1);
    else if (sType == "EnhancementBonusVsRace")
        ip = ItemPropertyEnhancementBonusVsRace(iSubtype, iVal1);
    else if (sType == "EnhancementBonusVsAlign")
        ip = ItemPropertyEnhancementBonusVsAlign(iSubtype, iVal1);
    else if (sType == "ACBonus")
        ip = ItemPropertyACBonus(iVal1);
    else if (sType == "ACBonusVsRace")
        ip = ItemPropertyACBonusVsRace(iSubtype, iVal1);
    else if (sType == "ACBonusVsAlign")
        ip = ItemPropertyACBonusVsAlign(iSubtype, iVal1);
    else if (sType == "DamageImmunity")
        ip = ItemPropertyDamageImmunity(iSubtype, iVal1);
    else if (sType == "SavingThrowBonusVs")
        ip = ItemPropertyBonusSavingThrowVsX(iSubtype, iVal1);
    else if (sType == "SpellFailure")
        ip = ItemPropertyArcaneSpellFailure(iVal1);
    else if (sType == "SpellResistance")
        ip = ItemPropertyBonusSpellResistance(iVal1);
    else if (sType == "Regeneration")
        ip = ItemPropertyRegeneration(iVal1);
    else if (sType == "VampiricRegeneration")
        ip = ItemPropertyVampiricRegeneration(iVal1);
    else if (sType == "Keen")
        ip = ItemPropertyKeen();
    else if (sType == "Stun")
        ip = ItemPropertyOnHitProps(IP_CONST_ONHIT_STUN, iVal1);
    else if (sType == "Silence")
        ip = ItemPropertyOnHitProps(IP_CONST_ONHIT_SILENCE, iVal1);
    else if (sType == "Mighty")
        ip = ItemPropertyMaxRangeStrengthMod(iVal1);
    else if (sType == "AttackBonus")
        ip = ItemPropertyAttackBonus(iVal1);
    else if (sType == "MassiveCriticals")
    {
        int iMasivo = CnrProp_DamageAmount(iVal1, iVal2);
        if (iMasivo >= 0)
            ip = ItemPropertyMassiveCritical(iMasivo);
        else
            bHandled = FALSE;
    }
    else if (sType == "OnHitSlow")
        ip = ItemPropertyOnHitProps(IP_CONST_ONHIT_SLOW, iVal1);
    // --- Anadidas para arcano. NWN las soporta y el generador de loot ya las
    // --- usa (pb_tesoros_inc.nss:1425 y :1537); faltaban aqui.
    else if (sType == "SkillBonus")
        // iSubtype es SKILL_*, que en este servidor son las filas 0-27 de
        // skills.2da. Las propias del servidor, 28-38, no tienen fila en
        // iprp_skills.2da y no pueden llevar bono de objeto.
        ip = ItemPropertySkillBonus(iSubtype, iVal1);
    else if (sType == "AbilityBonus")
        ip = ItemPropertyAbilityBonus(iSubtype, iVal1);
    else if (sType == "SavingThrowBonus")
        // Bono a la tirada entera: iSubtype es IP_CONST_SAVEBASETYPE_*
        // (Fortaleza 1, Voluntad 2, Reflejos 3). Distinto de
        // SavingThrowBonusVs, que va contra un elemento.
        ip = ItemPropertyBonusSavingThrow(iSubtype, iVal1);
    // Efectos al golpear. iVal1 es el indice de CD (IP_CONST_ONHIT_SAVEDC_*,
    // CD 14 es 0) y iVal2 el parametro especifico de cada efecto.
    else if (sType == "OnHitPoison")
        ip = ItemPropertyOnHitProps(IP_CONST_ONHIT_ITEMPOISON, iVal1, iVal2);
    else if (sType == "OnHitWounding")
        ip = ItemPropertyOnHitProps(IP_CONST_ONHIT_WOUNDING, iVal1, iVal2);
    else if (sType == "OnHitHold")
        ip = ItemPropertyOnHitProps(IP_CONST_ONHIT_HOLD, iVal1, iVal2);
    else if (sType == "OnHitDeafness")
        ip = ItemPropertyOnHitProps(IP_CONST_ONHIT_DEAFNESS, iVal1, iVal2);
    else if (sType == "OnHitConfusion")
        ip = ItemPropertyOnHitProps(IP_CONST_ONHIT_CONFUSION, iVal1, iVal2);
    else if (sType == "OnHitSleep")
        ip = ItemPropertyOnHitProps(IP_CONST_ONHIT_SLEEP, iVal1, iVal2);
    else if (sType == "OnHitFear")
        ip = ItemPropertyOnHitProps(IP_CONST_ONHIT_FEAR, iVal1, iVal2);
    else if (sType == "Light")
        // iVal1 es IP_CONST_LIGHTBRIGHTNESS_*, iVal2 IP_CONST_LIGHTCOLOR_*.
        ip = ItemPropertyLight(iVal1, iVal2);
    else if (sType == "DamageReduction")
        // iSubtype es el refuerzo que hace falta para atravesarla
        // (IP_CONST_DAMAGEREDUCTION_*, +1 es 0) y iVal1 el dano absorbido.
        ip = ItemPropertyDamageReduction(iSubtype, iVal1);
    else if (sType == "WeightReduction")
        ip = ItemPropertyWeightReduction(iVal1);
    else if (sType == "BonusLevelSpell")
    {
        // iVal2 is how many slots at iVal1, not how many consecutive levels:
        // "Esfera 4/2" is two fourth-sphere slots. A gem that grants different
        // spheres carries one row per sphere instead.
        int i;
        for (i = 0; i < iVal2; i++)
        {
            ip = ItemPropertyBonusLevelSpell(iSubtype, iVal1);
            if (GetIsItemPropertyValid(ip))
                AddItemProperty(DURATION_TYPE_PERMANENT, ip, oItem);
        }
        bHandled = FALSE;
    }
    else
    {
        PrintString("[CNR] propertyType sin soporte: " + sType);
        bHandled = FALSE;
    }

    if (bHandled && GetIsItemPropertyValid(ip))
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, ip, oItem);
    }

    return CnrProp_CountProperties(oItem) > iBefore;
}
