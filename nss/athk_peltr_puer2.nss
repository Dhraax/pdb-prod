void main()
{
    object oPC = GetPCSpeaker();
    object oTarget = GetWaypointByTag("casa_peletrero");
    AssignCommand(oPC, JumpToObject(oTarget));
    // Eliminar objetos del inventario del jugador.
    object oItemToTake;
    oItemToTake = GetItemPossessedBy(GetPCSpeaker(), "Taladro");
    if(GetIsObjectValid(oItemToTake) != 0)
        DestroyObject(oItemToTake);
}
