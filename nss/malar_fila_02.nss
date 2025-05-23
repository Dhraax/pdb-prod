void main()
{
object oPC = GetLastUsedBy();
//definimos los ubicados a borrar, entre comillas la etiqueta del objeto.
object oJaulaE = GetNearestObjectByTag("Jaula_malar_05");
object oJaulaF = GetNearestObjectByTag("Jaula_malar_06");
object oJaulaG = GetNearestObjectByTag("Jaula_malar_07");
object oJaulaH = GetNearestObjectByTag("Jaula_malar_08");
//quitamos la propiedad trama a los objetos,
//recordad que si esta estatico, el script no funcionara, es importante quitarselo.
SetPlotFlag(oJaulaE, FALSE);
SetPlotFlag(oJaulaF, FALSE);
SetPlotFlag(oJaulaG, FALSE);
SetPlotFlag(oJaulaH, FALSE);
//destruimos los objetos.
DestroyObject(oJaulaE, 1.0);
DestroyObject(oJaulaF, 1.0);
DestroyObject(oJaulaG, 1.0);
DestroyObject(oJaulaH, 1.0);
//los efectos especiales.
effect eVisual = EffectVisualEffect(VFX_FNF_DISPEL);
ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oJaulaE);
ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oJaulaF);
ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oJaulaG);
ApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oJaulaH);
}
