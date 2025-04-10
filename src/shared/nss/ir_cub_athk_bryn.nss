void main()
{

    // Quitar algo de oro al jugador
    TakeGoldFromCreature(500, GetPCSpeaker(), TRUE);
    object oPC = GetPCSpeaker();
    object oTarget = GetWaypointByTag("Enbarque_Athkatla");
    SetLocalInt(oPC, "HACIA_ATHKATLA_BRYNNLEY", 1);
    AssignCommand(oPC, JumpToObject(oTarget));
}
