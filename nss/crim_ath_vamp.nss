#include "nw_i0_tool"
void main()
{

    // Quitar algo de oro al jugador
    TakeGoldFromCreature(300, GetPCSpeaker(), TRUE);
    object oPC = GetPCSpeaker();
    object oTarget = GetWaypointByTag("cubierta_crimmor");
    object oPermiso = GetItemPossessedBy(oPC, "Permisonavalnocturno");
    if(GetIsObjectValid(oPermiso) == TRUE) DestroyObject(oPermiso);
    SetLocalInt(oPC, "HACIA_CRIMMOR_ATHKATLA_VAMP", 1);
    AssignCommand(oPC, JumpToObject(oTarget));
}


