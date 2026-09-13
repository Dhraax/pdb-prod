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

  // Mastery costs more than the middle of the trade, since 2026-08-20.
  // The gap for every level above 14 is 30% wider, so the total to reach
  // 20 goes from 21500 to 25000. Levels 1 to 14 are untouched: the entry
  // to a trade is where someone decides whether to keep at it.
  //
  // Measured before the change, for smithing, best available recipe each
  // level and successes only: 394 weapons to reach 20, or 600 crafts for
  // someone who also forges their own ingots. After: 445 and 676. The
  // material cost is untouched and is the longer half anyway - those 600
  // crafts eat about 1235 nuggets, some 62 drained veins.
  // Configure the XP required to achieve each tradeskill level
  object oModule = GetModule();
  SetLocalInt(oModule, "CnrTradeXPLevel1", 0);
  SetLocalInt(oModule, "CnrTradeXPLevel2", 125);
  SetLocalInt(oModule, "CnrTradeXPLevel3", 250);
  SetLocalInt(oModule, "CnrTradeXPLevel4", 500);
  SetLocalInt(oModule, "CnrTradeXPLevel5", 875);
  SetLocalInt(oModule, "CnrTradeXPLevel6", 1375);
  SetLocalInt(oModule, "CnrTradeXPLevel7", 2000);
  SetLocalInt(oModule, "CnrTradeXPLevel8", 2750);
  SetLocalInt(oModule, "CnrTradeXPLevel9", 3625);
  SetLocalInt(oModule, "CnrTradeXPLevel10", 4625);
  SetLocalInt(oModule, "CnrTradeXPLevel11", 5750);
  SetLocalInt(oModule, "CnrTradeXPLevel12", 7000);
  SetLocalInt(oModule, "CnrTradeXPLevel13", 8375);
  SetLocalInt(oModule, "CnrTradeXPLevel14", 9875);
  SetLocalInt(oModule, "CnrTradeXPLevel15", 11975);
  SetLocalInt(oModule, "CnrTradeXPLevel16", 14250);
  SetLocalInt(oModule, "CnrTradeXPLevel17", 16700);
  SetLocalInt(oModule, "CnrTradeXPLevel18", 19300);
  SetLocalInt(oModule, "CnrTradeXPLevel19", 22000);
  SetLocalInt(oModule, "CnrTradeXPLevel20", 25000);

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
