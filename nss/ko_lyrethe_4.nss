#include "mti_libreria"

void main()
{
object oPC = GetPCSpeaker();

SetCampaignInt("ko_lyrethe", "ko_quest", 3, oPC);

GiveGoldToCreature(GetPCSpeaker(), 10000);
GiveXPToCreature(GetPCSpeaker(), 2500);
AdjustAlignment(oPC, ALIGNMENT_EVIL, 10);

object oAnilloMatanecrario = GetItemPossessedBy(oPC, "anillomatanecrario");
if(GetIsObjectValid(oAnilloMatanecrario)) DestroyObject(oAnilloMatanecrario);
}
