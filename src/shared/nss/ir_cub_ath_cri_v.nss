void main()
{

    // Quitar algo de oro al jugador
    TakeGoldFromCreature(300, GetPCSpeaker(), TRUE);
    object oPC = GetPCSpeaker();
    object oTarget = GetWaypointByTag("Enbarque_Athkatla");
    object oPermiso = GetItemPossessedBy(oPC, "Permisonavalnocturno");
    if(GetIsObjectValid(oPermiso) == TRUE) DestroyObject(oPermiso);
    SetLocalInt(oPC, "HACIA_CRIMMOR_VAMPIRO", 1);
    AssignCommand(oPC, JumpToObject(oTarget));
}



