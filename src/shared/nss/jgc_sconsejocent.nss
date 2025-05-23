void main()
{
    object oPC=GetEnteringObject();
    object oTarget = GetWaypointByTag("WP_sConsejoCenti" );
    location lTarget = GetLocation(oTarget);
    if ( GetItemPossessedBy(oPC, "cuerno_centinelas") != OBJECT_INVALID ){
        FloatingTextStringOnCreature( "La cascada se abre dejandote pasar al interior del consejo", oPC, FALSE);
        DelayCommand(0.9, AssignCommand(oPC, ClearAllActions()));
        DelayCommand(1.0, AssignCommand(oPC, ActionJumpToLocation(lTarget)));
        }
    else  FloatingTextStringOnCreature( "La cascada te impide pasar", oPC, FALSE);
}
