//::///////////////////////////////////////////////
//:: Module OnPlayerEquip hook script
//:: q_equiphook.nss
//:://////////////////////////////////////////////
/*
    Culled from NwnE

    Called from: q_mod_def_equ.nss

    Strips a "cursed" item of all properties then assigns new "negative"
    properties.

    Alternatively, the Builder can create template cursed items
    with the tag GetTag(oItem)+"_CURSED" and place them within
    a special container with the tag "CURSE_MAKER"

    When the PC equips an item which has a corresponding tag
    within the CURSE_MAKER container, the properties from the
    template are copied over to the equipped item.

*/
//:://////////////////////////////////////////////
//:: Created By: Pstemarie
//:: Created On: July 17, 2012
//:://////////////////////////////////////////////

#include "q_inc_curseprops"

void main()
{
    object oItem = OBJECT_SELF;
    object oCurseMaker = GetObjectByTag("CURSE_MAKER");
    object oTemplate = GetItemPossessedBy(oCurseMaker,GetTag(oItem)+"_CURSED");

    if(oTemplate != OBJECT_INVALID)
    {
        itemproperty ip = GetFirstItemProperty(oItem);
        while(GetIsItemPropertyValid(ip))
        {
            RemoveItemProperty(oItem,ip);
            ip = GetNextItemProperty(oItem);
        }
        ip = GetFirstItemProperty(oTemplate);
        while(GetIsItemPropertyValid(ip))
        {
            AddItemProperty(DURATION_TYPE_PERMANENT,ip,oItem);
            ip = GetNextItemProperty(oTemplate);
        }
        return;
    }

    int nBaseItemType = GetBaseItemType(oItem);

    switch (nBaseItemType)
    {
        //Armor, shields, helmets, miscellaneous
        case BASE_ITEM_ARMOR:
        case BASE_ITEM_HELMET:
        case BASE_ITEM_LARGESHIELD:
        case BASE_ITEM_SMALLSHIELD:
        case BASE_ITEM_TOWERSHIELD:
        case BASE_ITEM_AMULET:
        case BASE_ITEM_BELT:
        case BASE_ITEM_BOOTS:
        case BASE_ITEM_BRACER:
        case BASE_ITEM_CLOAK:
        case BASE_ITEM_RING:

            ci_AddArmorShieldHelmMiscProps(oItem);

        break;

        //Melee weapons, thrown weapons, gloves
        case BASE_ITEM_BASTARDSWORD:
        case BASE_ITEM_BATTLEAXE:
        case BASE_ITEM_CLUB:
        case BASE_ITEM_DAGGER:
        case BASE_ITEM_DIREMACE:
        case BASE_ITEM_DOUBLEAXE:
        case BASE_ITEM_DWARVENWARAXE:
        case BASE_ITEM_GREATAXE:
        case BASE_ITEM_GREATSWORD:
        case BASE_ITEM_HALBERD:
        case BASE_ITEM_HANDAXE:
        case BASE_ITEM_HEAVYFLAIL:
        case BASE_ITEM_KAMA:
        case BASE_ITEM_KATANA:
        case BASE_ITEM_KUKRI:
        case BASE_ITEM_LIGHTFLAIL:
        case BASE_ITEM_LIGHTHAMMER:
        case BASE_ITEM_LIGHTMACE:
        case BASE_ITEM_LONGSWORD:
        case BASE_ITEM_MORNINGSTAR:
        case BASE_ITEM_QUARTERSTAFF:
        case BASE_ITEM_RAPIER:
        case BASE_ITEM_SCIMITAR:
        case BASE_ITEM_SHORTSPEAR:
        case BASE_ITEM_SHORTSWORD:
        case BASE_ITEM_SICKLE:
        case BASE_ITEM_TRIDENT:
        case BASE_ITEM_TWOBLADEDSWORD:
        case BASE_ITEM_WARHAMMER:
        case BASE_ITEM_WHIP:
        case BASE_ITEM_DART:
        case BASE_ITEM_SHURIKEN:
        case BASE_ITEM_THROWINGAXE:
        case BASE_ITEM_GLOVES:

            ci_AddMeleeThrownGloveProps(oItem);

        break;

        //Ranged weapons
        case BASE_ITEM_HEAVYCROSSBOW:
        case BASE_ITEM_LIGHTCROSSBOW:
        case BASE_ITEM_LONGBOW:
        case BASE_ITEM_SHORTBOW:
        case BASE_ITEM_SLING:

            ci_AddRangedProps(oItem);

        break;

        //Ammunition
        case BASE_ITEM_ARROW:
        case BASE_ITEM_BOLT:
        case BASE_ITEM_BULLET:

            ci_AddAmmoProps(oItem);

        break;

        /*Note: Rods, staves, and wands are handled in the spellhook script*/
    }
}
