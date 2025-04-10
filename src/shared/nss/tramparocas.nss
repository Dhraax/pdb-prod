void Derrumba(location lLoc)
{
    effect eDerr = EffectVisualEffect(353);
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eDerr, lLoc, 4.0);
}
void main()
{
    object oPJ = GetLastUsedBy();

    AssignCommand(OBJECT_SELF,ActionPlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE,0.2,2.0));

    if(!GetIsPC(oPJ))
        return;

    location lLoc = GetLocation(oPJ);
    int i, nRand;
    float x,y, fDelay;

    effect eTerr = EffectVisualEffect(VFX_FNF_SCREEN_SHAKE);

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eTerr, lLoc);
    DelayCommand(2.5, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eTerr, lLoc));
    DelayCommand(5.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eTerr, lLoc));

    AssignCommand(oPJ, PlaySound("as_an_rockfalgl1"));
    DelayCommand(1.5, AssignCommand(oPJ, PlaySound("as_an_rockfalgl2")));
    DelayCommand(3.0, AssignCommand(oPJ, PlaySound("as_an_rockfalgl1")));

    FloatingTextStringOnCreature("*Se desprenden montones de rocas que caen sobre ti y los que te rodean*", oPJ);

    for(i = 1; i <= 15; i++)
    {
        vector vPos = GetPosition(oPJ);
        x = IntToFloat(Random(20) - 10);
        y = IntToFloat(Random(20) - 10);
        vPos.z = 14.0;
        vPos.x += x;
        vPos.y += y;
        location lLoc = Location(GetArea(oPJ), vPos, 0.0);
        nRand = Random(6);
        fDelay = nRand * 1.0;
        //AssignCommand(oPC, ClearAllActions());
        DelayCommand(fDelay, Derrumba(lLoc));
    }

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 20.0, GetLocation(oPJ), TRUE, OBJECT_TYPE_CREATURE);
    effect eMal;

    while(GetIsObjectValid(oTarget))
    {
        if(ReflexSave(oTarget, 30, SAVING_THROW_TYPE_NONE) != 1)
        {
            eMal = EffectDamage(d12(10)+50, DAMAGE_TYPE_BLUDGEONING);
            DelayCommand(1.0,ApplyEffectToObject(DURATION_TYPE_INSTANT, eMal, oTarget));
        }
        else
        {
            eMal = EffectDamage(d12(5)+25, DAMAGE_TYPE_BLUDGEONING);
            DelayCommand(1.0,ApplyEffectToObject(DURATION_TYPE_INSTANT, eMal, oTarget));
        }
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, 8.0, GetLocation(oPJ), FALSE, OBJECT_TYPE_CREATURE);
    }
}
