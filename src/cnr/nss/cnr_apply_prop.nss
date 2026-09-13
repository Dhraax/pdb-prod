/// ----------------------------------------------------------------------------
/// @system  CNR Crafting
/// @file    cnr_apply_prop
/// @author  Dhraax
/// @brief   Applies one item property row to OBJECT_SELF. Called per row so the
///          SQL result set is not held open while the engine works.
/// modified by: Dhraax
/// ----------------------------------------------------------------------------

#include "cnr_i_prop"

void main()
{
    object oItem = OBJECT_SELF;

    string sType = GetLocalString(oItem, "CNR_PROP_TYPE");
    int iSubtype = GetLocalInt(oItem, "CNR_PROP_SUBTYPE");
    int iVal1    = GetLocalInt(oItem, "CNR_PROP_VALUE1");
    int iVal2    = GetLocalInt(oItem, "CNR_PROP_VALUE2");

    DeleteLocalString(oItem, "CNR_PROP_TYPE");
    DeleteLocalInt(oItem, "CNR_PROP_SUBTYPE");
    DeleteLocalInt(oItem, "CNR_PROP_VALUE1");
    DeleteLocalInt(oItem, "CNR_PROP_VALUE2");

    if (sType == "")
    {
        return;
    }

    itemproperty ip;
    int bHandled = TRUE;

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
}
