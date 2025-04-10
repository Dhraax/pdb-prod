void main()
{

    // Quitar algo de oro al jugador
    TakeGoldFromCreature(300, GetPCSpeaker(), TRUE);
    object oPC = GetPCSpeaker();
    object oTarget = GetWaypointByTag("enbarque_agujas");
    SetLocalInt(oPC, "HACIA_AGUJAS_CRIMMOR", 1);
    AssignCommand(oPC, JumpToObject(oTarget));
}

