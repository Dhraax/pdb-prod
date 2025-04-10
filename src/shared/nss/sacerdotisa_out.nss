void main()
{
object oSalida = GetWaypointByTag("sacerdo_out");
object oPC = GetPCSpeaker();
object oSacerdotisa = GetObjectByTag("SacerdotisaDrow_ilicito");
SetCampaignInt("QUESTILICITOS", "RESCATE", 1, oPC);
AssignCommand(oSacerdotisa, ActionMoveToObject(oSalida));
DestroyObject(oSacerdotisa);
}
