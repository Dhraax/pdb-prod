void main()
{
object oPC = GetPCSpeaker();

SetCampaignInt("ko_documento_haila", "ko_quest_nashkel_documento", 1, oPC);

GiveGoldToCreature(GetPCSpeaker(), 3000);
GiveXPToCreature(GetPCSpeaker(), 750);

object oDocumentoHaila = GetItemPossessedBy(oPC, "ko_nash_documento");
if(GetIsObjectValid(oDocumentoHaila)) DestroyObject(oDocumentoHaila);
}
