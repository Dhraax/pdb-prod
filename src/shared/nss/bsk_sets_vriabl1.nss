#include "nw_i0_tool"
void main()
{
  object oPC = GetPCSpeaker();

  SetCampaignInt("QUESTAMNAGUATORRE", "AVANCE", 4, oPC);

  object oBaston = GetItemPossessedBy(oPC, "bastndemadera");
  object oAnillo = GetItemPossessedBy(oPC, "anillodemaderaco");
  object oPlanta = GetItemPossessedBy(oPC, "florLuminosa");

  if(GetIsObjectValid(oBaston)) DestroyObject(oBaston);
  if(GetIsObjectValid(oAnillo)) DestroyObject(oAnillo);
  if(GetIsObjectValid(oPlanta)) DestroyObject(oPlanta);

  SetXP(oPC, GetXP(oPC) + 2500);
  CreateItemOnObject("bracersofk", oPC);
}
