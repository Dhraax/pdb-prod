void main()
{
    object oPC = GetPCSpeaker();
    string sDestino = GetLocalString (OBJECT_SELF, "DESTINOTRANSPORTE");
    object oTarget = GetWaypointByTag(sDestino);

    AssignCommand(oPC, JumpToObject(oTarget));
    FloatingTextStringOnCreature("*Se abren las puertas y cruzas*", oPC);
}

