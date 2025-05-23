#include "nw_i0_tool"
void main()
{

    // Quitar algo de oro al jugador
    TakeGoldFromCreature(500, GetPCSpeaker(), TRUE);
    object oPC = GetPCSpeaker();
    object oTarget = GetWaypointByTag("enbarque_agujas");
    object oPermiso = GetItemPossessedBy(oPC, "Permisonavalnocturno");
    if(GetIsObjectValid(oPermiso) == TRUE) DestroyObject(oPermiso);
    SetLocalInt(oPC, "HACIA_AGUJAS_CRIMMOR_VAMP", 1);
    AssignCommand(oPC, JumpToObject(oTarget));
}


