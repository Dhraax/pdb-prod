//::///////////////////////////////////////////////
//:: Nombre:      //    Desencadente - Derrumbamiento
//:: Para:        //    ESIRITH
//:: Creado Por:  //    Lagarto
//:://////////////////////////////////////////////
// Ñ ñ Ú É í Ó Á ¿ ¡ ú é í ó á
/*
    Sirve tambien para trampas.
*/
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

    effect eTerr = EffectVisualEffect(VFX_IMP_WALLSPIKE);

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eTerr, lLoc);
    DelayCommand(2.5, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eTerr, lLoc));
    DelayCommand(5.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eTerr, lLoc));
    FloatingTextStringOnCreature("*Al pisar la baldosa, numerosas estacas de metal amenazan con perforar tu piel*", oPJ);

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

    }
object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 20.0, GetLocation(oPJ), TRUE, OBJECT_TYPE_CREATURE);
    effect eMal;

    while(GetIsObjectValid(oTarget))
    {
        if(ReflexSave(oPJ, 25, SAVING_THROW_TYPE_NONE) != 1)
        {
            eMal = EffectDamage(d10(4), DAMAGE_TYPE_PIERCING);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eMal, oPJ);
        }
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, 20.0, GetLocation(oPJ), TRUE, OBJECT_TYPE_CREATURE);
    }
}


