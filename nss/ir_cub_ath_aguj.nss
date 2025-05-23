void main()
{

    // Quitar algo de oro al jugador
    TakeGoldFromCreature(100, GetPCSpeaker(), TRUE);
    object oPC = GetPCSpeaker();
    object oTarget = GetWaypointByTag("Enbarque_Athkatla");
    SetLocalInt(oPC, "HACIA_AGUJAS", 1);
    AssignCommand(oPC, JumpToObject(oTarget));
}
