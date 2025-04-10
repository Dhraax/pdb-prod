void main()
{
    object oPC = GetLastSpeaker();
    string oTag = GetTag(OBJECT_SELF);
    object oTarget = GetWaypointByTag("WP_" + oTag );   //WP_BosqueEldat
    int OroCaravana= GetLocalInt(OBJECT_SELF, "OroCaravana");
    location lTarget = GetLocation(oTarget);
    if(oPC == OBJECT_INVALID) oPC = GetLastUsedBy();  //Si es un ubicable debemos mirar el ultimo que lo uso, no el ultimo con el que hablo.
    if(GetGold(oPC)>=OroCaravana||OroCaravana==0){
        TakeGoldFromCreature(OroCaravana, oPC);
        DelayCommand(0.9, AssignCommand(oPC, ClearAllActions()));
        DelayCommand(1.0, AssignCommand(oPC, ActionJumpToLocation(lTarget)));
    }else{
        FloatingTextStringOnCreature("no tienes bastante dinero para esta caravana", oPC);
    }
}
