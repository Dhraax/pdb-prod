void main()
{
    object oPC = GetPCSpeaker();
    object oTarget = GetWaypointByTag("bg_p_mujer_salida");
    object oMod = GetModule();
    DeleteLocalInt(oMod, "ESTAR_CON_MUJER");
    AssignCommand(oPC, JumpToObject(oTarget));
    FloatingTextStringOnCreature("*Sales de la habitación*", oPC);
}
