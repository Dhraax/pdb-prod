//::///////////////////////////////////////////////
//:: Nombre:      //    Desencadente - Derrumbamiento
//:: Para:        //    ESIRITH
//:: Creado Por:  //    Lagarto
//:://////////////////////////////////////////////
// Ñ ñ Ú É í Ó Á ¿ ¡ ú é í ó á
/*
    Sirve tambien para trampas.
*/
void Derrumba(location lLoc)
{
    effect eDerr = EffectVisualEffect(353);
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eDerr, lLoc, 4.0);
}

void main()
{
    object oPJ = GetEnteringObject();

    if(!GetIsPC(oPJ))
        return;

    if(GetLocalInt(OBJECT_SELF, "Fired") == 1)
        return;

    location lLoc = GetLocation(oPJ);
    int i, nRand;
    float x,y, fDelay;

    effect eTerr = EffectVisualEffect(VFX_FNF_SCREEN_SHAKE);

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eTerr, lLoc);
    DelayCommand(2.5, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eTerr, lLoc));
    DelayCommand(5.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eTerr, lLoc));

    //antispam
    SetLocalInt(OBJECT_SELF, "Fired", 1);
    DelayCommand(400.0, DeleteLocalInt(OBJECT_SELF, "Fired"));

    AssignCommand(oPJ, PlaySound("as_an_rockfalgl1"));
    DelayCommand(1.5, AssignCommand(oPJ, PlaySound("as_an_rockfalgl2")));
    DelayCommand(3.0, AssignCommand(oPJ, PlaySound("as_an_rockfalgl1")));

    FloatingTextStringOnCreature("*Se desprenden montones de rocas que caen sobre ti*", oPJ);

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
        if(ReflexSave(oPJ, 20, SAVING_THROW_TYPE_NONE) != 1)
        {
            eMal = EffectDamage(d6(1)+3, DAMAGE_TYPE_BLUDGEONING);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eMal, oPJ);
        }
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, 20.0, GetLocation(oPJ), TRUE, OBJECT_TYPE_CREATURE);
    }
}
