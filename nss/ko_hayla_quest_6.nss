void main()
{
object oPC = GetPCSpeaker();

SetCampaignInt("ko_hayla_quest", "ko_quest_nashkel_3", 2, oPC); //Apuntamos que termina la quest

GiveGoldToCreature(GetPCSpeaker(), 6000);
GiveXPToCreature(GetPCSpeaker(), 1500);

object oDiarioBandido = GetItemPossessedBy(oPC, "ko_nash_diario_bandido");
object oDocumentoHaila = GetItemPossessedBy(oPC, "ko_nash_documento");
if(GetIsObjectValid(oDocumentoHaila)) DestroyObject(oDocumentoHaila);
if(GetIsObjectValid(oDiarioBandido)) DestroyObject(oDiarioBandido);
}

