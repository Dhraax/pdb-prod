void main()
{
object oPC = GetPCSpeaker();

SetCampaignInt("ko_lyrethe", "ko_quest", 2, oPC);

GiveGoldToCreature(GetPCSpeaker(), 10000);
GiveXPToCreature(GetPCSpeaker(), 2500);

object oAnilloMatanecrario = GetItemPossessedBy(oPC, "anillomatanecrario");
if(GetIsObjectValid(oAnilloMatanecrario)) DestroyObject(oAnilloMatanecrario);
}
