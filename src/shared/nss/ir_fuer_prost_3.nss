void main()
{
    object oPC = GetPCSpeaker();
    object oTarget = GetWaypointByTag("bg_p_mujyhomb_salida");
    object oMod= GetModule();
    DeleteLocalInt(oMod, "ESTAR_CON_AMBOS");
    AssignCommand(oPC, JumpToObject(oTarget));
    FloatingTextStringOnCreature("*Sales de la habitación*", oPC);
}
