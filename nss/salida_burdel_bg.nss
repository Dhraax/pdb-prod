void main()
{
    object oPC = GetPCSpeaker();
    object oTarget = GetWaypointByTag("salida_burdel_bg");
    AssignCommand(oPC, JumpToObject(oTarget));
    FloatingTextStringOnCreature("*Sales del burdel*", oPC);
}
