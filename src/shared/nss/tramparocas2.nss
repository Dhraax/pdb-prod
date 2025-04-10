void Derrumba(location lLoc)
{
    effect eDerr = EffectVisualEffect(353);
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eDerr, lLoc, 4.0);
}
void main()
{
    object oPJ = GetLastUsedBy();

    object oPuerta = GetNearestObjectByTag("puertaenano",OBJECT_SELF);
    AssignCommand(OBJECT_SELF,ActionOpenDoor(oPuerta));

    AssignCommand(OBJECT_SELF,ActionPlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE,0.2,2.0));


    if(!GetIsPC(oPJ))
        return;

    AssignCommand(oPJ, PlaySound("as_an_rockfalgl1"));
    DelayCommand(1.5, AssignCommand(oPJ, PlaySound("as_an_rockfalgl2")));


    FloatingTextStringOnCreature("*La puerta se abre...*", oPJ);
}
