/////////////////////////////////////////////////////////
//
//  Craftable Natural Resources (CNR) by Festyx
//
//  Name:  cnr_at_m_top
//
//  Desc:  Changes to the merchant's hello menu page
//
//  Author: David Bobeck 23Dec02
//
/////////////////////////////////////////////////////////
#include "cnr_merch_utils"
void main()
{
  object oPC = GetPCSpeaker();
  SetLocalString(oPC, "sCnrMenuType", "TOP");
  //CnrMerchantUpdateCustomTokens(OBJECT_SELF);

  string sKeyToMenu = GetLocalString(oPC, "sCnrCurrentMenu");
  int nMenuPage = GetLocalInt(oPC, "nCnrMenuPage");
  CnrMerchantShowMenu(sKeyToMenu, nMenuPage);
}
