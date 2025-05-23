//::///////////////////////////////////////////////
//:: Name: Q Shield Crafting Function Library
//:: FileName: q_inc_itemprop
//:: Website: http://www.qnwn.net
//:: Contact: projectq@qnwn.net
//:://////////////////////////////////////////////
/*
    Project Q - Release 1.5

    Based on x2_inc_itemprops by BioWare
*/
//:://////////////////////////////////////////////
//:: Created By: pstemarie
//:: Created On: 21 Dec 2011
//:://////////////////////////////////////////////

#include "x2_inc_craft"

//------------------------------------------------------------------------------
// FUNCTION DECLARATIONS
//------------------------------------------------------------------------------

// * Determines the base armor type of object oItem, using oItem's base gold piece value.
// * Returns: -1 OBJECT_INVALID
// *           0 None
// *           1 Padded
// *           2 Leather
// *           3 Studded Leather / Hide
// *           4 Chain Shirt / Scale Mail
// *           5 Chainmail / Breast Plate
// *           6 Splint Mail / Banded Mail
// *           7 Half-Plate
// *           8 Full Plate
int Q_IPGetArmorType(object oItem);

// * Checks if object oItem is magical. Ignores the following itemproperties:
// * ITEM_PROPERTY_HEALERS_KIT
// * ITEM_PROPERTY_MATERIAL
// * ITEM_PROPERTY_POISON
// * ITEM_PROPERTY_QUALITY
// * ITEM_PROPERTY_SPECIAL_WALK
// * ITEM_PROPERTY_TRAP
// * ITEM_PROPERTY_THIEVES_TOOLS
// * ITEM_PROPERTY_USE_LIMITATION_ALIGNMENT_GROUP
// * ITEM_PROPERTY_USE_LIMITATION_CLASS
// * ITEM_PROPERTY_USE_LIMITATION_RACIAL_TYPE
// * ITEM_PROPERTY_USE_LIMITATION_SPECIFIC_ALIGNMENT
// * ITEM_PROPERTY_USE_LIMITATION_TILESET
// * ITEM_PROPERTY_VISUALEFFECT
// * ITEM_PROPERTY_USE_LIMITATION_GENDER
int Q_IPGetIsMagicItem(object oItem);

// Get the Level Requirement of oItem based upon its GP Value (using the values
// from itemvalue.2da).
// Returns -1 if oItem is not a valid item.
int Q_IPGetItemLevel(object oItem);

//------------------------------------------------------------------------------
// FUNCTION IMPLEMENTATION
//------------------------------------------------------------------------------

//::///////////////////////////////////////////////
//:: GetArmorType
//:: Copyright (c) 2004 NWN Lexicon Group
//:://////////////////////////////////////////////
/*
    Returns the base armor type as a number, of oItem
    -1 if invalid, or not armor, or just plain not found.
    0 to 8 as the value of AC got from the armor - 0 for none, 8 for Full plate.
*/
//:://////////////////////////////////////////////
//:: Created By: Jason Harris, Jasperre, Kristian Markon
//:: Created On:
//:://////////////////////////////////////////////
int Q_IPGetArmorType(object oItem)
{
    // Make sure the item is valid and is an armor.
    if (!GetIsObjectValid(oItem))
        return -1;
    if (GetBaseItemType(oItem) != BASE_ITEM_ARMOR)
        return -1;

    // Get the identified flag for safe keeping.
    int bIdentified = GetIdentified(oItem);
    SetIdentified(oItem,FALSE);

    int nType = -1;
    switch (GetGoldPieceValue(oItem))
    {
        case    1: nType = 0; break; // None
        case    5: nType = 1; break; // Padded
        case   10: nType = 2; break; // Leather
        case   15: nType = 3; break; // Studded Leather / Hide
        case  100: nType = 4; break; // Chain Shirt / Scale Mail
        case  150: nType = 5; break; // Chainmail / Breastplate
        case  200: nType = 6; break; // Splint Mail / Banded Mail
        case  600: nType = 7; break; // Half-Plate
        case 1500: nType = 8; break; // Full Plate
    }
    // Restore the identified flag, and return armor type.
    SetIdentified(oItem,bIdentified);
    return nType;
}

int Q_IPGetIsMagicItem(object oItem)
{
    itemproperty iProp = GetFirstItemProperty(oItem);

    while (GetIsItemPropertyValid(iProp))
    {
	    int nType = GetItemPropertyType(iProp);
        if (nType  == ITEM_PROPERTY_HEALERS_KIT ||
	    nType  == ITEM_PROPERTY_MATERIAL ||
	    nType  == ITEM_PROPERTY_POISON ||
	    nType  == ITEM_PROPERTY_QUALITY ||
	    nType  == ITEM_PROPERTY_SPECIAL_WALK ||
	    nType  == ITEM_PROPERTY_TRAP ||
	    nType  == ITEM_PROPERTY_THIEVES_TOOLS ||
	    nType  == ITEM_PROPERTY_USE_LIMITATION_ALIGNMENT_GROUP ||
	    nType  == ITEM_PROPERTY_USE_LIMITATION_CLASS ||
	    nType  == ITEM_PROPERTY_USE_LIMITATION_RACIAL_TYPE ||
	    nType  == ITEM_PROPERTY_USE_LIMITATION_SPECIFIC_ALIGNMENT ||
	    nType  == ITEM_PROPERTY_USE_LIMITATION_TILESET ||
	    nType  == 88 /*ITEM_PROPERTY_USE_LIMITATION_GENDER*/ ||
	    nType  == ITEM_PROPERTY_VISUALEFFECT )
	{
		// do nothing
	} else {
		// Found one not of the above exceptions - assume magical
		return TRUE;
	}
	
        iProp = GetNextItemProperty(oItem);
    }
    return FALSE;
}

int Q_IPGetItemLevel(object oItem)
{
    if (GetBaseItemType(oItem) == BASE_ITEM_INVALID)
        return -1;

    int nItemVal = GetGoldPieceValue(oItem);
    int nItemLvl;

    if (nItemVal <= 1000) nItemLvl = 1;
    else if (nItemVal <= 1500)     nItemLvl = 2;
    else if (nItemVal <= 2500)     nItemLvl = 3;
    else if (nItemVal <= 3500)     nItemLvl = 4;
    else if (nItemVal <= 5000)     nItemLvl = 5;
    else if (nItemVal <= 6500)     nItemLvl = 6;
    else if (nItemVal <= 9000)     nItemLvl = 7;
    else if (nItemVal <= 12000)    nItemLvl = 8;
    else if (nItemVal <= 15000)    nItemLvl = 9;
    else if (nItemVal <= 19500)    nItemLvl = 10;
    else if (nItemVal <= 25000)    nItemLvl = 11;
    else if (nItemVal <= 30000)    nItemLvl = 12;
    else if (nItemVal <= 35000)    nItemLvl = 13;
    else if (nItemVal <= 40000)    nItemLvl = 14;
    else if (nItemVal <= 50000)    nItemLvl = 15;
    else if (nItemVal <= 65000)    nItemLvl = 16;
    else if (nItemVal <= 75000)    nItemLvl = 17;
    else if (nItemVal <= 90000)    nItemLvl = 18;
    else if (nItemVal <= 110000)   nItemLvl = 19;
    else if (nItemVal <= 130000)   nItemLvl = 20;
    else if (nItemVal <= 250000)   nItemLvl = 21;
    else if (nItemVal <= 500000)   nItemLvl = 22;
    else if (nItemVal <= 750000)   nItemLvl = 23;
    else if (nItemVal <= 1000000)  nItemLvl = 24;
    else nItemLvl = (20 + nItemVal / 200000);

    //Game is capped at lvl 60, so cap Required Level at 60
    if (nItemLvl > 60) nItemLvl = 60;

    return nItemLvl;
}

//------------------------------------------------------------------------------
// Crafting functions

int Q_IPGetShieldAppearanceColor(object oWeapon, int nPart, int nMode)
{
    string sMode;

    switch (nMode)
    {
        case        X2_IP_WEAPONTYPE_NEXT : sMode ="Next";
                    break;
        case        X2_IP_WEAPONTYPE_PREV : sMode ="Prev";
                    break;
    }

    int nCurrApp  = GetItemAppearance(oWeapon,ITEM_APPR_TYPE_WEAPON_COLOR,nPart);
    int nRet;

    int nMax =  8;// IPGetNumberOfArmorAppearances(nPart)-1; // index from 0 .. numparts -1
    int nMin =  1;

    // return a random valid armor type
    if (nMode == X2_IP_WEAPONTYPE_RANDOM)
    {
        return Random(nMax)+nMin;
    }

    else
    {
        if (nMode == X2_IP_WEAPONTYPE_NEXT)
        {
            // current appearance is max, return min
            if (nCurrApp == nMax)
            {
                return nMin;
            }
            // current appearance is min, return min +1
            else if (nCurrApp == nMin)
            {
                nRet = nMin +1;
                return nRet;
            }

            //SpeakString("next");
            // next
            nRet = nCurrApp +1;
            return nRet;
        }
        else // previous
        {
            // current appearance is max, return nMax-1
            if (nCurrApp == nMax)
            {
                nRet = nMax -1;
                return nRet;
            }
            // current appearance is min, return max
            else if (nCurrApp == nMin)
            {
                return nMax;
            }

            //SpeakString("prev");

            nRet = nCurrApp -1;
            return nRet;
        }
    }
}


int Q_IPGetShieldAppearanceType(object oWeapon, int nPart, int nMode)
{
    string sMode;

    switch (nMode)
    {
        case        X2_IP_WEAPONTYPE_NEXT : sMode ="Next";
                    break;
        case        X2_IP_WEAPONTYPE_PREV : sMode ="Prev";
                    break;
    }

    int nCurrApp  = GetItemAppearance(oWeapon,ITEM_APPR_TYPE_WEAPON_MODEL,nPart);
    int nRet;

    int nMax =  21;// IPGetNumberOfArmorAppearances(nPart)-1; // index from 0 .. numparts -1
    int nMin =  1;

    // return a random valid armor type
    if (nMode == X2_IP_WEAPONTYPE_RANDOM)
    {
        return Random(nMax)+nMin;
    }

    else
    {
        if (nMode == X2_IP_WEAPONTYPE_NEXT)
        {
            // current appearance is max, return min
            if (nCurrApp == nMax)
            {
                return nMin;
            }
            // current appearance is min, return min +1
            else if (nCurrApp == nMin)
            {
                nRet = nMin +1;
                return nRet;
            }

            //SpeakString("next");
            // next
            nRet = nCurrApp +1;

            if (nPart == ITEM_APPR_WEAPON_MODEL_BOTTOM)
            {
                if ((GetBaseItemType(oWeapon) == BASE_ITEM_LARGESHIELD) && (nRet >= 10 && nRet <= 20))
                    nRet = 20;

                else if ((GetBaseItemType(oWeapon) == BASE_ITEM_TOWERSHIELD) && (nRet >= 7 && nRet <= 20))
                    nRet = 20;
            }
            else if (nPart == ITEM_APPR_WEAPON_MODEL_MIDDLE)
            {
                if ((GetBaseItemType(oWeapon) == BASE_ITEM_LARGESHIELD) && (nRet >= 5 && nRet <= 20))
                    nRet = 20;

                else if ((GetBaseItemType(oWeapon) == BASE_ITEM_TOWERSHIELD) && (nRet >= 5 && nRet <= 20))
                    nRet = 20;
            }
            return nRet;
        }
        else // previous
        {
            // current appearance is max, return nMax-1
            if (nCurrApp == nMax)
            {
                nRet = nMax -1;
                return nRet;
            }
            // current appearance is min, return max
            else if (nCurrApp == nMin)
            {
                return nMax;
            }

            //SpeakString("prev");

            nRet = nCurrApp -1;

            if (nPart == ITEM_APPR_WEAPON_MODEL_BOTTOM)
            {
                if ((GetBaseItemType(oWeapon) == BASE_ITEM_LARGESHIELD) && (nRet <= 20 && nRet >= 10))
                    nRet = 9;
                else if ((GetBaseItemType(oWeapon) == BASE_ITEM_TOWERSHIELD) && (nRet <= 20 && nRet >= 7))
                    nRet = 6;
            }
            else if (nPart == ITEM_APPR_WEAPON_MODEL_MIDDLE)
            {
                if ((GetBaseItemType(oWeapon) == BASE_ITEM_LARGESHIELD || GetBaseItemType(oWeapon) == BASE_ITEM_TOWERSHIELD) && (nRet <= 20 && nRet >= 5))
                    nRet = 4;
            }
            return nRet;
        }
    }
}

// ----------------------------------------------------------------------------
// Returns a new armor based of oArmor with nPartModified
// nPart - ITEM_APPR_WEAPON_MODEL_* constant of the part to be changed
// nMode -
//          X2_IP_WEAPONTYPE_NEXT    - next valid appearance
//          X2_IP_WEAPONTYPE_PREV    - previous valid apperance;
//          X2_IP_WEAPONTYPE_RANDOM  - random valid appearance (torso is never changed);
// bDestroyOldOnSuccess - Destroy oArmor in process?
// Uses Get2DAstring, so do not use in loops
// ----------------------------------------------------------------------------
object Q_IPGetModifiedShield(object oWeapon, int nModify, int nPart, int nMode, int bDestroyOldOnSuccess)
{
    int nNewApp;
    if (nModify == ITEM_APPR_TYPE_WEAPON_MODEL)
    {
        nNewApp = Q_IPGetShieldAppearanceType(oWeapon, nPart,  nMode);
    }
    else
    {
        nNewApp = Q_IPGetShieldAppearanceColor(oWeapon, nPart,  nMode);
    }

    //SpeakString("old: " + IntToString(GetItemAppearance(oWeapon,nModify,nPart)));
    //SpeakString("new: " + IntToString(nNewApp));
    object oNew = CopyItemAndModify(oWeapon, nModify, nPart, nNewApp,TRUE);
    if (oNew != OBJECT_INVALID)
    {
        if( bDestroyOldOnSuccess )
        {
            DestroyObject(oWeapon);
        }
        return oNew;
    }
    // Safety fallback, return old weapon on failures
       return oWeapon;
}
