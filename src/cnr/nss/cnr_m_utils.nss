/// ----
/// @system CNR_CRAFTING
/// @file cnr_masterwork_utils.nss
/// @author Dhraax
/// @brief Utilidades para aplicar lógica de obra maestra (masterwork) en objetos forjados.
/// ----

#include "x2_inc_itemprop"

// -----
//                              Function Prototypes
// -----

/// @brief Aplica la lógica de obra maestra para adamantita en herrería.
/// @param oItem El objeto forjado
/// @param sTipo El tipo de objeto ("Arma", "Armadura", "Escudo", "Casco")
/// @param oPC El jugador que forja
/// @returns TRUE si fue obra maestra, FALSE si no
int MasterworkApplyAdamantite(object oItem, string sTipo, object oPC);

/// @brief Aplica la lógica de obra maestra para joyería engarzada.
/// @param oItem El objeto de joyería
/// @param sGemTag El tag de la gema engarzada (ej: bru_cuarzo)
/// @param oPC El jugador que engarza
/// @returns TRUE si fue obra maestra, FALSE si no
int MasterworkApplyJewelry(object oItem, string sGemTag, object oPC);

// -----
//                             Function Definitions
// -----

int MasterworkApplyAdamantite(object oItem, string sTipo, object oPC)
{
    int iFeatHerreria = 1919; // FEAT_HAB_HERRAMIENTA_ARTESANIA_HERRERIA
    if (!GetHasFeat(iFeatHerreria, oPC))
    {
        return FALSE;
    }
    int bApplied = FALSE;
    if (sTipo == "Arma")
    {
        itemproperty ip = GetFirstItemProperty(oItem);
        while (GetIsItemPropertyValid(ip))
        {
            if (GetItemPropertyType(ip) == ITEM_PROPERTY_ATTACK_BONUS && GetItemPropertyCostTableValue(ip) == 5)
            {
                RemoveItemProperty(oItem, ip);
                AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyAttackBonus(6), oItem);
                bApplied = TRUE;
                break;
            }
            ip = GetNextItemProperty(oItem);
        }
    }
    else if (sTipo == "Armadura" || sTipo == "Escudo" || sTipo == "Casco")
    {
        itemproperty ip = GetFirstItemProperty(oItem);
        while (GetIsItemPropertyValid(ip))
        {
            if (GetItemPropertyType(ip) == ITEM_PROPERTY_AC_BONUS && GetItemPropertyCostTableValue(ip) == 5)
            {
                RemoveItemProperty(oItem, ip);
                AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonus(6), oItem);
                bApplied = TRUE;
                break;
            }
            ip = GetNextItemProperty(oItem);
        }
    }
    if (bApplied)
    {
        SendMessageToPC(oPC, "¡Has creado una obra maestra de adamantita!");
        return TRUE;
    }
    return FALSE;
}

int MasterworkApplyJewelry(object oItem, string sGemTag, object oPC)
{
    if (GetLocalInt(oItem, "MASTERWORK_ENGARCE") == 1)
    {
        return FALSE;
    }
    SetLocalInt(oItem, "MASTERWORK_ENGARCE", 1); // Es obra maestra
    // Aplicar propiedad especial según la gema
    if (sGemTag == "bru_cuarzo")
    {
        if (4 >= SAVING_THROW_ALL && 4 <= SAVING_THROW_WILL)
        {
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusSavingThrow(4, 5), oItem);
        }
        else
        {
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusSavingThrowVsX(4, 5), oItem);
        }
    }
    else if (sGemTag == "bru_obs")
    {
        if (2 >= SAVING_THROW_ALL && 2 <= SAVING_THROW_WILL)
        {
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusSavingThrow(2, 5), oItem);
        }
        else
        {
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusSavingThrowVsX(2, 5), oItem);
        }
    }
    else if (sGemTag == "bru_top")
    {
        if (4 >= SAVING_THROW_ALL && 4 <= SAVING_THROW_WILL)
        {
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusSavingThrow(4, 5), oItem);
        }
        else
        {
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusSavingThrowVsX(4, 5), oItem);
        }
    }
    else if (sGemTag == "bru_per")
    {
        if (3 >= SAVING_THROW_ALL && 3 <= SAVING_THROW_WILL)
        {
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusSavingThrow(3, 5), oItem);
        }
        else
        {
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusSavingThrowVsX(3, 5), oItem);
        }
    }
    else if (sGemTag == "bru_aza")
    {
        if (8 >= SAVING_THROW_ALL && 8 <= SAVING_THROW_WILL)
        {
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusSavingThrow(8, 5), oItem);
        }
        else
        {
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusSavingThrowVsX(8, 5), oItem);
        }
    }
    else if (sGemTag == "bru_jade")
    {
        // Conjuro Bardo Esfera 7 /2
        int i;
        for (i = 0; i < 2; i++)
        {
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusLevelSpell(CLASS_TYPE_BARD, 7), oItem);
        }
    }
    else if (sGemTag == "bru_opalo")
    {
        // Conjuro Hechicero Esfera 8/2
        int i;
        for (i = 0; i < 2; i++)
        {
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusLevelSpell(CLASS_TYPE_SORCERER, 8), oItem);
        }
    }
    else if (sGemTag == "bru_lagrima_roja")
    {
        // Conjuro Druida Esfera 8/2
        int i;
        for (i = 0; i < 2; i++)
        {
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusLevelSpell(CLASS_TYPE_DRUID, 8), oItem);
        }
    }
    else if (sGemTag == "bru_opalo_negro")
    {
        // Conjuro Clérigo Esfera 8/2
        int i;
        for (i = 0; i < 2; i++)
        {
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusLevelSpell(CLASS_TYPE_CLERIC, 8), oItem);
        }
    }
    else if (sGemTag == "bru_orblen")
    {
        // Conjuro Mago Esfera 8/2
        int i;
        for (i = 0; i < 2; i++)
        {
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusLevelSpell(CLASS_TYPE_WIZARD, 8), oItem);
        }
    }
    else if (sGemTag == "bru_opalo_fuego")
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageImmunity(DAMAGE_TYPE_FIRE, 50), oItem); // Inmune Fuego 50% (aprox)
    }
    else if (sGemTag == "bru_corvidar")
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageImmunity(DAMAGE_TYPE_ACID, 50), oItem); // Inmune Ácido 50% (aprox)
    }
    else if (sGemTag == "bru_beljuril")
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageImmunity(DAMAGE_TYPE_ELECTRICAL, 50), oItem); // Inmune Eléctrico 50% (aprox)
    }
    else if (sGemTag == "bru_orlo")
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageImmunity(DAMAGE_TYPE_COLD, 50), oItem); // Inmune Frío 50% (aprox)
    }
    else if (sGemTag == "bru_zafiro")
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_24), oItem);
    }
    else if (sGemTag == "bru_opalo_agua")
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageImmunity(DAMAGE_TYPE_SLASHING, 25), oItem); // Inmunidad Cortante 25% (aprox)
    }
    else if (sGemTag == "bru_zendalur")
    {
        if (7 >= SAVING_THROW_ALL && 7 <= SAVING_THROW_WILL)
        {
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusSavingThrow(7, 5), oItem);
        }
        else
        {
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusSavingThrowVsX(7, 5), oItem);
        }
    }
    else if (sGemTag == "bru_barra_lunar")
    {
        if (6 >= SAVING_THROW_ALL && 6 <= SAVING_THROW_WILL)
        {
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusSavingThrow(6, 5), oItem);
        }
        else
        {
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusSavingThrowVsX(6, 5), oItem);
        }
    }
    else if (sGemTag == "bru_jacinto")
    {
        // Conjuro Druida Esfera 9/2
        int i;
        for (i = 0; i < 2; i++)
        {
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusLevelSpell(CLASS_TYPE_DRUID, 9), oItem);
        }
    }
    else if (sGemTag == "bru_amarazha")
    {
        // Conjuro Mago Esfera 6/2
        int i;
        for (i = 0; i < 2; i++)
        {
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusLevelSpell(CLASS_TYPE_WIZARD, 6), oItem);
        }
    }
    else if (sGemTag == "bru_piedra_picara")
    {
        // Conjuro Bardo Esfera 8/2
        int i;
        for (i = 0; i < 2; i++)
        {
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusLevelSpell(CLASS_TYPE_BARD, 8), oItem);
        }
    }
    else if (sGemTag == "bru_esme")
    {
        // Conjuro Hechicero Esfera 9/2
        int i;
        for (i = 0; i < 2; i++)
        {
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusLevelSpell(CLASS_TYPE_SORCERER, 9), oItem);
        }
    }
    else if (sGemTag == "bru_zafiro_negro")
    {
        // Conjuro Clérigo Esfera 9/2
        int i;
        for (i = 0; i < 2; i++)
        {
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusLevelSpell(CLASS_TYPE_CLERIC, 9), oItem);
        }
    }
    else if (sGemTag == "bru_diamante")
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonus(6), oItem);
    }
    else if (sGemTag == "bru_rubi")
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageImmunity(DAMAGE_TYPE_SLASHING, 30), oItem); // Inmunidad Cortante 30% (aprox)
    }
    else if (sGemTag == "bru_lagrima_rey")
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyRegeneration(3), oItem);
    }
    else if (sGemTag == "bru_zafiro_estrella")
    {
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonus(6), oItem);
    }
    else if (sGemTag == "bru_rubi_estrella")
    {
        if (0 >= SAVING_THROW_ALL && 0 <= SAVING_THROW_WILL)
        {
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusSavingThrow(0, 3), oItem);
        }
        else
        {
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusSavingThrowVsX(0, 3), oItem);
        }
    }
    SendMessageToPC(oPC, "¡Has realizado un engarce de obra maestra!");
    return TRUE;
}