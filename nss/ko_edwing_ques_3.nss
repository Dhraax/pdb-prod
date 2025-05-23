void main()
{
object oPC = GetPCSpeaker();

SetCampaignInt("ko_edwing_quest", "ko_quest_nashkel_4", 2, oPC); //Apuntamos que entrega documento
object oInformeEdwing = GetItemPossessedBy(oPC, "InformedeEdwingMatanecrarios");
if(GetIsObjectValid(oInformeEdwing)) DestroyObject(oInformeEdwing);
}

