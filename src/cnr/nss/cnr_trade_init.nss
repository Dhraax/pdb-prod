/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_trade_init
//
//  Desc:  Tradeskill recipe initialization. This script
//         is executed from "cnr_recipe_init".
//
//  Author: David Bobeck 25Jan03
//  modified by: Dhraax
//
/////////////////////////////////////////////////////////
#include "cnr_recipe_utils"

void main()
{
  PrintString("cnr_trade_init");

    // Shared cumulative XP curve. The 2026-09-18 curve, one fifth of the
    // original thresholds, reached mastery at 5000 XP; on 2026-09-23 every
    // threshold was raised by 30%, rounded half up, to 6500 XP.
    // Must match TRADESKILL_LEVEL_THRESHOLDS in cnr-editor/backend/app/tradeskills.py.
    object oModule = GetModule();
    SetLocalInt(oModule, "CnrTradeXPLevel1", 0);
    SetLocalInt(oModule, "CnrTradeXPLevel2", 33);
    SetLocalInt(oModule, "CnrTradeXPLevel3", 65);
    SetLocalInt(oModule, "CnrTradeXPLevel4", 130);
    SetLocalInt(oModule, "CnrTradeXPLevel5", 228);
    SetLocalInt(oModule, "CnrTradeXPLevel6", 358);
    SetLocalInt(oModule, "CnrTradeXPLevel7", 520);
    SetLocalInt(oModule, "CnrTradeXPLevel8", 715);
    SetLocalInt(oModule, "CnrTradeXPLevel9", 943);
    SetLocalInt(oModule, "CnrTradeXPLevel10", 1203);
    SetLocalInt(oModule, "CnrTradeXPLevel11", 1495);
    SetLocalInt(oModule, "CnrTradeXPLevel12", 1820);
    SetLocalInt(oModule, "CnrTradeXPLevel13", 2178);
    SetLocalInt(oModule, "CnrTradeXPLevel14", 2568);
    SetLocalInt(oModule, "CnrTradeXPLevel15", 3114);
    SetLocalInt(oModule, "CnrTradeXPLevel16", 3705);
    SetLocalInt(oModule, "CnrTradeXPLevel17", 4342);
    SetLocalInt(oModule, "CnrTradeXPLevel18", 5018);
    SetLocalInt(oModule, "CnrTradeXPLevel19", 5720);
    SetLocalInt(oModule, "CnrTradeXPLevel20", 6500);

  // CnrAddTradeskill(CNR_TRADESKILL_SMELTING, "Smelting");
  // CnrAddTradeskill(CNR_TRADESKILL_WEAPON_CRAFTING, "Weapon Crafting");
  // CnrAddTradeskill(CNR_TRADESKILL_ARMOR_CRAFTING, "Armor Crafting");
  // CnrAddTradeskill(CNR_TRADESKILL_ALCHEMY, "Alchemy");
  // CnrAddTradeskill(CNR_TRADESKILL_SCRIBING, "Scribing");
  // CnrAddTradeskill(CNR_TRADESKILL_TINKERING, "Tinkering");
  // CnrAddTradeskill(CNR_TRADESKILL_WOOD_CRAFTING, "Wood Crafting"); // includes BOWERING, FLETCHING, CARPENTRY
  // CnrAddTradeskill(CNR_TRADESKILL_ENCHANTING, "Enchanting");   // includes IMBUING
  // CnrAddTradeskill(CNR_TRADESKILL_GEM_CRAFTING, "Gem Crafting");
  // CnrAddTradeskill(CNR_TRADESKILL_TAILORING, "Tailoring");
  // CnrAddTradeskill(CNR_TRADESKILL_FOOD_CRAFTING, "Food Crafting");

  CnrAddTradeskill(CNR_TRADESKILL_SMITHING, "Herreria");
  CnrAddTradeskill(CNR_TRADESKILL_CARPENTRY, "Carpinteria");
  CnrAddTradeskill(CNR_TRADESKILL_TAILORING, "Peleteria");
  CnrAddTradeskill(CNR_TRADESKILL_ALCHEMY, "Alquimia");
  CnrAddTradeskill(CNR_TRADESKILL_JEWELRY, "Joyeria");
  CnrAddTradeskill(CNR_TRADESKILL_ARCANE, "Arcano");
  CnrAddTradeskill(CNR_TRADESKILL_SEWING, "Sastreria");

  // Module builders: You should add your trade skills to the
  // file "user_trade_init" so that future versions of
  // CNR don't over-write your work.

}
