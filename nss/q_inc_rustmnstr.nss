//::///////////////////////////////////////////////
//:: Project Q Rustmonster Library
//:: q_inc_rustmnstr.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Culled from NwnE

    Miscellaneous functions related to the rust monster
*/
//:://////////////////////////////////////////////
//:: Created By: Pstemarie
//:: Created On: 1/30/10
//:://////////////////////////////////////////////
#include "q_inc_combat"

//------------------------------------------------------------------------------
// FUNCTION DECLARATIONS
//------------------------------------------------------------------------------

// Return TRUE if oTarget carries a metal item in its inventory.
int rm_GetHasMetalItemInInventory(object oTarget);

// Returns TRUE if oTarget has a metal item equipped in any inventory slot.
int rm_GetHasMetalItemEquipped(object oTarget);

// Checks for exceptions to metal items.
int rm_CheckExceptions(object oItem);

// Returns TRUE if oItem is metal.
// Returns: 0 if not metal,
//          1 if partly metal, or
//          2 if mostly metal.
//
// Note: Performs an extra check on BASE_ITEM_ARMOR.
int rm_GetIsItemMetal(object oItem);


//------------------------------------------------------------------------------
// FUNCTION IMPLEMENTATION
//------------------------------------------------------------------------------

int rm_GetHasMetalItemInInventory(object oTarget)
{
    object oItem = GetFirstItemInInventory(oTarget);
    while (oItem != OBJECT_INVALID)
    {
        if (rm_GetIsItemMetal(oItem))
        {
            return TRUE;
            break;
        }
        oItem = GetNextItemInInventory(oTarget);
    }
    return FALSE;
}


int rm_GetHasMetalItemEquipped(object oTarget)
{
  int nSlot = 0;
  object oItem = GetItemInSlot(nSlot);
  while (nSlot <= 5)
  {
    if (rm_GetIsItemMetal(oItem))
    {
      return TRUE;
      break;
    }
    nSlot++;
    oItem = GetItemInSlot(nSlot);
  }
  return FALSE;
}


int rm_GetIsItemMetal(object oItem)
{
    int nReturnVal;
    int nType=GetBaseItemType(oItem);

    switch (nType)
    {
        //ReturnVal = 2 (Mostly Metal)
        case BASE_ITEM_BASTARDSWORD:
        case BASE_ITEM_BATTLEAXE:
        case BASE_ITEM_DAGGER:
        case BASE_ITEM_DART:
        case BASE_ITEM_DIREMACE:
        case BASE_ITEM_DOUBLEAXE:
        case BASE_ITEM_DWARVENWARAXE:
        case BASE_ITEM_GREATAXE:
        case BASE_ITEM_GREATSWORD:
        case BASE_ITEM_HALBERD:
        case BASE_ITEM_HANDAXE:
        case BASE_ITEM_HEAVYFLAIL:
        case BASE_ITEM_HELMET:
        case BASE_ITEM_KAMA:
        case BASE_ITEM_KATANA:
        case BASE_ITEM_KEY:
        case BASE_ITEM_KUKRI:
        case BASE_ITEM_LIGHTFLAIL:
        case BASE_ITEM_LIGHTHAMMER:
        case BASE_ITEM_LIGHTMACE:
        case BASE_ITEM_LONGSWORD:
        case BASE_ITEM_MORNINGSTAR:
        case BASE_ITEM_SCIMITAR:
        case BASE_ITEM_SCYTHE:
        case BASE_ITEM_SHORTSPEAR:
        case BASE_ITEM_SHORTSWORD:
        case BASE_ITEM_SHURIKEN:
        case BASE_ITEM_SICKLE:
        case BASE_ITEM_THIEVESTOOLS:
        case BASE_ITEM_THROWINGAXE:
        case BASE_ITEM_TOWERSHIELD:
        case BASE_ITEM_TRIDENT:
        case BASE_ITEM_TWOBLADEDSWORD:
        case BASE_ITEM_WARHAMMER:
        case 92: //BASE_ITEM_LANCE
        case 93: //BASE_ITEM_TRUMPET
        {
            //Handle Exceptions
            if (rm_CheckExceptions(oItem) == TRUE)
            {
                nReturnVal = 0;
            }
            else nReturnVal = 2;
        }
        break;

        //ReturnVal = 1 (Part Metal)
        case BASE_ITEM_ARROW:
        case BASE_ITEM_AMULET:
        case BASE_ITEM_BELT:
        case BASE_ITEM_BLANK_WAND:
        case BASE_ITEM_BOLT:
        case BASE_ITEM_BRACER:
        case BASE_ITEM_BULLET:
        case BASE_ITEM_CLUB:
        case BASE_ITEM_CRAFTMATERIALMED:
        case BASE_ITEM_CRAFTMATERIALSML:
        case BASE_ITEM_ENCHANTED_WAND:
        case BASE_ITEM_GEM:
        case BASE_ITEM_GLOVES:
        case BASE_ITEM_GOLD:
        case BASE_ITEM_HEAVYCROSSBOW:
        case BASE_ITEM_LARGESHIELD:
        case BASE_ITEM_LIGHTCROSSBOW:
        case BASE_ITEM_MAGICROD:
        case BASE_ITEM_MAGICSTAFF:
        case BASE_ITEM_MAGICWAND:
        case BASE_ITEM_QUARTERSTAFF:
        case BASE_ITEM_RING:
        case BASE_ITEM_SMALLSHIELD:
        case BASE_ITEM_TRAPKIT:
        case BASE_ITEM_WHIP:
        {
            //Handle Exceptions
            if (rm_CheckExceptions(oItem) == TRUE)
            {
                nReturnVal = 0;
            }
            else nReturnVal = 1;
        }
        break;

        //ReturnVal = 0 (No Metal)
        case BASE_ITEM_BLANK_POTION:
        case BASE_ITEM_BLANK_SCROLL:
        case BASE_ITEM_BOOK:
        case BASE_ITEM_BOOTS:
        case BASE_ITEM_CLOAK:
        case BASE_ITEM_ENCHANTED_POTION:
        case BASE_ITEM_ENCHANTED_SCROLL:
        case BASE_ITEM_GRENADE:
        case BASE_ITEM_HEALERSKIT:
        case BASE_ITEM_LARGEBOX:
        case BASE_ITEM_LONGBOW:
        case BASE_ITEM_MISCLARGE:
        case BASE_ITEM_MISCMEDIUM:
        case BASE_ITEM_MISCSMALL:
        case BASE_ITEM_MISCTALL:
        case BASE_ITEM_MISCTHIN:
        case BASE_ITEM_MISCWIDE:
        case BASE_ITEM_POTIONS:
        case BASE_ITEM_SCROLL:
        case BASE_ITEM_SHORTBOW:
        case BASE_ITEM_SLING:
        case BASE_ITEM_SPELLSCROLL:
        case BASE_ITEM_TORCH:
        case 94: //BASE_ITEM_MOON_STICK
        {
            nReturnVal = 0;
        }
        break;

        //Armor - Special Handling
        case BASE_ITEM_ARMOR:
        {
            int nAC = Q_IPGetArmorType(oItem);
            if (nAC >= 4) //Base AC 4+ = Metal Armors
            {
                if (rm_CheckExceptions(oItem) == TRUE)
                {
                    nReturnVal = 0;
                }
                else nReturnVal = 2; //Return mostly metal
            }
            else nReturnVal=0;
        }
        break;
    }
    return nReturnVal;
}


int rm_CheckExceptions(object oItem)
{
    string sResRef = GetResRef(oItem);

    if (GetLocalInt(oItem, "Q_RM_NOMETAL") == 1)
    {
        return TRUE;
    }
    else
    {
        if (sResRef == "x3_it_diamondsw" ||    //1.69 Diamond Greatsword
            sResRef == "x3_it_emeraldwh" ||    //1.69 Emerald Warhammmer
            sResRef == "x3_it_rubywh" ||       //1.69 Ruby Warhammer
            sResRef == "x3_it_diamondsw" ||    //1.69 Emerald Shield
            sResRef == "x3_it_rubysh" ||       //1.69 Ruby Shield
            sResRef == "nw_it_crewcl001" ||    //Ogre/Hill Giant Club
            sResRef == "nw_it_crewcl002" ||    //Ogre Chieftain Club
            sResRef == "nw_it_crewcl003" ||    //Ettin Club
            sResRef == "x2_iwoodshldl" ||      //Ironwood Large Shield
            sResRef == "x2_ironwshlds" ||      //Ironwood Small Shield
            sResRef == "x2_ironwshldt" )       //Ironwood Tower Shield
        {
            return TRUE;
        }
        return FALSE;
    }
}

