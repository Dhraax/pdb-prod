#include "nw_i0_tool"
void main()
{

    // Quitar algo de oro al jugador
    TakeGoldFromCreature(200, GetPCSpeaker(), TRUE);
    object oPC = GetPCSpeaker();
    object oTarget = GetWaypointByTag("Enbarque_Athkatla");
    object oPermiso = GetItemPossessedBy(oPC, "Permisonavalnocturno");
    if(GetIsObjectValid(oPermiso) == TRUE) DestroyObject(oPermiso);
    SetLocalInt(oPC, "HACIA_AGUJAS_VAMPIRO", 1);
    AssignCommand(oPC, JumpToObject(oTarget));
}

