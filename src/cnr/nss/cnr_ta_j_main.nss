/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_ta_j_main
//
//  Desc:  Init's the journal's top level menu
//
//  Author: David Bobeck 04Mar03
//  modified by: Dhraax
//
/////////////////////////////////////////////////////////
#include "cnr_i_setting"

int StartingConditional()
{
  object oPC = GetPCSpeaker();
  SetLocalInt(oPC, "nCnrJournalOffset", 1);

  // init some things for the DM xp altering menus
  SetLocalInt(oPC, "bCnrDMAdjustingXP", FALSE);
  SetLocalInt(oPC, "nCnrXpMenuPage", 0);

  SetLocalInt(oPC, "bCnrTopTenVisible", FALSE);

  int nShowAboveLevel = CnrSetting_GetInt(
    oPC,
    CNR_SETTING_SHOW_ABOVE_LEVEL,
    FALSE
  );
  string sState = nShowAboveLevel ? "ACTIVADO" : "DESACTIVADO";
  SetCustomToken(22299, "Mostrar recetas superiores a tu nivel: " + sState);

  return TRUE;
}

