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

    // Shared cumulative XP curve, selected on 2026-09-18.
    // One fifth of the original thresholds reaches mastery at 5000 XP,
    // approximately 20% fewer attempts than the 6250-XP testing reference.
    // Recipe XP awards, crafting DC and harvesting rules remain unchanged.
    object oModule = GetModule();
    SetLocalInt(oModule, "CnrTradeXPLevel1", 0);
    SetLocalInt(oModule, "CnrTradeXPLevel2", 25);
    SetLocalInt(oModule, "CnrTradeXPLevel3", 50);
    SetLocalInt(oModule, "CnrTradeXPLevel4", 100);
    SetLocalInt(oModule, "CnrTradeXPLevel5", 175);
    SetLocalInt(oModule, "CnrTradeXPLevel6", 275);
    SetLocalInt(oModule, "CnrTradeXPLevel7", 400);
    SetLocalInt(oModule, "CnrTradeXPLevel8", 550);
    SetLocalInt(oModule, "CnrTradeXPLevel9", 725);
    SetLocalInt(oModule, "CnrTradeXPLevel10", 925);
    SetLocalInt(oModule, "CnrTradeXPLevel11", 1150);
    SetLocalInt(oModule, "CnrTradeXPLevel12", 1400);
    SetLocalInt(oModule, "CnrTradeXPLevel13", 1675);
    SetLocalInt(oModule, "CnrTradeXPLevel14", 1975);
    SetLocalInt(oModule, "CnrTradeXPLevel15", 2395);
    SetLocalInt(oModule, "CnrTradeXPLevel16", 2850);
    SetLocalInt(oModule, "CnrTradeXPLevel17", 3340);
    SetLocalInt(oModule, "CnrTradeXPLevel18", 3860);
    SetLocalInt(oModule, "CnrTradeXPLevel19", 4400);
    SetLocalInt(oModule, "CnrTradeXPLevel20", 5000);

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
