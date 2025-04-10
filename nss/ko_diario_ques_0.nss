void main()
{
object oPC = GetPCSpeaker();

SetCampaignInt("ko_diario_bandido", "ko_quest_nashkel_diario", 1, oPC);

GiveGoldToCreature(GetPCSpeaker(), 3000);
GiveXPToCreature(GetPCSpeaker(), 750);

object oDiarioBandido = GetItemPossessedBy(oPC, "ko_nash_diario_bandido");
if(GetIsObjectValid(oDiarioBandido)) DestroyObject(oDiarioBandido);
}
