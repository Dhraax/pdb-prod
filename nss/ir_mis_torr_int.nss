void main()
{
    object oPC = GetLastUsedBy();
    object oTarget = GetWaypointByTag("mis_int_torre");
    string sMensaje = "*Subes las escaleras de la torre y te introduces en su interior... La oscuridad te envarga*";
    string sMensaje_2 = "*Te sientes desorientado y pierdes el norte de vista... Apareces en una sala, con el agua cubriéndote medio cuerpo...*";
    DelayCommand(1.0, FloatingTextStringOnCreature(sMensaje, oPC));
    DelayCommand(2.0, PlaySound("as_dr_stonmedop1"));
    DelayCommand(2.8, AssignCommand(oPC, JumpToObject(oTarget)));
    DelayCommand(5.8, PlaySound("as_dr_stonmedcl1"));
    DelayCommand(6.0, FloatingTextStringOnCreature(sMensaje_2, oPC));





}

