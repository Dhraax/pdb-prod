/*
    Decoracion Bolsa planar.
*/
void Derrumba(location lLoc)
{
    effect eDerr = EffectVisualEffect(353);
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eDerr, lLoc, 4.0);
}

void main()
{
    object oPJ = GetEnteringObject();

    if(!GetIsPC(oPJ)) return;
    if(GetLocalInt(OBJECT_SELF, "Fired") == 1) return;

    location lLoc = GetLocation(oPJ);
    int i, nRand;
    float x,y, fDelay;
    effect eTerr = EffectVisualEffect(VFX_FNF_SCREEN_SHAKE);

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eTerr, lLoc);
    DelayCommand(2.5, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eTerr, lLoc));
    DelayCommand(5.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eTerr, lLoc));

    //antispam
    SetLocalInt(OBJECT_SELF, "Fired", 1);
    DelayCommand(20.0, DeleteLocalInt(OBJECT_SELF, "Fired"));

    AssignCommand(oPJ, PlaySound("as_an_rockfalgl1"));
    DelayCommand(1.5, AssignCommand(oPJ, PlaySound("as_an_rockfalgl2")));
    DelayCommand(3.0, AssignCommand(oPJ, PlaySound("as_an_rockfalgl1")));

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
}
