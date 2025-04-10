//::///////////////////////////////////////////////
//:: Project Q Cursed Items fuction library
//:: q_inc_CurseProps.nss
//:://////////////////////////////////////////////
/*
    Culled from NwnE.

    The functions within this library create dynamic cursed
    items.

    The properties are determined randomly the first time that
    an item with the int variable "IS_CURSED" = TRUE is
    equipped.

    Alternatively, the Builder can create template cursed items
    with the tag GetTag(oItem)+"_CURSED" and place them within
    a special container with the tag "CURSE_MAKER"

    When the PC equips an item which has a corresponding template
    within the CURSE_MAKER container, the properties from the
    template are copied over to the equipped item.
*/
//:://////////////////////////////////////////////
//:: Created By: Pstemarie
//:: Created On: August 14, 2012
//:://////////////////////////////////////////////

#include "x2_inc_itemprop"

void ci_RemoveAllNonRestrictiveItemProperties(object oItem)
{
    int nIndex = 0;
    int bRemove = TRUE;
    itemproperty iProp = GetFirstItemProperty(oItem);

    // Remove all non-restrictive item properties
    while (GetIsItemPropertyValid(iProp))
    {
        int nPropType = GetItemPropertyType(iProp);
        switch (nPropType)
        {
            case ITEM_PROPERTY_USE_LIMITATION_ALIGNMENT_GROUP:
            case ITEM_PROPERTY_USE_LIMITATION_CLASS:
            case ITEM_PROPERTY_USE_LIMITATION_RACIAL_TYPE:
            case ITEM_PROPERTY_USE_LIMITATION_SPECIFIC_ALIGNMENT:
            case ITEM_PROPERTY_USE_LIMITATION_TILESET:
            case 88/*ITEM_PROPERTY_USE_LIMITATION_GENDER*/:

                bRemove = FALSE;

            break;
        }

        if (bRemove == TRUE)
        {
            RemoveItemProperty(oItem, iProp);
            nIndex ++;
        }
        else
        {
            // Reset bRemove to TRUE for the next pass
            bRemove = TRUE;
        }
        iProp = GetNextItemProperty(oItem);
    }
    SetLocalInt(oItem, "NUMBER_PROPS_REMOVED", nIndex);
}

void ci_AddMeleeThrownGloveProps(object oItem)
{
    // Remove old item properties
    ci_RemoveAllNonRestrictiveItemProperties(oItem);

    itemproperty iProp;
    int nIndex = GetLocalInt(oItem, "NUMBER_PROPS_REMOVED");
    DeleteLocalInt(oItem, "NUMBER_PROPS_REMOVED");
    while (nIndex > 0)
    {
        int nRoll = Random(7);
        switch (nRoll)
        {
            case 0: iProp = ItemPropertyAttackPenalty(Random(5)+1); break;
            case 1: iProp = ItemPropertyDamagePenalty(Random(5)+1); break;

            case 2:
            {
                int nDamType, nPercent;
                switch (Random(14))
                {
                    case 0: nDamType = IP_CONST_DAMAGETYPE_ACID; break;
                    case 1: nDamType = IP_CONST_DAMAGETYPE_BLUDGEONING; break;
                    case 2: nDamType = IP_CONST_DAMAGETYPE_COLD; break;
                    case 3: nDamType = IP_CONST_DAMAGETYPE_DIVINE; break;
                    case 4: nDamType = IP_CONST_DAMAGETYPE_ELECTRICAL; break;
                    case 5: nDamType = IP_CONST_DAMAGETYPE_FIRE; break;
                    case 6: nDamType = IP_CONST_DAMAGETYPE_MAGICAL; break;
                    case 7: nDamType = IP_CONST_DAMAGETYPE_NEGATIVE; break;
                    case 8: nDamType = IP_CONST_DAMAGETYPE_PHYSICAL; break;
                    case 9: nDamType = IP_CONST_DAMAGETYPE_PIERCING; break;
                    case 10: nDamType = IP_CONST_DAMAGETYPE_POSITIVE; break;
                    case 11: nDamType = IP_CONST_DAMAGETYPE_SLASHING; break;
                    case 12: nDamType = IP_CONST_DAMAGETYPE_SONIC; break;
                    case 13: nDamType = IP_CONST_DAMAGETYPE_SUBDUAL; break;
                }

                switch (Random(7))
                {
                    case 0: nPercent = IP_CONST_DAMAGEVULNERABILITY_5_PERCENT; break;
                    case 1: nPercent = IP_CONST_DAMAGEVULNERABILITY_10_PERCENT; break;
                    case 2: nPercent = IP_CONST_DAMAGEVULNERABILITY_25_PERCENT; break;
                    case 3: nPercent = IP_CONST_DAMAGEVULNERABILITY_50_PERCENT; break;
                    case 4: nPercent = IP_CONST_DAMAGEVULNERABILITY_75_PERCENT; break;
                    case 5: nPercent = IP_CONST_DAMAGEVULNERABILITY_90_PERCENT; break;
                    case 6: nPercent = IP_CONST_DAMAGEVULNERABILITY_100_PERCENT; break;
                }
                iProp = ItemPropertyDamageVulnerability(nDamType, nPercent);
            }
            break;

            case 3:
            {
                int nAbility;
                switch (d6())
                {
                    case 1: nAbility = ABILITY_CHARISMA; break;
                    case 2: nAbility = ABILITY_CONSTITUTION; break;
                    case 3: nAbility = ABILITY_DEXTERITY; break;
                    case 4: nAbility = ABILITY_INTELLIGENCE; break;
                    case 5: nAbility = ABILITY_STRENGTH; break;
                    case 6: nAbility = ABILITY_WISDOM; break;
                }
                iProp = ItemPropertyDecreaseAbility(nAbility, d10());
            }
            break;

            case 4:
            {
                int nModifierType;
                switch (Random(5))
                {
                    case 0: nModifierType = IP_CONST_ACMODIFIERTYPE_ARMOR; break;
                    case 1: nModifierType = IP_CONST_ACMODIFIERTYPE_DEFLECTION; break;
                    case 2: nModifierType = IP_CONST_ACMODIFIERTYPE_DODGE; break;
                    case 3: nModifierType = IP_CONST_ACMODIFIERTYPE_NATURAL; break;
                    case 4: nModifierType = IP_CONST_ACMODIFIERTYPE_SHIELD; break;
                }
                iProp = ItemPropertyDecreaseAC(nModifierType, Random(5)+1);
            }
            break;

            case 5:
            {
                int nSkill;
                switch (Random(29))
                {
                    case 0: nSkill = SKILL_ALL_SKILLS; break;
                    case 1: nSkill = SKILL_ANIMAL_EMPATHY; break;
                    case 2: nSkill = SKILL_APPRAISE; break;
                    case 3: nSkill = SKILL_BLUFF; break;
                    case 4: nSkill = SKILL_CONCENTRATION; break;
                    case 5: nSkill = SKILL_CRAFT_ARMOR; break;
                    case 6: nSkill = SKILL_CRAFT_TRAP; break;
                    case 7: nSkill = SKILL_CRAFT_WEAPON; break;
                    case 8: nSkill = SKILL_DISABLE_TRAP; break;
                    case 9: nSkill = SKILL_DISCIPLINE; break;
                    case 10: nSkill = SKILL_HEAL; break;
                    case 11: nSkill = SKILL_HIDE; break;
                    case 12: nSkill = SKILL_INTIMIDATE; break;
                    case 13: nSkill = SKILL_LISTEN; break;
                    case 14: nSkill = SKILL_LORE; break;
                    case 15: nSkill = SKILL_MOVE_SILENTLY; break;
                    case 16: nSkill = SKILL_OPEN_LOCK; break;
                    case 17: nSkill = SKILL_PARRY; break;
                    case 18: nSkill = SKILL_PERFORM; break;
                    case 19: nSkill = SKILL_PERSUADE; break;
                    case 20: nSkill = SKILL_PICK_POCKET; break;
                    case 21: nSkill = SKILL_RIDE; break;
                    case 22: nSkill = SKILL_SEARCH; break;
                    case 23: nSkill = SKILL_SET_TRAP; break;
                    case 24: nSkill = SKILL_SPELLCRAFT; break;
                    case 25: nSkill = SKILL_SPOT; break;
                    case 26: nSkill = SKILL_TAUNT; break;
                    case 27: nSkill = SKILL_TUMBLE; break;
                    case 28: nSkill = SKILL_USE_MAGIC_DEVICE; break;
                }
                iProp = ItemPropertyDecreaseSkill(nSkill, d10());
            }
            break;

            case 6: iProp = ItemPropertyNoDamage(); break;

            case 7:
            {
                int nSaveType;
                switch (d3())
                {
                    case 1: nSaveType = IP_CONST_SAVEBASETYPE_FORTITUDE; break;
                    case 2: nSaveType = IP_CONST_SAVEBASETYPE_REFLEX; break;
                    case 3: nSaveType = IP_CONST_SAVEBASETYPE_WILL; break;
                }
                iProp = ItemPropertyReducedSavingThrow(nSaveType, d20());
            }
            break;

            case 8:
            {
                int nSaveType;
                switch (d3())
                {
                    case 0: nSaveType = IP_CONST_SAVEVS_UNIVERSAL; break;
                    case 1: nSaveType = IP_CONST_SAVEVS_ACID; break;
                    case 2: nSaveType = IP_CONST_SAVEVS_COLD; break;
                    case 3: nSaveType = IP_CONST_SAVEVS_DEATH; break;
                    case 4: nSaveType = IP_CONST_SAVEVS_DISEASE; break;
                    case 5: nSaveType = IP_CONST_SAVEVS_DIVINE; break;
                    case 6: nSaveType = IP_CONST_SAVEVS_ELECTRICAL; break;
                    case 7: nSaveType = IP_CONST_SAVEVS_FEAR; break;
                    case 8: nSaveType = IP_CONST_SAVEVS_FIRE; break;
                    case 9: nSaveType = IP_CONST_SAVEVS_DEATH; break;
                    case 10: nSaveType = IP_CONST_SAVEVS_MINDAFFECTING; break;
                    case 11: nSaveType = IP_CONST_SAVEVS_NEGATIVE; break;
                    case 12: nSaveType = IP_CONST_SAVEVS_POISON; break;
                    case 13: nSaveType = IP_CONST_SAVEVS_POSITIVE; break;
                    case 14: nSaveType = IP_CONST_SAVEVS_SONIC; break;
                }
                iProp = ItemPropertyReducedSavingThrowVsX(nSaveType, d20());
            }
            break;
        }

        IPSafeAddItemProperty(oItem, iProp, 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, TRUE, TRUE);
        nIndex --;
    }
}

void ci_AddRangedProps(object oItem)
{
    // Remove old item properties
    ci_RemoveAllNonRestrictiveItemProperties(oItem);

    itemproperty iProp;
    int nIndex = GetLocalInt(oItem, "NUMBER_PROPS_REMOVED");
    DeleteLocalInt(oItem, "NUMBER_PROPS_REMOVED");
    while (nIndex > 0)
    {
        int nRoll = Random(9);
        switch (nRoll)
        {
            case 0:
            {
                int nDamType, nPercent;
                switch (Random(14))
                {
                    case 0: nDamType = IP_CONST_DAMAGETYPE_ACID; break;
                    case 1: nDamType = IP_CONST_DAMAGETYPE_BLUDGEONING; break;
                    case 2: nDamType = IP_CONST_DAMAGETYPE_COLD; break;
                    case 3: nDamType = IP_CONST_DAMAGETYPE_DIVINE; break;
                    case 4: nDamType = IP_CONST_DAMAGETYPE_ELECTRICAL; break;
                    case 5: nDamType = IP_CONST_DAMAGETYPE_FIRE; break;
                    case 6: nDamType = IP_CONST_DAMAGETYPE_MAGICAL; break;
                    case 7: nDamType = IP_CONST_DAMAGETYPE_NEGATIVE; break;
                    case 8: nDamType = IP_CONST_DAMAGETYPE_PHYSICAL; break;
                    case 9: nDamType = IP_CONST_DAMAGETYPE_PIERCING; break;
                    case 10: nDamType = IP_CONST_DAMAGETYPE_POSITIVE; break;
                    case 11: nDamType = IP_CONST_DAMAGETYPE_SLASHING; break;
                    case 12: nDamType = IP_CONST_DAMAGETYPE_SONIC; break;
                    case 13: nDamType = IP_CONST_DAMAGETYPE_SUBDUAL; break;
                }

                switch (Random(7))
                {
                    case 0: nPercent = IP_CONST_DAMAGEVULNERABILITY_5_PERCENT; break;
                    case 1: nPercent = IP_CONST_DAMAGEVULNERABILITY_10_PERCENT; break;
                    case 2: nPercent = IP_CONST_DAMAGEVULNERABILITY_25_PERCENT; break;
                    case 3: nPercent = IP_CONST_DAMAGEVULNERABILITY_50_PERCENT; break;
                    case 4: nPercent = IP_CONST_DAMAGEVULNERABILITY_75_PERCENT; break;
                    case 5: nPercent = IP_CONST_DAMAGEVULNERABILITY_90_PERCENT; break;
                    case 6: nPercent = IP_CONST_DAMAGEVULNERABILITY_100_PERCENT; break;
                }
                iProp = ItemPropertyDamageVulnerability(nDamType, nPercent);
            }
            break;

            case 1:
            {
                int nAbility;
                switch (d6())
                {
                    case 1: nAbility = ABILITY_CHARISMA; break;
                    case 2: nAbility = ABILITY_CONSTITUTION; break;
                    case 3: nAbility = ABILITY_DEXTERITY; break;
                    case 4: nAbility = ABILITY_INTELLIGENCE; break;
                    case 5: nAbility = ABILITY_STRENGTH; break;
                    case 6: nAbility = ABILITY_WISDOM; break;
                }
                iProp = ItemPropertyDecreaseAbility(nAbility, d10());
            }
            break;

            case 2:
            {
                int nModifierType;
                switch (Random(5))
                {
                    case 0: nModifierType = IP_CONST_ACMODIFIERTYPE_ARMOR; break;
                    case 1: nModifierType = IP_CONST_ACMODIFIERTYPE_DEFLECTION; break;
                    case 2: nModifierType = IP_CONST_ACMODIFIERTYPE_DODGE; break;
                    case 3: nModifierType = IP_CONST_ACMODIFIERTYPE_NATURAL; break;
                    case 4: nModifierType = IP_CONST_ACMODIFIERTYPE_SHIELD; break;
                }
                iProp = ItemPropertyDecreaseAC(nModifierType, Random(5)+1);
            }
            break;

            case 3:
            {
                int nSkill;
                switch (Random(29))
                {
                    case 0: nSkill = SKILL_ALL_SKILLS; break;
                    case 1: nSkill = SKILL_ANIMAL_EMPATHY; break;
                    case 2: nSkill = SKILL_APPRAISE; break;
                    case 3: nSkill = SKILL_BLUFF; break;
                    case 4: nSkill = SKILL_CONCENTRATION; break;
                    case 5: nSkill = SKILL_CRAFT_ARMOR; break;
                    case 6: nSkill = SKILL_CRAFT_TRAP; break;
                    case 7: nSkill = SKILL_CRAFT_WEAPON; break;
                    case 8: nSkill = SKILL_DISABLE_TRAP; break;
                    case 9: nSkill = SKILL_DISCIPLINE; break;
                    case 10: nSkill = SKILL_HEAL; break;
                    case 11: nSkill = SKILL_HIDE; break;
                    case 12: nSkill = SKILL_INTIMIDATE; break;
                    case 13: nSkill = SKILL_LISTEN; break;
                    case 14: nSkill = SKILL_LORE; break;
                    case 15: nSkill = SKILL_MOVE_SILENTLY; break;
                    case 16: nSkill = SKILL_OPEN_LOCK; break;
                    case 17: nSkill = SKILL_PARRY; break;
                    case 18: nSkill = SKILL_PERFORM; break;
                    case 19: nSkill = SKILL_PERSUADE; break;
                    case 20: nSkill = SKILL_PICK_POCKET; break;
                    case 21: nSkill = SKILL_RIDE; break;
                    case 22: nSkill = SKILL_SEARCH; break;
                    case 23: nSkill = SKILL_SET_TRAP; break;
                    case 24: nSkill = SKILL_SPELLCRAFT; break;
                    case 25: nSkill = SKILL_SPOT; break;
                    case 26: nSkill = SKILL_TAUNT; break;
                    case 27: nSkill = SKILL_TUMBLE; break;
                    case 28: nSkill = SKILL_USE_MAGIC_DEVICE; break;
                }
                iProp = ItemPropertyDecreaseSkill(nSkill, d10());
            }
            break;

            case 4: iProp = ItemPropertyNoDamage(); break;

            case 5:
            {
                int nSaveType;
                switch (d3())
                {
                    case 1: nSaveType = IP_CONST_SAVEBASETYPE_FORTITUDE; break;
                    case 2: nSaveType = IP_CONST_SAVEBASETYPE_REFLEX; break;
                    case 3: nSaveType = IP_CONST_SAVEBASETYPE_WILL; break;
                }
                iProp = ItemPropertyReducedSavingThrow(nSaveType, d20());
            }
            break;

            case 6:
            {
                int nSaveType;
                switch (d3())
                {
                    case 0: nSaveType = IP_CONST_SAVEVS_UNIVERSAL; break;
                    case 1: nSaveType = IP_CONST_SAVEVS_ACID; break;
                    case 2: nSaveType = IP_CONST_SAVEVS_COLD; break;
                    case 3: nSaveType = IP_CONST_SAVEVS_DEATH; break;
                    case 4: nSaveType = IP_CONST_SAVEVS_DISEASE; break;
                    case 5: nSaveType = IP_CONST_SAVEVS_DIVINE; break;
                    case 6: nSaveType = IP_CONST_SAVEVS_ELECTRICAL; break;
                    case 7: nSaveType = IP_CONST_SAVEVS_FEAR; break;
                    case 8: nSaveType = IP_CONST_SAVEVS_FIRE; break;
                    case 9: nSaveType = IP_CONST_SAVEVS_DEATH; break;
                    case 10: nSaveType = IP_CONST_SAVEVS_MINDAFFECTING; break;
                    case 11: nSaveType = IP_CONST_SAVEVS_NEGATIVE; break;
                    case 12: nSaveType = IP_CONST_SAVEVS_POISON; break;
                    case 13: nSaveType = IP_CONST_SAVEVS_POSITIVE; break;
                    case 14: nSaveType = IP_CONST_SAVEVS_SONIC; break;
                }
                iProp = ItemPropertyReducedSavingThrowVsX(nSaveType, d20());
            }
            break;
        }

        IPSafeAddItemProperty(oItem, iProp, 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, TRUE, TRUE);
        nIndex --;
    }
}

void ci_AddAmmoProps(object oItem)
{
    // Remove old item properties
    ci_RemoveAllNonRestrictiveItemProperties(oItem);

    itemproperty iProp;
    int nIndex = GetLocalInt(oItem, "NUMBER_PROPS_REMOVED");
    DeleteLocalInt(oItem, "NUMBER_PROPS_REMOVED");
    while (nIndex > 0)
    {
        int nRoll = d100(1);
        if (nRoll < 50) iProp = ItemPropertyDamagePenalty(Random(5)+1);
        else iProp = ItemPropertyNoDamage();

        IPSafeAddItemProperty(oItem, iProp, 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, TRUE, TRUE);
        nIndex --;
    }
}

void ci_AddArmorShieldHelmMiscProps(object oItem)
{
    //Remove old props
    ci_RemoveAllNonRestrictiveItemProperties(oItem);

    itemproperty iProp;
    int nIndex = GetLocalInt(oItem, "NUMBER_PROPS_REMOVED");
    DeleteLocalInt(oItem, "NUMBER_PROPS_REMOVED");
    while (nIndex > 0)
    {
        int nRoll = d6();
        switch (nRoll)
        {
            case 1:
            {
                int nDamType, nPercent;
                switch (Random(14))
                {
                    case 0: nDamType = IP_CONST_DAMAGETYPE_ACID; break;
                    case 1: nDamType = IP_CONST_DAMAGETYPE_BLUDGEONING; break;
                    case 2: nDamType = IP_CONST_DAMAGETYPE_COLD; break;
                    case 3: nDamType = IP_CONST_DAMAGETYPE_DIVINE; break;
                    case 4: nDamType = IP_CONST_DAMAGETYPE_ELECTRICAL; break;
                    case 5: nDamType = IP_CONST_DAMAGETYPE_FIRE; break;
                    case 6: nDamType = IP_CONST_DAMAGETYPE_MAGICAL; break;
                    case 7: nDamType = IP_CONST_DAMAGETYPE_NEGATIVE; break;
                    case 8: nDamType = IP_CONST_DAMAGETYPE_PHYSICAL; break;
                    case 9: nDamType = IP_CONST_DAMAGETYPE_PIERCING; break;
                    case 10: nDamType = IP_CONST_DAMAGETYPE_POSITIVE; break;
                    case 11: nDamType = IP_CONST_DAMAGETYPE_SLASHING; break;
                    case 12: nDamType = IP_CONST_DAMAGETYPE_SONIC; break;
                    case 13: nDamType = IP_CONST_DAMAGETYPE_SUBDUAL; break;
                }

                switch (Random(7))
                {
                    case 0: nPercent = IP_CONST_DAMAGEVULNERABILITY_5_PERCENT; break;
                    case 1: nPercent = IP_CONST_DAMAGEVULNERABILITY_10_PERCENT; break;
                    case 2: nPercent = IP_CONST_DAMAGEVULNERABILITY_25_PERCENT; break;
                    case 3: nPercent = IP_CONST_DAMAGEVULNERABILITY_50_PERCENT; break;
                    case 4: nPercent = IP_CONST_DAMAGEVULNERABILITY_75_PERCENT; break;
                    case 5: nPercent = IP_CONST_DAMAGEVULNERABILITY_90_PERCENT; break;
                    case 6: nPercent = IP_CONST_DAMAGEVULNERABILITY_100_PERCENT; break;
                }
                iProp = ItemPropertyDamageVulnerability(nDamType, nPercent);
            }
            break;

            case 2:
            {
                int nAbility;
                switch (d6())
                {
                    case 1: nAbility = ABILITY_CHARISMA; break;
                    case 2: nAbility = ABILITY_CONSTITUTION; break;
                    case 3: nAbility = ABILITY_DEXTERITY; break;
                    case 4: nAbility = ABILITY_INTELLIGENCE; break;
                    case 5: nAbility = ABILITY_STRENGTH; break;
                    case 6: nAbility = ABILITY_WISDOM; break;
                }
                iProp = ItemPropertyDecreaseAbility(nAbility, d10());
            }
            break;

            case 3:
            {
                int nModifierType;
                switch (Random(5))
                {
                    case 0: nModifierType = IP_CONST_ACMODIFIERTYPE_ARMOR; break;
                    case 1: nModifierType = IP_CONST_ACMODIFIERTYPE_DEFLECTION; break;
                    case 2: nModifierType = IP_CONST_ACMODIFIERTYPE_DODGE; break;
                    case 3: nModifierType = IP_CONST_ACMODIFIERTYPE_NATURAL; break;
                    case 4: nModifierType = IP_CONST_ACMODIFIERTYPE_SHIELD; break;
                }
                iProp = ItemPropertyDecreaseAC(nModifierType, Random(5)+1);
            }
            break;

            case 4:
            {
                int nSkill;
                switch (Random(29))
                {
                    case 0: nSkill = SKILL_ALL_SKILLS; break;
                    case 1: nSkill = SKILL_ANIMAL_EMPATHY; break;
                    case 2: nSkill = SKILL_APPRAISE; break;
                    case 3: nSkill = SKILL_BLUFF; break;
                    case 4: nSkill = SKILL_CONCENTRATION; break;
                    case 5: nSkill = SKILL_CRAFT_ARMOR; break;
                    case 6: nSkill = SKILL_CRAFT_TRAP; break;
                    case 7: nSkill = SKILL_CRAFT_WEAPON; break;
                    case 8: nSkill = SKILL_DISABLE_TRAP; break;
                    case 9: nSkill = SKILL_DISCIPLINE; break;
                    case 10: nSkill = SKILL_HEAL; break;
                    case 11: nSkill = SKILL_HIDE; break;
                    case 12: nSkill = SKILL_INTIMIDATE; break;
                    case 13: nSkill = SKILL_LISTEN; break;
                    case 14: nSkill = SKILL_LORE; break;
                    case 15: nSkill = SKILL_MOVE_SILENTLY; break;
                    case 16: nSkill = SKILL_OPEN_LOCK; break;
                    case 17: nSkill = SKILL_PARRY; break;
                    case 18: nSkill = SKILL_PERFORM; break;
                    case 19: nSkill = SKILL_PERSUADE; break;
                    case 20: nSkill = SKILL_PICK_POCKET; break;
                    case 21: nSkill = SKILL_RIDE; break;
                    case 22: nSkill = SKILL_SEARCH; break;
                    case 23: nSkill = SKILL_SET_TRAP; break;
                    case 24: nSkill = SKILL_SPELLCRAFT; break;
                    case 25: nSkill = SKILL_SPOT; break;
                    case 26: nSkill = SKILL_TAUNT; break;
                    case 27: nSkill = SKILL_TUMBLE; break;
                    case 28: nSkill = SKILL_USE_MAGIC_DEVICE; break;
                }
                iProp = ItemPropertyDecreaseSkill(nSkill, d10());
            }
            break;

            case 5:
            {
                int nSaveType;
                switch (d3())
                {
                    case 1: nSaveType = IP_CONST_SAVEBASETYPE_FORTITUDE; break;
                    case 2: nSaveType = IP_CONST_SAVEBASETYPE_REFLEX; break;
                    case 3: nSaveType = IP_CONST_SAVEBASETYPE_WILL; break;
                }
                iProp = ItemPropertyReducedSavingThrow(nSaveType, d20());
            }
            break;

            case 6:
            {
                int nSaveType;
                switch (d3())
                {
                    case 0: nSaveType = IP_CONST_SAVEVS_UNIVERSAL; break;
                    case 1: nSaveType = IP_CONST_SAVEVS_ACID; break;
                    case 2: nSaveType = IP_CONST_SAVEVS_COLD; break;
                    case 3: nSaveType = IP_CONST_SAVEVS_DEATH; break;
                    case 4: nSaveType = IP_CONST_SAVEVS_DISEASE; break;
                    case 5: nSaveType = IP_CONST_SAVEVS_DIVINE; break;
                    case 6: nSaveType = IP_CONST_SAVEVS_ELECTRICAL; break;
                    case 7: nSaveType = IP_CONST_SAVEVS_FEAR; break;
                    case 8: nSaveType = IP_CONST_SAVEVS_FIRE; break;
                    case 9: nSaveType = IP_CONST_SAVEVS_DEATH; break;
                    case 10: nSaveType = IP_CONST_SAVEVS_MINDAFFECTING; break;
                    case 11: nSaveType = IP_CONST_SAVEVS_NEGATIVE; break;
                    case 12: nSaveType = IP_CONST_SAVEVS_POISON; break;
                    case 13: nSaveType = IP_CONST_SAVEVS_POSITIVE; break;
                    case 14: nSaveType = IP_CONST_SAVEVS_SONIC; break;
                }
                iProp = ItemPropertyReducedSavingThrowVsX(nSaveType, d20());
            }
            break;
        }

        IPSafeAddItemProperty(oItem, iProp, 0.0f, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, TRUE, TRUE);
        nIndex --;
    }
}

// Sets the appropriate INVENTORY_SLOT based upon what type of item was unequipped
int ci_GetInventorySlotFromItem(object oItem)
{
    int nBaseItemType = GetBaseItemType(oItem);
    int nSlot;

    switch (nBaseItemType)
    {
        case BASE_ITEM_BRACER               :
        case BASE_ITEM_GLOVES               : nSlot = INVENTORY_SLOT_ARMS; break;

        case BASE_ITEM_ARROW                : nSlot = INVENTORY_SLOT_ARROWS; break;

        case BASE_ITEM_BELT                 : nSlot = INVENTORY_SLOT_BELT; break;

        case BASE_ITEM_BOLT                 : nSlot = INVENTORY_SLOT_BOLTS; break;

        case BASE_ITEM_BOOTS                : nSlot = INVENTORY_SLOT_BOOTS; break;

        case BASE_ITEM_BULLET               : nSlot = INVENTORY_SLOT_BULLETS; break;

        case BASE_ITEM_ARMOR                : nSlot = INVENTORY_SLOT_CHEST; break;

        case BASE_ITEM_CLOAK                : nSlot = INVENTORY_SLOT_CLOAK; break;

        case BASE_ITEM_HELMET               : nSlot = INVENTORY_SLOT_HEAD; break;

        case BASE_ITEM_LARGESHIELD          :
        case BASE_ITEM_SMALLSHIELD          :
        case BASE_ITEM_TOWERSHIELD          :
        case BASE_ITEM_TORCH                : nSlot = INVENTORY_SLOT_LEFTHAND; break;

        case BASE_ITEM_BASTARDSWORD         :
        case BASE_ITEM_BATTLEAXE            :
        case BASE_ITEM_CLUB                 :
        case BASE_ITEM_DAGGER               :
        case BASE_ITEM_DART                 :
        case BASE_ITEM_DIREMACE             :
        case BASE_ITEM_DOUBLEAXE            :
        case BASE_ITEM_DWARVENWARAXE        :
        case BASE_ITEM_GREATAXE             :
        case BASE_ITEM_GREATSWORD           :
        case BASE_ITEM_HALBERD              :
        case BASE_ITEM_HANDAXE              :
        case BASE_ITEM_HEAVYCROSSBOW        :
        case BASE_ITEM_HEAVYFLAIL           :
        case BASE_ITEM_KAMA                 :
        case BASE_ITEM_KATANA               :
        case BASE_ITEM_KUKRI                :
        case BASE_ITEM_LIGHTCROSSBOW        :
        case BASE_ITEM_LIGHTFLAIL           :
        case BASE_ITEM_LIGHTHAMMER          :
        case BASE_ITEM_LIGHTMACE            :
        case BASE_ITEM_LONGBOW              :
        case BASE_ITEM_LONGSWORD            :
        case BASE_ITEM_MAGICROD             :
        case BASE_ITEM_MAGICSTAFF           :
        case BASE_ITEM_MAGICWAND            :
        case BASE_ITEM_MORNINGSTAR          :
        case BASE_ITEM_QUARTERSTAFF         :
        case BASE_ITEM_RAPIER               :
        case BASE_ITEM_SCIMITAR             :
        case BASE_ITEM_SCYTHE               :
        case BASE_ITEM_SHORTBOW             :
        case BASE_ITEM_SHORTSPEAR           :
        case BASE_ITEM_SHORTSWORD           :
        case BASE_ITEM_SICKLE               :
        case BASE_ITEM_SLING                :
        case BASE_ITEM_THROWINGAXE          :
        case BASE_ITEM_TRIDENT              :
        case BASE_ITEM_TWOBLADEDSWORD       :
        case BASE_ITEM_WARHAMMER            :
        case BASE_ITEM_WHIP                 : nSlot = INVENTORY_SLOT_RIGHTHAND; break;

        case BASE_ITEM_RING                 : nSlot = INVENTORY_SLOT_RIGHTRING; break;

        case BASE_ITEM_AMULET               : nSlot = INVENTORY_SLOT_NECK; break;
    }
    return nSlot;
}
