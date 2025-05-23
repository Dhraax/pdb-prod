void main()
{

    // Quitar algo de oro al jugador
    TakeGoldFromCreature(300, GetPCSpeaker(), TRUE);
    object oPC = GetPCSpeaker();
    object oTarget = GetWaypointByTag("cubierta_crimmor");
    SetLocalInt(oPC, "HACIA_CRIMMOR_AGUJAS", 1);
    AssignCommand(oPC, JumpToObject(oTarget));
}


