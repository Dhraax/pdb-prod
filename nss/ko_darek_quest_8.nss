void main()
{
object oPC = GetPCSpeaker();

SetCampaignInt("ko_darek", "ko_quest_nashkel_1", 4 , oPC); //Apuntamos que entrega el amuleto

GiveGoldToCreature(GetPCSpeaker(), 4000);
GiveXPToCreature(GetPCSpeaker(), 1000);

object oAmuleto = GetItemPossessedBy(oPC, "AmuletodelosKensiddar"); //Quitamos amuleto
if(GetIsObjectValid(oAmuleto)) DestroyObject(oAmuleto);
}
