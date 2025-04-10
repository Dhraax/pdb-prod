void main()
{
object oPC = GetLastUsedBy();
int iNiveles = GetLevelByClass(CLASS_TYPE_DRUID,oPC);
object oMega = GetNearestObjectByTag("eeeee");

if(iNiveles == 0)
    {
    SendMessageToPC(oPC,"No ocurre nada.");
    return;
    }
else
    {
    SendMessageToPC(oPC,"El circulo druidico parece reaccionar...");
    effect eTemblor = EffectVisualEffect(VFX_FNF_SCREEN_SHAKE);
    DelayCommand(1.5,ApplyEffectToObject(DURATION_TYPE_INSTANT,eTemblor,OBJECT_SELF));
    if(iNiveles <= 9)
    {
    DelayCommand(2.5,SendMessageToPC(oPC,"...pero no libera su magia."));
    return;
    }
    if(iNiveles >= 10)
        {
        effect eNatura = EffectVisualEffect(VFX_FNF_NATURES_BALANCE);
        effect eRege = EffectRegenerate(10,5.0);
        effect eResto = EffectVisualEffect(VFX_DUR_PROT_BARKSKIN);
        DelayCommand(3.5,ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY,eNatura,GetLocation(oMega)));

object oCurados = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(oMega));

while(GetIsObjectValid(oCurados))
{
        DelayCommand(4.5,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eRege,oCurados,60.0));
        DelayCommand(4.5,SendMessageToPC(oCurados,"La fuerte energía natural del Nodo parece regenerar las heridas."));
        DelayCommand(4.5,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eResto,oCurados,60.0));
   oCurados = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(OBJECT_SELF));
}
        }
    }
}
